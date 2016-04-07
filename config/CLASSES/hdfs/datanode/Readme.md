# HDFS Datanode

## Variables

    export REALM=FARM.UTWENTE.NL
    export CENTRALNODE=farm02
    export HOST=farm02
    # safe directory where files can be exchanged (see kerberos_kdc)
    export SAFE=~dbeheer/safe

## Requirements 

* Install hdfs/basic before this

## Installation

### Basic Software Installation

    apt-get --yes install hadoop-hdfs-datanode=2.3.0+cdh5.1.2+816-1.cdh5.1.2.p0.3~precise-cdh5.1.2
    
### Adaptions Startup Scripts Files

  
    cat >> /etc/default/hadoop-hdfs-datanode <<EOF
    export HADOOP_SECURE_DN_USER=hdfs
    export HADOOP_SECURE_DN_PID_DIR=/var/lib/hadoop-hdfs
    export HADOOP_SECURE_DN_LOG_DIR=/var/log/hadoop-hdfs
    export JSVC_HOME=/usr/lib/bigtop-utils/
    EOF 
    
Adapt PID file for datanode
    
    sed -i.bak -e 's@PIDFILE=".*"@PIDFILE="/var/lib/hadoop-hdfs/hadoop_secure_dn.pid"@g' /etc/init.d/hadoop-hdfs-datanode

Note: without changing the PID file, starting a datanode would succeed but the controlling script returns an error:
```
starting datanode, logging to /var/log/hadoop-hdfs/hadoop-hdfs-datanode-farm01.out
 * Failed to start Hadoop datanode. Return value: 3
 * Datanode doesn't start
```
This is solved by adapting the data node file.    

### Adapt Directory Permissions

    chown -R hdfs /var/log/hadoop-hdfs
    
    # where data is actually stored
    mkdir -p /local/hadoop/dfs/data
    chown -R hdfs /local/hadoop/dfs/
    
### Kerberos / HTTPs related configuration

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

# Start Services

    /etc/init.d/hadoop-hdfs-datanode restart
