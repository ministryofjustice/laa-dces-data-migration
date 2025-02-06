BEGIN
    PERFORM 1 FROM pg_tables WHERE schemaname = 'marston' AND tablename = 'laceskeenrichment';
    IF FOUND THEN
        EXECUTE 'TRUNCATE TABLE marston.laceskeenrichment';
    END IF;

    CREATE TABLE IF NOT EXISTS marston.laceskeenrichment (
        lacescaseid TEXT,
        maatid TEXT,
        equityinadditionalproperties NUMERIC(10, 2),
        equityinmainproperty NUMERIC(10, 2),
        capitalassets NUMERIC(10, 2),
        totalke NUMERIC(10, 2),
        totalke_minus_30000 NUMERIC(10, 2)
    );
    
    WITH mortgage_entries AS (
        SELECT 
            propertyid,
            SUM(CAST(NULLIF(mortgage, 'NULL') AS float)) AS total_mortgage
        FROM 

            marston.laalacesexperianmortgageentries_20250106

        GROUP BY 
            propertyid
    ),
    property_equity AS (
        SELECT 
            a.lacescaseid,
            SUM(
                ((CASE WHEN COALESCE(CAST(NULLIF(a.foundvalue, 'NULL') AS numeric), 0) <> 0 
                       THEN COALESCE(CAST(NULLIF(a.foundvalue, 'NULL') AS numeric), 0)
                       ELSE COALESCE(CAST(NULLIF(a.declaredvalue, 'NULL') AS numeric), 0) END) 
                - COALESCE(m.total_mortgage, COALESCE(CAST(NULLIF(a.declaredmortgage, 'NULL') AS numeric), 0)))
                * (
                    (CASE WHEN COALESCE(CAST(NULLIF(a.foundpercentageownedapplicant, 'NULL') AS numeric), 0) <> 0 
                          THEN COALESCE(CAST(NULLIF(a.foundpercentageownedapplicant, 'NULL') AS numeric), 0)
                          ELSE COALESCE(CAST(NULLIF(a.percentageownedapplicant, 'NULL') AS numeric), 0) END)
                    + (CASE WHEN COALESCE(CAST(NULLIF(a.foundpercentageownedpartner, 'NULL') AS numeric), 0) <> 0 
                            THEN COALESCE(CAST(NULLIF(a.foundpercentageownedpartner, 'NULL') AS numeric), 0)
                            ELSE COALESCE(CAST(NULLIF(a.percentageownedpartner, 'NULL') AS numeric), 0) END)
                ) / 100) FILTER (WHERE a.ismainproperty = '1') AS equityinmainproperty,
            SUM(
                ((CASE WHEN COALESCE(CAST(NULLIF(a.foundvalue, 'NULL') AS numeric), 0) <> 0 
                       THEN COALESCE(CAST(NULLIF(a.foundvalue, 'NULL') AS numeric), 0)
                       ELSE COALESCE(CAST(NULLIF(a.declaredvalue, 'NULL') AS numeric), 0) END) 
                - COALESCE(m.total_mortgage, COALESCE(CAST(NULLIF(a.declaredmortgage, 'NULL') AS numeric), 0)))
                * (
                    (CASE WHEN COALESCE(CAST(NULLIF(a.foundpercentageownedapplicant, 'NULL') AS numeric), 0) <> 0 
                          THEN COALESCE(CAST(NULLIF(a.foundpercentageownedapplicant, 'NULL') AS numeric), 0)
                          ELSE COALESCE(CAST(NULLIF(a.percentageownedapplicant, 'NULL') AS numeric), 0) END)
                    + (CASE WHEN COALESCE(CAST(NULLIF(a.foundpercentageownedpartner, 'NULL') AS numeric), 0) <> 0 
                            THEN COALESCE(CAST(NULLIF(a.foundpercentageownedpartner, 'NULL') AS numeric), 0)
                            ELSE COALESCE(CAST(NULLIF(a.percentageownedpartner, 'NULL') AS numeric), 0) END)
                ) / 100) FILTER (WHERE a.ismainproperty = '0') AS equityinadditionalproperties
        FROM 

            marston.laalacesproperties_20250106 a

        LEFT JOIN 
            mortgage_entries m
            ON m.propertyid = CAST(a.recordid AS text)
        WHERE 
            a.json_footer IS NULL
        GROUP BY 
            a.lacescaseid
    )
    
    INSERT INTO marston.laceskeenrichment
    SELECT 
        p.lacescaseid,
        b.maatid,
        COALESCE(p.equityinadditionalproperties, 0) AS equityinadditionalproperties,
        COALESCE(p.equityinmainproperty, 0) AS equityinmainproperty,
        COALESCE(CAST(NULLIF(b.totalavailablecapitalassets, 'NULL') AS numeric), 0) AS CapitalAssets,
        
        -- Calculate totalKE
        (COALESCE(p.equityinadditionalproperties, 0) 
        + COALESCE(p.equityinmainproperty, 0) 
        + COALESCE(CAST(NULLIF(b.totalavailablecapitalassets, 'NULL') AS numeric), 0)) AS totalKE,
        
        -- Calculate totalKEminus30000 if totalKE > 30000
        CASE 
            WHEN (COALESCE(p.equityinadditionalproperties, 0) 
                  + COALESCE(p.equityinmainproperty, 0) 
                  + COALESCE(CAST(NULLIF(b.totalavailablecapitalassets, 'NULL') AS numeric), 0)) > 30000
            THEN (COALESCE(p.equityinadditionalproperties, 0) 
                  + COALESCE(p.equityinmainproperty, 0) 
                  + COALESCE(CAST(NULLIF(b.totalavailablecapitalassets, 'NULL') AS numeric), 0)) - 30000
            ELSE NULL
        END AS totalKEminus30000
    FROM 
        property_equity p
    INNER JOIN 

        marston.laalacesdatawarehouse_20250106 b 

        ON b.lacescaseid = p.lacescaseid
    ORDER BY 
        p.lacescaseid;
END
