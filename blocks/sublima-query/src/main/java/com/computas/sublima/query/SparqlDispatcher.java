package com.computas.sublima.query;

public interface SparqlDispatcher {
	
	// FIXME In order to increase the peformance, the 
	// sparql dispatcher shouldn't return a string object	
	Object query(String sparqlQuery);

}
