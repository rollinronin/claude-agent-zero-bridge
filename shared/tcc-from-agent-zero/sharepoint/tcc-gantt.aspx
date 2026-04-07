<%@ Page language="C#" %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>TCC IS Portfolio — Timeline</title><style>
*,*::before,*::after{box-sizing:border-box;margin:0;padding:0}
:root{
  --mc:#0054A4;--mc-dark:#003F7E;--mc-deep:#002A55;--mc-light:#D6E8F7;--mc-pale:#EBF4FB;
  --ink:#0d1117;--ink-2:#2d3748;--ink-3:#64748b;
  --surface:#fff;--surface-2:#f4f7fb;--surface-3:#e8f0f9;
  --border:rgba(0,84,164,.09);--border-md:rgba(0,84,164,.16);
  --red:#cc2222;--amber:#c97000;--amber-bg:#fff8ec;--amber-ring:#f5c97a;
  --green:#157a3c;--purple:#6d28d9;
  --font:'Segoe UI',system-ui,-apple-system,sans-serif;--mono:'Cascadia Mono','Courier New',monospace;
  --radius:12px;--row-h:36px;--label-w:200px;
}
body{font-family:var(--font);background:var(--surface-2);color:var(--ink);-webkit-font-smoothing:antialiased;padding:16px}
.hdr{display:flex;align-items:center;justify-content:space-between;margin-bottom:12px}
.hdr-title{font-size:11px;font-weight:700;text-transform:uppercase;letter-spacing:.08em;color:var(--mc-deep)}
.state{text-align:center;padding:32px;font-size:12px;color:var(--ink-3)}
.spinner{display:inline-block;width:14px;height:14px;border:2px solid var(--mc-light);border-top-color:var(--mc);border-radius:50%;animation:spin .7s linear infinite;vertical-align:middle;margin-right:6px}
@keyframes spin{to{transform:rotate(360deg)}}
.legend{display:flex;gap:14px;flex-wrap:wrap;margin-bottom:12px}
.li{display:flex;align-items:center;gap:5px;font-size:11px;color:var(--ink-2)}
.ld{width:10px;height:10px;border-radius:50%;flex-shrink:0}
.chart-wrap{background:var(--surface);border:1px solid var(--border-md);border-radius:var(--radius);overflow:hidden;overflow-x:auto}
.gantt{min-width:calc(var(--label-w) + 580px)}
.month-hdr{display:flex;border-bottom:1px solid var(--border-md);background:var(--surface);position:sticky;top:0;z-index:10}
.month-spacer{width:var(--label-w);flex-shrink:0;border-right:1px solid var(--border-md)}
.month-cells{flex:1;display:flex}
.month-cell{flex:1;text-align:center;padding:7px 0;font-size:10px;font-weight:600;text-transform:uppercase;letter-spacing:.06em;color:var(--ink-3);border-right:1px solid var(--border)}
.month-cell:last-child{border-right:none}
.month-cell.cur{color:var(--mc);background:var(--mc-pale);font-weight:700}
.sec-row{display:flex;align-items:center;background:var(--surface-2);border-bottom:1px solid var(--border-md);border-top:1px solid var(--border-md);padding:6px 14px;gap:8px}
.sec-dot{width:8px;height:8px;border-radius:50%;flex-shrink:0}
.sec-name{font-size:11px;font-weight:700}
.sec-role{font-size:10px;color:var(--ink-3);margin-left:2px}
.task-row{display:flex;height:var(--row-h);border-bottom:1px solid var(--border);align-items:center;transition:background .1s}
.task-row:hover{background:var(--mc-pale)}.task-row:last-child{border-bottom:none}
.task-lbl{width:var(--label-w);flex-shrink:0;padding:0 12px;border-right:1px solid var(--border-md);display:flex;flex-direction:column;justify-content:center;gap:2px;height:100%}
.task-name{font-size:11px;font-weight:500;color:var(--ink);white-space:nowrap;overflow:hidden;text-overflow:ellipsis}
.task-id{font-family:var(--mono);font-size:9px;color:var(--ink-3)}
.task-chart{flex:1;height:100%;position:relative}
.m-line{position:absolute;top:0;bottom:0;width:1px;background:var(--border)}
.today-line{position:absolute;top:0;bottom:0;width:1.5px;background:var(--mc);opacity:.4;z-index:5}
.gate-overlay{position:absolute;top:0;bottom:0;background:rgba(109,40,217,.04);border-left:1.5px dashed rgba(109,40,217,.25);pointer-events:none;z-index:2}
.m-diamond{position:absolute;width:10px;height:10px;transform:rotate(45deg) translateY(-50%);top:50%;margin-top:-3px;border-radius:2px;z-index:4;cursor:default;transition:transform .15s}
.m-diamond:hover{transform:rotate(45deg) translateY(-50%) scale(1.5)}
.m-complete{background:var(--green)}.m-active{background:var(--mc)}.m-confirm{background:var(--amber)}
.m-atrisk{background:var(--red)}.m-future{background:#c0cfe4}.m-gate{background:var(--purple)}
.tt{display:none;position:fixed;background:var(--mc-deep);color:#fff;font-size:11px;font-family:var(--font);padding:9px 13px;border-radius:8px;max-width:280px;z-index:200;line-height:1.5;pointer-events:none;box-shadow:0 6px 24px rgba(0,0,0,.25)}
.tt.vis{display:block}
.tt-title{font-weight:600;margin-bottom:3px}
.tt-date{color:rgba(255,255,255,.55);font-family:var(--mono);font-size:10px}
.tt-note{margin-top:4px;color:rgba(255,255,255,.8)}
.warn{background:var(--amber-bg);border:1px solid var(--amber-ring);border-radius:8px;padding:7px 12px;font-size:10px;color:var(--amber);margin-bottom:12px;display:none}
</style>
</head>
<body>

<div class="hdr">
  <div style="display:flex;align-items:center;gap:10px">
    <svg width="22" height="22" viewBox="0 0 30 30" fill="none"><polygon points="15,2 28,26 2,26" fill="#0054A4"/><polygon points="15,8 23.5,22 6.5,22" fill="#fff" opacity=".2"/></svg>
    <span class="hdr-title">IS Portfolio — Milestone Timeline 2026</span>
  </div>
  <span style="font-family:var(--mono);font-size:10px;color:var(--ink-3);background:var(--surface-3);padding:3px 9px;border-radius:20px;border:1px solid var(--border-md)">Construction-dependent · NTP pending</span>
</div>

<div class="legend">
  <div class="li"><div class="ld" style="background:var(--green)"></div>Complete</div>
  <div class="li"><div class="ld" style="background:var(--amber)"></div>Needs confirmation</div>
  <div class="li"><div class="ld" style="background:var(--mc)"></div>Active</div>
  <div class="li"><div class="ld" style="background:var(--red)"></div>At-risk</div>
  <div class="li"><div class="ld" style="background:#c0cfe4"></div>Future</div>
  <div class="li"><div class="ld" style="background:var(--purple)"></div>Construction Gate</div>
  <div class="li"><div style="width:18px;height:1.5px;background:var(--mc);opacity:.5;border-radius:1px"></div>&nbsp;Today</div>
</div>

<div id="warn" class="warn"></div>
<div id="loading" class="state"><span class="spinner"></span>Loading milestones...</div>
<div id="chartWrap" class="chart-wrap" style="display:none"><div class="gantt" id="gantt"></div></div>
<div class="tt" id="tt"><div class="tt-title" id="tt-t"></div><div class="tt-date" id="tt-d"></div><div class="tt-note" id="tt-n"></div></div>

<script>
const SITE='https://metcmn.sharepoint.com/sites/TCCISPortfolioHub';
const H={'Accept':'application/json;odata=verbose'};
const MOS=[{l:'Jan',mo:0},{l:'Feb',mo:1},{l:'Mar',mo:2},{l:'Apr',mo:3},{l:'May',mo:4},{l:'Jun',mo:5},{l:'Jul',mo:6},{l:'Aug',mo:7},{l:'Sep',mo:8},{l:'Oct',mo:9},{l:'Nov',mo:10},{l:'Dec',mo:11}];
const TODAY=new Date(2026,2,26),START=new Date(2026,0,1),END=new Date(2026,11,31),SPAN=END-START+86400000;
function pct(d){return Math.max(0,Math.min(1,(new Date(d)-START)/SPAN))}
function moPct(mo){return(new Date(2026,mo,1)-START)/SPAN}
const todayPct=(TODAY-START)/SPAN;

const FALLBACK=[
  {proj:'TCC Expansion',role:'IS Lead',color:'#0054A4',ms:[
    {id:'M-01',name:'PC Procurement GO/NO-GO',date:'2026-01-31',cls:'m-complete',note:'Complete. GO decision. Gates PC lead time.'},
    {id:'M-02',name:'CJIS Scope Confirmed',date:'2026-02-07',cls:'m-complete',note:'Complete. MTPD ruling confirmed.'},
    {id:'M-03',name:'Room 1007 ready for equipment',date:'2026-03-09',cls:'m-confirm',note:'CONFIRM: Physical buildout done. CJIS criteria in progress.'},
    {id:'M-04',name:'EBC PC eval units ordered',date:'2026-03-27',cls:'m-confirm',note:'CONFIRM: 3 eval units ordered Mar 27.'},
    {id:'CG-NTP',name:'Construction NTP',date:'2026-04-15',cls:'m-gate',note:'Expected mid-late April (Rimstad). Unlocks IS final-space planning.'},
    {id:'M-05',name:'EBC Operational',date:'2026-04-30',cls:'m-active',note:'Working target. 7 stations Room 1007 + 1 existing EBC.'},
    {id:'M-06',name:'911 Funding Decision',date:'2026-06-30',cls:'m-future',note:'Scenario A or B. TCC Executive decision.'},
    {id:'M-07',name:'CJIS Audit Complete',date:'2026-07-31',cls:'m-future',note:'Depends on CJIS scope ruling.'},
    {id:'M-08',name:'Final Space Clean-Room Ready',date:'2026-10-31',cls:'m-future',note:'After construction (Sep). Gates final-space IS buildout.'},
    {id:'M-09',name:'Final Infrastructure Ready',date:'2026-11-30',cls:'m-future',note:'Network, voice, security in final space.'},
    {id:'M-10',name:'TCC Go-Live — 30 consoles',date:'2026-12-15',cls:'m-future',note:'All 30 consoles operational.'},
  ]},
  {proj:'NG911 Refresh',role:'IS Coordination',color:'#7c3aed',ms:[
    {id:'N-01',name:'RFP Workshop',date:'2026-05-01',cls:'m-active',note:'FE-led. IS: cloud-hosted managed service, zero IS 24/7 obligation.'},
    {id:'N-02',name:'RFP Issued',date:'2026-06-15',cls:'m-future',note:'FE leads. IS monitors managed service requirement language.'},
    {id:'N-03',name:'Vendor Selected',date:'2026-09-30',cls:'m-future',note:'New vendor must own 100% end-to-end support.'},
    {id:'N-04',name:'Contract Finalized',date:'2026-12-31',cls:'m-future',note:'LOA for carrier/vendor escalation must be in contract.'},
  ]},
  {proj:'VuWall',role:'IS Coordination',color:'#0d9488',ms:[
    {id:'V-01',name:'PO Issued',date:'2026-03-26',cls:'m-complete',note:'Non-refundable POC committed.'},
    {id:'V-02',name:'BCA Design Docs Submitted',date:'2026-05-15',cls:'m-active',note:'Paul Burke + Eric Brown (LASO). CJIS prerequisite.'},
    {id:'V-03',name:'BCA CJIS Approval',date:'2026-07-31',cls:'m-atrisk',note:'Jun/Jul target. IS Network Apr-May unavailable pushed BCA to Jun.'},
    {id:'V-04',name:'POC Go/No-Go',date:'2026-08-31',cls:'m-future',note:'Based on documented success criteria only.'},
    {id:'V-05',name:'Support Partner Selected',date:'2026-08-31',cls:'m-atrisk',note:'Bluum contract unresolved. Parallel paths: Bluum, SHI, co-op.'},
    {id:'V-06',name:'VuWall Deployment',date:'2026-11-30',cls:'m-future',note:'Pending POC success, CJIS approval, construction schedule.'},
  ]},
];

async function tryLive(){
  const r=await fetch(`${SITE}/_api/web/lists/getbytitle('IS Milestones')/items?$select=Title,Project,WBS_x0020_Number,Planned_x0020_End,RAG_x0020_Status,Notes&$filter=Task_x0020_Type eq 'Milestone'&$orderby=Planned_x0020_End asc&$top=100`,{headers:H,credentials:'include'});
  if(!r.ok) throw new Error(`HTTP ${r.status}`);
  const items=(await r.json()).d.results;
  if(!items.length) throw new Error('No milestones in list yet');
  // Group by project
  const groups={};
  items.forEach(i=>{
    const p=i.Project||'Unknown';
    if(!groups[p]) groups[p]=[];
    groups[p].push({
      id:i.WBS_x0020_Number||'?',
      name:i.Title,
      date:i.Planned_x0020_End?i.Planned_x0020_End.substring(0,10):'2026-12-31',
      cls:ragToCls(i.RAG_x0020_Status),
      note:i.Notes||''
    });
  });
  return Object.entries(groups).map(([proj,ms])=>({proj,role:'',color:projColor(proj),ms}));
}

function ragToCls(rag){
  if(!rag||rag==='Not Started') return 'm-future';
  if(rag==='Complete') return 'm-complete';
  if(rag==='In Progress'||rag==='Active') return 'm-active';
  if(rag==='Red') return 'm-atrisk';
  if(rag==='Amber') return 'm-confirm';
  return 'm-future';
}
function projColor(p){
  if(p.includes('Expansion')) return '#0054A4';
  if(p.includes('NG911')||p.includes('911')) return '#7c3aed';
  if(p.includes('VuWall')) return '#0d9488';
  return '#64748b';
}

function build(projects){
  const g=document.getElementById('gantt');
  // month header
  const mh=document.createElement('div');mh.className='month-hdr';
  const sp=document.createElement('div');sp.className='month-spacer';mh.appendChild(sp);
  const mc=document.createElement('div');mc.className='month-cells';
  MOS.forEach(m=>{const c=document.createElement('div');c.className='month-cell'+(m.mo===2?' cur':'');c.textContent=m.l;mc.appendChild(c);});
  mh.appendChild(mc);g.appendChild(mh);

  projects.forEach(proj=>{
    const sec=document.createElement('div');sec.className='sec-row';
    sec.innerHTML=`<div class="sec-dot" style="background:${proj.color}"></div><span class="sec-name" style="color:${proj.color}">${proj.proj}</span><span class="sec-role">${proj.role}</span>`;
    g.appendChild(sec);

    proj.ms.forEach(m=>{
      const row=document.createElement('div');row.className='task-row';
      const lbl=document.createElement('div');lbl.className='task-lbl';
      lbl.innerHTML=`<span class="task-name">${m.name}</span><span class="task-id">${m.id}</span>`;
      row.appendChild(lbl);
      const chart=document.createElement('div');chart.className='task-chart';
      // gridlines
      MOS.forEach((mo,i)=>{if(!i)return;const l=document.createElement('div');l.className='m-line';l.style.left=moPct(mo.mo)*100+'%';chart.appendChild(l);});
      // today
      const tl=document.createElement('div');tl.className='today-line';tl.style.left=todayPct*100+'%';chart.appendChild(tl);
      // gate overlay Sep+
      const go=document.createElement('div');go.className='gate-overlay';go.style.left=moPct(8)*100+'%';go.style.right='0';chart.appendChild(go);
      // diamond
      const d=document.createElement('div');d.className='m-diamond '+m.cls;d.style.left=`calc(${pct(m.date)*100}% - 5px)`;
      d.addEventListener('mouseenter',e=>{
        document.getElementById('tt-t').textContent=m.name;
        document.getElementById('tt-d').textContent=m.id+' · '+m.date;
        document.getElementById('tt-n').textContent=m.note;
        document.getElementById('tt').classList.add('vis');
      });
      d.addEventListener('mousemove',e=>{const t=document.getElementById('tt');t.style.left=(e.clientX+14)+'px';t.style.top=(e.clientY-10)+'px';});
      d.addEventListener('mouseleave',()=>document.getElementById('tt').classList.remove('vis'));
      chart.appendChild(d);row.appendChild(chart);g.appendChild(row);
    });
  });
}

async function init(){
  let projects=FALLBACK;
  let live=false;
  try{projects=await tryLive();live=true;}
  catch(e){
    const w=document.getElementById('warn');
    w.textContent='⚠ Milestones list empty or not yet imported — showing static data. Import IS Milestones from WBS Excel to enable live data.';
    w.style.display='block';
  }
  build(projects);
  document.getElementById('loading').style.display='none';
  document.getElementById('chartWrap').style.display='block';
}
init();
</script>
</body>
</html>
