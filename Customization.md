# Configuration of portals 

## 1. About this document 
This document describes how each portal can be configured through property files, XLSTs and CSSes. The document assumes knowledge about XSLTs and CSSs. No knowledge about Java is required. 

Note that upload of ontologies and the resources of the portal is not covered in this document, but can be found under <Setup for Debian and Ubuntu> and <Setup for Mac OS X>. 

## 2. Base configuration and configuration files

In principle there are two things that needs to be done before you man configure the portals individually.

* Customize search (Edit the sublima configuration file)
* Customize user interface (Edit the cocoon configuration file)

The first related to the properties of sublima as a search system, the second to presentation layer and design of the portal.



### 2.1 Edit Sublima configuration file to enable customized search 

The configuration file for Sublima search engine is located here
        
    $SUBLIMA_HOME/blocks/sublima-query/src/main/resources/META-INF/cocoon/properties/sublima-query.properties
    
Note that $SUBLIMA_HOME referes to where you checked out your Subversion repository.


The file contains options for 

* Base URL (indicates where the URL of the application during runtime)
* Default operator for search with several words (AND operation chosen as default)
* Options regarding indexing (e.g. indexing of external resources/deep-search at startup)
* URL checking (if URL check is to be run at startup)
* Search fields indicating which fields are to be indexed for keyword search.

You do not need to change the default configuration of the search engine under normal circumstances. However, the Base url would normally need to be changed as described under setup documentation.

#### Base URL

The base URL represents your application running on your web server. This has to be set since the application uses RESTful nice URLs that will resolves to a SPARQL DESCRIBE in the back-end.

e.g.

http://mywebserver.mydomain.com/myapp/topic/topic-102 will resovle to a SPARQL query 

DESCRIBE <http://mywebserver.mydomain.com/myapp/topic/topic-102>

That will return a full record of resources with this topic.


The base URL needs to be set in the sublima configuration file 

        
    # The Base URL for this deployment of Sublima
    sublima.base.url=http://localhost:8180/sublima-webapp-1.0-SNAPSHOT/
    #sublima.base.url=http://rabbit.computas.int:8180/sublima-webapp-1.0-SNAPSHOT/
    

as well as in the imported RDF file.

e.g. for SMIL, in Turtle syntax:

        
    @base <http://localhost:8180/sublima-webapp-1.0-SNAPSHOT/> .
     

and in RDF/XML syntax 

        
    <rdf:RDF xml:base="http://localhost:8180/sublima-webapp-1.0-SNAPSHOT/"
    
    ...
    
    >
    

#### Default operator for seach

In the sublima configuration file $SUBLIMA_HOME/blocks/sublima-query/src/main/resources/META-INF/cocoon/properties/sublima-query.properties  you will find options regarding default operator for search. 

The default operator for search is set to AND. That means that in a free-text query with more than one word, all words in a query will be required to get a match. You may change this option to OR, which will mean that only one of the words in a free text query will be required to get a match.

        
    # BOOLEAN OPERATOR FOR SEARCH --> and/or
    sublima.default.boolean.operator=AND
    

#### Indexing

Several options are available regarding free-text indexing.

        
    # INDEX INTERNAL URLS ON STARTUP --> false/true
    sublima.index.internal.onstartup=true
    sublima.index.external.onstartup=false
    #
    # DIRECTORY TO STORE INDEX FILES
    sublima.index.type=file
    sublima.index.directory=/tmp/june
    
    

The first two options relates to indexing during startup. The last two options concerns where these indexes are stored. Please do not change the option to store the index in a file as that will break the external indexing cron job.  


