BEGIN
    -- Create the lacesduplicates table if it doesn't exist
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

    -- Truncate the table
    TRUNCATE TABLE marston.lacesduplicates;

    -- Insert data into lacesduplicates table
    INSERT INTO marston.lacesduplicates (
        caseid,
        maatid,
        originaltotalcapitalassetsamount,
        LACEStotalavailablecapitalassets,
        amountsequal,
        manualcaptalassetsamount,
        manualcapitalassetamountreliableflag,
        originalnumberofcapitalassets,
        lacesnumberofcapitalassets,
        accountsequal,
        potentialduplicationflag
    )
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
    )
    SELECT 
        b.caseid,
        b.clientcasereference AS maatid,
        aca.total_cap_amt AS originaltotalcapitalassetsamount,
        CASE 
            WHEN la.totalavailablecapitalassets = 'NULL' THEN NULL 
            ELSE CAST(la.totalavailablecapitalassets AS NUMERIC)
        END AS LACEStotalavailablecapitalassets,
        CASE 
            WHEN la.totalavailablecapitalassets = 'NULL' AND (aca.caseid IS NULL OR aca.total_cap_amt = 0) THEN TRUE
            WHEN CAST(NULLIF(la.totalavailablecapitalassets, 'NULL') AS NUMERIC) = aca.total_cap_amt THEN TRUE
            ELSE FALSE
        END AS amountsequal,
        pmca.ManuallyCorrectedAmount AS manualcaptalassetsamount,
        CASE 
            WHEN pmca.ManuallyCorrectedAmount IS NOT NULL THEN 'Y'
            ELSE 'N'
        END AS manualcapitalassetamountreliableflag,
        aca.numberofcapitalassets AS originalnumberofcapitalassets,
        CASE 
            WHEN la.numberofavailablecapitalassets ~ '^\d+$' 
            THEN la.numberofavailablecapitalassets::INTEGER
            ELSE NULL
        END AS lacesnumberofcapitalassets,
        (aca.numberofcapitalassets = 
            CASE 
                WHEN la.numberofavailablecapitalassets ~ '^\d+$' 
                THEN la.numberofavailablecapitalassets::INTEGER
                ELSE 0
            END
        ) AS accountsequal,
        CASE
            WHEN (pmca.ManuallyCorrectedAmount <> aca.total_cap_amt)
                 AND (aca.total_cap_amt <> CAST(NULLIF(la.totalavailablecapitalassets, 'NULL') AS NUMERIC))
                 AND la.maatid IS NOT NULL THEN 'Y'
            ELSE 'N'
        END AS potentialduplicationflag
    FROM marston.laacasedetails_20250106 b 
    JOIN marston.laalacesdatawarehouse_20250106 la ON la.maatid = b.clientcasereference
    JOIN marston.laalacescases_20250106 lc ON lc.lacescaseid = la.lacescaseid
    LEFT JOIN aggregated_cap_amounts aca ON b.caseid = aca.caseid
    LEFT JOIN total_capital_assets_additional tca ON aca.caseid = tca.caseid
    LEFT JOIN processed_mca pmca ON pmca.caseid = aca.caseid
    LEFT JOIN marston.referencedata r ON lc.casestatus = r.code
    LEFT JOIN max_casenotes mn ON b.caseid = mn.caseid
    LEFT JOIN max_casehistory mh ON b.caseid = mh.caseid
    WHERE (LOWER(CAST((aca.total_cap_amt = tca.CapitalfromAdditionalNotes) AS TEXT)) = 'false' 
           OR LOWER(CASE
                      WHEN la.totalavailablecapitalassets IS NULL THEN 'not in laces'
                      WHEN CAST(NULLIF(la.totalavailablecapitalassets, 'NULL') AS NUMERIC) = aca.total_cap_amt THEN 'true'
                      WHEN la.totalavailablecapitalassets = 'NULL' AND (aca.caseid IS NULL OR aca.total_cap_amt = 0) THEN 'true'
                      ELSE 'false'
                   END) = 'false' 
           OR LOWER(CAST((aca.numberofcapitalassets = 
                         CASE 
                             WHEN la.numberofavailablecapitalassets ~ '^\d+$' 
                             THEN la.numberofavailablecapitalassets::INTEGER
                             ELSE 0
                         END) AS TEXT)) = 'false');
END;
