#!/bin/bash

# badic should be installed before this

#NAMENODE, PRIMARY SERVER
apt-get --yes install hadoop-hdfs-namenode=2.3.0+cdh5.1.2+816-1.cdh5.1.2.p0.3~precise-cdh5.1.2

# FOR FIRST SETUP DO:
su hdfs
[
hadoop fs -mkdir /tmp
hadoop fs -chmod -R 1777 /tmp
hadoop fs -mkdir -p /user/history
hadoop fs -chmod -R 1777 /user/history
hadoop fs -chown mapred:hadoop /user/history

/etc/init.d/hadoop-yarn-resourcemanager restart
