require storm_basic
require supervisor

# supervisor config files
PLACE config/storm_nimbus_supervisor.conf in /etc/supervisor/conf.d/ directory
PLACE config/storm_ui_supervisor.conf in /etc/supervisor/conf.d/ directory

## (re-) start all remaining service
supervisorctl reload

=== Variables
export REALM=FARM.UTWENTE.NL
export CENTRALNODE=farm02
export HOST=farm02


==== Keyfiles
<on the kdc server>
kinit kadmin/admin@$REALM #login

For each nimubs or supervisor server, do the following
cd ~dbeheer
for i in $(seq 1 9); do
	HOST=$(printf "farm%02d.ewi.utwente.nl" $i)
	kadmin.local -r $REALM -q "addprinc -randkey storm/$HOST@$REALM"
	kadmin.local -r $REALM -q "xst -k $HOST.storm.keytab storm/$HOST"
done

<on each host (regionserver / master)>
HOST=$(hostname).ewi.utwente.nl
mv $HOST.hbase.keytab /etc/hbase/conf/hbase.keytab
chown hbase:hadoop /etc/hbase/conf/*.keytab
chmod 0400 /etc/hbase/conf/*.keytab
