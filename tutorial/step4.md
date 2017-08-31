# Step 4. Write Kubernetes YAMLs, including Deployment and Services stanzas.

In this step, we are going to write the needed configuration files, deployment files, etc for a container orchestrator such as Kubernetes to get our Liberty app appropriately deployed onto our virtulized infrastructure.

### Prerequisites
* Docker Cli


## Preparation steps

Before we upload images and start deployment we will create a separate user and namespace in kubernetes where the application will be hosted.
Namespacing is a concept in Kubernetes that allows isolation of applications and other resourcs.

### Create user and namespace
1. In your webbroswer login to the the ICp Dashboard on `https://10.0.0.1:8443` as a system administrator, username `admin` password `admin`.
#### Creating a namespace
1. From the navigation menu, select System > Namespaces.
1. Click New Namespace.
1. Enter a namespace name `websphere`
1. Click Add Namespace.
#### Adding a user to a namespace
1. Navigate to the `Users` tab.
1. Click New User.
1. Enter `user1` as the user name, and provide a password and email address.
1. Select Namespace `websphere`
1. Click Add User

### Push image to ICp Image Repository
ICp provides a docker compatible image repository out of the box, which is available on the server `master.cfc` port `8500`

#### Re-Tag image
To be able to push the image we build in the previous step into the ICp Image Repository, we'll need to add an additional tag to the image we built.

From the command line, enter the following command
```
$ docker tag customer-order-services:liberty master.cfc:8500/websphere/customer-order-services:liberty
```
This extra information in the tag tells docker that this image belongs to the repository `websphere` on the `master.cfc:8500` server, which maps to the namespace we created above.

#### Push image
To make the image available to use in Kubernetes enter the following commands
1. `$ docker login login master.cfc:8500` providing `user1` as the user and the password you created above
1. `$ docker push master.cfc:8500/websphere/customer-order-services:liberty`


You will now be able to see the image in the ICp Dashboard under *Infrastructure -> Images*

### Generate deployment.yaml
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

You can see there are two parts in this file, separated by `---`. The three dashes is a yaml construct that allows us to put the content of multiple files in a single file.

Above the dashes is the Service, indicated by `kind: Service`. Here we describe how we like the application to be exposed. In our case we choose to use ClusterIP, which means the application will receive an IP address from the 10.1.0.0/16 IP address range

The next part is the deployment part, indicated by `kind: Deployment`. Here we describe what we want the target state of the application to be.
In our example instruct a single container to be named `customerorderservices` and created from the image we pushed to our image repository

The envFrom section tells kubernetes to populate the containers environment variables from a ConfigMap which we will create in Step 5.
These variables holds deployment specific information, such as database host,port,user,password. This enables us to reuse the same image and deployment manifests in multiple deployment environments such as pre-prod and prod at the same time.
