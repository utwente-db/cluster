require storm_basic
require supervisor

PLACE config/storm.yaml in conf/ directory
PLACE config/storm_supervisor.conf in /etc/supervisor/conf.d/ directory

# reload configuration file
service supervisor restart

# (re-) start all remaining service
supervisorctl start all
