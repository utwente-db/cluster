echo "HDFS"
echo "------------------"
echo "Ls form hdfs"
if [ -z "$IN" ]; then
	IN=/tmp/test
fi 
hdfs dfs -ls /
echo "Write to hdfs $IN"
echo "The hadoop file system is accessed using the 'hdfs dfs' program"
echo "The program accepts commands similar to unix directory commands"
echo ""
echo "For example:"
echo "List directory '/' form hdfs"
hdfs dfs -ls /
echo ""
echo "Create directory test under the user's home directory"
hdfs dfs -mkidr test
echo ""
echo "Remove directory test from the user's home directory"
hdfs dfs -rm -r test
echo ""
echo "Write to file testfile to $IN (points to /tmp/test)"
hdfs dfs -put testfile $IN
echo ""
echo "Output file from hdfs"
hdfs dfs -cat $IN | head -n 2
