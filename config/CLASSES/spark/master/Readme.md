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

## Upload job assembly
<on central node>
  
    # Become hdfs root
    kinit -kt /etc/hadoop/hdfs.keytab hdfs@$CENTRALNODE.ewi.utwente.nl/$REALM
    hdfs dfs -mkdir -p /user/spark/share/lib
    hdfs dfs -rm /user/spark/share/lib/spark-assembly.jar
    hdfs dfs -put /usr/lib/spark/lib/spark-assembly.jar /user/spark/share/lib/spark-assembly.jar
