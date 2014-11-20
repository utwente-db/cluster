#!/bin/bash

# badic should be installed before this

#NAMENODE, PRIMARY SERVER
apt-get --yes install hadoop-hdfs-namenode

# FOR FIRST SETUP DO:
su hdfs
[
hadoop fs -mkdir /tmp
hadoop fs -chmod -R 1777 /tmp
hadoop fs -mkdir -p /user/history
hadoop fs -chmod -R 1777 /user/history
hadoop fs -chown mapred:hadoop /user/history

/etc/init.d/hadoop-yarn-resourcemanager restart
