Different cluster modes

spark-cluster

yarn

./bin/spark-submit --class org.apache.spark.examples.SparkPi --master yarn-cluster --num-executors 3 --driver-memory 4g --executor-memory 2g --executor-cores 1  --queue thequeue lib/spark-examples*.jar 10