<?xml version="1.0"?>
<xsl:stylesheet version="1.0" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
  xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#" 
  xmlns:dct="http://purl.org/dc/terms/" 
  xmlns:foaf="http://xmlns.com/foaf/0.1/" 
  xmlns:sub="http://xmlns.computas.com/sublima#"
  xmlns:sioc="http://rdfs.org/sioc/ns#"
  xmlns:lingvoj="http://www.lingvoj.org/ontology#"
  xmlns:skos="http://www.w3.org/2004/02/skos/core#"
  xmlns:wdr="http://www.w3.org/2007/05/powder#"
  xmlns:i18n="http://apache.org/cocoon/i18n/2.1"
  xmlns:c="http://xmlns.computas.com/cocoon"
  xmlns="http://www.w3.org/1999/xhtml" 
  exclude-result-prefixes="rdf rdfs dct foaf sub sioc lingvoj wdr skos">

  <xsl:import href="labels.xsl"/>


  <xsl:template match="foaf:Agent|foaf:Person|foaf:Group|foaf:Organization" mode="external-link">
    <xsl:choose>
      <xsl:when test="foaf:homepage">
	<a href="{foaf:homepage/@rdf:resource}"><xsl:value-of select="foaf:name"/></a>
      </xsl:when>
      <xsl:otherwise>
	<xsl:value-of select="foaf:name"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="dct:title" mode="internal-link">
    <a href="{../dct:identifier/@rdf:resource}.html{$qloc}"><xsl:value-of select="."/></a>
  </xsl:template>

  <xsl:template match="dct:title" mode="external-link">
    <a href="{../@rdf:about}"><xsl:value-of select="."/></a>
  </xsl:template>
  
  <xsl:template match="dct:title" mode="description-link">
    <a href="{../dct:identifier/@rdf:resource}.html{$qloc}"><i18n:text key="descriptionlink"/></a>
  </xsl:template>
  
    <!--xsl:template match="dct:title" mode="show-external-link">
    <a href="{../@rdf:about}"><xsl:value-of select="../@rdf:about"/></a>
  </xsl:template-->
  
  <xsl:template match="dct:description">
    <xsl:value-of select="." disable-output-escaping="yes"/>
  </xsl:template>

  <xsl:template match="sub:committer">
    <xsl:value-of select="./sioc:User/rdfs:label"/>
  </xsl:template>

  <xsl:template match="sub:lastApprovedBy">
    <xsl:value-of select="./sioc:User/rdfs:label"/>
  </xsl:template>
  
  <xsl:template match="dct:audience">
    <xsl:value-of select="./dct:AgentClass/rdfs:label[@xml:lang=$interface-language]"/>
  </xsl:template>

  <xsl:template match="dct:dateAccepted|dct:dateSubmitted">
    <xsl:value-of select="substring-before(., 'T')"/>
  </xsl:template>

  <xsl:template match="dct:publisher">
    <xsl:choose>
      <xsl:when test="./@rdf:resource">
	<xsl:variable name="uri" select="./@rdf:resource"/>
	<xsl:apply-templates select="//foaf:Agent[@rdf:about=$uri]|foaf:Person[@rdf:about=$uri]|foaf:Group[@rdf:about=$uri]|foaf:Organization[@rdf:about=$uri]" mode="external-link"/>
      </xsl:when>
      <xsl:otherwise>
	<xsl:apply-templates select="./foaf:Agent|foaf:Person|foaf:Group|foaf:Organization" mode="external-link" />
      </xsl:otherwise>
    </xsl:choose>
    <xsl:text> </xsl:text>
  </xsl:template>


  <!-- The following fields are meant to be in available in all
       languages that has an interface, thus, we need to check the
       interface language here. -->

  <xsl:template match="dct:subject">
   <xsl:choose>
      <xsl:when test="./@rdf:resource">
	<xsl:variable name="uri" select="./@rdf:resource"/>
	<a href="{$uri}.html{$qloc}">
	<xsl:choose>
	  <xsl:when test="//skos:Concept[@rdf:about=$uri]/skos:prefLabel[@xml:lang=$interface-language]">
	    <xsl:value-of select="//skos:Concept[@rdf:about=$uri]/skos:prefLabel[@xml:lang=$interface-language]"/>
	  </xsl:when>
	  <xsl:otherwise>
      <xsl:choose>
        <xsl:when test="$interface-language = 'no'">
          <span class="warning"><i18n:text key="validation.topic.notitle">Emnet mangler tittel på valgt språk</i18n:text></span>
          </xsl:when>
        <xsl:when test="$interface-language = 'nn'">
          <span class="warning"><i18n:text key="validation.topic.notitle">Emnet manglar tittel på valgt språk</i18n:text></span>
          </xsl:when>
        <xsl:when test="$interface-language = 'sv'">
          <span class="warning"><i18n:text key="validation.topic.notitle">Ämnet har inte titel på angivet språk</i18n:text></span>
          </xsl:when>
        <xsl:otherwise>
          <span class="warning"><i18n:text key="validation.topic.notitle">Topic has no title for the selected language</i18n:text></span>
        </xsl:otherwise>
      </xsl:choose>

	  </xsl:otherwise>
	</xsl:choose>
	</a>
      </xsl:when>
      <xsl:when test="./skos:Concept/@rdf:about">
	<a href="{./skos:Concept/@rdf:about}.html{$qloc}">
	<xsl:choose>
	  <xsl:when test="./skos:Concept/skos:prefLabel[@xml:lang=$interface-language]">
	    <xsl:value-of select="./skos:Concept/skos:prefLabel[@xml:lang=$interface-language]"/>
	  </xsl:when>
	  <xsl:otherwise>
      <xsl:choose>
        <xsl:when test="$interface-language = 'no'">
          <span class="warning"><i18n:text key="validation.topic.notitle">Emnet mangler tittel på valgt språk</i18n:text></span>
          </xsl:when>
        <xsl:when test="$interface-language = 'nn'">
          <span class="warning"><i18n:text key="validation.topic.notitle">Emnet manglar tittel på valgt språk</i18n:text></span>
          </xsl:when>
        <xsl:when test="$interface-language = 'sv'">
          <span class="warning"><i18n:text key="validation.topic.notitle">Ämnet har inte titel på angivet språk</i18n:text></span>
          </xsl:when>
        <xsl:otherwise>
          <span class="warning"><i18n:text key="validation.topic.notitle">Topic has no title for the selected language</i18n:text></span>
        </xsl:otherwise>
      </xsl:choose>

	  </xsl:otherwise>
	</xsl:choose>
	</a>
      </xsl:when>
      <xsl:otherwise>
        <xsl:choose>
          <xsl:when test="$interface-language = 'no'">
            <span class="warning"><i18n:text key="validation.topic.notitle">Emnet mangler tittel på valgt språk</i18n:text></span>
            </xsl:when>
          <xsl:when test="$interface-language = 'nn'">
            <span class="warning"><i18n:text key="validation.topic.notitle">Emnet manglar tittel på valgt språk</i18n:text></span>
            </xsl:when>
          <xsl:when test="$interface-language = 'sv'">
            <span class="warning"><i18n:text key="validation.topic.notitle">Ämnet har inte titel på angivet språk</i18n:text></span>
            </xsl:when>
          <xsl:otherwise>
            <span class="warning"><i18n:text key="validation.topic.notitle">Topic has no title for the selected language</i18n:text></span>
          </xsl:otherwise>
        </xsl:choose>

      </xsl:otherwise>
    </xsl:choose>
    <xsl:if test="position() != last()">
      <xsl:text>, </xsl:text>
    </xsl:if>
  </xsl:template>

  <xsl:template match="sub:Audience">
    <xsl:value-of select="./rdfs:label[@xml:lang=$interface-language]"/>
  </xsl:template>

  <xsl:template match="dct:language">
    <xsl:value-of select="./lingvoj:Lingvo/rdfs:label[@xml:lang=$interface-language]"/>
  </xsl:template>

  <xsl:template match="wdr:describedBy">
    <xsl:value-of select="./wdr:DR/rdfs:label[@xml:lang=$interface-language]"/>
  </xsl:template>

  <xsl:template match="dct:type">
    <xsl:value-of select="./dct:MediaType/rdfs:label[@xml:lang=$interface-language]"/>

    <xsl:if test="position() != last()">
      <xsl:text>, </xsl:text>
    </xsl:if>
  </xsl:template>

  <xsl:template match="foaf:Agent|foaf:Person|foaf:Group|foaf:Organization" mode="edit">
    <input type="hidden" name="uri" value="{./@rdf:about}" />


     <xsl:for-each select="./foaf:name">
          <xsl:call-template name="labels">
            <xsl:with-param name="label"><i18n:text key="title">Navn</i18n:text></xsl:with-param>
            <xsl:with-param name="value" select="."/>
            <xsl:with-param name="default-language" select="@xml:lang"/>
            <xsl:with-param name="field"><xsl:text>foaf:name-</xsl:text><xsl:value-of select="position()"/></xsl:with-param>
            <xsl:with-param name="type">text</xsl:with-param>
          </xsl:call-template>
        </xsl:for-each>

        <xsl:call-template name="labels">
          <xsl:with-param name="label"><i18n:text key="title">Navn</i18n:text></xsl:with-param>
          <xsl:with-param name="default-language" select="$interface-language"/>
          <xsl:with-param name="field"><xsl:text>foaf:name-</xsl:text><xsl:value-of select="count(foaf:name)+1"/></xsl:with-param>
          <xsl:with-param name="type">text</xsl:with-param>
        </xsl:call-template>

  </xsl:template>

</xsl:stylesheet>