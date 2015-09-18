echo "HDFS"
echo "------------------"
echo "Ls form hdfs"
hdfs dfs -ls /
echo "Write to hdfs /tmp"
hdfs dfs -put testfile $IN

echo "Read from hdfs"
hdfs dfs -cat $IN | head -n 2
