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
