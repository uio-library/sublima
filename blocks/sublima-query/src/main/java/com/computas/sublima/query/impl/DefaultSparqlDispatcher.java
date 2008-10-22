package com.computas.sublima.query.impl;

import com.computas.sublima.query.SparqlDispatcher;
import com.computas.sublima.query.service.SettingsService;
import com.hp.hpl.jena.query.*;
import org.apache.commons.io.IOUtils;
import org.apache.log4j.Logger;

import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.io.BufferedOutputStream;
import java.io.OutputStream;
import java.io.ByteArrayOutputStream;


/**
 * This component queries RDF triple stores using Sparql. It is threadsafe.
 */
public class DefaultSparqlDispatcher implements SparqlDispatcher {
  private static Logger logger = Logger.getLogger(DefaultSparqlDispatcher.class);

  /**
   * This method takes all SPARQL requests and identifies the corrent receiver.
   *
   * @param query
   * @return Object - based on what method it forwards to. Must be cased in cases
   *         where the returning object is not derived from java.lang.Object
   */
  public Object query(String query) {

    String result = null;
    HttpURLConnection con = null;
    try {
      String url = SettingsService.getProperty("sublima.joseki.endpoint");
      logger.info("SPARQLdispatcher executing.\n" + query + "\n");

      URL u = new URL(url + "?query=" + URLEncoder.encode(query, "UTF-8"));
      logger.debug("SPARQLdispatcher connected to Joseki.");
      long connecttime = System.currentTimeMillis();
      con = (HttpURLConnection) u.openConnection();
      result = IOUtils.toString(con.getInputStream());
      long requesttime = System.currentTimeMillis() - connecttime;
      logger.info("SPARQLdispatcher got results from Joseki. Query took " + requesttime + " ms." );
    } catch (Exception e) {
      con.disconnect();
      e.printStackTrace();
    }
    con.disconnect();
    System.gc();
    return result;
  }

  public String getResultsAsJSON(String queryString) {

    logger.info("SPARQLdispatcher executing.\n" + queryString + "\n");
    Query query = QueryFactory.create(queryString);
    QueryExecution qExec = QueryExecutionFactory.create(query, SettingsService.getModel());
    ByteArrayOutputStream out = new ByteArrayOutputStream();
    ResultSetFormatter.outputAsJSON(out, qExec.execSelect());
    qExec.close();
    System.gc();
    return out.toString();
  }

  public ResultSet getResultsAsResultSet(String queryString) {
    logger.info("SPARQLdispatcher executing.\n" + queryString + "\n");
    Query query = QueryFactory.create(queryString);
    QueryExecution qExec = QueryExecutionFactory.create(query, SettingsService.getModel());
    return qExec.execSelect();
  }
}
