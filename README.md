# 1. Introduction

This document describes the points needed to set up Sublima on Red Hat
or Fedora distributions. Still, Sublima can be
run on any Linux distro that supplies the necessary tools, like Ubuntu.
The documentation is currently being  updated to cover RHEL 7.

In short this document covers installation and configuration of
Virtuoso (database), Sublima backend (Virtuoso2Sublima communication)
and Sublima. For more in-depth documentation, see Customization.md.

# 2. Required tools

This section will describe installation and configuration of the tools required to install and configure Virtuoso and Sublima.

## 2.1 Installation and configuration

### 2.1.1 Java

Install with your favorite package tool.

	yum install java-1.8.0-oracle
	
### 2.1.2 Tomcat

Sublima uses Tomcat 5.5 or newer.

    yum install tomcat

Accept all dependencies.

Disable Tomcat's security. Does not seem to apply to tomcat 7. In the file /etc/default/tomcat5.5 set

    TOMCAT_SECURITY=no

in the same file, set file encoding and memory limits

    # Arguments to pass to the Java virtual machine (JVM).
    JAVA_OPTS="${JAVA_OPTS} -Dfile.encoding=UTF-8 -Xmx2048M -Xms2048M"

In the file /etc/tomcat5.5/server.xml locate the Connector element, and set the URI encoding here in an _attribute_, like:

    <Connector port="8080" maxHttpHeaderSize="8192" URIEncoding="UTF-8"

(Note that the other elements may have other values).
Firewall:

	firewall-cmd --add-port=8080/tcp --permanent

#### 2.1.2.1 Running Sublima on port 80

By default, Tomcat runs on port 8080. In order to simplify the url, it
is recommended to use an Apache server as a proxy. This also makes it
possible to serve static pages outside of Sublima, should that be wanted.

Needs Apache installed and running.

In /etc/tomcatx/server.xml, set proxyName and proxyPort:
        
    <Connector port="8080" protocol="HTTP/1.1"
               connectionTimeout="0" maxThreads="150"
               redirectPort="8443" disableUploadTimeout="true"
               maxHttpHeaderSize="8192" URIEncoding="UTF-8"
               proxyName="www.example.com" proxyPort="80"
    />
    

In httpd.conf add proxypass and proxypassreverse from port 80 to 8080:
        
        ProxyRequests Off
        ProxyPreserveHost On
    
        <Proxy *>
            Order deny,allow
            Allow from all
        </Proxy>
		
        ProxyPass               /jn       http://localhost:8080/jn
        ProxyPassReverse        /jn       http://localhost:8080/jn

Firewall and SE Linux:

	/usr/sbin/setsebool -P httpd_can_network_connect 1
	firewall-cmd --add-service http --permanent

Restart apache and then restart tomcat.

### 2.1.3 Memcached

Sublima uses Memcached to cache queries.
As root (use sudo or open a shell), run:
        
    yum install memcached
    
Config:
	
	CACHESIZE="256"
	OPTIONS="-l 127.0.0.1"

### 2.1.4 Git

Sublima uses Git for version control.
As root (use sudo or open a shell), run:
        
    yum install git
    
Accept all dependencies.

### 2.1.5 Maven 3

Sublima uses Maven 3 as build tool.

<http://maven.apache.org/download.html>

# 3. Virtuoso

## 3.1 Installation

