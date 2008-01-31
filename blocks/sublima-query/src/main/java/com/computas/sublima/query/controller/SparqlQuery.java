package com.computas.sublima.query.controller;

import java.util.HashMap;
import java.util.Map;

import org.apache.cocoon.ProcessingException;
import org.apache.cocoon.components.flow.apples.AppleRequest;
import org.apache.cocoon.components.flow.apples.AppleResponse;
import org.apache.cocoon.components.flow.apples.StatelessAppleController;

import com.computas.sublima.query.SparqlDispatcher;

public class SparqlQuery implements StatelessAppleController {

	private SparqlDispatcher sparqlDispatcher;

	public void process(AppleRequest req, AppleResponse res) throws Exception {
		String sparqlQuery = req.getCocoonRequest().getParameter("query");
		if(sparqlQuery == null || "".equals(sparqlQuery)) {
			throw new ProcessingException("A SPARQL query string has to be passed.");
		}
		Object queryResult = sparqlDispatcher.query(sparqlQuery);
		Map<String, Object> bizData = new HashMap<String, Object>();
		bizData.put("result", queryResult);
		res.sendPage("rdf/result-list", bizData);
	}

	public void setSparqlDispatcher(SparqlDispatcher sparqlDispatcher) {
		this.sparqlDispatcher = sparqlDispatcher;
	}
	
}
