#!/bin/bash

# Check if PGUSER is set, if not, print an error message and exit
if [ -z "$PGUSER" ]; then
    echo "Error: PGUSER is not set"
    exit 1
fi

# Check if BATCH_ID is set, if not, print an error message and exit
if [ -z "$BATCH_ID" ]; then
    echo "Error: BATCH_ID is not set"
    exit 1
fi

echo BATCH_ID=$BATCH_ID

# Check if S3_PREFIX is set, if not, print an error message and exit
if [ -z "$S3_PREFIX" ]; then
    echo "Error: S3_PREFIX is not set"
    exit 1
fi

# Check if the last character of S3_PREFIX is a '/'
if [[ "${S3_PREFIX: -1}" != "/" ]]; then
    echo "Error: S3_PREFIX must end with a '/'"
    exit 1
fi

echo S3_PREFIX=$S3_PREFIX

# Check if FILE_PATTERN is set, if not, print an error message and exit
if [ -z "$FILE_PATTERN" ]; then
    echo "Error: FILE_PATTERN is not set"
    exit 1
fi

echo FILE_PATTERN=$FILE_PATTERN

# Define variables
CSV_DIR="/app/data/"
TO_BE_PROCESSED_DIR="/app/to-be-processed/"
PROCESSED_DIR="/app/processed/"
SQL_FILE="$TO_BE_PROCESSED_DIR/outputfile.sql"

# Ensure the to-be-processed directory exists
mkdir -p "$TO_BE_PROCESSED_DIR"
mkdir -p "$PROCESSED_DIR"

# Download files from S3
aws s3 cp s3://$S3_BUCKET/$S3_PREFIX $CSV_DIR --recursive --exclude "*" --include "$FILE_PATTERN*.csv" --profile=dces-admin-user-dev

# Function to strip BOM from a file
strip_bom() {
    local file="$1"
    local tmp_file="${file}.nobom"
    awk 'NR==1{sub(/^\xef\xbb\xbf/,"")}{print}' "$file" > "$tmp_file"
    mv "$tmp_file" "$file"
}

# Function to remove carriage return characters
remove_carriage_returns() {
    local file="$1"
    sed -i 's/\r//g' "$file"
}

# Initialize SQL file (create a new file or truncate the existing one)
> "$SQL_FILE"

