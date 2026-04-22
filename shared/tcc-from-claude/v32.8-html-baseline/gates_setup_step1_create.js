/* IS Project Gates — Step 1: Create list + columns
 *
 * Run this in Chrome DevTools console while on any page of
 * https://metcmn.sharepoint.com/sites/TCCISPortfolioHub
 *
 * Creates the "IS Project Gates" list with schema:
 *   Title (text, default) — gate number ("G-01")
 *   Project (Choice) — TCC Expansion / NG911 Refresh / VuWall / Portfolio
 *   GateStatus (Choice) — Complete / Active / Blocked / NotStarted
 *   TargetDate (DateTime)
 *   Notes (Note)
 *
 * Idempotent — re-runs safely if list or columns already exist.
 */
(async () => {
  const SITE = "/sites/TCCISPortfolioHub";
  const LIST_NAME = "IS Project Gates";

  const digestRes = await fetch(SITE + "/_api/contextinfo", {
    method: "POST",
    headers: { "Accept": "application/json;odata=verbose" }
  });
  const digestJson = await digestRes.json();
  const digest = digestJson.d.GetContextWebInformation.FormDigestValue;

  const postJson = (url, body) => fetch(SITE + url, {
    method: "POST",
    headers: {
      "Accept": "application/json;odata=verbose",
      "Content-Type": "application/json;odata=verbose",
      "X-RequestDigest": digest
    },
    body: JSON.stringify(body)
  });

  // 1. Create the list (100 = Custom List)
  let listCreated = false;
  const existsRes = await fetch(SITE + `/_api/web/lists/getbytitle('${LIST_NAME}')`, {
    headers: { "Accept": "application/json;odata=verbose" }
  });
  if (existsRes.ok) {
    console.log(`List "${LIST_NAME}" already exists — skipping create`);
  } else {
    const r = await postJson("/_api/web/lists", {
      __metadata: { type: "SP.List" },
      Title: LIST_NAME,
      BaseTemplate: 100,
      Description: "Gate status per project for the IS Portfolio Hub"
    });
    if (r.ok) {
      console.log(`List "${LIST_NAME}" created`);
      listCreated = true;
    } else {
      console.error("List create failed:", r.status, await r.text());
      return;
    }
  }

  const listUrl = `/_api/web/lists/getbytitle('${LIST_NAME}')`;

  // 2. Check existing fields so we skip ones already added
  const fieldsRes = await fetch(SITE + listUrl + "/fields?$select=InternalName,Title", {
    headers: { "Accept": "application/json;odata=verbose" }
  });
  const fieldsJson = await fieldsRes.json();
  const existingFields = new Set(fieldsJson.d.results.map(f => f.InternalName));
  console.log(`  Existing fields: ${[...existingFields].filter(n => !n.startsWith("_") && !["ID","GUID","Title","ContentType","Modified","Created","Author","Editor","Attachments"].includes(n)).join(", ") || "(none)"}`);

  const addChoice = async (displayName, internalName, choices, required=false) => {
    if (existingFields.has(internalName)) {
      console.log(`  Field ${displayName} exists — skipping`);
      return;
    }
    const r = await postJson(listUrl + "/fields/addfield", {
      parameters: {
        __metadata: { type: "SP.FieldCreationInformation" },
        Title: displayName,
        FieldTypeKind: 6,
        Required: required,
        Choices: { results: choices }
      }
    });
    console.log(`  Field ${displayName}: ${r.ok ? "OK" : "FAIL " + r.status}`);
    if (!r.ok) console.error(await r.text());
  };

  const addSimple = async (displayName, internalName, fieldTypeKind) => {
    if (existingFields.has(internalName)) {
      console.log(`  Field ${displayName} exists — skipping`);
      return;
    }
    const r = await postJson(listUrl + "/fields", {
      __metadata: { type: "SP.Field" },
      Title: displayName,
      FieldTypeKind: fieldTypeKind
    });
    console.log(`  Field ${displayName}: ${r.ok ? "OK" : "FAIL " + r.status}`);
    if (!r.ok) console.error(await r.text());
  };

  // 3. Add columns
  await addChoice("Project", "Project",
    ["TCC Expansion","NG911 Refresh","VuWall","Portfolio"], true);
  await addChoice("Gate Status", "GateStatus",
    ["Complete","Active","Blocked","NotStarted"], true);
  await addSimple("Target Date", "TargetDate", 4);   // DateTime
  await addSimple("Notes",       "Notes",      3);   // Note

  console.log(`\nStep 1 complete — "${LIST_NAME}" ready. Now run gates_setup_step2_seed.js`);
})();
