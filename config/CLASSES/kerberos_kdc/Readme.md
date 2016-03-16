
# References
Script created according to
https://help.ubuntu.com/community/Kerberos
http://www.cloudera.com/documentation/enterprise/5-2-x/topics/cdh_sg_cdh5_install.html

# Variables
export REALM=FARM.UTWENTE.NL
export CENTRALNODE=farm02
export HOST=farm02

# Installed java extension
By default java has restricted encryption strength. To copy security jar file for strong encryption outside the USA
<On every node>
  
    cd ~dbeheer/jce_policy
    cp */{local_policy,US_export_policy}.jar $JAVA_HOME/jre/lib/security/

Note: keep jce_policy.zip at a save place.

# KDC

## Stop Hadoop services
Stop services

    for x in `cd /etc/init.d ; ls hadoop-*` ; do service $x stop ; done
    for x in `cd /etc/init.d ; ls hbase-*` ; do service $x stop ; done

## Setup KDC
Install software

    apt-get install krb5-kdc krb5-admin-server

Set startup parameters

    echo 'DAEMON_ARGS="-r $REALM"' >> /etc/default/krb5-kdc
    echo 'DAEMON_ARGS="-r $REALM"' >> /etc/default/krb5-admin-server

Adapt Configuration

    python scripts/shadow.py config/CLASSES/kerberos_kdc/config /

Create Realm

    kdb5_util create -s -r $REALM
    <enter realm password by hand> 
    
## Start services

    /etc/init.d/krb5-kdc start || true
    /etc/init.d/krb5-admin-server start ||true

## Create Trust relationship with AD.UTWENTE.NL
Enter trust relationship with AD domain.

    kinit kadmin/admin@$REALM
    kadmin.local -r $REALM -q "addprinc -e "aes256-cts:normal" krbtgt/$REALM@AD.UTWENTE.NL"
    <enter trust password twice>

## Create Principals and Export Keytabs
First create principals and export keytabs
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

Move every keytab to the correct location and change access permissions
<on each server>
    mv $HOST.hdfs.keytab /etc/hadoop/conf/hdfs.keytab
    mv $HOST.mapred.keytab /etc/hadoop/conf/mapred.keytab
    mv $HOST.yarn.keytab /etc/hadoop/conf/yarn.keytab
    chown hdfs:hadoop /etc/hadoop/conf/hdfs.keytab
    chown mapred:hadoop /etc/hadoop/conf/mapred.keytab
    chown yarn:hadoop /etc/hadoop/conf/yarn.keytab
    chmod 400 /etc/hadoop/conf/*.keytab

## HDFS Administration 
Exit safe mode

    # first become hdfs
    kinit -kt /etc/hadoop/conf/hdfs.keytab hdfs/$CENTRALNODE.ewi.utwente.nl@FARM.UTWENTE.NL
    hdfs dfsadmin -savemode leave

## Install Configuration Files
<on each datanode>
  
    cat >> /etc/default/hadoop-hdfs-datanode <<EOF
    export HADOOP_SECURE_DN_USER=hdfs
    export HADOOP_SECURE_DN_PID_DIR=/var/lib/hadoop-hdfs
    export HADOOP_SECURE_DN_LOG_DIR=/var/log/hadoop-hdfs
    export JSVC_HOME=/usr/lib/bigtop-utils/
    EOF 
    
Adapt PID file for datanode
    
    sed -i.bak -e 's@PIDFILE=".*"@PIDFILE="/var/lib/hadoop-hdfs/hadoop_secure_dn.pid"@g' /etc/init.d/hadoop-hdfs-datanode

Note: without chaning the PID file, starting a datanode would succeed but the controlling script would return an error:
```
starting datanode, logging to /var/log/hadoop-hdfs/hadoop-hdfs-datanode-farm01.out
 * Failed to start Hadoop datanode. Return value: 3
 * Datanode doesn't start
```
This can be solved by adapting the PID file.

## Start Hadoop services
Stop services
    for x in `cd /etc/init.d ; ls hadoop-*` ; do service $x start ; done
    for x in `cd /etc/init.d ; ls hbase-*` ; do service $x start ; done

# HTTP Configuration

## References
This script is mainly based on 

https://www-01.ibm.com/support/knowledgecenter/SSPT3X_4.1.0/com.ibm.swg.im.infosphere.biginsights.admin.doc/doc/admin_ssl_hbase_mr_yarn_hdfs_web.html

## Create Keys and Certificate Signing Requests

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
    scripts/shadow.py ~dbeheer/config/CLASSES/basic/config.ctit/ /etc/hadoop/conf/; do 
