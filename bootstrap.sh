#!/bin/sh

set -ex

here=$(dirname "$0")
host="$1"

ssh -lroot $host -- sh -ex <<EOF
apt-get update
apt-get -y install puppet rsync </dev/null
EOF

$here/push "$host"
