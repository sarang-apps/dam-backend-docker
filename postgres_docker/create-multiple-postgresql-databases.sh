#!/bin/bash

set -e
set -u

function create_user_and_database() {
	local database=$(echo $1 | tr ',' ' ' | awk  '{print $1}')
	local owner=$(echo $1 | tr ',' ' ' | awk  '{print $2}')
	echo "  Creating user and database '$database'"
	psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" <<-EOSQL
		CREATE DATABASE $database
			WITH 
			OWNER = $owner
			ENCODING = 'UTF8'
			LC_COLLATE = 'en_US.utf8'
			LC_CTYPE = 'en_US.utf8'
			TABLESPACE = pg_default
			CONNECTION LIMIT = -1;
	    GRANT ALL PRIVILEGES ON DATABASE $database TO $owner;
	EOSQL
	psql -d $database -c "CREATE EXTENSION zombodb;"
}

if [ -n "$POSTGRES_MULTIPLE_DATABASES" ]; then
	echo "Multiple database creation requested: $POSTGRES_MULTIPLE_DATABASES"
	for db in $(echo $POSTGRES_MULTIPLE_DATABASES | tr ' ' ' '); do
		create_user_and_database $db
	done
	echo "Multiple databases created"
fi