The indexing should also run in as an external cron job. This is to avoid indexing to affect the response time in the web interface. To run the index as a cron job create a index.sh (or similar file) containing the following:

        
    export SUBLIMA_JARS=/usr/local/apache-tomcat-5.5.16/webapps/sublima-webapp-1.0-SNAPSHOT/WEB-INF/lib/ 
    export CLASSPATH=$CLASSPATH:$SUBLIMA_JARS/sublima-app-1.0-SNAPSHOT.jar 
    export CLASSPATH=$CLASSPATH:$SUBLIMA_JARS/sublima-query-1.0-SNAPSHOT.jar 
    export CLASSPATH=$CLASSPATH:$SUBLIMA_JARS/arq-290508-SNAPSHOT.jar 
    export CLASSPATH=$CLASSPATH:$SUBLIMA_JARS/postgresql-8.2-504.jdbc3.jar 
    export CLASSPATH=$CLASSPATH:$SUBLIMA_JARS/jena-290508-SNAPSHOT.jar 
    export CLASSPATH=$CLASSPATH:$SUBLIMA_JARS/commons-logging-1.1.1.jar 
    export CLASSPATH=$CLASSPATH:$SUBLIMA_JARS/log4j-1.2.14.jar 
    export CLASSPATH=$CLASSPATH:$SUBLIMA_JARS/xercesImpl-2.8.1.jar 
    export CLASSPATH=$CLASSPATH:$SUBLIMA_JARS/iri-290508-SNAPSHOT.jar 
    export CLASSPATH=$CLASSPATH:$SUBLIMA_JARS/icu4j-3.4.4.jar 
    export CLASSPATH=$CLASSPATH:$SUBLIMA_JARS/concurrent-290508-SNAPSHOT.jar 
    export CLASSPATH=$CLASSPATH:$SUBLIMA_JARS/commons-io-1.3.1.jar 
    export CLASSPATH=$CLASSPATH:$SUBLIMA_JARS/lucene-core-2.2.0.jar 
    export CLASSPATH=$CLASSPATH:$SUBLIMA_JARS/nekohtml-1.9.7.jar 
    java -cp $CLASSPATH com.computas.sublima.app.jobs.IndexJob 
    

#### URL Checking

URL checking involves checking if the URLs are reachable. The URL checking updates the status of the resources (links), which creates list for the administrator users. URL checking can be started in various ways:
* performed during startup.
* performed manually by the librarian through the admin web interface
* performed manually by the librarian or system adm from the command line
* set up as an automatic cron job.

The first option can be set in the sublima configuration file $SUBLIMA_HOME/blocks/sublima-query/src/main/resources/META-INF/cocoon/properties/sublima-query.properties 
 

        
    # VALIDATE RESOURCE URLS ON STARTUP --> false/true
    sublima.checkurl.onstartup=false 
    


To start URL checking manually (or set up as a cron job), from the command line write

        
    java com.computas.sublima.app.jobs.LinkcheckJob
      

Remember to set the <correct classpath>