Sublima uses [Virtuoso Open-Source Edition](http://www.openlinksw.com/wiki/main/Main) for storing RDF data. It can be downloaded from here: <http://www.openlinksw.com/wiki/main/Main/VOSDownload>
Red Hat enterprise Linux has a package:

	yum install virtuoso-opensource virtuoso-opensource-utils

Open firewall:

	firewall-cmd --add-port=8890/tcp --permanent
	
Setup systemd unit-file in /etc/systemd/system/virtuoso.service:

	[Unit]
	Description=Virtuoso Opensource
	Before=tomcat.service
	After=network.target
	
	[Service]
	User=virtuoso
	Group=virtuoso
	Type=forking
	ExecStart=/usr/bin/virtuoso-t +configfile /var/lib/virtuoso/db/virtuoso.ini +wait
	
	[Install]
	WantedBy=multi-user.target



## 3.2 Configuration

In the file /var/lib/virtuoso/db/virtuoso.ini

First, you might want to load data from different locations in the file system, this is set in DirsAllowed. 
This is optional, and might have security implications.

Then, the number of buffers assigned to Virtuoso should be set. This is set in chunks of 8kB. Thus, 100000 is 0.8 GB RAM. This might be a good starting point:

        
    NumberOfBuffers                 = 100000
    MaxDirtyBuffers                 = 60000
    DirsAllowed                     = /
    

Then, a restart is required:

        
    /etc/init.d/virtuoso-opensource stop
    /etc/init.d/virtuoso-opensource start
    

### 3.2.1 Replace the default password

Virtuoso has a number of default users and passwords, which should be replaced immediately after installation for security reasons.

This can be done by using the Web frontend, point your browser to the installation at port 8890, e.g. <http://localhost:8890/>. Then go to the Conductor and log in with the default user, with username dba and password dba. Then, under System Admin, you'll find User Accounts.

The PROXY, SIMILE and XMLA users can be removed. You don't need to change the SPARQL and nobody users, but it is important to **change the password of dav and dba**

### 3.2.2 Virtuoso Open Source Upgrade Notes

Depending on installation method, the setup file virtuoso.ini might be
overwritten with each upgrade of Virtuoso. Thus you should copy it
before upgrading.

The database file format has previously changed substantially between
major versions of Virtuoso. More information regarding upgrades can be
found at
<http://virtuoso.openlinksw.com/dataspace/dav/wiki/Main/UpgradingToVOS610>.

## 3.3 How to

### 3.3.1 Restart Virtuoso

On the command line run the following command (if not logged in as root, append sudo first):
        
    /etc/init.d/virtuoso-opensource stop
    /etc/init.d/virtuoso-opensource start
    

# 4. Backend

The RDF/XML standard allows for great variation in the serialization of RDF data.
In order to be able to use XSLT for transforming the RDF/XML to HTML, the XML
data must have a predictable structure.

Virtuoso does not have a RDF/XML-ABBREV serialisation of its own, thus for Sublima, we must put Jena in between to create it. This is done in a separate servlet, which creates another endpoint. To get the code and build, do:

        
    git clone git://github.com/sublima/sublima-backend.git
    cd sublima-backend
    
## Virtuoso 6

The Jena endpoint needs to be configured with the URL of the Virtuoso
endpoint. This is done in src/main/webapp/WEB-INF/web.xml. The default
is running Virtuoso on localhost, so usually no change is required:

        
    <param-value>http://127.0.0.1:8890/sparql?</param-value>
    

Then, the servlet can by built:

        
    mvn package
    

This will create a WAR in target/, which can be deployed in the same way as the sublima-WAR, by e.g. copying it:

        
    cp target/backend-1.0-SNAPSHOT.war /var/lib/tomcat5.5/webapps/backend.war
    

# 5. Sublima


## 5.1 Installation


### 5.1.1 Download Sublima with git

If you have not already done so, download the latest release of Sublima:

    git clone git://github.com/sublima/sublima.git
    
This downloads all the source code for sublima and places it in the folder sublima.

### 5.1.2 Build Sublima with Maven to make available necessary tools

Now that Sublima is downloaded it is time to build it using Maven. To do this it is necessary to be online so that Maven can download all dependencies used by Sublima. We do this to make available the tools needed later in the installation process. Such as the administrator password generator.

On the command line, and in the root folder of Sublima, run the following command:

    mvn -Dmaven.test.skip=true package

The first time executed this can take some time depending on how much depencencies Maven downloads. When the build is done you should see the text BUILD SUCCESSFUL.

## 5.2 Configuration

The configuration is made up with the configuration of Sublima and the configuration of Sublima relevant Virtuoso configuration. For more general Virtuoso configuration see the chapter about Virtuoso.

### 5.2.1 Sublima

The configuration of Sublima is done in the properties-file sublima-query.properties. Sublima comes with an example configuration file, sublima-query.properties.default. Copy this and rename it to sublima-query.properties.
This file is located in sublima/blocks/sublima-query/src/main/resources/META-INF/cocoon/properties.

There are some field that must be changed for Sublima to work, while others can be configured if wanted. The optional fields are documented in sublima-query.properties.default.

The following fields must be configured:

The Base URL for this deployment of Sublima. This should be the same as the URL where Sublima is available.  
**sublima.base.url**=<http://www.example.com/sublima/>

The basegraph defines the graph in Virtuoso where all data is stored. It is most common the same as sublima.base.url.  
**sublima.basegraph**=<http://www.example.com/sublima/>

The SPARQL endpoint defines the location of the installed backend. This is used for queries from Sublima to Virtuoso.  
**sublima.sparql.endpoint**=<http://www.example.com:8080/backend/sparql>

The SPARQL Authenticated endpoint defines the location of the Virtuoso SPARQL/Update endpoint. This points to the URL where Virtuoso is installed and available online.  
**sublima.sparul.endpoint**=<http://www.example.com:8890/sparql-auth>

The SPARQL Direct endpoint defines the location of the Virtuoso SPARQL endpoint. This points to the URL where Virtuoso is installed and available online. This is used for queries that don't have to be sent through the backend endpoint.  
**sublima.sparql.directendpoint**=<http://www.example.com:8890/sparql>

Memcached servers define where Memcaced is running, if running at all.  
**sublima.memcached.servers=localhost:11211**

Credentials for Digest Authentication for Virtuoso.  
**sublima.database.url=jdbc:virtuoso://www.example.com:1111**

Remember to change the password\! The default password are available from Virtuoso documentation and should not be used.  
**virtuoso.digest.username=dba**  
**virtuoso.digest.password=dba**

The Cocoon Container encoding is the encoding of the operating system Sublima is installed on.
For Linux/Unix this is normally utf-8. For Windows it is normally iso-8859-1.  
**org.apache.cocoon.containerencoding=utf-8**

Index external tells the system to index a resource's external content (from it's webpage) or not.
Values true\|false.  
**sublima.index.external=true**

