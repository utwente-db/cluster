set -x
set -e
FILE=/tmp/java8
if [ ! -f "$FILE" ]; then
  apt-get update && apt-get --yes --no-install-recommends install software-properties-common
  add-apt-repository -y ppa:webupd8team/java 
  (
  echo "deb http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" 
  echo "deb-src http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main"
  ) > /etc/apt/sources.list.d/java8.list
  apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys EEA14886
  echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections
  apt-get install --yes --no-install-recommends oracle-java8-installer
  apt-get install oracle-java8-set-default
  (echo ""; echo "export JAVA_HOME=/usr/lib/jvm/java-8-oracle") >> /etc/profile
  (echo ""; echo "export JAVA_HOME=/usr/lib/jvm/java-8-oracle") >> /etc/bash.bashrc
  . /etc/profile
  export JAVA_HOME=/usr/lib/jvm/java-8-oracle
  cp -av /home/dbeheer/jce_policy/UnlimitedJCEPolicyJDK8/local_policy.jar $JAVA_HOME/jre/lib/security/
  cp -av /home/dbeheer/jce_policy/UnlimitedJCEPolicyJDK8/US_export_policy.jar $JAVA_HOME/jre/lib/security/
  date > $FILE
fi
set +x
set +e