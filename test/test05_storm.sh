echo "Storm"
echo "------------------"
OLDPWD=$PWD
git clone git://github.com/apache/storm.git && cd storm
git checkout v0.9.2-incubating
cd examples/storm-starter
mvn clean install -DskipTests=true
storm jar target/storm-starter-0.9.2-incubating-jar-with-dependencies.jar storm.starter.WordCountTopology test
storm list
echo "should end with"
echo "test                 ACTIVE     28         3            10"
storm kill test
cd $OLDPWD
rm -rf storm 

