#!/bin/bash
if [ "$1" != "" ]; then
#dt=$(date +"%Y.%m.%d")
    echo "Using SDK Version : $1"
CURRENT_VERSION=$1
SVN_CHECKOUT_DIR="/var/lib/jenkins/workspace/Reader-SDK-git/pxereaderjs/build"
GRUNT_SCRIPT="/usr/share/node/grunt-jenkins/jenkins-grunt-prod.sh"

# Run Grunt Scripts 
sh $GRUNT_SCRIPT

# Handle multiple stacks here.
HOST_NAMES=("pxereader-services-stack1-prod1 pxereader-services-stack1-prod2 pxereader-services-stack1-prod3 pxereader-services-stack1-prod4")
TOMCAT_PATH="/var/lib/tomcat7"
        for hostname in $HOST_NAMES
        do
                echo "deploying on the PRD servers - $hostname"
	        ssh  $hostname "sudo mkdir $TOMCAT_PATH/webapps/readersdk/; sudo chown -R ubuntu:ubuntu $TOMCAT_PATH/webapps/readersdk/ "
                ssh  $hostname "sudo mkdir $TOMCAT_PATH/webapps/readersdk/$CURRENT_VERSION; sudo chown -R ubuntu:ubuntu $TOMCAT_PATH/webapps/readersdk/ "
               # rsync  -avz $SVN_CHECKOUT_DIR/* $hostname:$TOMCAT_PATH/webapps/readersdk
		rsync  -avz $SVN_CHECKOUT_DIR/* $hostname:$TOMCAT_PATH/webapps/readersdk/
                rsync  -avz $SVN_CHECKOUT_DIR/* $hostname:$TOMCAT_PATH/webapps/readersdk/$CURRENT_VERSION
        done

else
    echo "SDK version is missing. please provide sdk version"
fi
