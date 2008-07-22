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

  <xsl:template match="c:advancedsearch" mode="advancedsearch">

    <script type="text/javascript">
        $(document).ready(function(){
          $("#subject").autocomplete("autocomplete", {
            minChars: 3 });
        });
    </script>

    <form action="search-result" method="GET" autocomplete="off">
      <input type="hidden" name="freetext-field" value="dct:title"/>
      <input type="hidden" name="freetext-field" value="dct:subject/all-labels"/>
      <input type="hidden" name="freetext-field" value="dct:description"/>
      <input type="hidden" name="freetext-field" value="dct:publisher/foaf:name"/>

      <input type="hidden" name="prefix" value="dct: &lt;http://purl.org/dc/terms/&gt;"/>
      <input type="hidden" name="prefix" value="foaf: &lt;http://xmlns.com/foaf/0.1/&gt;"/>
      <input type="hidden" name="prefix" value="sub: &lt;http://xmlns.computas.com/sublima#&gt;"/>
      <input type="hidden" name="prefix" value="rdfs: &lt;http://www.w3.org/2000/01/rdf-schema#&gt;"/>

      <table>
        <tr>
          <td align="right">
            <label for="title">Title</label>
          </td>
          <td>
            <input id="title" type="text" name="dct:title" size="20"/>
          </td>
        </tr>
        <tr>
          <td align="right">
            <label for="subject">Subject</label>
          </td>
          <td>
            <input id="subject" type="text" name="dct:subject/all-labels" size="20"/>
          </td>
        </tr>
        <tr>
          <td align="right">
            <label for="description">Description</label>
          </td>
          <td>
            <input id="description" type="text" name="dct:description" size="20"/>
          </td>
        </tr>
        <tr>
          <td align="right">
            <label for="publisher">Publisher</label>
          </td>
          <td>
            <input id="publisher" type="text" name="dct:publisher/foaf:name" size="20"/>
          </td>
        </tr>
        <tr>
          <td align="right">
            <label for="dateAccepted">DateAccepted</label>
          </td>
          <td>
            <input id="dateAccepted" type="text" name="dct:dateAccepted" size="20"/>
          </td>
        </tr>
        <tr>
          <td align="right">
            <label for="dateSubmitted">DateSubmitted</label>
          </td>
          <td>
            <input id="dateSubmitted" type="text" name="dct:dateSubmitted" size="20"/>
          </td>
        </tr>
        <tr>
          <td align="right">
            <label for="type">Type</label>
          </td>
          <td>
            <input id="type" type="text" name="dct:format" size="20"/>
          </td>
        </tr>
        <tr>
          <td align="right">
            <label for="identifier">Identifier</label>
          </td>
          <td>
            <input id="identifier" type="text" name="dct:identifier" size="20"/>
          </td>
        </tr>
        <tr>
          <td align="right">
            <label for="language">Language</label>
          </td>
          <td>
            <input id="language" type="text" name="dct:language/rdfs:label" size="20"/>
          </td>
        </tr>
        <tr>
          <td align="right">
            <label for="audience">Audience</label>
          </td>
          <td>
            <input id="audience" type="text" name="dct:audience/rdfs:label" size="20"/>
          </td>
        </tr>
        <tr>
          <td align="right">
            <label for="committer">Committer</label>
          </td>
          <td>
            <input id="committer" type="text" name="sub:committer/rdfs:label" size="20"/>
          </td>
        </tr>
        <tr>
          <td></td>
          <td>
            <input type="submit" value="Search"/>
          </td>
        </tr>
      </table>
    </form>
  </xsl:template>
</xsl:stylesheet>