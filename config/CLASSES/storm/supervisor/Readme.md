# Storm Supervisor Service
require storm_basic
require supervisor

## Installation

    cp config/storm_supervisor.conf /etc/supervisor/conf.d/

    PLACE config/jaas.conf /usr/lib/storm/conf replaceing the variables $REALM and $FQN

    # Install Keytab(s)
    cd $SAFE
    HOST=$(hostname).ewi.utwente.nl
    mv $HOST.storm.keytab /usr/lib/storm/conf/storm.keytab
    chown storm:hadoop /usr/lib/storm/conf/*.keytab
    chmod 0400 /usr/lib/storm/conf/*keytab

    # (re-) start all remaining service
    supervisorctl reload