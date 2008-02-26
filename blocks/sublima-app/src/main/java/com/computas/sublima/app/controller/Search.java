package com.computas.sublima.app.controller;

import com.computas.sublima.app.Form2SparqlService;
import com.computas.sublima.query.SparqlDispatcher;
import com.computas.sublima.query.service.DatabaseService;
import com.hp.hpl.jena.db.IDBConnection;
import com.hp.hpl.jena.db.ModelRDB;
import com.hp.hpl.jena.query.*;
import com.hp.hpl.jena.query.larq.IndexBuilderSubject;
import com.hp.hpl.jena.query.larq.IndexLARQ;
import com.hp.hpl.jena.query.larq.LARQ;
import com.hp.hpl.jena.query.larq.IndexBuilderString;
import com.hp.hpl.jena.rdf.model.Model;
import com.hp.hpl.jena.sparql.util.StringUtils;
import org.apache.cocoon.components.flow.apples.AppleRequest;
import org.apache.cocoon.components.flow.apples.AppleResponse;
import org.apache.cocoon.components.flow.apples.StatelessAppleController;
import org.apache.cocoon.environment.Request;
import org.apache.log4j.Logger;

import java.util.Enumeration;
import java.util.HashMap;
import java.util.Map;
import java.util.TreeMap;
import java.io.*;

public class Search implements StatelessAppleController {

  private SparqlDispatcher sparqlDispatcher;
  private String mode;

  private static Logger logger = Logger.getLogger(Search.class);

  @SuppressWarnings("unchecked")
  public void process(AppleRequest req, AppleResponse res) throws Exception {

    this.mode = req.getSitemapParameter("mode");

    // The initial advanced search page
    if ("advancedsearch".equalsIgnoreCase(mode)) {
      res.sendPage("xhtml/search-form", null);
      return;
    }

    // If it's search-results for advanced search, topic instance or resource
    if ("topic-instance".equalsIgnoreCase(mode) || "resource".equalsIgnoreCase(mode) || "search-result".equalsIgnoreCase(mode)) {
      doAdvancedSearch(res, req);
      return;
    }

    if ("freetext-result".equalsIgnoreCase(mode)) {
      doFreeTextSearch(res, req);
      return;
    }


  }

  private void doFreeTextSearch(AppleResponse res, AppleRequest req) {
    String searchstring = req.getCocoonRequest().getParameter("searchstring");

    DatabaseService myDbService = new DatabaseService();
    IDBConnection connection = myDbService.getConnection();

    // -- Read and index all literal strings.
    IndexBuilderString larqBuilder = new IndexBuilderString();

    //IndexBuilderSubject larqBuilder = new IndexBuilderSubject();

    //Create a model based on the one in the DB
    ModelRDB model = ModelRDB.open(connection);

    // -- Create an index based on existing statements
    larqBuilder.indexStatements(model.listStatements());
    // -- Finish indexing
    larqBuilder.closeForWriting();
    // -- Create the access index
    IndexLARQ index = larqBuilder.getIndex();

    // -- Make globally available
    LARQ.setDefaultIndex(index);

    //todo Fix me so that I'm up to speed with the actual model
    /*String queryString = StringUtils.join("\n", new String[]{
            "PREFIX pf: <http://jena.hpl.hp.com/ARQ/property#>",
            "PREFIX dct: <http://purl.org/dc/terms/>",
            "PREFIX foaf: <http://xmlns.com/foaf/0.1/>",
            "PREFIX sub: <http://xmlns.computas.com/sublima#>",
            "PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>",
            "SELECT ?resource WHERE {",
            "?resource dct:subject ?var1 .",
            "?var1 rdfs:label ?var2 .",
            "?var2 pf:textMatch '" + searchstring + "'",
            "}"
    });*/


    String queryString = StringUtils.join("\n", new String[] {
            "PREFIX pf: <http://jena.hpl.hp.com/ARQ/property#>",
            "PREFIX dct: <http://purl.org/dc/terms/>",
            "CONSTRUCT { ?resource dct:title ?title;",
            "                    dct:description ?desc;",
            "                    dct:language ?lang;",
            "                    dct:subject ?subject .",
            "            ?subject a ?topic . }",
            "WHERE {",
            "        ?lit pf:textMatch ( '+" + searchstring + "' 10 ) .",
            "        ?resource ?p ?lit; ",
            "                dct:title ?title;",
            "                dct:description ?desc;",
            "                dct:language ?lang;",
            "                dct:subject ?subject .",
            "        ?subject a ?topic. }"});

    /*String queryString = StringUtils.join("\n", new String[]{
            "PREFIX pf: <http://jena.hpl.hp.com/ARQ/property#>",
            "SELECT * {" ,
            "    ?lit pf:textMatch '+" + searchstring + "'",
            "}"
        }) ;*/


    Query query = QueryFactory.create(queryString);
    QueryExecution qExec = QueryExecutionFactory.create(query, model);
    Model m = qExec.execConstruct();
    qExec.close();
    ByteArrayOutputStream bout = new ByteArrayOutputStream();
    m.write(bout, "RDF/XML-ABBREV");

    Map<String, Object> bizData = new HashMap<String, Object>();
    bizData.put("result-list", bout.toString());
    bizData.put("configuration", new Object());
    res.sendPage("xml/sparql-result", bizData);
    /*
          Map<String, Object> bizData = new HashMap<String, Object>();
      bizData.put("freetext-result-list", queryResult);
      bizData.put("configuration", new Object());
      res.sendPage("xml/sparql-result", bizData);*/
  }

