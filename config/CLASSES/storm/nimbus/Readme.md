require storm_basic
require supervisor

# supervisor config files
PLACE config/storm_nimbus_supervisor.conf in /etc/supervisor/conf.d/ directory
PLACE config/storm_ui_supervisor.conf in /etc/supervisor/conf.d/ directory

## (re-) start all remaining service
supervisorctl reload