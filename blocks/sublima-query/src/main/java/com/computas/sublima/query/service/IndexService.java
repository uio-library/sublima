package com.computas.sublima.query.service;

import com.computas.sublima.query.impl.DefaultSparulDispatcher;
import com.hp.hpl.jena.db.IDBConnection;
import com.hp.hpl.jena.db.ModelRDB;
import com.hp.hpl.jena.query.*;
import com.hp.hpl.jena.query.larq.IndexBuilderExt;
import com.hp.hpl.jena.query.larq.IndexBuilderString;
import com.hp.hpl.jena.query.larq.IndexLARQ;
import com.hp.hpl.jena.query.larq.LARQ;
import com.hp.hpl.jena.rdf.model.Resource;
import com.hp.hpl.jena.rdf.model.ResourceFactory;
import com.hp.hpl.jena.sparql.util.StringUtils;
import org.apache.commons.io.IOUtils;
import org.apache.log4j.Logger;

import java.io.File;
import java.io.IOException;
import java.net.*;
import java.sql.SQLException;
import java.util.HashMap;

/**
 * A class to support Lucene/LARQ indexing in the web app
 * Has methods for creating and accessing indexes
 *
 * @author: mha
 * Date: 13.mar.2008
 */
public class IndexService {

  private static Logger logger = Logger.getLogger(IndexService.class);
  private DefaultSparulDispatcher sparulDispatcher;

  /**
   * Method to create an index based on the internal content
   */
  public void createInternalResourcesMemoryIndex() {

    DatabaseService myDbService = new DatabaseService();
    IDBConnection connection = myDbService.getConnection();
    ResultSet resultSet;
    IndexBuilderString larqBuilder;

    logger.info("SUBLIMA: createInternalResourcesMemoryIndex() --> Indexing - Created database connection " + connection.getDatabaseType());

    // -- Read and index all literal strings.
    File indexDir = new File(SettingsService.getProperty("sublima.index.directory"));
    logger.info("SUBLIMA: createInternalResourcesMemoryIndex() --> Indexing - Read and index all literal strings");
    if("memory".equals(SettingsService.getProperty("sublima.index.type"))) {
      larqBuilder = new IndexBuilderString();
    }
    else {
      larqBuilder = new IndexBuilderString(indexDir);
    }


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
    model.close();

    // -- Make globally available
    LARQ.setDefaultIndex(index);
    logger.info("SUBLIMA: createInternalResourcesMemoryIndex() --> Indexing - Index now globally available");
  }

  /**
   * Method to create an index based on the external content
   *
   * @deprecated Replaced by a CRON job
   */

