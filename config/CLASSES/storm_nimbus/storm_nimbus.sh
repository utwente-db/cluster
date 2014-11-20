cd /local
wget http://ftp.tudelft.nl/apache/incubator/storm/apache-storm-0.9.2-incubating/apache-storm-0.9.2-incubating.tar.gz
tar xvzp -f apache-storm-0.9.2-incubating.tar.gz
rm apache-storm-0.9.2-incubating.tar.gz
mv apache-storm-0.9.2-incubating storm
chown -R hdfs storm
su hdfs
cd storm
mkdir data

PLACE CONFIGURATION in CONF

# process that should be supervised (watchdogged)
/local/storm/bin/storm nimbus
/local/storm/bin/storm ui
