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
        xmlns:i18n="http://apache.org/cocoon/i18n/2.1"
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
            <label for="rdfs:label"><i18n:text key="name">Navn</i18n:text></label>
          </td>
          <td>
            <input id="rdfs:label" type="text" name="rdfs:label" size="40" value="{./c:roledetails/rdf:RDF/sioc:Role/rdfs:label}"/>
          </td>
        </tr>
        <tr>
          <td><i18n:text key="rights">Rettigheter</i18n:text></td>
        </tr>
        <tr>
          <td></td>
          <td><i18n:text key="topics">Emner</i18n:text></td>
        </tr>
        <tr>
          <td></td>
          <td>
            <xsl:choose>
              <xsl:when test="./c:roleprivilegies/c:privileges/c:privilege = 'topic.edit'">
                <input type="checkbox" name="privileges" value="topic.edit" checked="checked"/><i18n:text key="addedit">Legge til/Redigere</i18n:text>
              </xsl:when>
              <xsl:otherwise>
                <input type="checkbox" name="privileges" value="topic.edit"/><i18n:text key="addedit">Legge til/Redigere</i18n:text>
              </xsl:otherwise>
            </xsl:choose>
          </td>
        </tr>
        <tr>
          <td></td>
          <td>
            <xsl:choose>
              <xsl:when test="./c:roleprivilegies/c:privileges/c:privilege = 'topic.approve'">
                <input type="checkbox" name="privileges" value="topic.approve" checked="checked"/><i18n:text key="addedit">Godkjenne</i18n:text>
              </xsl:when>
              <xsl:otherwise>
                <input type="checkbox" name="privileges" value="topic.approve"/><i18n:text key="addedit">Godkjenne</i18n:text>
              </xsl:otherwise>
            </xsl:choose>
          </td>
        </tr>
        <tr>
          <td></td>
          <td>
            <xsl:choose>
              <xsl:when test="./c:roleprivilegies/c:privileges/c:privilege = 'topic.delete'">
                <input type="checkbox" name="privileges" value="topic.delete" checked="checked"/><i18n:text key="delete">Slette</i18n:text>
              </xsl:when>
              <xsl:otherwise>
                <input type="checkbox" name="privileges" value="topic.delete"/><i18n:text key="delete">Slette</i18n:text>
              </xsl:otherwise>
            </xsl:choose>
          </td>
        </tr>
        <tr>
          <td></td>
          <td>
            <xsl:choose>
              <xsl:when test="./c:roleprivilegies/c:privileges/c:privilege = 'topic.theme'">
                <input type="checkbox" name="privileges" value="topic.theme" checked="checked"/><i18n:text key="setthemetopics">Sette temaemner</i18n:text>
              </xsl:when>
              <xsl:otherwise>
                <input type="checkbox" name="privileges" value="topic.theme"/><i18n:text key="setthemetopics">Sette temaemner</i18n:text>
              </xsl:otherwise>
            </xsl:choose>
          </td>
        </tr>
        <tr>
          <td></td>
          <td>
            <xsl:choose>
              <xsl:when test="./c:roleprivilegies/c:privileges/c:privilege = 'topic.join'">
                <input type="checkbox" name="privileges" value="topic.join" checked="checked"/><i18n:text key="jointopics">Koble emner</i18n:text>
              </xsl:when>
              <xsl:otherwise>
                <input type="checkbox" name="privileges" value="topic.join"/><i18n:text key="jointopics">Koble emner</i18n:text>
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
          <td><i18n:text key="relations">Relasjoner</i18n:text></td>
        </tr>
        <tr>
          <td></td>
          <td>
            <xsl:choose>
              <xsl:when test="./c:roleprivilegies/c:privileges/c:privilege = 'relation.edit'">
                <input type="checkbox" name="privileges" value="relation.edit" checked="checked"/><i18n:text key="addedit">Legge til/Redigere</i18n:text>
              </xsl:when>
              <xsl:otherwise>
                <input type="checkbox" name="privileges" value="relation.edit"/><i18n:text key="addedit">Legge til/Redigere</i18n:text>
              </xsl:otherwise>
            </xsl:choose>
          </td>
        </tr>
        <tr>
          <td></td>
          <td>
            <xsl:choose>
              <xsl:when test="./c:roleprivilegies/c:privileges/c:privilege = 'relation.approve'">
                <input type="checkbox" name="privileges" value="relation.approve" checked="checked"/><i18n:text key="addedit">Godkjenne</i18n:text>
              </xsl:when>
              <xsl:otherwise>
                <input type="checkbox" name="privileges" value="relation.approve"/><i18n:text key="addedit">Godkjenne</i18n:text>
              </xsl:otherwise>
            </xsl:choose>
          </td>
        </tr>
        <tr>
          <td></td>
          <td>
            <xsl:choose>
              <xsl:when test="./c:roleprivilegies/c:privileges/c:privilege = 'relation.delete'">
                <input type="checkbox" name="privileges" value="relation.delete" checked="checked"/><i18n:text key="delete">Slette</i18n:text>
              </xsl:when>
              <xsl:otherwise>
                <input type="checkbox" name="privileges" value="relation.delete"/><i18n:text key="delete">Slette</i18n:text>
              </xsl:otherwise>
            </xsl:choose>
          </td>
        </tr>
        <tr>
          <td></td>
          <td><i18n:text key="resources">Ressurser</i18n:text></td>
        </tr>
        <tr>
          <td></td>
          <td>
            <xsl:choose>
              <xsl:when test="./c:roleprivilegies/c:privileges/c:privilege = 'relation.edit'">
                <input type="checkbox" name="privileges" value="resource.edit" checked="checked"/><i18n:text key="addedit">Legge til/Redigere</i18n:text>
              </xsl:when>
              <xsl:otherwise>
                <input type="checkbox" name="privileges" value="resource.edit"/><i18n:text key="addedit">Legge til/Redigere</i18n:text>
              </xsl:otherwise>
            </xsl:choose>

          </td>
        </tr>
        <tr>
          <td></td>
          <td>
            <xsl:choose>
              <xsl:when test="./c:roleprivilegies/c:privileges/c:privilege = 'relation.approve'">
                <input type="checkbox" name="privileges" value="resource.approve" checked="checked"/><i18n:text key="addedit">Godkjenne</i18n:text>
              </xsl:when>
              <xsl:otherwise>
                <input type="checkbox" name="privileges" value="resource.approve"/><i18n:text key="addedit">Godkjenne</i18n:text>
              </xsl:otherwise>
            </xsl:choose>

          </td>
        </tr>
        <tr>
          <td></td>
          <td>
            <xsl:choose>
              <xsl:when test="./c:roleprivilegies/c:privileges/c:privilege = 'relation.delete'">
                <input type="checkbox" name="privileges" value="resource.delete" checked="checked"/><i18n:text key="delete">Slette</i18n:text>
              </xsl:when>
              <xsl:otherwise>
                <input type="checkbox" name="privileges" value="resource.delete"/><i18n:text key="delete">Slette</i18n:text>
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
          <td><i18n:text key="users">Brukere</i18n:text></td>
        </tr>
        <tr>
          <td></td>
          <td>
            <xsl:choose>
              <xsl:when test="./c:roleprivilegies/c:privileges/c:privilege = 'user.edit'">
                <input type="checkbox" name="privileges" value="user.edit" checked="checked"/><i18n:text key="addedit">Legge til/Redigere</i18n:text>
              </xsl:when>
              <xsl:otherwise>
                <input type="checkbox" name="privileges" value="user.edit"/><i18n:text key="addedit">Legge til/Redigere</i18n:text>
              </xsl:otherwise>
            </xsl:choose>
          </td>
        </tr>
        <tr>
          <td></td>
          <td>
            <xsl:choose>
              <xsl:when test="./c:roleprivilegies/c:privileges/c:privilege = 'user.approve'">
                <input type="checkbox" name="privileges" value="user.approve" checked="checked"/><i18n:text key="addedit">Godkjenne</i18n:text>
              </xsl:when>
              <xsl:otherwise>
                <input type="checkbox" name="privileges" value="user.approve"/><i18n:text key="addedit">Godkjenne</i18n:text>
              </xsl:otherwise>
            </xsl:choose>
          </td>
        </tr>
        <tr>
          <td></td>
          <td>
            <xsl:choose>
              <xsl:when test="./c:roleprivilegies/c:privileges/c:privilege = 'user.delete'">
                <input type="checkbox" name="privileges" value="user.delete" checked="checked"/><i18n:text key="delete">Slette</i18n:text>
              </xsl:when>
              <xsl:otherwise>
                <input type="checkbox" name="privileges" value="user.delete"/><i18n:text key="delete">Slette</i18n:text>
              </xsl:otherwise>
            </xsl:choose>
          </td>
        </tr>
        <tr>
          <td></td>
          <td><i18n:text key="roles">Roller</i18n:text></td>
        </tr>
        <tr>
          <td></td>
          <td>
            <xsl:choose>
              <xsl:when test="./c:roleprivilegies/c:privileges/c:privilege = 'role.edit'">
                <input type="checkbox" name="privileges" value="role.edit" checked="checked"/><i18n:text key="addedit">Legge til/Redigere</i18n:text>
              </xsl:when>
              <xsl:otherwise>
                <input type="checkbox" name="privileges" value="role.edit"/><i18n:text key="addedit">Legge til/Redigere</i18n:text>
              </xsl:otherwise>
            </xsl:choose>
          </td>
        </tr>
        <tr>
          <td></td>
          <td>
            <xsl:choose>
              <xsl:when test="./c:roleprivilegies/c:privileges/c:privilege = 'role.approve'">
                <input type="checkbox" name="privileges" value="role.approve" checked="checked"/><i18n:text key="addedit">Godkjenne</i18n:text>
              </xsl:when>
              <xsl:otherwise>
                <input type="checkbox" name="privileges" value="role.approve"/><i18n:text key="addedit">Godkjenne</i18n:text>
              </xsl:otherwise>
            </xsl:choose>
          </td>
        </tr>
        <tr>
          <td></td>
          <td>
            <xsl:choose>
              <xsl:when test="./c:roleprivilegies/c:privileges/c:privilege = 'role.delete'">
                <input type="checkbox" name="privileges" value="role.delete" checked="checked"/><i18n:text key="delete">Slette</i18n:text>
              </xsl:when>
              <xsl:otherwise>
                <input type="checkbox" name="privileges" value="role.delete"/><i18n:text key="delete">Slette</i18n:text>
              </xsl:otherwise>
            </xsl:choose>
          </td>
        </tr>
        <tr>
          <td></td>
          <td><i18n:text key="publishers">Utgivere</i18n:text></td>
        </tr>
        <tr>
          <td></td>
          <td>
            <xsl:choose>
              <xsl:when test="./c:roleprivilegies/c:privileges/c:privilege = 'publisher.edit'">
                <input type="checkbox" name="privileges" value="publisher.edit" checked="checked"/><i18n:text key="addedit">Legge til/Redigere</i18n:text>
              </xsl:when>
              <xsl:otherwise>
                <input type="checkbox" name="privileges" value="publisher.edit"/><i18n:text key="addedit">Legge til/Redigere</i18n:text>
              </xsl:otherwise>
            </xsl:choose>
          </td>
        </tr>
        <tr>
          <td></td>
          <td>
            <xsl:choose>
              <xsl:when test="./c:roleprivilegies/c:privileges/c:privilege = 'publisher.delete'">
                <input type="checkbox" name="privileges" value="publisher.delete" checked="checked"/><i18n:text key="delete">Slette</i18n:text>
              </xsl:when>
              <xsl:otherwise>
                <input type="checkbox" name="privileges" value="publisher.delete"/><i18n:text key="delete">Slette</i18n:text>
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
              <xsl:with-param name="buttontext"><i18n:text key="button.saverole">Lagre rolle</i18n:text></xsl:with-param>
            </xsl:call-template>
          </td>
          <td>
            <input type="reset" value="button.empty" i18n:attri="value"/>
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
            <label for="rdfs:label"><i18n:text key="name">Navn</i18n:text></label>
          </td>
          <td>
            <input id="rdfs:label" type="text" name="rdfs:label" size="40" value="{./c:tempvalues/c:tempvalues/rdfs:label}"/>
          </td>
        </tr>
        <tr>
           <td><i18n:text key="rights">Rettigheter</i18n:text></td>
        </tr>
        <tr>
          <td></td>
          <td><i18n:text key="topics">Emner</i18n:text></td>
        </tr>
        <tr>
          <td></td>
          <td>
            <xsl:choose>
              <xsl:when test="./c:tempvalues/c:tempvalues/c:privileges/c:privilege = 'topic.edit'">
                <input type="checkbox" name="privileges" value="topic.edit" checked="checked"/><i18n:text key="addedit">Legge til/Redigere</i18n:text>
              </xsl:when>
              <xsl:otherwise>
                <input type="checkbox" name="privileges" value="topic.edit"/><i18n:text key="addedit">Legge til/Redigere</i18n:text>
              </xsl:otherwise>
            </xsl:choose>
          </td>
        </tr>
        <tr>
          <td></td>
          <td>
            <xsl:choose>
              <xsl:when test="./c:tempvalues/c:tempvalues/c:privileges/c:privilege = 'topic.approve'">
                <input type="checkbox" name="privileges" value="topic.approve" checked="checked"/><i18n:text key="addedit">Godkjenne</i18n:text>
              </xsl:when>
              <xsl:otherwise>
                <input type="checkbox" name="privileges" value="topic.approve"/><i18n:text key="addedit">Godkjenne</i18n:text>
              </xsl:otherwise>
            </xsl:choose>


          </td>
        </tr>
        <tr>
          <td></td>
          <td>
            <xsl:choose>
              <xsl:when test="./c:tempvalues/c:tempvalues/c:privileges/c:privilege = 'topic.delete'">
                <input type="checkbox" name="privileges" value="topic.delete" checked="checked"/><i18n:text key="delete">Slette</i18n:text>
              </xsl:when>
              <xsl:otherwise>
                <input type="checkbox" name="privileges" value="topic.delete"/><i18n:text key="delete">Slette</i18n:text>
              </xsl:otherwise>
            </xsl:choose>

          </td>
        </tr>

        <tr>
          <td></td>
          <td>
            <xsl:choose>
              <xsl:when test="./c:tempvalues/c:tempvalues/c:privileges/c:privilege = 'topic.theme'">
                <input type="checkbox" name="privileges" value="topic.theme" checked="checked"/><i18n:text key="setthemetopics">Sette temaemner</i18n:text>
              </xsl:when>
              <xsl:otherwise>
                <input type="checkbox" name="privileges" value="topic.theme"/><i18n:text key="setthemetopics">Sette temaemner</i18n:text>
              </xsl:otherwise>
            </xsl:choose>
          </td>
        </tr>
        <tr>
          <td></td>
          <td>
            <xsl:choose>
              <xsl:when test="./c:tempvalues/c:tempvalues/c:privileges/c:privilege = 'topic.join'">
                <input type="checkbox" name="privileges" value="topic.join" checked="checked"/><i18n:text key="jointopics">Koble emner</i18n:text>
              </xsl:when>
              <xsl:otherwise>
                <input type="checkbox" name="privileges" value="topic.join"/><i18n:text key="jointopics">Koble emner</i18n:text>
              </xsl:otherwise>
            </xsl:choose>
          </td>
        </tr>
        <tr>
          <td></td>
          <td><i18n:text key="relations">Relasjoner</i18n:text></td>
        </tr>
        <tr>
          <td></td>
          <td>
            <xsl:choose>
              <xsl:when test="./c:tempvalues/c:tempvalues/c:privileges/c:privilege = 'relation.edit'">
                <input type="checkbox" name="privileges" value="relation.edit" checked="checked"/><i18n:text key="addedit">Legge til/Redigere</i18n:text>
              </xsl:when>
              <xsl:otherwise>
                <input type="checkbox" name="privileges" value="relation.edit"/><i18n:text key="addedit">Legge til/Redigere</i18n:text>
              </xsl:otherwise>
            </xsl:choose>

          </td>
        </tr>
        <tr>
          <td></td>
          <td>
            <xsl:choose>
              <xsl:when test="./c:tempvalues/c:tempvalues/c:privileges/c:privilege = 'relation.approve'">
                <input type="checkbox" name="privileges" value="relation.approve" checked="checked"/><i18n:text key="addedit">Godkjenne</i18n:text>
              </xsl:when>
              <xsl:otherwise>
                <input type="checkbox" name="privileges" value="relation.approve"/><i18n:text key="addedit">Godkjenne</i18n:text>
              </xsl:otherwise>
            </xsl:choose>

          </td>
        </tr>
        <tr>
          <td></td>
          <td>
            <xsl:choose>
              <xsl:when test="./c:tempvalues/c:tempvalues/c:privileges/c:privilege = 'relation.delete'">
                <input type="checkbox" name="privileges" value="relation.delete" checked="checked"/><i18n:text key="delete">Slette</i18n:text>
              </xsl:when>
              <xsl:otherwise>
                <input type="checkbox" name="privileges" value="relation.delete"/><i18n:text key="delete">Slette</i18n:text>
              </xsl:otherwise>
            </xsl:choose>

          </td>
        </tr>
        <tr>
          <td></td>
          <td><i18n:text key="resources">Ressurser</i18n:text></td>
        </tr>
        <tr>
          <td></td>
          <td>
            <xsl:choose>
              <xsl:when test="./c:tempvalues/c:tempvalues/c:privileges/c:privilege = 'relation.edit'">
                <input type="checkbox" name="privileges" value="resource.edit" checked="checked"/><i18n:text key="addedit">Legge til/Redigere</i18n:text>
              </xsl:when>
              <xsl:otherwise>
                <input type="checkbox" name="privileges" value="resource.edit"/><i18n:text key="addedit">Legge til/Redigere</i18n:text>
              </xsl:otherwise>
            </xsl:choose>

          </td>
        </tr>
        <tr>
          <td></td>
          <td>
            <xsl:choose>
              <xsl:when test="./c:tempvalues/c:tempvalues/c:privileges/c:privilege = 'relation.approve'">
                <input type="checkbox" name="privileges" value="resource.approve" checked="checked"/><i18n:text key="addedit">Godkjenne</i18n:text>
              </xsl:when>
              <xsl:otherwise>
                <input type="checkbox" name="privileges" value="resource.approve"/><i18n:text key="addedit">Godkjenne</i18n:text>
              </xsl:otherwise>
            </xsl:choose>

          </td>
        </tr>
        <tr>
          <td></td>
          <td>
            <xsl:choose>
              <xsl:when test="./c:tempvalues/c:tempvalues/c:privileges/c:privilege = 'relation.delete'">
                <input type="checkbox" name="privileges" value="resource.delete" checked="checked"/><i18n:text key="delete">Slette</i18n:text>
              </xsl:when>
              <xsl:otherwise>
                <input type="checkbox" name="privileges" value="resource.delete"/><i18n:text key="delete">Slette</i18n:text>
              </xsl:otherwise>
            </xsl:choose>

          </td>
        </tr>
        <tr>
          <td></td>
          <td><i18n:text key="users">Brukere</i18n:text></td>
        </tr>
        <tr>
          <td></td>
          <td>
            <xsl:choose>
              <xsl:when test="./c:tempvalues/c:tempvalues/c:privileges/c:privilege = 'user.edit'">
                <input type="checkbox" name="privileges" value="user.edit" checked="checked"/><i18n:text key="addedit">Legge til/Redigere</i18n:text>
              </xsl:when>
              <xsl:otherwise>
                <input type="checkbox" name="privileges" value="user.edit"/><i18n:text key="addedit">Legge til/Redigere</i18n:text>
              </xsl:otherwise>
            </xsl:choose>
          </td>
        </tr>
        <tr>
          <td></td>
          <td>
            <xsl:choose>
              <xsl:when test="./c:tempvalues/c:tempvalues/c:privileges/c:privilege = 'user.approve'">
                <input type="checkbox" name="privileges" value="user.approve" checked="checked"/><i18n:text key="addedit">Godkjenne</i18n:text>
              </xsl:when>
              <xsl:otherwise>
                <input type="checkbox" name="privileges" value="user.approve"/><i18n:text key="addedit">Godkjenne</i18n:text>
              </xsl:otherwise>
            </xsl:choose>
          </td>
        </tr>
        <tr>
          <td></td>
          <td>
            <xsl:choose>
              <xsl:when test="./c:tempvalues/c:tempvalues/c:privileges/c:privilege = 'user.delete'">
                <input type="checkbox" name="privileges" value="user.delete" checked="checked"/><i18n:text key="delete">Slette</i18n:text>
              </xsl:when>
              <xsl:otherwise>
                <input type="checkbox" name="privileges" value="user.delete"/><i18n:text key="delete">Slette</i18n:text>
              </xsl:otherwise>
            </xsl:choose>
          </td>
        </tr>
        <tr>
          <td></td>
          <td><i18n:text key="roles">Roller</i18n:text></td>
        </tr>
        <tr>
          <td></td>
          <td>
            <xsl:choose>
              <xsl:when test="./c:tempvalues/c:tempvalues/c:privileges/c:privilege = 'role.edit'">
                <input type="checkbox" name="privileges" value="role.edit" checked="checked"/><i18n:text key="addedit">Legge til/Redigere</i18n:text>
              </xsl:when>
              <xsl:otherwise>
                <input type="checkbox" name="privileges" value="role.edit"/><i18n:text key="addedit">Legge til/Redigere</i18n:text>
              </xsl:otherwise>
            </xsl:choose>
          </td>
        </tr>
        <tr>
          <td></td>
          <td>
            <xsl:choose>
              <xsl:when test="./c:tempvalues/c:tempvalues/c:privileges/c:privilege = 'role.approve'">
                <input type="checkbox" name="privileges" value="role.approve" checked="checked"/><i18n:text key="addedit">Godkjenne</i18n:text>
              </xsl:when>
              <xsl:otherwise>
                <input type="checkbox" name="privileges" value="role.approve"/><i18n:text key="addedit">Godkjenne</i18n:text>
              </xsl:otherwise>
            </xsl:choose>
          </td>
        </tr>
        <tr>
          <td></td>
          <td>
            <xsl:choose>
              <xsl:when test="./c:tempvalues/c:tempvalues/c:privileges/c:privilege = 'role.delete'">
                <input type="checkbox" name="privileges" value="role.delete" checked="checked"/><i18n:text key="delete">Slette</i18n:text>
              </xsl:when>
              <xsl:otherwise>
                <input type="checkbox" name="privileges" value="role.delete"/><i18n:text key="delete">Slette</i18n:text>
              </xsl:otherwise>
            </xsl:choose>
          </td>
        </tr>
         <tr>
          <td></td>
          <td><i18n:text key="publishers">Utgivere</i18n:text></td>
        </tr>
        <tr>
          <td></td>
          <td>
            <xsl:choose>
              <xsl:when test="./c:tempvalues/c:tempvalues/c:privileges/c:privilege = 'publisher.edit'">
                <input type="checkbox" name="privileges" value="publisher.edit" checked="checked"/><i18n:text key="addedit">Legge til/Redigere</i18n:text>
              </xsl:when>
              <xsl:otherwise>
                <input type="checkbox" name="privileges" value="publisher.edit"/><i18n:text key="addedit">Legge til/Redigere</i18n:text>
              </xsl:otherwise>
            </xsl:choose>
          </td>
        </tr>
        <tr>
          <td></td>
          <td>
            <xsl:choose>
              <xsl:when test="../c:tempvalues/c:tempvalues/c:privileges/c:privilege = 'publisher.delete'">
                <input type="checkbox" name="privileges" value="publisher.delete" checked="checked"/><i18n:text key="delete">Slette</i18n:text>
              </xsl:when>
              <xsl:otherwise>
                <input type="checkbox" name="privileges" value="publisher.delete"/><i18n:text key="delete">Slette</i18n:text>
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
              <xsl:with-param name="buttontext"><i18n:text key="button.saverole">Lagre rolle</i18n:text></xsl:with-param>
            </xsl:call-template>
          </td>
          <td>
            <input type="reset" value="button.empty" i18n:attr="value"/>
          </td>
        </tr>
      </table>
    </form>

  </xsl:template>
</xsl:stylesheet>