  @Deprecated
  public void createExternalResourcesMemoryIndex() {
    IndexBuilderExt larqBuilder = new IndexBuilderExt();
    ResultSet resultSet;

    // -- Read and index all external resources
    logger.info("SUBLIMA: createExternalResourcesMemoryIndex() --> Indexing - Read and index all external resources");

    resultSet = getAllExternalResourcesURLs();
    IndexBuilderExt larqBuilderExt = new IndexBuilderExt();

    // For each URL, do a HTTP GET and extract the content. This content is put in the index.
    URL u = null;
    String result = null;

    for (int i = 0; i < 10; i++) {
      String resultURL = resultSet.next().toString();
      String url = resultURL.substring(10, resultURL.length() - 3).trim();
      if ("200".equals(getHTTPcodeForUrl(url))) {
        result = readContentFromURL(url);
        // Strip all HTML tags
        result = result.replaceAll("\\<.*?>", "");
      }

      if (result != null) {
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

    larqBuilder.closeForWriting();
    IndexLARQ index = larqBuilder.getIndex();

    // -- Make globally available
    LARQ.setDefaultIndex(index);

    logger.info("SUBLIMA: createExternalResourcesMemoryIndex() --> Indexing - Index now globally available");

  }

  /**
   * Method to extract all URLs of the resources in the model
   *
   * @return ResultSet containing all resource URLS from the model
   */
  // todo Use SparqlDispatcher (needs to return ResultSet)
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
    //model.close();

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
   *
   * @return A map containing the URL and its HTTP Code. In case of exceptions a String
   *         representation of the exception is used.
   */
  public HashMap<String, String> validateURLs() {
    ResultSet resultSet;
    resultSet = getAllExternalResourcesURLs();
    HashMap<String, String> urlCodeMap = new HashMap<String, String>();

    // For each URL, do a HTTP GET and check the HTTP code
    URL u = null;
    String result;

    for (int i = 0; i < 200; i++) {
      String resultURL = resultSet.next().toString();
      String url = resultURL.substring(10, resultURL.length() - 3).trim();
      result = getHTTPcodeForUrl(url);
      urlCodeMap.put(url, result);
      logger.info("validateURLS() ---> " + url + "  :  " + result);

    }

    /*
    while (resultSet.hasNext()) {
        String resultURL = resultSet.next().toString();
        String url = resultURL.substring(10, resultURL.length() - 3).trim();
        result = getHTTPcodeForUrl(url);
        urlCodeMap.put(url, result);
        logger.debug("validateURLS() ---> " + url + "  :  " + result);
      }
     */

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
   *         representation of the exception is used.
   */
  public String getHTTPcodeForUrl(String url) {
    String result = null;

    try {
      URL u = new URL(url);
      logger.info("getHTTPcodeForUrl() ---> " + url);
      HttpURLConnection con = (HttpURLConnection) u.openConnection();
      con.setConnectTimeout(6000);
      result = String.valueOf(con.getResponseCode());
    }
    catch (MalformedURLException e) {
      result = "MALFORMED_URL";
    }
    catch (ClassCastException e) {
      result = "UNSUPPORTED_PROTOCOL";
    }
    catch (UnknownHostException e) {
      result = "UNKNOWN_HOST";
    }
    catch (ConnectException e) {
      result = "CONNECTION_TIMEOUT";
    }
    catch (SocketTimeoutException e) {
      result = "CONNECTION_TIMEOUT";
    }
    catch (IOException e) {
      result = "IOEXCEPTION";
    }
    return result;
  }

  /**
   * Method that updates a resource based on the HTTP Code.
   * The resource can have one of three statuses: OK, CHECK or INACTIVE.
   * This list shows what HTTP Codes that gives what status.
   * <p/>
   * 2xx - OK
   * <p/>
   * 301 - Fetch new URL from HTTP Header, then CHECK
   * 302 - OK
   * 303 - OK
   * 304 - OK
   * 305 - OK
   * 306 - INACTIVE
   * 307 - OK
   * <p/>
   * 400 - INACTIVE
   * 401 - CHECK
   * 403 - INACTIVE
   * 404 - CHECK
   * 405 - INACTIVE
   * 406 - CHECK
   * 407 - CHECK
   * 408 - CHECK
   * 409 - CHECK
   * 410 - GONE
   * 411 to 417 - CHECK
   * <p/>
   * 5xx - CHECK
   * <p/>
   * MALFORMED_URL - INACTIVE
   * UNSUPPORTED_PROTOCOL - INACTIVE
   * UNKNOWN_HOST - CHECK
   * CONNECTION_TIMEOUT - CHECK
   * <p/>
   * Others - CHECK
   *
   * @param url  - The URL (resource URI) to update
   * @param code - The URLs HTTP Code
   */
  public void updateResourceStatus(String url, String code) {
    sparulDispatcher = new DefaultSparulDispatcher();
    String status = null;

    // OK
    if ("302".equals(code) ||
            "303".equals(code) ||
            "304".equals(code) ||
            "305".equals(code) ||
            "307".equals(code) ||
            code.startsWith("2")) {
      status = "<http://sublima.computas.com/status/OK>";
    }
    // GONE
    else if ("410".equals(code)) {
      status = "<http://sublima.computas.com/status/GONE>";
    }
    // INACTIVE
    else if ("306".equals(code) ||
            "400".equals(code) ||
            "403".equals(code) ||
            "405".equals(code) ||
            "MALFORMED_URL".equals(code) ||
            "UNSUPPORTED_PROTOCOL".equals(code)) {
      status = "<http://sublima.computas.com/status/INACTIVE>";
    }
    // CHECK
    else {
      status = "<http://sublima.computas.com/status/CHECK>";
    }

    String deleteString = "PREFIX sub: <http://xmlns.computas.com/sublima#>\n" +
            "DELETE\n" +
            "{ " +
            "<" +url +"> sub:status ?oldstatus " +
            "}\n" +
            "WHERE {\n" +
             "<" +url +"> sub:status ?oldstatus " +
            "}";

    boolean success = false;
    success = sparulDispatcher.query(deleteString);
    logger.info("updateResourceStatus() ---> " + url + ":" + code + " -- DELETE OLD STATUS --> " + success);

    String updateString = "PREFIX sub: <http://xmlns.computas.com/sublima#>\n" +
            "INSERT\n" +
            "{ " +
            "<" +url +"> sub:status " + status + "\n" +
            "}";

    success = false;

    success = sparulDispatcher.query(updateString);
    logger.info("updateResourceStatus() ---> " + url + ":" + code + " -- INSERT NEW STATUS --> " + success);
  }

  public void updateResourceExternalContent(String url) {
    sparulDispatcher = new DefaultSparulDispatcher();
    String resourceExternalContent = readContentFromURL(url);

    String deleteString = "PREFIX ext: <??????????>\n" +
            "DELETE\n" +
            "{ " +
            "<" +url +"> ext:body ?oldcontent " +
            "}\n" +
            "WHERE {\n" +
             "<" +url +"> ext:body ?oldcontent " +
            "}";

    boolean success = false;
    success = sparulDispatcher.query(deleteString);
    logger.info("updateResourceExternalContent() ---> " + url + " -- DELETE OLD STATUS --> " + success);

    String updateString = "PREFIX ext: <???????????>\n" +
            "INSERT\n" +
            "{ " +
            "<" +url +"> ext:body " + resourceExternalContent + "\n" +
            "}";

    success = false;

    success = sparulDispatcher.query(deleteString);
    logger.info("updateResourceExternalContent() ---> " + url + " -- INSERT NEW STATUS --> " + success);
  }

  /**
   * Method thats perform the linkcheck job. The job performs an
   * URL check on all resource URLs, fetches the URL content for all URLs
   * marked as OK and updates the status in the model
   */

  public void performLinkcheckJob() {
    HashMap<String, String> validatedURLs = null;

    validatedURLs = validateURLs();

    for (String url : validatedURLs.keySet()) {
      String code = validatedURLs.get(url);
      updateResourceStatus(url, code);
    }
  }


}
