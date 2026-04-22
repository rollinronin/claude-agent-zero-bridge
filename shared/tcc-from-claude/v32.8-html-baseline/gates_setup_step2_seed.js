/* IS Project Gates — Step 2: Seed 18 initial rows
 *
 * Run AFTER step 1 completes successfully.
 * Same Chrome console, same SP site.
 *
 * Seeds gate status for TCC Expansion / NG911 Refresh / VuWall projects
 * matching the current hardcoded state in gProjects.GateStrip.
 *
 * Idempotent-ish: will not duplicate if re-run (checks existing rows by
 * Title + Project combo).
 */
(async () => {
  const SITE = "/sites/TCCISPortfolioHub";
  const LIST_NAME = "IS Project Gates";

  const digestJson = await fetch(SITE + "/_api/contextinfo", {
    method: "POST",
    headers: { "Accept": "application/json;odata=verbose" }
  }).then(r => r.json());
  const digest = digestJson.d.GetContextWebInformation.FormDigestValue;

  // Get the list entity type name (needed for inserts)
  const listMetaRes = await fetch(SITE + `/_api/web/lists/getbytitle('${LIST_NAME}')?$select=ListItemEntityTypeFullName`, {
    headers: { "Accept": "application/json;odata=verbose" }
  });
  const listMeta = await listMetaRes.json();
  const entityType = listMeta.d.ListItemEntityTypeFullName;
  console.log(`Using entity type: ${entityType}`);

  // Existing rows (to skip duplicates on re-run)
  const existingRes = await fetch(SITE + `/_api/web/lists/getbytitle('${LIST_NAME}')/items?$select=Title,Project&$top=500`, {
    headers: { "Accept": "application/json;odata=verbose" }
  });
  const existingJson = await existingRes.json();
  const existingKeys = new Set(existingJson.d.results.map(r => `${r.Title}||${r.Project}`));
  console.log(`Found ${existingKeys.size} existing rows, will skip matching`);

  const SEED = [
    // TCC Expansion
    { gate:"G-01", proj:"TCC Expansion", status:"Complete" },
    { gate:"G-02", proj:"TCC Expansion", status:"NotStarted" },
    { gate:"G-03", proj:"TCC Expansion", status:"NotStarted" },
    { gate:"G-04", proj:"TCC Expansion", status:"NotStarted" },
    { gate:"G-05", proj:"TCC Expansion", status:"NotStarted" },
    { gate:"G-13", proj:"TCC Expansion", status:"NotStarted" },
    // NG911 Refresh
    { gate:"G-01", proj:"NG911 Refresh", status:"Complete" },
    { gate:"G-02", proj:"NG911 Refresh", status:"Complete" },
    { gate:"G-03", proj:"NG911 Refresh", status:"Active" },
    { gate:"G-04", proj:"NG911 Refresh", status:"NotStarted" },
    { gate:"G-05", proj:"NG911 Refresh", status:"NotStarted" },
    { gate:"G-13", proj:"NG911 Refresh", status:"NotStarted" },
    // VuWall
    { gate:"G-01", proj:"VuWall", status:"Complete" },
    { gate:"G-02", proj:"VuWall", status:"Complete" },
    { gate:"G-03", proj:"VuWall", status:"Blocked" },
    { gate:"G-04", proj:"VuWall", status:"NotStarted" },
    { gate:"G-05", proj:"VuWall", status:"NotStarted" },
    { gate:"G-13", proj:"VuWall", status:"NotStarted" }
  ];

  let added = 0, skipped = 0, failed = 0;
  for (const row of SEED) {
    const key = `${row.gate}||${row.proj}`;
    if (existingKeys.has(key)) {
      skipped++;
      continue;
    }
    const body = {
      __metadata: { type: entityType },
      Title:      row.gate,
      Project:    row.proj,
      GateStatus: row.status
    };
    const r = await fetch(SITE + `/_api/web/lists/getbytitle('${LIST_NAME}')/items`, {
      method: "POST",
      headers: {
        "Accept": "application/json;odata=verbose",
        "Content-Type": "application/json;odata=verbose",
        "X-RequestDigest": digest
      },
      body: JSON.stringify(body)
    });
    if (r.ok) { added++; console.log(`  + ${row.proj} ${row.gate} = ${row.status}`); }
    else { failed++; console.error(`  X ${row.proj} ${row.gate}: ${r.status}`, await r.text()); }
  }

  console.log(`\nSeed complete: ${added} added, ${skipped} skipped, ${failed} failed`);
  console.log(`\nNext: in Power Apps Studio, open app, Add Data -> SharePoint ->`);
  console.log(`select site -> pick "IS Project Gates" list -> Connect -> Save.`);
  console.log(`Then tell Claude: "gates ready"`);
})();
