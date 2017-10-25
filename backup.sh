#!/bin/bash -ex

DATE=$(date +%Y-%m-%d-%H.%M.%S)
pg_dump --schema-only | bzip2 -c > ~/$PGDATABASE-postgres-backup-data-only-$DATE-schema.sql.bz2
pg_dump --column-inserts --data-only | bzip2 -c > ~/$PGDATABASE-postgres-backup-data-only-$DATE-data.sql.bz2
s3cmd put ~/$PGDATABASE-postgres-backup-data-only-$DATE-schema.sql.bz2 s3://${BUCKET_NAME}/backups/
s3cmd put ~/$PGDATABASE-postgres-backup-data-only-$DATE-data.sql.bz2 s3://${BUCKET_NAME}/backups/
rm ~/$PGDATABASE-postgres-backup-data-only-$DATE-schema.sql.bz2
rm ~/$PGDATABASE-postgres-backup-data-only-$DATE-data.sql.bz2
