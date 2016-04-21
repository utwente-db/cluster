echo "Map Reduce"
echo "------------------"
echo "This section explains creates a minimalistic map reduce job."
echo ""
echo "First set required variables"
export PATH=$JAVA_HOME/bin:$PATH
export HADOOP_CLASSPATH=$JAVA_HOME/lib/tools.jar
if [ -z "$IN" ]; then
	IN=/tmp/test-$RANDOM
fi 
hdfs dfs -put testfile $IN
echo "==="
echo "Compile the accompanying wordcount example."
echo "We use the hadoop command instead of an direct call to javac because"
echo "the former sets adds the necessary jar files to the classpath."
hadoop com.sun.tools.javac.Main WordCount.java
echo "==="
echo "Package the example into a jar file"
jar cf wc.jar WordCount*.class
echo "==="
echo "Set output destination"
OUT=/tmp/fileout-$RANDOM
echo "Run the map reduce job invoking the main class of WordCount in the wc.jar file"
hadoop jar wc.jar WordCount $IN $OUT
echo "==="
echo "The output of a map reduce job is a directory with potentially many part-r-xxxx files"
echo "Each of these files contains the output of a reducer."
hdfs dfs -cat $OUT/part-r-00000 | tail -n 2
echo "==="
echo "Remove the test output directory"
hdfs dfs -rm -r $OUT
echo "==="
echo "Remove the test input file"
hdfs dfs -rm $IN
