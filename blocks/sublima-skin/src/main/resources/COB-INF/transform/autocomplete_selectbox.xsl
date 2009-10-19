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
        xmlns:sioc="http://rdfs.org/sioc/ns#"
        xmlns:mv="http://www.computas.com/mediasone#"
        xmlns:imdb="http://www.csd.abdn.ac.uk/~ggrimnes/dev/imdb/IMDB#"
        xmlns:mo="http://purl.org/ontology/mo#"
        xmlns="http://www.w3.org/1999/xhtml"
        version="1.0">

  <xsl:import href="selectmultiple.xsl"/>

  <xsl:template name="dropdownautocomplete">
    <xsl:param name="select_id"/>
    <xsl:param name="select_name"/>
    <xsl:param name="node"/>
    <xsl:param name="match"/>

    <tr>
      <td valign="top">
        <label for="{$select_id}">
          <!--i18n:text key="{$select_id}">[Must be translated, please note and report]</i18n:text-->
          <xsl:value-of select="./rdfs:label[@xml:lang=$interface-language]"/>
        </label>
      </td>

      <td valign="top">
        <input type="text" id='input_{$select_id}' size="40" onkeypress="return disableEnterKey(event)" />
      </td>

      <td>
        <select name="{$select_name}" class="selectmultiple" multiple="multiple" id="{$select_id}">
          <option/>
          <xsl:for-each select="$node">
            <xsl:sort select="./foaf:name"/>
            <xsl:sort select="./rdfs:label"/>
            <xsl:sort select="./dct:title"/>
            <xsl:sort select="./skos:prefLabel"/>
            <xsl:if test="./@rdf:about = $match">
              <xsl:if test="./foaf:name or ./rdfs:label or ./dct:title or ./skos:prefLabel">
                <option value="{./@rdf:about}">
                  <xsl:choose>
                    <xsl:when test="./foaf:name">
                      <xsl:value-of select="./foaf:name"/>
                    </xsl:when>
                    <xsl:when test="./rdfs:label">
                      <xsl:value-of select="./rdfs:label"/>
                    </xsl:when>
                    <xsl:when test="./skos:prefLabel">
                      <xsl:value-of select="./skos:prefLabel"/>
                    </xsl:when>
                    <xsl:when test="./dct:title">
                      <xsl:choose>
                        <xsl:when test="./mv:musicPerformer/foaf:Agent">
                          <xsl:value-of select="./dct:title"/><xsl:text> - </xsl:text><xsl:value-of select="./mv:musicPerformer/foaf:Agent/foaf:name"/>
                        </xsl:when>
                        <xsl:otherwise>
                          <xsl:value-of select="./dct:title"/>
                        </xsl:otherwise>
                      </xsl:choose>
                    </xsl:when>
                  </xsl:choose>
                </option>
              </xsl:if>
            </xsl:if>
          </xsl:for-each>
        </select>
        <a href="#" id="remove{$select_id}" class="selectmultiplebutton">&lt;&lt; remove</a>
      </td>

    </tr>

    <xsl:call-template name="selectmultiple">
      <xsl:with-param name="selectionid">#<xsl:value-of select="$select_id"/></xsl:with-param>
      <xsl:with-param name="tempid">#temp<xsl:value-of select="$select_id"/></xsl:with-param>
      <xsl:with-param name="position"><xsl:value-of select="$select_id"/></xsl:with-param>
    </xsl:call-template>

  <script type="text/javascript">
    var url = "<xsl:value-of select="$baseurl"/>" + "/autocomplete";
    $(document).ready(function(){
    $("#input_<xsl:value-of select="$select_id"/>").autocomplete(url, {
            max: 50,
            minChars: 2,
            extraParams : { action:"topicvalue", language:"<xsl:value-of select="$interface-language"/>"}
          });

    });

    $("#input_<xsl:value-of select="$select_id"/>").result(function(event, data, formatted) {
        <!-- $("#<xsl:value-of select="$select_id"/>").addOption(data[1], data[0]); -->
        $("#<xsl:value-of select="$select_id"/>").append('<option value="' + data[1] + '">' + data[0] + '</option>');

        $("#input_<xsl:value-of select="$select_id"/>").val('').focus();
    });

    function disableEnterKey(e)
{
     var key;
     if(window.event)
          key = window.event.keyCode; //IE
     else
          key = e.which; //firefox

     return (key != 13);
}

  </script>


  </xsl:template>
</xsl:stylesheet>

