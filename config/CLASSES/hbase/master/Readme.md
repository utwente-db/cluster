# HBase Master

## Variables

    export REALM=FARM.UTWENTE.NL
    export CENTRALNODE=farm02
    export HOST=farm02
    # safe directory where files can be exchanged (see kerberos_kdc)
    export SAFE=~dbeheer/safe

## Installation
  sudo apt-get install hbase-master

  # become root
  kinit -kt /etc/hadoop/conf/hdfs.keytab hdfs/$CENTRALNODE.ewi.utwente.nl@FARM.UTWENTE.NL
  
  hadoop fs -mkdir /hbase
  hadoop fs -chown hbase /hbase

  service hbase-master start
