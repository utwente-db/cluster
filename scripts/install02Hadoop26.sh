set -x
set -e
BASE=/home/dbeheer/cluster
BASECONFIG=$BASE/config/CLASSES
FILE=/tmp/hadoop
if [ ! -f "$FILE" ]; then
  export REALM=CTIT-KRB.UTWENTE.NL
  export CENTRALNODE=farm02
  export DEBIAN_FRONTEND=noninteractive
  
  cp -av $BASECONFIG/base/config/CLOUDERA.LIST /etc/apt/sources.list.d/cloudera.list
  cp -av $BASECONFIG/base/config/cloudera.pref /etc/apt/preferences.d/
  $BASE/scripts/shadow.py $BASECONFIG/hdfs/basic/config/yarn-site.xml /etc/hadoop/conf/yarn-site.xml
  cp -av $BASECONFIG/hdfs/basic/config/hadoop-policy.xml /etc/hadoop/conf/
  cp -av $BASECONFIG/hdfs/basic/config/hadoop-env.sh /etc/hadoop/conf/
  apt-get update

  # adjust file permissions
  chown hdfs /etc/hadoop/conf/hdfs.keytab 
  chown yarn /etc/hadoop/conf/yarn.keytab 
  chown mapred /etc/hadoop/conf/mapred.keytab 

  # temporarily deactivate starting of services
  # https://major.io/2014/06/26/install-debian-packages-without-starting-daemons/
cat > /usr/sbin/policy-rc.d << EOF
#!/bin/sh
echo "All runlevel operations denied by policy" >&2
exit 101
EOF

  # install/update hadoop, keeping already installed configuration files
  # -o Dpkg::Options::="--force-confold"
  apt-get -o Dpkg::Options::="--force-confold" install --yes --no-install-recommends hadoop
  
  # for package in $(dpkg --get-selections | grep -i hadoop); do
  #   apt-cache policy $package
  # done
  
  # activate starting of services from debian packages again
  rm /usr/sbin/policy-rc.d
  
  # adjust file permissions
  chown hdfs /etc/hadoop/conf/hdfs.keytab 
  chown yarn /etc/hadoop/conf/yarn.keytab 
  chown mapred /etc/hadoop/conf/mapred.keytab 
  
  # mark job as done
  date > $FILE
fi
set +x
set +e