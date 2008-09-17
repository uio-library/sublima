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
    <script type="text/javascript" src="styles/getMassEditResources.js"/>
    <script type="text/javascript">var dummy = null;</script>
    <script src="styles/jquery.blockUI.js" type="text/javascript"/>

     <form action="">
       <fieldset>
	 <table>
	   <tr>
	     <th>Regular Expression</th>
	     <th>Pattern</th>
	     <th></th>
	   </tr>
	   <tr>
	     <td>
	       <input id="selectregex" name="selectregex" type="text" />
	     </td>
	     <td>
	       <input id="selectpattern" name="selectpattern" type="text" />
	     </td>
	     <td>
	       <input type="button" name="query" value="Get resources" onClick="getResources()"/>
	     </td>
	   </tr>
	 </table>
       </fieldset>
     </form>

     <form style="display:none" action="" method="POST" id="resources-to-modify">

       <table id="my-table">
	 <thead>
	   <tr>
	     <th>Id</th>
	     <th>Tittel</th>
	     <th>Gammel URL</th>
	     <th>Ny URL</th>
	   </tr>
	 </thead>
	 <tbody>
	   
	 </tbody>
       </table>

       <input type="submit" value="Change all URLs"/>

     </form>


  </xsl:template>


</xsl:stylesheet>