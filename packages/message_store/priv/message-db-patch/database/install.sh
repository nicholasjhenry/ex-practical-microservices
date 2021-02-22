#!/usr/bin/env bash

set -e

function script_dir {
  val="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
  echo "$val" | sed 's/-patch//'
}

base=$(script_dir)

echo
echo "Installing Database"
echo "Version: $(cat $base/VERSION.txt)"
echo "= = ="

if [ -z ${DATABASE_NAME+x} ]; then
  database=message_store
  echo "DATABASE_NAME is not set. Using: $database."
  export DATABASE_NAME=$database
else
  database=$DATABASE_NAME
fi


if [ -z ${CREATE_DATABASE+x} ]; then
  CREATE_DATABASE="on"
fi

create_database=true
if [ "$CREATE_DATABASE" = "off" ] ; then
  create_database=false
fi


if [ -z ${PGOPTIONS+x} ]; then
  export PGOPTIONS='-c client_min_messages=warning'
fi

function create-user {
  base=$(script_dir)

  echo "» message_store role"
  psql postgres -q -f $base/roles/message-store.sql
}

function create-database {
  echo "» $database database"
  createdb $database
}

function create-schema {
  echo "» message_store schema"
  psql $database -q -f $base/schema/message-store.sql
}

function create-extensions {
  base=$(script_dir)

  echo "» pgcrypto extension"
  psql $database -q -f $base/extensions/pgcrypto.sql
}

function create-table {
  base=$(script_dir)

  echo "» messages table"
  psql $database -q -f $base/tables/messages.sql
}

echo

echo "Skipping creating User"
echo "- - -"
# create-user
echo

echo "Creating Database"
echo "- - -"
if [ "$create_database" = true ] ; then
  create-database
else
  echo "Database creation is deactivated. Not creating the database."
fi
echo

echo "Creating Schema"
echo "- - -"
create-schema
echo

echo "Creating Extensions"
echo "- - -"
create-extensions
echo

echo "Creating Table"
echo "- - -"
create-table
echo

# Install functions
source $base/install-functions.sh

# Install indexes
source $base/install-indexes.sh

# Install views
source $base/install-views.sh

# Install privileges
source $base/install-privileges.sh

echo "= = ="
echo "Done Installing Database"
echo "Version: $(cat $base/VERSION.txt)"
echo
