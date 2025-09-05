#!/usr/bin/env bash
set -euo pipefail
if [ $# -lt 1 ]; then
  echo "Usage: $0 path/to/dump.sql"
  exit 1
fi
DUMP="$1"
if [ ! -f "$DUMP" ]; then
  echo "File not found: $DUMP"
  exit 1
fi

echo "Copying dump into mysql_db…"
docker cp "$DUMP" mysql_db:/dump.sql

echo "Importing into container database…"
docker exec -it mysql_db bash -lc 'mysql -u root -p"$MYSQL_ROOT_PASSWORD" "$MYSQL_DATABASE" < /dump.sql'

echo "Done."
