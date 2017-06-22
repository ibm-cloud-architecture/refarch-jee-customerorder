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

Use the Migration Toolkit for Application Binaries to evaluate the applications
In this section you will use the Migration Toolkit for Application Binaries to generate evaluation reports for the EAR file CustomerOrderServicesApp-0.1.0
SNAPSHOT.ear. It the original app that runs on WAS V7.

In this section you will generate and review the Application Evaluation Report for CustomerOrderServicesApp-0.1.0-SNAPSHOT.ear
To generate the Application Evaluation Report for CustomerOrderServicesApp

    1. 	Navigate to {binaryAppScanner.jar_LOCATION} by issuing the command:

        'cd {binaryAppScanner.jar_LOCATION}'

    2. 	Run the Migration Toolkit for Application Binaries passing the binaryInputPath to CustomerOrderServicesApp and the –evaluate action as shown below:
        'java –jar binaryAppScanner.jar {CustomerOrderServicesApp-0.1.0-SNAPSHOT.ear_LOCATION}/CustomerOrderServicesApp-0.1.0-SNAPSHOT.ear --evaluate'

#### Step 2.2: TBD

TODO Details to be added:  Merge from Don's work

### Step 3: Create DB2 service instance for ORDERDB

1. Create an instance of `Db2 on Cloud SQL DB (formerly dashDB TX)` and name it `DB2 on Cloud - ORDERDB`
2. When you are redirected back to your Services dashboard, click on the new database service instance.
2. Click on `Service Credentials` and then click on `New credential`.
3. Click `Add` and then click on `View credentials`.
4. Make note of the `password` field for your instance.
5. Click on `Manage` and then click on `Open`.
6. Click on `Run SQL`
7. Click on `Open Script` and browse to `createOrderDB.sql` inside the 'Common' sub-directory of the project directory.
8. Click `Run All`
9. You should see some successes and some failures.  This is due to the scripts cleaning up previous data, but none exists yet.  You should see 28 successful SQL statements and 30 failures.
10. Go to the dropdown in the upper right and click on `Connection Info`
11. Select `Without SSL` and copy the following information for later:
- Host name _(most likely in the form of dashdb-txn-flex-yp-dalXX-YY.services.dal.bluemix.net)_
- Port number _(most likely 50000)_
- Database name _(most likely BLUDB)_
- User ID _(most likely bluadmin)_
- Password _(previous password from the `View credentials` tab)_

### Step 4: Create DB2 service instance for INVENTORYDB

1. Create an instance of `Db2 on Cloud SQL DB (formerly dashDB TX)` and name it `DB2 on Cloud - INVENTORYDB`
2. When you are redirected back to your Services dashboard, click on the new database service instance.
3. Click on `Service Credentials` and then click on `New credential`.
4. Click `Add` and then click on `View credentials`.
5. Make note of the `password` field for your instance.
6. Click on `Manage` and then click on `Open`.
7. Click on `Run SQL`
8. Click on `Open Script` and browse to `InventoryDdl.sql` inside the 'Common' sub-directory of the project directory.
9. Click `Run All`
10. You should see some successes and some failures.  This is due to the scripts cleaning up previous data, but none exists yet.  You should see 5 successful SQL statements and 4 failures.
11. Click on `Open Script` and browse to `InventoryData.sql` inside the 'Common' sub-directory of the project directory.  Confirm the prompt that you would like to open this new file and replace the previous content of the SQL Editor.
12. Click `Run All`
13.  You should now see 12 successes.
14. Go to the dropdown in the upper right and click on `Connection Info`
15. Select `Without SSL` and copy the following information for later:
- Host name _(most likely in the form of dashdb-txn-flex-yp-dalXX-YY.services.dal.bluemix.net)_
- Port number _(most likely 50000)_
- Database name _(most likely BLUDB)_
- User ID _(most likely bluadmin)_
- Password _(previous password from the `View credentials` tab)_

### Step 5: Create WebSphere Application Server service instance

