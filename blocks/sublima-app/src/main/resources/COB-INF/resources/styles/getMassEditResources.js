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


function createTable(data) {
     //      alert("foo" + data.results.bindings[1].uri.value);
  
//  var j = data.results.bindings.length();
  for (var i = 0 ; i < data.results.bindings.length; i++) {
  $("#my-table tbody").append("<tr><td>"+ (i+1) +"</td><td>"+data.results.bindings[i].title.value+"</td><td><input type=\"text\" name=\"old-"+i+"\" size=\"30\" value=\""+data.results.bindings[i].uri.value+"\" readonly=\"readonly\"/></td><td><input type=\"text\"  size=\"30\" name=\new-"+i+"\" value=\""+data.results.bindings[i].uri.value+"\"/></td></tr>");
      }
}