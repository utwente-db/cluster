require spark_basic

sudo -u hdfs hadoop fs -mkdir /user/spark 
sudo -u hdfs hadoop fs -mkdir /user/spark/applicationHistory 
sudo -u hdfs hadoop fs -chown -R spark:spark /user/spark
sudo -u hdfs hadoop fs -chmod 1777 /user/spark/applicationHistory

apt-get install spark-master spark-history-server