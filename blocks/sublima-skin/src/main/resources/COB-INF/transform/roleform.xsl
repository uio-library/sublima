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
            <input id="rdfs:label" type="text"
                   name="rdfs:label" size="40"
                   value="{./c:userdetails/rdf:RDF/sioc:Role/rdfs:label}"/>
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
          <td><input type="checkbox" name="topic.edit"/>Legge til/Redigere</td>
        </tr>
        <tr>
          <td></td>
          <td><input type="checkbox" name="topic.approve"/>Godkjenne</td>
        </tr>
        <tr>
          <td></td>
          <td><input type="checkbox" name="topic.delete"/>Slette</td>
        </tr>
        <tr>
          <td></td>
          <td>Relasjoner</td>
        </tr>
        <tr>
          <td></td>
          <td><input type="checkbox" name="relation.edit"/>Legge til/Redigere</td>
        </tr>
        <tr>
          <td></td>
          <td><input type="checkbox" name="relation.approve"/>Godkjenne</td>
        </tr>
        <tr>
          <td></td>
          <td><input type="checkbox" name="relation.delete"/>Slette</td>
        </tr>
        <tr>
          <td></td>
          <td>Ressurser</td>
        </tr>
        <tr>
          <td></td>
          <td><input type="checkbox" name="resource.edit"/>Legge til/Redigere</td>
        </tr>
        <tr>
          <td></td>
          <td><input type="checkbox" name="resource.approve"/>Godkjenne</td>
        </tr>
        <tr>
          <td></td>
          <td><input type="checkbox" name="resource.delete"/>Slette</td>
        </tr>
        <tr>
          <td></td>
          <td>Brukere</td>
        </tr>
        <tr>
          <td></td>
          <td><input type="checkbox" name="user.edit"/>Legge til/Redigere</td>
        </tr>
        <tr>
          <td></td>
          <td><input type="checkbox" name="user.approve"/>Godkjenne</td>
        </tr>
        <tr>
          <td></td>
          <td><input type="checkbox" name="user.delete"/>Slette</td>
        </tr>
        <tr>
          <td></td>
          <td>Roller</td>
        </tr>
        <tr>
          <td></td>
          <td><input type="checkbox" name="role.edit"/>Legge til/Redigere</td>
        </tr>
        <tr>
          <td></td>
          <td><input type="checkbox" name="role.approve"/>Godkjenne</td>
        </tr>
        <tr>
          <td></td>
          <td><input type="checkbox" name="role.delete"/>Slette</td>
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
            <input id="rdfs:label" type="text"
                   name="rdfs:label" size="40"
                   value="{./c:tempvalues/c:tempvalues/rdfs:label}"/>
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