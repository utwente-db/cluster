# Hadoop Basic Installation

## Variables

    export REALM=FARM.UTWENTE.NL
    export CENTRALNODE=farm02
    export HOST=$(hostname)
    export PUBLICPASS=<path to file keypassword>
    export KEYPASSWORD=<path to file publicpass>

## Install Hadoop Client
In the basic installation only install hadoop -client

Moved the hadoop-client install to base class. The hadoop user is needed earlier in the install.

    #apt-get --yes install hadoop-client=2.3.0+cdh5.1.2+816-1.cdh5.1.2.p0.3~precise-cdh5.1.2

# now copy the config files for hadoop to the correct location

    shadow.py config/ /etc/hadoop/conf/
