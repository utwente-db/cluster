echo "Piglatin"
echo "------------------"
echo "This script explains how to run pig latin scripts. "
echo "Pig latin scripts are run as follows"
pig -x mapreduce wordcount.pig | grep -v INFO
echo "The following command should output one line:"
hdfs dfs -cat /tmp/pigout/part* | grep sendmail
echo "Removing temporary direcory"
hdfs dfs -rm -r /tmp/pigout
