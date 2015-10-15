apt-get install spark-core spark-python scala

# copy configuraiton
cp config/spark-defaults.conf /etc/spark/conf/

# add global variable to every node
export HADOOP_CONF_DIR=/etc/hadoop/conf
