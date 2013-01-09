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

  <xsl:template match="rdf:RDF" mode="resource">
    <xsl:call-template name="messages"/>

    <table>

      <tr>
        <td colspan="2" scope="col">
          <xsl:apply-templates select="sub:Resource/dct:title" mode="external-link"/>
          <xsl:if test="../../c:loggedin = 'true'">-
            <a href="{$baseurl}/admin/ressurser/edit?uri={url:encode(sub:Resource/@rdf:about)}{$aloc}">[Edit]</a>
          </xsl:if>
        </td>
      </tr>
      <xsl:if test="sub:Resource/dct:publisher">
        <tr>
          <td scope="row">
            <i18n:text key="search.result.publishedby">Publisert av</i18n:text>:
          </td>
          <td>
            <xsl:apply-templates select="sub:Resource/dct:publisher"/>
          </td>
        </tr>
      </xsl:if>
      <xsl:if test="sub:Resource/dct:subject">
        <tr>
          <td scope="row">
            <i18n:text key="topics">Emner</i18n:text>:
          </td>
          <td>
            <xsl:apply-templates select="sub:Resource/dct:subject"/>
          </td>
        </tr>
      </xsl:if>
      <xsl:if test="sub:Resource/dct:description">
        <tr>
          <td scope="row" valign="top">
            <i18n:text key="description">Beskrivelse</i18n:text>:
          </td>
          <td>
            <xsl:apply-templates select="sub:Resource/dct:description"/>
          </td>
        </tr>
      </xsl:if>
      <xsl:if test="sub:Resource/dct:publisher//dct:description">
        <tr>
          <td scope="row" valign="top">
            <i18n:text key="publisher.about">Om utgiver:</i18n:text>:
          </td>
          <td>
            <xsl:apply-templates select="sub:Resource/dct:publisher//dct:description"/>
          </td>
        </tr>
      </xsl:if>
      <xsl:if test="sub:Resource/sub:lastApprovedBy">
        <xsl:if test="../../c:loggedin = 'true'">
          <tr>
            <td scope="row">
              <i18n:text key="admin.approvedby">Redaksjonelt godkjent av</i18n:text>:
            </td>
            <td>
              <xsl:apply-templates select="sub:Resource/sub:lastApprovedBy"/>
            </td>
          </tr>
        </xsl:if>
      </xsl:if>
      <xsl:if test="sub:Resource/dct:dateSubmitted">
        <xsl:if test="../../c:loggedin = 'true'">
          <tr>
            <td scope="row">
              <i18n:text key="admin.posteddate">Innsendt</i18n:text>:
            </td>
            <td>
              <xsl:apply-templates select="sub:Resource/dct:dateSubmitted"/>
            </td>
          </tr>
        </xsl:if>
      </xsl:if>
      <xsl:if test="sub:Resource/dct:dateAccepted">
        <!--xsl:if test="../../c:loggedin = 'true'"-->
          <tr>
            <td scope="row">
              <i18n:text key="admin.accepteddate">Akseptert</i18n:text>:
            </td>
            <td>
              <xsl:apply-templates select="sub:Resource/dct:dateAccepted"/>
            </td>
          </tr>
        <!--/xsl:if-->
      </xsl:if>
      <xsl:if test="sub:Resource/dct:language">
        <tr>
          <td scope="row">
            <i18n:text key="language">Språk</i18n:text>:
          </td>
          <td>
            <xsl:apply-templates select="sub:Resource/dct:language"/>
          </td>
        </tr>
      </xsl:if>
      <xsl:if test="sub:Resource/dct:type">
        <tr>
          <td scope="row">
            <i18n:text key="type">Type</i18n:text>:
          </td>
          <td>
            <xsl:apply-templates select="sub:Resource/dct:type"/>
          </td>
        </tr>
      </xsl:if>
      <xsl:if test="sub:Resource/wdr:describedBy">
        <xsl:if test="../../c:loggedin = 'true'">
          <tr>
            <td scope="row">
              <i18n:text key="status">Status</i18n:text>:
            </td>
            <td>
              <xsl:apply-templates select="sub:Resource/wdr:describedBy"/>
            </td>
          </tr>
        </xsl:if>
      </xsl:if>
      <xsl:if test="sub:Resource/dct:audience">
        <tr>
          <td scope="row">
            <i18n:text key="audience">Målgruppe</i18n:text>:
          </td>
          <td>
            <xsl:apply-templates select="sub:Resource/dct:audience"/>
          </td>
        </tr>
      </xsl:if>
    </table>
    <br/>

  </xsl:template>


</xsl:stylesheet>
