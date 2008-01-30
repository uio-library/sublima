function query() {
  var sparqlDispatcher = cocoon.getComponent("com.computas.sublima.query.SparqlDispatcher");
  var result = sparqlDispatcher.query();
  cocoon.sendPage("screens/result-list", 
    {
      "result" : result
    }
  );
}