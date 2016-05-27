#!/bin/bash
#
echo "Going to run the JAR file "
mv /tmp/pxereader-cm-indexer-1.0.0-SNAPSHOT-jar-with-dependencies.jar ~/
lsof -t -i:5000 | xargs kill -9
sleep 10
java -cp pxereader-cm-indexer-1.0.0-SNAPSHOT-jar-with-dependencies.jar com.pearson.pxereader.cm.indexer.App -p 5000 -n 2 > /dev/null &
exit 0;
