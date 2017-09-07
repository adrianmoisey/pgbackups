#!/bin/bash -ex

export DATE=$(date +%Y-%m-%d-%H.%M.%S)
pg_dump --column-inserts --data-only | bzip2 -c > ~/postgres-backup-data-only-$DATE.sql.bz2
s3cmd put ~/postgres-backup-data-only-$DATE.sql.bz2 s3://${BUCKET_NAME}/backups/
rm ~/postgres-backup-data-only-$DATE.sql.bz2
