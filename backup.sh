#!/bin/bash -ex

export DATE=$(date +%Y-%m-%d-%H.%M.%S)
pg_dump --column-inserts --data-only | bzip2 -c > ~/$PGDATABASE-postgres-backup-data-only-$DATE.sql.bz2
s3cmd put ~/$PGDATABASE-postgres-backup-data-only-$DATE.sql.bz2 s3://${BUCKET_NAME}/backups/
rm ~/$PGDATABASE-postgres-backup-data-only-$DATE.sql.bz2
