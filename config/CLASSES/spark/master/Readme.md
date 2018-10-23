# Spark Master Installation

## Variables

    export REALM=CTIT-KRB.UTWENTE.NL
    export CENTRALNODE=farm02
    export HOST=$(hostname)
    # export SPARK_VERSION=1.6.0-cdh5.9.0
    export SPARK_VERSION=2.2.0-cdh5.9.0
    

## Required Classes
require spark_basic

## Preparatations

Remove previously installed spark-master spark-history-server

## Credate hdfs directories for log history
<on central node>

    # Become hdfs root
    kinit -kt /etc/hadoop/conf/hdfs.keytab hdfs/$CENTRALNODE.ewi.utwente.nl@$REALM
    hdfs dfs -mkdir /user/spark 
    hdfs dfs -mkdir /user/spark/applicationHistory 
    hdfs dfs -chown -R spark:spark /user/spark
    hdfs dfs -chmod 1777 /user/spark/applicationHistory

## Creating job assembly
Spark jobs download a so-called assembly file from hdfs, essentially containing spark 
libraries. This assembly is version specific and has to be uploaded separately after
each spark version update.

<on central node>
  
    # Become spark user
    # DEPRICATED kinit -kt /etc/spark/conf/spark.keytab spark/$CENTRALNODE.ewi.utwente.nl@$REALM
    # DEPRICATED hdfs dfs -put /usr/lib/spark/lib/spark-assembly.jar /user/spark/share/lib/spark-assembly-${SPARK_VERSION}.jar
    
