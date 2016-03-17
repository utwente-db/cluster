# Installation Hadoop Namenode

## Requirements 

* Install hdfs/basic before this

## Variables

    export REALM=FARM.UTWENTE.NL
    export CENTRALNODE=farm02
    export HOST=farm02
    # safe directory where files can be exchanged (see kerberos_kdc)
    export SAFE=~dbeheer/safe

## Installation

    apt-get --yes install hadoop-hdfs-namenode=2.3.0+cdh5.1.2+816-1.cdh5.1.2.p0.3~precise-cdh5.1.2
    
    # name node data
    mkdir -p /var/lib/hadoop-hdfs/cache/hdfs/dfs/name
    chown -R hdfs /var/lib/hadoop-hdfs

    cd $SAFE 
    # Copy Keytabs
    export FQN=$(hostname).ewi.utwente.nl
    mv $FQN.hdfs.keytab /etc/hadoop/conf/hdfs.keytab
    mv $FQN.mapred.keytab /etc/hadoop/conf/mapred.keytab
    mv $FQN.yarn.keytab /etc/hadoop/conf/yarn.keytab
    chown hdfs:hadoop /etc/hadoop/conf/hdfs.keytab
    chown mapred:hadoop /etc/hadoop/conf/mapred.keytab
    chown yarn:hadoop /etc/hadoop/conf/yarn.keytab
    chmod 400 /etc/hadoop/conf/*.keytab
    
    # Copy HTTPS to configuration
    cp -a $REALM.jks /etc/hadoop/conf
    cp -a $host.jks /etc/hadoop/conf
    cp -a $host.trust.jks /etc/hadoop/conf
    cp -a $host.cer /etc/hadoop/conf
    chmod 0440 /etc/hadoop/conf/*jks /etc/hadoop/conf/*cer
    chown -R yarn:hadoop /etc/hadoop/conf/*jks /etc/hadoop/conf/*cer

    /etc/init.d/hadoop-hdfs-namenode restart

    # first become hdfs
    kinit -kt /etc/hadoop/conf/hdfs.keytab hdfs/$(hostname).ewi.utwente.nl@$REALM
    
    # to format the hadoop file system (uncomment if needed)
    # hdfs  namenode -format
    
    # to exit safe mode (uncomment if needed)
    hdfs dfsadmin -savemode leave

## Setup of HDFS Directory 
On the first run do.

    hadoop fs -mkdir /tmp
    hadoop fs -chmod -R 1777 /tmp
    hadoop fs -mkdir -p /user/history
    hadoop fs -chmod -R 1777 /user/history
    hadoop fs -chown mapred:hadoop /user/history


## Update Configuration
    scripts/shadow.py ~dbeheer/config/CLASSES/basic/config.ctit/ /etc/hadoop/conf/; do 