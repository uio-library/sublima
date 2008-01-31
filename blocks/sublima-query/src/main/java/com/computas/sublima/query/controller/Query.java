package com.computas.sublima.query.controller;

import java.util.HashMap;
import java.util.Map;

import org.apache.cocoon.components.flow.apples.AppleRequest;
import org.apache.cocoon.components.flow.apples.AppleResponse;
import org.apache.cocoon.components.flow.apples.StatelessAppleController;

import com.computas.sublima.query.SparqlDispatcher;

public class Query implements StatelessAppleController {

	private SparqlDispatcher sparqlDispatcher;

	public void process(AppleRequest req, AppleResponse res) throws Exception {
		Object queryResult = sparqlDispatcher.query();
		Map<String, Object> bizData = new HashMap<String, Object>();
		bizData.put("result", queryResult);
		res.sendPage("rdf/result-list", bizData);
	}

	public void setSparqlDispatcher(SparqlDispatcher sparqlDispatcher) {
		this.sparqlDispatcher = sparqlDispatcher;
	}
	
}
