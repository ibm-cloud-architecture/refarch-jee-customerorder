# Step 5. Deploy the Liberty app to IBM Cloud private

In this final step, we are going to deploy our Liberty app to our IBM Cloud private through the Kubernetes command line interface or the ICp dashboard.

# Building and deploying 

## Prerequisites
* kubectl
* Docker CLI

## Preparation steps

Before we start deployment we will create a separate user and namespace in kubernetes where the application will be hosted.
Namespacing is a concept in Kubernetes that allows isolation of applications and other resourcs.

### Create user and namespace
1. In your webbroswer login to the the ICp Dashboard on `https://10.0.0.1:8443` as a system administrator, username `admin` password `admin`.
#### Creating a namespace
1. From the navigation menu, select System > Namespaces.
1. Click New Namespace.
1. Enter a namespace name `websphere'
1. Click Add Namespace.
#### Adding a user to a namespace
1. Navigate to the `Users` tab.
1. Click New User.
1. Enter "user1" as the user name, and provide a password and email address.
1. Select Namespace `websphere`.
1. Click Add User

# Push image to ICp Image Repository
ICp provides a docker compatible image repository out of the box, which is available on the server `master.cfc` port `8500`

### Re-Tag image
To be able to push the image we build in the previous step into the ICp Image Repository, we'll need to add an additional tag to the image we built.

From the command line, enter the following command
```
$ docker tag customer-order-services:liberty master.cfc:8500/websphere/customer-order-services:liberty
```
This extra information in the tag tells docker that this image belongs to the repository `websphere` on the `master.cfc:8500` server, which maps to the namespace we created above.

### Push image
To make the image available to use in Kubernetes enter the following commands
1. `$ docker login login master.cfc:8500` providing `user1` as the user and the password you created above
1. `$ docker push master.cfc:8500/websphere/customer-order-services:liberty`


You will now be able to see the image in the ICp Dashboard under *Infrastructure -> Images*



# Deploy application
Applications can be deployed both from the ICp Dashboard or using the Kubenetes command line tool `kubectl`
Both approaches will be described in this guide.

### From GUI

####  Create ConfigMaps
The environment specific runtime variables for the application will be held in ConfigMaps. We use ConfigMaps to hold deployment specific variables, such that images and deployment manifests can be independent of individual deployments, making it easy to reuse the majority of assets across different environments such as pre-prod and prod.
This information will include connectivity details for the Order database, the Inventory database and the LDAP server.

1. Log in to the ICp Dashboard as user `user1`
1. From the navigation menu, select Configs
1. Click Create Configmap
1. In the dialog box, provide the name ```orderdb```
1. Toggle the ```JSON mode``` button to enter JSON mode
1. in the ```data``` key enter the following map

    ```
    "DB2_HOST_ORDER": "cap-sg-prd-2.integration.ibmcloud.com",
    "DB2_PORT_ORDER": "16516",
    "DB2_DBNAME_ORDER": "ORDERDB",
    "DB2_USER_ORDER": "db2inst1",
    "DB2_PASSWORD_ORDER": "insert password here"
    ```

1. Click ```Create```

1. Click Create Configmap
1. In the dialog box, provide the name ```inventorydb```
1. Toggle the ```JSON mode``` button to enter JSON mode
1. in the ```data``` key enter the following map

    ```
    "DB2_HOST_INVENTORY": "cap-sg-prd-2.integration.ibmcloud.com",
    "DB2_PORT_INVENTORY": "16516",
    "DB2_DBNAME_INVENTORY": "INDB",
    "DB2_USER_INVENTORY": "db2inst1",
    "DB2_PASSWORD_INVENTORY": "insert password here"
    ```

1. Click ```Create```

1. Click Create Configmap
1. In the dialog box, provide the name ```ldap```
1. Toggle the ```JSON mode``` button to enter JSON mode
1. in the ```data``` key enter the following map

    ```
    "LDAP_HOST": "cap-sg-prd-4.integration.ibmcloud.com",
    "LDAP_PORT": "17830",
    "LDAP_BASE_DN": "",
    "LDAP_BIND_DN": "uid=casebind,ou=caseinc,o=sample",
    "LDAP_BIND_PASSWORD": "caseBindUser!",
    "LDAP_REALM": "SampleLdapIDSRealm"
    ```

1. Click ```Create```


#### Deploy application

1. From navigation menu, select Applications.
1. Select Deploy Application.
1. On the General tab, provide an application name.
1. On the Container Settings tab, provide a container name, image name, and port.​​​​​​
    
    * Application name: customerorderservices
    * Container name: customerorderservices
    * Image name: master.cfc:8500/websphere/customer-order-services:liberty
    * Container port: 9080

1. To be able to expose the information we stored in the ConfigMaps we need to create some entries in the JSON files manually
   To see underpinning JSON file toggle `JSON mode`
1. Under `containers` enter
    ```
    "envFrom": [
        {
            "configMapRef": {
                "name": "orderdb"
            }
        },
        {
            "configMapRef": {
                "name": "inventorydb"
            }
        },
        {
            "configMapRef": {
                "name": "ldap"
            }
        }
    ],
    
    ```
1.Select Deploy.

#### Expose the application
To be able to connect to the application from our workstation we need to expose the application to the external network.

1. From the Applications view, right click the cog wheel for the application and select `Expose`
1. Fill in Expose Method, Port and Target port. The other fields can be left blank or as default values
    * Expose Method: ClusterIP
    * Port: 80
    * Target Port: 9080

#### Validate application

1. From the Application View locate the application and click on the application name. 
1. In the application overview page, locate the `Expose details` section
1. Click on the `access 80` link
1. In the new web broswer tab that opens, append `CustomerOrderServicesWeb/` to the URL, resulting in a URL similar to this:
    ```
    https://10.0.0.1:8443/kubernetes/api/v1/proxy/namespaces/websphere/services/customerorderservices:80/CustomerOrderServicesWeb/
    ```
1. Validate that the shop loads with product listings

### From kubectl

####  Create ConfigMaps
The environment specific runtime variables for the application will be held in ConfigMaps. We use ConfigMaps to hold deployment specific variables, such that images and deployment manifests can be independent of individual deployments, making it easy to reuse the majority of assets across different environments such as pre-prod and prod.
This information will include connectivity details for the Order database, the Inventory database and the LDAP server.
We will load the variables from properties files located in the Common directory.

1. Update the passwords for the database settings

    ```
    sed -i 's/___TOBEREPLACED___/insertPassword/g' Common/order-db.properties
    sed -i 's/___TOBEREPLACED___/insertPassword/g' Common/inventory-db.properties
    ```
1. Create the ConfigMaps
    
    ```
    kubectl create configmap orderdb --from-file=order-db.properties
    kubectl create configmap inventorydb --from-file=inventory-db.properties
    kubectl create configmap ldap --from-file=ldap.properties


