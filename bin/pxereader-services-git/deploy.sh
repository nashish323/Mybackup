#!/bin/bash

function deployTomcat {
typeset warName=$1
TOMCAT_HOME=/var/lib/tomcat7
TOMCAT_WEBAPPS=$TOMCAT_HOME/webapps
printf "Shut down Tomcat7...\n"
sudo service tomcat7 stop
rc=$?

if [ "$rc" -gt 0 ]; then
printf "tomcat stop failed with rc = %d\n" $rc
exit $rc
fi

printf "Deleting old files...\n"
sudo rm -fr $TOMCAT_WEBAPPS/${warName}
rc=$?

if [ "$rc" -gt 0 ]; then
printf "delete dir failed with rc = %d\n" $rc
exit $rc
fi

printf "Unzip the dist...\n"
cd $TOMCAT_WEBAPPS
sudo chown ubuntu: .

mkdir ${warName}
unzip /tmp/${warName}.war -d ./${warName}
rc=$?

if [ "$rc" -gt 0 ]; then
printf "untar failed with rc = %d\n" $rc
exit $rc
fi

printf "Finally remove the dist and this script...\n"
rm -f /tmp/${warName}.war /tmp/deploy.sh

rc=$?

if [ "$rc" -gt 0 ]; then
printf "rm rc = %d - ignored\n" $rc
fi

printf "Start Tomcat...\n"
sudo service tomcat7 start
rc=$?

if [ "$rc" -gt 0 ]; then
printf "tomcat start failed with rc = %d\n" $rc
exit $rc
fi
printf "%s: Done without errors.\n" $0
exit 0
}

deployTomcat $1
exit $?
