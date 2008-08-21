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
        xmlns:i18n="http://apache.org/cocoon/i18n/2.1"
        xmlns:sparql="http://www.w3.org/2005/sparql-results#"
        xmlns="http://www.w3.org/1999/xhtml"
        version="1.0">
  <xsl:import href="rdfxml2xhtml-deflist.xsl"/>
  <xsl:import href="controlbutton.xsl"/>
  <xsl:param name="baseurl"/>
  <xsl:param name="interface-language">no</xsl:param>

  <xsl:template match="c:user" mode="useredit">

    <form action="{$baseurl}/admin/brukere/bruker" method="POST">
      <input type="hidden" name="oldusername" value="{substring-after(./c:userdetails/rdf:RDF/sioc:User/sioc:email/@rdf:resource, 'mailto:')}"/>

      <input type="hidden" name="prefix" value="rdfs: &lt;http://www.w3.org/2000/01/rdf-schema#&gt;"/>
      <input type="hidden" name="prefix" value="rdf: &lt;http://www.w3.org/1999/02/22-rdf-syntax-ns#&gt;"/>
      <input type="hidden" name="prefix" value="sioc: &lt;http://rdfs.org/sioc/ns#&gt;"/>
      <input type="hidden" name="rdf:type" value="http://rdfs.org/sioc/ns#User"/>
      <input type="hidden" name="interface-language" value="{$interface-language}"/>

      <xsl:choose>
        <xsl:when test="./c:userdetails/rdf:RDF/sioc:User/@rdf:about">
          <input type="hidden" name="the-resource" value="{./c:userdetails/rdf:RDF/sioc:User/@rdf:about}"/>
        </xsl:when>
        <xsl:otherwise>
          <input type="hidden" name="title-field" value="sioc:email"/>
          <input type="hidden" name="subjecturi-prefix" value="user/"/>
        </xsl:otherwise>
      </xsl:choose>

      <table>
        <tr>
          <td>
            <label for="sioc:email"><i18n:text key="email">E-post</i18n:text>(<i18n:text key="username">brukernavn</i18n:text>)</label>
          </td>
          <td>
            <input id="sioc:email" type="text"
                   name="sioc:email" size="40" value="{substring-after(./c:userdetails/rdf:RDF/sioc:User/sioc:email/@rdf:resource, 'mailto:')}">
            </input>

          </td>
        </tr>

        <tr>
          <td>
            <label for="rdfs:label"><i18n:text key="name">Navn</i18n:text></label>
          </td>
          <td>
            <input id="rdfs:label" type="text"
                   name="rdfs:label" size="40"
                   value="{./c:userdetails/rdf:RDF/sioc:User/rdfs:label}"/>
          </td>
        </tr>

        <tr>
          <td>
            <label for="password1"><i18n:text key="password">Passord</i18n:text></label>
          </td>
          <td>
            <input id="password1" type="password"
                   name="password1" size="40"
                   value="passwordplaceholder"/>
          </td>
        </tr>

        <tr>
          <td>
            <label for="password2"><i18n:text key="repeat">Gjenta</i18n:text><xsl:text> </xsl:text><i18n:text key="password">passord</i18n:text></label>
          </td>
          <td>
            <input id="password2" type="password"
                   name="password2" size="40"
                   value="passwordplaceholder"/>
          </td>
        </tr>

        <tr>
            <td>
              <label for="sioc:has_function"><i18n:text key="role">Rolle</i18n:text></label>
            </td>
            <td>
              <select id="sioc:has_function"
                      name="sioc:has_function">
                <xsl:for-each select="/c:page/c:content/c:user/c:allroles/rdf:RDF/sioc:Role">
                  <xsl:sort select="./rdfs:label"/>
                  <xsl:choose>
                    <xsl:when
                            test="./@rdf:about = /c:page/c:content/c:user/c:userdetails/rdf:RDF/sioc:User/sioc:has_function/@rdf:resource">
                      <option value="{./@rdf:about}" selected="selected">
                        <xsl:value-of select="./rdfs:label"/>
                      </option>
                    </xsl:when>
                    <xsl:otherwise>
                      <option value="{./@rdf:about}">
                        <xsl:value-of select="./rdfs:label"/>
                      </option>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:for-each>
              </select>
            </td>
        </tr>
        <tr>
          <td></td>
          <td></td>
        </tr>
        <tr>
          <td>
           <xsl:call-template name="controlbutton">
              <xsl:with-param name="privilege">user.edit</xsl:with-param>
              <xsl:with-param name="buttontext"><i18n:text key="button.saveuser">Lagre bruker</i18n:text></xsl:with-param>
            </xsl:call-template>
          </td>
          <td>
 
          </td>
        </tr>
      </table>
    </form>

  </xsl:template>

  <xsl:template match="c:user" mode="usertemp">

    <form action="{$baseurl}/admin/brukere/bruker" method="POST">
      <input type="hidden" name="uri" value="{./c:tempvalues/c:tempvalues/rdf:about}"/>
      <input type="hidden" name="oldusername" value="{./c:tempvalues/c:tempvalues/c:oldusername}"/>
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
            <td>
              <label for="sioc:has_function">Rolle</label>
            </td>
            <td>
              <select id="sioc:has_function"
                      name="sioc:has_function">
                <xsl:for-each select="/c:page/c:content/c:user/c:allroles/rdf:RDF/sioc:Role">
                  <xsl:sort select="./rdfs:label"/>
                  <xsl:choose>
                    <xsl:when
                            test="./@rdf:about = /c:page/c:content/c:user/c:tempvalues/c:tempvalues/sioc:has_function">
                      <option value="{./@rdf:about}" selected="selected">
                        <xsl:value-of select="./rdfs:label"/>
                      </option>
                    </xsl:when>
                    <xsl:otherwise>
                      <option value="{./@rdf:about}">
                        <xsl:value-of select="./rdfs:label"/>
                      </option>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:for-each>
              </select>
            </td>
        </tr>

        <tr>
          <td></td>
          <td></td>
        </tr>
        <tr>
          <td>
             <xsl:call-template name="controlbutton">
                        <xsl:with-param name="privilege">user.edit</xsl:with-param>
                        <xsl:with-param name="buttontext">Lagre bruker</xsl:with-param>
                      </xsl:call-template>
          </td>
          <td>

          </td>
        </tr>
      </table>
    </form>

  </xsl:template>
</xsl:stylesheet>