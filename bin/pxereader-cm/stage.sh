#!/bin/bash

declare SCRIPTS_DIR=`dirname $0`
declare ARCHIVE_DIR="$1"
declare TARGET_SERVER="$2"

printf "Copying the artifacts to %s...\n" ${TARGET_SERVER}
scp ${ARCHIVE_DIR}/pxereader-cm-services/target/pxereader-cm.war ${SCRIPTS_DIR}/deploy.sh ${TARGET_SERVER}:/tmp
exit $?
