package com.computas.sublima.query.controller;

import java.util.HashMap;
import java.util.Map;

import org.apache.cocoon.ProcessingException;
import org.apache.cocoon.components.flow.apples.AppleRequest;
import org.apache.cocoon.components.flow.apples.AppleResponse;
import org.apache.cocoon.components.flow.apples.StatelessAppleController;

import com.computas.sublima.query.SparulDispatcher;

public class SparulQuery implements StatelessAppleController {

	private SparulDispatcher sparulDispatcher;

	public void process(AppleRequest req, AppleResponse res) throws Exception {
		String sparqlQuery = req.getCocoonRequest().getParameter("insert");
		if(sparqlQuery == null || "".equals(sparqlQuery)) {
			throw new ProcessingException("A SPARUL insert string has to be passed.");
		}
		Object queryResult = sparulDispatcher.query(sparqlQuery);
		Map<String, Object> bizData = new HashMap<String, Object>();
		bizData.put("result", queryResult);
		System.gc();
    res.sendPage("rdf/result-list", bizData);
	}

	public void setSparqlDispatcher(SparulDispatcher sparulDispatcher) {
		this.sparulDispatcher = sparulDispatcher;
	}

}
