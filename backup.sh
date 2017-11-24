#!/bin/bash -ex

export PGPASSWORD=$(cat /run/secrets/pgpassword)
export AWS_ACCESS_KEY_ID=$(cat /run/secrets/aws_access_key_id)
export AWS_SECRET_ACCESS_KEY=$(cat /run/secrets/aws_secret_access_key)

DATE=$(date +%Y-%m-%d-%H.%M.%S)
pg_dump --schema-only | bzip2 -c > ~/$PGDATABASE-postgres-backup-data-only-$DATE-schema.sql.bz2
pg_dump --column-inserts --data-only | bzip2 -c > ~/$PGDATABASE-postgres-backup-data-only-$DATE-data.sql.bz2
s3cmd put ~/$PGDATABASE-postgres-backup-data-only-$DATE-schema.sql.bz2 s3://${BUCKET_NAME}/backups/
s3cmd put ~/$PGDATABASE-postgres-backup-data-only-$DATE-data.sql.bz2 s3://${BUCKET_NAME}/backups/
rm ~/$PGDATABASE-postgres-backup-data-only-$DATE-schema.sql.bz2
rm ~/$PGDATABASE-postgres-backup-data-only-$DATE-data.sql.bz2
