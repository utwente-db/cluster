set -x
set -e
BASE=/home/dbeheer/cluster
BASECONFIG=$BASE/config/CLASSES
FILE=/tmp/hbase
if [ ! -f "$FILE" ]; then
  export REALM=CTIT-KRB.UTWENTE.NL
  export CENTRALNODE=farm02
  export DEBIAN_FRONTEND=noninteractive
  
  # temporarily deactivate starting of services
  # https://major.io/2014/06/26/install-debian-packages-without-starting-daemons/
cat > /usr/sbin/policy-rc.d << EOF
#!/bin/sh
echo "All runlevel operations denied by policy" >&2
exit 101
EOF

  # install/update hadoop, keeping already installed configuration files
  # -o Dpkg::Options::="--force-confold"
  apt-get -o Dpkg::Options::="--force-confold" install --yes --no-install-recommends zookeeper hbase
  
  # activate starting of services from debian packages again
  rm /usr/sbin/policy-rc.d
  
  # adjust file permissions
  chown hbase /etc/hbase/conf/hbase.keytab 
  
  # mark job as done
  date > $FILE
fi
set +x
set +e