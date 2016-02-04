require spark_basic

# remove previously installed spark-master spark-history-server

# credate hdfs directories for log history
export HADOOP_USER_NAME=hdfs
sudo -u hdfs hdfs -mkdir /user/spark 
sudo -u hdfs hdfs fs -mkdir /user/spark/applicationHistory 
sudo -u hdfs hdfs fs -chown -R spark:spark /user/spark
sudo -u hdfs hdfs fs -chmod 1777 /user/spark/applicationHistory

# upload assembly job to be executed by spark workers
hdfs dfs -mkdir -p /user/spark/share/lib
hdfs dfs -rm /user/spark/share/lib/spark-assembly.jar
hdfs dfs -put /usr/lib/spark/lib/spark-assembly.jar /user/spark/share/lib/spark-assembly.jar
unset HADOOP_USER_NAME

