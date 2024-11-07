
DECLARE
    src_table TEXT;  -- Variable to hold the schema-qualified table name from the source column
    table_name TEXT;  -- Variable to hold the table name only (without schema)
    create_table_sql TEXT;  -- Variable to store the dynamic SQL for creating the new table
    copy_data_sql TEXT;  -- Variable to store the dynamic SQL for copying data
BEGIN
    -- Loop through the rows in the source column of the source_table_list table
    FOR src_table IN 
        SELECT lower(tablename) FROM marston.dataload_file_audit where comment='September 16th files'
    LOOP
        -- Extract the table name without the schema (e.g., LAADefaultersWelfare_20240916)
        table_name := split_part(src_table, '.', 2);

        -- 1. Create the new table in the 'anonymised' schema with the same structure
        create_table_sql := format('CREATE TABLE IF NOT EXISTS anonymised.%I (LIKE %s INCLUDING ALL)', table_name, src_table);
        EXECUTE create_table_sql;

        -- 2. Copy the data from the source table to the new anonymised table
        copy_data_sql := format('INSERT INTO anonymised.%I SELECT * FROM %s', table_name, src_table);
        EXECUTE copy_data_sql;

    END LOOP;
END;
