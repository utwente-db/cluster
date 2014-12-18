wget http://www.eng.lsu.edu/mirrors/apache/kafka/0.8.1.1/kafka_2.8.0-0.8.1.1.tgz
tar xvzp -f kafka_2.8.0-0.8.1.1.tgz
mv kafka_2.8.0-0.8.1.1 /usr/lib/kafka

# create files with logs
mkdir -p /var/log/kafka
chown -R hdfs /var/log/kafka

PLACE config/server.properties IN /usr/lib/kafka/config
REPLACE the following variables 
  $COMPUTERID unique integer of computer (example mapping ctit035 -> 1035, farm13 -> 13)
  $CENTRAL zookeeper node (ctit048.ewi.utwente.nl or farmname.ewi.utwente.nl) 

cat ./PATH_AND_ALIASES >> /etc/bash.bashrc
cat ./PATH_AND_ALIASES >> /etc/profile