Deepsearch when zero hits tells the system to perform a search in the resources external content or not if a regular search returns 0 hits. If sublima.index.external is set to false this should also be set to false.
Values true\|false.  
**sulima.deepsearch.when.zero.hits=true**


### 5.2.2 Create database tables and an administrator user with all rights

Use the following SQL to create the tables in Virtuoso Conductors Interactive SQL:
        
    create table DB.DBA.users ( username VARCHAR(60) NOT NULL, "password" VARCHAR(60) NOT NULL, CONSTRAINT users_pk PRIMARY KEY (username) );
    CREATE TABLE DB.DBA.roleprivilege ( "role" VARCHAR(120) NOT NULL, privilege VARCHAR(120) NOT NULL, CONSTRAINT roleprivilege_pk PRIMARY KEY ("role", privilege) ) ;
    CREATE TABLE DB.DBA.indexstatistics ( type VARCHAR(20) NOT NULL, "date" VARCHAR(40) NOT NULL, CONSTRAINT indexstatistics_pk PRIMARY KEY (type, "date") ) ;
    

Use the following SQL to insert an admin user with all rights in Virtuoso Conductors Interactive SQL. Remember to alter <http://www.example.com/sublima/> to match your base graph, and also replace 815a287366c30b1c8460e04eb59c4cd0d396c33c with the SHA1 sum of your administrator password.

	INSERT INTO DB.DBA.users(username, "password") VALUES('Administrator', '815a287366c30b1c8460e04eb59c4cd0d396c33c');
	INSERT INTO DB.DBA.roleprivilege("role", privilege) VALUES('http://www.example.com/sublima/role/Administrator','topic.edit');
	INSERT INTO DB.DBA.roleprivilege("role", privilege) VALUES('http://www.example.com/sublima/role/Administrator','topic.approve');
	INSERT INTO DB.DBA.roleprivilege("role", privilege) VALUES('http://www.example.com/sublima/role/Administrator','topic.delete');
	INSERT INTO DB.DBA.roleprivilege("role", privilege) VALUES('http://www.example.com/sublima/role/Administrator','topic.theme');
	INSERT INTO DB.DBA.roleprivilege("role", privilege) VALUES('http://www.example.com/sublima/role/Administrator','topic.join');
	INSERT INTO DB.DBA.roleprivilege("role", privilege) VALUES('http://www.example.com/sublima/role/Administrator','relation.edit');
	INSERT INTO DB.DBA.roleprivilege("role", privilege) VALUES('http://www.example.com/sublima/role/Administrator','relation.approve');
	INSERT INTO DB.DBA.roleprivilege("role", privilege) VALUES('http://www.example.com/sublima/role/Administrator','relation.delete');
	INSERT INTO DB.DBA.roleprivilege("role", privilege) VALUES('http://www.example.com/sublima/role/Administrator','resource.edit');
	INSERT INTO DB.DBA.roleprivilege("role", privilege) VALUES('http://www.example.com/sublima/role/Administrator','resource.approve');
	INSERT INTO DB.DBA.roleprivilege("role", privilege) VALUES('http://www.example.com/sublima/role/Administrator','resource.delete');
	INSERT INTO DB.DBA.roleprivilege("role", privilege) VALUES('http://www.example.com/sublima/role/Administrator','user.edit');
	INSERT INTO DB.DBA.roleprivilege("role", privilege) VALUES('http://www.example.com/sublima/role/Administrator','user.approve');
	INSERT INTO DB.DBA.roleprivilege("role", privilege) VALUES('http://www.example.com/sublima/role/Administrator','user.delete');
	INSERT INTO DB.DBA.roleprivilege("role", privilege) VALUES('http://www.example.com/sublima/role/Administrator','role.edit');
	INSERT INTO DB.DBA.roleprivilege("role", privilege) VALUES('http://www.example.com/sublima/role/Administrator','role.approve');
	INSERT INTO DB.DBA.roleprivilege("role", privilege) VALUES('http://www.example.com/sublima/role/Administrator','role.delete');
	INSERT INTO DB.DBA.roleprivilege("role", privilege) VALUES('http://www.example.com/sublima/role/Administrator','publisher.edit');
	INSERT INTO DB.DBA.roleprivilege("role", privilege) VALUES('http://www.example.com/sublima/role/Administrator','publisher.delete');
	INSERT INTO DB.DBA.roleprivilege("role", privilege) VALUES('http://www.example.com/sublima/role/Administrator','database.import');
	INSERT INTO DB.DBA.roleprivilege("role", privilege) VALUES('http://www.example.com/sublima/role/Administrator','database.export');
	INSERT INTO DB.DBA.roleprivilege("role", privilege) VALUES('http://www.example.com/sublima/role/Administrator','resource.status.http://sublima.computas.com/status/godkjent_av_administrator');
	INSERT INTO DB.DBA.roleprivilege("role", privilege) VALUES('http://www.example.com/sublima/role/Administrator','resource.status.http://sublima.computas.com/status/ikke_godkjent_av_administrator');
	INSERT INTO DB.DBA.roleprivilege("role", privilege) VALUES('http://www.example.com/sublima/role/Administrator','resource.status.http://sublima.computas.com/status/inaktiv');
	INSERT INTO DB.DBA.roleprivilege("role", privilege) VALUES('http://www.example.com/sublima/role/Administrator','resource.status.http://sublima.computas.com/status/nytt_forslag');
	INSERT INTO DB.DBA.roleprivilege("role", privilege) VALUES('http://www.example.com/sublima/role/Administrator','resource.status.http://sublima.computas.com/status/til_godkjenning');
	INSERT INTO DB.DBA.roleprivilege("role", privilege) VALUES('http://www.example.com/sublima/role/Administrator','resource.status.http://sublima.computas.com/status/under_behandling');
	INSERT INTO DB.DBA.roleprivilege("role", privilege) VALUES('http://www.example.com/sublima/role/Administrator','topic.status.http://sublima.computas.com/status/godkjent_av_administrator');
	INSERT INTO DB.DBA.roleprivilege("role", privilege) VALUES('http://www.example.com/sublima/role/Administrator','topic.status.http://sublima.computas.com/status/ikke_godkjent_av_administrator');
	INSERT INTO DB.DBA.roleprivilege("role", privilege) VALUES('http://www.example.com/sublima/role/Administrator','topic.status.http://sublima.computas.com/status/inaktiv');
	INSERT INTO DB.DBA.roleprivilege("role", privilege) VALUES('http://www.example.com/sublima/role/Administrator','topic.status.http://sublima.computas.com/status/nytt_forslag');
	INSERT INTO DB.DBA.roleprivilege("role", privilege) VALUES('http://www.example.com/sublima/role/Administrator','topic.status.http://sublima.computas.com/status/til_godkjenning');
	INSERT INTO DB.DBA.roleprivilege("role", privilege) VALUES('http://www.example.com/sublima/role/Administrator','topic.status.http://sublima.computas.com/status/under_behandling');


