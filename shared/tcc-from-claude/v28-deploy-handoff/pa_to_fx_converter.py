#!/usr/bin/env python3
"""
Convert AZ's pa.yaml list-form screen files to pac CLI fx.yaml source form.

Input format (AZ pa.yaml):
    Screens:
    - scrExecutive:
        Properties:
          Fill: =cBgPage
          OnVisible: |-
            Set(...)
        Children:
          - rcvtHdr:
              Control: Rectangle
              Properties:
                X: =0
                Y: =0
              Children: [...]

Output format (pac fx.yaml):
    scrExecutive As screen:
        Fill: =cBgPage
        OnVisible: |-
            Set(...)

        rcvtHdr As rectangle:
            X: =0
            Y: =0

Custom line parser because AZ's files contain Power Fx expressions with colons
(e.g., "Data: ") that trip strict YAML parsers.
"""
import sys
import re
import json
from pathlib import Path


CONTROL_TEMPLATE_MAP = {
    'Rectangle': 'rectangle',
    'Label': 'label',
    'Button': 'button',
    'Gallery': 'gallery',  # gallery uses variant qualifier
    'Icon': 'icon',
    'Image': 'image',
    'TextInput': 'text',
    'Dropdown': 'dropdown',
}


def count_leading_spaces(line):
    return len(line) - len(line.lstrip(' '))


class Control:
    def __init__(self, name):
        self.name = name
        self.control_type = None
        self.variant = None
        self.properties = []  # list of (key, value_str, is_multiline)
        self.children = []

    def __repr__(self):
        return f"Control({self.name}, type={self.control_type}, variant={self.variant}, props={len(self.properties)}, children={len(self.children)})"


def parse_pa_yaml(text):
    """Parse AZ's pa.yaml text into a list of Control objects (screens)."""
    lines = text.splitlines()
    screens = []
    i = 0
    # Skip until 'Screens:' header
    while i < len(lines) and not lines[i].strip().startswith('Screens:'):
        i += 1
    i += 1  # past 'Screens:'

    # Each screen: '- scrName:' at indent 0 (the '-' at col 0, name after)
    while i < len(lines):
        line = lines[i]
        stripped = line.strip()
        if not stripped or stripped.startswith('#'):
            i += 1
            continue
        # Screen start: '- <name>:'
        m = re.match(r'^-\s+(\w+):\s*$', line)
        if m:
            screen = Control(m.group(1))
            i += 1
            i = parse_control_body(lines, i, screen, base_indent=4)
            screens.append(screen)
        else:
            i += 1
    return screens


def parse_control_body(lines, i, control, base_indent):
    """
    Parse a control's body (Properties:, Children:, Control:, Variant:).
    Returns the next line index after this control.
    base_indent is the column of the control's OWN fields (e.g., Properties: at col 4
    for a screen).
    """
    while i < len(lines):
        line = lines[i]
        stripped = line.strip()
        if not stripped or stripped.startswith('#'):
            i += 1
            continue
        indent = count_leading_spaces(line)
        if indent < base_indent:
            # Popped out of this control
            return i
        if indent != base_indent:
            # Unexpected indent but keep going - either we're inside a multi-line or
            # there's an indent anomaly. Just advance.
            i += 1
            continue

        if stripped == 'Properties:':
            i += 1
            i = parse_properties(lines, i, control, base_indent + 2)
        elif stripped == 'Children:':
            i += 1
            i = parse_children(lines, i, control, base_indent + 2)
        elif stripped.startswith('Control:'):
            control.control_type = stripped.split(':', 1)[1].strip()
            i += 1
        elif stripped.startswith('Variant:'):
            control.variant = stripped.split(':', 1)[1].strip()
            i += 1
        else:
            # Unknown field; skip
            i += 1
    return i


