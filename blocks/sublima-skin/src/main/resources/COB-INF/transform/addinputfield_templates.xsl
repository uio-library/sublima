<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns="http://www.w3.org/1999/xhtml"
        xmlns:i18n="http://apache.org/cocoon/i18n/2.1"
        xmlns:c="http://xmlns.computas.com/cocoon"
        xmlns:lingvoj="http://www.lingvoj.org/ontology#"
        xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
        xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
        version="1.0">
  <xsl:import href="rdfxml2html-lang-dropdown.xsl"/>

  <xsl:template name="addinputfieldtemplates">
    <xsl:param name="interface-language"/>
    <xsl:param name="uid"/>
    <xsl:param name="values"/>
    <xsl:param name="template"/>
    <xsl:param name="name"/>
    <xsl:param name="i18nkey"/>
    <xsl:param name="i18ntext"/>

    <textarea rows="5" cols="40"
              id="{$values}"
              style="display: none;">
      {
      count: intCount<xsl:value-of select="$uid"/>,
      name: "<xsl:value-of select="$name"/>",
      }
    </textarea>

    <textarea rows="5" cols="40"
              id="{$template}"
              style="display: none;">
      &lt;tr&gt;
      &lt;th scope="row"&gt;
      &lt;label for="{name}-{count}"&gt;&lt;i18n:text key="<xsl:value-of select="$i18nkey"/>"&gt;<xsl:value-of select="$i18ntext"/>&lt;/i18n:text&gt;&lt;/label&gt;
      &lt;/th&gt;
      &lt;td&gt;
      &lt;input value="" size="20" name="{name}-{count}" type="text" id="{name}-{count}"/&gt;
      &lt;/td&gt;
      &lt;td&gt;
      &lt;select name="{name}-{count}"&gt;

      <xsl:apply-templates select="/c:page/c:content/c:allanguages/rdf:RDF/lingvoj:Lingvo" mode="list-options">
        <xsl:with-param name="default-language" select="$interface-language"/>
        <xsl:sort lang="{$interface-language}" select="./rdfs:label[@xml:lang=$interface-language]"/>
      </xsl:apply-templates>

      &lt;/select&gt;
      &lt;/td&gt;
      &lt;/tr&gt;

    </textarea>

  </xsl:template>
</xsl:stylesheet>