### 5.2.3 Virtuoso

These are the indexing rules, which should be run from the isql-v command line or Interactive SQL in the web administration console, Conductor.
Again, the graph name is important, this example assumes that sublima.basegraph=<http://www.example.com/graph/>. The last command tells Virtuoso to update its index every 10 minutes. Change the interval as you which.
Then, this should be used:

        
    DB.DBA.RDF_OBJ_FT_RULE_ADD ('http://www.example.com/graph/', 'http://xmlns.computas.com/sublima#literals', 'literals');
    DB.DBA.RDF_OBJ_FT_RULE_ADD ('http://www.example.com/graph/', 'http://xmlns.computas.com/sublima#externalliterals', 'externalliterals');
    DB.DBA.RDF_OBJ_FT_RULE_ADD ('http://www.example.com/graph/', 'http://purl.org/dc/terms/title', 'title');
    DB.DBA.RDF_OBJ_FT_RULE_ADD ('http://www.example.com/graph/', 'http://purl.org/dc/terms/description', 'description');
    DB.DBA.RDF_OBJ_FT_RULE_ADD ('http://www.example.com/graph/', 'http://xmlns.com/foaf/0.1/name', 'pubname');
    DB.DBA.VT_BATCH_UPDATE ('DB.DBA.RDF_OBJ', 'ON', 10);
    DB.DBA.VT_INC_INDEX_DB_DBA_RDF_OBJ ();
    



