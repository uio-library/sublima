<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
        xmlns:lingvoj="http://www.lingvoj.org/ontology#"
        xmlns:wdr="http://www.w3.org/2007/05/powder#"
        xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
        xmlns:c="http://xmlns.computas.com/cocoon"
        xmlns:skos="http://www.w3.org/2004/02/skos/core#"
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
        xmlns:dct="http://purl.org/dc/terms/"
        xmlns:sub="http://xmlns.computas.com/sublima#"
        xmlns:i18n="http://apache.org/cocoon/i18n/2.1"
        xmlns:foaf="http://xmlns.com/foaf/0.1/"
        xmlns:sq="http://www.w3.org/2005/sparql-results#"
        xmlns="http://www.w3.org/1999/xhtml"
        version="1.0">

  <xsl:template match="c:massediting">
    <script src="styles/jquery.tablelib.js" type="text/javascript" />
    <script type="text/javascript">var dummy = null;</script>
    <script src="styles/iterators.js" type="text/javascript" />
    <script type="text/javascript">var dummy = null;</script>
    <script type="text/javascript" src="styles/getMassEditResources.js"/>
    <script type="text/javascript">
       function createTable(data) {
//         alert("foo" + data.results.bindings[1].uri.value);

           var j = data.results.bindings.length();
           for (var i = 0 ; i &lt; j; i++) {
	     $("#my-table tbody").append("<tr><td>"+data.results.bindings[i].uri.value+"</td><td>"+data.results.bindings[1].title.value+"</td></tr>");
	   }
     }
     </script>

     <form action="foo">
       <fieldset>
	 <input type="text" name="selectregex"/>
	 <input type="button" name="query" value="Get resources" onClick="getResources()"/>
       </fieldset>
     </form>

     <table id="my-table">
       <thead>
	 <tr>
	   <th>Gammel URL</th>
	   <th>Tittel</th>
	   <th>Ny URL</th>
	 </tr>
       </thead>
       <tbody>
	 
       </tbody>
     </table>


     <form action="" method="POST" id="resources-to-modify">

     </form>


  </xsl:template>


</xsl:stylesheet>