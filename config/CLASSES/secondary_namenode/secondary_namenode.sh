# basic should be installed for this

apt-get install hadoop-hdfs-secondarynamenode

mkdir /local/hadoop/dfs/checkpoints
chown -R hdfs /local/hadoop/dfs/checkpoints
/etc/init.d/hadoop-hdfs-secondarynamenode restart 
