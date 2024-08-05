#!/bin/bash

# Ensure PGPASSWORD is set in the environment
if [ -z "$PGPASSWORD" ]; then
    echo "Error: PGPASSWORD environment variable is not set." >&2
    exit 1
fi

# Check if PGUSER is set, if not, print an error message and exit
if [ -z "$PGUSER" ]; then
    echo "Error: PGUSER is not set" >&2
    exit 1
fi

# Check if BATCH_SIZE is set, if not, print an error message and exit
if [ -z "$BATCH_SIZE" ]; then
    echo "Error: BATCH_SIZE is not set" >&2
    exit 1
fi

echo "BATCH_SIZE=$BATCH_SIZE"

# Check if S3_PREFIX is set, if not, print an error message and exit
if [ -z "$S3_PREFIX" ]; then
    echo "Error: S3_PREFIX is not set" >&2
    exit 1
fi

# Check if the last character of S3_PREFIX is a '/'
if [[ "${S3_PREFIX: -1}" != "/" ]]; then
    echo "Error: S3_PREFIX must end with a '/'" >&2
    exit 1
fi

echo "S3_PREFIX=$S3_PREFIX"

# Function to update PostgreSQL record
update_db_record() {
    local id=$1
    local file_exists=$2
    echo "Updating record with id $id to file_exists=$file_exists" >&2
    psql -h "$PGHOST" -d "$PGDATABASE" -U "$PGUSER" -c "UPDATE marston.test_attachments SET file_exists = '$file_exists' WHERE id = $id" >/dev/null 2>&1
    if [[ $? -ne 0 ]]; then
        echo "Error: Failed to update record with id $id" >&2
    fi
}

# Function to handle S3 check
check_s3_file() {
    local file_path=$1
    echo "Checking if file exists in S3 at path s3://$S3_BUCKET/$S3_PREFIX$file_path" >&2
    aws s3 ls "s3://$S3_BUCKET/$S3_PREFIX$file_path" --recursive --profile=$DCES_ADMIN_USER >/dev/null 2>&1
    return $?
}

# Function to handle errors
handle_error() {
    local error_message=$1
    echo "Error: $error_message" >&2
    # Optionally: log error to a file or monitoring system
}

# Check PostgreSQL connection before proceeding
echo "Checking PostgreSQL connection..." >&2
psql -h "$PGHOST" -d "$PGDATABASE" -U "$PGUSER" -c "SELECT 1" >/dev/null 2>&1
if [[ $? -ne 0 ]]; then
    handle_error "Unable to connect to PostgreSQL database."
    exit 1
fi

# Main processing loop in batches
offset=0
while : ; do
    echo "Fetching records with offset=$offset and batch size=$BATCH_SIZE" >&2
    # Fetch a batch of records from PostgreSQL
    records=$(psql -h "$PGHOST" -d "$PGDATABASE" -U "$PGUSER" -t -A -F '|' -c "COPY (SELECT id, fullname || '/' || name as file_path FROM marston.test_attachments WHERE file_exists IS NULL or file_exists = false LIMIT $BATCH_SIZE OFFSET $offset) TO STDOUT WITH CSV DELIMITER '|'")

    # Break the loop if no records are returned
    if [[ -z "$records" ]]; then
        echo "No more records to process. Exiting loop." >&2
        break
    fi

    # Process each record in the batch
    while IFS='|' read -r id file_path; do
        echo "Processing record id=$id with file_path=$file_path" >&2
        # Check if the file exists in S3
        if check_s3_file "$file_path"; then
            file_exists="true"
            echo "File exists in S3." >&2
        else
            file_exists="false"
            echo "File does not exist in S3." >&2
        fi

        # Update PostgreSQL record
        update_db_record "$id" "$file_exists"
    done <<< "$records"

    # Increment offset for the next batch
    offset=$((offset + BATCH_SIZE))
done
