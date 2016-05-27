#!/bin/bash

#*******************************************************#
# Goldengate Build Script - A magical script that will  #
# build and create the Goldengate distribution. This    #
# script will not deploy the app.                       #
#                                                       #
#  Author:                                              #
#  Hari Gangadharan (hari.gangadharan@pearson.com)      #
#*******************************************************#


printf "%s Starting...\n" $0
printf "Current working dirctory: %s\n" `pwd`
printf "======== environment ===========\n"
env
printf "================================\n"
rm -fr /var/lib/jenkins/.cache/bower

declare -i rc=0

printf "git checkout of the right revision... Revision: %s\n" ${GIT_COMMIT}
git checkout ${GIT_COMMIT}
rc=$?
if [ "$rc" -gt 0 ]; then
    printf "git checkout failed with rc = %d\n" $rc
    exit $rc
fi

printf "npm install...\n"
npm install
rc=$?

if [ "$rc" -gt 0 ]; then
    printf "npm failed with rc = %d\n" $rc
    exit $rc
fi

bower install
rc=$?

if [ "$rc" -gt 0 ]; then
    printf "bower failed with rc = %d\n" $rc
    exit $rc
fi

grunt build
rc=$?

if [ "$rc" -gt 0 ]; then
    printf "grunt build failed with rc = %d\n" $rc
    exit $rc
fi

printf "Archiving dist...\n"
printf "Job Name: %s Build Number: %s\n" ${JOB_NAME} ${BUILD_NUMBER} >./dist/version.txt
printf "Git Branch: %s Git Commit: %s\n" ${GIT_BRANCH} ${GIT_COMMIT} >>./dist/version.txt
cat ~/jobs/${JOB_NAME}/builds/${BUILD_NUMBER}/changelog.xml >>./dist/version.txt
cp ~/jobs/${JOB_NAME}/builds/${BUILD_NUMBER}/changelog.xml .

tar -cvzf ./dist.tar.gz -C ./dist ./
rc=$?

if [ "$rc" -gt 0 ]; then
    printf "tar failed with rc = %d\n" $rc
    exit $rc
fi

printf "Surprisingly the build ended without any problems!\n"
exit 0
