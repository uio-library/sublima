package com.computas.sublima.query.impl;

import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.sql.SQLException;

import org.apache.commons.io.IOUtils;

import com.computas.sublima.query.SparqlDispatcher;
import com.computas.sublima.query.service.SettingsService;
import com.computas.sublima.query.service.DatabaseService;
import com.hp.hpl.jena.rdf.model.Model;
import com.hp.hpl.jena.db.IDBConnection;
import com.hp.hpl.jena.db.ModelRDB;
import com.hp.hpl.jena.query.Query;
import com.hp.hpl.jena.query.QueryFactory;
import com.hp.hpl.jena.query.QueryExecution;
import com.hp.hpl.jena.query.QueryExecutionFactory;

/**
 * This component queries RDF triple stores using Sparql. It is threadsafe.
 */
public class DefaultSparqlDispatcher implements SparqlDispatcher {

  /**
   * This method takes all SPARQL requests and identifies the corrent receiver.
   * 
   * @param query
   * @return Object - based on what method it forwards to. Must be cased in cases
   * where the returning object is not derived from java.lang.Object 
   */
  public Object query(String query) {

    /*  Detect if the SPARQL should be sent to Joseki or LARQ
     *  If the query contains the URI <http://jena.hpl.hp.com/ARQ/property#>
     *  we know that it is a free text search
     */
    if(query.contains("<http://jena.hpl.hp.com/ARQ/property#>")) {
      return freesearchQuery(query);
    }
    else { // It's a structured search (ie. advanced search)
      return structuredQuery(query);
    }
	}

  private Object structuredQuery(String query) {
    String result = null;
    try {
      String url = SettingsService.getProperty("sublima.joseki.endpoint");

      URL u = new URL(url + "?query=" + URLEncoder.encode(query, "UTF-8"));

      HttpURLConnection con = (HttpURLConnection) u.openConnection();

      result = IOUtils.toString(con.getInputStream());
    } catch (Exception e) {
      e.printStackTrace();
    }
    return result;
  }

  /**
   * Method do perform a free text search on the index based on the DB model
   * @param sparqlQuery - A String containing the SPARQL query
   * @return queryResult - An RDF Model containing the result as a graph
   */
  public Object freesearchQuery(String sparqlQuery) {
    DatabaseService myDbService = new DatabaseService();
    IDBConnection connection = myDbService.getConnection();

    //Create a model based on the one in the DB
    ModelRDB model = ModelRDB.open(connection);
    try {
      connection.close();
    } catch (SQLException e) {
      e.printStackTrace();
    }

    Query query = QueryFactory.create(sparqlQuery);
    QueryExecution qExec = QueryExecutionFactory.create(query, model);
    Model queryResult = qExec.execDescribe();
    qExec.close();

    return queryResult;
  }
}