# Loop through CSV files in the directory
for CSV_FILE in "$CSV_DIR"$FILE_PATTERN*.csv; do

    # Strip BOM from the CSV file
    strip_bom "$CSV_FILE"

    # Remove carriage return characters
    remove_carriage_returns "$CSV_FILE"

    # Extract base table name from CSV file name
    BASE_TABLE_NAME=$(basename "$CSV_FILE" | sed 's/^file1_//' | sed 's/\.csv$//')

    # Incorporate batch ID into the table name
    TABLE_NAME="marston.${BASE_TABLE_NAME}_${BATCH_ID}"

    echo $TABLE_NAME

    # Extract header from CSV file
    HEADER=$(head -n 1 "$CSV_FILE")

    # Convert header to lowercase and replace spaces with underscores
    HEADER=$(echo "$HEADER" | tr '[:upper:]' '[:lower:]' | sed 's/ /_/g')

    # Add batch_id column to the beginning of the header and json_footer column at the end
    HEADER="batch_id,${HEADER},json_footer"

    # Create SQL column definitions
    COLUMNS=$(echo "$HEADER" | awk -F, '{ for(i=1; i<=NF; i++) print $i (i==NF ? " jsonb," : " text,") }' | sed '$ s/,$//')

    # Create SQL statements
    DROP_TABLE_SQL="drop table if exists $TABLE_NAME;\n"
    CREATE_TABLE_SQL="create table $TABLE_NAME (\n$COLUMNS\n);\n"

    # Create a temporary CSV file with the batch ID column in the to-be-processed directory
    TMP_CSV_FILE="$TO_BE_PROCESSED_DIR${BASE_TABLE_NAME}_${BATCH_ID}_with_batch_id.csv"
    {
        echo "$HEADER"
        awk -v batch_id="$BATCH_ID" -F, 'NR > 1 { print batch_id "," $0 "," }' "$CSV_FILE" | head -n -1
    } > "$TMP_CSV_FILE"

    # Extract the footer
    FOOTER=$(tail -n 1 "$CSV_FILE")
    FOOTER_JSON=$(echo "$FOOTER" | awk -F, '{printf "{ \"createdate\": \"%s\", \"weeknum\": \"%s\", \"daynum\": \"%s\", \"rowcount\": \"%s\", \"deltastartdate\": \"%s\", \"deltaenddate\": \"%s\" }", $1, $2, $3, $4, $5, $6}')

    # Properly escape the double quotes for the JSON string
    FOOTER_JSON_ESCAPED=$(echo "$FOOTER_JSON" | sed 's/"/""/g')

    # Get the number of columns (including the new ones for batch_id and json_footer)
    NUM_COLUMNS=$(echo "$HEADER" | awk -F, '{print NF}')

    # Create an empty row with just the footer JSON in the last column
    EMPTY_COLUMNS=$(for i in $(seq 1 $((NUM_COLUMNS-2))); do printf ","; done)
    echo "$BATCH_ID$EMPTY_COLUMNS,\"$FOOTER_JSON_ESCAPED\"" >> "$TMP_CSV_FILE"

    # Create the COPY SQL statement
    COPY_SQL="copy $TABLE_NAME from '$TMP_CSV_FILE' delimiter ',' CSV HEADER;\n"
    BS='\'

    # Write SQL statements to the SQL file
    {
        echo -e "$DROP_TABLE_SQL"
        echo -e "$CREATE_TABLE_SQL"
        echo -n $BS
        echo -e $COPY_SQL

        # Add an insert statement for the logging table
        #echo "insert into $LOGGING_TABLE (filename, batchid, tablename, createdate, weeknum, daynum, rowcount, deltastartdate, deltaenddate) values ('$CSV_FILE', '$BATCH_ID', '$TABLE_NAME', '$FOOTER_JSON'::jsonb->>'createdate', '$FOOTER_JSON'::jsonb->>'weeknum', '$FOOTER_JSON'::jsonb->>'daynum', '$FOOTER_JSON'::jsonb->>'rowcount', '$FOOTER_JSON'::jsonb->>'deltastartdate', '$FOOTER_JSON'::jsonb->>'deltaenddate');"
        echo "insert into marston.dataload_file_audit (filename, batchid, tablename, json_footer) values ('$S3_PREFIX-$CSV_FILE', '$BATCH_ID', '$TABLE_NAME', '$FOOTER_JSON'::jsonb);"
     } >> "$SQL_FILE"

done

# Output the generated SQL file
cat "$SQL_FILE"

# Execute the SQL file to load data into PostgreSQL
psql -h "$PGHOST" -p "$PGPORT" -U "$PGUSER" -d "$PGDATABASE" -W -f "$SQL_FILE"

# Check if the psql command was successful
if [ $? -eq 0 ]; then
  # Move processed files to the S3 processed directory
  for CSV_FILE in "$CSV_DIR"$FILE_PATTERN*.csv; do
    BASE_FILE_NAME=$(basename "$CSV_FILE")
 #   aws s3 cp s3://$S3_BUCKET/$S3_PREFIX"$BASE_FILE_NAME" s3://$S3_BUCKET/LAA/$S3_PREFIX"processed/" --profile=dces-admin-user-dev
 #   aws s3api delete-object --bucket $S3_BUCKET --key LAA/data/"$BASE_FILE_NAME" --profile=dces-admin-user-dev
    echo "$BASE_FILE_NAME" potentially processed - pls verify table in database
  done
else
  echo "Unable to connect to DB via psql - pls verify logs."
fi
