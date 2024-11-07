
DECLARE
    tblname TEXT;           -- Variable for the table name
    schema_name TEXT;       -- Variable for the schema name
    table_name TEXT;        -- Variable for the actual table name without schema
    colname TEXT;           -- Variable for the column name
    anon_type TEXT;         -- Variable for anonymisation type
    sql_query TEXT;         -- Variable for dynamic SQL
BEGIN
    -- Loop through the rows of the control table
    FOR tblname, colname, anon_type IN
        SELECT tablename, columnname, anonymisation_method
        FROM anonymised.control_table
    LOOP
        -- Extract schema name and table name, force them to lowercase
        schema_name := lower(split_part(tblname, '.', 1));  -- Force schema names to lowercase
        table_name := lower(split_part(tblname, '.', 2));   -- Force table names to lowercase
        colname := lower(colname);                          -- Force column names to lowercase

        -- Start an autonomous transaction for each table/column
        BEGIN
            -- Case 1: Standard anonymisation (random letter/number replacement)
            IF anon_type = 'standard' THEN
                sql_query := format(
                    'UPDATE %I.%I SET %I = ( ' || 
                    '  SELECT string_agg( ' ||
                    '    CASE ' ||
                    '      WHEN c ~ ''^[A-Za-z]$'' THEN chr((floor(random() * 26)::int) + 65) ' || -- Random letter (A-Z)
                    '      WHEN c ~ ''^[0-9]$'' THEN chr((floor(random() * 10)::int) + 48) ' || -- Random digit (0-9)
                    '      ELSE c ' ||
                    '    END, '''') ' ||
                    '  FROM regexp_split_to_table(%I::TEXT, '''') AS c )',
                    schema_name, table_name, colname, colname);
                RAISE NOTICE 'Generated SQL: %', sql_query;
                EXECUTE sql_query;

            -- Case 2: Keep-DOB anonymisation (random year, random month, random day)
            ELSIF anon_type = 'keep-dob' THEN
                sql_query := format(
                    'UPDATE %I.%I SET %I = CASE WHEN %I IS NOT NULL AND %I ~ ''^\d{4}-\d{2}-\d{2}$'' THEN CAST(MAKE_DATE( ' || 
                    '  EXTRACT(YEAR FROM TO_DATE(%I, ''YYYY-MM-DD''))::int - (1 + floor(random() * 10))::int, ' ||  -- Random year between 1 and 10 years earlier
                    '  (1 + floor(random() * 12))::int, ' ||                                            -- Random month between 1 and 12
                    '  (1 + floor(random() * 28))::int ' ||                                             -- Random day between 1 and 28
                    ') AS TEXT) ELSE %I END WHERE %I IS NOT NULL AND %I ~ ''^\d{4}-\d{2}-\d{2}$''',  -- Add a check for valid dates
                    schema_name, table_name, colname, colname, colname, colname, colname, colname, colname, colname);
                RAISE NOTICE 'Generated SQL: %', sql_query;
                EXECUTE sql_query;

            -- Case 3: Keep-Case anonymisation (consistent number replacement 0-9)
            ELSIF anon_type = 'keep-case' THEN
                -- Use CALL to invoke the procedure
                CALL anonymised.create_keep_case_mapping();
                
                sql_query := format(
                    'UPDATE %I.%I SET %I = ( ' ||
                    '  SELECT string_agg( ' ||
                    '    CASE ' ||
                    '      WHEN c ~ ''^[0-9]$'' THEN (SELECT new_num FROM number_mapping WHERE old_num = c) ' ||
                    '      ELSE c ' ||
                    '    END, '''') ' ||
                    '  FROM regexp_split_to_table(%I::TEXT, '''') AS c )',
                    schema_name, table_name, colname, colname);
                RAISE NOTICE 'Generated SQL: %', sql_query;
                EXECUTE sql_query;
            END IF;

            -- Commit changes after each table/column is processed
            --COMMIT;

            -- Log a message indicating the processed table and column
            RAISE NOTICE 'Successfully anonymised table: %I, column: %I', table_name, colname;

        EXCEPTION
            WHEN OTHERS THEN
                -- Rollback if there's an error, and log the error
                --ROLLBACK;
                RAISE NOTICE 'An error occurred while processing table: %I, column: %I. Skipping...', table_name, colname;
                CONTINUE;
        END;
    END LOOP;
END;
