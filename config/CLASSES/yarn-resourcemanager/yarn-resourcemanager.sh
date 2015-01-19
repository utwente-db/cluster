#!/bin/bash

# basic should be installed before this

#YARN RESOURCE MANAGER
apt-get --yes install hadoop-yarn-resourcemanager

# FOR FIRST SETUP DO:
su hdfs
hadoop fs -mkdir -p /var/log/hadoop-yarn
hadoop fs -chown yarn:mapred /var/log/hadoop-yarn
hadoop fs -ls -R /

/etc/init.d/hadoop-yarn-resourcemanager restart
