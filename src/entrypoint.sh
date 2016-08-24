#!/usr/bin/env sh

set -a
set -x
set -e

: ${DB_HOST:?}
: ${DB_MASTERUSERNAME:?}
: ${DB_MASTERPASSWORD:?}
: ${CLUSTER_ID:?}

: ${DB_PASSWORD:?}

cat > /tmp/batch.sql <<EOF
CREATE DATABASE ${CLUSTER_ID}_master ;
CREATE USER '${CLUSTER_ID}'@'%' IDENTIFIED BY '${DB_PASSWORD}' ;
GRANT TRIGGER on ${CLUSTER_ID}_master.* to '${CLUSTER_ID}'@'%' ;
GRANT ALL on ${CLUSTER_ID}_master.* to '${CLUSTER_ID}'@'%' ;

FLUSH PRIVILEGES ;
EOF

cat /tmp/batch.sql

mysql -h ${DB_HOST} -u ${DB_MASTERUSERNAME} -p${DB_MASTERPASSWORD} < /tmp/batch.sql
