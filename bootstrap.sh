#!/bin/sh

set -ex

here=$(dirname "$0")
host="$1"

ssh-add ~/.ssh/id_rsa-codesearch

if ! ssh -lroot "$host" echo SUCCESS | grep -q SUCCESS; then
    ssh -lubuntu "$host" -- sh -ex <<EOF
sudo sed -i 's/^.*\(ssh-rsa\)/\1/' /root/.ssh/authorized_keys
EOF
fi

ssh -lroot $host -- sh -ex <<EOF
apt-get update
apt-get -y install puppet rsync </dev/null
EOF

$here/push "$host"
