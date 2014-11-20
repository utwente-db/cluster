#!/bin/bash

# basic should be installed before installing this

# DATANODE INSTALL
apt-get --yes install hadoop-hdfs-datanode

#fix
chown -R hdfs /var/log/hadoop-hdfs

mkdir /local/hadoop
mkdir /local/hadoop/dfs/
mkdir /local/hadoop/dfs/data
chown -R hdfs /local/hadoop/dfs/

/etc/init.d/hadoop-hdfs-datanode restart
