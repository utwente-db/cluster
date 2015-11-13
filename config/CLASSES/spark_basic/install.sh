# remove previously installed spark-core and spark python
apt-get install scala

download newest version of spark
wget http://d3kbcqa49mib13.cloudfront.net/spark-1.5.1-bin-hadoop2.6.tgz

tar xvzp -f spark-1.5.1-bin-hadoop2.6.tgz

mv spark-1.5.1-bin-hadoop2.6.tgz /usr/lib/spark

# copy configuraiton setting DISPATCHER to either farmname or ctit048
cp config/spark-defaults.conf /usr/lib/spark/conf/

# add global variable to every node
export HADOOP_CONF_DIR=/etc/hadoop/conf
export PATH=/usr/lib/spark/bin:$PATH
