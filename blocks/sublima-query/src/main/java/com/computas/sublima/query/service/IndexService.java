package com.computas.sublima.query.service;

import com.hp.hpl.jena.db.IDBConnection;
import com.hp.hpl.jena.db.ModelRDB;
import com.hp.hpl.jena.query.*;
import com.hp.hpl.jena.query.larq.IndexBuilderString;
import com.hp.hpl.jena.query.larq.IndexBuilderExt;
import com.hp.hpl.jena.query.larq.IndexLARQ;
import com.hp.hpl.jena.query.larq.LARQ;
import com.hp.hpl.jena.sparql.util.StringUtils;
import com.hp.hpl.jena.rdf.model.Resource;
import com.hp.hpl.jena.rdf.model.ResourceFactory;
import org.apache.log4j.Logger;
import org.apache.commons.io.IOUtils;

import java.net.URL;
import java.net.URLEncoder;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.io.IOException;
import java.util.Map;
import java.sql.SQLException;

/**
 * A class to support Lucene/LARQ indexing in the web app
 * Has methods for creating and accessing indexes
 *
 *
 * @author: mha
 * Date: 13.mar.2008
 */
public class IndexService {

    private static Logger logger = Logger.getLogger(IndexService.class);

  /**
   *  Method to create an index based on the internal content
   */
  public void createInternalResourcesMemoryIndex() {
    
    DatabaseService myDbService = new DatabaseService();
    IDBConnection connection = myDbService.getConnection();
    ResultSet resultSet;

    logger.info("SUBLIMA: createInternalResourcesMemoryIndex() --> Indexing - Created database connection " + connection.getDatabaseType());

    // -- Read and index all literal strings.
    logger.info("SUBLIMA: createInternalResourcesMemoryIndex() --> Indexing - Read and index all literal strings");
    IndexBuilderString larqBuilder = new IndexBuilderString();
   
    //IndexBuilderSubject larqBuilder = new IndexBuilderSubject();

    //Create a model based on the one in the DB
    ModelRDB model = ModelRDB.open(connection);
    logger.info("SUBLIMA: createInternalResourcesMemoryIndex() --> Indexing - Created RDF model from database");
    try {
      connection.close();
    } catch (SQLException e) {
      e.printStackTrace(); 
    }

    // -- Create an index based on existing statements
    larqBuilder.indexStatements(model.listStatements());
    logger.info("SUBLIMA: createInternalResourcesMemoryIndex() --> Indexing - Indexed all model statements");
    // -- Finish indexing
    larqBuilder.closeForWriting();
    logger.info("SUBLIMA: createInternalResourcesMemoryIndex() --> Indexing - Closed index for writing");
    // -- Create the access index
    IndexLARQ index = larqBuilder.getIndex();

    // -- Make globally available
    LARQ.setDefaultIndex(index);
    logger.info("SUBLIMA: createInternalResourcesMemoryIndex() --> Indexing - Index now globally available");
  }

  /**
   *  Method to create an index based on the external content
   */
  public void createExternalResourcesMemoryIndex() {
    IndexBuilderExt larqBuilder = new IndexBuilderExt() ;
    ResultSet resultSet;


    // -- Read and index all external resources
    logger.info("SUBLIMA: createExternalResourcesMemoryIndex() --> Indexing - Read and index all external resources");

    resultSet = getAllExternalResourcesURLs();
    IndexBuilderExt larqBuilderExt = new IndexBuilderExt() ;

    // For each URL, do a HTTP GET and extract the content. This content is put in the index.
    URL u = null;
    String result = null;

    for(int i = 0; i<10; i++) {
      String resultURL = resultSet.next().toString();
      String url = resultURL.substring(10, resultURL.length()-3).trim();
      if(getHTTPcodeForUrl(url) == 200) {
        result = readURL(url);
        // Strip all HTML tags
        result = result.replaceAll("\\<.*?>","");
      }

      if(result != null) {
        Resource r = ResourceFactory.createResource(url);
        larqBuilderExt.index(r, result);
        System.out.println(result);
      }
    }
    /*
    while(resultSet.hasNext()) {
      String resultURL = resultSet.next().toString();
      String url = resultURL.substring(10, resultURL.length()-3).trim();
      if(getHTTPcodeForUrl(url) == 200) {
        result = readURL(url);
      }

      if(result != null) {
        Resource r = ResourceFactory.createResource(url);
        larqBuilderExt.index(r, result);
        System.out.println(result);
      }
    }*/

    larqBuilder.closeForWriting() ;
    IndexLARQ index = larqBuilder.getIndex() ;

    // -- Make globally available
    LARQ.setDefaultIndex(index);
    logger.info("SUBLIMA: createExternalResourcesMemoryIndex() --> Indexing - Index now globally available");

  }

  /**
   * Method to extract all URLs to the resources in the model
   *
   * @return ResultSet containing all resource URLS from the model
   */
  private ResultSet getAllExternalResourcesURLs() {
    DatabaseService myDbService = new DatabaseService();
    IDBConnection connection = myDbService.getConnection();
    ModelRDB model = ModelRDB.open(connection);

    String queryString = StringUtils.join("\n", new String[]{
            "PREFIX dct: <http://purl.org/dc/terms/>",
            "SELECT ?url",
            "WHERE {",
            "        ?url dct:title ?title }"});

    Query query = QueryFactory.create(queryString);
    QueryExecution qExec = QueryExecutionFactory.create(query, model);
    ResultSet resultSet = qExec.execSelect();
    logger.info("SUBLIMA: getAllExternalResourcesURLs() --> Indexing - Fetched all resource URLs from the model");
    return resultSet;
  }

  /**
   * A method to validate all urls on the resources. Adds the URL to the list along with
   * the http code if it's not okey - 200.
   * @return A map containing the URL with the error code
   */
  //todo Return a map ie with the failing urls
  public void validateURLs() {
    ResultSet resultSet;
    resultSet = getAllExternalResourcesURLs();

    // For each URL, do a HTTP GET and check the HTTP code
    URL u = null;
    int result = 0;

    while(resultSet.hasNext()) {
      String resultURL = resultSet.next().toString();
      String url = resultURL.substring(10, resultURL.length()-3).trim();

      result = getHTTPcodeForUrl(url);

      if(result != 200) {
        System.out.println(url + " returned a " + result);
      }
    }
  }

  /**
   * A method to read the content of a URL
   *
   * @param url - The URL of the resource to read
   * @return A String containing the content of the given URL
   */
  private String readURL(String url) {
    String result = null;

    try {
      URL u = new URL(url);
      HttpURLConnection con = (HttpURLConnection) u.openConnection();
      result = IOUtils.toString(con.getInputStream());
    }
    catch (MalformedURLException e) {
      e.printStackTrace();
    }
    catch (IOException e) {
      e.printStackTrace();
    }
    return result;
  }

  /**
   * A method to check a URL. Returns the HTTP code.
   *
   * @param url - The URL of the resource to read
   * @return A int representing the HTTP code.
   */
  public int getHTTPcodeForUrl(String url) {
        int result = 0;

    try {
      URL u = new URL(url);
      HttpURLConnection con = (HttpURLConnection) u.openConnection();
      result = con.getResponseCode();
    }
    catch (MalformedURLException e) {
      e.printStackTrace();
    }
    catch (IOException e) {
      e.printStackTrace();
    }
    catch (ClassCastException e) {
      System.out.println("***** ERROR ****** " + url);
      e.printStackTrace();

    }
    return result;
  }
}
