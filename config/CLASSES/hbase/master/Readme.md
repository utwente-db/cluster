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
  kinit -kt /etc/hbase/conf/hbase.keytab hbase/ctit048.ewi.utwente.nl@CTIT-KRB.UTWENTE.NL
  
  # create hbase's base directory
  hadoop fs -mkdir /hbase
  hadoop fs -chown hbase /hbase

  service hbase-master start
  
  # setup testing namespace with full rights for 'alyr'
  echo "create_namespace 'test'" | hbase shell
  # grant all rights to testing user on namespace 'test'
  echo "grant 'alyr', 'RWXCA', '@test'" | hbase shell
  
## User administration

In the current installation, HBase requires for each user access rights to given tables. These rights are best administered via namespaces. To grant a user ``abc`` full access to the tables in a new namespace ``xyz``, do the following.

  # become hbase-root user 'hbase'
  kinit -kt /etc/hbase/conf/hbase.keytab hbase/$HOST@$REALM
  
  # create namespace
  echo "create_namespace 'xyz'" | hbase shell
  # grat 
  echo "grant 'abc', 'RWXCA', '@xyz'" | hbase shell
