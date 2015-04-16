#!/bin/bash
set -e
IN=/tmp/filein-$RANDOM
export HADOOP_ROOT_LOGGER=WARN,console


echo "HDFS"
echo "------------------"
echo "Ls form hdfs"
hdfs dfs -ls /
echo "Write to hdfs /tmp"
hdfs dfs -put /etc/passwd $IN

echo "Read from hdfs"
hdfs dfs -cat $IN | head -n 2

echo ""
echo "Press Enter"
read A

echo "Map Reduce"
echo "------------------"
export PATH=$JAVA_HOME/bin:$PATH
export HADOOP_CLASSPATH=$JAVA_HOME/lib/tools.jar
hadoop com.sun.tools.javac.Main WordCount.java
jar cf wc.jar WordCount*.class
OUT=/tmp/fileout-$RANDOM
hadoop jar wc.jar WordCount $IN $OUT
hdfs dfs -cat $OUT/part-r-00000
echo "should output two lines"
hdfs dfs -rm -r $OUT
hdfs dfs -rm $IN

echo ""
echo "Press Enter"
read A

echo "Piglatin"
echo "------------------"
pig -x mapreduce wordcount.pig | grep -v INFO
hdfs dfs -cat /tmp/pigout/part* | grep sendmail
echo "should output one line"
hdfs dfs -rm -r /tmp/pigout
echo ""
echo "Press Enter"
read A

echo "HBase"
echo "------------------"
TABLE=test-$RANDOM
echo "create '$TABLE', 'test'" | hbase shell
echo "list" | hbase shell
echo "put '$TABLE','test','test','value'" | hbase shell
echo "get '$TABLE','test','test'" | hbase shell
echo "You should see"
echo " test:                                              timestamp=1429172811893, value=value "

echo "disable '$TABLE'" | hbase shell
echo "drop '$TABLE'" | hbase shell
echo ""
echo "Press Enter"
read A

echo "Storm"
echo "------------------"
OLDPWD=$PWD
git clone git://github.com/apache/storm.git && cd storm
git checkout v0.9.2-incubating
cd examples/storm-starter
mvn clean install -DskipTests=true
storm jar target/storm-starter-0.9.2-incubating-jar-with-dependencies.jar storm.starter.WordCountTopology test
storm list
echo "should end with"
echo "test                 ACTIVE     28         3            10"
storm kill test
cd $OLDPWD
rm -rf storm 

echo ""
echo "Press Enter"
read A
