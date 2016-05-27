#!/bin/bash
#if [ "$1" != "" ]; then
 #   echo "Using SDK Version : $1"
#CURRENT_VERSION=$1
SVN_CHECKOUT_DIR="/var/lib/jenkins/workspace/swagger-ui-CM-deploy-QA/swagger-ui"
#SVN_CHECKOUT_DIR="/var/lib/jenkins/workspace/Reader-SDK-git/swagger-ui"
GRUNT_SCRIPT="/usr/share/node/grunt-jenkins/jenkins-grunt-swagger.sh"

# Make the necessary changes in the source code
#sed -i 's#http://pxe-sdk.dev-openclass.com#https://pxe-sdk.openclass.com#g' $SVN_CHECKOUT_DIR/swagger-ui && sed -i 's#http://dragonfly.dev-openclass.com#https://dragonfly.openclass.com#g' $SVN_CHECKOUT_DIR/swagger-ui

# Run grunt tasks now
sh $GRUNT_SCRIPT

# TODO: Handle multiple stacks here.
HOST_NAMES=("pxereader-cm-qa")
TOMCAT_PATH="/var/lib/tomcat7"
        for hostname in $HOST_NAMES
        do
                echo "deploying on the QA server - $hostname"
                ssh  $hostname "sudo mkdir $TOMCAT_PATH/webapps/swagger-ui/$CURRENT_VERSION; sudo chown -R ubuntu:ubuntu $TOMCAT_PATH/webapps/swagger-ui/ "
                echo "$(date)"
		rsync -avz $SVN_CHECKOUT_DIR/* $hostname:$TOMCAT_PATH/webapps/swagger-ui
                echo "$(date)"
		rsync -avz $SVN_CHECKOUT_DIR/* $hostname:$TOMCAT_PATH/webapps/swagger-ui/$CURRENT_VERSION
        done

#else
#    echo "SDK version is missing. please provide sdk version"
#fi
