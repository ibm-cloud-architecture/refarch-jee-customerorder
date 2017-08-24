# Step 1. Perform transformation from WAS7 to Liberty (Optional)

**Output: server.xml**

## Create the Liberty server.xml file

Configuration of the traditional WebSphere should be migrated to Liberty before deploying the application to Liberty. In Liberty, the runtime environment operates from a set of built-in configuration default settings, and the configuration can be specified by overriding the default settings. 

For this, you can make use of available tools or it can be done manually.

### [Eclipse based configuration migration tool]( https://developer.ibm.com/wasdev/downloads/#asset/tools-WebSphere_Configuration_Migration_Tool)

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

### [WebSphere Configuration Migration Toolkit: WebSphere Migration](https://ibm.biz/WCMT_Web)

![Web Tool 1](https://github.com/ibm-cloud-architecture/refarch-jee/blob/master/static/imgs/LibertyToolKit/WebTool1.png)

![Web Tool 2](https://github.com/ibm-cloud-architecture/refarch-jee/blob/master/static/imgs/LibertyToolKit/WebTool2.png)

![Web Tool 3](https://github.com/ibm-cloud-architecture/refarch-jee/blob/master/static/imgs/LibertyToolKit/WebTool3.png)

![Web Tool 4](https://github.com/ibm-cloud-architecture/refarch-jee/blob/master/static/imgs/LibertyToolKit/WebTool4.png)

![Web Tool 5](https://github.com/ibm-cloud-architecture/refarch-jee/blob/master/static/imgs/LibertyToolKit/WebTool5.png)

![Web Tool 6](https://github.com/ibm-cloud-architecture/refarch-jee/blob/master/static/imgs/LibertyToolKit/WebTool6.png)

Finally, you will have a server.xml file generated.

### server.xml manual modifications

Open your liberty server.xml and replace the contents of it with the one we just generated.

However, the migration tool kit doesnot have access to the code. So, some of the modification must be done manually depending on the application you deploy.

1. The feature list must be replaced with the following.

     ```
     <featureManager>
        <feature>jsp-2.3</feature>
        <feature>jdbc-4.1</feature>
        <feature>jaxrs-1.1</feature>
        <feature>jpa-2.0</feature>
        <feature>ejbLite-3.1</feature>
        <feature>appSecurity-2.0</feature>
        <feature>ldapRegistry-3.0</feature>
        <feature>localConnector-1.0</feature>
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
     <dataSource id="OrderDS" jdbcDriverRef="DB2_Using_IBM_JCC_Driver_(XA)" jndiName="jdbc/orderds">
        <properties.db2.jcc databaseName="ORDERDB" portNumber="50000" serverName="localhost" user="db2inst1" password="db2inst1-pwd" />
     </dataSource>
     <dataSource id="INDS" jdbcDriverRef="DB2_Using_IBM_JCC_Driver_(XA)" jndiName="jdbc/inds">
        <properties.db2.jcc databaseName="INDB" portNumber="50000" serverName="localhost" user="db2inst1" password="db2inst1-pwd"/>
     </dataSource>
     ```
     
4. jdbcDriver definition should be modified pointing the location of jars.

     ```
     <jdbcDriver id="DB2_Using_IBM_JCC_Driver_(XA)" javax.sql.DataSource="com.ibm.db2.jcc.DB2XADataSource">
        <library id="DB2JCC4Lib">
          <fileset dir="/opt/ibm/db2/V11.1/java" includes="db2jcc4.jar db2jcc_license_cu.jar db2jcc_license_cisuz.jar" />
        </library>
     </jdbcDriver>
     ```

5. As we are using LDAP in the sample application, LDAP registry definition must be added.

     ```
     <ldapRegistry baseDN="" bindDN="**Use your bind DN**" bindPassword="**Use your bind password**" host="**use your host name**" id="ldap" ignoreCase="true" ldapType="IBM Tivoli Directory Server" port="**use your port number**" realm="SampleLdapIDSRealm">
    <idsFilters groupFilter="(&amp;(cn=%v)(objectclass=groupOfUniqueNames))" groupIdMap="*:cn" groupMemberIdMap="mycompany-allGroups:member;mycompany-allGroups:uniqueMember;groupOfNames:member;groupOfUniqueNames:uniqueMember" userFilter="(&amp;(uid=%v)(objectclass=inetorgperson))" userIdMap="*:uid">
    </idsFilters>
    </ldapRegistry>
    ```
Once you are done with all these modifications, your server.xml should look like [this]() - Link to be added

## Liberty server Configuration

1. Using command prompt, go to the Liberty/bin directory.
2. Use this command, install all the missing features.
   
   `installUtility install server_name`
   
   During the installation, it prompts to accept the licenses. Please accept them.

Your server is ready now with all the necessary features installed. 

## Deploying your application using Liberty server.

This can be done in two ways. You can use server.xml or dropins folder.

1. Using server.xml, you can deploy the application by adding the following lines to your server.xml.

   ```
   <application id="CustomerOrderServices" location="path/CustomerOrderServicesApp-0.1.0-SNAPSHOT.ear" name="CustomerOrderServices"></application>
   ```
2. Instead of this, you can also deploy the application by placing the ear file in the **dropins** folder.
   
   `Place your ear in Liberty dir/usr/servers/server_name/dropins`

