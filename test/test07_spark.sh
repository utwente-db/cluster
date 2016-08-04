echo "SPARK"
echo "------------------"
echo "Upload test data"
export IN=/tmp/test-$RANDOM
export OUT=/tmp/out-$RANDOM
export OUT2=/tmp/out-$RANDOM
hdfs dfs -put testfile $IN

echo "Trying spark-shell"
perl -p -e 's/\$\{([^}]+)\}/defined $ENV{$1} ? $ENV{$1} : $&/eg; s/\$\{([^}]+)\}//eg' wordcount.spark > wordcount.spark.test
cat wordcount.spark.test | spark-shell --master yarn-client
hdfs dfs -cat $OUT/part*
echo "Delete output"
hdfs dfs -rm -r $OUT

echo "Trying git repository"
git clone https://github.com/robinaly/ctit-spark.git
cd ctit-spark
mvn package
echo "Setenv"
. setenv
echo "Wordcount"
runTool JavaWordCount $IN $OUT
cd ..
#rm -rf ctit-spark
echo "Delete output"
hdfs dfs -rm -r $OUT

echo "Deleting test data"
hdfs dfs -rm -r $IN
