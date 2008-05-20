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

  <xsl:template match="c:user" mode="useredit">

    <form action="{$baseurl}/admin/brukere/bruker" method="POST">
      <input type="hidden" name="uri" value="{./c:userdetails/rdf:RDF/sioc:User/@rdf:about}"/>
      <table>
        <tr>
          <td>
            <label for="sioc:email">E-post (brukernavn)</label>
          </td>
          <td>
            <input id="sioc:email" type="text"
                   name="sioc:email" size="40"
                   value="{./c:userdetails/rdf:RDF/sioc:User/sioc:email/@rdf:resource}"/>
          </td>
        </tr>

        <tr>
          <td>
            <label for="rdfs:label">Navn</label>
          </td>
          <td>
            <input id="rdfs:label" type="text"
                   name="rdfs:label" size="40"
                   value="{./c:userdetails/rdf:RDF/sioc:User/rdfs:label}"/>
          </td>
        </tr>

        <tr>
          <td>
            <label for="password1">Passord</label>
          </td>
          <td>
            <input id="password1" type="password"
                   name="password1" size="40"
                   value="passwordplaceholder"/>
          </td>
        </tr>

        <tr>
          <td>
            <label for="password2">Gjenta passord</label>
          </td>
          <td>
            <input id="password2" type="password"
                   name="password2" size="40"
                   value="passwordplaceholder"/>
          </td>
        </tr>

        <tr>
          <td></td>
          <td></td>
        </tr>
        <tr>
          <td>
            <input type="submit" value="Lagre emne"/>
          </td>
          <td>
            <input type="reset" value="Rens skjema"/>
          </td>
        </tr>
      </table>
    </form>

  </xsl:template>

  <xsl:template match="c:user" mode="usertemp">

    <form action="{$baseurl}/admin/brukere/bruker" method="POST">
      <input type="hidden" name="uri" value="{./c:tempvalues/c:tempvalues/rdf:about}"/>
      <table>
        <tr>
          <td>
            <label for="sioc:email">E-post (brukernavn)</label>
          </td>
          <td>
            <input id="sioc:email" type="text"
                   name="sioc:email" size="40"
                   value="{./c:tempvalues/c:tempvalues/sioc:email}"/>
          </td>
        </tr>

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
          <td>
            <label for="password1">Passord</label>
          </td>
          <td>
            <input id="password1" type="password"
                   name="password1" size="40"
                   />
          </td>
        </tr>

        <tr>
          <td>
            <label for="password2">Gjenta passord</label>
          </td>
          <td>
            <input id="password2" type="password"
                   name="password2" size="40"
                   />
          </td>
        </tr>

        <tr>
          <td></td>
          <td></td>
        </tr>
        <tr>
          <td>
            <input type="submit" value="Lagre emne"/>
          </td>
          <td>
            <input type="reset" value="Rens skjema"/>
          </td>
        </tr>
      </table>
    </form>

  </xsl:template>
</xsl:stylesheet>