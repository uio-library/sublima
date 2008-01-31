function query() {
  var sparqlDispatcher = cocoon.getComponent("com.computas.sublima.query.SparqlDispatcher");
  var result = sparqlDispatcher.query();
  cocoon.sendPage("rdf/result-list", 
    {
      "result" : result
    }
  );
}