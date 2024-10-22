package com.computas.sublima.query;

public interface SparqlDispatcher {

  // FIXME In order to increase the peformance, the
  // sparql dispatcher shouldn't return a string object
  Object query(String sparqlQuery);

  Object query(String sparqlQuery, String queryType);

  String getResultsAsFormat(String sparqlQuery, String format);
}