1. Go to your [Bluemix console](https://new-console.ng.bluemix.net/) and create a [**WebSphere Application Server** instance](https://console-regional.ng.bluemix.net/catalog/services/websphere-application-server)

2. Name your service, choose the **WAS Base Plan**, and create the instance.

3. Once the service instance is created, provision a **WebSphere Version 9.0.0.0** server of size **Medium**.  This should be a server deployment taking up 2 of your 2 trial credits.  This step can take up to 30 minutes to complete.

4. Once done, you can access the Admin console using the **Open the Admin Console** option. In order to access the Admin console, install the [VPN](https://console.bluemix.net/docs/services/ApplicationServeronCloud/systemAccess.html#setup_openvpn) as instructed. 

   - [Windows 64-Bit (OpenVPN)](https://swupdate.openvpn.org/community/releases/openvpn-install-2.3.11-I001-x86_64.exe)
   - [Windows 32-Bit (OpenVPN)](https://swupdate.openvpn.org/community/releases/openvpn-install-2.3.11-I001-i686.exe)
   - [Linux (OpenVPN)](https://openvpn.net/index.php/access-server/download-openvpn-as-sw.html)
   - [Mac (Tunnelblick)](https://tunnelblick.net/)  
   
   Download, extract, and install the VPN configuration files by clicking the **Download** button.
   
   **VPN - Windows Configuration**
   
   1. From the [openVPN Windows download](http://swupdate.openvpn.org/community/releases/) link, download
      [openvpn-install-2.3.4-I001-x86_64.exe](https://swupdate.openvpn.org/community/releases/openvpn-install-2.3.4-I001-x86_64.exe) for 64-bit, or
      [openvpn-install-2.3.4-I001-i686.exe](https://swupdate.openvpn.org/community/releases/openvpn-install-2.3.4-I001-i686.exe) for 32-bit.
      
   2. Ensure you [Run as a Windows Administrator](https://technet.microsoft.com/en-us/magazine/ff431742.aspx) and openVPN is installed.
   
   3. Download the VPN configuration files from the OpenVPN download link of the WebSphere Application Server in Bluemix instance in the service dashboard. Extract all four files in the compressed file to the {OpenVPN home}\config directory. 
   
   `C:\Program Files\OpenVPN\Config`
   
   4. Start the openVPN client program "OpenVPN GUI". Ensure that you select [Run as a Windows Administrator](https://technet.microsoft.com/en-us/magazine/ff431742.aspx) to start the program. If you do not, you might not be able to connect.

   **VPN - Linux Configuration**
 
   1. To install openVPN, follow the [instructions](https://openvpn.net/index.php/access-server/docs/admin-guides/182-how-to-connect-to-access-server-with-linux-clients.html).
   
      If you need to manually download and install the RPM Package Manager, go to [openVPN unix/linux download](https://openvpn.net/index.php/access-server/download-openvpn-as-sw.html). You might need assistance from your Linux administrator.

   2. Download the VPN configuration files from the OpenVPN download link of the WebSphere Application Server in Bluemix instance in the service dashboard. Extract the files into the directory from which you plan to start the openVPN client. You need all four files in the same directory.
   
   3. Start the openVPN client program. Open a terminal window and go to the directory that contains the config files. Run the following command as root:
   
   `openvpn --config vt-wasaas-wasaas.ovpn`
   
   **VPN - MAC configuration**
   
   1. One method is to install [Tunnelblick](https://tunnelblick.net/), an open source software product.
   
   2. Extract the VPN configuration files from the WebSphere service. Tunnelblick prompts for your admin password for Mac and adds the config to the set of VPNs you can use to connect.
   
   3. Connect to the VPN network and then you can access your virtual machine. After your first access, Tunnelblick caches the configuration and you can connect from [Tunnelblick](https://tunnelblick.net/). You can put an icon on the top menu bar for easy access.
   
Once the VPN is configured, you can access the Admin console. Please add the exception for insecure connection when it prompts to access the admin console.
   
5. Get a public IP address. This can be done using the [**Manage Public IP Access**](https://console.bluemix.net/docs/services/ApplicationServeronCloud/networkEnvironment.html#networkEnvironment) option. 

6. You can **ssh** into the WebSphere Application Server instance using the Admin Username **root** and Password provided in your bluemix instance.

   In **Application Hosts/Nodes**, by expanding the Traditional **WebSphere Base option**, you can find the details of your OS distribution, Admin username, Admin password and Key Store password.

### Step 6: Perform WebSphere configuration

1. Log into the Admin Console via the adddress accessible from your service instance page.

**TODO will need to be updated to be external LDAP**

3. In the Global security section, check **Enable application security** and click **Save**.

![Readme 1](https://github.com/ibm-cloud-architecture/refarch-jee/raw/master/static/imgs/Customer_README/Readme1.png)

4. In the **Users and Groups** section, select **Manage Users** and create the following users:

- username: **rbarcia**  password: **bl0wfish**
- username: **kbrown**   password: **bl0wfish**

![Readme 2](https://github.com/ibm-cloud-architecture/refarch-jee/raw/master/static/imgs/Customer_README/Readme2.png)

5. In the **Users and Groups** section, select **Manage Groups** and create the following group:

- group name: **SecureShopper**

This JEE application implements role-based security whereby only those users and groups with appropriate roles can execute certain actions. As a result, all users must belong to the SecureShopper group if they want to be able to access to the protected customer resources:

![Readme 3](https://github.com/ibm-cloud-architecture/refarch-jee/raw/master/static/imgs/Customer_README/Readme3.png)

During deployment, you will need to map your desired users or groups to the **SecureShopper** role. By default, SecureShopper group gets mapped to the SecureShopper role.

<sup>\*</sup>_Alternatively, you can leverage an external security registry such as an LDAP server for your users and groups.  This is the path that the reference architecture has taken for this application which gets described in the different phases in [here](https://github.com/ibm-cloud-architecture/refarch-jee)._

**TODO END LDAP**

##### Configuring JDBC Resources

6. Under **Global Security**, select **J2C authentication data**. Create a new user named **DBUser-ORDERDB** using your DB2 on Cloud instance and password.  The user will be `bluadmin` and the password will be specific to the instance you named **DB2 on Cloud - ORDERDB**.

![Readme 4](https://github.com/ibm-cloud-architecture/refarch-jee/raw/master/static/imgs/Customer_README/Readme4.png)

7. On the same page, create another new user named **DBUsuer-INVENTORYDB** using your DB2 on Cloud instance and password.  The user will again be `bluadmin`, but the password will be different as you are connecting to a different DB2 database on a different Bluemix service instance.

![Readme 4](https://github.com/ibm-cloud-architecture/refarch-jee/raw/master/static/imgs/Customer_README/Readme4.png)

1. Go to the **Resources > JDBC > JDBC Providers** section and ensure that you are at the **Cell** scope.

![Readme 5](https://github.com/ibm-cloud-architecture/refarch-jee/raw/master/static/imgs/Customer_README/Readme5.png)

2. Click the New Button to create a new JDBC provider.
    -  Database type : **DB2**
    -  Provider type : **DB2 Using IBM JCC Driver**
    -  Implementation type : **XA data source**

![Readme 6](https://github.com/ibm-cloud-architecture/refarch-jee/raw/master/static/imgs/Customer_README/Readme6.png)

3. You need to enter the database class path information. Enter the directory where the DB2 Java is set.

![Readme 7](https://github.com/ibm-cloud-architecture/refarch-jee/raw/master/static/imgs/Customer_README/Readme7.png)

4. Press **Next** and then **Finish**. Save the Configuration.

![Readme 8](https://github.com/ibm-cloud-architecture/refarch-jee/raw/master/static/imgs/Customer_README/Readme8.png)

5. Go to the **Resources > JDBC > Data sources** section to create a new data source.
   1. Make sure that the scope is at **Cell** level and click **New**
   2. OrderDB - Step 1
      -  Data source name: **OrderDS**
      -  JNDI name: **jdbc/orderds**      
         ![Readme 9](https://github.com/ibm-cloud-architecture/refarch-jee/raw/master/static/imgs/Customer_README/Readme9.png)
   3. OrderDB - Step 2
      - Select an existing JDBC provider --> **DB2 Using IBM JCC Driver (XA)**
        ![Readme 10](https://github.com/ibm-cloud-architecture/refarch-jee/raw/master/static/imgs/Customer_README/Readme10.png)
   4. ORDERDB - Step 3
      - Driver Type: **4**
      - Database name: **ORDERDB**
      - Server name: **Your default DB2 host**
      - Port number: **Your default DB2 port**
        ![Readme 11](https://github.com/ibm-cloud-architecture/refarch-jee/raw/master/static/imgs/Customer_README/Readme11.png)
   5. OrderDB - Step 4
      - Authentication alias for XA recovery: **DB2User-ORDERDB**
      - Component-managed authentication alias: **DB2User-ORDERDB**
      - Mapping-configuration alias: **DefaultPrincipalMapping**
      - Container-managed authentication alias: **DB2User-ORDERDB**
        ![Readme 12](https://github.com/ibm-cloud-architecture/refarch-jee/raw/master/static/imgs/Customer_README/Readme12.png)
      
6. Once this is done, under Preferences, there will be a new resource called **OrderDS**. Make sure that the resources got connected using **Test Connection** option. You will see a success message if the connection is established successfully.

![Readme 13](https://github.com/ibm-cloud-architecture/refarch-jee/raw/master/static/imgs/Customer_README/Readme13.png)

7. Check the Data source and select Test Connection to ensure you created the database correctly.  If the connection fails, a few things to check are
      - Your database is started as we did in the beginning.  
      - Your host and port number are correct.
      - The classpath for the Driver is set properly.  
      - Check the WebSphere Variables.  You may want to change them to point to your local DB2 install.
8. Create the INVENTORYDB data source using the same process as before.  Click **New**.
   1. InventoryDB - Step 1
      -  Data source name: **INDS**
      -  JNDI name: **jdbc/inds**
   2. InventoryDB - Step 2
      - Select an existing JDBC provider --> **DB2 Using IBM JCC Driver (XA)**
   3. InventoryDB - Step 3
      - Driver Type: **4**
      - Database name: **INDB**
      - Server name: **Your default DB2 host**
      - Port number: **Your default DB2 port**
   4. InventoryDB - Step 4
      - Authentication alias for XA recovery: **DB2User-INVENTORYDB**
      - Component-managed authentication alias: **DB2User-INVENTORYDB**
      - Mapping-configuration alias: **DefaultPrincipalMapping**
      - Container-managed authentication alias: **DB2User-INVENTORYDB**
9. Remember to save and test the connection again.

### Step 7: Install Customer Order Services application

1.  We have provided a built EAR that has had the previously discussed changes for installation on WAS V9.0.  It is available at [https://github.com/ibm-cloud-architecture/refarch-jee/blob/master/static/artifacts/end-to-end-tutorial1/WAS9/CustomerOrderServicesApp-0.1.0-SNAPSHOT.ear](https://github.com/ibm-cloud-architecture/refarch-jee/blob/master/static/artifacts/end-to-end-tutorial1/WAS9/CustomerOrderServicesApp-0.1.0-SNAPSHOT.ear) for download.

2.  Install the EAR to the Admin console.
   -  Login to the Administrative Console.
   -  Select **Applications > Application Types > WebSphere enterprise applications**
   -  Choose **Install > Browse the EAR > Next > Choose Detailed**
   -  Click on **Step 12**.
   -  Customize the environment variables for your **DBUser-ORDERDB** instance:
     - **DBUNIT_SCHEMA:** BLUDB
     - **DBUNIT_USERNAME:** bluadmin
     - **DBUNIT_PASSWORD:** _(Value acquired in Step 3.4)_
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
