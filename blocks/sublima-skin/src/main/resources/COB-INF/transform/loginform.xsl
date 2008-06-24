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
        xmlns:sparql="http://www.w3.org/2005/sparql-results#"
        xmlns="http://www.w3.org/1999/xhtml"
        version="1.0">
    <xsl:param name="baseurl"/>
    <xsl:param name="interface-language">no</xsl:param>

    <xsl:template match="c:login" mode="login">

       <form action="do-login" method="post">
         <table>
           <tr>
             <td>
               <label for="username"><i18n:text key="username">Brukernavn</i18n:text></label>
             </td>
             <td>
               <input type="text" name="username" id="username"/>
             </td>
           </tr>
           <tr>
             <td>
               <label for="password"><i18n:text key="password">Passord</i18n:text></label>
             </td>
             <td>
               <input type="password" name="password" id="password" />
             </td>
           </tr>
           <tr>
             <td>
               <input type="submit" value="admin.login" i18n:attr="value"/>
             </td>
           </tr>
         </table>
      </form>
    </xsl:template>
</xsl:stylesheet>