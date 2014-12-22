sudo apt-get install hbase-master

su hdfs
hadoop fs -mkdir /hbase
hadoop fs -chown hbase /hbase

sudo service hbase-master start
