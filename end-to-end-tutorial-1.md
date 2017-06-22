# Customer Order Services - JavaEE Enterprise Application

## Application Overview

The application is a simple store-front shopping application, built during the early days of the Web 2.0 movement.  As such, it is in major need of upgrades from both the technology and business point of view.  Users interact directly with a browser-based interface and manage their cart to submit orders.  This application is built using the traditional [3-Tier Architecture](http://www.tonymarston.net/php-mysql/3-tier-architecture.html) model, with an HTTP server, an application server, and a supporting database.

![Phase 0 Application Architecture](https://github.com/ibm-cloud-architecture/refarch-jee/raw/master/static/imgs/apparch-pc-phase0-customerorderservices.png)

There are several components of the overall application architecture:
- Starting with the database, the application leverages two SQL-based databases running on [IBM DB2](https://www.ibm.com/analytics/us/en/technology/db2/).
- The application exposes its data model through an [Enterprise JavaBean](https://en.wikipedia.org/wiki/Enterprise_JavaBeans) layer, named **CustomerOrderServices**.  This components leverages the [Java Persistence API](https://en.wikibooks.org/wiki/Java_Persistence/What_is_JPA%3F) to exposed the backend data model to calling services with minimal coding effort.
  - As of the [WebSphere Application Server](http://www-03.ibm.com/software/products/en/appserv-was) Version 9 build, the application is using **EJB 3.0** and **JPA 2.0** versions of the respective capabilities.
- The next tier of the application, named **CustomerOrderServicesWeb**, exposes the necessary business APIs via REST-based web services.  This component leverages the [JAX-RS](https://en.wikipedia.org/wiki/Java_API_for_RESTful_Web_Services) libraries for creating Java-based REST services with minimal coding effort.
  - As of the [WebSphere Application Server](http://www-03.ibm.com/software/products/en/appserv-was) Version 9 build, the application is using **JAX-RS 1.1** version of the respective capability.
- The application's user interface is exposed through the **CustomerOrderServicesWeb** component as well, in the form of a [Dojo Toolkit](#tbd)-based JavaScript application.  Delivering the user interface and business APIs in the same component is one major inhibitor our migration strategy will help to alleviate in the long-term.
- Finally, there is an additional integration testing component, named **CustomerOrderServicesTest** that is built to quickly validate an application's build and deployment to a given application server.  This test component contains both **JPA** and **JAX-RS**-based tests.  

## Building and deploying the application on WebSphere Application Server 9

### Tutorial Overview

**TBD Team recap that syncs with deck**

### Step 0: Prerequisites

The following are prerequisites for completing this tutorial:
- Bluemix Services:
  - [WebSphere Application Server Version 9](https://console.bluemix.net/catalog/services/websphere-application-server) - Referred to as _WASaaS_ throughout the rest of the tutorial
  - [DB2 on Cloud SQL DB](https://console.bluemix.net/catalog/services/db2-on-cloud-sql-db-formerly-dashdb-tx) 
- Command line tools:
  - [git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)
  - [Maven](https://maven.apache.org/install.html)
  - VPN Client for connectivity to WASaaS private network
    - [Windows 64-Bit (OpenVPN)](https://swupdate.openvpn.org/community/releases/openvpn-install-2.3.11-I001-x86_64.exe)
    - [Windows 32-Bit (OpenVPN)](https://swupdate.openvpn.org/community/releases/openvpn-install-2.3.11-I001-i686.exe)
    - [Linux (OpenVPN)](https://openvpn.net/index.php/access-server/download-openvpn-as-sw.html)
    - [Mac (Tunnelblick)](https://tunnelblick.net/)
  - SSH capability
    - Windows users will need [Putty](https://www.chiark.greenend.org.uk/~sgtatham/putty/latest.html) or [OpenSSH](https://www.openssh.com/)
  - [WebSphere Application Server Migration Toolkit for Application Binaries](https://developer.ibm.com/wasdev/downloads/#asset/tools-Migration_Toolkit_for_Application_Binaries)
 
### Step 1: Getting the project repository
  		  
You can clone the repository from its main GitHub repository page and checkout the appropriate branch for this version of the application.
  		  
1. `git clone https://github.com/ibm-cloud-architecture/refarch-jee-customerorder.git`  		   
2. `cd refarch-jee-customerorder`
3. `git checkout was90-prod`
 
### Step 2: Perform assessment walkthrough

#### Step 2.1: Use the Migration Toolkit for Application Binaries to evaluate the applications

TODO Insert & format Don's document from https://ibm.box.com/s/icn00hjcv2hejpnmvpl90oxkvacwgjmp

#### Step 2.2: TBD

TODO Details to be added:  Merge from Don's work

### Step 3: Create DB2 service instance for ORDERDB

TODO Details to be added - Db2 on Cloud SQL DB (formerly dashDB TX)

1. Create an instance of `Db2 on Cloud SQL DB (formerly dashDB TX)`
2. Name it `DB2 on Cloud - ORDERDB`
3. Click on Open
4. Click on `Run SQL`
5. Click on `Open Script` and browse to `createOrderDB.sql` inside the 'Common' sub-directory of the project directory.
6. Click `Run All`
7. You should see some successes and some failures.  This is due to the scripts cleaning up previous data, but none exists yet.  You should see 28 successful SQL statements and 30 failures.
8. Go to the dropdown in the upper right and click on `Connection Info`
9. **TODO DB SERVICE INSTANCE DETERMINE PASSWORD**
10. Select `Without SSL` and copy the following information for later:
- Host name
- Port number _(most likely 50000)_
- Database name _(most likely BLUDB)_
- User ID _(most likely bluadmin)_
- Password

### Step 4: Create DB2 service instance for INVENTORYDB

**TODO Replicate Step 3 but with DDLs below**

1. `db2 -tf Common/InventoryDdl.sql`
2. `db2 -tf Common/InventoryData.sql`

### Step 6: Create WebSphere Application Server service instance

1.Go to your [Bluemix console](https://console.bluemix.net/) and create a [**WebSphere Application Server** instance](https://console.bluemix.net/catalog/services/websphere-application-server)

2. Name your service, choose the **WAS Base Plan**, and create the instance.

3. Provision your server based on your requirements.

4. Once done, you can access the Admin console using the **Open the Admin Console** option. In order to access the Admin console, install the VPN as instructed. **Needs URL**

5. Get a public IP address. This can be done using the **Manage Public IP Access** option. **Needs doc & link**

6. You can **ssh** into the WebSphere Application Server instance using the Admin Username and Password provided in your instance.

### Step 7: Run WebSphere configuration scripts

1.  Connect to the WebSphere Server via **ssh**.

2. Download the WAS configuration scripts on the remote WAS instance via `curl` or `wget`.  There are three scripts that are used here, which automate the migration of the server and application configuration.  
    1. [ldap.properties](https://github.com/ibm-cloud-architecture/refarch-jee/blob/master/static/artifacts/end-to-end-tutorial1/LDAP/ldap.properties)
    2. [create_ldap_jython.sh](https://github.com/ibm-cloud-architecture/refarch-jee/blob/master/static/artifacts/end-to-end-tutorial1/LDAP/create_ldap_jython.sh)
 
 **TODO Provide curl/wget commands to public configuration scripts**
 
3. Run `sh was_config_jython.sh -f was.properties`

4. This script walks you through some installation steps. Please provide the information required.

5. Start the WebSphere Application Server. **TODO**

6. Go to the **<WAS_PROFILE_DIR>/bin**, and run the following command:

`<Profile Home>/bin/wsadmin.sh –lang jython –f ~/WAS_config.py`

7. Once the script gets executed successfully, the configuration setup is completed. You can verify the configuration by opening your admin console and then check if all the resources are correct.

8.  You may now disconnect from the remote WASaaS instance.

### Step 7: Install Customer Order Services application

1.  We have provided a built EAR that has had the previously discussed changes for installation on WAS V9.0.  It is available at [https://github.com/ibm-cloud-architecture/refarch-jee/blob/master/static/artifacts/CustomerOrderServicesApp-0.1.0-SNAPSHOT.ear](https://github.com/ibm-cloud-architecture/refarch-jee/blob/master/static/artifacts/CustomerOrderServicesApp-0.1.0-SNAPSHOT.ear) for download.

2.  Install the EAR to the Admin console.
   -  Login to the Administrative Console.
   -  Select **Applications > Application Types > WebSphere enterprise applications**
   -  Choose **Install > Browse the EAR > Next > Choose Detailed**
   -  Click on **Step 12**.  Customize the environment variables for your system. This is most likely just going to be the **DBUNIT_SCHEMA**, **DBUNIT_USERNAME**, and **DBUNIT_PASSWORD** fields. Those values need to be specific to your local DB2 installation.
   -  Click on **Step 13**.  Verify the **SecureShopper** role is mapped to the **SecureShopper** group (or a corresponding group in your application server's user registry).
   -  Click on **Summary** (Step 18) and click **Finish**.
   -  Once you see Application **CustomerOrderServicesApp** installed successfully, click **Save** and now your application is ready.

3.  Go back to the Enterprise Applications list, select the application, and click **Start**.

4.  Initial users can be created by running the **JPA** tests in the https://your-host/CustomerOrderServicesTest web application.

5.  Prime the database with the JPA tests avaiable at https://your-host/CustomerOrderServicesTest. 

6.  Login as the user `rbarcia` with the password of `bl0wfish`.  

7.  Select the first two tests and click `Run`

8.  Access the application at https://your-host/CustomerOrderServicesWeb/#shopPage

9.  Login as the user `rbarcia` with the password of `bl0wfish`.  

10.  Add an item to the cart by clicking on an available item.  Drag and drop the item to the cart. 

11.  Take a screencap and submit the image to the available proctors as proof of completion.



## BACKUP

### Step 5. Configure users in ORDERDB

**TODO  Is this necessary?**

As you will see in the following section, the Customer Order Services application implements application security. Hence, you need to have your application users defined in both your LDAP/Security registry and the application database. The _ORDERDB_ application database contains a table called _CUSTOMER_ which will store the application users. As a result, you need to add your application users to this table.

In order to add your application users to you application database:
1. Edit the [addBusinessCustomer.sql](https://github.com/ibm-cloud-architecture/refarch-jee-customerorder/blob/was90-prod/Common/addBusinessCustomer.sql) and/or [addResidentialCustomer.sql](https://github.com/ibm-cloud-architecture/refarch-jee-customerorder/blob/was90-prod/Common/addResidentialCustomer.sql) sql files you can find in the Common folder to define your users in there.
2. Execute the sql files: `db2 -tf Common/addBusinessCustomer.sql` and/or `db2 -tf Common/addResidentialCustomer.sql`
