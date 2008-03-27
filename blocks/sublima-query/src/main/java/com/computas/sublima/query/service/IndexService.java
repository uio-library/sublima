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
import com.computas.sublima.query.impl.DefaultSparqlDispatcher;
import com.computas.sublima.query.impl.DefaultSparulDispatcher;
import org.apache.log4j.Logger;
import org.apache.commons.io.IOUtils;

import java.net.*;
import java.io.IOException;
import java.io.File;
import java.util.HashMap;
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
    private DefaultSparulDispatcher sparulDispatcher;

  /**
   *  Method to create an index based on the internal content
   */
  public void createInternalResourcesMemoryIndex() {
    
    DatabaseService myDbService = new DatabaseService();
    IDBConnection connection = myDbService.getConnection();
    ResultSet resultSet;

    logger.info("SUBLIMA: createInternalResourcesMemoryIndex() --> Indexing - Created database connection " + connection.getDatabaseType());

    // -- Read and index all literal strings.
    File indexDir = new File(SettingsService.getProperty("sublima.index.directory"));
    logger.info("SUBLIMA: createInternalResourcesMemoryIndex() --> Indexing - Read and index all literal strings");
    IndexBuilderString larqBuilder = new IndexBuilderString(indexDir);

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
   * @deprecated Replaced by a CRON job
   */

  @Deprecated public void createExternalResourcesMemoryIndex() {
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
      if("200".equals(getHTTPcodeForUrl(url))) {
        result = readContentFromURL(url);
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
        result = readContentFromURL(url);
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
   * Method to extract all URLs of the resources in the model
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

    try {
      connection.close();
    } catch (SQLException e) {
      e.printStackTrace();
    }
    
    logger.info("SUBLIMA: getAllExternalResourcesURLs() --> Indexing - Fetched all resource URLs from the model");
    return resultSet;
  }

  /**
   * A method to validate all urls on the resources. Adds the URL to the list along with
   * the http code.
   * @return A map containing the URL and its HTTP Code. In case of exceptions a String
   * representation of the exception is used.
   */
  public HashMap<String, String> validateURLs() {
    ResultSet resultSet;
    resultSet = getAllExternalResourcesURLs();
    HashMap<String, String> urlCodeMap = new HashMap<String, String>();

    // For each URL, do a HTTP GET and check the HTTP code
    URL u = null;
    String result;

    while(resultSet.hasNext()) {
      String resultURL = resultSet.next().toString();
      String url = resultURL.substring(10, resultURL.length()-3).trim();
      result = getHTTPcodeForUrl(url);
      urlCodeMap.put(url, result);
      logger.debug("validateURLS() ---> " + url + "  :  " + result);
    }

    return urlCodeMap;
  }

  /**
   * A method to read the content of a URL
   *
   * @param url - The URL of the resource to read
   * @return A String containing the content of the given URL
   */
  private String readContentFromURL(String url) {
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
   * In cases where the connection gives an exception
   * the exception is catched and a String representation
   * of the exception is returned as the http code
   *
   * @param url - The URL of the resource to read
   * @return A String representing the HTTP code. In case of exceptions a String
   * representation of the exception is used.
   */
  public String getHTTPcodeForUrl(String url) {
        String result = null;

    try {
      URL u = new URL(url);
      HttpURLConnection con = (HttpURLConnection) u.openConnection();
      result = String.valueOf(con.getResponseCode());
    }
    catch (MalformedURLException e) {
      result = "MALFORMED_URL";
      e.printStackTrace();
    }
    catch (ClassCastException e) {
      result = "UNSUPPORTED_PROTOCOL";
      e.printStackTrace();
    }
    catch (UnknownHostException e) {
      result = "UNKNOWN_HOST";
      e.printStackTrace();
    }
    catch (ConnectException e) {
      result = "CONNECTION_TIMEOUT";
      e.printStackTrace();
    }
    catch(IOException e) {
      result = "IOEXCEPTION";
      e.printStackTrace();
    }
    return result;
  }

  /**
   * Method that updates a resource based on the HTTP Code.
   * @param url - The URL (resource URI) to update
   * @param code - The URLs HTTP Code
   */
  public void updateResourceStatus(String url, String code) {
    sparulDispatcher = new DefaultSparulDispatcher();
    String updateString = null;

    /*
      if("200".equals(code)) {

      updateString = "PREFIX dct: <http://purl.org/dc/terms/>\n" +
                     "PREFIX wdr: <http://www.w3.org/2007/05/powder#>\n" +
                     "PREFIX sub: <http://xmlns.computas.com/sublima#>\n" +
                     "MODIFY <" + url + ">\n" +
                     "DELETE\n" +
                     "{ " +
                     "wdr:describedBy ?oldstatus " +
                     "}\n" +
                     "INSERT\n" +

    }
    */


  }

  /**
   * Method thats perform the linkcheck job. The job performs an
   * URL check on all resource URLs, fetches the URL content for all URLs
   * marked as OK and updates the status in the model
   */

  public void performLinkcheckJob() {
    HashMap<String, String> validatedURLs = null;

    validatedURLs = validateURLs();

    for(String url : validatedURLs.keySet()) {
      String code = validatedURLs.get(url);
      updateResourceStatus(url, code);
    }
  }


}
