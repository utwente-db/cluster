apt-get --yes install zookeeper_server

PLACE config/zoo.cfg under /etc/zookeeper/conf/

service zookeeper-server init --myid=1 --force
