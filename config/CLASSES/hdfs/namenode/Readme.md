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
    
    # name node data directory
    mkdir -p /local/hadoop/dfs/namenode
    chown -R hdfs /local/hadoop/dfs/namenode

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
    
    # Copy HTTPS keys to configuration
    cp -a $REALM.jks /etc/hadoop/conf
    cp -a $FQN.jks /etc/hadoop/conf
    cp -a $FQN.trust.jks /etc/hadoop/conf
    cp -a $FQN.cer /etc/hadoop/conf
    chmod 0440 /etc/hadoop/conf/*jks /etc/hadoop/conf/*cer
    chown -R yarn:hadoop /etc/hadoop/conf/*jks /etc/hadoop/conf/*cer

    # set permissions
    chmod 0700 /etc/hadoop/conf/container-executor.cfg
    chown root:yarn /etc/hadoop/conf/container-executor.cfg 
    chmod 6050 /usr/lib/hadoop-yarn/bin/container-executor

    /etc/init.d/hadoop-hdfs-namenode restart

## Administration

### Format Filesystem 
    # first become hdfs
    kinit -kt /etc/hadoop/conf/hdfs.keytab hdfs/$(hostname).ewi.utwente.nl@$REALM
    
    # to format the hadoop file system (uncomment if needed)
    # hdfs  namenode -format
    
    # to exit safe mode (uncomment if needed)
    hdfs dfsadmin -safemode leave

### Upgrade filesystem (minor version)

See 

* [here](http://www.michael-noll.com/blog/2011/08/23/performing-an-hdfs-upgrade-of-an-hadoop-cluster/) 
* [here](https://www.cloudera.com/documentation/enterprise/latest/topics/cdh_ig_earlier_cdh5_upgrade.html)

for howto

on central node


    # backup 1
    su hdfs
    kinit -kt  /etc/hadoop/conf/hdfs.keytab hdfs/farm02.ewi.utwente.nl@CTIT-KRB.UTWENTE.NL
    # directory listing
    hadoop dfs -ls -R / > /dfs-v-old-lsr-1.log
    hadoop dfsadmin -report > /dfs-v-old-report-1.log

    # stop services
    service hbase-master stop
    service hadoop-yarn-resourcemanager stop
    service hadoop-mapreduce-historyserver stop
    service hadoop-hdfs-namenode stop
    
    # backup 2
    # namenode directory
    tar cvzp -f /dfs-v-old-namenode.tgz /local/hadoop/dfs/namenode
    
    # upgrade software
    
    # upgrade filesystem structure
    su hdfs
    kinit -kt  /etc/hadoop/conf/hdfs.keytab hdfs/farm02.ewi.utwente.nl@CTIT-KRB.UTWENTE.NL
    service hadoop-hdfs-namenode upgrade
    
    # start services again
    service hbase-master start
    service hadoop-yarn-resourcemanager start
    service hadoop-mapreduce-historyserver start
    service hadoop-hdfs-namenode start
    

### Setup Essential Directories

On the first run do.

    # become root
    kinit -kt /etc/hadoop/conf/hdfs.keytab hdfs/$(hostname).ewi.utwente.nl@$REALM
    
    hdfs dfs -mkdir /tmp
    hdfs dfs -chmod -R 1777 /tmp
    hdfs dfs -mkdir -p /user/history
    hdfs dfs -chmod -R 1777 /user/history
    hdfs dfs -chown mapred:hadoop /user/history
