# Approach
- delete any tables using procedure public.drop_hardcoded_tables
- we copied the set of tables from the marston schema to a new anonymisation schema using a procedure: anonymised.copy_tables_to_anonymised
- we created a procedure called anonymised.anonymise_data that loops through a set of columns of specific tables. This in turn calls another procedure anonymised.create_keep_case_mapping, depending on the anonymisation met
the tables and columns to be anonymised are contained in a table called ANONYMISATION.CONTROL_TABLE. This table contains:
  - table name
  - column name
  - anonymisation method

- If the Anonymisation method is:
  - standard: applies to Alphanumeric columns (e.g., IDs, names, etc.).
  - - For each letter in the column value, replace it with a random letter from A-Z
  - - For each digit in the column value, replace it with a random digit from 0-9.
  - - Other characters (non-alphanumeric) are left unchanged.
  - keep-case: application to columns containing numeric identifiers (e.g., case numbers, ID numbers) where relationships between the values must be preserved across the dataset.
  - - Consistently replace each digit (0-9) with a random but unique mapping from 0-9.
  - - The same digit is replaced by the same new digit across the entire dataset to ensure consistency in relationships.
  - keep-dob: applies to Date of Birth columns or other date-related fields.
  - - Year: Subtract a random number of years between 1 and 10 from the original date.
  - - Month: Replace the original month with a randomly generated month between 1 and 12.
  - - Day: Replace the original day with a random day between 1 and 28 (to avoid issues with differing month lengths).

- Finally to export the data to CSV we ran a procedure called anonymised.generate_copy_statements which loops through tables in the anonymised scheme and constructs a copy statement which gets output to the terminal.
  - The output can be copied into a file e.g. copy_statements.txt
  - and then the file can be run from psql like this:
  - - psql -h localhost -p 5432 -U <dbuser> -W -d laa_dces_data_migration_dev_db -f /Users/tariq.hossain/marston-csv/tmp/copy_statements.txt
