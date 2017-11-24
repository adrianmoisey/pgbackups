#!/bin/bash -e

# usage: file_env VAR [DEFAULT]
#    ie: file_env 'XYZ_DB_PASSWORD' 'example'
# (will allow for "$XYZ_DB_PASSWORD_FILE" to fill in the value of
#  "$XYZ_DB_PASSWORD" from a file, especially for Docker's secrets feature)
file_env() {
    local var="$1"
    local fileVar="${var}_FILE"
    local def="${2:-}"
    if [ "${!var:-}" ] && [ "${!fileVar:-}" ]; then
        echo >&2 "error: both $var and $fileVar are set (but are exclusive)"
        exit 1
    fi
    local val="$def"
    if [ "${!var:-}" ]; then
        val="${!var}"
    elif [ "${!fileVar:-}" ]; then
        val="$(< "${!fileVar}")"
    fi
    export "$var"="$val"
    unset "$fileVar"
}


file_env 'PGPASSWORD'
file_env 'AWS_ACCESS_KEY_ID'
file_env 'AWS_SECRET_ACCESS_KEY'

DATE=$(date +%Y-%m-%d-%H.%M.%S)
pg_dump --schema-only | bzip2 -c > ~/$PGDATABASE-postgres-backup-schema-only-$DATE-schema.sql.bz2
pg_dump --column-inserts --data-only | bzip2 -c > ~/$PGDATABASE-postgres-backup-data-only-$DATE-data.sql.bz2
s3cmd put ~/$PGDATABASE-postgres-backup-schema-only-$DATE-schema.sql.bz2 s3://${BUCKET_NAME}/backups/
s3cmd put ~/$PGDATABASE-postgres-backup-data-only-$DATE-data.sql.bz2 s3://${BUCKET_NAME}/backups/
rm ~/$PGDATABASE-postgres-backup-schema-only-$DATE-schema.sql.bz2
rm ~/$PGDATABASE-postgres-backup-data-only-$DATE-data.sql.bz2
