# Customer Order Services - JavaEE Enterprise Application

## Application Overview

Details and simple diagram to be added

## Getting Started

### Building and deploying the application on WebSphere Application Server 7

#### Environment SetUp

Grab all the archives from http://rtpgsa.ibm.com/projects/c/case/artifacts/stonehenge/vagrant/WAS7/

1. http://rtpgsa.ibm.com/projects/c/case/artifacts/stonehenge/vagrant/WAS7/C1FZ9ML_was70_linux_x86-64.tar.gz
2. http://rtpgsa.ibm.com/projects/c/case/artifacts/stonehenge/vagrant/WAS7/7.0.0.43-WS-UPDI-LinuxAMD64.tar.gz
3. http://rtpgsa.ibm.com/projects/c/case/artifacts/stonehenge/vagrant/WAS7/7.0.0-WS-WAS-LinuxX64-FP0000043.pak 
4. http://rtpgsa.ibm.com/projects/c/case/artifacts/stonehenge/vagrant/WAS7/7.0.0-WS-WASSDK-LinuxX64-FP0000043.pak 
5. http://rtpgsa.ibm.com/projects/c/case/artifacts/stonehenge/vagrant/WAS7/WAS_V70_FP_WEB2.0_V11_MP.tar.gz 
6. http://rtpgsa.ibm.com/projects/c/case/artifacts/stonehenge/vagrant/WAS7/CZF7DML.zip 
7. http://rtpgsa.ibm.com/projects/c/case/artifacts/stonehenge/vagrant/WAS7/was.7.0.import.zip

#### Getting your environment ready

1. Use C1FZ9ML_was70_linux_x86-64.tar.gz and untar it. Execute the installation file (install) inside the WAS directory. This installs WAS7 into your system. The installer walks through the installation steps.

   Go to **C1FZ9ML_was70_linux_x86-64**
   
   **cd WAS**
   
   **./install**

   By the end you should be able to see IBM WebSphere Application Server V7.0 in your applications.

2. Install the UpdateInstaller. Use 7.0.0.43-WS-UPDI-LinuxAMD64.tar.gz and untar it. 

   Go to **7.0.0.43-WS-UPDI-LinuxAMD64**
   
   **cd UpdateInstaller**
   
   **./install**

   This installer walks you through the installation process. During the installation process, it asks you for the maintenance packages. Then browse the path containing 7.0.0-WS-WAS-LinuxX64-FP0000043.pak and 7.0.0-WS-WASSDK-LinuxX64-FP0000043.pak and continue the process. 

3. Install web2mobilefep_1.1. Use **WAS_V70_FP_WEB2.0_V11_MP.tar.gz** and untar it.

   **./install**

   Before running this, set JAVA_HOME and WAS_HOME variables.
   
   For example,

       export JAVA_HOME=/home/vagrant/IBM/WebSphere/AppServer1/java
       export WAS_HOME=/home/vagrant/IBM/WebSphere/AppServer1

   The installer will run you through the installation process and the feature gets installed in your system.

4. Install Feature Pack for Java Persistence API 2.0. For this, use CZF7DML.zip and unzip it.

   Go to **CZF7DML**
   
   **cd local-repositories**

   You will find a repository.config file in this directory. Now import this repo into the Installation Manager and install the JPA feature available.

   IBM Installation Manager --> File --> Preferences --> Add Repository --> Browse repository.config from local-repositories

   Once this is done, use the install option to find the package and then install the same. During the installation choose the JPA feature for installation when prompted.

5. Import the WAS 7 into the installation manager. This can be done by using was.7.0.import.zip. Unzip was.7.0.import.zip.

   Go to **was.7.0.import
   cd Fixpack70043Sync**

   You will find a **repository.config** file in this directory. Import the same into the Installation Manager.

   IBM Installation Manager --> File --> Preferences --> Add Repository --> Browse repository.config from Fixpack70043Sync

   Now choose the import option available in the installation manager and select the WAS7 installation directory to import it into the IBM Installation Manager.

   Once the import is done, check if the installation manager recommends any updates. If there are any recommended updates, please update them.

#### Getting the project repository

You can clone the repository from https://github.com/ibm-cloud-architecture/refarch-jee-customerorder.git

#### Running the Database and Creating the tables

This project uses DB2 as its database. Before creating the databasesa and getting connected to them, verify if your database is running. You can verfiy it using

1. su database_instance_name
2. db2start

Create two databases - ORDERDB and INDB

1. db2 create database ORDERDB
2. db2 create database INDB

After this, run the database scripts for the ORDERDB.  This also cleans the database tables just in case if needed.  

Connect to the Database using the db2 connect to ORDERDB command. 

Run the createOrderDB.sql script present inside the 'Common' sub directory of the project directory.

	db2 -tf /<Project Directory>/Common/createOrderDB.sql

Next connect to the inventory database INDB using the command db2 connect to INDB.

Run InventoryDdl.sql and InventoryData.sql scripts present inside the 'Common' sub directory of the project directory.

	db2 -tf /<Project Directory>/Common/InventoryDdl.sql
	db2 -tf /<Project Directory>/Common/InventoryData.sql
  
#### Configuring the WebSphere v7 Environment with Security and Resources