#### Generate deployment.yaml
Our deployment file will look like this

    ```
    apiVersion: v1
    kind: Service
    metadata:
      name: customerorderservices
      labels:
        app: customerorderservices
    spec:
      ports:
        - port: 80
          targetPort: 9080
      selector:
        app: customerorderservices
      type: ClusterIP
      
    ---
    apiVersion: extensions/v1beta1
    kind: Deployment
    metadata:
      labels:
        app: customerorderservices
      name: customerorderservices
    spec:
      replicas: 1
      template:
        metadata:
          labels:
            app: customerorderservices
        spec:
          containers:
          - image: master.cfc:8500/websphere/customer-order-services:liberty
            name: customerorderservices
            ports:
            - containerPort: 9080
              protocol: TCP
            envFrom:
            - configMapRef:
                name: orderdb
            - configMapRef:
                name: inventorydb
            - configMapRef:
                name: ldap 
          imagePullSecrets:
          - name: user1.registrykey
    ```

You can see there are two sections in this file, separated by `---`. The three dashes is a yaml construct that allows us to put the content of multiple files in a single file.

Above the dashes is the Service, indicated by `kind: Service`. Here we describe how we like the application to be exposed. In our case we choose to use ClusterIP, which means the application will receive an IP address from the 10.1.0.0/16 IP address range

The next part is the deployment part, indicated by `kind: Deployment`. Here we describe what we want the target state of the application to be.

The envFrom section enables the data we entered in the ConfigMaps in previous steps to be consumed by the application in the containers as environment variables.


1. Run kubectl to apply the deployment

    ```kubectl apply -f deployment.yaml```
    
#### Validate 

To validate that the application is running properly, grab the Clusters IP address using kubectl
```
kubectl get service customerorderservices
```

Using a web broswer, navigate to the IP address for the Cluster with the path of `CustomerOrderServicesWeb`, so the full URL should look something this:
```
http://10.0.0.147/CustomerOrderServicesWeb/
```
