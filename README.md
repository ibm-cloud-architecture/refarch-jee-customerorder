# Customer Order Services - JavaEE Enterprise Application

## Application Overview

The application is a simple store-front shopping application, built during the early days of the Web 2.0 movement.  As such, it is in major need of upgrades from both the technology and business point of view.  Users interact directly with a browser-based interface and manage their cart to submit orders.  This application is built using the traditional [3-Tier Architecture](http://www.tonymarston.net/php-mysql/3-tier-architecture.html) model, with an HTTP server, an application server, and a supporting database.

![Phase 0 Application Architecture](https://github.com/ibm-cloud-architecture/refarch-jee/raw/master/static/imgs/apparch-pc-phase0-customerorderservices.png)

There are several components of the overall application architecture:
- Starting with the database, the application leverages two SQL-based databases running on [IBM DB2](https://www.ibm.com/analytics/us/en/technology/db2/).
- The application exposes its data model through an [Enterprise JavaBean](https://en.wikipedia.org/wiki/Enterprise_JavaBeans) layer, named **CustomerOrderServices**.  This components leverages the [Java Persistence API](https://en.wikibooks.org/wiki/Java_Persistence/What_is_JPA%3F) to exposed the backend data model to calling services with minimal coding effort.
  - As of the [WebSphere Application Server](http://www-03.ibm.com/software/products/en/appserv-was) Version 7 build, the application is using **EJB 3.0** and **JPA 2.0** versions of the respective capabilities.
- The next tier of the application, named **CustomerOrderServicesWeb**, exposes the necessary business APIs via REST-based web services.  This component leverages the [JAX-RS](https://en.wikipedia.org/wiki/Java_API_for_RESTful_Web_Services) libraries for creating Java-based REST services with minimal coding effort.
  - As of the [WebSphere Application Server](http://www-03.ibm.com/software/products/en/appserv-was) Version 7 build, the application is using **JAX-RS 1.1** version of the respective capability.
- The application's user interface is exposed through the **CustomerOrderServicesWeb** component as well, in the form of a [Dojo Toolkit](#tbd)-based JavaScript application.  Delivering the user interface and business APIs in the same component is one major inhibitor our migration strategy will help to alleviate in the long-term.
- Finally, there is an additional integration testing component, named **CustomerOrderServicesTest** that is built to quickly validate an application's build and deployment to a given application server.  This test component contains both **JPA** and **JAX-RS**-based tests.  


## Building and deploying the application on WebSphere Application Server 7

### 1. Prerequisites

The following are prerequisites for deploying the original ASIS version of this application:
- [WebSphere Application Server Version 7](http://www-03.ibm.com/software/products/en/appserv-was)
- [IBM WebSphere Applicaton Server Feature Pack for Web 2.0 and Mobile, Version 1.1.0](http://www-01.ibm.com/support/docview.wss?uid=swg24033752)
- [WebSphere Application Server V7 Feature Pack for OSGi and JPA](http://www-01.ibm.com/support/docview.wss?uid=swg24033884)

### 2. Getting the project repository

You can clone the repository from its main GitHub repository page and checkout the appropriate branch for this version of the application.

1. `git clone https://github.com/ibm-cloud-architecture/refarch-jee-customerorder.git`  
2. `cd refarch-jee-customerorder`  
3. `git checkout was70-dev`  


### 3. Running the Database and Creating the tables

This project uses DB2 as its database. Before creating the databases and getting connected to them, verify if your database is running. You can verify it using

1. `su {database_instance_name}`
2. `db2start`

Create two databases - ORDERDB and INDB

1. `db2 create database ORDERDB`
2. `db2 create database INDB`

After this, run the database scripts for the ORDERDB.  This also cleans the database tables, just in case.  

Run the createOrderDB.sql script present inside the 'Common' sub-directory of the project directory.

1. `db2 connect to ORDERDB`
2. `db2 -tf Common/createOrderDB.sql`

Next connect to the inventory database INDB and run the required scripts from the 'Common' sub-directory.

1. `db2 connect to INDB`
2. `db2 -tf Common/InventoryDdl.sql`
3. `db2 -tf Common/InventoryData.sql`

If you want to re-run the scripts, please make sure you drop the databases and create them again.

As you will see in the following section, the Customer Order Services application implements application security. Hence, you need to have your application users defined in both your LDAP/Security registry and the application database. The _ORDERDB_ application database contains a table called _CUSTOMER_ which will store the application users. As a result, you need to add your application users to this table. 

In order to add your application users to you application database:
1. Edit the [addBusinessCustomer.sql](https://github.com/ibm-cloud-architecture/refarch-jee-customerorder/blob/was70-dev/Common/addBusinessCustomer.sql) and/or [addResidentialCustomer.sql](https://github.com/ibm-cloud-architecture/refarch-jee-customerorder/blob/was70-dev/Common/addResidentialCustomer.sql) sql files you can find in the Common folder to define your users in there.
2. Execute the sql files: `db2 -tf Common/addBusinessCustomer.sql` and/or `db2 -tf Common/addResidentialCustomer.sql`

### 4. Configuring the WebSphere v7 Environment with Security and Resources

Websphere environment configuration can be setup using the automation script or it can be done manually. You can choose from either ways based upon your convenience.

#### Using the Configuration Script

1. The configuration file (Jython script) can be accessed here [migConfig.py](https://github.com/ibm-cloud-architecture/refarch-jee-customerorder/blob/was70-dev/Common/migConfig.py). It resides in the 'Common' sub-directory.

2. Start the WebSphere Application Server.

3. Go to the **<WAS_PROFILE_DIR>/bin**, and use the following command.

  `<Profile Home>/bin/wsadmin.(bat/sh) –lang jython –f <Location of Jython script>`

4. This script prompts the user for input. Please provide the necessary information.

5. Once the script gets executed successfully, the configuration setup is completed. You can verify the configuration by opening your admin console and then check if all the resources are correct.

#### Manual Setup

##### Setting Up Security

1. Log into the Admin Console via http://localhost:9043/admin.

3. In the Global security section, check **Enable application security** and click **Save**.

4. In the **Users and Groups** section, select **Manage Users** to create the users and **Manage Groups** to create groups. During deployment, you will need to map your desired users or groups to the **SecureShopper** role.
    - Alternatively, you can leverage an external user registry such as LDAP for your users.  This is path the encompassing reference architecture has taken for this application.

5. Under **Global Security**, select **J2C authentication data**. Create a new user named **DBUser** using your db2 instance and password.

##### Configuring JDBC Resources

1. Go to the **Resources > JDBC > JDBC Providers** section and ensure that you are at the **Cell** scope.  Click the New Button to create a new JDBC provider.
    -  Database type : **DB2**
    -  Provider type : **DB2 Using IBM JCC Driver**
    -  Implementation type : **XA data source**
2. You need to enter the database class path information. Enter the directory where the DB2 Java is set.
3. Press **Next** and then **Finish**. Save the Configuration.
4. Go to the **Resources > JDBC > Data sources** section to create a new data source.
  1. Make sure that the scope is at **Cell** level and click **New**
  2.  OrderDB Step 1
      -  Data source name: **OrderDS**
      -  JNDI name: **jdbc/orderds**
  3.  OrderDB Step 2
      - Select an existing JDBC provider --> **DB2 Using IBM JCC Driver (XA)**
  4.  ORDERDB Step 3
      - Driver Type: **4**
      - Database name: **ORDERDB**
      - Server name: **Your default DB2 host**
      - Port number: **Your default DB2 port**
  5.  OrderDB Step 4
      - Authentication alias for XA recovery: **DB2User**
      - Component-managed authentication alias: **DB2User**
      - Mapping-configuration alias: **DefaultPrincipalMapping**
      - Container-managed authentication alias: **DB2User**
  6.  Once this is done, under Preferences, there will be a new resource called **OrderDS**. Make sure that the resources got connected using **Test Connection** option.  You will see a success message if the connection is established successfully.
  7. Check the Data source and select Test Connection to ensure you created the database correctly.  If the connection fails, a few things to check are
      - Your database is started as we did in the beginning.  
      - Your host and port number are correct.
      - The classpath for the Driver is set properly.  
      - Check the WebSphere Variables.  You may want to change them to point to your local DB2 install.
  8.  Create the INVENTORYDB data source using the same process as before.  Click **New**.
  9.  InventoryDB Step 1
      -  Data source name: **INDS**
      -  JNDI name: **jdbc/inds**
  10.  InventoryDB Step 2
      - Select an existing JDBC provider --> **DB2 Using IBM JCC Driver (XA)**
  11.  InventoryDB Step 3
      - Driver Type: **4**
      - Database name: **INDB**
      - Server name: **Your default DB2 host**
      - Port number: **Your default DB2 port**
  12.  InventoryDB Step 4
      - Authentication alias for XA recovery: **DB2User**
      - Component-managed authentication alias: **DB2User**
      - Mapping-configuration alias: **DefaultPrincipalMapping**
      - Container-managed authentication alias: **DB2User**
  13. Remember to save and test the connection again.

### 5. Running the Application in WAS7

1.  Build the EAR using Maven in CustomerOrderServicesProject.

    -  Install Maven and run `mvn -v` to test your version
    -  `cd CustomerOrderServicesProject`
    -  `mvn clean package`
    -  You will have an EAR built in the `CustomerOrderServicesApp/target` subdirectory, named `CustomerOrderServicesApp-0.1.0-SNAPSHOT.ear`.

2. Install the EAR to http://localhost:9060/ibm/console

    -  Login to the Administrative Console.
    -  Select **Applications > Application Types > WebSphere enterprise applications**
    -  Choose **Install > Browse the EAR > Next > Choose Detailed**
    -  Click on **Step 4**.  Verify the **CustomerOrderServicesApp** line has a reference to the **IBM WebSphere Application Server traditional V7.0 JAX-RS Library**.
    -  Click on **Step 12**.  Customize the environment variables for your system. This is most likely just going to be the **DBUNIT_SCHEMA**, **DBUNIT_USERNAME**, and **DBUNIT_PASSWORD** fields. Those values need to be specific to your local DB2 installation.
    -  Click on **Step 13**.  Verify the **SecureShopper** role is mapped to the **SecureShopper** group (or a corresponding group in your application server's user registry).
    -  Click on **Summary** (Step 16) and click **Finish**.
    -  Once you see `Application CustomerOrderServicesApp installed successfully`, click **Save** and now your application is ready.

3.  Go back to the Enterprise Applications list, select the application, and click **Start**.
4.  Initial users can be created by running the **JPA** tests in the http://localhost:9080/CustomerOrderServicesTest web application.
5.  Access the application at http://localhost:9080/CustomerOrderServicesWeb
