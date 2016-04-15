# Kerberos KDC / HTTPS Certificates

## References
Script created according to
* [General Info on KDC / UBUNTU Site](https://help.ubuntu.com/community/Kerberos)
* [Integration with hadoop: Cloudera Site](http://www.cloudera.com/documentation/enterprise/5-2-x/topics/cdh_sg_cdh5_install.html)
* [IBM Site]( https://www-01.ibm.com/support/knowledgecenter/SSPT3X_4.1.0/com.ibm.swg.im.infosphere.biginsights.admin.doc/doc/admin_ssl_hbase_mr_yarn_hdfs_web.html)

## Variables

    # The REALM that should be configured 
    export REALM=FARM.UTWENTE.NL
    # The central node that contains the namenode, resource manager etc
    export CENTRALNODE=farm02
    # The current host
    export HOST=farm02
    # a safe directory where files can be exchanged between the kdc host and the clients
    export SAFE=~dbeheer/safe


## Installation

### Setup KDC
Install software packages required to run a kdc

    apt-get install krb5-kdc krb5-admin-server

Adapt Configuration

    python scripts/shadow.py config/CLASSES/kerberos_kdc/config /

Create Realm Database 

    kdb5_util create -s -r $REALM -P $TRUSTPASSWORD
    <enter realm password by hand> 
    
Start KDC Services

    /etc/init.d/krb5-kdc start
    /etc/init.d/krb5-admin-server start

### Create Trust Relationship with AD.UTWENTE.NL

To create a trust relationship with AD domain:

    kadmin.local -r $REALM -q "addprinc -pw $TRUSTPASSWORD -e "aes256-cts:normal" krbtgt/$REALM@AD.UTWENTE.NL"
    <enter trust password twice>

## Administration
### Create Principals and Export Keytabs

Create principals and export keytabs
<on kdc server>
  
    mkdir -p $SAFE
    chmod 0700 $SAFE
    cd $SAFE
  
    # for each host 
    # Foreach node do the following 
    for i in $(seq 1 9); do
      #adapt to CTIT
      FQN=$(printf "farm%02d.ewi.utwente.nl" $i)

      kadmin.local -r $REALM -q "addprinc -randkey hdfs/$FQN@$REALM"
      kadmin.local -r $REALM -q "addprinc -randkey mapred/$FQN@$REALM"
      kadmin.local -r $REALM -q "addprinc -randkey yarn/$FQN@$REALM"
      kadmin.local -r $REALM -q "addprinc -randkey HTTP/$FQN@$REALM"
      kadmin.local -r $REALM -q "addprinc -randkey hbase/$FQN@$REALM"
      kadmin.local -r $REALM -q "addprinc -randkey zookeeper/$HOST@$REALM"
      kadmin.local -r $REALM -q "addprinc -randkey hbase/$HOST@$REALM"
      
      kadmin.local -r $REALM -q "xst -norandkey -k $FQN.hdfs.keytab hdfs/$FQN@$REALM HTTP/$FQN@$REALM"
      kadmin.local -r $REALM -q "xst -norandkey -k $FQN.mapred.keytab mapred/$FQN@$REALM HTTP/$FQN@$REALM"
      kadmin.local -r $REALM -q "xst -norandkey -k $FQN.yarn.keytab mapred/$FQN@$REALM yarn/$FQN@$REALM HTTP/$FQN@$REALM"
      kadmin.local -r $REALM -q "xst -norandkey -k $FQN.hbase.keytab hbase/$FQN@$REALM"
      kadmin.local -r $REALM -q "xst -norandkey -k $FQN.zookeeper.keytab zookeeper/$HOST"
      kadmin.local -r $REALM -q "xst -norandkey -k $FQN.hbase.keytab zookeeper/$HOST"
    done

### HTTPs Configuration

#### Create Keys and Certificate Signing Requests

    openssl rand -base64 32 > keypassword
    chmod 0400 keypassword
  
    openssl rand -base64 32 > publicpass
    chmod 0400 publicpass
    
    
    # Create Keys
    for i in $(seq 1 9); do H=$(printf "farm%02d" $i); openssl genrsa -passout file:keypassword -out $H.ewi.utwente.nl.key 2048; done
    for i in $(seq 1 9); do H=$(printf "farm%02d" $i); openssl req -new -passin file:keypassword -sha256 -key $H.ewi.utwente.nl.key -out $H.ewi.utwente.nl.csr -subj "/C=NL/ST=OV/L=Enschede/O=University of Twente/OU=CTIT/CN=$H.ewi.utwente.nl"; done
    for i in $(seq 1 48); do H=$(printf "ctit%03d" $i); openssl genrsa -passout file:keypassword -out $H.ewi.utwente.nl.key 2048; done
    for i in $(seq 1 48); do H=$(printf "ctit%03d" $i); openssl req -new -passin file:keypassword -sha256 -key $H.ewi.utwente.nl.key -out $H.ewi.utwente.nl.csr -subj "/C=NL/ST=OV/L=Enschede/O=University of Twente/OU=CTIT/CN=$H.ewi.utwente.nl"; done

.... submit certificate requests (*.csr) to ICTS and wait for certificate (*.zip)

#### Convert Obtained Certificates To Hadoop Compatible

Once the certificates are signed by ICTS, copy them into $SAFE:
    
    cd $SAFE
    
    unzip ~dbeheer/$(hostname)_ewi_utwente_nl*.zip
    rm ~dbeheer/$(hostname)_ewi_utwente_nl*.zip
    cp $(hostname)_ewi_utwente_nl*/*p7b .
    rm -rf $(hostname)_ewi_utwente_nl_*
    
    openssl rand -base64 10 > shortpass
    chmod 0400 shortpass
    
    for i in $(seq 1 48); do
      export HOST=$(printf "ctit%03d" $i)
      #export HOST=$(printf "farm%02d" $i)
      export host=$HOST.ewi.utwente.nl
      echo Converting keys
      openssl pkcs7 -print_certs -in ${HOST}_ewi_utwente_nl.p7b -outform PEM -out $host.crt
      openssl pkcs12 -export -in $host.crt -passin file:keypassword -inkey $host.key -passout file:shortpass -name $host -out $host.p12

      echo Import into private keystore
      keytool -list -storepass:file shortpass -storetype pkcs12 -keystore $host.p12 
      keytool -importkeystore -srcstoretype pkcs12 -srcstorepass:file shortpass -srckeystore $host.p12 -alias $host -deststorepass:file keypassword  -destkeystore $host.jks
      rm $host.p12 #remove intermediate file

      echo Export certificate
      keytool -export -alias $host -keystore $host.jks -rfc -storepass:file keypassword -file $host.cer

      echo Import into trust stores
      keytool -import -trustcacerts -storepass:file publicpass -alias $host -noprompt -file $host.crt -keystore $host.trust.jks
      # debugging keytool -list -storepass:file publicpass -keystore $host.trust.jks

      echo Import into realm store
      keytool -import -trustcacerts -storepass:file publicpass -alias $host -noprompt -file $host.crt -keystore $REALM.jks
      # debugging keytool -list -storepass:file publicpass -keystore $REALM.jks 
    done
    
    rm shortpass

