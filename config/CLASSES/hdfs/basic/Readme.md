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
cat ./PATH_AND_ALIASES >> /etc/bash.bashrc
cat ./PATH_AND_ALIASES >> /etc/profile

#rehash
apt-get --yes install curl
curl -s http://archive.cloudera.com/cdh5/ubuntu/precise/amd64/cdh/archive.key | apt-key add -

# look for puppet modifications inside CLOUDERA.LIST
cp ./CLOUDERA.LIST /etc/apt/sources.list.d/cloudera.list
#
# Give the claudera repository higher priorty,
# see http://blog.cloudera.com/blog/2014/11/guidelines-for-installing-cdh-packages-on-unsupported-operating-systems/
#
cp cloudera.pref /etc/apt/preferences.d/

#
# Update repository cache
#
apt-get update

# as basic installation only install hadoop -client
apt-get --yes install hadoop-client=2.3.0+cdh5.1.2+816-1.cdh5.1.2.p0.3~precise-cdh5.1.2

#
# Install specific zookeeper version
#
apt-get --yes install zookeeper=3.4.5+cdh5.3.0+81-1.cdh5.3.0.p0.36~precise-cdh5.3.0

# now copy the config files for hadoop to the correct location
cp ./DEFAULT-CONFIG-FILES/* /etc/hadoop/conf/

# Maven
sudo apt-get install maven