## 5.3 Deploying

Re-build Sublima using:
        
    mvn -Dmaven.test.skip=true clean package

And deploy using the deployment script:

    ./deploy.sh
    
This copies sublima/sublima-webapp/target/sublima-webapp-1.0-SNAPSHOT.war
to /var/lib/tomcat5/webapps/sublima.war. You can edit the script to replace
sublima.war with your desired application name. It also restarts Tomcat and
Sublima should now be available on your selected URL.

Use deploy.sh -t to deploy a test install, http://www.example.com/test/


## 5.4 How to

### 5.4.1 Login to the administration part of Sublima

Access the administration login at <http://www.example.com/sublima/admin> and login with user Administrator and the password you inserted.

### 5.4.2 Add static pages

Adding static pages to Sublima involves three steps. In this example we'll create a help-page available on the URL <sublima>/portal/help

#### Creating the page for each locale supported

This example creates the page for the norwegian locale
In sublima/blocks/sublima-skin/src/main/resources/COB-INF/transform create help_no.xsl.
As with other XSLT-stylesheets the file can contain both XSLT and HTML. See the code below for a short example that you can use as a template.
        
    <?xml version="1.0" encoding="UTF-8"?>
    <xsl:stylesheet
            xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
            xmlns="http://www.w3.org/1999/xhtml"
            version="1.0">
        <xsl:template name="help_no">
            <h2>Hjelp</h2>
            <p>Hjelpetekst kommer her</p>
        </xsl:template>
    </xsl:stylesheet>
    

