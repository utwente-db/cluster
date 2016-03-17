= Packages =
sudo apt-get install hbase

= References = 
http://www.cloudera.com/documentation/enterprise/5-2-x/topics/cdh_sg_hbase_security.html
http://www.cloudera.com/documentation/enterprise/5-2-x/topics/cdh_sg_hbase_authorization.html

= Variables
export REALM=FARM.UTWENTE.NL
export CENTRALNODE=farm02
export HOST=farm02

==== Keyfiles ===
<on the kdc server>
kinit kadmin/admin@$REALM #login

For each master or regionserver do the following
cd ~dbeheer
for i in $(seq 1 9); do
	HOST=$(printf "farm%02d.ewi.utwente.nl" $i)
	kadmin.local -r $REALM -q "addprinc -randkey hbase/$HOST@$REALM"
	kadmin.local -r $REALM -q "xst -k $HOST.hbase.keytab hbase/$HOST"
done

<on each host (regionserver / master)>
HOST=$(hostname).ewi.utwente.nl
mv $HOST.hbase.keytab /etc/hbase/conf/hbase.keytab
chown hbase:hadoop /etc/hbase/conf/*.keytab
chmod 0400 /etc/hbase/conf/*.keytab

== Install Configuration Files ==
# install user specific 
cat hbase-site.xml | perl -pe 's/\$(\w+)/$ENV{$1}/g' > /etc/hbase/conf/hbase-site.xml
cat zk-jaas.conf | perl -pe 's/\$(\w+)/$ENV{$1}/g' > /etc/hbase/conf/zk-jaas.conf
echo 'export HBASE_OPTS="$HBASE_OPTS -Djava.security.auth.login.config=/etc/hbase/conf/zk-jaas.conf -Djava.security.krb5.conf=/etc/krb5.farm.conf"' >> /etc/hbase/conf/hbase-env.sh
echo 'export HBASE_MANAGES_ZK=false' >> /etc/hbase/conf/hbase-env.sh

Note changes in zookeeper_server / zoo.cfg
