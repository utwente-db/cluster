echo "Piglatin"
echo "------------------"
hdfs dfs -put testfile /tmp/testfile
pig -x mapreduce wordcount.pig 
hdfs dfs -cat /tmp/pigout/part* | grep sendmail
echo "should output one line"
hdfs dfs -rm -r /tmp/pigout