#### Telling the static page handler to include your newly created help-page

In sublima/blocks/sublima-skin/src/main/resources/COB-INF/transform/statiskinnhold.xsl add:

        
    <xsl:import href="help_no.xsl"/>
    

Remember to also import help_sv, help_da etc. if you create a help-page for other languages.

Follow the pattern used for the other static pages to add your own:

        
    <!-- Checks if the URL is portal/help -->
            <xsl:if test=". = 'help'">
                <!-- Check the locale and use the correct template -->
                <xsl:choose>
                    <xsl:when test="$interface-language = 'no'">
                        <xsl:call-template name="help_no"/>
                    </xsl:when>
                    <xsl:when test="$interface-language = 'sv'">
                        <xsl:call-template name="help_sv"/>
                    </xsl:when>
                    <xsl:when test="$interface-language = 'da'">
                        <xsl:call-template name="help_da"/>
                    </xsl:when>
                    <xsl:otherwise>
    
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:if>
    

Now what's left is to create a link that takes the user to your static page. This can be done anywhere, but the other links are created in the headers.xsl located in the same folder as your static page.

        
    <a href="{$baseurl}/portal/help{$qloc}">Om portalen</a></div>
    
  
**$baseurl** resolves itself to the URL of your Sublima installation and **$gloc** resolves to the locale selected by the user.

Your static page should now be done. Remember to rebuild Sublima and restart Tomcat if you don't read the files from the file system.


### 5.4.3 Re-index

Every update done in the administration interface should handle updating the index itself, but if you delete all data and upload new, you can use the Database - Index - Index all option to re-index all the data.

### 5.4.4 Export all data for editing in a third party tool

The easiest, fastest and most stable way to export all data is to use the UNIX/Linux command line tool wget. Remember to replace www.example.com in the query with your graph name, and the correct port.

To ensure that Virtuoso returns all the data you should make sure that the ResultSetMaxRows parameter is set high enough. Log in to the Virtuoso Conductor, and go to System Admin - Parameters - SPARQL and set ResultSetMaxRows to ie. 99999999999 before you export the data. Change the value back to its original after the export is done.

        
    wget --header="Accept: application/rdf+xml" http://www.example.com:8890/sparql?query=describe%20%3Fs%20from%20%3Chttp%3A%2F%2Fwww.example.com%2F%3E%20where%20%7B%3Fs%20%3Fp%20%3Fo%7D&format=application/rdf+xml&debug=on
    

