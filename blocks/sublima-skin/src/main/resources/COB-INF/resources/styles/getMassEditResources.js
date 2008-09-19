function getResources() {
  sparqlquery = 'PREFIX dct: <http://purl.org/dc/terms/>\nPREFIX sub: <http://xmlns.computas.com/sublima#>\nPREFIX xsd:    <http://www.w3.org/2001/XMLSchema#>\nSELECT ?uri ?title WHERE \n{ ?uri dct:title ?title ;\n   a sub:Resource  .\n   FILTER regex(xsd:string(?uri), "'+document.getElementById("selectregex").value+'", "i")\n} ORDER BY xsd:string(?uri)';
  $().ajaxStart($.blockUI).ajaxStop($.unblockUI);
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
  var regex = new RegExp(document.getElementById("selectregex").value, 'i');
  patternout = document.getElementById("selectpattern").value;
  $("#my-table tbody tr").remove();
  $("#resources-to-modify").removeAttr("style");
  for (var i = 0 ; i < data.results.bindings.length; i++) {
    oldurl = data.results.bindings[i].uri.value;
    newurl = oldurl.replace(regex, patternout);
    $("#my-table tbody").append("<tr><td>"+ (i+1) +"</td><td>"+data.results.bindings[i].title.value+"</td><td><input type=\"text\" name=\"old-"+i+"\" size=\"40\" value=\""+oldurl+"\" readonly=\"readonly\"/></td><td><input type=\"text\"  size=\"40\" name=\"new-"+i+"\" value=\""+newurl+"\"/></td></tr>");
  }
}