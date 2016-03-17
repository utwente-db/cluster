# Base Installation for All Servers

## Install Basic App

    apt-get --yes install csh
    apt-get --yes install software-properties-common
    apt-get --yes install python-software-properties
    apt-get --yes install curl
    apt-get --yes install maven
  
## Install Java7

    add-apt-repository -y ppa:webupd8team/java
    apt-get update 
    echo oracle-java7-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections
    apt-get --yes install oracle-jdk7-installer
    update-alternatives --display java


## Set system wide JAVA HOME

    cat config/JAVA_HOME_SET >> /etc/profile
    cat config/JAVA_HOME_SET >> /etc/bash.bashrc

## Add Cloudera Repository

    curl -s http://archive.cloudera.com/cdh5/ubuntu/precise/amd64/cdh/archive.key | apt-key add -

    # look for puppet modifications inside CLOUDERA.LIST
    cp config/CLOUDERA.LIST /etc/apt/sources.list.d/cloudera.list

    # Give the claudera repository higher priorty,
    # see http://blog.cloudera.com/blog/2014/11/guidelines-for-installing-cdh-packages-on-unsupported-operating-systems/
    cp config/cloudera.pref /etc/apt/preferences.d/

    # Update repository cache
    apt-get update
