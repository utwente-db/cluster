#!/bin/bash

# basic should be installed before installing this

# DATANODE INSTALL
apt-get --yes install hadoop-hdfs-datanode=2.3.0+cdh5.1.2+816-1.cdh5.1.2.p0.3~precise-cdh5.1.2

#fix
chown -R hdfs /var/log/hadoop-hdfs

mkdir -p /local/hadoop/dfs/data
chown -R hdfs /local/hadoop/dfs/

/etc/init.d/hadoop-hdfs-datanode restart