To be concrete you can create a .sh file with the following contents to run the url check (remember to edit the first line to match the location of sublima on your file system.

        
    export SUBLIMA_JARS=/usr/local/apache-tomcat-5.5.16/webapps/sublima-webapp-1.0-SNAPSHOT/WEB-INF/lib/
    export CLASSPATH=$CLASSPATH:$SUBLIMA_JARS/sublima-app-1.0-SNAPSHOT.jar
    export CLASSPATH=$CLASSPATH:$SUBLIMA_JARS/sublima-query-1.0-SNAPSHOT.jar
    export CLASSPATH=$CLASSPATH:$SUBLIMA_JARS/arq-290508-SNAPSHOT.jar
    export CLASSPATH=$CLASSPATH:$SUBLIMA_JARS/postgresql-8.2-504.jdbc3.jar
    export CLASSPATH=$CLASSPATH:$SUBLIMA_JARS/jena-290508-SNAPSHOT.jar
    export CLASSPATH=$CLASSPATH:$SUBLIMA_JARS/commons-logging-1.1.1.jar
    export CLASSPATH=$CLASSPATH:$SUBLIMA_JARS/log4j-1.2.14.jar
    export CLASSPATH=$CLASSPATH:$SUBLIMA_JARS/xercesImpl-2.8.1.jar
    export CLASSPATH=$CLASSPATH:$SUBLIMA_JARS/iri-290508-SNAPSHOT.jar
    export CLASSPATH=$CLASSPATH:$SUBLIMA_JARS/icu4j-3.4.4.jar
    export CLASSPATH=$CLASSPATH:$SUBLIMA_JARS/concurrent-290508-SNAPSHOT.jar
    export CLASSPATH=$CLASSPATH:$SUBLIMA_JARS/commons-io-1.3.1.jar
    export CLASSPATH=$CLASSPATH:$SUBLIMA_JARS/lucene-core-2.2.0.jar
    export CLASSPATH=$CLASSPATH:$SUBLIMA_JARS/nekohtml-1.9.7.jar
    java -cp $CLASSPATH com.computas.sublima.app.jobs.LinkcheckJob
    

Depending on the number of resources the URL check may take hours.

#### Search fields

The "Search fileds" configuration allow you to configure which fields should be accessed during search.

It defines which fields of the resource that should be searchable. The fields must be given with their prefix and separated with semicolon. Ie. sublima.searchfields=dct:title;dct:subject;dct:publisher that states that the title, subjects and publisher should be searchable


        
    # SEARCH FIELDS
    # Defines which fields of the resource that should be searchable.
    # The fields must be given with their prefix and separated with semicolon. Ie.
    # sublima.searchfields=dct:title;dct:subject;dct:publisher
    # that states that the title, subjects and publisher should be searchable
    # See resourceform.xsl for reference to which fields each resource contains
    sublima.searchfields=dct:title;dct:description;dct:publisher/foaf:name;dct:subject/skos:prefLabel;dct:subject/skos:altLabel;dct:subject/skos:hiddenLabel
    sublima.prefixes=dct: <http://purl.org/dc/terms/>;foaf: <http://xmlns.com/foaf/0.1/>;sub: <http://xmlns.computas.com/sublima#>;skos: <http://www.w3.org/2004/02/skos/core#>
    

Note that you also need to specify the sublima.prefixes which contains the full URI for the vocabulary. 



### 2.2 Edit the cocoon configuration file to set up to enable customized user interfaces

The user interface of sublima is in a module (or "block") called /sublima-skin/.
All XSLTs and CSSes that control the user interface are in this block. Using the default configuration of Sublima, this block (and hence the XSLTs and CSSes) are packaged in a .jar file. This .jar file is then as all other modules/blocks deployed on the Tomcat application server together with the compiled program code.

To be able to more easy make adjustments of the portals we need to be able to work on XSLTs and CSSes as files. In practice this means that we must be able to refer to them outside the .jar file. This can be set up in the cocoon configuration file.

We can in principle put the XLSTs and CSSes wherever we want. However, it is required that we define where they are located before we deploy the application on Tomcat. The configuration file is located at the following place:
        
    $SUBLIMA_HOME/sublima-skin/src/main/resources/META-INF/cocoon/spring/servlet-service.xml
    
The contents of this file is
        
    <?xml version="1.0" encoding="UTF-8"?>
    <beans xmlns="http://www.springframework.org/schema/beans"
	   xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	   xmlns:servlet="http://cocoon.apache.org/schema/servlet"
	   xsi:schemaLocation="http://www.springframework.org/schema/beans http://www.springframework.org/schema/beans/spring-beans-2.0.xsd
			       http://cocoon.apache.org/schema/servlet http://cocoon.apache.org/schema/servlet/cocoon-servlet-1.0.xsd">

      <bean id="com.computas.sublima.sublima-skin.service" class="org.apache.cocoon.sitemap.SitemapServlet">

	<!--
	<servlet:context mount-path="/sublima-skin" context-path="blockcontext:/sublima-skin/" /> 
	-->
	<servlet:context mount-path="/sublima-skin" 
			 context-path="file:///usr/local/src/sublima/blocks/sublima-skin/src/main/resources/COB-INF/"
      </bean>

    </beans>

In the code above you can see the location of the sublima-skin block is changed to a explicit path on the disk, <file:///usr/local/src/sublima/blocks/sublima-skin/src/main/resources/COB-INF/>. The statement above (commented out) indicated what was in this file originally.

Making this change, we now have all user interface elements in a separate catalog
        
    $SUBLIMA_HOME/sublima-skin/src/main/resources/COB-INF/
    
(I've chosen to use the same catalog as I checked out the code from Subversion, be however careful here so that you don't check in code that only are meant for your portal. On the other hand, any local changes to the XSLTs and CSSes will be overwritten when checking out a new version of Sublima. *So be sure to save copies of the updated files at another location*).

Before the changes are taken into effect we need to rebuild the application, and deploy and restart Tomcat then all XSLTs and CSSes will be taken from this catalog.

## 3. Understanding and configuring XSLT

The XSLTs converts data into HTML (and RSS). The system contains a series of XLSTs in hierarchy. All XSLTs can be found in the catalog $SUBLIMA_HOME/blocks/sublima-skin/src/main/resources/COB-INF/transform/. The main XSLT for XHTML styling (that is the web interface) is the file alt-styling.xsl.

This XSLT imports other XSLTs
        
      <xsl:import href="rdfxml2xhtml-deflist.xsl"/>
      <xsl:import href="rdfxml2xhtml-facets.xsl"/>
      <xsl:import href="rdfxml2xhtml-table.xsl"/>
      <xsl:import href="rdfxml-nav-templates.xsl"/>
      <xsl:import href="browse.xsl"/> 
      <xsl:import href="headers.xsl"/>
      <xsl:import href="tipsform.xsl"/>
      <xsl:import href="loginform.xsl"/>
      <xsl:import href="a-z.xsl"/>
      <xsl:import href="set-lang.xsl"/>
      <xsl:import href="advancedsearch.xsl"/>
    


Each file contains a header describing the role of the file. In general each file has a role of describing a widget in the user interface, e.g. 


* rdfxml2xhtml-facets.xsl describes the transformation of result-data to facets (in XHTML)
* rdfxml2xhtml-table.xsl describes the transformation of result-data to a list of results (in XHTML) 
* loginform.xsl describes the transformation of the login widget 

etc.

### 3.1 The processing of the XHTML templates

The above only describes the distribution of the templates. How each template is called is a matter of studying the template structure of the main XSLT, i.e. alt-styling.xsl. And within this the template matching the root, i.e. <xsl:template match="/">. This is where each page starts.

The dependencies of this file shows that the root template it is (potentially) calling (or matching) various templates. Note that not all templates have names, but are called using xsl:apply-templates with a matching select and potentially mode attribute.

- "head" in _headers.xsl_ producing metadata in the XHTML <head> element
- "headers" in _headers.xsl_ producing the top of the page including logo etc.
- login \<mode\> in _loginform.xsl_ giving the login form if the admin user is not authenticated.
- a-z \<mode\> in _a-z.xsl_ producing the a-z widget
- facets \<mode\> in _rdfxml2xhtml-facets.xsl_ producing the facets widget
- advancedsearch \<mode\> in _advancedsearch.xsl_ producing the advanced search form widget 
- resource \<mode\> _rdfxml2xhtml-table.xsl_ producing the details for each resource widget
- browse \<mode\> in _browse.xsl_ producing the links
- results \<mode\> in _rdfxml2xhtml-deflist.xsl producing the list of the result set widget.
- a template matching concepts used for navigation in rdfxml-nav-templates.xsl to produce a navigation widget.
- the free-text search widget is included in the root template of the _alt-styling.xsl_.

Similar structure exists for the administration pages.

In addition it contains logic on when to include the various widgets, i.e. creating pages. This is based on the name (or c:page/c:modes) of requests

The c:modes are
- search-result (the user is making a search)
- resource (the user is looking up metdadata for a particular resource)
- browse (the user is browsing the topic hierarchy)
- topic (the user is looking up a particular resource)
 

### 3.2 Changing fields to be shown

All fields that are relevant to any modes (c:modes) can be visualized in the XHTML from XSLTs. E.g. to include the committer in a result-view (see the template $SUBLIMA_HOME/blocks/sublima-skin/src/main/resources/COB-INF/transform/rdfxml2xhtml-deflist.xsl and rdfxml-res-templates.xsl) one has only to understand the structure of the datamodel, and add the field in

        
    ---snip---
    	<dd>
    	  <div style="font-size:small"><i18n:text key="search.result.publishedby">Publisert av</i18n:text><xsl:text>: </xsl:text>
    	    <xsl:apply-templates select="dct:publisher"/>
    	    <xsl:text> </xsl:text>
    	    <xsl:apply-templates select="./dct:dateAccepted"/>
                <xsl:apply-templates select="./dct:committer/">  <!-- added -->
    	  </div>
    	  <xsl:apply-templates select="./dct:description"/>
    	</dd>
    ---snip---
    


## 4. Configuring CSS

The CSS files are located in $SUBLIMA_HOME/blocks/sublima-skin/src/main/resources/COB-INF/resources/styles/

### 4.1 The main stylesheet

The main CSS is called alt-css.css and contains styling for the overall application.

The CSS refers directly to generic styling of tags (e.g. a, h1, h2, h3, p, img, body etc.) as well based on tags identifiers (e.g. #header and #footer) and classes (.facet, resources, .navigation etc.).

The CSS stylesheet documents the function of each element.


### 4.2 The autocompletion stylesheets

There is separate stylesheets for autocompletion. These third party stylesheet are located in the same folder and are called my-css.css,  jquery.autocomplete.css, and thickbox.css




## 5. Adding new fields

Sublima has a great deal of flexibility when it comes to adding new metadata to the resources. The following steps needs to be done to add a new field to the resources:

* describing the new field in the schemas
* optionally load a controlled list of values (if the new field contains list of choices)
* changing the administrative forms to accept this new field
* changing the end-user interface to show the field
* optionally change the configuration to accept searches on this field
* optionally add it as a separate search field in advanced search


When all these tasks has been covered you will have to restart the application and the changes should show up.


### 5.1 Describing a new field in the schemas

The schemas in sublima are divided into two separate files. information-model.ttl and sublima-ns.ttl, these files are located in $SUBLIMA_HOME/blocks/sublima-app/src/main/resources/rdf-data/

These two schemas are in Turtle syntax, be sure to make a copy if you are changing them. Generally you could add the new property to any of them, however, we are here explaining changing the information-model file.


The code below shows some of the contents of the file.

        
    # The information model, describing the relationship between the
    # vocabularies that we use. 
    
    # Issues addressed with this file:
    #  * https://jira.computas.no/browse/OKE-49
    
    # As of 2008-01-14, the DCMI took upon itself to define the ranges and
    # domains of the properties, which simplifies the model somewhat.
    
    
    @prefix rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#> .
    @prefix rdfs: <http://www.w3.org/2000/01/rdf-schema#> .
    @prefix owl: <http://www.w3.org/2002/07/owl#> .
    @prefix foaf: <http://xmlns.com/foaf/0.1/> .
    @prefix lingvoj: <http://www.lingvoj.org/ontology#> .
    @prefix dcmitype: <http://purl.org/dc/dcmitype/> .
    @prefix dct: <http://purl.org/dc/terms/> .
    @prefix sub: <http://xmlns.computas.com/sublima#> . 
    @prefix wdr: <http://www.w3.org/2007/05/powder#> .
    @prefix sioc: <http://rdfs.org/sioc/ns#> .
    @prefix xsd: <http://www.w3.org/2001/XMLSchema#> .
    @prefix skos: <http://www.w3.org/2004/02/skos/core#> .  
    
    ######################################################
    # RESOURCES CLASS
    ######################################################
    
    # see also sub:
    # sub:Resource a owl:Class .
    
    #
    dct:subject             a               owl:ObjectProperty ;
                            rdfs:domain     sub:Resource ;
                            rdfs:range      skos:Concept .  
                
            
    #       
    dct:title               rdfs:range      rdfs:Literal ;          
                            a               owl:AnnotationProperty ;
                            rdfs:domain     sub:Resource .
    
    
    


To add a new property here you have to add what we call statements. Let's say that we want to add a property location. Basically it means that you have to:

- identify the new property (say "sub:location" - all new attributes needs to be prefixed with "sub:")
- say what it is (a owl:AnnotationProperty)
- give it a name ("lokasjon"@no) in norwegian
- and say something about it's use (that it can be used for the entity sub:Resource, and contains rdfs:Literal-s)

The example below shows how to add a new property "Location" 

        
    # adding a location attribute to resources, that can hold
    # a string with the name of the location.
    sub:location           a            owl:AnnotationProperty ;
                           rdfs:label   "lokasjon"@no ;
                           rdfs:domain  sub:Resource ;
                           rdfs:range   rdfs:Literal .  
    
    


This file then needs to be uploaded again to sublima.


### 5.2 Load a controlled list of values

Note that this operation is only relevant if you have a list of RDF data that contains the set of allowed values for an attribute.

Lets assume that you have a simple list of locations (below shown in Turtle syntax)

        
    
    @prefix my: <http://my.domain.com/my/>
    @prefix rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#> .
    @prefix rdfs: <http://www.w3.org/2000/01/rdf-schema#> .
    @prefix owl: <http://www.w3.org/2002/07/owl#> .
    
    my:Location a owl:Class .
    
    my:Norge a my:Location ;  
            rdfs:label "Norge"@no .
      
    my:Utlandet a my:Location ;
            rdfs:label "Utlandet"@no .
    
    

This file contains now a Class of Genders, with two instances Male and Female and labels in Norwegian.

All you now need to do is to add this using the admin user interface.

Then follow the steps further, using the RDF-Path "sub:location/rdfs:label" rather than just "sub:location".  


### 5.3 Changing the administrative forms to accept a new field

To be able to add values for the new fields you need to add the field to the resource administration form. This is an XSLT file located at $SUBLIMA_HOME/blocks/sublima-skin/src/main/resources/COB-INF/transform/resourceform.xsl


When you open this XSLT you will find one template. Generally what you need to do is to add a new row in the template at the appropriate place. In the case of adding a location attribute the content to be added is shown below.


        
            <tr>
              <td>
                <label for="sub:location"><i18n:text key="location">Location</i18n:text></label>
              </td>
              <td>
                <input id="dct:title" type="text" name="sub:location" size="40"
                       value="{./c:resource/rdf:RDF/sub:Resource/sub:location}"/>
              </td>
            </tr>
    

#### Internationalization of labels

Note here that we now also have a internationalization key called "location". This needs to be filled in in the i18n files found in $SUBLIMA_HOME/blocks/sublima-skin/src/main/resources/COB-INF/translations/messages_no.xml and similar.

Editing this file is simply adding a statement

        
    <message key="location">Lokasjon</message>
    

### 5.4 Changing the end-user interface to show the field

The user interface for the resultset is found in $SUBLIMA_HOME/blocks/sublima-skin/src/main/resources/COB-INF/transform/rdfxml2xhtml-deflist.xsl  and 
$SUBLIMA_HOME/blocks/sublima-skin/src/main/resources/COB-INF/transform/rdfxml-res-templates.xsl 

The first XSLT contains one template and reference templates in the second. A version of the first is shown below.

        
    <xsl:template match="rdf:RDF" mode="results">
        <xsl:param name="sorting"/>
        
        <dl>
          <xsl:for-each select="sub:Resource"> <!-- The root node for each described resource -->
            <xsl:sort select="./*<name() = $sorting>"/>
    
      <dt>
    	  <xsl:apply-templates select="./dct:title" mode="internal-link"/>
    	  <i18n:text key="search.result.hastopic">har emne</i18n:text><xsl:text> </xsl:text>
        <xsl:apply-templates select="./dct:subject"/>
    	</dt>
    	<dd>
    	  <div style="font-size:small"><i18n:text key="search.result.publishedby">Publisert av</i18n:text><xsl:text>: </xsl:text>
    	    <xsl:apply-templates select="dct:publisher"/>
    	    <xsl:text> </xsl:text>
    	    <xsl:apply-templates select="./dct:dateAccepted"/>
    	  </div>
    	  <xsl:apply-templates select="./dct:description"/>
    	</dd>
          </xsl:for-each>
        </dl>
      </xsl:template>
    



In principle showing the location field could be as simple as a small insert here

        
      <xsl:apply-templates select="./sub:location"/>
    

Then you create this template in the second XSLT which could be as simple as

        
      <xsl:template match="sub:location">
        <xsl:value-of select="."/>
      </xsl:template>
    

### 5.5 Change the configuration to accept searches on a new field

To make a newly added field searchable you change the sublima configuration file  $SUBLIMA_HOME/blocks/sublima-query/src/main/resources/META-INF/cocoon/properties/sublima-query.properties

By default search filed has the following settings 


        
    # SEARCH FIELDS
    # Defines which fields of the resource that should be searchable.
    # The fields must be given with their prefix and separated with semicolon. Ie.
    # sublima.searchfields=dct:title;dct:subject;dct:publisher
    # that states that the title, subjects and publisher should be searchable
    # See resourceform.xsl for reference to which fields each resource contains
    sublima.searchfields=dct:title;dct:description;dct:publisher/foaf:name;dct:subject/skos:prefLabel;dct:subject/skos:altLabel;dct:subject/skos:hiddenLabel
    sublima.prefixes=dct: <http://purl.org/dc/terms/>;foaf: <http://xmlns.com/foaf/0.1/>;sub: <http://xmlns.computas.com/sublima#>;skos: <http://www.w3.org/2004/02/skos/core#>
    

To add a new field here you have to add the search filed identifier in the sublima.searchfields  property.

        
    sublima.searchfields=dct:title;dct:description;dct:publisher/foaf:name;dct:subject/skos:prefLabel;dct:subject/skos:altLabel;dct:subject/skos:hiddenLabel;sub:location
    

### 5.6 Add a new search field in advanced search

To add a new search field in advanced search you will need to open the XSLT for advanced search. This is located at $SUBLIMA_HOME/blocks/sublima-skin/src/main/resources/COB-INF/transform/advancedsearch.xsl.

Adding a new field here basically means to create a new row, which can be done as shown below.

        
            <tr>
              <th scope="row">
                <label for="location"><i18n:text key="location">location</i18n:text></label>
              </th>
              <td>
                <input id="location" type="text" name="sub:location" size="20"/>
              </td>
            </tr>
            <tr>
    


## 6. Repeating fields


### 6.1 Repeated fields in the current admin interface

Relevant fields for repetition are included

* Subject (including customized relations)
* Preferred label
* Synonym
* Misspellings


### 6.2 Creating new repeated fields

Fields can be repeated in the administration interface. This is done in the administrator XSLTs interface. Templates are based on the$SUBLIMA_HOME/blocks/sublima-skin/src/main/resources/COB-INF/transform/admin-styling.xslt

It works based on a key-value Map, and the usual usage is to pass the query parameters from a HTTP request (i.e. from the XSLT generated XHTML). 

The subject can be given either directly by a URI in a key named _the-resource_,
or by sending a _title-field_ key containing the name a key containing a user-given string, which will be stripped of accents and non-alphanumeric characters. In the latter case _subjecturi-prefix_ must also be given, and it should contain a valid URI which will be prepended to the above title, to give the full subject URI.
 
Different languages are supported. It may either be given as a key _interface-language_ that holds the language of any literal. This may be overridden by giving the keys unique names, where one contains the literal, the other contains a Lingvoj language URI. See the test class for examples.


#### 6.1.1 Single value 

The keys and values are not repeated
        
    foaf:name=Institute for Energy Technology
    interface-language=en
    the-resource"http://sublima.computas.com/agent/ife
    


#### 6.1.2 Repeated value

The keys are repeated values are not
        
    skos:prefLabel-1=Jet
    skos:prefLabel-1=http://www.lingvoj.org/lang/en
    skos:prefLabel-2=Jetfly
    skos:prefLabel-2=http://www.lingvoj.org/lang/no
    the-resource=http://sublima.computas.com/topic/Jet
    

Only triples can be inserted, it does not support the path-like notation of the DESCRIBE methods. 

