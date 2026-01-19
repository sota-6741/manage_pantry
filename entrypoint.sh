#!/bin/sh
set -e

# pid が残っていたら削除
rm -f tmp/pids/server.pid

exec "$@"
