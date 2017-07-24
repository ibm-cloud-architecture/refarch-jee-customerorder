#!/bin/bash
curdir=`pwd`
export iphost=`nslookup $HOSTNAME | grep Address | tail -1 | awk '{ print $2 }'`

export WAS_HOME=/opt/IBM/WebSphere/AppServer
export WAS_PROFILE=/opt/IBM/WebSphere/Profiles

export APPLICATION=$curdir/CustomerOrderServicesApp-0.2.0-WAS9.ear
export DEPLOYER_EMAIL=Hemankita.Perabathini@ibm.com
export DBUNIT_CONNECTION_URL=jdbc:db2://dashdb-txn-flex-yp-dal09-56.services.dal.bluemix.net:50000/BLUDB
export DBUNIT_SCHEMA=BLUADMIN
export DBUNIT_USERNAME=bluadmin
export DBUNIT_PASSWORD=ZTA2YzVmYjA2MjU3

export APPNAME=CustomerOrderServicesApp
export GROUP_NAME=SecureShopper
export WEB_ENDPOINT_NAME=CUSTOMER_ORDER_SERVICES_WEB_ENDPOINT
export TEST_ENDPOINT_NAME=CUSTOMER_ORDER_SERVICES_TEST_ENDPOINT
export CUSTOMER_ORDER_SERVICES_WEB_ENDPOINT=https://$iphost:9443/CustomerOrderServicesWeb
export CUSTOMER_ORDER_SERVICES_TEST_ENDPOINT=http://$iphost:9080/CustomerOrderServicesTest


$WAS_PROFILE/DefaultAppSrv01/bin/wsadmin.sh -lang jython -conntype SOAP -username uid=wasadmin,ou=caseinc,o=sample -password websphereUser! -f $curdir/app.jy -username uid=wasadmin,ou=caseinc,o=sample
$WAS_PROFILE/DefaultAppSrv01/bin/stopServer.sh server1 -username uid=wasadmin,ou=caseinc,o=sample -password websphereUser!
sleep 5
$WAS_PROFILE/DefaultAppSrv01/bin//startServer.sh server1
