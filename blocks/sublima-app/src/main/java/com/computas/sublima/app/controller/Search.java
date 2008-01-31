package com.computas.sublima.app.controller;

import java.util.HashMap;
import java.util.Map;

import org.apache.cocoon.components.flow.apples.AppleRequest;
import org.apache.cocoon.components.flow.apples.AppleResponse;
import org.apache.cocoon.components.flow.apples.StatelessAppleController;

import com.computas.sublima.query.SparqlDispatcher;

public class Search implements StatelessAppleController {

	private SparqlDispatcher sparqlDispatcher;

	public void process(AppleRequest req, AppleResponse res) throws Exception {

		// the initial search page
		String mode = req.getSitemapParameter("mode");
		if (!"search-result".equalsIgnoreCase(mode)) {
			res.sendPage("xhtml/search-form", null);
			return;
		}

		// sending the result
		Object queryResult = sparqlDispatcher.query();
		Map<String, Object> bizData = new HashMap<String, Object>();
		bizData.put("result", queryResult);
		res.sendPage("xml/search", bizData);
	}

	public void setSparqlDispatcher(SparqlDispatcher sparqlDispatcher) {
		this.sparqlDispatcher = sparqlDispatcher;
	}

}
