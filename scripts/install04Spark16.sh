set -x
set -e
BASE=/home/dbeheer/cluster
BASECONFIG=$BASE/config/CLASSES
export REALM=CTIT-KRB.UTWENTE.NL
export CENTRALNODE=farm02

export SPARK_VERSION=1.6.0-cdh5.9.0

# General information on spark with cloudera
# http://www.cloudera.com/documentation/enterprise/latest/topics/cdh_ig_running_spark_on_yarn.html

FILE=/tmp/uninstall-old-spark
if [ ! -f "/tmp/spark" ] && [ ! -f "$FILE" ]; then
  # remove old spark installation from .tgz
  rm -rf /usr/lib/spark  
  date > $FILE
fi

FILE=/tmp/spark
if [ ! -f "$FILE" ]; then
  # install/update hadoop, keeping already installed configuration files
  # using -o Dpkg::Options::="--force-confold"
  # For package description see
  # http://www.cloudera.com/documentation/enterprise/latest/topics/cdh_ig_spark_package.html#spark_packages
  PACKAGES="spark-core spark-python"
  # install history server on central node
  if [ "$HOSTNAME" == "farm02" ] || [ "$HOSTNAME" == "ctit048" ]; then
    PACKAGES="$PACKAGES spark-history-server"
  fi
  export DEBIAN_FRONTEND=noninteractive
  apt-get -o Dpkg::Options::="--force-confold" install --yes --no-install-recommends $PACKAGES

  # mark job as done
  date > $FILE
fi

# install/update configuration scripts
$BASE/scripts/shadow.py -f $BASECONFIG/spark/basic/config/log4j.properties /etc/spark/conf/log4j.properties
$BASE/scripts/shadow.py -f $BASECONFIG/spark/basic/config/spark-env.sh /etc/spark/conf/spark-env.sh
$BASE/scripts/shadow.py -f $BASECONFIG/spark/basic/config/spark-defaults.conf /etc/spark/conf/spark-defaults.conf

set +x
set +e