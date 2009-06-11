<?xml version="1.0"?>
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
  xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
  xmlns:dct="http://purl.org/dc/terms/"
  xmlns:owl="http://www.w3.org/2002/07/owl#"
  xmlns:foaf="http://xmlns.com/foaf/0.1/"
  xmlns:sub="http://xmlns.computas.com/sublima#"
  xmlns:sioc="http://rdfs.org/sioc/ns#"
  xmlns:lingvoj="http://www.lingvoj.org/ontology#"
  xmlns:wdr="http://www.w3.org/2007/05/powder#"
  xmlns:i18n="http://apache.org/cocoon/i18n/2.1"
  xmlns:skos="http://www.w3.org/2004/02/skos/core#"
  xmlns:c="http://xmlns.computas.com/cocoon"
  xmlns="http://www.w3.org/1999/xhtml"
  exclude-result-prefixes="rdf rdfs dct foaf sub sioc lingvoj wdr"
  >


  <!-- This is a recursive template, so that there is just a single
       skos:Concept template, which calls itself to format the label.
       It takes a single parameter "role", which when set to
       "this-param" will cause the template to behave is if this
       particular concept is the main concept, e.g. is the concept of
       the page that you are on. To this concept, synonyms, broader
       and other relations are attached. Then, the template continues
       to recurse into the linked concepts.
  -->
  <xsl:template match="skos:Concept">
    <xsl:param name="role"/>
    <!-- uri is the URI of the concept we are on -->
    <xsl:variable name="uri" select="@rdf:about"/>
    <!-- The following deals mostly with the labels of Semantic
	 Relations, not the labels of the concepts.
	 First, we will find the label of relation that is a
	 direct child node of the node that we are on, e.g. we
	 have /skos:Concept/skos:broader/skos:Concept, we'd like
	 the label of skos:broader.
	 Then, we continue to iterate over all relations that are
	 not a child node of the current concept.
    -->
    <!-- label-uri will contain the URI of the Semantic Relation,
	 i.e. it has to expand elements like skos:related to a full URI -->
    <xsl:variable name="label-uri"
		  select="concat(namespace-uri(..),
			  local-name(..))"/>
    <!-- Get the label of the Semantic Relation itself, if it
	 exists -->
    <div class="skos:Concept">
      <p>
	<xsl:choose>
	  <xsl:when test="//owl:ObjectProperty[@rdf:about = $label-uri]/rdfs:label[@xml:lang=$interface-language]">
	    <xsl:value-of select="//owl:ObjectProperty[@rdf:about = $label-uri]/rdfs:label[@xml:lang=$interface-language]"/>
	  </xsl:when>
	  <xsl:when test="//owl:SymmetricProperty[@rdf:about = $label-uri]/rdfs:label[@xml:lang=$interface-language]">
	    <xsl:value-of select="//owl:SymmetricProperty[@rdf:about = $label-uri]/rdfs:label[@xml:lang=$interface-language]"/>
	  </xsl:when>
	</xsl:choose>
<!-- Iterate over all relations that has the current URI -->
	<xsl:for-each select="../../*[@rdf:resource = $uri]">
	   <xsl:variable name="label2-uri" select="concat(namespace-uri(.), local-name(.))"/>
	   <xsl:choose>
	     <xsl:when test="//owl:ObjectProperty[@rdf:about = $label2-uri]/rdfs:label[@xml:lang=$interface-language]">
	       <xsl:text>,  </xsl:text>
	       <xsl:value-of select="//owl:ObjectProperty[@rdf:about = $label2-uri]/rdfs:label[@xml:lang=$interface-language]"/>
	     </xsl:when>
	     <xsl:when test="//owl:SymmetricProperty[@rdf:about = $label2-uri]/rdfs:label[@xml:lang=$interface-language]">
	       <xsl:text>,  </xsl:text>
	       <xsl:value-of select="//owl:SymmProperty[@rdf:about = $label2-uri]/rdfs:label[@xml:lang=$interface-language]"/>
	     </xsl:when>
	   </xsl:choose>
	</xsl:for-each>

	<xsl:if test="$role!='this-param'">
	  <xsl:text>: </xsl:text>
	 
	</xsl:if>

      </p>

      <!-- Synonyms -->
      <!--xsl:if test="$role='this-param' and skos:altLabel[@xml:lang=$interface-language]">
	<p>
	  <i18n:text key="synonym">Synonym</i18n:text>: <xsl:value-of select="skos:altLabel[@xml:lang=$interface-language]"/>
	</p>
      </xsl:if-->

      <!-- Now, run through all nodes that has skos:Concept as child
	   node. These will be nodes that this concept has a relation
           to. -->

      <!-- We could here also sort by the specific relation, i.e.
      //owl:ObjectProperty|owl:SymmetricProperty[@rdf:about = $label-uri]/rdfs:label[@xml:lang=$interface-language]
      for now sorting alphabetically on all the concepts regardless of relation.
      -->

      
      <xsl:for-each select="/c:page/c:navigation/rdf:RDF/*[rdfs:subPropertyOf/@rdf:resource = 'http://www.w3.org/2004/02/skos/core#semanticRelation']">
	<h4><xsl:value-of select="rdfs:label[@xml:lang=$interface-language]"/></h4>
	<xsl:variable name="label-uri" select="@rdf:about"/>
	<ul>
	  <xsl:for-each select="/c:page/c:navigation/rdf:RDF/skos:Concept/*">
	    <!-- The order isn't entirely predictable
	    <xsl:sort lang="{$interface-language}" select=".//skos:Concept/skos:prefLabel[@xml:lang=$interface-language]"/>
	    -->
	    <xsl:choose>
	      <xsl:when test="$label-uri = concat(namespace-uri(.), local-name(.)) and ./@rdf:resource">
		<xsl:variable name="concept-uri" select="./@rdf:resource"/>
		<xsl:apply-templates select="//skos:Concept[@rdf:about = $concept-uri]" mode="link"/>
	      </xsl:when>
	      <xsl:when test="$label-uri = concat(namespace-uri(.), local-name(.))">
		<xsl:apply-templates select="./skos:Concept" mode="link"/>
	      </xsl:when>
	    </xsl:choose>
	  </xsl:for-each>
	</ul>
      </xsl:for-each>
		      



      <!-- xsl:for-each select="./*/skos:Concept">
	<xsl:sort lang="{$interface-language}" select="//owl:ObjectProperty[@rdf:about = concat(namespace-uri(..), local-name(..))]/rdfs:label[@xml:lang=$interface-language]"/>
	<xsl:sort lang="{$interface-language}" select="skos:prefLabel[@xml:lang=$interface-language]"/>
	<li><xsl:value-of select="//owl:ObjectProperty[@rdf:about = concat(namespace-uri(..), local-name(..))]/rdfs:label[@xml:lang=$interface-language]"/> :

	<xsl:value-of select="concat(namespace-uri(..), local-name(..))"/> :

	<xsl:if test="//*[@rdf:about = concat(namespace-uri(..), local-name(..))]">fpoo :</xsl:if>
	<xsl:value-of select="skos:prefLabel[@xml:lang=$interface-language]"/></li>
      </xsl:for-each -->


    </div>

  </xsl:template>

  <xsl:template match="skos:Concept" mode="link">
    <li><a href="{@rdf:about}.html{$qloc}"><xsl:value-of select="skos:prefLabel[@xml:lang=$interface-language]"/></a></li>
  </xsl:template>

</xsl:stylesheet>