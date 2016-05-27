#!/bin/sh

#################Copy Backup file on DevENv tmp folder#####################
scp -r /var/lib/jenkins/backup_script/devenv/backup_readersdk-dev.sh ubuntu@pxereader-services-dev:/tmp/

#################Excute file from Dev Server###############################

ssh  ubuntu@pxereader-services-dev '/tmp/backup_readersdk-dev.sh'

#################Remove backup file from Dev Server tmp location##########
ssh ubuntu@pxereader-services-dev 'rm -rf /tmp/backup_readersdk-dev.sh'  

################Webapps Unique_backup Is done############################
