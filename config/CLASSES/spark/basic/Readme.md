# Spark Basic Installation

## Variables

    export CENTRALNODE=farm02

## Preparation
Install Scala
    wget www.scala-lang.org/files/archive/scala-2.11.7.deb
    dpkg -i scala-2.11.7.deb
    #apt-get install scala

remove old version

    rm -rf /usr/lib/spark

## Installation 

download newest version of spark

    VERSION=2.0.2
    wget http://d3kbcqa49mib13.cloudfront.net/spark-$VERSION-bin-hadoop2.6.tgz
    tar xvzp -f spark-$VERSION-bin-hadoop2.6.tgz
    cp -r spark-$VERSION-bin-hadoop2.6 /usr/lib/

copy configuration 

    ../scripts/shadow.py config/ /usr/lib/spark/conf/

Add Global Variables

    export HADOOP_CONF_DIR=/etc/hadoop/conf
    export SPARK_HOME=/usr/lib/spark-$VERSION-*
    export PATH=$SPARK_HOME/bin:$PATH

## Restart the `ResourceManager` and all `NodeManagers`.

    # on nodes of class yarn/resourcemanager
    /etc/init.d/hadoop-yarn-resourcemanager restart
    
    # on nodes of class yarn/nodemanager
    /etc/init.d/hadoop-yarn-nodemanager restart

## Testing script

$SPARK_HOME./bin/spark-submit --class org.apache.spark.examples.SparkPi --master yarn --deploy-mode cluster --queue thequeue lib/spark-examples*.jar 10