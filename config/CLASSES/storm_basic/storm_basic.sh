cd /local
wget http://ftp.tudelft.nl/apache/incubator/storm/apache-storm-0.9.2-incubating/apache-storm-0.9.2-incubating.tar.gz
tar xvzp -f apache-storm-0.9.2-incubating.tar.gz
rm apache-storm-0.9.2-incubating.tar.gz
mv apache-storm-0.9.2-incubating /usr/lib/storm
chown -R hdfs /var/lib/storm

mkdir -p /local/storm/data
chown -R hdfs /local/storm

mkdir -p /var/log/storm
chown -R hdfs /var/log/storm

PLACE config/storm.yaml in /usr/lib/storm/conf
Replace following variables
$CENTRAL zookeeper node (ctit048.ewi.utwente.nl or farmname.ewi.utwente.nl) 

cat ./PATH_AND_ALIASES >> /etc/bash.bashrc
cat ./PATH_AND_ALIASES >> /etc/profile