def parse_properties(lines, i, control, base_indent):
    """
    Parse Property: value entries at base_indent. Supports multi-line |- blocks.
    Returns next line index.
    """
    while i < len(lines):
        line = lines[i]
        stripped = line.strip()
        if not stripped or stripped.startswith('#'):
            i += 1
            continue
        indent = count_leading_spaces(line)
        if indent < base_indent:
            return i
        if indent != base_indent:
            i += 1
            continue

        # Expect 'Key: value' — split on first ':'
        if ':' not in stripped:
            i += 1
            continue
        key, _, val = stripped.partition(':')
        key = key.strip()
        val = val.strip()

        if val == '|-' or val == '|':
            # Multi-line scalar — collect subsequent more-indented lines
            i += 1
            block_lines = []
            block_indent = None
            while i < len(lines):
                nl = lines[i]
                if not nl.strip():
                    block_lines.append('')
                    i += 1
                    continue
                nl_indent = count_leading_spaces(nl)
                if nl_indent <= base_indent:
                    break
                if block_indent is None:
                    block_indent = nl_indent
                block_lines.append(nl[block_indent:])
                i += 1
            # Strip trailing blank lines
            while block_lines and not block_lines[-1]:
                block_lines.pop()
            control.properties.append((key, '\n'.join(block_lines), True))
        else:
            # Check for implicit multi-line: next line(s) at DEEPER indent OR a line whose only
            # purpose is to close an open paren/bracket. Track paren balance to know when done.
            def paren_depth(s):
                depth = 0
                in_str = None
                esc = False
                for ch in s:
                    if esc:
                        esc = False
                        continue
                    if ch == '\\' and in_str:
                        esc = True
                        continue
                    if in_str:
                        if ch == in_str:
                            in_str = None
                        continue
                    if ch in '"\'':
                        in_str = ch
                        continue
                    if ch in '([':
                        depth += 1
                    elif ch in ')]':
                        depth -= 1
                return depth

            depth = paren_depth(val)
            i += 1
            extra_lines = []
            while i < len(lines):
                nl = lines[i]
                stripped_nl = nl.strip()
                if not stripped_nl:
                    # blank line — peek ahead
                    j = i + 1
                    while j < len(lines) and not lines[j].strip():
                        j += 1
                    if j < len(lines):
                        next_indent = count_leading_spaces(lines[j])
                        next_stripped = lines[j].strip()
                        if next_indent > base_indent or (depth > 0 and next_stripped and not re.match(r'^(Control|Variant|Properties|Children):', next_stripped) and not re.match(r'^-\s+\w+:', next_stripped)):
                            extra_lines.append('')
                            i += 1
                            continue
                    break
                nl_indent = count_leading_spaces(nl)
                # A continuation if: deeper indent, OR paren still unbalanced AND line isn't a new structural element
                is_structural = re.match(r'^(Control|Variant|Properties|Children):', stripped_nl) or re.match(r'^-\s+\w+:', stripped_nl)
                if nl_indent > base_indent:
                    extra_lines.append(stripped_nl)
                    depth += paren_depth(stripped_nl)
                    i += 1
                elif depth > 0 and not is_structural:
                    # Same-or-lesser indent, but parens still open — this is a closing line
                    extra_lines.append(stripped_nl)
                    depth += paren_depth(stripped_nl)
                    i += 1
                else:
                    break
            if extra_lines:
                combined = val + ' ' + ' '.join(extra_lines)
                control.properties.append((key, combined, False))
            else:
                control.properties.append((key, val, False))
    return i


def parse_children(lines, i, control, base_indent):
    """
    Parse list of children: '- <name>:' at base_indent, each with its own control body.
    Child body fields (Control:, Properties:, Children:) are at base_indent + 4.
    """
    while i < len(lines):
        line = lines[i]
        stripped = line.strip()
        if not stripped or stripped.startswith('#'):
            i += 1
            continue
        indent = count_leading_spaces(line)
        if indent < base_indent:
            return i
        if indent != base_indent:
            i += 1
            continue

        m = re.match(r'^-\s+(\w+):\s*$', stripped)
        if m:
            child = Control(m.group(1))
            i += 1
            # Child body fields are indented +4 from the '- name:' line
            i = parse_control_body(lines, i, child, base_indent + 4)
            control.children.append(child)
        else:
            i += 1
    return i


def render_fx_yaml(screen, indent=0):
    """Render a screen Control tree as fx.yaml text."""
    lines = []
    pad = ' ' * indent
    # Top-level screen: 'screenName As screen:'
    lines.append(f"{pad}{screen.name} As screen:")
    lines.extend(render_body(screen, indent + 4))
    return '\n'.join(lines) + '\n'


def render_body(control, indent):
    lines = []
    pad = ' ' * indent

    # Properties
    for key, val, is_multi in control.properties:
        if is_multi:
            lines.append(f"{pad}{key}: |-")
            # pac fx.yaml requires property values to start with '=' — prepend to first non-empty line
            block = val.split('\n')
            prefixed = False
            for vl in block:
                if not vl and not prefixed:
                    lines.append('')
                    continue
                if not prefixed:
                    lines.append(f"{pad}    ={vl}")
                    prefixed = True
                else:
                    lines.append(f"{pad}    {vl}" if vl else '')
        else:
            lines.append(f"{pad}{key}: {val}")

    # Children (nested controls) — no blank separator; matches reference output
    for child in control.children:
        lines.extend(render_control(child, indent))
    return lines


