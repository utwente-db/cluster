== 06th January 2015 ==

systems.ctit: hbase_common => hbase_basic

supervisior: moved config/supervisord.conf to config/supervisor.conf and adapted the install
             to copying to /etc/supervisor/, producing a link from /etc/supervisor.conf and
						 pointing the init.d script to it

basic: apt-get preferences to always prefer packages coming from cloudera, this should install 

storm_nimbus: adapted path in storm_nimubs_supervisor.conf

storm_basic: adapted path to storm

storm_supervisor: removed unnecessary placement of configfile

basic,datanode,namenode: added specific version number 2.3.0 to the apt-get install commands

== 18th December 2014 ==

CLASSES: 

basic:
	added installation of maven
	changed hdfs port in core-site.xml to standard (8020), 
	changed default number of reducers in mapred-site.xml

hbase_basic:
	new class containing the software installation & configuration of hbase. no services are started.
	
hbase_mater:
	hbase master: moved software installation and configuration to hbase_basic
	
hbase_mater:
	hbase master: moved software installation and configuration to hbase_basic

kafa:
	moved software installation and basic configuration to kafka_basic, added supervisord 'module' for /etc/supervisor/conf.d;
	added dependency to kafka_basic

kafka_basic:
	new class; basic installation, configuration and setting of paths

pig_basic:
	new class; basic installation and adaptation of script
	
storm_basic:
	new class; basic installation (now under /usr/lib/storm to ensure software is wiped if class is removed) and configuration ; data remains on  /local

storm_nimbus:
	moved software installation and basic configuration to storm_basic, added supervisord 'module' for /etc/supervisor/conf.d
	added dependency to storm_basic

storm_supervisor:
	moved software installation and basic configuration to storm_basic, added supervisord 'module' for /etc/supervisor/conf.d
	added dependency to storm_basic
	
supervisor:
	removed service specific modules 
	changed main configuration files to /etc/supervisord.conf (note the d before .conf) because this is assumed by supervisorctl

zookeeper_server:
	added config file which removes the limitations of connections per node (installation described in zookeeper_server.sh)

CLASS ASSIGNMENTS

systems.ctit: 
	added ctithead machines; did not add supervisor, kafka_basic, and storm_basic because I assume they are automatically installed (dependency)
	
systems.farm
	updated classes for farm09
	
PORTS
	new file containing ports used / required for firewall
	


