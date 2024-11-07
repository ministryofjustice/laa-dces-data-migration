
DECLARE
    tblname TEXT;  -- Variable to hold the table name
    sql_query TEXT;  -- Variable to hold the dynamic COPY statement
    output_directory TEXT := '/Users/tariq.hossain/marston-csv/tmp/';  -- The output directory for CSV files
BEGIN
    -- Loop through all the tables in the anonymised schema
    FOR tblname IN
        SELECT tablename
        FROM pg_tables
        WHERE schemaname = 'anonymised' and tablename like '%laacasevisits%20240916'
    LOOP
        -- Construct the COPY statement for exporting the table to CSV
        sql_query := format(
            '\copy anonymised.%I to ''%s%I.csv'' delimiter '','' CSV HEADER',
            tblname, output_directory, tblname
        );
        
        -- Raise a notice to display the generated SQL query for debugging purposes
        RAISE NOTICE 'Executing: %', sql_query;
        
        -- Execute the dynamically generated COPY statement
        EXECUTE sql_query;
    END LOOP;
    
    -- Raise a notice indicating that the export is complete
    RAISE NOTICE 'Export complete. All tables have been exported to CSV files.';
END;