  public void doAdvancedSearch(AppleResponse res, AppleRequest req) {
    // Get all parameteres from the HTML form as Map
    Map<String, String[]> parameterMap = new TreeMap<String, String[]>(createParametersMap(req.getCocoonRequest()));

    if ("topic-instance".equalsIgnoreCase(mode) || "resource".equalsIgnoreCase(mode)) {
      parameterMap.put("prefix", new String[]{"dct: <http://purl.org/dc/terms/>", "rdfs: <http://www.w3.org/2000/01/rdf-schema#>"});
      parameterMap.put("interface-language", new String[]{req.getSitemapParameter("interface-language")});
    }

    if ("topic-instance".equalsIgnoreCase(mode)) {
      parameterMap.put("dct:subject/rdfs:label", new String[]{req.getSitemapParameter("topic")});
    }

    if ("resource".equalsIgnoreCase(mode)) {
      parameterMap.put("dct:identifier", new String[]{"http://sublima.computas.com/resource/"
              + req.getSitemapParameter("name")});
      parameterMap.put("dct:subject/rdfs:label", new String[]{""});
    }

    // sending the result
    String sparqlQuery = null;
    // Check for magic prefixes
    if (parameterMap.get("prefix") != null) {
      // Calls the Form2SPARQL service with the parameterMap which returns
      // a SPARQL as String
      Form2SparqlService form2SparqlService = new Form2SparqlService(parameterMap.get("prefix"));
      parameterMap.remove("prefix"); // The prefixes are magic variables
      sparqlQuery = form2SparqlService.convertForm2Sparql(parameterMap);
    } else {
      res.sendStatus(400);
    }
    // FIXME hard-wire the query for testing!!!
    // sparqlQuery = "DESCRIBE <http://the-jet.com/>";

    logger.trace("SPARQL query sent to dispatcher: " + sparqlQuery);
    Object queryResult = sparqlDispatcher.query(sparqlQuery);
    Map<String, Object> bizData = new HashMap<String, Object>();
    bizData.put("result-list", queryResult);
    bizData.put("configuration", new Object());
    res.sendPage("xml/sparql-result", bizData);
  }

  public void setSparqlDispatcher(SparqlDispatcher sparqlDispatcher) {
    this.sparqlDispatcher = sparqlDispatcher;
  }

  private Map<String, String[]> createParametersMap(Request request) {
    Map<String, String[]> result = new HashMap<String, String[]>();
    Enumeration parameterNames = request.getParameterNames();
    while (parameterNames.hasMoreElements()) {
      String paramName = (String) parameterNames.nextElement();
      result.put(paramName, request.getParameterValues(paramName));
    }
    return result;
  }

}
