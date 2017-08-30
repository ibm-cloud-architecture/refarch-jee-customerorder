### Step 3. Containerize the Liberty app

In this step, we are going to use Docker technology to containerise our Liberty application so that it can be then deployed to a virtualized infrastructure using a containers orchestrator such as Kubernetes.


### Containerise app

- Explain dockerfile a bit so that students know how the container is built
- Create container from dockerfile

Start **Docker** in your machine.

1. Build the docker image.

`docker build -t "customer-order-services:liberty" .`

You can verify your docker image using the command `docker images`. You will find the image.

```
REPOSITORY                                          TAG                 IMAGE ID            CREATED             SIZE
customer-order-services                             liberty             8c3e4d876dad        2 hours ago         424MB
```

### Run the containerised app

2. Run the docker image.

`docker run -p 9080 customer-order-services:liberty`

When it is complete, you can see the below output.

```
[AUDIT   ] CWWKT0016I: Web application available (default_host): http://4963b17bece0:9080/CustomerOrderServicesWeb/
[AUDIT   ] CWWKT0016I: Web application available (default_host): http://4963b17bece0:9080/CustomerOrderServicesTest/
[AUDIT   ] CWWKZ0001I: Application CustomerOrderServicesApp-0.1.0-SNAPSHOT.ear started in 2.366 seconds.
[AUDIT   ] CWWKF0012I: The server installed the following features: [jsp-2.3, ejbLite-3.1, servlet-3.1, ssl-1.0, jndi-1.0, localConnector-1.0, federatedRegistry-1.0, appSecurity-2.0, jdbc-4.1, jaxrs-1.1, el-3.0, ldapRegistry-3.0, json-1.0, distributedMap-1.0, beanValidation-1.0, jpa-2.0].
[AUDIT   ] CWWKF0011I: The server defaultServer is ready to run a smarter planet.
```
Now you can run the application locally.

1. Go to your browser.
2. Access **http://<i>localhost</i>:<i>your port</i>/CustomerOrderServicesWeb/#shopPage**.
 
To get your port,
 - Use the command `docker ps`
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
