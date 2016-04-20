# Kafka Basic Installatin


## Variables

PLACE config/server.properties IN /usr/lib/kafka/config
REPLACE the following variables 
  $COMPUTERID unique integer of computer (example mapping ctit035 -> 1035, farm13 -> 13)
  $CENTRALNODE zookeeper node (ctit048 or farmname) 


## Installation 

    wget http://www.eng.lsu.edu/mirrors/apache/kafka/0.8.1.1/kafka_2.8.0-0.8.1.1.tgz
    tar xvzp -f kafka_2.8.0-0.8.1.1.tgz
    mv kafka_2.8.0-0.8.1.1 /usr/lib/kafka

    # create directory for logs (the data of kafka) # not sure whether needed on client
    mkdir -p /var/log/kafka
    chown -R hdfs /var/log/kafka

    # create dummy log directory so that start script doesn't complain
    mkdir -p /usr/lib/kafka/logs
    
    Add PATHS and ALIASES variables to
    cat ./PATH_AND_ALIASES >> /etc/bash.bashrc
    cat ./PATH_AND_ALIASES >> /etc/profile



