#!/bin/bash

function deploy() {
        stack_param=$1[@]
        cmd=$2
        env=$3
        stack=("${!stack_param}")

        for node in "${stack[@]}"
	do
                echo "ssh $node \"$cmd\""
                ssh $node "$cmd"
                if [ $? -eq 0 ]; then
                        echo "Deploy Succeeded on $node!"
                else
                        echo "Deploy failed on $node!"
                        exit 1
                fi
        done
}


if [ $1 == "DEV" ];
then
        declare -a STACK_A=(pxe-missionbay-dev nextext-api-dev)
elif [ $1 == "QA" ];
then
        declare -a STACK_A=(pxe-missionbay-qa)
elif [ $1 == "PQA" ];
then
        declare -a STACK_A=(pxe-missionbay-stack1-pqa1 pxe-missionbay-stack1-pqa2 pxe-missionbay-stack1-pqa3 pxe-missionbay-stack1-pqa4)
elif [ $1 == "PROD" ];
then
        declare -a STACK_A=(pxe-missionbay-stack1-prod1 pxe-missionbay-stack1-prod2 pxe-missionbay-stack1-prod3 pxe-missionbay-stack1-prod4)
        declare -a STACK_B=(pxe-missionbay-stack2-prod1 pxe-missionbay-stack2-prod2 pxe-missionbay-stack2-prod3 pxe-missionbay-stack2-prod4)
fi

DIRECTORY="/usr/share/tomcat7/bin/"
SVN_USER="vrajasw"
SVN_PASS="Vrajasw070144"
SVN_REPO="http://subversion.pearsoncmg.com/data/reader-sdk/trunk/devops/"

UPD_CMD="svn export --force --username $SVN_USER --password $SVN_PASS --non-interactive $SVN_REPO $DIRECTORY"

# Update STACK_A hosts
if [ "$STACK" == "STACK_A" ]; then
        deploy STACK_A "$UPD_CMD" "$1"
fi

# Update STACK_B hosts
if [ "$STACK" == "STACK_B" ]; then
       deploy STACK_B "$UPD_CMD" "$1"
fi

exit 0
