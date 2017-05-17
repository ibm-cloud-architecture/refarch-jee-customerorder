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

   Go to **C1FZ9ML_was70_linux_x86-64
   cd WAS
   ./install**

   By the end you should be able to see IBM WebSphere Application Server V7.0 in your applications.

2. Install the UpdateInstaller. Use 7.0.0.43-WS-UPDI-LinuxAMD64.tar.gz and untar it. 

   Go to **7.0.0.43-WS-UPDI-LinuxAMD64
   cd UpdateInstaller
   ./install**

   This installer walks you through the installation process. During the installation process, it asks you for the maintenance packages. Then browse the path containing 7.0.0-WS-WAS-LinuxX64-FP0000043.pak and 7.0.0-WS-WASSDK-LinuxX64-FP0000043.pak and continue the process. 

3. Install web2mobilefep_1.1. Use **WAS_V70_FP_WEB2.0_V11_MP.tar.gz** and untar it.

   **./install**

   Before running this, set JAVA_HOME and WAS_HOME variables.

       export JAVA_HOME=/home/vagrant/IBM/WebSphere/AppServer1/java
       export WAS_HOME=/home/vagrant/IBM/WebSphere/AppServer1

   The installer will run you through the installation process and the feature gets installed in your system.

4. Install Feature Pack for Java Persistence API 2.0. For this, use CZF7DML.zip and unzip it.

   Go to **CZF7DML
   cd local-repositories**

   You will find a repository.config file in this directory. Now import this repo into the Installation Manager and install the JPA feature available.

   IBM Installation Manager --> File --> Preferences --> Add Repository --> Browse repository.config from local-repositories

   Once this is done, use the install option to find the package and then install the same. During the installation choose the JPA feature for installation when prompted.

5. Import the WAS 7 into the installation manager. This can be done by using was.7.0.import.zip. Unzip was.7.0.import.zip.

   Go to **was.7.0.import
   cd Fixpack70043Sync**

   You will find a repository.config file in this directory. Import the same into the Installation Manager.

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

Details to be added

#### Running the Application in WAS7

Details to be added
