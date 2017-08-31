# Step 2. Build & run the Liberty app locally talking to remote DB2 and LDAP servers

In this step, we are going to build and run the Liberty app locally and connect it to the remote DB2 and LDAP servers simulating what would be a real production scenario.

Before building the application, on your skytap machine, go to **/home/skytap/PurpleCompute**. This is the home directory from where we run the lab.

- Login to your skytap machine.
- Open your terminal.
- Enter `cd PurpleCompute`

### Build the Liberty app

**Getting the project repository**

You can clone the repository from its main GitHub repository page and checkout the appropriate branch for this version of the application.

1. `git clone https://github.com/ibm-cloud-architecture/refarch-jee-customerorder.git`
2. `cd refarch-jee-customerorder`
3. `git checkout liberty`

**Building the ear file using Maven**

Maven is a good project management tool. It is based on Project Object Model (POM). Maven is generally used for projects build, dependency and documentation. Basically, it simplifies the project build. We are using Maven for building our project ear.

1. `cd CustomerOrderServicesProject`
2. `mvn clean package`

This command will build **CustomerOrderServicesApp-0.1.0-SNAPSHOT.ear** in **target** directory of **CustomerOrderServicesApp** for you. You can see the below message once the build is successful.

```
[INFO] ------------------------------------------------------------------------
[INFO] Reactor Summary:
[INFO] 
[INFO] project ............................................ SUCCESS [  0.157 s]
[INFO] CustomerOrderServices .............................. SUCCESS [  1.514 s]
[INFO] Customer Order Services Web Module ................. SUCCESS [  9.391 s]
[INFO] Customer Order Services Test Module ................ SUCCESS [  0.598 s]
[INFO] CustomerOrderServicesApp ........................... SUCCESS [  1.294 s]
[INFO] ------------------------------------------------------------------------
[INFO] BUILD SUCCESS
[INFO] ------------------------------------------------------------------------
[INFO] Total time: 13.061 s
[INFO] Finished at: 2017-08-30T11:08:51-05:00
[INFO] Final Memory: 30M/324M
[INFO] ------------------------------------------------------------------------
```

### Run the Liberty app

**Configuring the Liberty Server**

1. Go to the installation location of your Liberty server.

- Go to **defaultServer** folder .
  
  Path ... **Home > PurpleCompute > wlp > usr > servers > defaultServer**
  
  - You will find a **server.xml** file.
    
    - Replace this file with
      
      **/home/skytap/PurpleCompute/refarch-jee-customerorder/tutorial/tutorialConfigFiles/step2/server.xml**
    
  - Now, you can see one other file named **server.env**.
  
    - Replace this file with 
      
      **/home/skytap/PurpleCompute/refarch-jee-customerorder/tutorial/tutorialConfigFiles/step2/server.env**
      
    - Replace the database password with **your database password**.
    
    - Also, verify **DB2_JARS**. Check if the location mentioned contains the necessary JARs.
    
      In this environment, the JARs (db2jcc4.jar and db2jcc_license_cu.jar) are placed in **Home > PurpleCompute > db2lib**. 
    
**Deploying the app**
 
- Go to **Home > PurpleCompute > refarch-jee-customerorder > CustomerOrderServicesApp > target**
- You will see **CustomerOrderServicesApp-0.1.0-SNAPSHOT.ear**
- Copy this ear file into **apps** folder of your liberty server.
  
  Path ... **Home > PurpleCompute > wlp > usr > servers > defaultServer > apps**
  
Now, you are done with the configuration and the app is ready to deploy. To run the app on Liberty,

1. Open your terminal.
2. `cd /home/skytap/PurpleCompute/wlp/bin`
3. Before starting the server, to make sure all the utilities are installed, run `./installUtility install defaultServer`. It prompts you to accept the license by pressing 1. Please accept it.
3. Start the server - Run `./server start defaultServer`
4. Open your browser.
5. Access http://localhost:9080/CustomerOrderServicesWeb/#shopPage, it prompts you for username and password.
6. Login as the user `rbarcia` with the password of `bl0wfish`.

<p align="center">
<img src="https://github.com/ibm-cloud-architecture/refarch-jee/blob/master/static/imgs/LibertyToolKit/step2apprunning.png">
</p>

7.Now to stop the server - Run `./server stop defaultServer`



