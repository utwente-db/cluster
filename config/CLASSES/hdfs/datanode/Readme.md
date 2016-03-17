# HDFS Datanode

## Variables

    export REALM=FARM.UTWENTE.NL
    export CENTRALNODE=farm02
    export HOST=farm02
    # safe directory where files can be exchanged (see kerberos_kdc)
    export SAFE=~dbeheer/safe

## Requirements 

* Install hdfs/basic before this

# Installation
    apt-get --yes install hadoop-hdfs-datanode=2.3.0+cdh5.1.2+816-1.cdh5.1.2.p0.3~precise-cdh5.1.2
    chown -R hdfs /var/log/hadoop-hdfs
    
    # where data is actually stored
    mkdir -p /local/hadoop/dfs/data
    chown -R hdfs /local/hadoop/dfs/
    
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

    # start services
    /etc/init.d/hadoop-hdfs-datanode restart
