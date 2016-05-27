#!/bin/bash
if [ "$1" != "" ]; then
#dt=$(date +"%Y.%m.%d")
echo "Using SDK Version : $1"
CURRENT_VERSION=$1
SVN_CHECKOUT_DIR="/var/lib/jenkins/workspace/Reader-SDK-git/pxereaderjs/build"
GRUNT_SCRIPT="/usr/share/node/grunt-jenkins/jenkins-grunt.sh"

# Make the necessary changes in the source code
#sed -i 's#http://pxe-sdk.dev-openclass.com#https://pxe-sdk.openclass.com#g' $SVN_CHECKOUT_DIR/pxereader.js && sed -i 's#http://dragonfly.dev-openclass.com#https://dragonfly.openclass.com#g' $SVN_CHECKOUT_DIR/pxereader.js

# Run grunt tasks now
sh $GRUNT_SCRIPT

# Handle multiple stacks here.
HOST_NAMES=("pxereader-services-qa")
TOMCAT_PATH="/var/lib/tomcat7"
        for hostname in $HOST_NAMES
        do
                echo "deploying on the QA server - $hostname"
                ssh  $hostname "sudo mkdir $TOMCAT_PATH/webapps/readersdk/; sudo chown -R ubuntu:ubuntu $TOMCAT_PATH/webapps/readersdk/ "
                ssh  $hostname "sudo mkdir $TOMCAT_PATH/webapps/readersdk/$CURRENT_VERSION; sudo chown -R ubuntu:ubuntu $TOMCAT_PATH/webapps/readersdk/ "
#		 ssh  $hostname "sudo mkdir $TOMCAT_PATH/webapps/readersdk/zoom/; sudo chown -R ubuntu:ubuntu $TOMCAT_PATH/webapps/readersdk/zoom/ "
         #       ssh  $hostname "sudo mkdir $TOMCAT_PATH/webapps/readersdk/zoom/$CURRENT_VERSION; sudo chown -R ubuntu:ubuntu $TOMCAT_PATH/webapps/readersdk/zoom/ "
  	       # rsync -avz $SVN_CHECKOUT_DIR/* $hostname:$TOMCAT_PATH/webapps/readersdk
		rsync -avz $SVN_CHECKOUT_DIR/* $hostname:$TOMCAT_PATH/webapps/readersdk/
        #       rsync -avz $SVN_CHECKOUT_DIR/* $hostname:$TOMCAT_PATH/webapps/readersdk/zoom
               rsync -avz $SVN_CHECKOUT_DIR/* $hostname:$TOMCAT_PATH/webapps/readersdk/$CURRENT_VERSION
#		rsync -avz $SVN_CHECKOUT_DIR/* $hostname:$TOMCAT_PATH/webapps/readersdk/hyphenator/
 #               rsync -avz $SVN_CHECKOUT_DIR/* $hostname:$TOMCAT_PATH/webapps/readersdk/hyphenator/$CURRENT_VERSION

        done

else
    echo "SDK version is missing. please provide sdk version"
fi
