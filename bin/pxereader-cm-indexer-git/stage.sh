#!/bin/bash

declare SCRIPTS_DIR=`dirname $0`
ARCHIVE_DIR='/var/lib/jenkins/workspace/pxereader-cm-indexer-git/pxereader-cm/pxereader-cm-indexer/target'
declare TARGET_SERVER="$2"

printf "Copying the artifacts to %s...\n" ${TARGET_SERVER}
printf "Scripts folder is %s...\n" ${SCRIPTS_DIR}
scp ${ARCHIVE_DIR}/pxereader-cm-indexer-1.0.0-SNAPSHOT-jar-with-dependencies.jar ${SCRIPTS_DIR}/deploy.sh ${TARGET_SERVER}:/tmp/
exit $?
