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
  <xsl:import href="controlbutton.xsl"/>
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
          <td>
            <xsl:choose>
              <xsl:when test="./c:roleprivilegies/c:privileges/c:privilege = 'topic.theme'">
                <input type="checkbox" name="privileges" value="topic.theme" checked="checked"/>Sette temaemner
              </xsl:when>
              <xsl:otherwise>
                <input type="checkbox" name="privileges" value="topic.theme"/>Sette temaemner
              </xsl:otherwise>
            </xsl:choose>
          </td>
        </tr>
        <tr>
          <td></td>
          <td>
            <xsl:choose>
              <xsl:when test="./c:roleprivilegies/c:privileges/c:privilege = 'topic.join'">
                <input type="checkbox" name="privileges" value="topic.join" checked="checked"/>Koble emner
              </xsl:when>
              <xsl:otherwise>
                <input type="checkbox" name="privileges" value="topic.join"/>Koble emner
              </xsl:otherwise>
            </xsl:choose>
          </td>
        </tr>
        <tr>
          <td></td>
          <td>
            <select id="topic.status" name="topic.status" multiple="true">
              <option value=""/>
              <xsl:for-each select="./c:allstatuses/rdf:RDF/wdr:DR">
                  <xsl:sort select="./rdfs:label"/>
                  <xsl:variable name="status">topic.status.<xsl:value-of select="./@rdf:about"/></xsl:variable>
                  <xsl:choose>
                      <xsl:when test="$status = /c:page/c:content/c:role/c:roleprivilegies/c:privileges/c:privilege">
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
                <input type="checkbox" name="privileges" value="relation.approve" checked="checked"/>Godkjenne
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
                <input type="checkbox" name="privileges" value="relation.delete" checked="checked"/>Slette
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
          <td>
            <xsl:choose>
              <xsl:when test="./c:roleprivilegies/c:privileges/c:privilege = 'relation.approve'">
                <input type="checkbox" name="privileges" value="resource.approve" checked="checked"/>Godkjenne
              </xsl:when>
              <xsl:otherwise>
                <input type="checkbox" name="privileges" value="resource.approve"/>Godkjenne
              </xsl:otherwise>
            </xsl:choose>

          </td>
        </tr>
        <tr>
          <td></td>
          <td>
            <xsl:choose>
              <xsl:when test="./c:roleprivilegies/c:privileges/c:privilege = 'relation.delete'">
                <input type="checkbox" name="privileges" value="resource.delete" checked="checked"/>Slette
              </xsl:when>
              <xsl:otherwise>
                <input type="checkbox" name="privileges" value="resource.delete"/>Slette
              </xsl:otherwise>
            </xsl:choose>

          </td>
        </tr>
        <tr>
          <td></td>
          <td>
            <select id="resource.status" name="resource.status" multiple="true">
              <option value=""/>
              <xsl:for-each select="./c:allstatuses/rdf:RDF/wdr:DR">
                  <xsl:sort select="./rdfs:label"/>
                  <xsl:variable name="status">resource.status.<xsl:value-of select="./@rdf:about"/></xsl:variable>
                  <xsl:choose>
                      <xsl:when test="$status = /c:page/c:content/c:role/c:roleprivilegies/c:privileges/c:privilege">
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
          <td>Brukere</td>
        </tr>
        <tr>
          <td></td>
          <td>
            <xsl:choose>
              <xsl:when test="./c:roleprivilegies/c:privileges/c:privilege = 'user.edit'">
                <input type="checkbox" name="privileges" value="user.edit" checked="checked"/>Legge til/Redigere
              </xsl:when>
              <xsl:otherwise>
                <input type="checkbox" name="privileges" value="user.edit"/>Legge til/Redigere
              </xsl:otherwise>
            </xsl:choose>
          </td>
        </tr>
        <tr>
          <td></td>
          <td>
            <xsl:choose>
              <xsl:when test="./c:roleprivilegies/c:privileges/c:privilege = 'user.approve'">
                <input type="checkbox" name="privileges" value="user.approve" checked="checked"/>Godkjenne
              </xsl:when>
              <xsl:otherwise>
                <input type="checkbox" name="privileges" value="user.approve"/>Godkjenne
              </xsl:otherwise>
            </xsl:choose>
          </td>
        </tr>
        <tr>
          <td></td>
          <td>
            <xsl:choose>
              <xsl:when test="./c:roleprivilegies/c:privileges/c:privilege = 'user.delete'">
                <input type="checkbox" name="privileges" value="user.delete" checked="checked"/>Slette
              </xsl:when>
              <xsl:otherwise>
                <input type="checkbox" name="privileges" value="user.delete"/>Slette
              </xsl:otherwise>
            </xsl:choose>
          </td>
        </tr>
        <tr>
          <td></td>
          <td>Roller</td>
        </tr>
        <tr>
          <td></td>
          <td>
            <xsl:choose>
              <xsl:when test="./c:roleprivilegies/c:privileges/c:privilege = 'role.edit'">
                <input type="checkbox" name="privileges" value="role.edit" checked="checked"/>Legge til/Redigere
              </xsl:when>
              <xsl:otherwise>
                <input type="checkbox" name="privileges" value="role.edit"/>Legge til/Redigere
              </xsl:otherwise>
            </xsl:choose>
          </td>
        </tr>
        <tr>
          <td></td>
          <td>
            <xsl:choose>
              <xsl:when test="./c:roleprivilegies/c:privileges/c:privilege = 'role.approve'">
                <input type="checkbox" name="privileges" value="role.approve" checked="checked"/>Godkjenne
              </xsl:when>
              <xsl:otherwise>
                <input type="checkbox" name="privileges" value="role.approve"/>Godkjenne
              </xsl:otherwise>
            </xsl:choose>
          </td>
        </tr>
        <tr>
          <td></td>
          <td>
            <xsl:choose>
              <xsl:when test="./c:roleprivilegies/c:privileges/c:privilege = 'role.delete'">
                <input type="checkbox" name="privileges" value="role.delete" checked="checked"/>Slette
              </xsl:when>
              <xsl:otherwise>
                <input type="checkbox" name="privileges" value="role.delete"/>Slette
              </xsl:otherwise>
            </xsl:choose>
          </td>
        </tr>
        <tr>
          <td></td>
          <td>Utgivere</td>
        </tr>
        <tr>
          <td></td>
          <td>
            <xsl:choose>
              <xsl:when test="./c:roleprivilegies/c:privileges/c:privilege = 'publisher.edit'">
                <input type="checkbox" name="privileges" value="publisher.edit" checked="checked"/>Legge til/Redigere
              </xsl:when>
              <xsl:otherwise>
                <input type="checkbox" name="privileges" value="publisher.edit"/>Legge til/Redigere
              </xsl:otherwise>
            </xsl:choose>
          </td>
        </tr>
        <tr>
          <td></td>
          <td>
            <xsl:choose>
              <xsl:when test="./c:roleprivilegies/c:privileges/c:privilege = 'publisher.delete'">
                <input type="checkbox" name="privileges" value="publisher.delete" checked="checked"/>Slette
              </xsl:when>
              <xsl:otherwise>
                <input type="checkbox" name="privileges" value="publisher.delete"/>Slette
              </xsl:otherwise>
            </xsl:choose>
          </td>
        </tr>
        <tr>
          <td></td>
          <td></td>
        </tr>
        <tr>
          <td>
             <xsl:call-template name="controlbutton">
              <xsl:with-param name="privilege">role.edit</xsl:with-param>
              <xsl:with-param name="buttontext">Lagre rolle</xsl:with-param>
            </xsl:call-template>
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
          <td>
            <xsl:choose>
              <xsl:when test="./c:tempvalues/c:tempvalues/c:privileges/c:privilege = 'topic.edit'">
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
              <xsl:when test="./c:tempvalues/c:tempvalues/c:privileges/c:privilege = 'topic.approve'">
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
              <xsl:when test="./c:tempvalues/c:tempvalues/c:privileges/c:privilege = 'topic.delete'">
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
              <xsl:when test="./c:tempvalues/c:tempvalues/c:privileges/c:privilege = 'relation.edit'">
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
              <xsl:when test="./c:tempvalues/c:tempvalues/c:privileges/c:privilege = 'relation.approve'">
                <input type="checkbox" name="privileges" value="relation.approve" checked="checked"/>Godkjenne
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
              <xsl:when test="./c:tempvalues/c:tempvalues/c:privileges/c:privilege = 'relation.delete'">
                <input type="checkbox" name="privileges" value="relation.delete" checked="checked"/>Slette
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
              <xsl:when test="./c:tempvalues/c:tempvalues/c:privileges/c:privilege = 'relation.edit'">
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
          <td>
            <xsl:choose>
              <xsl:when test="./c:tempvalues/c:tempvalues/c:privileges/c:privilege = 'relation.approve'">
                <input type="checkbox" name="privileges" value="resource.approve" checked="checked"/>Godkjenne
              </xsl:when>
              <xsl:otherwise>
                <input type="checkbox" name="privileges" value="resource.approve"/>Godkjenne
              </xsl:otherwise>
            </xsl:choose>

          </td>
        </tr>
        <tr>
          <td></td>
          <td>
            <xsl:choose>
              <xsl:when test="./c:tempvalues/c:tempvalues/c:privileges/c:privilege = 'relation.delete'">
                <input type="checkbox" name="privileges" value="resource.delete" checked="checked"/>Slette
              </xsl:when>
              <xsl:otherwise>
                <input type="checkbox" name="privileges" value="resource.delete"/>Slette
              </xsl:otherwise>
            </xsl:choose>

          </td>
        </tr>
        <tr>
          <td></td>
          <td>Brukere</td>
        </tr>
        <tr>
          <td></td>
          <td>
            <xsl:choose>
              <xsl:when test="./c:tempvalues/c:tempvalues/c:privileges/c:privilege = 'user.edit'">
                <input type="checkbox" name="privileges" value="user.edit" checked="checked"/>Legge til/Redigere
              </xsl:when>
              <xsl:otherwise>
                <input type="checkbox" name="privileges" value="user.edit"/>Legge til/Redigere
              </xsl:otherwise>
            </xsl:choose>
          </td>
        </tr>
        <tr>
          <td></td>
          <td>
            <xsl:choose>
              <xsl:when test="./c:tempvalues/c:tempvalues/c:privileges/c:privilege = 'user.approve'">
                <input type="checkbox" name="privileges" value="user.approve" checked="checked"/>Godkjenne
              </xsl:when>
              <xsl:otherwise>
                <input type="checkbox" name="privileges" value="user.approve"/>Godkjenne
              </xsl:otherwise>
            </xsl:choose>
          </td>
        </tr>
        <tr>
          <td></td>
          <td>
            <xsl:choose>
              <xsl:when test="./c:tempvalues/c:tempvalues/c:privileges/c:privilege = 'user.delete'">
                <input type="checkbox" name="privileges" value="user.delete" checked="checked"/>Slette
              </xsl:when>
              <xsl:otherwise>
                <input type="checkbox" name="privileges" value="user.delete"/>Slette
              </xsl:otherwise>
            </xsl:choose>
          </td>
        </tr>
        <tr>
          <td></td>
          <td>Roller</td>
        </tr>
        <tr>
          <td></td>
          <td>
            <xsl:choose>
              <xsl:when test="./c:tempvalues/c:tempvalues/c:privileges/c:privilege = 'role.edit'">
                <input type="checkbox" name="privileges" value="role.edit" checked="checked"/>Legge til/Redigere
              </xsl:when>
              <xsl:otherwise>
                <input type="checkbox" name="privileges" value="role.edit"/>Legge til/Redigere
              </xsl:otherwise>
            </xsl:choose>
          </td>
        </tr>
        <tr>
          <td></td>
          <td>
            <xsl:choose>
              <xsl:when test="./c:tempvalues/c:tempvalues/c:privileges/c:privilege = 'role.approve'">
                <input type="checkbox" name="privileges" value="role.approve" checked="checked"/>Godkjenne
              </xsl:when>
              <xsl:otherwise>
                <input type="checkbox" name="privileges" value="role.approve"/>Godkjenne
              </xsl:otherwise>
            </xsl:choose>
          </td>
        </tr>
        <tr>
          <td></td>
          <td>
            <xsl:choose>
              <xsl:when test="./c:tempvalues/c:tempvalues/c:privileges/c:privilege = 'role.delete'">
                <input type="checkbox" name="privileges" value="role.delete" checked="checked"/>Slette
              </xsl:when>
              <xsl:otherwise>
                <input type="checkbox" name="privileges" value="role.delete"/>Slette
              </xsl:otherwise>
            </xsl:choose>
          </td>
        </tr>
        <tr>
          <td></td>
          <td></td>
        </tr>
        <tr>
          <td>
            <xsl:choose>
              <xsl:when test="/c:page/c:userprivileges/c:privileges/c:privilege = 'role.edit'">
                <input type="submit" value="Lagre rolle"/>
              </xsl:when>
              <xsl:otherwise>
                <input type="submit" value="Lagre rolle" disabled="true"/>
              </xsl:otherwise>
            </xsl:choose>

          </td>
          <td>
            <input type="reset" value="Rens skjema"/>
          </td>
        </tr>
      </table>
    </form>

  </xsl:template>
</xsl:stylesheet>