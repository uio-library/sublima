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
        xmlns="http://www.w3.org/1999/xhtml"
        version="1.0">

  <xsl:import href="rdfxml-res-templates.xsl"/>
  <xsl:import href="tablesorter.xsl"/>

  <xsl:param name="baseurl"/>
  <xsl:param name="interface-language">no</xsl:param>

  <xsl:template match="c:comments">
    <table id="commentstable">
      <thead>
        <tr>
          <th scope="col">
            <i18n:text key="date">Dato</i18n:text>
          </th>
          <th scope="col">
            <i18n:text key="resource">Ressurs</i18n:text>
          </th>
          <th scope="col">
            <i18n:text key="comment">Kommentar</i18n:text>
          </th>
          <th scope="col">
            <i18n:text key="sender">Avsender</i18n:text>
          </th>
        </tr>
      </thead>
      <tbody>
        <xsl:for-each select="./rdf:RDF//sub:Resource">
          <xsl:sort lang="{$interface-language}" select="//sioc:Item/dct:dateAccepted" order="descending"/>
          <xsl:variable name="resource" select="."/>

          <xsl:for-each select="/c:page/c:content/c:comments/rdf:RDF//sioc:Item">

            <xsl:if test="./sioc:has_owner/@rdf:resource = $resource/@rdf:about or ./sioc:has_owner/sub:Resource/@rdf:about = $resource/@rdf:about">
              <tr>
                <td>
                  <xsl:value-of select="translate(./dct:dateAccepted, 'T', ' ')"/>
                </td>
                <td>
                  <xsl:apply-templates select="$resource/dct:title" mode="internal-link"/>
                </td>
                <td>
                  <xsl:value-of select="./sioc:content"/>
                </td>
                <td>
                  <a href="mailto:{./sioc:has_creator}">
                    <xsl:value-of select="./sioc:has_creator"/>
                  </a>
                </td>
                <td>
                  <i18n:text> - </i18n:text><a href="{$baseurl}/admin/ressurser/kommentarer/slett?uri={./@rdf:about}"><i18n:text key="delete">Slett</i18n:text></a>
                </td>
              </tr>
            </xsl:if>
          </xsl:for-each>
        </xsl:for-each>
      </tbody>
    </table>

    <xsl:call-template name="tablesorter">
      <xsl:with-param name="tableid">#commentstable</xsl:with-param>
    </xsl:call-template>

  </xsl:template>
</xsl:stylesheet>