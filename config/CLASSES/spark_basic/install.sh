# remove previously installed spark-core and spark python
apt-get install scala

remove old version
rm -rf /usr/lib/spark

download newest version of spark
VERSION=1.6.0
wget http://d3kbcqa49mib13.cloudfront.net/spark-$VERSION-bin-hadoop2.6.tgz

tar xvzp -f spark-$VERSION-bin-hadoop2.6.tgz

mv spark-$VERSION-bin-hadoop2.6.tgz /usr/lib/spark

rm spark-$VERSION-bin-hadoop2.6.tgz

# copy configuraiton setting DISPATCHER to either farmname or ctit048
cp config/spark-defaults.conf /usr/lib/spark/conf/

# add global variable to bashrc
export HADOOP_CONF_DIR=/etc/hadoop/conf
export PATH=/usr/lib/spark/bin:$PATH
