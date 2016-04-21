echo "HBase"
echo "------------------"
echo "This script explains the base commands for using hbase."
TABLE=test:test-$RANDOM
echo "==="
echo "To create a table"
echo "create '$TABLE', 'test'" | hbase shell
echo "==="
echo "To list all tables"
echo "list" | hbase shell
echo "==="
echo "To put a record into the temporary table"
echo "put '$TABLE','test','test','value'" | hbase shell
echo "==="
echo "To get a column value from the temporary table"
echo "get '$TABLE','test','test'" | hbase shell
echo "You should see"
echo " test:                                              timestamp=1429172811893, value=value "
echo "==="
echo "To delete a table you first have to disable it and the to drop it."
echo "disable '$TABLE'" | hbase shell
echo "drop '$TABLE'" | hbase shell
