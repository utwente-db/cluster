# Storm Nimbus
require storm_basic
require supervisor

## Variables
    export REALM=FARM.UTWENTE.NL
    export CENTRALNODE=farm02
    export HOST=farm02
    export FQN=# Fully qualified name
    # safe directory where files can be exchanged (see kerberos_kdc)
    export SAFE=~dbeheer/safe

## Installation
    # supervisor config files
    PLACE config/storm_nimbus_supervisor.conf in /etc/supervisor/conf.d/ directory
    PLACE config/storm_ui_supervisor.conf in /etc/supervisor/conf.d/ directory
    
    PLACE config/jaas.conf /usr/lib/storm/conf replaceing the variables $REALM and $FQN

    # Install Keytab(s)
    cd $SAFE
    HOST=$(hostname).ewi.utwente.nl
    mv $HOST.storm.keytab /usr/lib/storm/conf/storm.keytab
    chown storm:hadoop /usr/lib/storm/conf/*.keytab
    chmod 0400 /usr/lib/storm/conf/*keytab

    # (re-) start all remaining service
    supervisorctl reload

