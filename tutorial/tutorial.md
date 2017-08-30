# Tutorial - WebSphere on IBM Cloud private

This tutorial aims to drive readers throughout the process of migrating an existing WebSphere Application Server 7 application to run on the new WebSphere Application Server Liberty profile to then containerise it and deploy it to the on premises IBM Cloud private, orchestrated by Kubernetes.

For doing so, we are going to go through the following steps below. Each step will have its instructions on a separate readme file for clarity and simplicity.

### Step 1. Modernise application to run on WebSphere Application Server Liberty profile (OPTIONAL)

In this step, we are going to make the modifications needed both at the application level and the server configuration level to migrate our legacy WebSphere Application Server 7 application to run on the WebSphere Application Server Liberty profile.

Click [here](step1.md) for the instructions.

### Step 2. Build & run the Liberty app locally talking to remote DB2 and LDAP servers

In this step, we are going to build and run the Liberty app locally and connect it to the remote DB2 and LDAP servers simulating what would be a real production scenario.

Click [here](step2.md) for the instructions.

### Step 3. Containerize the Liberty app

In this step, we are going to use Docker technology to containerise our Liberty application so that it can be then deployed to a virtualized infrastructure using a containers orchestrator such as Kubernetes.

Click [here](step3.md) for the instructions.

### Step 4. Write Kubernetes YAMLs, including Deployment and Services stanzas.

In this step, we are going to write the needed configuration files, deployment files, etc for a container orchestrator such as Kubernetes to get our Liberty app appropriately deployed onto our virtulized infrastructure.

Click [here](step4.md) for the instructions.

### Step 5. Deploy the Liberty app to IBM Cloud private

In this final step, we are going to deploy our Liberty app to our IBM Cloud private through the Kubernetes command line interface.

Click [here](step5.md) for the instructions.

------------------
Stretch
-------------------
Extra credits...
