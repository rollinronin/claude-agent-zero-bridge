// IS Portfolio Config — SP list creation + seed rows
// Run via Claude-in-Chrome javascript_tool on metcmn.sharepoint.com/sites/TCCISPortfolioHub
// Results are stored to window.TCC_CONFIG_* globals (poll after ~20s for the final summary)
(async () => {
    const SITE = '/sites/TCCISPortfolioHub';
    const LIST_TITLE = 'IS Portfolio Config';
    const LIST_DESC = 'Key/value configuration store for the IS Portfolio Hub canvas app (countdown targets, thresholds, dates).';
    const results = { steps: [], errors: [] };
    window.TCC_CONFIG_RESULTS = results;

    const log = (step, data) => {
        results.steps.push({ step, data, ts: new Date().toISOString() });
        console.log('[TCC_CONFIG]', step, data);
    };
    const fail = (step, err) => {
        results.errors.push({ step, err: String(err), ts: new Date().toISOString() });
        console.error('[TCC_CONFIG][FAIL]', step, err);
    };

    // 1. Get form digest
    let digest;
    try {
        const r = await fetch(`${SITE}/_api/contextinfo`, {
            method: 'POST',
            headers: { 'Accept': 'application/json;odata=nometadata' }
        });
        const j = await r.json();
        digest = j.FormDigestValue;
        log('digest', { ok: !!digest });
    } catch (e) { fail('digest', e); return; }

    const hdr = () => ({
        'Accept': 'application/json;odata=nometadata',
        'Content-Type': 'application/json;odata=verbose',
        'X-RequestDigest': digest
    });

    // 2. Create list (BaseTemplate 100 = Generic List)
    try {
        const body = JSON.stringify({
            __metadata: { type: 'SP.List' },
            Title: LIST_TITLE,
            Description: LIST_DESC,
            BaseTemplate: 100,
            ContentTypesEnabled: false,
            AllowContentTypes: false
        });
        const r = await fetch(`${SITE}/_api/web/lists`, { method: 'POST', headers: hdr(), body });
        if (r.status === 201 || r.status === 200) {
            const j = await r.json();
            log('list.create', { id: j.Id, title: j.Title });
            window.TCC_CONFIG_LIST_ID = j.Id;
        } else {
            const t = await r.text();
            fail('list.create', `${r.status} ${t.substring(0, 400)}`);
            return;
        }
    } catch (e) { fail('list.create', e); return; }

    // helper: add field via XML schema (most reliable for Required + Unique + Indexed)
    const addField = async (schemaXml) => {
        const body = JSON.stringify({
            parameters: {
                __metadata: { type: 'SP.XmlSchemaFieldCreationInformation' },
                SchemaXml: schemaXml
            }
        });
        const r = await fetch(
            `${SITE}/_api/web/lists/getbytitle('${encodeURIComponent(LIST_TITLE)}')/fields/createfieldasxml`,
            { method: 'POST', headers: hdr(), body }
        );
        if (r.status === 201 || r.status === 200) {
            const j = await r.json();
            return { ok: true, internal: j.InternalName };
        } else {
            const t = await r.text();
            return { ok: false, err: `${r.status} ${t.substring(0, 400)}` };
        }
    };

    // 3. Key field — Text, required, indexed, unique
    const keyRes = await addField(
        `<Field Type="Text" DisplayName="Key" Name="Key" Required="TRUE" EnforceUniqueValues="TRUE" Indexed="TRUE" MaxLength="60" />`
    );
    log('field.key', keyRes);

    // 4. Value field — DateTime, DateOnly format
    const valRes = await addField(
        `<Field Type="DateTime" DisplayName="Value" Name="ConfigValue" Format="DateOnly" FriendlyDisplayFormat="Disabled" />`
    );
    log('field.value', valRes);
    // Note: internal name forced to ConfigValue (not "Value") to avoid collision with SP system reserved tokens.

    // 5. Notes field — MultiLineText plain
    const notesRes = await addField(
        `<Field Type="Note" DisplayName="Notes" Name="ConfigNotes" NumLines="4" RichText="FALSE" />`
    );
    log('field.notes', notesRes);

    // 6. Seed rows
    const seed = [
        {
            Title: 'Room 1007 Go-Live',
            Key: 'RoomReadyDate',
            ConfigValue: '2026-08-15',
            ConfigNotes: 'Pre-State-Fair target; earlier if achievable. Drives DAYS TO EBC countdown on scrExecutive.'
        },
        {
            Title: 'MN State Fair Start',
            Key: 'StateFairStart',
            ConfigValue: '2026-08-21',
            ConfigNotes: 'Hard stop for TCC load-peak window. Disruption risk during Fair is unacceptable. Drives DAYS TO STATE FAIR countdown.'
        },
        {
            Title: 'TCC Final Construction Complete',
            Key: 'TCCFinalComplete',
            ConfigValue: '2026-12-31',
            ConfigNotes: 'Long-horizon anchor; precedes Council+MTPD Go-Live (~Mar 2027). Drives DAYS TO TCC FINAL countdown. Revise when construction PM confirms actual date.'
        }
    ];

    // entity type full name — POST a probe to discover (list title spaces get stripped + prefixed by SP)
    let entityType;
    try {
        const r = await fetch(
            `${SITE}/_api/web/lists/getbytitle('${encodeURIComponent(LIST_TITLE)}')?$select=ListItemEntityTypeFullName`,
            { headers: { 'Accept': 'application/json;odata=nometadata' } }
        );
        const j = await r.json();
        entityType = j.ListItemEntityTypeFullName;
        log('entityType', entityType);
    } catch (e) { fail('entityType', e); return; }

    for (const row of seed) {
        try {
            const body = JSON.stringify({ __metadata: { type: entityType }, ...row });
            const r = await fetch(
                `${SITE}/_api/web/lists/getbytitle('${encodeURIComponent(LIST_TITLE)}')/items`,
                { method: 'POST', headers: hdr(), body }
            );
            if (r.status === 201 || r.status === 200) {
                const j = await r.json();
                log('row.create', { key: row.Key, id: j.Id });
            } else {
                const t = await r.text();
                fail(`row.create[${row.Key}]`, `${r.status} ${t.substring(0, 400)}`);
            }
        } catch (e) { fail(`row.create[${row.Key}]`, e); }
    }

    // Final summary
    window.TCC_CONFIG_DONE = {
        listId: window.TCC_CONFIG_LIST_ID,
        steps: results.steps.length,
        errors: results.errors.length,
        errorDetail: results.errors
    };
    console.log('[TCC_CONFIG] DONE', window.TCC_CONFIG_DONE);
})();
