# HBase Master

## Variables

    export REALM=FARM.UTWENTE.NL
    export CENTRALNODE=farm02
    export HOST=farm02
    # safe directory where files can be exchanged (see kerberos_kdc)
    export SAFE=~dbeheer/safe

## Installation
  sudo apt-get install hbase-master

  # become hbase-root user 'hbase'
  kinit -kt /etc/hadoop/conf/hdfs.keytab hdfs/$CENTRALNODE.ewi.utwente.nl@$REALM
  
  # create hbase's base directory
  hadoop fs -mkdir /hbase
  hadoop fs -chown hbase /hbase

  service hbase-master start
  
  # setup testing namespace with full rights for 'alyr'
  echo "create_namespace 'test'" | hbase shell
  # grant all rights to testing user on namespace 'test'
  echo "grant 'alyr', 'RWXCA', '@test'"
