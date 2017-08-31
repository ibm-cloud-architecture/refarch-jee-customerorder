### Step 3. Containerize the Liberty app

In this step, we are going to use Docker technology to containerise our Liberty application so that it can be then deployed to a virtualized infrastructure using a containers orchestrator such as Kubernetes.

### Containerising the app

We are using Docker to containerize the app. Using Docker, we can pack, ship and easily run the apps on a portable lightweight container that can run anywhere virtually.

Lets have a look at our [Docker file](https://github.com/ibm-cloud-architecture/refarch-jee-customerorder/blob/liberty/Dockerfile)

```
FROM websphere-liberty:webProfile7

COPY Common/server.xml /config
COPY Common/server.env.remote /config/server.env
COPY CustomerOrderServicesApp/target/CustomerOrderServicesApp-0.1.0-SNAPSHOT.ear /config/apps

RUN /opt/ibm/wlp/bin/installUtility install  --acceptLicense \
    appSecurity-2.0 \
    ejbLite-3.1 \
    ldapRegistry-3.0 \
    localConnector-1.0 \
    jaxrs-1.1 \
    jdbc-4.1 \
    jpa-2.0 \
    jsp-2.3 \
    servlet-3.1

ADD https://artifacts.alfresco.com/nexus/content/repositories/public/com/ibm/db2/jcc/db2jcc4/10.1/db2jcc4-10.1.jar /db2lib/db2jcc4.jar

ADD http://download.osgeo.org/webdav/geotools/com/ibm/db2jcc_license_cu/9/db2jcc_license_cu-9.jar /db2lib/db2jcc_lisence_cu.jar

```

1. **FROM** instruction is used to set the base image. We are setting the base image to **websphere-liberty:webProfile7**.
2. **COPY** instruction is used to copy directories and files from a source specified to a destination in the container file system.
   - We are copying the **server.xml** from **Common** directory to **config** folder in the container.
   - We are replacing the contents of **server.env** in **config** folder with contents of **server.env.remote** in **Common** directory.
   - We are also copying the **ear** file from **CustomerOrderServicesApp** and placing it in **apps** folder residing in **config**.
3. **RUN** instruction helps us to execute the commands. 
   - Here we have a pre-condition to install all the utilities in server.xml. We can use RUN command to install them on top of the base image.
4. **ADD** instruction is used to copy something using the remote URL. This is very similar to COPY command but with additional features like remote URL support and tar extraction.
   - In this case, we are downloading the jar files required for the app.

Using this docker file, we build a docker image and using this image we will launch the docker container.

#### Creating the container from dockerfile

Start **Docker** in your machine.

**Note** - While using docker commands, if you are getting the following message in your skytap environment, please add `sudo` before your instruction.

Eg. `docker images`

```
Got permission denied while trying to connect to the Docker daemon socket at unix:///var/run/docker.sock: Get http://%2Fvar%2Frun%2Fdocker.sock/v1.30/images/json: dial unix /var/run/docker.sock: connect: permission denied
```

Then use `sudo docker images`

```
REPOSITORY                                          TAG                 IMAGE ID            CREATED             SIZE
hello-world                                         latest              1815c82652c0        2 months ago        1.84kB
```
Before building the docker image, replace the database password in the **server.env.remote** with **your database password**.

- Navigate to **/home/skytap/PurpleCompute/refarch-jee-customerorder/Common/server.env.remote** and replace the password.


Navigate to this path as the docker file resides here.

`cd /home/skytap/PurpleCompute/refarch-jee-customerorder`

#### Build the docker image.

`sudo docker build -t "customer-order-services:liberty" .`

You can verify your docker image using the command `sudo docker images`. You will find the image.

```
REPOSITORY                                          TAG                 IMAGE ID            CREATED             SIZE
customer-order-services                             liberty             8c3e4d876dad        2 hours ago         424MB
```

#### Run the containerised app

Run the docker image.

`sudo docker run -p 9080 customer-order-services:liberty`

When it is complete, you can see the below output.

```
[AUDIT   ] CWWKT0016I: Web application available (default_host): http://4963b17bece0:9080/CustomerOrderServicesWeb/
[AUDIT   ] CWWKT0016I: Web application available (default_host): http://4963b17bece0:9080/CustomerOrderServicesTest/
[AUDIT   ] CWWKZ0001I: Application CustomerOrderServicesApp-0.1.0-SNAPSHOT.ear started in 2.366 seconds.
[AUDIT   ] CWWKF0012I: The server installed the following features: [jsp-2.3, ejbLite-3.1, servlet-3.1, ssl-1.0, jndi-1.0, localConnector-1.0, federatedRegistry-1.0, appSecurity-2.0, jdbc-4.1, jaxrs-1.1, el-3.0, ldapRegistry-3.0, json-1.0, distributedMap-1.0, beanValidation-1.0, jpa-2.0].
[AUDIT   ] CWWKF0011I: The server defaultServer is ready to run a smarter planet.
```
Now your application is running locally.

1. Go to your browser.
2. Access **http://<i>localhost</i>:<i>your port</i>/CustomerOrderServicesWeb/#shopPage**.
 
To get your port,
 - Use the command `sudo docker ps`
 ```
 CONTAINER ID  IMAGE                             COMMAND                  CREATED             STATUS                                             
4963b17bece0   customer-order-services:liberty   "/opt/ibm/docker/d..."   3 minutes ago       Up 3 minutes        

PORTS                                     NAMES
9443/tcp, 0.0.0.0:32768->9080/tcp         distracted_shirley
 ```
 
Grab the port and replace it in the url. In this case, port will be 32768.

3. Once you access **http://<i>localhost</i>:<i>your port</i>/CustomerOrderServicesWeb/#shopPage**, it prompts you for username and password.

4. Login as the user `rbarcia` with the password of `bl0wfish`.

<p align="center">
<img src="https://github.com/ibm-cloud-architecture/refarch-jee/blob/master/static/imgs/LibertyToolKit/AppRunningLocally.png">
</p>
