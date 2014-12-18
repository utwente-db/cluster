cd /local
wget http://www.eng.lsu.edu/mirrors/apache/kafka/0.8.1.1/kafka_2.8.0-0.8.1.1.tgz
tar xvzp -f kafka_2.8.0-0.8.1.1.tgz
mv kafka_2.8.0-0.8.1.1 kafka
cd kafka
sudo bash
mkdir -p /local/kafka/logs
chown -R hdfs /local/kafka

PLACE config/server.properties IN config

# # To start the service... (has to be replaced with a watch dog call)
bin/kafka-server-start.sh -daemon config/server.properties	

cat ./PATH_AND_ALIASES >> /etc/bash.bashrc
cat ./PATH_AND_ALIASES >> /etc/profile