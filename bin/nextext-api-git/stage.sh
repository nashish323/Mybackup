#!/bin/bash

declare SCRIPTS_DIR=`dirname $0`
declare ARCHIVE_DIR="$1"
declare TARGET_SERVER="$2"

printf "Copying the artifacts to %s...\n" ${TARGET_SERVER}
scp ${ARCHIVE_DIR}/nextext/nextext-api/target/nextext-api-1.0.war ${SCRIPTS_DIR}/deploy.sh ${TARGET_SERVER}:/tmp/
exit $?
