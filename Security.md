# Customer Order Services application security

Any application security mechanism is always a shared effort between the application itself and the web server that hosts and makes this application available to users. The application must implement security constraints that the web server should handle and provide. Data is the most frequent resource to secure and specially when this data is confidential or private. However, we do not only need to protect how the data is accessed and handled by the applications but also how it is serviced or made available to users or the public in general.

In our Customer Order Services application, we are storing and using customers private data which we are making available to them through web services. As a result, we must implement authentication and authorisation to make sure a customer's private data is not only accessed only by him and served only to him but also this information is provided and communicated in a secure manner.

## Application level

At the application level, we must secure Customer Order Services' web services which interact with customer specific and confidential information. We then need users to authenticate themselves and get authorised to use certain web services and data.

You protect web resources by specifying a security constraint. A security constraint determines who is authorized to access a web resource collection, which is a list of URL patterns and HTTP methods that describe a set of resources to be protected.

web.xml:
![Security 1](https://github.com/ibm-cloud-architecture/refarch-jee/raw/master/static/imgs/Security/Security1.png)


We can see in the _web.xml_ file that the **SecureShopper** role has been specified as the authorisation constraint to get access to any customer resource at the web services level. Then, we need to define same role and map it to particular groups at the application level. This is done in the application and application binding xml files:

application.xml:
![Security 2](https://github.com/ibm-cloud-architecture/refarch-jee/raw/master/static/imgs/Security/Security2.png)

ibm-application-bnd.xml:
![Security 3](https://github.com/ibm-cloud-architecture/refarch-jee/raw/master/static/imgs/Security/Security3.png)

Now that we have secured our web services so that only those with SecureShopper authorization role can access them, which in other words are any member of the SecureShopper group as per the application binding file, we need to address how users authenticate themselves.

We have specified, in our _web.xml_ file for any web resource related to customers data, basic authentication. With basic authentication, the following things occur:

1. A client requests access to a protected resource.
2. The web server returns a dialog box that requests the user name and password.
3. The client submits the user name and password to the server.
4. The server validates the credentials and, if successful, returns the requested resource.

HTTP basic authentication is not particularly secure. Basic authentication sends user names and passwords over the Internet as text that is uu-encoded (Unix-to-Unix encoded) but not encrypted. This form of authentication, which uses Base64 encoding, can expose your user names and passwords unless all connections are over SSL. Therefore, we must ensure the communication and data transmision happens on a secure manner.

A user data constraint contains the <transport-guarantee> element. A user data constraint can be used to require that a protected transport layer connection such as HTTPS (HTTP over SSL) be used for all constrained URL patterns and HTTP methods specified in the security constraint. The choices for transport guarantee include CONFIDENTIAL, INTEGRAL, or NONE. If you specify CONFIDENTIAL or INTEGRAL as a security constraint, it generally means that the use of SSL is required, and that type of security constraint applies to all requests that match the URL patterns in the web resource collection and not just to the login dialog box.

![Security 10](https://github.com/ibm-cloud-architecture/refarch-jee/raw/master/static/imgs/Security/Security10.png)

The returned resource for any customer web service is a **Session Bean**:

![Security 4](https://github.com/ibm-cloud-architecture/refarch-jee/raw/master/static/imgs/Security/Security4.png)
![Security 5](https://github.com/ibm-cloud-architecture/refarch-jee/raw/master/static/imgs/Security/Security5.png)

A session bean is an EJB 3.1, EJB 3.0 or EJB 2.1 enterprise bean component created by a client for the duration of a single client/server session. A session bean encapsulates business logic that can be invoked programmatically by a client over local, remote, or web service client views. To access an application that is deployed on the server, the client invokes the session bean’s methods. The session bean performs work for its client, shielding it from complexity by executing business tasks inside the server.

A stateless session bean does not maintain a conversational state for the client. When a client invokes the method of a stateless bean, the bean’s instance variables may contain a state, but only for the duration of the invocation. When the method is finished, the state is no longer retained. Except during method invocation, all instances of a stateless bean are equivalent, allowing the EJB container to assign an instance to any client.

These stateless session beans will make use of **Entity Beans** for executing that business logic which involves interacting with persistent storage. Therefore, an Entity Bean represents a business entity object that exists in persistent storage. In order to interact with that persitent storage, Entity Beans must have a data source defined in the _persistence.xml_ file for the EJB project:

![Security 6](https://github.com/ibm-cloud-architecture/refarch-jee/raw/master/static/imgs/Security/Security6.png)

## Web Server level

As we have already mentioned, the web server should provide the tools and mechanisms to meet application's security requirements. In our case, we need WebSphere Application Server to provide the Customer Order Services application with mechanisms to, at least:

1. [Access application's data stored in the database](#enterprise-information-system-integration).
2. [Authenticate and Authorise users](#application-security).
3. [Secure communications](#communications).

### Enterprise Information System integration

WebSphere Application Server can provide access to data stored in Enterprise Information Systems (EIS) to its enterprise applications by defining Java Database Connectivity (JDBC) data sources. Any JDBC data source needs:

* A JDBC provider, which encapsulates the specific JDBC driver implementation class for access to the specific vendor database of your environment,
* The appropriate authentication and authorisation data<sup>\*</sup> to connect to the backend or resource and
* The data source properties (in our case, the database connection properties)

![Security 7](https://github.com/ibm-cloud-architecture/refarch-jee/raw/master/static/imgs/Security/Security7.png)

(\*) _In WebSphere Application Server, Java Authentication and Authorization Service (JAAS) and Java 2 Connector (J2C) authentication aliases can be configured to hold the user ID and password that are used to connect to a backend resource. The authentication alias is then specified on the data source or connection factory in order to authenticate the user when establishing a connection._

![Security 8](https://github.com/ibm-cloud-architecture/refarch-jee/raw/master/static/imgs/Security/Security8.png)

`TBD:`

`Protect application server to database link:` https://www.ibm.com/developerworks/websphere/techjournal/1210_lansche/1210_lansche.html#step28

### Application security

WebSphere Application Server can enable security for the applications in your environment. This type of security provides application isolation and requirements for authenticating application users which is the other security requirement our web server must meet.

The J2EE server’s authentication service includes and interacts with the following components:

* Realm: A collection of users and groups that are controlled by the same authentication policy.
* User: An individual (or application program) identity that has been defined in the Application Server. Users can be associated with a group.
* Group: A set of authenticated users, classified by common traits, defined in the Application Server.
* Role: An abstract name for the permission to access a particular set of resources in an application. A role can be compared to a key that can open a lock. Many people might have a copy of the key. The lock doesn’t care who you are, only that you have the right key.

These can be defined in several ways, being the easiest a federated repository in an internal file repository where users and groups are directly managed from the _Users and Groups_ section within the WAS admin console while the most common an standalone LDAP registry.

`TBD`

`Encrypt WebSphere Application Server to LDAP link:` https://www.ibm.com/developerworks/websphere/techjournal/1210_lansche/1210_lansche.html#step18


WebSphere Application Server encrypts authentication information so that the application server can send the data from one server to another in a secure manner. The encryption of authentication information that is exchanged between servers involves the Lightweight Third-Party Authentication (LTPA) mechanism. When accessing web servers that use the LTPA technology it is possible for a web user to re-use their login across physical servers. An IBM WebSphere server that is configured to use the LTPA authentication will challenge the web user for a name and password. When the user has been authenticated, their browser will have received a session cookie - a cookie that is only available for one browsing session. This cookie contains the LTPA token. If the user – after having received the LTPA token – accesses a server that is a member of the same authentication realm as the first server, and if the browsing session has not been terminated (the browser was not closed down), then the user is automatically authenticated and will not be challenged for a name and password. Such an environment is also called a Single-Sign-On (SSO) environment.

![Security 9](https://github.com/ibm-cloud-architecture/refarch-jee/raw/master/static/imgs/Security/Security9.png)

However, if an intruder were to capture one of your cookies, they could potentially use the cookie to act as you. Since network traffic is often traveling over untrusted networks (consider your favorite WiFi hotspot), where capturing packets is quite easy, important Web traffic should be encrypted using SSL. This includes important cookies. Clearly, if SSL is used for all requests, the cookies are protected. However, many applications (perhaps accidentally) make some requests over HTTP without SSL, potentially exposing cookies. Fortunately, the HTTP specification makes it possible to tell the browser to only send cookies over SSL.

In the case of WebSphere Application Server, the most important cookie is the LTPA cookie, and therefore it should be configured to be sent only over SSL.

![Security 11](https://github.com/ibm-cloud-architecture/refarch-jee/raw/master/static/imgs/Security/Security11.png)

### Communications

As we have already said, it is important to secure all type of communications among your different middleware components. We have already seen how to secure the WebSphere Application Server to LDAP and DB2 links by using SSL. Now, we want to secure the communication happening from the web server to the application server.

Even if you have chosen not to authenticate the link from the Web server to the Web container, you might want to consider encrypting it. The Web server plug-in transmits information from the Web server to the Web container over HTTP. If the request arrived at the Web server using HTTPS, the plug-in will forward the request on using HTTPS by default. If the request arrived over HTTP, HTTP will be used by the plug-in. These defaults are appropriate for most environments. There is, however, one possible exception.

In some environments, sensitive information is added to the request after it has arrived on your network. For example, some authenticating proxy servers (such as WebSEAL) augment requests with password information. Custom code in the Web server might do something similar. If that’s the case, you should take extra steps to protect the traffic from the Web server to the Web container. To force the use of HTTPS for all traffic from the plug-in, simply disable the HTTP transport from the Web container on every application server and then regenerate and deploy the plug-in. You must disable both the WCInboundDefault and the HttpQueueInboundDefault transport chains. Now, the plug-in can only use HTTPS and so it will use it for all traffic regardless of how the traffic arrived at the Web container.

![Security 12](https://github.com/ibm-cloud-architecture/refarch-jee/raw/master/static/imgs/Security/Security12.png)

`TBD`

`WAS admin console access using only https + SSL certificates`
