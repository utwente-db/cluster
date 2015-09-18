echo "HBase"
echo "------------------"
TABLE=test-$RANDOM
echo "create '$TABLE', 'test'" | hbase shell
echo "list" | hbase shell
echo "put '$TABLE','test','test','value'" | hbase shell
echo "get '$TABLE','test','test'" | hbase shell
echo "You should see"
echo " test:                                              timestamp=1429172811893, value=value "

echo "disable '$TABLE'" | hbase shell
echo "drop '$TABLE'" | hbase shell
