#!/bin/bash

declare SCRIPTS_DIR=`dirname $0`
declare PLATFORM="$1"
declare ENV="$2"
#declare ROOM_NUMBER="$3"
declare WAR_NAME="$3"

declare ARCHIVE_DIR=~/jobs/${UPSTREAM_JOBNAME}/builds/${UPSTREAM_NUMBER}/archive

printf "Deploying the build artifacts from %s...\n" ${ARCHIVE_DIR}
declare -i rc=0

SERVER_CONFIG=${SCRIPTS_DIR}/${PLATFORM}/servers.sh

if [ -f "${SERVER_CONFIG}" ]; then
    printf "Sourcing in server config %s...\n" ${SERVER_CONFIG}
else
    printf "Missing Server config: %s\n" ${SERVER_CONFIG}
    printf "Cannot proceed!"
    exit 1
fi
. ${SERVER_CONFIG}
declare -a 'servers=("${'"$ENV"'_SERVERS[@]}")'

if [ ${#servers[@]} -eq 0 ]; then
    printf "Aborted! Server information missing - is server config proper?\n"
    exit 2
fi

for server in "${servers[@]}"; do
    printf "Deploying %s to %s Env - Server: %s\n" ${PLATFORM} ${ENV} ${server}
    ${SCRIPTS_DIR}/${PLATFORM}/stage.sh ${ARCHIVE_DIR} ${server} ${PLATFORM}
    rc=$?

    if [ "$rc" -gt 0 ]; then
        printf "Staging failed with rc = %d\n" $rc
        exit $rc
    fi

    printf "Changing the permission for /tmp/deploy.sh on ${server}...\n"
    ssh ${server} "chmod +x /tmp/deploy.sh && ls -ltr /tmp/deploy.sh"
    rc=$?

    if [ "$rc" -gt 0 ]; then 
        print "Can't set executable permissions for /tmp/deploy.sh on ${server}...\n"
        exit $rc
    fi

    printf "Executing the deploy script...\n"
    printf "server %s\n" ${server}
    printf "WAR_NAME %s\n" ${WAR_NAME}
    printf "PLATFORM %s\n" ${PLATFORM}
    ssh ${server} "/tmp/deploy.sh ${WAR_NAME} ${PLATFORM}"
    rc=$?

    if [ "$rc" -gt 0 ]; then
        printf "Deployer failed with rc = %d\n" $rc
        exit $rc
    fi
done

printf "%s: Done without errors.\n" $0
