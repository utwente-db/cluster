require storm_basic
require supervisor

cp config/storm_supervisor.conf /etc/supervisor/conf.d/

# (re-) start all remaining service
supervisorctl reload
