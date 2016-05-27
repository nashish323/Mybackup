#!/bin/bash


printf "Deleting old files...\n"
cd /usr/local/goldengate
sudo chown -R ubuntu: .

find * -type f | xargs rm -f
rc=$?

if [ "$rc" -gt 0 ]; then
    printf "delete files failed with rc = %d\n" $rc
    exit $rc
fi

printf "Deleting old dirs...\n"
find * -type d | xargs rm -fr
rc=$?

if [ "$rc" -gt 0 ]; then
    printf "delete dir failed with rc = %d\n" $rc
    exit $rc
fi

printf "Untarring the dist...\n"
tar -xzvf /tmp/dist.tar.gz
rc=$?

if [ "$rc" -gt 0 ]; then
    printf "untar failed with rc = %d\n" $rc
    exit $rc
fi

printf "Executing npm install...\n"
npm install
rc=$?

if [ "$rc" -gt 0 ]; then
    printf "npm install failed with rc = %d\n" $rc
    exit $rc
fi

printf "Finally remove the dist and this script...\n"
rm -f /tmp/dist.tar.gz /tmp/deploy.sh

rc=$?

if [ "$rc" -gt 0 ]; then
    printf "rm rc = %d - ignored\n" $rc
fi

printf "%s: Done without errors.\n" $0
