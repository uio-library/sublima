<?xml version="1.0"?>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:c="http://xmlns.computas.com/cocoon"
                xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
                xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
                xmlns:dct="http://purl.org/dc/terms/"
                xmlns:foaf="http://xmlns.com/foaf/0.1/"
                xmlns:sub="http://xmlns.computas.com/sublima#"
                xmlns:sioc="http://rdfs.org/sioc/ns#"
                xmlns:lingvoj="http://www.lingvoj.org/ontology#"
                xmlns:wdr="http://www.w3.org/2007/05/powder#"
                xmlns:i18n="http://apache.org/cocoon/i18n/2.1"
                xmlns="http://www.w3.org/1999/xhtml"
                xmlns:url="http://whatever/java/java.net.URLEncoder"
                exclude-result-prefixes="rdf rdfs dct foaf sub sioc lingvoj wdr url">
  <xsl:import href="rdfxml-res-templates.xsl"/>
  <xsl:output indent="yes"/>

  <xsl:param name="interface-language">no</xsl:param>
  <xsl:param name="baseurl"/>

  <xsl:template match="rdf:RDF" mode="results-full">
       <xsl:param name="sorting"/>
      <xsl:param name="sortorder">
      <xsl:choose>
        <xsl:when test="$sorting = 'dateAccepted'">descending</xsl:when>
        <xsl:otherwise>ascending</xsl:otherwise>
      </xsl:choose>
    </xsl:param>


    <!-- views -->
    <!-- "just" remove the res-view attribute -->
    <!-- issue: a & is left.... -->
    <xsl:param name="gen-req">
      <xsl:choose>
        <!-- xsl:when test="contains(/c:page/c:facets/c:request/@requesturl, 'res-view=short')">
        <xsl:value-of select="concat(substring-before(/c:page/c:facets/c:request/@requesturl, 'res-view=short'),  substring-after(/c:page/c:facets/c:request/@requesturl, 'res-view=short'))"/>
      </xsl:when -->
        <xsl:when test="contains(/c:page/c:facets/c:request/@requesturl, 'res-view=full')">
          <xsl:value-of
                  select="concat(substring-before(/c:page/c:facets/c:request/@requesturl, 'res-view=full'),  substring-after(/c:page/c:facets/c:request/@requesturl, 'res-view=full'))"/>
        </xsl:when>
        <xsl:when test="contains(/c:page/c:facets/c:request/@requesturl, 'res-view=medium')">
          <xsl:value-of
                  select="concat(substring-before(/c:page/c:facets/c:request/@requesturl, 'res-view=medium'),  substring-after(/c:page/c:facets/c:request/@requesturl, 'res-view=medium'))"/>
        </xsl:when>

        <xsl:otherwise>
          <xsl:value-of select="/c:page/c:facets/c:request/@requesturl"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:param>
    
	<xsl:variable name="loggedin"><xsl:value-of select="//c:loggedin"/></xsl:variable>
	<!-- sort by title by default -->
	<xsl:variable name="sort">
		<xsl:choose>
			<xsl:when test="$sorting = ''">title</xsl:when>		
			<xsl:otherwise><xsl:value-of select="$sorting"/></xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	
    <div id="fullDescribed">
      <xsl:for-each select="sub:Resource"> <!-- The root node for each described resource -->
	<xsl:sort lang="{$interface-language}" select="./*[local-name() = $sort]" order="{$sortorder}"/>
      <br/>
      <table>

        <tr>
	  <th>
	    &#160;
	  </th>
          <th scope="col">
            <xsl:apply-templates select="./dct:title" mode="external-link"/>
            <xsl:if test="$loggedin = 'true'">-
              <a href="{$baseurl}/admin/ressurser/edit?uri={url:encode(./@rdf:about)}{$aloc}">[Edit]</a>
            </xsl:if>
          </th>
        </tr>
        <xsl:if test="./dct:publisher">
          <tr class="fullDescribedRow">
            <th scope="row">
              <i18n:text key="search.result.publishedby">Publisert av</i18n:text>:
            </th>
            <td>
              <xsl:apply-templates select="./dct:publisher"/>
            </td>
          </tr>
        </xsl:if>
        <xsl:if test="./dct:subject">
          <tr>
	    <th scope="row">
              <i18n:text key="topics">Emner</i18n:text>:
            </th>
            <td>
              <xsl:apply-templates select="./dct:subject"/>
            </td>
          </tr>
        </xsl:if>
        <xsl:if test="./dct:description">
          <tr>
            <th scope="row">
              <i18n:text key="description">Beskrivelse</i18n:text>:
            </th>
            <td>
              <xsl:apply-templates select="./dct:description"/>
            </td>
          </tr>
        </xsl:if>
        <xsl:if test="./dct:publisher//dct:description">
        <tr>
          <th scope="row">
            <i18n:text key="publisher.about">Om utgiver:</i18n:text>:
          </th>
          <td>
            <xsl:apply-templates select="./dct:publisher//dct:description"/>
          </td>
        </tr>
       </xsl:if>
        <xsl:if test="./sub:lastApprovedBy">
          <xsl:if test="../../../c:loggedin = 'true'">
          <tr>
            <th scope="row">
              <i18n:text key="admin.approvedby">Redaksjonelt godkjent av</i18n:text>:
            </th>
            <td>
              <xsl:apply-templates select="./sub:lastApprovedBy"/>
            </td>
          </tr>
            </xsl:if>
        </xsl:if>
        <xsl:if test="./dct:dateSubmitted">
          <xsl:if test="../../../c:loggedin = 'true'">
          <tr>
            <th scope="row">
              <i18n:text key="admin.posteddate">Innsendt</i18n:text>:
            </th>
            <td>
              <xsl:apply-templates select="./dct:dateSubmitted"/>
            </td>
          </tr>
            </xsl:if>
        </xsl:if>
        <xsl:if test="./dct:dateAccepted">
          <xsl:if test="../../../c:loggedin = 'true'">
          <tr>
            <th scope="row">
              <i18n:text key="admin.accepteddate">Akseptert</i18n:text>:
            </th>
            <td>
              <xsl:apply-templates select="./dct:dateAccepted"/>
            </td>
          </tr>
            </xsl:if>
        </xsl:if>
        <xsl:if test="./dct:language">
          <tr>
            <th scope="row">
              <i18n:text key="language">Språk</i18n:text>:
            </th>
            <td>
              <xsl:apply-templates select="./dct:language"/>
            </td>
          </tr>
        </xsl:if>
        <xsl:if test="./dct:coverage">
          <tr>
            <th scope="row">
              <i18n:text key="country">Land</i18n:text>:
            </th>
            <td>
              <xsl:apply-templates select="./dct:coverage"/>
            </td>
          </tr>
        </xsl:if>
        <xsl:if test="./dct:type">
          <tr>
            <th scope="row">
              <i18n:text key="type">Type</i18n:text>:
            </th>
            <td>
              <xsl:apply-templates select="./dct:type"/>
            </td>
          </tr>
        </xsl:if>
        <xsl:if test="./wdr:describedBy">
          <xsl:if test="../../../c:loggedin = 'true'">
            <tr>
              <th scope="row">
                <i18n:text key="status">Status</i18n:text>:
              </th>
              <td>
                <xsl:apply-templates select="./wdr:describedBy"/>
              </td>
            </tr>
          </xsl:if>
        </xsl:if>
        <xsl:if test="./dct:audience">
          <tr>
            <th scope="row">
              <i18n:text key="audience">Målgruppe</i18n:text>:
            </th>
            <td>
              <xsl:apply-templates select="./dct:audience"/>
            </td>
          </tr>
        </xsl:if>

      </table>

    </xsl:for-each>
  </div>
  </xsl:template>


</xsl:stylesheet>