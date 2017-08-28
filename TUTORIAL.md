# Step 1. Perform transformation from WAS7 to Liberty (Optional)

In this step, we are going to make the modifications needed both at the application level and the server configuration level to migrate our WebSphere Application Server 7 application to run in WebSphere Liberty.

**_(To be discussed. We might one to do the config migration before the source migration since we will need the config to run the application to complete the source migration process)_**

1.  [Source Code Migration](#source-code-migration)
2.  [WebSphere Configuration Migration](#websphere-configuration-migration)

## Source Code Migration

In order to migrate the code to get our WebSphere Application Server 7 application working on WebSphere Liberty, we are going to use the [WebSphere Application Server Migration Toolkit (WAMT)](https://developer.ibm.com/wasdev/downloads/#asset/tools-WebSphere_Application_Server_Migration_Toolkit). The migration toolkit provides a rich set of tools that help you migrate applications from third-party application servers, between versions of WebSphere Application Server, to Liberty, and to cloud platforms such as Liberty for Java on IBM Bluemix, IBM WebSphere on Cloud and Docker.

### Software Analyzer Configuration

More precisely, we are going to use the Software Analyzer that the WAMT comes with. For doing so, we first need to have in our development environment eclipse opened with the WAMT installed on it and our WAS 7 application projects imported into the workspace. Once we have the above in place, click on **Run -> Analysis...** This will open the **Software Analyzer**.

![Source migration 1](https://github.com/ibm-cloud-architecture/refarch-jee/blob/master/static/imgs/toLiberty/Source1.png)

Now, **right-click** on _Sofwtare Analyzer_ and select **New**. Give a relevant and appropriate name to the new configuration and click on the **Rules** tab for this configuration. Select the **WebSphere Application Server Version Migration** option for the _Rule Sets_ dropdown menu and click **Set...**

![Source migration 2](https://github.com/ibm-cloud-architecture/refarch-jee/blob/master/static/imgs/toLiberty/Source2.png)

The Rule set configuration panel should be displayed. This panel must be configured so that the appropriate set of rules based on our migration requirements are applied during the software analysis of our applications.

![Source migration 3](https://github.com/ibm-cloud-architecture/refarch-jee/blob/master/static/imgs/toLiberty/Source3.png)

### Running the Software Analyzer

After running the _Software Analyzer_ you should see a _Software Analyzer Results_ tab at the bottom. The Software Analyzer rules are categorised, and so are the errors and warnings produced in its report, in four categories: **Java Code Review, XML File Review, JSP Code Review and File Review**. We must go through each of these tabs/categories and review the errors and warnings as code/configuration changes might be needed.

![Source migration 4](https://github.com/ibm-cloud-architecture/refarch-jee/blob/master/static/imgs/toLiberty/Source4.png)

We will start off with the **File Review** analysis tab. As you can see in the image below, one warning that will always appear when you migrate your apps to a newer WebSphere Application Server version is the need to configure the appropriate target runtime for your applications. This is the first and foremost step:

![Source migration 5](https://github.com/ibm-cloud-architecture/refarch-jee/blob/master/static/imgs/toLiberty/Source5.png)

Along with the warning and errors reported, the WebSphere Application Migration Toolkit also comes with information about the rule that flagged the each error/warning and the possible solutions for them. In order to see this info and help, click on **Help -> Show Contextual Help**. This will open the help portlet in eclipse.

![Source migration 6](https://github.com/ibm-cloud-architecture/refarch-jee/blob/master/static/imgs/toLiberty/Source6.png)

If you scroll down to the bottom and press on the "detailed help" button it will show you additional ideas on how to resolve that problem.

![Source migration 7](https://github.com/ibm-cloud-architecture/refarch-jee/blob/master/static/imgs/toLiberty/Source7.png)

If we follow the instructions and go to Targeted Runtimes for any of the project we might find out that WebSphere Liberty does not seem to appear as an option.

![Source migration 8](https://github.com/ibm-cloud-architecture/refarch-jee/blob/master/static/imgs/toLiberty/Source8.png)

However, if we click on the Show all runtimes option, we see the other runtimes availabe in our environment. They now appear although they are greyed out. The reason is, as we can read at the bottom of the panel, that we might need to uninstall one or more of the currently installed project facets.

![Source migration 9](https://github.com/ibm-cloud-architecture/refarch-jee/blob/master/static/imgs/toLiberty/Source9.png)

In our case, the problem resides in the current WebSphere Application Server version 7 specific facets we have installed in our projects for them to properly run on that WebSphere version. As a result, we now need to uninstall them. For doing so, click on the Uninstall Facets... hyperlink presented on this panel and then deselect all WebSphere specific facets you might find active.

![Source migration 10](https://github.com/ibm-cloud-architecture/refarch-jee/blob/master/static/imgs/toLiberty/Source10.png)

Once you have deselected all active WebSphere specific facets installed for the project, click on Finish. You will get back to the targeted runtimes panel but you will not see the WebSphere Application Server Liberty option available to select just yet until you click on Apply. Hence, click on Apply, deselect the existing WebSphere Application Server traditional V7.0 option, select the WebSphere Application Server Liberty option and click on Apply and OK. **Repeat the same process for all four projects**

![Source migration 11](https://github.com/ibm-cloud-architecture/refarch-jee/blob/master/static/imgs/toLiberty/Source11.png)

If we ran the Software Analyzer again, we should see the File Review tab empty.

Moving on to the **Java Code Review** category tab, these are the aspects the WebSphere Application Migration Toolkit warns us about:

![Source migration 12](https://github.com/ibm-cloud-architecture/refarch-jee/blob/master/static/imgs/toLiberty/Source12.png)

The first warning we see in there is about using the default initalContext JNDI properties. In order to understand more about the problem, we click on it and read what the Help portlet says about it. If we still want or need more information, we can always click on the Detailed help link displayed within the portlet for a deeper and longer explanation:

![Source migration 13](https://github.com/ibm-cloud-architecture/refarch-jee/blob/master/static/imgs/toLiberty/Source13.png)

Now that we have understood what the problem is, we can double click on the file pointed out by the Software Analyzer to inspect the actual code and determine whether this warning affects our application or not:

![Source migration 14](https://github.com/ibm-cloud-architecture/refarch-jee/blob/master/static/imgs/toLiberty/Source14.png)

As you can see by looking at the code, we are not using any of the two default initialContext JNDI properties this warning is about so we do not need to care about their default values. As a result, we can ignore this warning and move on to the next one.

Next aspect in this **Java Code Review** section is about the use of sytem-provided third-party APIs:

![Source migration 18](https://github.com/ibm-cloud-architecture/refarch-jee/blob/master/static/imgs/toLiberty/Source18.png)

If we click on the detailed help within the help portlet we are presented with the following information:

![Source migration 19](https://github.com/ibm-cloud-architecture/refarch-jee/blob/master/static/imgs/toLiberty/Source19.png)

However, that does not seem like enough information in order to figure out what the problem is. Therefore, we click on the link at the bottom which get us to the following IBM Knowledge Center page for WebSphere:

![Source migration 20](https://github.com/ibm-cloud-architecture/refarch-jee/blob/master/static/imgs/toLiberty/Source20.png)

With the information gathered along the links we have visited above, we now realise we need to configure the application in the server.xml file to be able to access third-party libraries by adding the following:

```
<application id="customerOrderServicesApp" name="CustomerOrderServicesApp.ear" type="ear" location="${shared.app.dir}/CustomerOrderServicesApp.ear">
     <classloader apiTypeVisibility="spec, ibm-api, third-party" />
</application>
```

The above will allow the classloader to have access to the third-party libraries included with Liberty. Some of those third-party libraries we need the classloader to have access to so that our application work fine are Jackson and Apache Wink libraries.

Last aspect in this **Java Code Review** section has to do with a change in the JPA cascade strategy and its detailed information says the following:

![Source migration 15](https://github.com/ibm-cloud-architecture/refarch-jee/blob/master/static/imgs/toLiberty/Source15.png)

As we can read in the detailed info above, the change in the JPA cascade strategy is not expected to affect most applications. Also, this new cascade strategy can be mitigated by simply reverting to the previous behaviour by setting the _openjpa.Compatibility_ peroperty in the _persistence.xml_ file. Anyway, newer WebSphere Application Server versions can always be configured to run on previous or older version for most of the JEE technologies. JPA is one of them and you can see in the server.xml file that we are using tje jpa-2.0 feature so that the warning above does not affect our app at all.

Finally, moving on to the last **XML File Review** section in the Software Analyzer results, we see a problem due to a behaviour change on lookups for Enterprise JavaBeans:

![Source migration 16](https://github.com/ibm-cloud-architecture/refarch-jee/blob/master/static/imgs/toLiberty/Source16.png)

And this is what the detailed help says about it:

![Source migration 17](https://github.com/ibm-cloud-architecture/refarch-jee/blob/master/static/imgs/toLiberty/Source17.png)

If we click on the file that is being raised the error on, we realise we are using the WebSphere Application Server traditional namespaces for the EJB binding:

![Source migration 34](https://github.com/ibm-cloud-architecture/refarch-jee/blob/master/static/imgs/toLiberty/Source34.png)

Therefore, we need to change it to

```
java:app/CustomerOrderServices/ProductSearchServiceImpl!org.pwte.example.service.ProductSearchService
```

### Running the application

In order to locally run our application now that we seem to have the appropriate source code of the application and the server configuration migrated to WebSphere Liberty, we right-click on the CustomerOrderServicesApp project and select export --> EAR file

We are presented with a dialog to export our project as an EAR file. In this dialog, we must give our EAR project the appropriate name **CustomerOrderServicesApp** and the proper destination **_WebSphere-Liberty-Installation-path_/usr/shared/apps**. Finally, we optimize the application to run on WebSphere Application Server Liberty and select the Overwrite existing file option in case there was an existing application with he same name already.

![Source migration 21](https://github.com/ibm-cloud-architecture/refarch-jee/blob/master/static/imgs/toLiberty/Source21.png)

Once the EAR project has been exported as an EAR file into the shared applications folder for WebSphere Liberty (and the application itself as a result), we go into the Servers tab in eclipse, right click on WebSphere Application Server Liberty at localhost and click on start. We should get moved to the Console tab in eclipse right away in order to see the WebSphere Liberty's output. We should then see something similar to:

![Source migration 22](https://github.com/ibm-cloud-architecture/refarch-jee/blob/master/static/imgs/toLiberty/Source22.png)

where we can find the links for the two web applications deployed into WebSphere Liberty. One is a test project we will ignore for the time being. The other is the Customer Order Services Web Application and should be accessible at http://localhost:9080/CustomerOrderServicesWeb/. Go ahead and click on that link in the Console tab in eclipse or open a web browser yourself and point it to that url.

You will first be presented with a log in dialog since we have security for our application enabled as you can find out in the server.xml file.

![Source migration 23](https://github.com/ibm-cloud-architecture/refarch-jee/blob/master/static/imgs/toLiberty/Source23.png)

Introduce **rbarcia or kbrown** as the username and **bl0wfish** as the password for the credentials. Once you have done that, you should be able to see the Customer Order Services Web Application displayed in your web browser. However you will most likely be presented with an error on screen:

![Source migration 24](https://github.com/ibm-cloud-architecture/refarch-jee/blob/master/static/imgs/toLiberty/Source24.png)

If we go into the Console tab for WebSphere Liberty Server in eclipse we will see the following trace:

![Source migration 25](https://github.com/ibm-cloud-architecture/refarch-jee/blob/master/static/imgs/toLiberty/Source25.png)

This means that _CustomerOrderResource.java_ couldn't find _ejblocal:org.pwte.example.service.CustomerOrderServices_ during the lookup of it. The reason for this is what we have already seen during the Software Analisis section above in regards to the EJB lookups in WebSphere Liberty. More precisely, you can find the explanation in the **XML File Review** section above. However, the Software Analyzer did not raised these lookups since they were not done through bindings or the @EJB annotation but through initial context lookups:

![Source migration 26](https://github.com/ibm-cloud-architecture/refarch-jee/blob/master/static/imgs/toLiberty/Source26.png)

As a result, we need to change the three web resources within the Web project so that the inital context lookups succeed. Hence, change the initial context lookups located in the following files:

![Source migration 27](https://github.com/ibm-cloud-architecture/refarch-jee/blob/master/static/imgs/toLiberty/Source27.png)

Those lookups should look like the following respectively:

```
java:app/CustomerOrderServices/ProductSearchServiceImpl!org.pwte.example.service.ProductSearchService
java:app/CustomerOrderServices/CustomerOrderServicesImpl!org.pwte.example.service.CustomerOrderServices
java:app/CustomerOrderServices/ProductSearchServiceImpl!org.pwte.example.service.ProductSearchService
```

Once we have corrected the way EJB lookups are specified in WebSphere Liberty, we export the EAR project again and run the application. After loging into the application we should now see the Customer Order Services Application:

![Source migration 28](https://github.com/ibm-cloud-architecture/refarch-jee/blob/master/static/imgs/toLiberty/Source28.png)

However, if we look into the Console tab for WebSphere Liberty in eclipse, we still see errors:

![Source migration 29](https://github.com/ibm-cloud-architecture/refarch-jee/blob/master/static/imgs/toLiberty/Source29.png)

Looking carefuly at them, we see there is a problem with the data type problem with the data that is returned from the database and that this happens in the loadCustomer method in CustomerOrderServicesImpl.java. So is we look into that method we soon realise this is only trying to return an AbstractCustomer from the database:

![Source migration 30](https://github.com/ibm-cloud-architecture/refarch-jee/blob/master/static/imgs/toLiberty/Source30.png)

Therefore, the problem must reside in the AbstractCustomer class. However, as the name suggests, this is an abstract class and thus it will not be instantiated. Instead, we need to look for the classes that extends such abstract class. These are BusinessCustomer and ResidentialCustomer. If we remember the SQL error we have in the WebSphere Liberty Console log, it is about a value 'Y' being returned as an integer. If we then look at the Java classes we realise that some boolean attributes, which will get values of 'Y' and 'N', are being returned as Integer causing the SQL exception.

The reason for this is that the OpenJPA driver treats booleans differently based on its version. In this case, the OpenJPA driver version we are using in WebSphere Liberty does not convert 'Y' or 'N' database values into booleans automatically. As a result, we need to store them as Strings and check those Strings to return a boolean value:

![Source migration 31](https://github.com/ibm-cloud-architecture/refarch-jee/blob/master/static/imgs/toLiberty/Source31.png)
![Source migration 32](https://github.com/ibm-cloud-architecture/refarch-jee/blob/master/static/imgs/toLiberty/Source32.png)

Again, save all the changes, export the EAR project to the WebSphere Liberty folder and start the Server up. You should now see the Customer Order Services web application with no errors at all either on the browser or in the Console tab for WebSphere Liberty in eclipse:

![Source migration 33](https://github.com/ibm-cloud-architecture/refarch-jee/blob/master/static/imgs/toLiberty/Source33.png)

## WebSphere Configuration Migration

**Output: server.xml**

### Create the Liberty server.xml file

Configuration of the traditional WebSphere should be migrated to Liberty before deploying the application to Liberty. In Liberty, the runtime environment operates from a set of built-in configuration default settings, and the configuration can be specified by overriding the default settings. 

For this, you can make use of available tools or it can be done manually.

#### [Eclipse based configuration migration tool]( https://developer.ibm.com/wasdev/downloads/#asset/tools-WebSphere_Configuration_Migration_Tool)

[Eclipse-based WebSphere Configuration Migration tool](https://developer.ibm.com/wasdev/downloads/#asset/tools-WebSphere_Configuration_Migration_Tool) can be used to migrate the configuration from different types of servers to WebSphere application server. This can also be used to migrate the configuration of traditional WebSphere to Liberty.

Once this tool gets installed in your IDE, you can access it using the option Migration Tools.

![Eclipse Plugin1](https://github.com/ibm-cloud-architecture/refarch-jee/blob/master/static/imgs/LibertyToolKit/EclipseMigToolkit.png)

Choose your environment and proceed with the migration.

![Eclipse Plugin2](https://github.com/ibm-cloud-architecture/refarch-jee/blob/master/static/imgs/LibertyToolKit/ConfigMigToolPropsFile.png)

`./wsadmin.sh –lang jython –c “AdminTask.extractConfigProperties(‘[-propertiesFileName my.props]’)”`

After executing this command, my.props file will be generated. The properties file for this sample application can be accessed here [my.props](https://github.com/ibm-cloud-architecture/refarch-jee/blob/master/phases/phase1_assets/my.props)

Choose WebSphere Liberty as the target environment and continue the process.

![Eclipse Plugin3](https://github.com/ibm-cloud-architecture/refarch-jee/blob/master/static/imgs/LibertyToolKit/ConfigMigToolTarget.png)

![Eclipse Plugin4](https://github.com/ibm-cloud-architecture/refarch-jee/blob/master/static/imgs/LibertyToolKit/ConfigMigToolResources.png)

![Eclipse Plugin5](https://github.com/ibm-cloud-architecture/refarch-jee/blob/master/static/imgs/LibertyToolKit/FinalServerXML.png)

At the end, you will have server.xml file generated. Save it.

After generating my.props file, you can also make use of [WebSphere Configuration Migration Toolkit: WebSphere Migration](https://ibm.biz/WCMT_Web) available online. This is just a replacement to the Eclipse plugin. Both of them works in the same way.

#### [WebSphere Configuration Migration Toolkit: WebSphere Migration](https://ibm.biz/WCMT_Web)

![Web Tool 1](https://github.com/ibm-cloud-architecture/refarch-jee/blob/master/static/imgs/LibertyToolKit/WebTool1.png)

![Web Tool 2](https://github.com/ibm-cloud-architecture/refarch-jee/blob/master/static/imgs/LibertyToolKit/WebTool2.png)

![Web Tool 3](https://github.com/ibm-cloud-architecture/refarch-jee/blob/master/static/imgs/LibertyToolKit/WebTool3.png)

![Web Tool 4](https://github.com/ibm-cloud-architecture/refarch-jee/blob/master/static/imgs/LibertyToolKit/WebTool4.png)

![Web Tool 5](https://github.com/ibm-cloud-architecture/refarch-jee/blob/master/static/imgs/LibertyToolKit/WebTool5.png)

![Web Tool 6](https://github.com/ibm-cloud-architecture/refarch-jee/blob/master/static/imgs/LibertyToolKit/WebTool6.png)

Finally, you will have a server.xml file generated.

#### server.xml manual modifications

Open your liberty server.xml and replace the contents of it with the one we just generated.

However, the migration tool kit doesnot have access to the code. So, some of the modification must be done manually depending on the application you deploy.

1. The feature list must be replaced with the following.

     ```
     <featureManager>
      <feature>localConnector-1.0</feature>
      <feature>jsp-2.3</feature>
      <feature>jpa-2.0</feature>
      <feature>jaxrs-1.1</feature>
      <feature>servlet-3.1</feature>
      <feature>jdbc-4.1</feature>
      <feature>ejbLite-3.1</feature>
      <feature>appSecurity-2.0</feature>
      <feature>ldapRegistry-3.0</feature>
     </featureManager>
     ```
  
2. Configure the http port.

     ```
     <httpEndpoint host="*" httpPort="9080" httpsPort="9443" id="defaultHttpEndpoint">
      <tcpOptions soReuseAddr="true"/>
     </httpEndpoint>
     ```
     
3. Modify the datasource definition, as the migration tool kit grabbed the default ones for traditional server, replace them in such a way that they are preferred for Liberty.
 
     ```
     <dataSource id="OrderDS" type="javax.sql.XADataSource" jndiName="jdbc/orderds">
      <jdbcDriver libraryRef="DB2Lib"/>
      <properties.db2.jcc  user="${env.DB2_USER_ORDER}" password="${env.DB2_PASSWORD_ORDER}" databaseName="${env.DB2_DBNAME_ORDER}" serverName="${env.DB2_HOST_ORDER}" portNumber="${env.DB2_PORT_ORDER}"/>
      <connectionManager agedTimeout="0" connectionTimeout="180" maxIdleTime="1800" maxPoolSize="10" minPoolSize="1" reapTime="180"/>
     </dataSource>
     <dataSource id="INDS" type="javax.sql.XADataSource" jndiName="jdbc/inds">
      <jdbcDriver libraryRef="DB2Lib"/>
      <properties.db2.jcc  user="${env.DB2_USER_INVENTORY}" password="${env.DB2_PASSWORD_INVENTORY}" databaseName="${env.DB2_DBNAME_INVENTORY}" serverName="${env.DB2_HOST_INVENTORY}" portNumber="${env.DB2_PORT_INVENTORY}"/>
      <connectionManager agedTimeout="0" connectionTimeout="180" maxIdleTime="1800" maxPoolSize="10" minPoolSize="1" reapTime="180"/>
     </dataSource>
     ```
     
4. jdbcDriver definition should be modified pointing the location of jars.

     ```
     <library id="DB2Lib">
      <fileset dir="${env.DB2_JARS}" includes="db2jcc4.jar db2jcc_license_cu.jar"/>
     </library>
     ```

5. As we are using LDAP in the sample application, LDAP registry definition must be added.

     ```
     <ldapRegistry id="ldap" host="${env.LDAP_HOST}" port="${env.LDAP_PORT}" baseDN="${env.LDAP_BASE_DN}" bindDN="${env.LDAP_BIND_DN}" bindPassword="${env.LDAP_BIND_PASSWORD}" realm="${env.LDAP_REALM}" ignoreCase="true" ldapType="IBM Tivoli Directory Server">
      <idsFilters groupFilter="(&amp;(cn=%v)(objectclass=groupOfUniqueNames))" groupIdMap="*:cn" groupMemberIdMap="mycompany-allGroups:member;mycompany-allGroups:uniqueMember;groupOfNames:member;groupOfUniqueNames:uniqueMember" userFilter="(&amp;(uid=%v)(objectclass=inetorgperson))" userIdMap="*:uid">
      </idsFilters>
    </ldapRegistry>
    ```
Once you are done with all these modifications, your server.xml should look like [this](https://github.com/ibm-cloud-architecture/refarch-jee-customerorder/blob/toLiberty/Common/server.xml) and the env variables are defined in [server.env](https://github.com/ibm-cloud-architecture/refarch-jee-customerorder/blob/toLiberty/Common/server.env)

### Liberty server Configuration

1. Using command prompt, go to the Liberty/bin directory.
2. Use this command, install all the missing features.
   
   `installUtility install server_name`
   
   During the installation, it prompts to accept the licenses. Please accept them.

Your server is ready now with all the necessary features installed. 

### Deploying your application using Liberty server.

This can be done in two ways. You can use server.xml or dropins folder.

1. Using server.xml, you can deploy the application by adding the following lines to your server.xml.

   ```
   <application id="CustomerOrderServices" location="path/CustomerOrderServicesApp-0.1.0-SNAPSHOT.ear" name="CustomerOrderServices"></application>
   ```
2. Instead of this, you can also deploy the application by placing the ear file in the **dropins** folder.
   
   `Place your ear in Liberty dir/usr/servers/server_name/dropins`

