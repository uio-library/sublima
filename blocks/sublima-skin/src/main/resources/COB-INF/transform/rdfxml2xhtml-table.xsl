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
  xmlns:wdr="http://www.w3.org/2007/05/powder#"
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
	  <xsl:apply-templates select="sub:Resource/dct:title" mode="external-link"/> - <a href="{$baseurl}/admin/ressurser/edit?uri={sub:Resource/@rdf:about}">[Edit]</a>
    </th>
      </tr>
      <tr>
	<th scope="row">
	  Publisert av:
	</th>
	<td>
	  <xsl:apply-templates select="sub:Resource/dct:publisher" mode="external-link" />
	</td>
      </tr>
      <tr>
	<th scope="row">
	  Emner:
	</th>
	<td>
	  <xsl:apply-templates select="sub:Resource/dct:subject"/>
	</td>
      </tr>
      <tr>
	<th scope="row">
	  Beskrivelse
	</th>
	<td>
	  <xsl:apply-templates select="sub:Resource/dct:description"/>
	</td>
      </tr>
      <tr>
	<th scope="row">
	  Redaksjonelt godkjent av:
	</th>
	<td>
	  <xsl:apply-templates select="sub:Resource/sub:committer"/>
	</td>
      </tr>
      <tr>
	<th scope="row">
	  Innsendt dato:
	</th>
	<td>
	  <xsl:apply-templates select="sub:Resource/dct:dateSubmitted"/>
	</td>
      </tr>
     
      <tr>
	<th scope="row">
	  Akseptert dato:
	</th>
	<td>
	  <xsl:apply-templates select="sub:Resource/dct:dateAccepted"/>
	</td>
      </tr>
      <tr>
	<th scope="row">
	  Språk:
	</th>
	<td>
	  <xsl:apply-templates select="sub:Resource/dct:language"/>
	</td>
      </tr>
      <tr>
	<th scope="row">
	  Type:
	</th>
	<td>
	  <xsl:apply-templates select="sub:Resource/dct:type"/>
	</td>
      </tr>
      <tr>
	<th scope="row">
	  Status:
	</th>
	<td>
	  <xsl:apply-templates select="sub:Resource/wdr:describedBy"/>
	</td>
      </tr>
      <tr>
	<th scope="row">
	  Ment for:
	</th>
	<td>
	  <xsl:apply-templates select="sub:Resource/dct:audience" />
	</td>
      </tr>
     
    </table>

    <p>Send inn en kommentar angående denne ressursen</p>
    <form name="resourcecomment" action="resourcecomment" method="GET">
        <input type="hidden" name="uri" value="{sub:Resource/@rdf:about}"/>
      <table>
        <tr>
          <td align="right">
            <label for="email">Din e-post</label>
          </td>
          <td>
            <input id="email" type="text" name="email" size="40"/>
          </td>
        </tr>
        <tr>
          <td align="right">
            <label for="comment">Kommentar</label>
          </td>
          <td>
            <textarea id="comment" name="comment" rows="6" cols="40"> </textarea>
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