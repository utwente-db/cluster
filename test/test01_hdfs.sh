echo "HDFS"
echo "------------------"
echo "Ls form hdfs"
if [ -z "$IN" ]; then
	IN=/tmp/test
fi 
hdfs dfs -ls /
echo "Write to hdfs $IN"
hdfs dfs -put testfile $IN

echo "Read from hdfs"
hdfs dfs -cat $IN | head -n 2
