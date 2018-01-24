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


## Build, configure and deploy

This branch contains a Liberty based version of the Customer Order Services application. This application integrates with DB2 for data storage and LDAP for security.

DB2 and LDAP installation, configuration and exposure are out of scope for the instructions on how to build and deploy this JEE application. As a result, we will consider a DB2 instance and an LDAP server are available to the system where this JEE application will run on.

### 1. Prerequisites

#### Tools

In order to build, deploy and run the Customer Order Services application we will need the following tools installed on our machine:

1. [Git CLI](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)
2. [Maven](https://maven.apache.org/install.html)
3. [WebSphere Application Server Liberty Server](https://www.ibm.com/support/knowledgecenter/en/SSD28V_9.0.0/com.ibm.websphere.wlp.core.doc/ae/twlp_inst.html) *(The installation consist of only unzipping a zip file. Also, follow README.TXT inside this unzipped directory)*

#### Getting the project repository

You can clone the repository from its main GitHub repository page and checkout the appropriate branch for this version of the application.

1. `git clone https://github.com/ibm-cloud-architecture/refarch-jee-customerorder.git`  
2. `cd refarch-jee-customerorder`  
3. `git checkout liberty`  

### 2. Create application database infrastructure

As said in the prerequisites section above, the Customer Order Services application uses uses DB2 as its database. Follow these steps to create the appropriate database, tables and data the application needs to:

1. Ssh into the db2 host
2. Execute `su - ${DB2INSTANCE} -c "bash <(curl -s https://raw.githubusercontent.com/ibm-cloud-architecture/refarch-jee-customerorder/liberty/Common/bootstrapCurlDb2.sh)"` where `${DB2INSTANCE}` is the db2 instance user you set up (it usually is _db2inst1_)

If you want to re-run the scripts, please make sure you drop the databases and create them again.

### 3. Build the application

In order to build the application using Maven follow these steps:

1. `cd CustomerOrderServicesProject`
2. `mvn clean package`

### 4. Configure the WebSphere Application Server Liberty Server

The IBM WebSphere Application Server Liberty Profile is a composable, dynamic application server environment that supports development and testing of Java EE Full Platform web applications.

The Liberty profile is a simplified, lightweight development and application runtime environment that has the following characteristics:

* Simple to configure. Configuration is read from an XML file with text-editor-friendly syntax.
* Dynamic and flexible. The run time loads only what your application needs and recomposes the run time in response to configuration changes.
* Fast. The server starts in under 5 seconds with a basic web application.
* Extensible. The Liberty profile provides support for user and product extensions, which can use System Programming Interfaces (SPIs) to extend the run time.

[Here](https://www.ibm.com/support/knowledgecenter/SSEQTP_liberty/com.ibm.websphere.wlp.doc/ae/rwlp_feat.html) you can see the technologies that the WebSphere Application Server Liberty support on its different flavors.

The application server configuration is described in a series of elements in the server.xml configuration file. This file can be found in **<wlp_installation_directory>/wlp/usr/servers/<server_name>/server.xml**, where
- *<wlp_installation_directory>* is the directory where the WebSphere Application Server Liberty Server has been installed and
- *<server_name>* the name of the Liberty Server you created in the [tools](#tools) section above by following the README.TXT file that comes within the *<wlp_installation_directory>*.

In order to get our Liberty server prepared to successfully run our Customer Order Services application, we need to replace the default server.xml and server.env files with the ones provided in the **Common** folder of this repo:

- **server_ldap.xml and server_ldap.env** if you want to integrate the application with an existing LDAP server

```
cp Common/server_ldap.xml <wlp_installation_directory>/wlp/usr/servers/<server_name>/server.xml
cp Common/server_ldap.env <wlp_installation_directory>/wlp/usr/servers/<server_name>/server.env
```

or

- **server_no_ldap.xml and server_no_ldap.env** if you do not have an LDAP server to integrate the application with

```
cp Common/server_no_ldap.xml <wlp_installation_directory>/wlp/usr/servers/<server_name>/server.xml
cp Common/server_no_ldap.env <wlp_installation_directory>/wlp/usr/servers/<server_name>/server.env
```

**IMPORTANT:** the .env file declares the values for the variables the server.xml file depends on. That is, you need to define the appropriate values in there for your DB2 (and LDAP) configuration.

Finally, you **must** provide the Customer Order Services application with the appropriate DB2 jar files for a JEE application to interact with a DB2 database. These jar files are the **db2jcc4.jar** and the **db2jcc_license_cu.jar** files. You should be able to find them by issuing the command `find / -name "<jar_file_name>"` on the host where your DB2 instance is installed on.
You **must** copy these DB2 jar files onto the machine you will run the Customer Order Services application on and specify the location of them in the **server.env** file mentioned above as the value of the variable **DB2_JARS**.

### 5. Users

Application's users **must be present both in the security side and data side of the application**. That is, users need to be both in the security side in the WebSphere Liberty Server configuration file (server.xml) as a *basicRegistry entry* (if you don't have an LDAP server to integrate with) or in that LDAP server and the application's customer database tables the application will use to retrieve user's session, data, etc.

<sup>\*</sup>*How you create new users in an LDAP server is out of scope for these instructions.*

The default user defined in the WebSphere Liberty Server configuration file (server.xml) configured in step 4 and the application's data loaded into your DB2 instance in step 2 is `rbarcia` and its password is `b0wfish`.

In order to create new users in the application's database, the _ORDERDB_ application's database contains a table called _CUSTOMER_, which will store the application users.

1. Depending on what type of customer you want your new user to be, edit the [addBusinessCustomer.sql](https://github.com/ibm-cloud-architecture/refarch-jee-customerorder/blob/liberty/Common/addBusinessCustomer.sql) and/or [addResidentialCustomer.sql](https://github.com/ibm-cloud-architecture/refarch-jee-customerorder/blob/liberty/Common/addResidentialCustomer.sql) sql files you can find in the **Common** folder for this repo to define your users in there.
2. Copy the files above over to your DB2 host machine (or git clone the repository).
3. Ssh into your DB2 host machine.
4. Connect to the **ORDERDB** database: `db2 connect to ORDERDB`
5. Execute the sql files: `db2 -tf addBusinessCustomer.sql` and/or `db2 -tf addResidentialCustomer.sql`

You should now be able to log into the Customer Order Services application with your newly created user.

### 6. Run the application

We are now ready to run the application. We just need to copy the output of building our application with Maven in step 3 to the appropriate location in our WebSphere Liberty Server installation directory and start the server:

1. `cp CustomerOrderServicesApp/target/CustomerOrderServicesApp-0.1.0-SNAPSHOT.ear <wlp_installation_directory>/wlp/usr/shared/apps`
2. `cd <wlp_installation_directory>/wlp/bin`
3. `./server start`
