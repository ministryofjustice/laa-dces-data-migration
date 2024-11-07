create procedure export_transform_tables_to_csv()
    language plpgsql
as
$$
DECLARE
tblname TEXT;  -- Variable to hold the table name
    copy_command TEXT;  -- Variable to hold the dynamically generated \copy command
    output_directory TEXT := '/Users/abe.cetin/Documents/transform-csv/tmp/';  -- The output directory for CSV files
BEGIN
    -- Loop through all the tables in the transform schema
FOR tblname IN
SELECT tablename
FROM pg_tables
WHERE schemaname = 'transform'
    LOOP
        -- Construct the \copy statement for exporting the table to CSV
        copy_command := format(
            '\copy transform.%I TO ''%s%I.csv'' DELIMITER '','' CSV HEADER;',
            tblname, output_directory, tblname
        );

-- Output the generated \copy command
RAISE NOTICE '%', copy_command;
END LOOP;

    -- Indicate that all commands have been generated
    RAISE NOTICE 'All \copy commands generated. Please run them manually in psql.';
END;
$$;

alter procedure export_transform_tables_to_csv() owner to "cpSB74T20Z";

