# Spark Basic Installation

## Variables

    export CENTRALNODE=farm02

## Preparation
Install Scala

    apt-get install scala

remove old version

    rm -rf /usr/lib/spark

## Installation 

download newest version of spark

    VERSION=1.6.0
    wget http://d3kbcqa49mib13.cloudfront.net/spark-$VERSION-bin-hadoop2.6.tgz
    tar xvzp -f spark-$VERSION-bin-hadoop2.6.tgz
    mv spark-$VERSION-bin-hadoop2.6.tgz /usr/lib/spark
    rm spark-$VERSION-bin-hadoop2.6.tgz

copy configuration 

    ../scripts/shadow.py config/ /usr/lib/spark/conf/

Add Global Variables

    export HADOOP_CONF_DIR=/etc/hadoop/conf
    export PATH=/usr/lib/spark/bin:$PATH

## Testing script

./bin/spark-submit --class org.apache.spark.examples.SparkPi --master yarn-cluster --num-executors 3 --driver-memory 4g --executor-memory 2g --executor-cores 1  --queue thequeue lib/spark-examples*.jar 10