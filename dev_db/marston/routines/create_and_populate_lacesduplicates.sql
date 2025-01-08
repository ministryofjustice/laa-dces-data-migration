
BEGIN
    -- Create the lacesduplicates table
    CREATE TABLE IF NOT EXISTS marston.lacesduplicates (
        caseid TEXT,
        maatid TEXT,
        originaltotalcapitalassetsamount NUMERIC,
        LACEStotalavailablecapitalassets NUMERIC,
        amountsequal BOOLEAN,
        manualcaptalassetsamount NUMERIC,
        manualcapitalassetamountreliableflag CHAR(1),
        originalnumberofcapitalassets INTEGER,
        lacesnumberofcapitalassets INTEGER,
        accountsequal BOOLEAN,
        potentialduplicationflag TEXT
    );
	TRUNCATE TABLE marston.lacesduplicates;
    -- Populate the lacesduplicates table
WITH max_casenotes AS (
        SELECT 
                caseid, 
                MAX(loadedon) AS max_loadedon_casenotes
        FROM 
                marston.laacasenotes_20250106
        GROUP BY 
                caseid
),
max_casehistory AS (
        SELECT 
                caseid, 
                MAX(loadedon) AS max_loadedon_casehistory
        FROM 
                marston.laacasehistory_20250106
        GROUP BY 
                caseid
),
cap_amounts AS (
SELECT 
        caseid,
        regexp_match(comment, 'Cap amt:\s*([^\;]+);', 'i') AS cap_amt_array
FROM marston.laacasenotes_20250106
WHERE 
  comment ILIKE '%Cap amt%'
),
processed_cap_amounts AS (
    SELECT
        caseid,
        CASE
            WHEN cap_amt_array IS NOT NULL THEN
                CASE
                    WHEN regexp_replace(cap_amt_array[1], '[^\d\.-]', '', 'g') ~ '^[-+]?\d*\.?\d+$' THEN
                        CAST(regexp_replace(cap_amt_array[1], '[^\d\.-]', '', 'g') AS numeric)
                    ELSE NULL
                END
            ELSE NULL
        END AS cap_amt
    FROM cap_amounts
),
aggregated_cap_amounts AS (
    SELECT 
        caseid, 
        SUM(cap_amt) AS total_cap_amt,
        COUNT(cap_amt) AS numberofcapitalassets
    FROM processed_cap_amounts
    GROUP BY caseid
),
total_capital_assets_additional AS (
    SELECT 
        caseid,
        MAX(
            CASE
                WHEN regexp_replace(value, '[^\d\.-]', '', 'g') ~ '^[-+]?\d*\.?\d+$' THEN
                    CAST(regexp_replace(value, '[^\d\.-]', '', 'g') AS numeric)
                ELSE NULL
            END
        ) FILTER (WHERE name = 'Capital') AS CapitalfromAdditionalNotes,
        MAX(value) FILTER (WHERE name = 'Sufficient Capital and Equity') AS SufficientCapitalAndEquity,
        MAX(
            CASE
                WHEN regexp_replace(value, '[^\d\.-]', '', 'g') ~ '^[-+]?\d*\.?\d+$' THEN
                    CAST(regexp_replace(value, '[^\d\.-]', '', 'g') AS numeric)
                ELSE NULL
            END
        ) FILTER (WHERE name = 'Total Capital Assets') AS TotalCapitalAssetsfromAdditionalNotes,
        MAX(value) FILTER (WHERE name = 'Total K&E less 30,000') AS TotalKELess30000,
        MAX(value) FILTER (WHERE name = 'Total K&E') AS TotalKE,
        MAX(value) FILTER (WHERE name = 'K&E') AS KE,
        MAX(value) FILTER (WHERE name = 'Property Value') AS PropertyValue,
        MAX(value) FILTER (WHERE name = 'FinalDefenceCost') AS FinalDefenceCost,
        MAX(value) FILTER (WHERE name = 'Outcome') AS Outcome,
        MAX(value) FILTER (WHERE name = 'SentenceOrderDate') AS SentenceOrderDate
    FROM marston.laacaseadditionaldata_20250106
    GROUP BY caseid
),
manually_corrected_amounts AS (
    SELECT DISTINCT ON (nt.caseid)
        nt.caseid,
        -- Extract the first numeric amount after ""duplicate"" or ""duplicated"" (case-insensitive)
        regexp_match(nt.comment, '(?i)duplicated?[^0-9]*([-+]?\d{1,}(?:,\d{3})*(?:\.\d+)?)') AS mca_array
    FROM marston.laacasenotes_20250106 nt
    WHERE nt.comment ILIKE '%DUPLICATE%' and (nt.comment ILIKE '%CAP%' OR nt.comment ILIKE '%ACC%' OR nt.comment ILIKE '%AMOUNT%')
    ORDER BY nt.caseid, nt.loadedon DESC
),
processed_mca AS (
    SELECT
        caseid,
        CASE
            WHEN mca_array IS NOT NULL THEN
                CASE
                    WHEN regexp_replace(mca_array[1], '[^\d\.-]', '', 'g') ~ '^[-+]?\d*\.?\d+$' THEN
                        CAST(regexp_replace(mca_array[1], '[^\d\.-]', '', 'g') AS numeric)
                    ELSE NULL
                END
            ELSE NULL
        END AS ManuallyCorrectedAmount
    FROM manually_corrected_amounts
),
header_row AS (
    SELECT 
        'Columbus'::TEXT AS caseid,
        'Columbus'::TEXT AS clientcasereference,
        'Columbus'::TEXT AS currentstatus,
        'Columbus'::TEXT AS statusdate,
        'AdditionalNotes'::TEXT AS total_cap_amt,
        'AdditionalNotes'::TEXT AS CapitalfromAdditionalNotes,
        'FLAG'::TEXT AS amountsequal,
        'ColumbusNotes'::TEXT AS ManuallyCorrectedAmount,
        'FLAG'::TEXT AS needschecking,
        'LACES'::TEXT AS LACEStotalavailablecapitalassets,
        'FLAG'::TEXT AS valuesequal,
        'AdditionalNotes'::TEXT AS numberofcapitalassets,
        'LACES'::TEXT AS numberofavailablecapitalassets,
        'FLAG'::TEXT AS accountsequal,
        'AdditionalNotes'::TEXT AS TotalCapitalAssetsfromAdditionalNotes,
        'AdditionalNotes'::TEXT AS TotalKE,
        'AdditionalNotes'::TEXT AS TotalKELess30000,
        'AdditionalNotes'::TEXT AS SufficientCapitalAndEquity,
        'AdditionalNotes'::TEXT AS PropertyValue,
        'AdditionalNotes'::TEXT AS FinalDefenceCost,
        'AdditionalNotes'::TEXT AS Outcome,
        'AdditionalNotes'::TEXT AS SentenceOrderDate,
        'Columbus'::TEXT AS SentenceOrderDate,
        'Columbus'::TEXT AS Outcome,
        'AdditionalNotes'::TEXT AS KE,
                'LACES'::TEXT as LACESstatus,
        'Columbus'::TEXT AS clientname,
        'LACES'::TEXT AS totalavailablecapitalassets,
        'LACES'::TEXT AS numberofavailablecapitalassets,
                'Columbus'::TEXT  as openclosedstatus,
                'Columbus'::TEXT  as currentstatus,
                'Columbus'::TEXT  as currentphase,
                'Columbus'::TEXT  as currentstage,
                'Columbus'::TEXT  as lastupdateoncase,
                'Columbus'::TEXT  as InMigrationScope
    UNION ALL
    SELECT 
        b.caseid::TEXT,  
        b.clientcasereference::TEXT,
        b.currentstatus::TEXT,
        b.statusdate::TEXT,
        aca.total_cap_amt::TEXT,
        tca.CapitalfromAdditionalNotes::TEXT,
        (aca.total_cap_amt = tca.CapitalfromAdditionalNotes)::TEXT AS amountsequal,
        pmca.ManuallyCorrectedAmount::TEXT,
                CASE
            WHEN (pmca.ManuallyCorrectedAmount <> aca.total_cap_amt)
                 AND (aca.total_cap_amt <> CAST(NULLIF(la.totalavailablecapitalassets, 'NULL') AS numeric))
                 AND la.maatid IS NOT NULL THEN 'Y'
            ELSE NULL
        END AS needschecking,
        la.totalavailablecapitalassets::TEXT AS LACEStotalavailablecapitalassets,
        CASE
            WHEN la.totalavailablecapitalassets IS NULL THEN 'not in laces'
            WHEN CAST(NULLIF(la.totalavailablecapitalassets, 'NULL') AS numeric) = aca.total_cap_amt THEN 'true'
            WHEN la.totalavailablecapitalassets = 'NULL' AND (aca.caseid is null or aca.total_cap_amt=0) THEN 'true'
                        ELSE 'false'
        END AS valuesequal,   
        aca.numberofcapitalassets::TEXT,
        la.numberofavailablecapitalassets::TEXT,
        (aca.numberofcapitalassets = 
            CASE 
                WHEN la.numberofavailablecapitalassets ~ '^\d+$' THEN la.numberofavailablecapitalassets::integer
                ELSE 0
            END
        )::TEXT AS accountsequal,
        tca.TotalCapitalAssetsfromAdditionalNotes::TEXT,
        tca.TotalKE::TEXT,
        tca.TotalKELess30000::TEXT,
        tca.SufficientCapitalAndEquity::TEXT,  
        tca.PropertyValue::TEXT,
        tca.FinalDefenceCost::TEXT,
        tca.Outcome::TEXT,
        tca.SentenceOrderDate::TEXT,
                b.SentenceOrderDate::TEXT,
                b.Outcome::TEXT,
        tca.KE::TEXT,
        r.description::TEXT as LACESstatus,
        b.clientname::TEXT,
                la.totalavailablecapitalassets::TEXT AS totalavailablecapitalassets,
        la.numberofavailablecapitalassets::TEXT AS numberofavailablecapitalassets,
                b.openclosedstatus::TEXT,
                b.currentstatus::TEXT,
                b.currentphase::TEXT,
                b.currentstage::TEXT,
GREATEST(
COALESCE(mn.max_loadedon_casenotes, '1900-01-01'::timestamp),
COALESCE(mh.max_loadedon_casehistory, '1900-01-01'::timestamp)
)::TEXT AS lastupdateoncase,
(CASE WHEN (openclosedstatus = 'OPEN'
OR GREATEST(
COALESCE(mn.max_loadedon_casenotes, '1900-01-01'::timestamp),
COALESCE(mh.max_loadedon_casehistory, '1900-01-01'::timestamp)
) >'2023-01-31' ) THEN 'TRUE' ELSE 'FALSE' END)::TEXT as InMigrationScope
        FROM marston.laacasedetails_20250106 b 
        JOIN marston.laalacesdatawarehouse_20250106 la ON la.maatid = b.clientcasereference
    JOIN marston.laalacescases_20250106 lc ON lc.lacescaseid = la.lacescaseid
        LEFT JOIN aggregated_cap_amounts aca ON b.caseid = aca.caseid
    LEFT JOIN total_capital_assets_additional tca ON aca.caseid = tca.caseid
    LEFT JOIN processed_mca pmca ON pmca.caseid = aca.caseid
        LEFT JOIN marston.referencedata r ON lc.casestatus = r.code
        LEFT JOIN max_casenotes mn ON b.caseid = mn.caseid
        LEFT JOIN max_casehistory mh ON b.caseid = mh.caseid  
    -- WHERE aca.caseid = '21036214'
)
SELECT *
FROM header_row
WHERE (LOWER(amountsequal) = 'false' or LOWER(valuesequal) = 'false' 
or LOWER(accountsequal) = 'false' 
or caseid = 'Columbus') -- to make sure we are selecting header
ORDER BY 
    CASE WHEN caseid = 'Columbus' THEN 0 ELSE 1 END,
    valuesequal DESC;
END;
