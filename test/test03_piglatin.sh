echo "Piglatin"
echo "------------------"
pig -x mapreduce wordcount.pig | grep -v INFO
hdfs dfs -cat /tmp/pigout/part* | grep sendmail
echo "should output one line"
hdfs dfs -rm -r /tmp/pigout
