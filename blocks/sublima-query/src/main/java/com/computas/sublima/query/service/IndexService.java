package com.computas.sublima.query.service;

import com.computas.sublima.query.impl.DefaultSparulDispatcher;
import com.computas.sublima.app.service.URLActions;
import com.hp.hpl.jena.db.IDBConnection;
import com.hp.hpl.jena.db.ModelRDB;
import com.hp.hpl.jena.query.*;
import com.hp.hpl.jena.query.larq.IndexBuilderString;
import com.hp.hpl.jena.query.larq.IndexLARQ;
import com.hp.hpl.jena.query.larq.LARQ;
import com.hp.hpl.jena.shared.DoesNotExistException;
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
  private SearchService searchService = new SearchService();

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
    if ("memory".equals(SettingsService.getProperty("sublima.index.type"))) {
      larqBuilder = new IndexBuilderString();
    } else {
      larqBuilder = new IndexBuilderString(indexDir);
    }

    //IndexBuilderSubject larqBuilder = new IndexBuilderSubject();

    //Create a model based on the one in the DB
    try {
      ModelRDB model = ModelRDB.open(connection);
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
    catch (DoesNotExistException e) {
      logger.info("SUBLIMA: createInternalResourcesMemoryIndex() --> Indexing - NO CONTENT IN DATABASE. Please fill DB from Admin/Database and restart Tomcat.");
    }

    logger.info("SUBLIMA: createInternalResourcesMemoryIndex() --> Indexing - Created RDF model from database");
    try {
      connection.close();
    } catch (SQLException e) {
      e.printStackTrace();
    }
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
  public HashMap<String, HashMap<String, String>> validateURLs() {
    ResultSet resultSet;
    resultSet = getAllExternalResourcesURLs();
    HashMap<String, HashMap<String, String>> urlCodeMap = new HashMap<String, HashMap<String, String>>();

    // For each URL, do a HTTP GET and check the HTTP code
    URL u = null;
    HashMap<String, String> result;

    for (int i = 0; i < 200; i++) {
      String resultURL = resultSet.next().toString();
      String url = resultURL.substring(10, resultURL.length() - 3).trim();
      
      result = getHTTPmapForUrl(url);
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

  /**
   * Method thats perform the linkcheck job. The job performs an
   * URL check on all resource URLs, fetches the URL content for all URLs
   * marked as OK and updates the status in the model
   */

  public void performLinkcheckJob() {
    HashMap<String, HashMap<String, String>> validatedURLs = null;

    validatedURLs = validateURLs();

    for (String url : validatedURLs.keySet()) {
      String code = validatedURLs.get(url).get("http:status");
      updateResourceStatus(url, code);
    }
  }


}
