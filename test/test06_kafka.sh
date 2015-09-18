#echo "Kafka"
#topic=test-$RANDOM
#kafka-topics.sh -create -topic $topic -partitions 2 -replication-factor 2
#kafka-console-consumer.sh -topic test123 --zookeeper farmname.ewi.utwente.nl 
#kafka-console-producer.sh -topic test123 --broker-list  farm01.ewi.utwente.nl:9092