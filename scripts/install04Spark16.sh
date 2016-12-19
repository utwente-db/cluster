set -x
set -e
BASE=/home/dbeheer/cluster
BASECONFIG=$BASE/config/CLASSES
export REALM=CTIT-KRB.UTWENTE.NL
export CENTRALNODE=farm02
export DEBIAN_FRONTEND=noninteractive

FILE=/tmp/spark
if [ ! -f "$FILE" ]; then
  
  # remove old spark installation from .tgz
  rm -rf /usr/lib/spark
  
  # install/update hadoop, keeping already installed configuration files
  # -o Dpkg::Options::="--force-confold"
  PACKAGES=spark-core
  if [ "$HOSTNAME" == "farm02" ]; then
    PACKAGES="$PACKAGES spark-history-server"
  fi 
  apt-get -o Dpkg::Options::="--force-confold" install --yes --no-install-recommends $PACKAGES

  # install configuration scripts
  $BASE/scripts/shadow.py $BASECONFIG/spark/basic/config/spark-env.sh /etc/spark/conf/spark-env.sh
  $BASE/scripts/shadow.py $BASECONFIG/spark/basic/config/spark-defaults.conf /etc/spark/conf/spark-defaults.conf
  
  # mark job as done
  date > $FILE
fi
set +x
set +e