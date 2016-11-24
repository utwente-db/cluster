# Spark Master Installation

## Required Classes
require spark_basic

## Preparatations

Remove previously installed spark-master spark-history-server

## Credate hdfs directories for log history
<on central node>

    # Become hdfs root
    kinit -kt /etc/hadoop/hdfs.keytab hdfs@$CENTRALNODE.ewi.utwente.nl/$REALM
    hdfs dfs -mkdir /user/spark 
    hdfs dfs -mkdir /user/spark/applicationHistory 
    hdfs dfs -chown -R spark:spark /user/spark
    hdfs dfs -chmod 1777 /user/spark/applicationHistory

## Creating job assembly
An assembly is a zip of all required jar files - done for version 2.0.2
<on central node>
  
    # Become hdfs root
    kinit -kt /etc/hadoop/hdfs.keytab hdfs@$CENTRALNODE.ewi.utwente.nl/$REALM
    cd /usr/lib/spark-$VERSION-*/jars
    zip ../spark-$VERSION-assembly.zip *.jar
    hdfs dfs -put ../spark-$VERSION-assembly.zip /user/spark/share/lib/
    hdfs dfs -chown spark.spark /user/spark/share/lib/
