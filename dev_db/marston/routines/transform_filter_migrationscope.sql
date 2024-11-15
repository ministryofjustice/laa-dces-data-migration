-- This script checks if the `MigrationScope` table exists in the `marston` schema. If it exists, the table is truncated; if not, it creates the table.
-- The script then populates the `MigrationScope` table with data from multiple sources.
-- It aggregates maximum loaded dates from `laacasenotes_20241018` and `laacasehistory_20241018`, and selects relevant `caseid`, `maatid`, and `lacescaseid` values from `laacasedetails_20241018`.
-- Records are filtered based on whether the case is open or if the latest activity date in case notes, history, or statusdate is later than January 31, 2023.
-- Additional criteria added to filter clientcasereference https://dsdmoj.atlassian.net/browse/DCES-564
-- 151124 - AC: statuscodedate added as per DCES-599

DO $$
BEGIN
    -- Check if MigrationScope table exists in marston schema, if exists truncate it, if not create it
    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = 'marston' AND table_name = 'migrationscope') THEN
        TRUNCATE TABLE marston.migrationscope;
    ELSE
        CREATE TABLE marston.migrationscope (
            caseid VARCHAR,
            maatid VARCHAR,
            lacescaseid VARCHAR
        );
    END IF;

    -- Populate the MigrationScope table
    WITH 
        -- Aggregate maximum loadedon dates from laacasenotes_20241018
        max_casenotes AS (
            SELECT 
                caseid, 
                MAX(loadedon) AS max_loadedon_casenotes
            FROM 
                marston.laacasenotes_20241018
            GROUP BY 
                caseid
        ),
        max_casehistory AS (
            SELECT 
                caseid, 
                MAX(loadedon) AS max_loadedon_casehistory
            FROM 
                marston.laacasehistory_20241018
            GROUP BY 
                caseid
        )
    INSERT INTO marston.migrationscope (caseid, maatid, lacescaseid)
    SELECT a.caseid, a.clientcasereference, dwh.lacescaseid
    FROM marston.laacasedetails_20241018 a
    LEFT JOIN max_casenotes mn ON a.caseid = mn.caseid
    LEFT JOIN max_casehistory mh ON a.caseid = mh.caseid
    LEFT JOIN marston.laalacesdatawarehouse_20241018 dwh ON dwh.maatid = a.clientcasereference
    WHERE (a.openclosedstatus = 'OPEN'
        OR GREATEST(
            COALESCE(mn.max_loadedon_casenotes, '1900-01-01'::timestamp),
            COALESCE(mh.max_loadedon_casehistory, '1900-01-01'::timestamp),
            COALESCE(a.statusdate::timestamp, '1900-01-01'::timestamp)  -- 151124: Added for DCES-599
        ) > '2023-01-31')
      -- 06112024: Criteria below added for DCES-563  
      AND (NOT (a.clientcasereference !~ '^\d{7}$')
        OR a.clientcasereference = 'A1043EL')
      ;
END $$;
