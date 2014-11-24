sudo apt-get install hbase-master

place config/hbase-site.xml under /etc/hbase/conf/
replace farmname with ctit048 for the new cluster

su hdfs
hadoop fs -mkdir /hbase
hadoop fs -chown hbase /hbase

sudo service hbase-master start
