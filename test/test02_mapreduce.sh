echo "Map Reduce"
echo "------------------"
export PATH=$JAVA_HOME/bin:$PATH
export HADOOP_CLASSPATH=$JAVA_HOME/lib/tools.jar
hadoop com.sun.tools.javac.Main WordCount.java
jar cf wc.jar WordCount*.class
OUT=/tmp/fileout-$RANDOM
hadoop jar wc.jar WordCount $IN $OUT
echo "The following command should output two lines"
hdfs dfs -cat $OUT/part-r-00000 | tail -n 2
hdfs dfs -rm -r $OUT
hdfs dfs -rm $IN
