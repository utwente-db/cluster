# Set Hadoop-specific environment variables here.

# The only required environment variable is JAVA_HOME.  All others are
# optional.  When running a distributed configuration it is best to
# set JAVA_HOME in this file, so that it is correctly defined on
# remote nodes.

# The java implementation to use.  Required.
export JAVA_HOME=/usr/lib/jvm/java-7-oracle
export HADOOP_OPTS="$HADOOP_OPTS -Djava.security.krb5.conf=/etc/krb5.farm.conf"
