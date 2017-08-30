# Step 2. Build & run the Liberty app locally talking to remote DB2 and LDAP servers

In this step, we are going to build and run the Liberty app locally and connect it to the remote DB2 and LDAP servers simulating what would be a real production scenario.

### Build the Liberty app

TBD: what does a student need to get the ear file build?

- clone github repo
- build using maven

### Run the Liberty app

TBD: what does a student need to do to run the ear file on the local Liberty runtime?

- Configure the liberty server (copy server.xml and server.env from repo)
- copy app to shared/apps folder
- bin folder ---> ./server start <liberty server name>
- test app in web browser
- stope the server
  
  
-----------------------------

**Getting the project repository**

You can clone the repository from its main GitHub repository page and checkout the appropriate branch for this version of the application.

1. `git clone https://github.com/ibm-cloud-architecture/refarch-jee-customerorder.git`
2. `cd refarch-jee-customerorder`
3. `git checkout liberty`
