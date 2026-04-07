<%@ Page language="C#" %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>TCC IS Portfolio Hub — Nav</title><style>
*,*::before,*::after{box-sizing:border-box;margin:0;padding:0}
:root{
  --mc:#0054A4;--mc-dark:#003F7E;--mc-deep:#002A55;--mc-mid:#1A6BBF;
  --mc-light:#D6E8F7;--mc-pale:#EBF4FB;
  --ink:#0d1117;--ink-3:#64748b;
  --surface:#fff;--surface-2:#f4f7fb;--surface-3:#e8f0f9;
  --border:rgba(0,84,164,.09);--border-md:rgba(0,84,164,.16);
  --red:#cc2222;--red-bg:#edf4fd;--red-ring:#93bde8;
  --amber:#c97000;--amber-bg:#fff8ec;--amber-ring:#f5c97a;
  --font:'Segoe UI',system-ui,-apple-system,sans-serif;--mono:'Cascadia Mono','Courier New',monospace;
}
html,body{height:100%;margin:0;overflow:hidden}
body{font-family:var(--font);background:var(--surface);color:var(--ink);-webkit-font-smoothing:antialiased}

.nav-shell{background:var(--surface);border-bottom:1px solid var(--border-md)}

/* top row */
.nav-top{display:flex;align-items:center;padding:0 20px;height:48px;border-bottom:1px solid var(--border);gap:0}
.nav-wordmark{display:flex;align-items:center;gap:9px;text-decoration:none;flex-shrink:0;margin-right:24px}
.nav-site-name{font-size:13px;font-weight:600;color:var(--mc-deep);letter-spacing:-.01em;line-height:1}
.nav-site-sub{font-size:9px;font-weight:500;color:var(--ink-3);letter-spacing:.04em;text-transform:uppercase}
.nav-items{display:flex;align-items:stretch;height:100%;flex:1}
.nav-item{display:flex;align-items:center;padding:0 14px;font-size:12px;font-weight:500;color:var(--ink-3);text-decoration:none;border-bottom:2.5px solid transparent;cursor:pointer;white-space:nowrap;transition:color .12s,border-color .12s}
.nav-item:hover{color:var(--mc)}
.nav-item.active{color:var(--mc);border-bottom-color:var(--mc);font-weight:600}
.nav-right{display:flex;align-items:center;gap:10px;margin-left:auto;flex-shrink:0}
.alert-badge{display:flex;align-items:center;gap:5px;background:var(--red-bg);border:1px solid var(--red-ring);color:var(--red);font-size:10px;font-weight:600;padding:3px 9px;border-radius:20px;cursor:pointer}
.alert-dot{width:6px;height:6px;border-radius:50%;background:var(--red);animation:pulse-r 2s ease-in-out infinite}
@keyframes pulse-r{0%,100%{opacity:1;transform:scale(1)}50%{opacity:.4;transform:scale(1.5)}}
.nav-date{font-family:var(--mono);font-size:10px;color:var(--ink-3);background:var(--surface-3);padding:3px 9px;border-radius:20px;border:1px solid var(--border-md)}

