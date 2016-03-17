# Kerberos KDC

## References
Script created according to
* https://help.ubuntu.com/community/Kerberos
* http://www.cloudera.com/documentation/enterprise/5-2-x/topics/cdh_sg_cdh5_install.html
* https://www-01.ibm.com/support/knowledgecenter/SSPT3X_4.1.0/com.ibm.swg.im.infosphere.biginsights.admin.doc/doc/admin_ssl_hbase_mr_yarn_hdfs_web.html

## Variables

    export REALM=FARM.UTWENTE.NL
    export CENTRALNODE=farm02
    export HOST=farm02
    # safe directory where files can be exchanged
    export SAFE=~dbeheer/safe

## Installed java extension
By default java has restricted encryption strength. To copy security jar file for strong encryption outside the USA
<On every node>
  
    cd ~dbeheer/jce_policy
    cp */{local_policy,US_export_policy}.jar $JAVA_HOME/jre/lib/security/

Note: keep jce_policy.zip at a save place.

## Installation

### Stop Hadoop services
Stop services

    for x in `cd /etc/init.d ; ls hadoop-*` ; do service $x stop ; done
    for x in `cd /etc/init.d ; ls hbase-*` ; do service $x stop ; done

### Setup KDC
Install software

    apt-get install krb5-kdc krb5-admin-server

Adapt Configuration

    python scripts/shadow.py config/CLASSES/kerberos_kdc/config /

Create Realm

    kdb5_util create -s -r $REALM
    <enter realm password by hand> 
    
Start KDC Services

    /etc/init.d/krb5-kdc start
    /etc/init.d/krb5-admin-server start

### Create Trust Relationship with AD.UTWENTE.NL
Enter trust relationship with AD domain.

    kinit kadmin/admin@$REALM
    kadmin.local -r $REALM -q "addprinc -e "aes256-cts:normal" krbtgt/$REALM@AD.UTWENTE.NL"
    <enter trust password twice>

### Create Principals and Export Keytabs
First create principals and export keytabs
<on kdc server>
    mkdir $SAFE
    chmod 0700 $SAFE
  
    kinit -r $REALM -p kadmin/admin@$REALM
    <enter new password>
      
    # for each host 
    # Foreach master or regionserver do the following 
    for i in $(seq 1 9); do
      #adapt to CTIT
      FQN=$(printf "farm%02d.ewi.utwente.nl" $i)

      kadmin.local -r $REALM -q "addprinc -randkey hdfs/$FQN@$REALM"
      kadmin.local -r $REALM -q "addprinc -randkey mapred/$FQN@$REALM"
      kadmin.local -r $REALM -q "addprinc -randkey yarn/$FQN@$REALM"
      kadmin.local -r $REALM -q "addprinc -randkey HTTP/$FQN@$REALM"
      kadmin.local -r $REALM -q "addprinc -randkey hbase/$FQN@$REALM"

      kadmin.local -r $REALM -q "xst -norandkey -k $FQN.hdfs.keytab hdfs/$FQN@$REALM HTTP/$FQN@$REALM"
      kadmin.local -r $REALM -q "xst -norandkey -k $FQN.hdfs.keytab hdfs/$HOST@$REALM HTTP/$FQN@$REALM"
      kadmin.local -r $REALM -q "xst -norandkey -k $FQN.mapred.keytab mapred/$FQN@$REALM HTTP/$FQN@$REALM"
      kadmin.local -r $REALM -q "xst -norandkey -k $FQN.yarn.keytab mapred/$FQN@$REALM yarn/$FQN@$REALM HTTP/$FQN@$REALM"
      kadmin.local -r $REALM -q "xst -norandkey -k $FQN.yarn.keytab hbase/$FQN@$REALM"
    done
    
### Install Configuration Files
<on each datanode>
  
    cat >> /etc/default/hadoop-hdfs-datanode <<EOF
    export HADOOP_SECURE_DN_USER=hdfs
    export HADOOP_SECURE_DN_PID_DIR=/var/lib/hadoop-hdfs
    export HADOOP_SECURE_DN_LOG_DIR=/var/log/hadoop-hdfs
    export JSVC_HOME=/usr/lib/bigtop-utils/
    EOF 
    
