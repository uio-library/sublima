<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
        xmlns:lingvoj="http://www.lingvoj.org/ontology#"
        xmlns:wdr="http://www.w3.org/2007/05/powder#"
        xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
        xmlns:c="http://xmlns.computas.com/cocoon"
        xmlns:skos="http://www.w3.org/2004/02/skos/core#"
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
        xmlns:sub="http://xmlns.computas.com/sublima#"
        xmlns:dct="http://purl.org/dc/terms/"
        xmlns:foaf="http://xmlns.com/foaf/0.1/"
        xmlns:i18n="http://apache.org/cocoon/i18n/2.1"
        xmlns:sparql="http://www.w3.org/2005/sparql-results#"
        xmlns="http://www.w3.org/1999/xhtml" version="1.0">
  <xsl:import href="rdfxml2xhtml-deflist.xsl"/>
  <xsl:import href="controlbutton.xsl"/>
  <xsl:import href="addinputfield_templates.xsl"/>
  <xsl:import href="addinputfield_script.xsl"/>
  
  <xsl:param name="baseurl"/>
  <xsl:param name="interface-language">no</xsl:param>

  <xsl:template match="c:publisherdetails">

    <xsl:call-template name="addinputfieldtemplates">
      <xsl:with-param name="uid">publisher</xsl:with-param>
      <xsl:with-param name="interface-language" select="$interface-language"/>
      <xsl:with-param name="values">publishervalues</xsl:with-param>
      <xsl:with-param name="template">publishertemplate</xsl:with-param>
      <xsl:with-param name="name">foaf:name</xsl:with-param>
      <xsl:with-param name="i18nkey">name</xsl:with-param>
      <xsl:with-param name="i18ntext">Navn</xsl:with-param>
    </xsl:call-template>

    <script type="text/javascript">

      // Hook up the add button handler.
      $(
      function(){

        <xsl:call-template name="addinputfieldscript">
          <xsl:with-param name="uid">publisher</xsl:with-param>
          <xsl:with-param name="values">publishervalues</xsl:with-param>
          <xsl:with-param name="template">publishertemplate</xsl:with-param>
          <xsl:with-param name="count" select="count(//foaf:name)+2"/>
          <xsl:with-param name="linkid">addpublisher</xsl:with-param>
          <xsl:with-param name="appendto">addpublisherbefore</xsl:with-param>
        </xsl:call-template>
       
        }
      );
    </script>

    <form action="{$baseurl}/admin/utgivere/ny" method="POST">

      <input type="hidden" name="prefix" value="skos: &lt;http://www.w3.org/2004/02/skos/core#&gt;"/>
      <input type="hidden" name="prefix" value="rdfs: &lt;http://www.w3.org/2000/01/rdf-schema#&gt;"/>
      <input type="hidden" name="prefix" value="wdr: &lt;http://www.w3.org/2007/05/powder#&gt;"/>
      <input type="hidden" name="prefix" value="lingvoj: &lt;http://www.lingvoj.org/ontology#&gt;"/>
      <input type="hidden" name="prefix" value="dct: &lt;http://purl.org/dc/terms/&gt;"/>
      <input type="hidden" name="prefix" value="rdf: &lt;http://www.w3.org/1999/02/22-rdf-syntax-ns#&gt;"/>
      <input type="hidden" name="prefix" value="sub: &lt;http://xmlns.computas.com/sublima#&gt;"/>
      <input type="hidden" name="prefix" value="foaf: &lt;http://xmlns.com/foaf/0.1/&gt;"/>
      <input type="hidden" name="rdf:type" value="http://xmlns.com/foaf/0.1/Agent"/>
      <input type="hidden" name="interface-language" value="{$interface-language}"/>
      <xsl:call-template name="hidden-locale-field"/>

      <xsl:choose>
        <xsl:when test="//foaf:Agent/@rdf:about">
          <input type="hidden" name="the-resource" value="{//foaf:Agent/@rdf:about}"/>
        </xsl:when>
        <xsl:otherwise>
          <input type="hidden" name="title-field" value="foaf:name-1"/>
          <input type="hidden" name="subjecturi-prefix" value="agent/"/>
        </xsl:otherwise>
      </xsl:choose>

      <table>
        <tr>
          <th scope="col"/>
          <th scope="col"/>
          <th scope="col">
            <i18n:text key="language">Språk</i18n:text>
          </th>
        </tr>
        <xsl:for-each select="//foaf:name">
          <xsl:call-template name="labels">
            <xsl:with-param name="label">
              <i18n:text key="title">Navn</i18n:text>
            </xsl:with-param>
            <xsl:with-param name="value" select="."/>
            <xsl:with-param name="default-language" select="@xml:lang"/>
            <xsl:with-param name="field">
              <xsl:text>foaf:name-</xsl:text>
              <xsl:value-of select="position()"/>
            </xsl:with-param>
            <xsl:with-param name="type">text</xsl:with-param>
          </xsl:call-template>
        </xsl:for-each>

        <xsl:call-template name="labels">
          <xsl:with-param name="label">
            <i18n:text key="title">Navn</i18n:text>
          </xsl:with-param>
          <xsl:with-param name="default-language" select="$interface-language"/>
          <xsl:with-param name="field">
            <xsl:text>foaf:name-</xsl:text>
            <xsl:value-of select="count(//foaf:name)+1"/>
          </xsl:with-param>
          <xsl:with-param name="type">text</xsl:with-param>
        </xsl:call-template>

        <tr id="addpublisherbefore">
          <td/>
          <td/>
          <td><a id="addpublisher"><i18n:text key="addpublisher">Legg til utgiver</i18n:text></a></td>
        </tr>

        <tr>
          <td>
            <label for="dct:description">
              <i18n:text key="description">Beskrivelse</i18n:text>
            </label>
          </td>
          <td>
            <textarea id="dct:description" name="dct:description" rows="6" cols="40">
              <xsl:value-of
                      select="//foaf:Agent/dct:description"/>
              <xsl:text> </xsl:text>
            </textarea>
          </td>
        </tr>
        <tr>
          <td></td>
          <td>
            <xsl:call-template name="controlbutton">
              <xsl:with-param name="privilege">publisher.edit</xsl:with-param>
              <xsl:with-param name="buttontext">button.savepublisher</xsl:with-param>
            </xsl:call-template>
            <xsl:call-template name="controlbutton">
              <xsl:with-param name="privilege">publisher.delete</xsl:with-param>
              <xsl:with-param name="buttontext">button.deletepublisher</xsl:with-param>
              <xsl:with-param name="buttonname">actionbuttondelete</xsl:with-param>
            </xsl:call-template>
          </td>
        </tr>
      </table>
    </form>
    <br/>
    <h4>
      <i18n:text key="admin.publisher.resources">Ressurser tilknyttet utgiveren</i18n:text>
    </h4>

    <xsl:apply-templates select="./rdf:RDF" mode="results"/>

  </xsl:template>
</xsl:stylesheet>