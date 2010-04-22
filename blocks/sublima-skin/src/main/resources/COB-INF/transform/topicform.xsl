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
        xmlns:i18n="http://apache.org/cocoon/i18n/2.1"
        xmlns:owl="http://www.w3.org/2002/07/owl#"
        xmlns:sparql="http://www.w3.org/2005/sparql-results#"
        xmlns="http://www.w3.org/1999/xhtml"
        version="1.0">
  <xsl:import href="rdfxml2xhtml-deflist.xsl"/>
  <xsl:import href="controlbutton.xsl"/>
  <xsl:import href="labels.xsl"/>
  <xsl:import href="selectmultiple.xsl"/>
  <xsl:import href="addinputfield_templates.xsl"/>
  <xsl:import href="addinputfield_script.xsl"/>
  <xsl:import href="autocomplete_selectbox.xsl"/>

  <xsl:param name="baseurl"/>
  <xsl:param name="servername"/>
  <xsl:param name="serverport"/>
  <xsl:param name="interface-language">no</xsl:param>

  <xsl:template match="c:topic">
    <xsl:param name="mode"/>

    <xsl:variable name="port">
      <xsl:choose>
        <xsl:when test="$serverport = '80'"></xsl:when>
        <xsl:otherwise>
          <xsl:text>:</xsl:text>
          <xsl:value-of select="$serverport"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

     <xsl:call-template name="addinputfieldtemplates">
      <xsl:with-param name="uid">title</xsl:with-param>
      <xsl:with-param name="interface-language" select="$interface-language"/>
      <xsl:with-param name="values">titlevalues</xsl:with-param>
      <xsl:with-param name="template">titletemplate</xsl:with-param>
      <xsl:with-param name="name">skos:prefLabel</xsl:with-param>
      <xsl:with-param name="i18nkey">title</xsl:with-param>
      <xsl:with-param name="i18ntext">Tittel</xsl:with-param>
    </xsl:call-template>

    <xsl:call-template name="addinputfieldtemplates">
      <xsl:with-param name="uid">synonym</xsl:with-param>
      <xsl:with-param name="interface-language" select="$interface-language"/>
      <xsl:with-param name="values">synonymvalues</xsl:with-param>
      <xsl:with-param name="template">synonymtemplate</xsl:with-param>
      <xsl:with-param name="name">skos:altLabel</xsl:with-param>
      <xsl:with-param name="i18nkey">synonym</xsl:with-param>
      <xsl:with-param name="i18ntext">Synonym</xsl:with-param>
    </xsl:call-template>

     <xsl:call-template name="addinputfieldtemplates">
      <xsl:with-param name="uid">skrivefeil</xsl:with-param>
      <xsl:with-param name="interface-language" select="$interface-language"/>
      <xsl:with-param name="values">skrivefeilvalues</xsl:with-param>
      <xsl:with-param name="template">skrivefeiltemplate</xsl:with-param>
      <xsl:with-param name="name">skos:hiddenLabel</xsl:with-param>
      <xsl:with-param name="i18nkey">skrivefeil</xsl:with-param>
      <xsl:with-param name="i18ntext">Skrivefeil</xsl:with-param>
    </xsl:call-template>

    <xsl:call-template name="addinputfieldtemplates">
      <xsl:with-param name="uid">klassifisering</xsl:with-param>
      <xsl:with-param name="interface-language" select="$interface-language"/>
      <xsl:with-param name="values">klassifiseringvalues</xsl:with-param>
      <xsl:with-param name="template">klassifiseringtemplate</xsl:with-param>
      <xsl:with-param name="name">sub:classification</xsl:with-param>
      <xsl:with-param name="i18nkey">classification</xsl:with-param>
      <xsl:with-param name="i18ntext">Klassifisering</xsl:with-param>
    </xsl:call-template>

    <script type="text/javascript">

      // Hook up the add button handler.
      $(
      function(){

        <xsl:call-template name="addinputfieldscript">
          <xsl:with-param name="uid">title</xsl:with-param>
          <xsl:with-param name="values">titlevalues</xsl:with-param>
          <xsl:with-param name="template">titletemplate</xsl:with-param>
          <xsl:with-param name="count" select="count(c:topicdetails/rdf:RDF/skos:Concept/skos:prefLabel)+2"/>
          <xsl:with-param name="linkid">addtitle</xsl:with-param>
          <xsl:with-param name="appendto">addtitlebefore</xsl:with-param>
        </xsl:call-template>
        <xsl:call-template name="addinputfieldscript">
          <xsl:with-param name="uid">synonym</xsl:with-param>
          <xsl:with-param name="values">synonymvalues</xsl:with-param>
          <xsl:with-param name="template">synonymtemplate</xsl:with-param>
          <xsl:with-param name="count" select="count(c:topicdetails/rdf:RDF/skos:Concept/skos:altLabel)+2"/>
          <xsl:with-param name="linkid">addsynonym</xsl:with-param>
          <xsl:with-param name="appendto">addsynonymbefore</xsl:with-param>
        </xsl:call-template>
        <xsl:call-template name="addinputfieldscript">
          <xsl:with-param name="uid">skrivefeil</xsl:with-param>
          <xsl:with-param name="values">skrivefeilvalues</xsl:with-param>
          <xsl:with-param name="template">skrivefeiltemplate</xsl:with-param>
          <xsl:with-param name="count" select="count(c:topicdetails/rdf:RDF/skos:Concept/skos:hiddenLabel)+2"/>
          <xsl:with-param name="linkid">addskrivefeil</xsl:with-param>
          <xsl:with-param name="appendto">addskrivefeilbefore</xsl:with-param>
        </xsl:call-template>
        <xsl:call-template name="addinputfieldscript">
          <xsl:with-param name="uid">klassifisering</xsl:with-param>
          <xsl:with-param name="values">klassifiseringvalues</xsl:with-param>
          <xsl:with-param name="template">klassifiseringtemplate</xsl:with-param>
          <xsl:with-param name="count" select="count(c:topicdetails/rdf:RDF/skos:Concept/sub:classification)+2"/>
          <xsl:with-param name="linkid">addklassifisering</xsl:with-param>
          <xsl:with-param name="appendto">addklassifiseringbefore</xsl:with-param>
        </xsl:call-template>


        }
      );
    </script>
    <form action="{$baseurl}/admin/emner/emne" method="POST">

      <input type="hidden" name="prefix" value="skos: &lt;http://www.w3.org/2004/02/skos/core#&gt;"/>
      <input type="hidden" name="prefix" value="rdfs: &lt;http://www.w3.org/2000/01/rdf-schema#&gt;"/>
      <input type="hidden" name="prefix" value="wdr: &lt;http://www.w3.org/2007/05/powder#&gt;"/>
      <input type="hidden" name="prefix" value="lingvoj: &lt;http://www.lingvoj.org/ontology#&gt;"/>
      <input type="hidden" name="prefix" value="sub: &lt;http://xmlns.computas.com/sublima#&gt;"/>
      <input type="hidden" name="prefix" value="rdf: &lt;http://www.w3.org/1999/02/22-rdf-syntax-ns#&gt;"/>
      <input type="hidden" name="rdf:type" value="http://www.w3.org/2004/02/skos/core#Concept"/>
      <xsl:call-template name="hidden-locale-field"/>

      <xsl:choose>
        <xsl:when test="./c:topicdetails/rdf:RDF/skos:Concept/@rdf:about">
          <input type="text" name="the-resource" size="80" value="{./c:topicdetails/rdf:RDF/skos:Concept/@rdf:about}"/>
          <input type="hidden" name="old-the-resource" size="80" value="{./c:topicdetails/rdf:RDF/skos:Concept/@rdf:about}"/>
        </xsl:when>
        <xsl:otherwise>
          <input type="hidden" name="title-field" value="skos:prefLabel-1"/>
          <input type="hidden" name="subjecturi-prefix" value="topic/"/>
        </xsl:otherwise>
      </xsl:choose>
      <table>
        <caption>
          <i18n:text key="topic">Emne</i18n:text>
        </caption>
        <tr>
          <th scope="col">
            <i18n:text key="type">Type</i18n:text>
          </th>
          <th scope="col">
            <i18n:text key="text">Tekst</i18n:text>
          </th>
          <th scope="col">
            <i18n:text key="language">Språk</i18n:text>
          </th>
        </tr>

        <xsl:for-each select="c:topicdetails/rdf:RDF/skos:Concept/skos:prefLabel">
          <xsl:call-template name="labels">
            <xsl:with-param name="label">
              <i18n:text key="title">Tittel</i18n:text>
            </xsl:with-param>
            <xsl:with-param name="value" select="."/>
            <xsl:with-param name="default-language" select="@xml:lang"/>
            <xsl:with-param name="field">
              <xsl:text>skos:prefLabel-</xsl:text>
              <xsl:value-of select="position()"/>
            </xsl:with-param>
            <xsl:with-param name="type">text</xsl:with-param>
          </xsl:call-template>
        </xsl:for-each>

        <xsl:call-template name="labels">
          <xsl:with-param name="label">
            <i18n:text key="title">Tittel</i18n:text>
          </xsl:with-param>
          <xsl:with-param name="value"/>
          <xsl:with-param name="default-language" select="$interface-language"/>
          <xsl:with-param name="field">
            <xsl:text>skos:prefLabel-</xsl:text>
            <xsl:value-of select="count(c:topicdetails/rdf:RDF/skos:Concept/skos:prefLabel)+1"/>
          </xsl:with-param>
          <xsl:with-param name="type">text</xsl:with-param>
        </xsl:call-template>

        <tr id="addtitlebefore">
          <td/>
          <td/>
          <td><a id="addtitle"><i18n:text key="addtitle">Legg til tittel</i18n:text></a></td>
        </tr>

        <xsl:for-each select="c:topicdetails/rdf:RDF/skos:Concept/skos:altLabel">
          <xsl:call-template name="labels">
            <xsl:with-param name="label">
              <i18n:text key="synonym">Synonym</i18n:text>
            </xsl:with-param>
            <xsl:with-param name="value" select="."/>
            <xsl:with-param name="default-language" select="@xml:lang"/>
            <xsl:with-param name="field">
              <xsl:text>skos:altLabel-</xsl:text>
              <xsl:value-of select="position()"/>
            </xsl:with-param>
            <xsl:with-param name="type">text</xsl:with-param>
          </xsl:call-template>
        </xsl:for-each>

        <xsl:call-template name="labels">
          <xsl:with-param name="label">
            <i18n:text key="synonym">Synonym</i18n:text>
          </xsl:with-param>
          <xsl:with-param name="value"/>
          <xsl:with-param name="default-language" select="$interface-language"/>
          <xsl:with-param name="field">
            <xsl:text>skos:altLabel-</xsl:text>
            <xsl:value-of select="count(c:topicdetails/rdf:RDF/skos:Concept/skos:altLabel)+1"/>
          </xsl:with-param>
          <xsl:with-param name="type">text</xsl:with-param>
        </xsl:call-template>

        <tr id="addsynonymbefore">
          <td/>
          <td/>
          <td><a id="addsynonym"><i18n:text key="addsynonym">Legg til synonym</i18n:text></a></td>
        </tr>

        <xsl:for-each select="c:topicdetails/rdf:RDF/skos:Concept/skos:hiddenLabel">
          <xsl:call-template name="labels">
            <xsl:with-param name="label">
              <i18n:text key="typo">Skrivefeil</i18n:text>
            </xsl:with-param>
            <xsl:with-param name="value" select="."/>
            <xsl:with-param name="default-language" select="@xml:lang"/>
            <xsl:with-param name="field">
              <xsl:text>skos:hiddenLabel-</xsl:text>
              <xsl:value-of select="position()"/>
            </xsl:with-param>
            <xsl:with-param name="type">text</xsl:with-param>
          </xsl:call-template>
        </xsl:for-each>

        <xsl:call-template name="labels">
          <xsl:with-param name="label">
            <i18n:text key="typo">Skrivefeil</i18n:text>
          </xsl:with-param>
          <xsl:with-param name="value"/>
          <xsl:with-param name="default-language" select="$interface-language"/>
          <xsl:with-param name="field">
            <xsl:text>skos:hiddenLabel-</xsl:text>
            <xsl:value-of select="count(c:topicdetails/rdf:RDF/skos:Concept/skos:hiddenLabel)+1"/>
          </xsl:with-param>
          <xsl:with-param name="type">text</xsl:with-param>
        </xsl:call-template>

        <tr id="addskrivefeilbefore">
          <td/>
          <td/>
          <td><a id="addskrivefeil"><i18n:text key="addskrivefeil">Legg til skrivefeil</i18n:text></a></td>
        </tr>

          <xsl:for-each select="c:topicdetails/rdf:RDF/skos:Concept/sub:classification">
          <xsl:call-template name="labels">
            <xsl:with-param name="label">
              <i18n:text key="classification">Klassifisering</i18n:text>
            </xsl:with-param>
            <xsl:with-param name="value" select="."/>
            <xsl:with-param name="default-language" select="@xml:lang"/>
            <xsl:with-param name="field">
              <xsl:text>sub:classification-</xsl:text>
              <xsl:value-of select="position()"/>
            </xsl:with-param>
            <xsl:with-param name="type">text</xsl:with-param>
          </xsl:call-template>
        </xsl:for-each>

        <xsl:call-template name="labels">
          <xsl:with-param name="label">
            <i18n:text key="classification">Klassifisering</i18n:text>
          </xsl:with-param>
          <xsl:with-param name="value"/>
          <xsl:with-param name="default-language" select="$interface-language"/>
          <xsl:with-param name="field">
            <xsl:text>sub:classification-</xsl:text>
            <xsl:value-of select="count(c:topicdetails/rdf:RDF/skos:Concept/sub:classification)+1"/>
          </xsl:with-param>
          <xsl:with-param name="type">text</xsl:with-param>
        </xsl:call-template>

        <tr id="addklassifiseringbefore">
          <td/>
          <td/>
          <td><a id="addklassifisering"><i18n:text key="addklassifisering">Legg til klassifisering</i18n:text></a></td>
        </tr>

      </table>
      <table>
        <tr>
          <td>
            <label for="sub:isMainConceptOf">
              <i18n:text key="topconcept">Hovedemne</i18n:text>
            </label>
          </td>
          <td>
            <xsl:choose>
              <xsl:when test="./c:topicdetails/rdf:RDF/skos:Concept/sub:isMainConceptOf">
                <input type="checkbox" name="sub:isMainConceptOf" value="{concat('http://', $servername, $port, $baseurl, '/topic')}" checked="checked"/>
              </xsl:when>
              <xsl:otherwise>
                <input type="checkbox" name="sub:isMainConceptOf" value="{concat('http://', $servername, $port, $baseurl, '/topic')}"/>
              </xsl:otherwise>
            </xsl:choose>
          </td>
        </tr>
        <tr>
          <td>
            <label for="skos:definition">
              <i18n:text key="description">Beskrivelse</i18n:text>
            </label>
          </td>
          <td>
            <textarea id="skos:definition" name="skos:definition"
                      rows="6" cols="40">
              <xsl:value-of select="./c:topicdetails/rdf:RDF/skos:Concept/skos:definition"/>
              <xsl:text> </xsl:text>
            </textarea>
          </td>
        </tr>

      </table>

      <table>
        <caption>
          <i18n:text key="topic.related">Relaterte emner</i18n:text>
        </caption>
        <xsl:for-each select="c:relationtypes/rdf:RDF/owl:ObjectProperty | c:relationtypes/rdf:RDF/owl:SymmetricProperty">
          <xsl:sort lang="{$interface-language}" select="./rdfs:label[@xml:lang=$interface-language]"/>
          <xsl:variable name="relation-uri" select="./@rdf:about"/>
          <xsl:call-template name="dropdownautocomplete">
            <xsl:with-param name="select_id">the-relation-<xsl:value-of select="position()"/></xsl:with-param>
            <xsl:with-param name="select_name">&lt;<xsl:value-of select="$relation-uri"/>&gt;</xsl:with-param>
            <xsl:with-param name="node" select="/c:page/c:content/c:topic/c:alltopics/rdf:RDF/skos:Concept"/>
            <xsl:with-param name="match" select="/c:page/c:content/c:topic/c:topicdetails/rdf:RDF/skos:Concept/*[concat(namespace-uri(), local-name()) = $relation-uri]/@rdf:resource"/>
          </xsl:call-template>  


          <!--
          <tr>
            <th scope="row">
              <label for="the-relation-{position()}">
                <xsl:value-of select="./rdfs:label[@xml:lang=$interface-language]"/>
              </label>
            </th>
            <td>

              <xsl:call-template name="selectmultiple">
                <xsl:with-param name="selectionid">#the-relation-<xsl:value-of select="position()"/></xsl:with-param>
                <xsl:with-param name="tempid">#temp<xsl:value-of select="position()"/></xsl:with-param>
                <xsl:with-param name="position"><xsl:value-of select="position()"/></xsl:with-param>
              </xsl:call-template>

              -->

              <!--select id="the-relation-{position()}" name="&lt;{$relation-uri}&gt;" multiple="multiple"-->


            <!--
              <select class="selectmultiple" id="temp{position()}" multiple="multiple">
                <xsl:for-each select="/c:page/c:content/c:topic/c:alltopics/rdf:RDF/skos:Concept">
                  <xsl:sort lang="{$interface-language}" select="./skos:prefLabel[@xml:lang=$interface-language]"/>
                  <xsl:if test="not(./@rdf:about = /c:page/c:content/c:topic/c:topicdetails/rdf:RDF/skos:Concept/*[concat(namespace-uri(), local-name()) = $relation-uri]/@rdf:resource)">
                    <xsl:if test="./skos:prefLabel[@xml:lang=$interface-language]">
                      <option value="{./@rdf:about}">
                        <xsl:value-of select="./skos:prefLabel[@xml:lang=$interface-language]"/>
                      </option>
                    </xsl:if>
                  </xsl:if>
                </xsl:for-each>
              </select>
              <a href="#" id="add{position()}" class="selectmultiplebutton"><i18n:text key="add">add</i18n:text> &gt;&gt;</a>
            </td>
            <td>
              <select name="&lt;{$relation-uri}&gt;" class="selectmultiple" multiple="multiple" id="the-relation-{position()}">
                <option/>
                <xsl:for-each select="/c:page/c:content/c:topic/c:alltopics/rdf:RDF/skos:Concept">
                  <xsl:sort lang="{$interface-language}" select="./skos:prefLabel[@xml:lang=$interface-language]"/>
                  <xsl:if test="./@rdf:about = /c:page/c:content/c:topic/c:topicdetails/rdf:RDF/skos:Concept/*[concat(namespace-uri(), local-name()) = $relation-uri]/@rdf:resource">
                    <xsl:if test="./skos:prefLabel[@xml:lang=$interface-language]">
                      <option value="{./@rdf:about}" selected="selected">
                        <xsl:value-of select="./skos:prefLabel[@xml:lang=$interface-language]"/>
                      </option>
                    </xsl:if>
                  </xsl:if>
                </xsl:for-each>
              </select>
              <a href="#" id="remove{position()}" class="selectmultiplebutton">&lt;&lt; <i18n:text key="remove">remove</i18n:text></a>
            </td>
          </tr>
          -->

        </xsl:for-each>

        <tr>
          <td>
            <label for="wdr:describedBy">
              <i18n:text key="status">Status</i18n:text>
            </label>
          </td>
          <td>
            <xsl:choose>

              <xsl:when test="not(/c:page/c:content/c:topic/c:topicdetails/rdf:RDF/skos:Concept/wdr:describedBy/@rdf:resource)">
                <select id="wdr:describedBy" name="wdr:describedBy">

                  <xsl:for-each select="./c:statuses/rdf:RDF/wdr:DR">
                    <xsl:sort lang="{$interface-language}" select="./rdfs:label[@xml:lang=$interface-language]"/>

                    <xsl:choose>

                      <xsl:when test="./@rdf:about = 'http://sublima.computas.com/status/inaktiv'">
                        <xsl:if test="./rdfs:label[@xml:lang=$interface-language]">
                          <option value="{./@rdf:about}" selected="selected">
                            <xsl:value-of select="./rdfs:label[@xml:lang=$interface-language]"/>
                          </option>
                        </xsl:if>
                      </xsl:when>

                      <xsl:otherwise>
                        <xsl:if test="./rdfs:label[@xml:lang=$interface-language]">
                          <option value="{./@rdf:about}">
                            <xsl:value-of select="./rdfs:label[@xml:lang=$interface-language]"/>
                          </option>
                        </xsl:if>
                      </xsl:otherwise>

                    </xsl:choose>

                  </xsl:for-each>

                </select>

              </xsl:when>

              <xsl:otherwise>

                <select id="wdr:describedBy" name="wdr:describedBy">

                  <xsl:for-each select="./c:statuses/rdf:RDF/wdr:DR">
                    <xsl:sort lang="{$interface-language}" select="./rdfs:label"/>

                    <xsl:choose>

                      <xsl:when test="./@rdf:about = /c:page/c:content/c:topic/c:topicdetails/rdf:RDF/skos:Concept/wdr:describedBy/@rdf:resource">
                        <xsl:if test="./rdfs:label[@xml:lang=$interface-language]">
                          <option value="{./@rdf:about}" selected="selected">
                            <xsl:value-of select="./rdfs:label[@xml:lang=$interface-language]"/>
                          </option>
                        </xsl:if>
                      </xsl:when>

                      <xsl:otherwise>
                        <xsl:if test="./rdfs:label[@xml:lang=$interface-language]">
                          <option value="{./@rdf:about}">
                            <xsl:value-of select="./rdfs:label[@xml:lang=$interface-language]"/>
                          </option>
                        </xsl:if>
                      </xsl:otherwise>

                    </xsl:choose>

                  </xsl:for-each>

                </select>

              </xsl:otherwise>

            </xsl:choose>

          </td>
        </tr>

        <tr>
          <td>
            <label for="skos:note">
              <i18n:text key="comment">Kommentar</i18n:text>
            </label>
          </td>
          <td>
            <textarea id="skos:note" name="skos:note" rows="6"
                      cols="40">
              <xsl:value-of
                      select="./c:topicdetails/rdf:RDF/skos:Concept/skos:note"/>
              <xsl:text> </xsl:text>
            </textarea>
          </td>
        </tr>


        <tr>
          <td></td>
          <td></td>
        </tr>
        <tr>
          <td>
            <xsl:call-template name="controlbutton">
              <xsl:with-param name="privilege">topic.edit</xsl:with-param>
              <xsl:with-param name="buttontext">
                <i18n:text key="button.savetopic">Lagre emne</i18n:text>
              </xsl:with-param>
            </xsl:call-template>

            <xsl:call-template name="controlbutton">
              <xsl:with-param name="privilege">topic.delete</xsl:with-param>
              <xsl:with-param name="buttontext">button.deletetopic</xsl:with-param>
              <xsl:with-param name="buttonname">actionbuttondelete</xsl:with-param>
            </xsl:call-template>
          </td>
          <td>

          </td>
        </tr>
      </table>

      <br/>

      <h4>
        <i18n:text key="admin.topic.usedby">Ressurser tilknyttet emnet</i18n:text>
      </h4>
      <xsl:apply-templates select="/c:page/c:content/c:topic/c:topicresources/rdf:RDF" mode="results"/>

      <!-- Check that no resources have the topic attached to it -->
      <xsl:for-each select="/c:page/c:content/c:topic/c:topicresources/rdf:RDF">
        <xsl:if test="count(./sub:Resource) &gt; 0">
          <input type="hidden" name="warningSingleResource" value="true"/>
        </xsl:if>
      </xsl:for-each>


    </form>

  </xsl:template>

</xsl:stylesheet>