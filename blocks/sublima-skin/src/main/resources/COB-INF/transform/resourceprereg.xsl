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
        xmlns:foaf="http://xmlns.com/foaf/0.1/"
        xmlns:sparql="http://www.w3.org/2005/sparql-results#"
        xmlns:i18n="http://apache.org/cocoon/i18n/2.1"
        xmlns:url="http://whatever/java/java.net.URLDecoder"
        xmlns="http://www.w3.org/1999/xhtml"
        exclude-result-prefixes="url"
        version="1.0">

  <xsl:import href="controlbutton.xsl"/>

  <xsl:param name="baseurl"/>
  <xsl:param name="interface-language">no</xsl:param>
  <xsl:template match="c:resourceprereg" mode="resourceprereg">

    <form action="{$baseurl}/admin/ressurser/checkurl" method="POST" onsubmit="urlEncode();">
      <xsl:call-template name="hidden-locale-field"/>
      <table>
        <tr>
          <td>
            <label for="sub:url"><i18n:text key="url">URL</i18n:text></label>
          </td>
          <td>
            <input id="sub:url" type="text" name="sub:url" size="40"
                   value="{url:decode(./c:tempvalues/c:tempvalues/sub:url)}"/>
          </td>
        </tr>
        <tr>
          <td>

            <xsl:call-template name="controlbutton">
              <xsl:with-param name="privilege">resource.edit</xsl:with-param>
              <xsl:with-param name="buttontext"><i18n:text key="button.next">Neste</i18n:text></xsl:with-param>
            </xsl:call-template>

          </td>
          <td>
          </td>
        </tr>
      </table>
    </form>

      <script type="text/javascript">
        function urlEncode() {
            var resource = document.getElementById("sub:url").value;
            resource = resource.replace(" ", "%20");
            resource = resource.replace("ø", "%C3%B8");
            resource = resource.replace("æ", "%C3%A6");
            resource = resource.replace("å", "%C3%A5");
            resource = resource.replace("à", "%C3%A0");
            resource = resource.replace("è", "%C3%A8");
            resource = resource.replace("ì", "%C3%AC");
            resource = resource.replace("ò", "%C3%B2");
            resource = resource.replace("á", "%C3%A1");
            resource = resource.replace("é", "%C3%A9");
            resource = resource.replace("í", "%C3%AD");
            resource = resource.replace("ó", "%C3%B3");
            resource = resource.replace("ä", "%C3%A4");
            resource = resource.replace("ë", "%C3%AB");
            resource = resource.replace("ï", "%C3%AF");
            resource = resource.replace("ö", "%C3%B6");
            resource = resource.replace("ü", "%C3%BC");
            resource = resource.replace("ú", "%C3%BA");
            resource = resource.replace("ù", "%C3%B9");
            document.getElementById("sub:url").value = resource;
        }
      </script>
  </xsl:template>

</xsl:stylesheet>