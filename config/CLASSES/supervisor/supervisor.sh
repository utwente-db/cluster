apt-get install supervisor

mkdir -p /etc/supervisor/conf.d
mkdir -p /var/log/supervisord/

PLACE config/supervisord.conf in /etc/
PLACE config/supervisord.init.d in /etc/init.d/supervisor

update-rc.d supervisor defaults

service supervisor start
