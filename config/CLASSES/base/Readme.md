# Base Installation for All Servers

## Variables

    # The REALM that the current computer should participate in
    export REALM=FARM.UTWENTE.NL

## Install Basic Applications

    apt-get --yes install csh
    apt-get --yes install software-properties-common
    apt-get --yes install python-software-properties
    apt-get --yes install curl
    apt-get --yes install maven
    apt-get --yes install hadoop-client
  
## Install Java8

    add-apt-repository -y ppa:webupd8team/java
    apt-get update 
    echo oracle-java7-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections
    apt-get --yes install oracle-jdk7-installer
    update-alternatives --display java
    
    ## Set system wide JAVA HOME

    cat config/JAVA_HOME_SET >> /etc/profile
    cat config/JAVA_HOME_SET >> /etc/bash.bashrc

## Install Java Security Extension

Download the [Java Security Extension](http://www.oracle.com/technetwork/java/javase/downloads/jce-7-download-432124.html)

By default java has restricted encryption strength. Copy security jar file for strong encryption outside the USA
<On every node>
  
    cd ~dbeheer/jce_policy
    cp */{local_policy,US_export_policy}.jar $JAVA_HOME/jre/lib/security/

Note: keep jce_policy.zip at a save place.


## Kerberos Configuration

Copy the two kerberos configuration files, one for clients putting AD.UTWENTE.NL as default realm and one for services, putting the FARM.UTWENTE.NL or CTIT.UTWENTE.NL as default. 

    # Replace variable $REALM
    cp config/krb5.conf /etc/krb5.conf
    cp config/krb5.service.conf /etc/krb5.service.conf

## Add Cloudera Repository

    curl -s http://archive.cloudera.com/cdh5/ubuntu/precise/amd64/cdh/archive.key | apt-key add -

    # look for puppet modifications inside CLOUDERA.LIST
    cp config/CLOUDERA.LIST /etc/apt/sources.list.d/cloudera.list

    # Give the claudera repository higher priorty,
    # see http://blog.cloudera.com/blog/2014/11/guidelines-for-installing-cdh-packages-on-unsupported-operating-systems/
    cp config/cloudera.pref /etc/apt/preferences.d/

    # Update repository cache
    apt-get update
