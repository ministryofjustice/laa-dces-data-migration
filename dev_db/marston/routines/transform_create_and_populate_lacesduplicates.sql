
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

    -- Populate the lacesduplicates table
    WITH cap_amounts AS (
        SELECT 
            caseid,
            regexp_match(comment, 'Cap amt:\s*([^;]+);', 'i') AS cap_amt_array
        FROM marston.laacasenotes_20240916
        WHERE comment ILIKE '%Cap amt%'
    ),
    processed_cap_amounts AS (
        SELECT
            caseid,
            CASE
                WHEN cap_amt_array IS NOT NULL AND regexp_replace(cap_amt_array[1], '[^\d\.-]', '', 'g') ~ '^[-+]?\d*\.?\d+$' THEN
                    CAST(regexp_replace(cap_amt_array[1], '[^\d\.-]', '', 'g') AS numeric)
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
    manually_corrected_amounts AS (
        SELECT DISTINCT ON (nt.caseid)
            nt.caseid,
            regexp_match(nt.comment, '(?i)duplicated?[^0-9]*([-+]?\d{1,}(?:,\d{3})*(?:\.\d+)?)') AS mca_array
        FROM marston.laacasenotes_20240916 nt
        WHERE nt.comment ILIKE '%DUPLICATE%' AND (nt.comment ILIKE '%CAP%' OR nt.comment ILIKE '%ACC%' OR nt.comment ILIKE '%AMOUNT%')
        ORDER BY nt.caseid, nt.loadedon DESC
    ),
    processed_mca AS (
        SELECT
            caseid,
            CASE
                WHEN mca_array IS NOT NULL AND regexp_replace(mca_array[1], '[^\d\.-]', '', 'g') ~ '^[-+]?\d*\.?\d+$' THEN
                    CAST(regexp_replace(mca_array[1], '[^\d\.-]', '', 'g') AS numeric)
                ELSE NULL
            END AS ManuallyCorrectedAmount
        FROM manually_corrected_amounts
    )
    INSERT INTO marston.lacesduplicates (caseid, maatid, originaltotalcapitalassetsamount, LACEStotalavailablecapitalassets, amountsequal, manualcaptalassetsamount, manualcapitalassetamountreliableflag, originalnumberofcapitalassets, lacesnumberofcapitalassets, accountsequal, potentialduplicationflag)
    SELECT 
        b.caseid,  
        b.clientcasereference AS maatid,
        aca.total_cap_amt AS originaltotalcapitalassetsamount,
        CAST(NULLIF(la.totalavailablecapitalassets, 'NULL') AS numeric) AS LACEStotalavailablecapitalassets,
        CASE
            WHEN CAST(NULLIF(la.totalavailablecapitalassets, 'NULL') AS numeric) = aca.total_cap_amt THEN true
            WHEN la.totalavailablecapitalassets = 'NULL' AND (aca.caseid IS NULL OR aca.total_cap_amt = 0) THEN true
            ELSE false
        END AS amountsequal,
        pmca.ManuallyCorrectedAmount AS manualcaptalassetsamount,
        CASE
            WHEN pmca.ManuallyCorrectedAmount IS NULL THEN NULL
            WHEN pmca.ManuallyCorrectedAmount IS NOT NULL AND (pmca.ManuallyCorrectedAmount <> aca.total_cap_amt AND pmca.ManuallyCorrectedAmount <> CAST(NULLIF(la.totalavailablecapitalassets, 'NULL') AS numeric)) AND la.maatid IS NOT NULL THEN 'N'
            ELSE 'Y'
        END AS manualcapitalassetamountreliableflag,
        aca.numberofcapitalassets AS originalnumberofcapitalassets,
        CASE WHEN la.numberofavailablecapitalassets ~ '^\d+$' THEN la.numberofavailablecapitalassets::integer ELSE 0 END AS lacesnumberofcapitalassets,
        (aca.numberofcapitalassets = CASE WHEN la.numberofavailablecapitalassets ~ '^\d+$' THEN la.numberofavailablecapitalassets::integer ELSE 0 END) AS accountsequal,
        CASE
            WHEN CAST(NULLIF(la.totalavailablecapitalassets, 'NULL') AS numeric) = aca.total_cap_amt THEN 'N'
            WHEN la.totalavailablecapitalassets = 'NULL' AND (aca.caseid IS NULL OR aca.total_cap_amt = 0) THEN 'N'
            WHEN (aca.numberofcapitalassets = CASE WHEN la.numberofavailablecapitalassets ~ '^\d+$' THEN la.numberofavailablecapitalassets::integer ELSE 0 END) THEN 'N'
            WHEN la.totalavailablecapitalassets IS NULL THEN 'not in laces'
            ELSE 'Y'
        END AS potentialduplicationflag
    FROM marston.laacasedetails_20240916 b 
    JOIN marston.laalacesdatawarehouse_20240916 la ON la.maatid = b.clientcasereference
    JOIN marston.laalacescases_20240916 lc ON lc.lacescaseid = la.lacescaseid
    LEFT JOIN aggregated_cap_amounts aca ON b.caseid = aca.caseid
    LEFT JOIN processed_mca pmca ON pmca.caseid = aca.caseid
    LEFT JOIN marston.referencedata r ON lc.casestatus = r.code
    WHERE (aca.numberofcapitalassets <> CASE WHEN la.numberofavailablecapitalassets ~ '^\d+$' THEN la.numberofavailablecapitalassets::integer ELSE 0 END)
        OR (CASE WHEN CAST(NULLIF(la.totalavailablecapitalassets, 'NULL') AS numeric) = aca.total_cap_amt THEN true WHEN la.totalavailablecapitalassets = 'NULL' AND (aca.caseid IS NULL OR aca.total_cap_amt = 0) THEN true ELSE false END) <> true
        OR pmca.ManuallyCorrectedAmount IS NOT NULL;
END;
