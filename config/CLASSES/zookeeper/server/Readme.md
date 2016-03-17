apt-get --yes install zookeeper-server

PLACE config/zoo.cfg under /etc/zookeeper/conf/

service zookeeper-server init --myid=1 --force

= Variables
export REALM=FARM.UTWENTE.NL
export CENTRALNODE=farm02
export HOST=farm02

=== Keyfiles ==
<on the kdc server>
kinit kadmin/admin@$REALM

<on the kdc>
HOST=$CENTRALNODE.ewi.utwente.nl
cd ~dbeheer 
kadmin.local -r $REALM -q "addprinc -randkey zookeeper/$HOST@$REALM"
kadmin.local -r $REALM -q "xst -k $HOST.zookeeper.keytab zookeeper/$HOST"

<on the host>
HOST=$(hostname).ewi.utwente.nl
mv ~dbeheer/$HOST.zookeeper.keytab /etc/zookeeper/conf/zookeeper.keytab
chown zookeeper:hadoop /etc/zookeeper/conf/*.keytab
chmod 0400 /etc/zookeeper/conf/*.keytab

== Install Configuration Files ==
cat zk-jaas.conf | perl -pe 's/\$(\w+)/$ENV{$1}/g' > /etc/zookeeper/conf/zk-jaas.conf
cp java.env /etc/zookeeper/conf/

