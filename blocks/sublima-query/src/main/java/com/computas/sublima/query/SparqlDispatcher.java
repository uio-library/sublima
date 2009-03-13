package com.computas.sublima.query;

import com.hp.hpl.jena.query.ResultSet;

public interface SparqlDispatcher {
	
	// FIXME In order to increase the peformance, the 
	// sparql dispatcher shouldn't return a string object	
	Object query(String sparqlQuery);

    Object query(String sparqlQuery, String queryType);

  String getResultsAsJSON(String sparqlQuery);

  ResultSet getResultsAsResultSet(String sparqlQuery);

}
