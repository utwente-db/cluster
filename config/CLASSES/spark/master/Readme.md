# Spark Master Installation

## Required Classes
require spark_basic

## Preparatations

Remove previously installed spark-master spark-history-server

## Credate hdfs directories for log history
<on central node>

    # Become hdfs root
    kinit -kt /etc/hadoop/hdfs.keytab hdfs@$CENTRALNODE.ewi.utwente.nl/$REALM
    sudo -u hdfs hdfs -mkdir /user/spark 
    sudo -u hdfs hdfs fs -mkdir /user/spark/applicationHistory 
    sudo -u hdfs hdfs fs -chown -R spark:spark /user/spark
    sudo -u hdfs hdfs fs -chmod 1777 /user/spark/applicationHistory

## Upload job assembly
<on central node>
  
    # Become hdfs root
    kinit -kt /etc/hadoop/hdfs.keytab hdfs@$CENTRALNODE.ewi.utwente.nl/$REALM
    hdfs dfs -mkdir -p /user/spark/share/lib
    hdfs dfs -rm /user/spark/share/lib/spark-assembly.jar
    hdfs dfs -put /usr/lib/spark/lib/spark-assembly.jar /user/spark/share/lib/spark-assembly.jar