##### Setting Up Security

1. Launch the Admin console by going to the Server View in a RAD workspace, right click on a Server and select Administration --> Run Administrative console.

2. Log into the admin console. Admin Console can be accesed at http://localhost:9043/admin.

3. In the Global security section, enable the **Application security**.

4. In the Users and Groups section, use Manage users to create the users and Manage Groups to create Groups. During deployment, you will need to map your desired users or groups to the SecureShopper role. 

5. Under Global Security, select J2C authentication data. Create the DBUser using your db2 instance and password.

##### Configuring JDBC Resources

1. Go to the JDBC --> Providers section and ensure that you are at the Cell Level Configuration.  Click the New Button to create a New DataSource.

	Database type : **DB2**
	Provider type : **DB2 Using IBM JCC Driver**
	Implementation type : **XA data source**
	
2. You need to enter the database class path information. Enter the directory where the DB2 java is set.

3. Press **Next** and then **Finish**. Save the Configuration.

4. Go to the Data sources section to create a new Data source.

	JDBC --> Data sources 
	
   Make sure that the scope is at **cell** level.
   
   Under Preferences, click **New**.
   
   a) Page 1: Enter basic data source information
   	
	Data source name: OrderDS
	JNDI name: jdbc/orderds
	
   b) Page 2: Select JDBC provider
   	
	Select an existing JDBC provider --> DB2 Using IBM JCC Driver (XA)
   
   c) Page 3:
   
      1. Driver Type: **4**
      2. Database name: **ORDERDB**
      3. Server name: **localhost**
      4. Port number: **Your deafult DB2 port**

   d) Page 4: Set all aliases to DBUser
   
      1. Authentication alias for XA recovery: **DB2User**
      2. Componenet-managed authentication alias: **DB2User**
      3. Mapping-configuration alias: **DefaultPrincipalMapping**
      4. Container-managed authentication alias: **DB2User**
	
   e) Once this is done, under Preferences, there will be a new resource called OrderDS. Make sure that the resources got connected using **Test Connection** option.
   
      You will see a success message if the connection is established successfully.
      
   f) Check the Data source and select Test Connection to ensure you created the database correctly.  If the connection fails, a few things to check are
	
      1. Your database is started as we did in the beginning.  
      2. Your host and port number are correct.
      3. The classpath for the Driver is set properly.  
      4. Check the WebSphere Variables.  You may want to change them to point to your local DB2 install.You can check your variable values by selecting WebSphere variables.  Ensure your variables are at the cell level. 
   
   g) Create another new Data source using the same process as the previous one.
   
      1. Data source name: INDS
      2. JNDI name: jdbc/inds
      3. Select an existing JDBC provider --> DB2 Using IBM JCC Driver (XA)
      4. Driver Type: **4**, Database name: **ORDERDB**, Server name: **localhost**, Port number: **Your deafult DB2 port** 
      5. Set all aliases to DBUser, Authentication alias for XA recovery: **DB2User**, Componenet-managed authentication alias: **DB2User**, Mapping-configuration alias: **DefaultPrincipalMapping**, Container-managed authentication alias: **DB2User**
      6. Test the connection.
      
#### Running the Application in WAS7

1. Open RAD and create a new server in RAD

   In RAD --> Go to Servers view --> Right click and select New --> Server. 
   Then select WAS 7 and input the server details.

   Once done start the server.

2. Import the project directory from **https://github.com/ibm-cloud-architecture/refarch-jee-customerorder.git**

   Go to the project repository and then checkout **rad96-was70 branch**.

   `git checkout rad96-was70`  

3. From this branch, build the EAR using Maven in CustomerOrderServicesProject.

   Install Maven --> `mvn -v` to test your version
   **cd Project_Repository
   cd CustomerOrderServicesProject
   mvn clean package**

   By the end you will have an EAR built in subdirectory target of CustomerOrderServicesApp.

   CustomerOrderServicesApp --> target --> CustomerOrderServicesApp-0.1.0-SNAPSHOT.ear

4. Install the EAR from the 'target' subdirectory to http://localhost:9060/ibm/console

   Login to the console.
   Select Applications --> Application Types --> WebSphere enterprise applications
   Choose Install --> Browse the EAR --> Next --> Choose Detailed 

   Once done you will have a couple of steps. Verify the following.

   a) Check the **Map Shared Libraries** (Click on Step 4) and make sure the CustomerOrderServicesApp line has a reference to the IBM WebSphere Application Server traditional V7.0 JAX-RS Library.
   
   b) Check **Map environment variables to web modules** (Click on Step 12) and customize the environment variables for your system. This is most likely just going to be the DBUNIT_SCHEMA, DBUNIT_USERNAME, and DBUNIT_PASSWORD. Those values need to be specific to your local DB2 installation.
   
   c) Check **Map security roles to users or groups** (Click on Step 13) and make sure the SecureShopper role is mapped to the SecureShopper group.
   
   d) Click on **Summary** (Step 16) and click Finish.

   Once you see Application CustomerOrderServicesApp installed successfully, click Save and now your application is ready.

5. Go back to the enterprise applications list and select the application. Then click start and you are good to go.

   Access the application at http://localhost:9080/CustomerOrderServicesWeb