/* project chips row */
.nav-projects{display:flex;align-items:center;padding:0 20px;height:38px;gap:6px;overflow-x:auto}
.nav-projects::-webkit-scrollbar{display:none}
.proj-chip{display:flex;align-items:center;gap:6px;padding:4px 12px;border-radius:20px;font-size:11px;font-weight:500;color:var(--ink-3);border:1px solid var(--border-md);background:var(--surface);cursor:pointer;text-decoration:none;white-space:nowrap;transition:all .12s;flex-shrink:0}
.proj-chip:hover{background:var(--mc-pale);color:var(--mc);border-color:var(--mc-light)}
.proj-chip.exp.active{background:var(--mc-pale);border-color:var(--mc);color:var(--mc);font-weight:600}
.proj-chip.ng911.active{background:#f5f3ff;border-color:#7c3aed;color:#7c3aed;font-weight:600}
.proj-chip.vuw.active{background:#f0fdfa;border-color:#0d9488;color:#0d9488;font-weight:600}
.proj-rag{width:6px;height:6px;border-radius:50%;flex-shrink:0}
.proj-id{font-family:var(--mono);font-size:9px;opacity:.6}
.chip-div{width:1px;height:18px;background:var(--border-md);flex-shrink:0;margin:0 4px}
.sec-chip{display:flex;align-items:center;gap:5px;padding:4px 10px;border-radius:20px;font-size:11px;color:var(--ink-3);cursor:pointer;text-decoration:none;white-space:nowrap;transition:all .12s;flex-shrink:0;border:1px solid transparent}
.sec-chip:hover,.sec-chip.active{color:var(--mc);background:var(--mc-pale);border-color:var(--mc-light)}
.sec-chip.active{font-weight:500}
</style>
</head>
<body>
<nav class="nav-shell" id="navShell">
  <div class="nav-top">
    <a class="nav-wordmark" href="https://metcmn.sharepoint.com/sites/TCCISPortfolioHub" target="_parent">
      <svg width="28" height="28" viewBox="0 0 30 30" fill="none"><polygon points="15,2 28,26 2,26" fill="#0054A4"/><polygon points="15,8 23.5,22 6.5,22" fill="#fff" opacity=".2"/></svg>
      <div>
        <div class="nav-site-name">IS Portfolio Hub</div>
        <div class="nav-site-sub">Metropolitan Council · Metro Transit · TCC</div>
      </div>
    </a>
    <div class="nav-items">
      <a class="nav-item active" href="#" onclick="setNav(this)">Status</a>
      <a class="nav-item" href="#" onclick="setNav(this)">Timeline</a>
      <a class="nav-item" href="#" onclick="setNav(this)">RAID Log</a>
      <a class="nav-item" href="#" onclick="setNav(this)">WBS</a>
      <a class="nav-item" href="#" onclick="setNav(this)">Monday Brief</a>
      <a class="nav-item" href="#" onclick="setNav(this)">Documents</a>
    </div>
    <div class="nav-right">
      <div class="alert-badge" id="alertBadge"><div class="alert-dot"></div><span id="alertCount">9 Red</span></div>
      <div class="nav-date" id="navDate"></div>
    </div>
  </div>
  <div class="nav-projects">
    <a class="proj-chip exp active" href="#" onclick="setProj(this)"><div class="proj-rag" style="background:#c97000"></div>TCC Expansion<span class="proj-id">EXP</span></a>
    <a class="proj-chip ng911" href="#" onclick="setProj(this)"><div class="proj-rag" style="background:#c97000"></div>NG911 Refresh<span class="proj-id">NG911</span></a>
    <a class="proj-chip vuw" href="#" onclick="setProj(this)"><div class="proj-rag" style="background:#cc2222"></div>VuWall / KVM<span class="proj-id">VUW</span></a>
    <div class="chip-div"></div>
    <a class="sec-chip active" href="#" onclick="setSec(this)">Overview</a>
    <a class="sec-chip" href="#" onclick="setSec(this)">Milestones</a>
    <a class="sec-chip" href="#" onclick="setSec(this)">Risks</a>
    <a class="sec-chip" href="#" onclick="setSec(this)">Actions</a>
    <a class="sec-chip" href="#" onclick="setSec(this)">Decisions</a>
  </div>
</nav>

<script>
// Set today's date
document.getElementById('navDate').textContent = new Date().toLocaleDateString('en-US',{month:'short',day:'numeric',year:'numeric'});

// Nav interactions
function setNav(el){event.preventDefault();document.querySelectorAll('.nav-item').forEach(n=>n.classList.remove('active'));el.classList.add('active');}
function setProj(el){event.preventDefault();const was=el.classList.contains('active');document.querySelectorAll('.proj-chip').forEach(c=>c.classList.remove('active'));if(!was)el.classList.add('active');}
function setSec(el){event.preventDefault();document.querySelectorAll('.sec-chip').forEach(c=>c.classList.remove('active'));el.classList.add('active');}

// Try to pull live red count from RAID list
(async()=>{
  try{
    const r=await fetch('https://metcmn.sharepoint.com/sites/TCCISPortfolioHub/_api/web/lists/getbytitle(\'IS Project RAID\')/items?$select=RAG_x0020_Status,Status&$filter=RAG_x0020_Status eq \'Red\' and Status ne \'Closed\'&$top=100',
      {headers:{'Accept':'application/json;odata=verbose'},credentials:'include'});
    if(r.ok){const d=await r.json();const n=d.d.results.length;document.getElementById('alertCount').textContent=n+' Red';}
  }catch(e){}
})();
</script>
</body>
</html>
