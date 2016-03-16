
# References
Script created according to
https://help.ubuntu.com/community/Kerberos
http://www.cloudera.com/documentation/enterprise/5-2-x/topics/cdh_sg_cdh5_install.html

# Variables
export REALM=FARM.UTWENTE.NL
export CENTRALNODE=farm02
export HOST=farm02


== Stop services =
Stop services
for x in `cd /etc/init.d ; ls hadoop-*` ; do service $x stop ; done
for x in `cd /etc/init.d ; ls hbase-*` ; do service $x stop ; done

# Installed java extension
copy security jar file for strong encryption outside the USA
<On every node>
unzip jce_policy-8.zip (currently on /home/dbeheer)
cp {local_policy,US_export_policy}.jar $JAVA_HOME/jre/lib/security/

# Create KDC
    #install software
    apt-get install krb5-kdc krb5-admin-server
    # set startup parameters
    echo 'DAEMON_ARGS="-r $REALM"' >> /etc/default/krb5-kdc
    echo 'DAEMON_ARGS="-r $REALM"' >> /etc/default/krb5-admin-server

Adapt Configuration
    for f in ~dbeheer/config/CLASSES/kerberos_kdc_/etc/*; do 
    	F=/etc/krb5kdc/$(basename $f); 
    	if [ "$f" -nt "$F" ]; then
    		echo $f $F; 
    		cat $f | perl -pe 's/\$(\w+)/$ENV{$1}/g' > $F
    done

## Create relam
    kdb5_util create -s -r $REALM
    /etc/init.d/krb5-kdc start || true
    /etc/init.d/krb5-admin-server start ||true

# Create copy of kerberos configuration file
To make $REALM the default default
    sed -e "s@default_realm = AD.UTWENTE.NL@default_realm = $REALM@g" /etc/krb5.conf > /etc/krb5.farm.conf


## Create Trust relationship with AD.UTWENTE.NL
    kinit kadmin/admin@$REALM
    kadmin.local -r $REALM -q "addprinc -e "aes256-cts:normal" krbtgt/$REALM@AD.UTWENTE.NL"
    <enter trust password twice>

## Create Principles and Export Keytabs
<on kdc server>
    kinit -r $REALM -p kadmin/admin@$REALM
    <enter new password>

    # for each host 
    HOST=farm02.ewi.utwente.nl
    kadmin.local -r $REALM -q "addprinc -randkey hdfs/$HOST@$REALM"
    kadmin.local -r $REALM -q "addprinc -randkey mapred/$HOST@$REALM"
    kadmin.local -r $REALM -q "addprinc -randkey yarn/$HOST@$REALM"
    kadmin.local -r $REALM -q "addprinc -randkey HTTP/$HOST@$REALM"

    kadmin.local -r $REALM -q "xst -norandkey -k $HOST.hdfs.keytab hdfs/$HOST@$REALM HTTP/$HOST@$REALM"
    kadmin.local -r $REALM -q "xst -norandkey -k $HOST.hdfs.keytab hdfs/$HOST@$REALM HTTP/$HOST@$REALM"
    kadmin.local -r $REALM -q "xst -norandkey -k $HOST.mapred.keytab mapred/$HOST@$REALM HTTP/$HOST@$REALM"
    kadmin.local -r $REALM -q "xst -norandkey -k $HOST.yarn.keytab mapred/$HOST@$REALM yarn/$HOST@$REALM HTTP/$HOST@$REALM"

<on each server>
    mv $HOST.hdfs.keytab /etc/hadoop/conf/hdfs.keytab
    mv $HOST.mapred.keytab /etc/hadoop/conf/mapred.keytab
    mv $HOST.yarn.keytab /etc/hadoop/conf/yarn.keytab
    chown hdfs:hadoop /etc/hadoop/conf/hdfs.keytab
    chown mapred:hadoop /etc/hadoop/conf/mapred.keytab
    chown yarn:hadoop /etc/hadoop/conf/yarn.keytab
    chmod 400 /etc/hadoop/conf/*.keytab

## Administration 
Exit safe mode
    # first become hdfs
    kinit -kt /etc/hadoop/conf/hdfs.keytab hdfs/$CENTRALNODE.ewi.utwente.nl@FARM.UTWENTE.NL
    hdfs dfsadmin -savemode leave

## Install Configuration Files
    cat >> /etc/default/hadoop-hdfs-datanode <<EOF
    export HADOOP_SECURE_DN_USER=hdfs
    export HADOOP_SECURE_DN_PID_DIR=/var/lib/hadoop-hdfs
    export HADOOP_SECURE_DN_LOG_DIR=/var/log/hadoop-hdfs
    export JSVC_HOME=/usr/lib/bigtop-utils/
    EOF 

## Set correct PID file for secure datenodes
<on each datanode>
    sed -i.bak -e 's@PIDFILE=".*"@PIDFILE="/var/lib/hadoop-hdfs/hadoop_secure_dn.pid"@g' /etc/init.d/hadoop-hdfs-datanode

Note:
before, starting a datanode would succeed but the controlling script would return an error:
```
starting datanode, logging to /var/log/hadoop-hdfs/hadoop-hdfs-datanode-farm01.out
 * Failed to start Hadoop datanode. Return value: 3
* Datanode doesn't start
```
This can be solved by the above sed command

# HTTP Configuration

## Create Certificate Signing Requests
https://www-01.ibm.com/support/knowledgecenter/SSPT3X_4.1.0/com.ibm.swg.im.infosphere.biginsights.admin.doc/doc/admin_ssl_hbase_mr_yarn_hdfs_web.html

    echo "PASSWORD" > keypassword
    chmod 0400 keypassword
    openssl rand -base64 32 > publicpass
    openssl rand -base64 10 > shortpass
    export KEYPASSWORD=$(cat /root/certificates/keypassword)
    for i in $(seq 1 9); do H=$(printf "farm%02d" $i); openssl genrsa -passout file:keypassword -out $H.ewi.utwente.nl.key 2048; done
    for i in $(seq 1 9); do H=$(printf "farm%02d" $i); openssl req -new -passin file:keypassword -sha256 -key $H.ewi.utwente.nl.key -out $H.ewi.utwente.nl.csr -subj "/C=NL/ST=OV/L=Enschede/O=University of Twente/OU=CTIT/CN=$H.ewi.utwente.nl"; done
    for i in $(seq 1 48); do H=$(printf "ctit%03d" $i); openssl genrsa -passout file:keypassword -out $H.ewi.utwente.nl.key 2048; done
    for i in $(seq 1 48); do H=$(printf "ctit%03d" $i); openssl req -new -passin file:keypassword -sha256 -key $H.ewi.utwente.nl.key -out $H.ewi.utwente.nl.csr -subj "/C=NL/ST=OV/L=Enschede/O=University of Twente/OU=CTIT/CN=$H.ewi.utwente.nl"; done

.... wait for certificate

    export host=$(hostname).ewi.utwente.nl
    openssl pkcs7 -print_certs -in $host_ewi_utwente_nl.p7b -outform PEM -out $host.crt
    openssl pkcs12 -export -in $host.crt -passin file:keypassword -inkey $host.key -passout file:shortpass -name $host -out $host.p12

## Import into private keystore
keytool -list -storepass:file shortpass -storetype pkcs12 -keystore $host.p12 
keytool -importkeystore -srcstoretype pkcs12 -srcstorepass:file shortpass -srckeystore $host.p12 -alias $host -deststorepass:file keypassword  -destkeystore $host.jks
rm $host.p12

keytool -export -alias $host -keystore $host.jks -rfc -storepass:file keypassword -file $host.cer

## Import into trust stores
keytool -import -trustcacerts -storepass:file publicpass -alias $host -noprompt -file $host.crt -keystore $host.trust.jks
keytool -list -storepass:file publicpass -v -keystore $host.trust.jks

keytool -import -trustcacerts -storepass:file publicpass -alias $host -noprompt -file $host.crt -keystore $REALM.jks
keytool -list -storepass:file publicpass -v -keystore $REALM.jks 

## Copy to configuration to actual configuraiton
cp -a $REALM.jks /etc/hadoop/conf
cp -a $host.jks /etc/hadoop/conf
cp -a $host.trust.jks /etc/hadoop/conf
cp -a $host.cer /etc/hadoop/conf

chmod 0440 /etc/hadoop/conf/*jks /etc/hadoop/conf/*cer
chown -R yarn:hadoop /etc/hadoop/conf/*jks /etc/hadoop/conf/*cer

# Update hadoop configuration
for f in ~dbeheer/config/CLASSES/basic/config.ctit/*; do 
	F=/etc/hadoop/conf/$(basename $f); 
	if [ "$f" -nt "$F" ]; then
		echo $f $F; 
		cat $f | perl -pe 's/\$(\w+)/$ENV{$1}/g' > $F
done
cat ~dbeheer/CLASSES/basic/config.ctit/hdfs-site.xml | perl -pe 's/\$(\w+)/$ENV{$1}/g' > /etc/hadoop/conf/hdfs-site.test