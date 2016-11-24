#!/bin/bash

# basic should be installed before installing this

# YARN NODEMANAGER INSTALL
apt-get --yes install hadoop-yarn-nodemanager
apt-get --yes install hadoop-mapreduce

#fix
  mkdir /local/hadoop/mapred
  mkdir /local/hadoop/mapred/local
  chown -R mapred /local/hadoop/mapred

  mkdir -p /local/hadoop/yarn/nm-local-dir
  mkdir -p /local/hadoop/yarn/container-logs
  chown -R yarn /local/hadoop/yarn

/etc/init.d/hadoop-yarn-nodemanager restart
