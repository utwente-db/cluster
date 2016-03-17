# HBase Basic 

## References
http://www.cloudera.com/documentation/enterprise/5-2-x/topics/cdh_sg_hbase_security.html
http://www.cloudera.com/documentation/enterprise/5-2-x/topics/cdh_sg_hbase_authorization.html

## Variables

    export REALM=FARM.UTWENTE.NL
    export CENTRALNODE=farm02
    export HOST=farm02

## Installation

    sudo apt-get install hbase

## Install Keytabs
<on the kdc server>
  
    #login
    kinit kadmin/admin@$REALM 
    cd ~dbeheer
    
    # Foreach master or regionserver do the following (adapt to CTIT)
    for i in $(seq 1 9); do
      FQN=$(printf "farm%02d.ewi.utwente.nl" $i)
      kadmin.local -r $REALM -q "xst -k $FQN.hbase.keytab hbase/$FQN"
    done

<on each host (regionserver / master)>
  
    FQN=$(hostname).ewi.utwente.nl
    mv $FQN.hbase.keytab /etc/hbase/conf/hbase.keytab
    chown hbase:hadoop /etc/hbase/conf/*.keytab
    chmod 0400 /etc/hbase/conf/*.keytab

## Update  Configuration Files

cat hbase-site.xml | perl -pe 's/\$(\w+)/$ENV{$1}/g' > /etc/hbase/conf/hbase-site.xml
cat zk-jaas.conf | perl -pe 's/\$(\w+)/$ENV{$1}/g' > /etc/hbase/conf/zk-jaas.conf
echo 'export HBASE_OPTS="$HBASE_OPTS -Djava.security.auth.login.config=/etc/hbase/conf/zk-jaas.conf -Djava.security.krb5.conf=/etc/krb5.farm.conf"' >> /etc/hbase/conf/hbase-env.sh
echo 'export HBASE_MANAGES_ZK=false' >> /etc/hbase/conf/hbase-env.sh

#
*Note changes in zookeeper/server / zoo.cfg*
