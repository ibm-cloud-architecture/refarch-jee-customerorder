# Customer Order Services - JavaEE Enterprise Application

### Branches

* [master](https://github.com/ibm-cloud-architecture/refarch-jee-customerorder/tree/master) - READMEs.
* [was70-dev](https://github.com/ibm-cloud-architecture/refarch-jee-customerorder/tree/was70-dev) - Development branch for WebSphere Application Server V7.0 application code. Development Environment: RAD V9.6 + WAS V7.0. Builds either from RAD or using Maven.
* [was70-prod](https://github.com/ibm-cloud-architecture/refarch-jee-customerorder/tree/was70-prod) - Production branch for WebSphere Application Server V7.0 application code. Does not contain any IDE specific file. Builds only using Maven.
* [was70-unit-test](https://github.com/ibm-cloud-architecture/refarch-jee-customerorder/tree/was70-unit-test) - Branch to keep the current effort on implementing some unit test for WebSphere Application Server V7.0 code.
* [was90-dev](https://github.com/ibm-cloud-architecture/refarch-jee-customerorder/tree/was90-dev) - Development branch for WebSphere Application Server V9.0 application code. Development Environment: eclipse MARS 2 + WAS V9.0. Builds either from eclipse or using Maven.
* [was90-prod](https://github.com/ibm-cloud-architecture/refarch-jee-customerorder/tree/was90-prod) - Production branch for WebSphere Application Server V9.0 application code. Does not contain any IDE specific file. Builds only using Maven.

## [WebSphere Application Server Version 7](https://github.com/ibm-cloud-architecture/refarch-jee-customerorder/tree/was70-dev)

### Application Overview

The application is a simple store-front shopping application, built during the early days of the Web 2.0 movement.  As such, it is in major need of upgrades from both the technology and business point of view.  Users interact directly with a browser-based interface and manage their cart to submit orders.  This application is built using the traditional [3-Tier Architecture](http://www.tonymarston.net/php-mysql/3-tier-architecture.html) model, with an HTTP server, an application server, and a supporting database.

![Phase 0 Application Architecture](https://github.com/ibm-cloud-architecture/refarch-jee/raw/master/static/imgs/apparch-pc-phase0-customerorderservices.png)

There are several components of the overall application architecture:
- Starting with the database, the application leverages two SQL-based databases running on [IBM DB2](https://www.ibm.com/analytics/us/en/technology/db2/).
- The application exposes its data model through an [Enterprise JavaBean](https://en.wikipedia.org/wiki/Enterprise_JavaBeans) layer, named **CustomerOrderServices**.  This components leverages the [Java Persistence API](https://en.wikibooks.org/wiki/Java_Persistence/What_is_JPA%3F) to exposed the backend data model to calling services with minimal coding effort.
  - As of the [WebSphere Application Server](http://www-03.ibm.com/software/products/en/appserv-was) Version 7 build, the application is using **EJB 3.0** and **JPA 2.0** versions of the respective capabilities.
- The next tier of the application, named **CustomerOrderServicesWeb**, exposes the necessary business APIs via REST-based web services.  This component leverages the [JAX-RS](https://en.wikipedia.org/wiki/Java_API_for_RESTful_Web_Services) libraries for creating Java-based REST services with minimal coding effort.
  - As of the [WebSphere Application Server](http://www-03.ibm.com/software/products/en/appserv-was) Version 7 build, the application is using **JAX-RS 1.1** version of the respective capability.
- The application's user interface is exposed through the **CustomerOrderServicesWeb** component as well, in the form of a [Dojo Toolkit](#tbd)-based JavaScript application.  Delivering the user interface and business APIs in the same component is one major inhibitor our migration strategy will help to alleviate in the long-term.
- Finally, there is an additional integration testing component, named **CustomerOrderServicesTest** that is built to quickly validate an application's build and deployment to a given application server.  This test component contains both **JPA** and **JAX-RS**-based tests.  

## [WebSphere Application Server Version 9](https://github.com/ibm-cloud-architecture/refarch-jee-customerorder/tree/was90-dev)

### Application Overview

Application architecture, both logical and physical, is the same as the WAS7 version. Application component versions are still the same since we are applying the *lift and shift* pattern which consist of migrating your WebSphere Application Server deployment to the IBM Cloud with the minimum change possible. As a result, EJB, JPA, JAX-RS levels are still the same as in the WebSphere Application Server 7 version.

Detailed code migration efforts are available in the [Phase 1: Modernizing the Existing Application](https://github.com/ibm-cloud-architecture/refarch-jee/blob/master/phases/phase1.md) documentation in the root repository.