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
  exclude-result-prefixes="rdf rdfs dct foaf sub sioc lingvoj wdr">
  <xsl:import href="rdfxml-res-templates.xsl"/>
  <xsl:output indent="yes"/>

  <xsl:param name="interface-language">no</xsl:param>
  <xsl:param name="baseurl"/>

  <xsl:template match="rdf:RDF" mode="resource">
    <table>
      
      <tr>
	<th colspan="2" scope="col">
	  <xsl:apply-templates select="sub:Resource/dct:title" mode="external-link"/> <xsl:if test="../../c:loggedin = 'true'"> - <a href="{$baseurl}/admin/ressurser/edit?uri={sub:Resource/@rdf:about}{$aloc}">[Edit]</a> </xsl:if>
    </th>
      </tr>
      <tr>
	<th scope="row">
    <i18n:text key="search.result.publishedby">Publisert av</i18n:text>:
	</th>
	<td>
	  <xsl:apply-templates select="sub:Resource/dct:publisher" mode="external-link" />
	</td>
      </tr>
      <tr>
	<th scope="row">
	  <i18n:text key="topics">Emner</i18n:text>:
	</th>
	<td>
	  <xsl:apply-templates select="sub:Resource/dct:subject"/>
	</td>
      </tr>
      <tr>
	<th scope="row">
	  <i18n:text key="description">Beskrivelse</i18n:text>
	</th>
	<td>
	  <xsl:apply-templates select="sub:Resource/dct:description"/>
	</td>
      </tr>
      <tr>
	<th scope="row">
	  <i18n:text key="admin.approvedby">Redaksjonelt godkjent av</i18n:text>:
	</th>
	<td>
	  <xsl:apply-templates select="sub:Resource/sub:committer"/>
	</td>
      </tr>
      <tr>
	<th scope="row">
	  <i18n:text key="admin.posteddate">Innsendt</i18n:text>:
	</th>
	<td>
	  <xsl:apply-templates select="sub:Resource/dct:dateSubmitted"/>
	</td>
      </tr>
     
      <tr>
	<th scope="row">
	  <i18n:text key="admin.accepteddate">Akseptert</i18n:text>:
	</th>
	<td>
	  <xsl:apply-templates select="sub:Resource/dct:dateAccepted"/>
	</td>
      </tr>
      <tr>
	<th scope="row">
	  <i18n:text key="language">Språk</i18n:text>:
	</th>
	<td>
	  <xsl:apply-templates select="sub:Resource/dct:language"/>
	</td>
      </tr>
      <tr>
	<th scope="row">
	  <i18n:text key="type">Type</i18n:text>:
	</th>
	<td>
	  <xsl:apply-templates select="sub:Resource/dct:format"/>
	</td>
      </tr>
      <tr>
	<th scope="row">
	  <i18n:text key="status">Status</i18n:text>:
	</th>
	<td>
	  <xsl:apply-templates select="sub:Resource/wdr:describedBy"/>
	</td>
      </tr>
      <tr>
	<th scope="row">
	  <i18n:text key="audience">Målgruppe</i18n:text>:
	</th>
	<td>
	  <xsl:apply-templates select="sub:Resource/dct:audience" />
	</td>
      </tr>
     
    </table>
    <br/>
    <p><i18n:text key="resource.sendcomment">Send inn en kommentar angående denne ressursen</i18n:text></p>

    <xsl:if test="/c:page/c:content/c:messages/c:messages/c:message">
      <ul>
        <xsl:for-each select="/c:page/c:content/c:messages/c:messages/c:message">
          <li>
            <xsl:value-of select="."/>
            <br/>
          </li>
        </xsl:for-each>
      </ul>
    </xsl:if>
    
    <form action="{$baseurl}/resourcecomment" method="GET">
        <input type="hidden" name="uri" value="{sub:Resource/@rdf:about}"/>
        <input type="hidden" name="resource" value="{sub:Resource/dct:identifier/@rdf:resource}"/>
      <table>
        <tr>
          <td align="right">
            <label for="email"><i18n:text key="email">E-post</i18n:text></label>
          </td>
          <td>
            <input id="email" type="text" name="email" size="40"/>
          </td>
        </tr>
        <tr>
          <td align="right">
            <label for="comment"><i18n:text key="comment">Kommentar</i18n:text></label>
          </td>
          <td>
            <textarea id="comment" name="comment" rows="6" cols="40"><xsl:text> </xsl:text></textarea>
          </td>
        </tr>
        <tr>
          <td></td>
          <td>
            <input type="submit" value="Send inn"/>
          </td>
        </tr>
      </table>
    </form>
  </xsl:template>


</xsl:stylesheet>