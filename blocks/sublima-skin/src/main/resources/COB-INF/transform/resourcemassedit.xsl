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
    <xsl:param name="endpoint"/>
    <!-- problems with self-closing empty script tags in firefox --> 
    <script src="styles/getMassEditResources.js" type="text/javascript">;</script>
    <script type="text/javascript">var dummy = null;</script> 
    <script src="styles/jquery.blockUI.js" type="text/javascript">;</script>

    <p class="instructions">
      <i18n:text key="instructions.regex">
	Her kan man bruke regulære uttrykk slik det er definert av
	JavaScript. I det første feltet skriver man inn uttrykket man
	ønsker skal matche URLen. I det andre feltet hvordan URLen
	skal omformes.
      </i18n:text>
    </p>

     <form action="">
       <xsl:call-template name="hidden-locale-field"/>
       <fieldset>
	 <table>
	   <tr>
	     <th><i18n:text key="regex">Regular Expression</i18n:text></th>
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
	       <input type="button" name="query" value="Get resources" onClick="getResources('{$endpoint}')"/>
	     </td>
	   </tr>
	 </table>
       </fieldset>
     </form>

     <form style="display:none" action="" method="POST" id="resources-to-modify">

       <table id="my-table">
	 <thead>
	   <tr>
	     <th><i18n:text key="id">Id</i18n:text></th>
	     <th><i18n:text key="title">Tittel</i18n:text></th>
	     <th><i18n:text key="oldurl">Gammel URL</i18n:text></th>
	     <th><i18n:text key="newurl">Ny URL</i18n:text></th>
	   </tr>
	 </thead>
	 <tbody>
	   
	 </tbody>
       </table>

       <input type="submit" value="Change all URLs"/>

     </form>


  </xsl:template>


</xsl:stylesheet>