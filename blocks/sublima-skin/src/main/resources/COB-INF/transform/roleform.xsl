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
        xmlns:sioc="http://rdfs.org/sioc/ns#"
        xmlns:sparql="http://www.w3.org/2005/sparql-results#"
        xmlns="http://www.w3.org/1999/xhtml"
        version="1.0">
  <xsl:import href="rdfxml2xhtml-deflist.xsl"/>
  <xsl:param name="baseurl"/>
  <xsl:param name="interface-language">no</xsl:param>

  <xsl:template match="c:role" mode="roleedit">
    <form action="{$baseurl}/admin/brukere/roller/rolle" method="POST">
      <input type="hidden" name="uri" value="{./c:roledetails/rdf:RDF/sioc:Role/@rdf:about}"/>

      <table>
        <tr>
          <td>
            <label for="rdfs:label">Navn</label>
          </td>
          <td>
            <input id="rdfs:label" type="text" name="rdfs:label" size="40" value="{./c:roledetails/rdf:RDF/sioc:Role/rdfs:label}"/>
          </td>
        </tr>
        <tr>
          <td>Rettigheter</td>
        </tr>
        <tr>
          <td></td>
          <td>Emner</td>
        </tr>
        <tr>
          <td></td>
          <td>
            <xsl:choose>
              <xsl:when test="./c:roleprivilegies/c:privileges/c:privilege = 'topic.edit'">
                <input type="checkbox" name="privileges" value="topic.edit" checked="checked"/>Legge til/Redigere
              </xsl:when>
              <xsl:otherwise>
                <input type="checkbox" name="privileges" value="topic.edit"/>Legge til/Redigere
              </xsl:otherwise>
            </xsl:choose>
          </td>
        </tr>
        <tr>
          <td></td>
          <td>
            <xsl:choose>
              <xsl:when test="./c:roleprivilegies/c:privileges/c:privilege = 'topic.approve'">
                <input type="checkbox" name="privileges" value="topic.approve" checked="checked"/>Godkjenne
              </xsl:when>
              <xsl:otherwise>
                <input type="checkbox" name="privileges" value="topic.approve"/>Godkjenne
              </xsl:otherwise>
            </xsl:choose>


          </td>
        </tr>
        <tr>
          <td></td>
          <td>
            <xsl:choose>
              <xsl:when test="./c:roleprivilegies/c:privileges/c:privilege = 'topic.delete'">
                <input type="checkbox" name="privileges" value="topic.delete" checked="checked"/>Slette
              </xsl:when>
              <xsl:otherwise>
                <input type="checkbox" name="privileges" value="topic.delete"/>Slette
              </xsl:otherwise>
            </xsl:choose>

          </td>
        </tr>
        <tr>
          <td></td>
          <td>Relasjoner</td>
        </tr>
        <tr>
          <td></td>
          <td>
            <xsl:choose>
              <xsl:when test="./c:roleprivilegies/c:privileges/c:privilege = 'relation.edit'">
                <input type="checkbox" name="privileges" value="relation.edit" checked="checked"/>Legge til/Redigere
              </xsl:when>
              <xsl:otherwise>
                <input type="checkbox" name="privileges" value="relation.edit"/>Legge til/Redigere
              </xsl:otherwise>
            </xsl:choose>

          </td>
        </tr>
        <tr>
          <td></td>
          <td>
            <xsl:choose>
              <xsl:when test="./c:roleprivilegies/c:privileges/c:privilege = 'relation.approve'">
                <input type="checkbox" name="privileges" value="relation.approve" checked="checked"/>Legge til/Redigere
              </xsl:when>
              <xsl:otherwise>
                <input type="checkbox" name="privileges" value="relation.approve"/>Godkjenne
              </xsl:otherwise>
            </xsl:choose>

          </td>
        </tr>
        <tr>
          <td></td>
          <td>
            <xsl:choose>
              <xsl:when test="./c:roleprivilegies/c:privileges/c:privilege = 'relation.delete'">
                <input type="checkbox" name="privileges" value="relation.delete" checked="checked"/>Legge til/Redigere
              </xsl:when>
              <xsl:otherwise>
                <input type="checkbox" name="privileges" value="relation.delete"/>Slette
              </xsl:otherwise>
            </xsl:choose>

          </td>
        </tr>
        <tr>
          <td></td>
          <td>Ressurser</td>
        </tr>
        <tr>
          <td></td>
          <td>
            <xsl:choose>
              <xsl:when test="./c:roleprivilegies/c:privileges/c:privilege = 'relation.edit'">
                <input type="checkbox" name="privileges" value="resource.edit" checked="checked"/>Legge til/Redigere
              </xsl:when>
              <xsl:otherwise>
                <input type="checkbox" name="privileges" value="resource.edit"/>Legge til/Redigere
              </xsl:otherwise>
            </xsl:choose>

          </td>
        </tr>
        <tr>
          <td></td>
          <td><input type="checkbox" name="privileges" value="resource.approve"/>Godkjenne
          </td>
        </tr>
        <tr>
          <td></td>
          <td><input type="checkbox" name="privileges" value="resource.delete"/>Slette
          </td>
        </tr>
        <tr>
          <td></td>
          <td>Brukere</td>
        </tr>
        <tr>
          <td></td>
          <td><input type="checkbox" name="privileges" value="user.edit"/>Legge til/Redigere
          </td>
        </tr>
        <tr>
          <td></td>
          <td><input type="checkbox" name="privileges" value="user.approve"/>Godkjenne
          </td>
        </tr>
        <tr>
          <td></td>
          <td><input type="checkbox" name="privileges" value="user.delete"/>Slette
          </td>
        </tr>
        <tr>
          <td></td>
          <td>Roller</td>
        </tr>
        <tr>
          <td></td>
          <td><input type="checkbox" name="privileges" value="role.edit"/>Legge til/Redigere
          </td>
        </tr>
        <tr>
          <td></td>
          <td><input type="checkbox" name="privileges" value="role.approve"/>Godkjenne
          </td>
        </tr>
        <tr>
          <td></td>
          <td><input type="checkbox" name="privileges" value="role.delete"/>Slette
          </td>
        </tr>
        <tr>
          <td></td>
          <td></td>
        </tr>
        <tr>
          <td>
            <input type="submit" value="Lagre rolle"/>
          </td>
          <td>
            <input type="reset" value="Rens skjema"/>
          </td>
        </tr>
      </table>
    </form>

  </xsl:template>

  <xsl:template match="c:role" mode="roletemp">
    <form action="{$baseurl}/admin/brukere/roller/rolle" method="POST">
      <input type="hidden" name="uri" value="{./c:tempvalues/c:tempvalues/rdf:about}"/>
      <table>
        <tr>
          <td>
            <label for="rdfs:label">Navn</label>
          </td>
          <td>
            <input id="rdfs:label" type="text" name="rdfs:label" size="40" value="{./c:tempvalues/c:tempvalues/rdfs:label}"/>
          </td>
        </tr>
        <tr>
          <td>Rettigheter</td>
        </tr>
        <tr>
          <td></td>
          <td>Emner</td>
        </tr>
        <tr>
          <td></td>
          <td><input type="checkbox" name="privileges" value="topic.edit"/>Legge til/Redigere
          </td>
        </tr>
        <tr>
          <td></td>
          <td><input type="checkbox" name="privileges" value="topic.approve"/>Godkjenne
          </td>
        </tr>
        <tr>
          <td></td>
          <td><input type="checkbox" name="privileges" value="topic.delete"/>Slette
          </td>
        </tr>
        <tr>
          <td></td>
          <td>Relasjoner</td>
        </tr>
        <tr>
          <td></td>
          <td><input type="checkbox" name="privileges" value="relation.edit"/>Legge til/Redigere
          </td>
        </tr>
        <tr>
          <td></td>
          <td><input type="checkbox" name="privileges" value="relation.approve"/>Godkjenne
          </td>
        </tr>
        <tr>
          <td></td>
          <td><input type="checkbox" name="privileges" value="relation.delete"/>Slette
          </td>
        </tr>
        <tr>
          <td></td>
          <td>Ressurser</td>
        </tr>
        <tr>
          <td></td>
          <td><input type="checkbox" name="privileges" value="resource.edit"/>Legge til/Redigere
          </td>
        </tr>
        <tr>
          <td></td>
          <td><input type="checkbox" name="privileges" value="resource.approve"/>Godkjenne
          </td>
        </tr>
        <tr>
          <td></td>
          <td><input type="checkbox" name="privileges" value="resource.delete"/>Slette
          </td>
        </tr>
        <tr>
          <td></td>
          <td>Brukere</td>
        </tr>
        <tr>
          <td></td>
          <td><input type="checkbox" name="privileges" value="user.edit"/>Legge til/Redigere
          </td>
        </tr>
        <tr>
          <td></td>
          <td><input type="checkbox" name="privileges" value="user.approve"/>Godkjenne
          </td>
        </tr>
        <tr>
          <td></td>
          <td><input type="checkbox" name="privileges" value="user.delete"/>Slette
          </td>
        </tr>
        <tr>
          <td></td>
          <td>Roller</td>
        </tr>
        <tr>
          <td></td>
          <td><input type="checkbox" name="privileges" value="role.edit"/>Legge til/Redigere
          </td>
        </tr>
        <tr>
          <td></td>
          <td><input type="checkbox" name="privileges" value="role.approve"/>Godkjenne
          </td>
        </tr>
        <tr>
          <td></td>
          <td><input type="checkbox" name="privileges" value="role.delete"/>Slette
          </td>
        </tr>
        <tr>
          <td></td>
          <td></td>
        </tr>
        <tr>
          <td>
            <input type="submit" value="Lagre rolle"/>
          </td>
          <td>
            <input type="reset" value="Rens skjema"/>
          </td>
        </tr>
      </table>
    </form>

  </xsl:template>
</xsl:stylesheet>