require kafka_basic
require supervisor

# Create directory where real data is preduced
mkdir -p /local/kafka/logs
chown -R hdfs /local/kafka

# supervisor config files
PLACE config/kafka_supervisor.conf IN /etc/supervisor/conf.d

# reload configuration file
service supervisor restart

# (re-) start all remaining service
supervisorctl start all

