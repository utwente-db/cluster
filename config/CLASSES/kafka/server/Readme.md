# Kafka Server Installation

require kafka_basic
require supervisor

## Installation
    # Create directory where real data is preduced
    mkdir -p /local/kafka/logs
    chown -R hdfs /local/kafka

    ## Supervisor config files
    PLACE config/kafka_supervisor.conf IN /etc/supervisor/conf.d

    ## Reload Supervisor configuration file
    service supervisor restart

    ## start all services service
    supervisorctl start all

