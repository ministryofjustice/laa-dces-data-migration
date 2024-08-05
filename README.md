# laa-dces-data-migration
## dces-extract-load-csv-files
This application gets files from an s3 bucket, adds a batch id and loads the data into the postgres database

## dces-check-attachment-exists
This application queries the attachment metadata in postgres. In the table will be a location to the physical attachment. The application checks the s3 bucket in the location specified. If a matching file exists then the application updates the file_exists column in the postgres table to TRUE so it doesnt try to recheck again, or FALSE when there is no matching file.

