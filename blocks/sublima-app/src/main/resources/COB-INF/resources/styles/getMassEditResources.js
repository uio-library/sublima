function getResources() {
  sparqlquery = 'PREFIX dct: <http://purl.org/dc/terms/>\nPREFIX sub: <http://xmlns.computas.com/sublima#>\nPREFIX xsd:    <http://www.w3.org/2001/XMLSchema#>\nSELECT ?uri ?title WHERE \n{ ?uri dct:title ?title ;\n   a sub:Resource  .\n   FILTER regex(xsd:string(?uri), ".*legen.*", "i")\n}';
  $.ajax({
    type: "GET",
    url: "../../sparql",
    dataType: "json",
    data: {query: sparqlquery, accept:"application/sparql-results+json"},
    error: function (XMLHttpRequest, textStatus) {
      alert("An error occured, contact webmaster. Message was: " + textStatus);
    },
    success: function(data) { createTable(data); }
  });
}