Adapt PID file for datanode
    
    sed -i.bak -e 's@PIDFILE=".*"@PIDFILE="/var/lib/hadoop-hdfs/hadoop_secure_dn.pid"@g' /etc/init.d/hadoop-hdfs-datanode

Note: without changing the PID file, starting a datanode would succeed but the controlling script would return an error:
```
starting datanode, logging to /var/log/hadoop-hdfs/hadoop-hdfs-datanode-farm01.out
 * Failed to start Hadoop datanode. Return value: 3
 * Datanode doesn't start
```
This can be solved by adapting the PID file.

### Start Hadoop services
Stop services

    for x in `cd /etc/init.d ; ls hadoop-*` ; do service $x start ; done
    for x in `cd /etc/init.d ; ls hbase-*` ; do service $x start ; done


## HTTPs Configuration


### Create Keys and Certificate Signing Requests

    echo "PASSWORD" > keypassword
    chmod 0400 keypassword
    openssl rand -base64 32 > publicpass
    openssl rand -base64 10 > shortpass
    export KEYPASSWORD=$(cat /root/certificates/keypassword)
    for i in $(seq 1 9); do H=$(printf "farm%02d" $i); openssl genrsa -passout file:keypassword -out $H.ewi.utwente.nl.key 2048; done
    for i in $(seq 1 9); do H=$(printf "farm%02d" $i); openssl req -new -passin file:keypassword -sha256 -key $H.ewi.utwente.nl.key -out $H.ewi.utwente.nl.csr -subj "/C=NL/ST=OV/L=Enschede/O=University of Twente/OU=CTIT/CN=$H.ewi.utwente.nl"; done
    for i in $(seq 1 48); do H=$(printf "ctit%03d" $i); openssl genrsa -passout file:keypassword -out $H.ewi.utwente.nl.key 2048; done
    for i in $(seq 1 48); do H=$(printf "ctit%03d" $i); openssl req -new -passin file:keypassword -sha256 -key $H.ewi.utwente.nl.key -out $H.ewi.utwente.nl.csr -subj "/C=NL/ST=OV/L=Enschede/O=University of Twente/OU=CTIT/CN=$H.ewi.utwente.nl"; done

.... submit certificate requests (*.csr) to ICTS and wait for certificate (*.zip)

### Convert Obtained Certificates To Hadoop Compatible

Copy certificates into root directory of ~dbeheer:
    
    cd $SAFE
    unzip ~dbeheer/$(hostname)_ewi_utwente_nl*.zip
    rm ~dbeheer/$(hostname)_ewi_utwente_nl*.zip
    cp $(hostname)_ewi_utwente_nl*/*p7b .
    rm -rf $(hostname)_ewi_utwente_nl_*
    export host=$(hostname).ewi.utwente.nl
    openssl pkcs7 -print_certs -in $host_ewi_utwente_nl.p7b -outform PEM -out $host.crt
    openssl pkcs12 -export -in $host.crt -passin file:keypassword -inkey $host.key -passout file:shortpass -name $host -out $host.p12

    # Import into private keystore

    keytool -list -storepass:file shortpass -storetype pkcs12 -keystore $host.p12 
    keytool -importkeystore -srcstoretype pkcs12 -srcstorepass:file shortpass -srckeystore $host.p12 -alias $host -deststorepass:file keypassword  -destkeystore $host.jks
    rm $host.p12

    keytool -export -alias $host -keystore $host.jks -rfc -storepass:file keypassword -file $host.cer

    # Import into trust stores
    keytool -import -trustcacerts -storepass:file publicpass -alias $host -noprompt -file $host.crt -keystore $host.trust.jks
    keytool -list -storepass:file publicpass -v -keystore $host.trust.jks

    keytool -import -trustcacerts -storepass:file publicpass -alias $host -noprompt -file $host.crt -keystore $REALM.jks
    keytool -list -storepass:file publicpass -v -keystore $REALM.jks 

