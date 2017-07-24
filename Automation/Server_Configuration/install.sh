#!/bin/bash
curdir=`pwd`

export WAS_HOME=/opt/IBM/WebSphere/AppServer
export WAS_PROFILE=/opt/IBM/WebSphere/Profiles

### Enabling Application Security

$WAS_HOME/bin/wsadmin.sh -lang jython -f $curdir/AppSecurity.jy -username wsadmin

### LDAP Configuration

export LDAP_HOST=cap-sg-prd-4.integration.ibmcloud.com
export LDAP_PORT=17830
export LDAP_SERVER_TYPE=IBM_DIRECTORY_SERVER
export BIND_DN=cn=root
export BIND_PASSWORD=purpleTDS!
export PRIMARY_ADMIN_ID=uid=wasadmin,ou=caseinc,o=sample
export DN=ou=caseinc,o=sample
export LDAPPASSWORD=websphereUser!

$WAS_HOME//virtual/bin/openFirewallPorts.sh -ports 50000:tcp,17830:tcp -persist true

$WAS_HOME/bin/wsadmin.sh -lang jython -f $curdir/LDAPConfig.jy -username wsadmin

$WAS_HOME/bin/stopServer.sh server1 -username wsadmin
### Stop completed
sleep 5
### Restarting the Server
$WAS_PROFILE/DefaultAppSrv01/bin//startServer.sh server1

### Creating J2C authentication alias

export DB2USER=bluadmin
export DB2PASSWORD=ZTA2YzVmYjA2MjU3
export AUTHALIAS=DBUser-ORDERDB

$WAS_PROFILE/DefaultAppSrv01/bin/wsadmin.sh -lang jython -conntype SOAP -username uid=wasadmin,ou=caseinc,o=sample -password websphereUser! -f $curdir/j2cauth.jy -username uid=wasadmin,ou=caseinc,o=sample

export DB2USER=bluadmin
export DB2PASSWORD=OWI1OTI0YTgxYzZi
export AUTHALIAS=DB2User-INVENTORYDB

$WAS_PROFILE/DefaultAppSrv01/bin/wsadmin.sh -lang jython -conntype SOAP -username uid=wasadmin,ou=caseinc,o=sample -password websphereUser! -f $curdir/j2cauth.jy -username uid=wasadmin,ou=caseinc,o=sample

### Creating JDBC provider and Data Sources

export DRIVER_PATH=$WAS_HOME/deploytool/itp/plugins/com.ibm.datatools.db2_2.2.200.v20150728_2354/driver

export DB2HOST=dashdb-txn-flex-yp-dal09-56.services.dal.bluemix.net
export DB2DBNAME=BLUDB
export DB2PORT=50000
export DSNAME=OrderDS
export DSJNDI=jdbc/orderds
export AUTHALIAS=DBUser-ORDERDB
$WAS_PROFILE/DefaultAppSrv01/bin/wsadmin.sh -lang jython -conntype SOAP -username uid=wasadmin,ou=caseinc,o=sample -password websphereUser! -f $curdir/DataSource.jy -username uid=wasadmin,ou=caseinc,o=sample


export DB2HOST=dashdb-txn-flex-yp-dal09-61.services.dal.bluemix.net
export DB2DBNAME=BLUDB
export DB2PORT=50000
export DSNAME=INDS
export DSJNDI=jdbc/inds
export AUTHALIAS=DB2User-INVENTORYDB
$WAS_PROFILE/DefaultAppSrv01/bin/wsadmin.sh -lang jython -conntype SOAP -username uid=wasadmin,ou=caseinc,o=sample -password websphereUser! -f $curdir/DataSource.jy -username uid=wasadmin,ou=caseinc,o=sample

### JPA and JAX-RS Specifications

$WAS_PROFILE/DefaultAppSrv01/bin/wsadmin.sh -lang jython -conntype SOAP -username uid=wasadmin,ou=caseinc,o=sample -password websphereUser! -f $curdir/specs.jy -username uid=wasadmin,ou=caseinc,o=sample

### Server restart

$WAS_PROFILE/DefaultAppSrv01/bin/stopServer.sh server1 -username uid=wasadmin,ou=caseinc,o=sample -password websphereUser!
sleep 5
$WAS_PROFILE/DefaultAppSrv01/bin//startServer.sh server1
