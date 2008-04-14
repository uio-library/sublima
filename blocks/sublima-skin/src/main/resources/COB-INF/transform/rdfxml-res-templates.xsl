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
  xmlns="http://www.w3.org/1999/xhtml" 
  exclude-result-prefixes="rdf rdfs dct foaf sub sioc lingvoj wdr skos"
  >


  <xsl:template match="foaf:Agent|foaf:Person|foaf:Group|foaf:Organization" mode="external-link">
    <xsl:choose>
      <xsl:when test="foaf:homepage and foaf:name/@xml:lang=$interface-language">
	<a href="{foaf:homepage/@rdf:resource}"><xsl:value-of select="foaf:name"/></a>
      </xsl:when>
      <xsl:otherwise>
	<xsl:value-of select="foaf:name[@xml:lang=$interface-language]"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="dct:title" mode="internal-link">
    <xsl:if test="@xml:lang=$interface-language">
      <a href="{../dct:identifier/@rdf:resource}"><xsl:value-of select="."/></a>
    </xsl:if>
  </xsl:template>

  <xsl:template match="dct:title" mode="external-link">
    <xsl:if test="@xml:lang=$interface-language">
      <a href="{../@rdf:about}"><xsl:value-of select="."/></a>
    </xsl:if>
  </xsl:template>
  
  <xsl:template match="dct:description">
    <xsl:if test="@xml:lang=$interface-language">
      <xsl:copy-of select="node()"/>
    </xsl:if>
  </xsl:template>

  <xsl:template match="sub:committer">
    <xsl:value-of select="./sioc:User/rdfs:label[@xml:lang=$interface-language]"/>
  </xsl:template>
  
  <xsl:template match="dct:audience">
    <xsl:value-of select="./dct:AgentClass/rdfs:label[@xml:lang=$interface-language]"/>
  </xsl:template>

  <xsl:template match="dct:dateAccepted|dct:dateSubmitted">
    <xsl:value-of select="substring-before(., 'T')"/>
  </xsl:template>

  <xsl:template match="dct:subject">
   <xsl:choose>
      <xsl:when test="./@rdf:resource">
	<xsl:variable name="uri" select="./@rdf:resource"/>
	<a href="{$uri}"><xsl:value-of select="//skos:Concept[@rdf:about=$uri]/rdfs:label[@xml:lang=$interface-language]"/></a>
      </xsl:when>
      <xsl:when test="./skos:Concept/@rdf:about">
	<a href="{./skos:Concept/@rdf:about}"><xsl:value-of select="./skos:Concept/rdfs:label[@xml:lang=$interface-language]"/></a>
      </xsl:when>
      <xsl:otherwise>
	<span class="warning">Emne mangler tittel</span>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:if test="position() != last()">
      <xsl:text>, </xsl:text>
    </xsl:if>
  </xsl:template>

  <xsl:template match="dct:publisher">
   <xsl:choose>
      <xsl:when test="./@rdf:resource">
	<xsl:variable name="uri" select="./@rdf:resource"/>
	<xsl:apply-templates select="//foaf:*[@rdf:about=$uri]"/>
      </xsl:when>
      <xsl:otherwise>
	<xsl:apply-templates select="./*" mode="external-link" />
      </xsl:otherwise>
    </xsl:choose>
    <xsl:text> </xsl:text>
  </xsl:template>

  <xsl:template match="sub:Audience">
    <xsl:value-of select="./rdfs:label[@xml:lang=$interface-language]"/>
  </xsl:template>

  <xsl:template match="dct:language">
    <xsl:value-of select="./lingvoj:Lingvo/rdfs:label[@xml:lang=$interface-language]"/>
  </xsl:template>

  <!-- There are two ways to do this; either address a literal, which
       is in the model, or hardcode a value in the XSLT. In most
       cases, we want to keep the values in the database, but there
       might be exceptions. The status of the resource and the type of
       the resource might be such exceptions. In particular, in cases
       where the search interface consists of a drop-down, it has
       performance benefits and makes the query simpler and we don't
       have to search a literal, when the URI rather than the literal
       is searched for. -->

  <xsl:template match="wdr:describedBy">
    <xsl:value-of select="./rdf:Description/rdfs:label[@xml:lang=$interface-language]"/>
  </xsl:template>

  <xsl:template match="dct:type">
    <xsl:choose>
      <xsl:when test="@rdf:resource='http://purl.org/dc/dcmitype/Text'">
	<xsl:choose>
	  <xsl:when test="$interface-language='en'">Text</xsl:when>
	  <xsl:when test="$interface-language='no'">Tekst</xsl:when>
	</xsl:choose>
      </xsl:when>
      <xsl:when test="@rdf:resource='http://purl.org/dc/dcmitype/Image'">
	<xsl:choose>
	  <xsl:when test="$interface-language='en'">Image</xsl:when>
	  <xsl:when test="$interface-language='no'">Bilde</xsl:when>
	</xsl:choose>
      </xsl:when>
      <xsl:when test="@rdf:resource='http://purl.org/dc/dcmitype/Film'">
	<xsl:choose>
	  <xsl:when test="$interface-language='en'">Film</xsl:when>
	  <xsl:when test="$interface-language='no'">Film</xsl:when>
	</xsl:choose>
      </xsl:when>

    </xsl:choose>
    <xsl:if test="position() != last()">
      <xsl:text>, </xsl:text>
    </xsl:if>
  </xsl:template>

  <xsl:template match="foaf:Agent|foaf:Person|foaf:Group|foaf:Organization" mode="edit">
    <input type="hidden" name="uri" value="{./@rdf:about}" />

    <tr>
      <td>Språk</td>
      <td>Navn</td>
    </tr>
    <xsl:for-each select="./foaf:name">
      <tr>
        <td>
          <label for="foaf:Agent/foaf:name@{@xml:lang}"><xsl:value-of select="@xml:lang" /></label>
        </td>
        <td>
          <input id="foaf:Agent/foaf:name@{@xml:lang}" type="text" name="foaf:Agent/foaf:name@{@xml:lang}" size="40">
           <xsl:attribute name="value">
            <xsl:value-of select="."/>
           </xsl:attribute>
          </input>
        </td>
      </tr>
      
    </xsl:for-each>
    <tr>
      <td>
        <input id="new_lang" type="text" name="new_lang" size="5" />
      </td>
      <td>
        <input id="new_name" type="text" name="new_name" size="40" />  
      </td>
    </tr>

  </xsl:template>

</xsl:stylesheet>