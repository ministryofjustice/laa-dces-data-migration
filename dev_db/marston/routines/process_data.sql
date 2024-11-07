
DECLARE
    -- Cursor declarations
    get_cases_metadata CURSOR FOR
        SELECT dsf.dataload_file_audit_id,
               dfa.filename AS long_filename, 
               regexp_replace(regexp_replace(dfa.filename, '^.*/', ''), '\.csv$', '') AS filename,
               dfa.batchid, 
               dfa.tablename AS sourcetablename,
               dfa.json_footer->>'rowcount' AS rowcount,
               dfa.json_footer->>'deltastartdate' AS deltastartdate,
               dfa.json_footer->>'deltaenddate' AS deltaenddate
        FROM marston.dataload_stabilised_files dsf
        JOIN marston.dataload_file_audit dfa ON dsf.dataload_file_audit_id = dfa.id
        WHERE dsf.cases_seq IS NOT NULL		
        ORDER BY dsf.cases_seq ASC;

    filename_record RECORD;
    entity_record RECORD;
    transform_record RECORD;
    data_row RECORD;
    query TEXT;
    drop_table_cmd TEXT;
    create_table_cmd TEXT;
    insert_cmd TEXT;
BEGIN
    RAISE NOTICE 'Starting the process_data procedure.';

    -- Open the first cursor
    OPEN get_cases_metadata;
    FETCH get_cases_metadata INTO filename_record;
    IF NOT FOUND THEN
        RAISE NOTICE 'No records found in get_cases_metadata cursor.';
        CLOSE get_cases_metadata;
        RETURN;
    END IF;

    RAISE NOTICE 'Processing file with ID: %, Filename: %, Batch ID: %, Source Table: %',
                  filename_record.dataload_file_audit_id, 
                  filename_record.filename,
                  filename_record.batchid, 
                  filename_record.sourcetablename;

    -- Debugging the fetched record
    RAISE NOTICE 'Filename after processing: %', filename_record.filename;

    -- Find the entity for the filename
    RAISE NOTICE 'Opening second cursor to find entity for filename: %', filename_record.filename;

    FOR entity_record IN
        SELECT entity_name
        FROM marston.dataload_filename_entity_mapping
        WHERE filename_string_match = filename_record.filename
    LOOP
        RAISE NOTICE 'Entity found: %', entity_record.entity_name;

        -- Find the transform table for the entity
        RAISE NOTICE 'Opening third cursor to find transform table for entity: %', entity_record.entity_name;

        FOR transform_record IN
            SELECT transform1_table
            FROM marston.dataload_entity
            WHERE entity_name = entity_record.entity_name
        LOOP
            RAISE NOTICE 'Transforming data to destination table: %', transform_record.transform1_table;

            -- Prepare and display the DROP TABLE command
            drop_table_cmd := 'DROP TABLE IF EXISTS marston.' || transform_record.transform1_table;
            RAISE NOTICE 'Executing SQL: %', drop_table_cmd;
            EXECUTE drop_table_cmd;

            -- Prepare and display the CREATE TABLE command
            create_table_cmd := 'CREATE TABLE marston.' || transform_record.transform1_table || 
                                ' (LIKE ' || filename_record.sourcetablename || ' INCLUDING ALL)';
            RAISE NOTICE 'Executing SQL: %', create_table_cmd;
            EXECUTE create_table_cmd;

            RAISE NOTICE 'Destination table % created.', transform_record.transform1_table;

            -- Process the first record (already fetched)
            -- Data validation and copying for the first record
            query := 'SELECT * FROM ' || filename_record.sourcetablename;
            RAISE NOTICE 'Validating data in source table: %', filename_record.sourcetablename;
            RAISE NOTICE 'Executing SQL for validation: %', query;

            FOR data_row IN EXECUTE query
            LOOP
                IF data_row IS NULL THEN
                    RAISE EXCEPTION 'Data validation failed for file: %', filename_record.filename;
                END IF;
            END LOOP;

            RAISE NOTICE 'Data validation completed for file: %', filename_record.filename;

            insert_cmd := 'INSERT INTO marston.' || transform_record.transform1_table || 
                          ' SELECT * FROM ' || filename_record.sourcetablename;
            RAISE NOTICE 'Executing SQL: %', insert_cmd;
            EXECUTE insert_cmd;

            RAISE NOTICE 'Data copied from % to %', filename_record.sourcetablename, transform_record.transform1_table;
        END LOOP;
    END LOOP;

    -- Process the rest of the records
    LOOP
        FETCH get_cases_metadata INTO filename_record;
        EXIT WHEN NOT FOUND;

        RAISE NOTICE 'Processing file with ID: %, Filename: %, Batch ID: %, Source Table: %',
                      filename_record.dataload_file_audit_id, 
                      filename_record.filename,
                      filename_record.batchid, 
                      filename_record.sourcetablename;

        -- Data validation and copying for the rest of the records
        query := 'SELECT * FROM ' || filename_record.sourcetablename;
        RAISE NOTICE 'Validating data in source table: %', filename_record.sourcetablename;
        RAISE NOTICE 'Executing SQL for validation: %', query;

        FOR data_row IN EXECUTE query
        LOOP
            IF data_row IS NULL THEN
                RAISE EXCEPTION 'Data validation failed for file: %', filename_record.filename;
            END IF;
        END LOOP;

        RAISE NOTICE 'Data validation completed for file: %', filename_record.filename;

        insert_cmd := 'INSERT INTO marston.' || transform_record.transform1_table || 
                      ' SELECT * FROM ' || filename_record.sourcetablename;
        RAISE NOTICE 'Executing SQL: %', insert_cmd;
        EXECUTE insert_cmd;

        RAISE NOTICE 'Data copied from % to %', filename_record.sourcetablename, transform_record.transform1_table;
    END LOOP;

    CLOSE get_cases_metadata;
    RAISE NOTICE 'Process completed..';
END;