The following SPARQL query is executed and can also be executed from Virtuosos SPARQL Query Form (typically <http://www.example.com:8890/sparql>)
        
    DESCRIBE ?s FROM <http://www.example.com/> where {?s ?p ?o}
    

This command performs a DESCRIBE query on the given graph asking for everything contained within that graph. The result is saved in a file in the location the command is executed from as RDF/XML. Note that all changes made on the live data set will be lost when re-importing the exported data. There is no way to just import changed data or to preserve changes made in the live data set.

To import the data back to Virtuoso follow these steps:
1. Log on to Virtuoso web admin (Conductor) and go to the RDF pane, then the Graphs pane.
2. Delete the <http://www.example.com/sublima/> graph
3. On the command line on the server run ISQL-V
4. Run the following command to import a RDF/XML file:
        
    DB.DBA.RDF_LOAD_RDFXML (file_to_string ('/path/to/file.rdf'), 'http://www.example.com/', 'http://www.example.com/');
    
5. Or the following command to import a Turtle file
        
    ttlp (file_to_string_output ('/path/to/file.ttl'), 'http://www.example.com/', 'http://www.example.com/', 0);
    

### 5.4.5 Use SPARQL to add to and delete from resources

This will show some examples on how we can utilize SPARQL to add and delete from resources using the SPARQL web interface in Virtuoso.
Use <http://www.example.com:8890/sparql-auth> to run the SPARQL commands. Usename/password should be the same as for Virtuoso Conductor.

#### Add status code approved to all resources that doesn't have a status code
        
    PREFIX sub: <http://xmlns.computas.com/sublima#>
    PREFIX wdr: <http://www.w3.org/2007/05/powder#>
    INSERT INTO <http://www.example.com/sublima/> {
      ?resource wdr:describedBy <http://sublima.computas.com/status/godkjent_av_administrator> .}
    WHERE {
      ?resource a sub:Resource .
      OPTIONAL {
          ?resource wdr:describedBy ?o
      }
      FILTER(!bound(?o))
    }
    


#### Delete all resources with a given publisher
        
    PREFIX dct: <http://purl.org/dc/terms/>
    PREFIX sub: <http://xmlns.computas.com/sublima#>
    DELETE FROM <http://www.example.com/sublima/> {
      ?resource ?p ?o .
    } WHERE {
      ?resource ?p ?o .
      ?resource a sub:Resource .
      ?resource dct:publisher <http://smil.sys.wserver.no/smil/agent/TryggHansa> .
    }
    

# 6. Data

With Sublima and Virtuoso installed and configured it's time to give Sublima some data to use.

Using the isql-v command line tool from Virtusoso, upload Sublima specific data using the following command. Remember to alter <http://www.example.com/sublima/> to match your base graph.
        
    ttlp (file_to_string_output ('/usr/local/src/sublima/blocks/sublima-app/src/main/resources/rdf-data/information-model.ttl'), 'http://www.example.com/sublima/', 'http://www.example.com/sublima/', 0);
    ttlp (file_to_string_output ('/usr/local/src/sublima/blocks/sublima-app/src/main/resources/rdf-data/sublima-ns.ttl'), 'http://www.example.com/sublima/', 'http://www.example.com/sublima/', 0);
    ttlp (file_to_string_output ('/usr/local/src/sublima/blocks/sublima-app/src/main/resources/rdf-data/geonames-excerpt.ttl'), 'http://www.example.com/sublima/', 'http://www.example.com/sublima/', 0);
    DB.DBA.RDF_LOAD_RDFXML (file_to_string ('/usr/local/src/sublima/blocks/sublima-app/src/main/resources/rdf-data/lingvoj-excerpt.rdf'), 'http://www.example.com/sublima/', 'http://www.example.com/sublima/');
    

If you have a data file for import, use the following command. Remember to alter <http://www.example.com/sublima/> to match your base graph, and do the same in the actual data file.
        
    DB.DBA.RDF_LOAD_RDFXML (file_to_string ('/usr/local/src/sublima/blocks/sublima-app/src/main/resources/rdf-data/kurs-test-data.rdf'), 'http://www.example.com/sublima/', 'http://www.example.com/sublima/');
    

Now you should be ready to login to Sublima using your newly created administrator user and use the Database - Index menu option to start indexing of resources and topics.

# 7. Backup

## Virtuoso database

Follow <http://docs.openlinksw.com/virtuoso/backup.html> and choose whatever backup solution that works best with your existing backup plans. The easieast and most straightforward way to backup the Virtuoso database is to first stop Virtuoso, then backup the /virtuoso/db folder and then start Virtuoso again.
