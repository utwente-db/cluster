#!/bin/bash

apt-get --yes install csh

# install apt utilities
apt-get --yes install software-properties-common
apt-get --yes install python-software-properties

# install Oracle Java 7
add-apt-repository -y ppa:webupd8team/java
apt-get update 
# ACCEPT LICENSE
echo oracle-java7-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections
apt-get --yes install oracle-jdk7-installer
update-alternatives --display java

# set system wide JAVA HOME
cat ./JAVA_HOME_SET >> /etc/profile
cat ./JAVA_HOME_SET >> /etc/bash.bashrc

#rehash
apt-get --yes install curl
curl -s http://archive.cloudera.com/cdh5/ubuntu/precise/amd64/cdh/archive.key | apt-key add -

# look for puppet modifications inside CLOUDERA.LIST
cp ./CLOUDERA.LIST /etc/apt/sources.list.d/cloudera.list
apt-get update

# as basic installation only install hadoop -client
apt-get --yes install hadoop-client

# now copy the config files for hadoop to the correct location
cp ./DEFAULT-CONFIG-FILES/* /etc/hadoop/conf/
