#!/bin/bash

# basic should be installed before this

#YARN RESOURCE MANAGER
apt-get --yes install hadoop-yarn-resourcemanager
apt-get --yes install hadoop-mapreduce-historyserver

#put all hadoop packages on-hold - not used for now
#for p in $(dpkg --list | grep hadoop | cut -d " " -f 3); do echo "$p hold" | dpkg --set-selections; done

# FOR FIRST SETUP DO:
su hdfs
hadoop fs -mkdir -p /var/log/hadoop-yarn
hadoop fs -chown yarn:mapred /var/log/hadoop-yarn
hadoop fs -ls -R /

hadoop fs -mkdir -p /user/history
hadoop fs -chmod -R 1777 /user/history
hadoop fs -chown mapred:hadoop /user/history
hadoop fs -mkdir -p /var/log/hadoop-yarn/apps
hadoop fs -chmod 0777 /var/log/hadoop-yarn/apps

/etc/init.d/hadoop-yarn-resourcemanager restart

