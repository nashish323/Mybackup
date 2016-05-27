#!/bin/bash

function deployTomcat {
typeset warName=$1
typeset projectName=$2
TOMCAT_HOME=/var/lib/tomcat7/
TOMCAT_WEBAPPS=/var/lib/tomcat7/webapps
printf "Shut down Tomcat...\n"
sudo service tomcat7 stop
rc=$?

if [ "$rc" -gt 0 ]; then
printf "tomcat7 stop failed with rc = %d\n" $rc
exit $rc
fi

printf "Deleting old files...\n"
rm -fr $TOMCAT_WEBAPPS/${projectName}
rc=$?

if [ "$rc" -gt 0 ]; then
printf "delete dir failed with rc = %d\n" $rc
exit $rc
fi

printf "Unzip the dist...\n"
cd $TOMCAT_WEBAPPS
sudo chown ubuntu: .

mkdir ${projectName}
echo ${projectName}
unzip /tmp/${warName}.war -d ${projectName}
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
printf "tomcat7 start failed with rc = %d\n" $rc
exit $rc
fi
printf "%s: Done without errors.\n" $0
exit 0
}

deployTomcat $1 $2
exit $?
