require spark_basic

apt-get install spark-master spark-history-server

# log history
sudo -u hdfs hadoop fs -mkdir /user/spark 
sudo -u hdfs hadoop fs -mkdir /user/spark/applicationHistory 
sudo -u hdfs hadoop fs -chown -R spark:spark /user/spark
sudo -u hdfs hadoop fs -chmod 1777 /user/spark/applicationHistory

# do once
hdfs dfs -mkdir -p /user/spark/share/lib
hdfs dfs -put /usr/lib/spark/lib/spark-assembly_*.jar /user/spark/share/lib/spark-assembly.jar