def render_control(control, indent):
    lines = []
    pad = ' ' * indent
    tpl = CONTROL_TEMPLATE_MAP.get(control.control_type, control.control_type.lower() if control.control_type else 'label')
    if control.control_type == 'Gallery':
        if control.variant:
            header = f'"{control.name} As gallery.\'{control.variant}\'"'
        else:
            header = f"{control.name} As gallery"
    else:
        header = f"{control.name} As {tpl}"
    lines.append(f"{pad}{header}:")
    lines.extend(render_body(control, indent + 4))
    return lines


def build_editor_state(screen):
    """Build a Src/EditorState/<screen>.editorstate.json dict.

    Produces minimal but complete metadata: each control gets ControlPropertyState
    = list of its set properties, plus Properties array of {Category, PropertyName,
    RuleProviderType}. Style guessed from control type.
    """
    states = {}

    # Property category defaults. Unknown properties default to "Design".
    CAT = {
        'Items': 'Data', 'OnSelect': 'Behavior', 'OnStart': 'Behavior',
        'OnVisible': 'Behavior', 'OnHidden': 'Behavior', 'OnChange': 'Behavior',
        'Text': 'Data', 'Visible': 'Design', 'Default': 'Data',
        'ConfirmExit': 'Data', 'BackEnabled': 'Data', 'SizeBreakpoints': 'ConstantData',
    }

    STYLE = {
        'screen': 'defaultScreenStyle',
        'rectangle': '',
        'label': '',
        'button': '',
        'gallery': 'defaultGalleryStyle',
    }

    def add_control(ctrl, is_screen=False):
        tpl = 'screen' if is_screen else CONTROL_TEMPLATE_MAP.get(ctrl.control_type, (ctrl.control_type or '').lower())
        prop_names = [key for key, _, _ in ctrl.properties]
        state = {
            'AllowAccessToGlobals': is_screen or tpl == 'gallery',
            'ControlPropertyState': prop_names,
            'HasDynamicProperties': False,
            'IsAutoGenerated': False,
            'IsComponentDefinition': False,
            'IsDataControl': tpl == 'gallery',
            'IsFromScreenLayout': False,
            'IsGroupControl': False,
            'IsLocked': False,
            'LayoutName': '',
            'MetaDataIDKey': '',
            'Name': ctrl.name,
            'OptimizeForDevices': 'Off',
            'ParentIndex': 0,
            'PersistMetaDataIDKey': False,
            'Properties': [
                {'Category': CAT.get(k, 'Design'), 'PropertyName': k, 'RuleProviderType': 'Unknown'}
                for k in prop_names
            ],
            'StyleName': STYLE.get(tpl, ''),
            'Type': 'ControlInfo',
        }
        if is_screen:
            # Screens don't have HasDynamicProperties in reference
            state.pop('HasDynamicProperties', None)
        states[ctrl.name] = state

    def walk(ctrl, is_screen=False):
        add_control(ctrl, is_screen=is_screen)
        for child in ctrl.children:
            walk(child)

    walk(screen, is_screen=True)
    return {
        'ControlStates': states,
        'TopParentName': screen.name,
    }


def main():
    if len(sys.argv) < 3:
        print("Usage: pa_to_fx_converter.py <input.pa.yaml> <output_dir>")
        sys.exit(1)
    src = Path(sys.argv[1])
    out_dir = Path(sys.argv[2])
    out_dir.mkdir(parents=True, exist_ok=True)

    text = src.read_text(encoding='utf-8')
    screens = parse_pa_yaml(text)

    editorstate_dir = out_dir / 'EditorState'
    editorstate_dir.mkdir(parents=True, exist_ok=True)

    for screen in screens:
        fx = render_fx_yaml(screen)
        fx_path = out_dir / f"{screen.name}.fx.yaml"
        fx_path.write_text(fx, encoding='utf-8')
        print(f"  wrote {fx_path}")

        state = build_editor_state(screen)
        st_path = editorstate_dir / f"{screen.name}.editorstate.json"
        st_path.write_text(json.dumps(state, indent=2), encoding='utf-8')
        print(f"  wrote {st_path}")

        # Summary
        def count(c):
            return 1 + sum(count(ch) for ch in c.children)
        total = count(screen)
        print(f"  {screen.name}: {len(screen.children)} top-level children, {total} total controls")


if __name__ == '__main__':
    main()
