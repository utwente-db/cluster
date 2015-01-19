#!/bin/bash

# badic should be installed before this

#NAMENODE, PRIMARY SERVER
apt-get --yes install hadoop-hdfs-namenode=2.3.0+cdh5.1.2+816-1.cdh5.1.2.p0.3~precise-cdh5.1.2

mkdir -p /var/lib/hadoop-hdfs/cache/hdfs/dfs/name
chown -R hdfs /var/lib/hadoop-hdfs

/etc/init.d/hadoop-hdfs-namenode restart

su hdfs
hdfs  namenode -format

# FOR FIRST SETUP DO:
hadoop fs -mkdir /tmp
hadoop fs -chmod -R 1777 /tmp
hadoop fs -mkdir -p /user/history
hadoop fs -chmod -R 1777 /user/history
hadoop fs -chown mapred:hadoop /user/history


