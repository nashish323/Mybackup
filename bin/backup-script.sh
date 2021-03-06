#!/bin/bash

# dirs to backups
DIRS="/var/lib/tomcat7/webapps/unique"

# Save zip file elsewhere on the server 
DEST="/mnt/backup_dev"



# set to "no" keep old zip file and add new file
DELETE_OLD_ZIP_FILES="yes" 

#Path to binary files
BASENAME=/usr/bin/basename 
ZIP=/usr/bin/zip
dt=$(date +"%Y-%m-%d-%H:%M:%S")

for d in $DIRS
do
    zipfile="${DEST}/$(${BASENAME} ${d})_$dt.zip"
    echo -n "Creating $zipfile..."
    if [ "$DELETE_OLD_ZIP_FILES" == "yes" ]
    then
        [ -f $zipfile ] && /bin/rm -f $zipfile 
    fi
    # create zip file
    ${ZIP} -r $zipfile $d $dt &>/dev/null && echo "Done!"
done
