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
        xmlns:owl="http://www.w3.org/2002/07/owl#"
        xmlns:foaf="http://xmlns.com/foaf/0.1/"
        xmlns:i18n="http://apache.org/cocoon/i18n/2.1"
        xmlns:sparql="http://www.w3.org/2005/sparql-results#"
        xmlns="http://www.w3.org/1999/xhtml"
        version="1.0">
  <xsl:import href="rdfxml2html-lang-dropdown.xsl"/>
  <xsl:import href="controlbutton.xsl"/>
  <xsl:import href="addinputfield_templates.xsl"/>
  <xsl:import href="addinputfield_script.xsl"/>

  <xsl:param name="baseurl"/>
  <xsl:param name="interface-language">no</xsl:param>
  <xsl:template match="c:related">

    <xsl:call-template name="addinputfieldtemplates">
      <xsl:with-param name="uid">relation</xsl:with-param>
      <xsl:with-param name="interface-language" select="$interface-language"/>
      <xsl:with-param name="values">relationvalues</xsl:with-param>
      <xsl:with-param name="template">relationtemplate</xsl:with-param>
      <xsl:with-param name="name">rdfs:label</xsl:with-param>
      <xsl:with-param name="i18nkey">name</xsl:with-param>
      <xsl:with-param name="i18ntext">Navn</xsl:with-param>
    </xsl:call-template>

    <script type="text/javascript">

      // Hook up the add button handler.
      $(
      function(){

      <xsl:call-template name="addinputfieldscript">
        <xsl:with-param name="uid">relation</xsl:with-param>
        <xsl:with-param name="values">relationvalues</xsl:with-param>
        <xsl:with-param name="template">relationtemplate</xsl:with-param>
        <xsl:with-param name="count" select="count(./c:relation/rdf:RDF/owl:ObjectProperty/rdfs:label)+2"/>
        <xsl:with-param name="linkid">addrelation</xsl:with-param>
        <xsl:with-param name="appendto">addrelationbefore</xsl:with-param>
      </xsl:call-template>

      }
      );

    </script>
    
    <form action="{$baseurl}/admin/emner/relasjoner/relasjon" method="POST">
      <fieldset>

        <xsl:call-template name="hidden-locale-field"/>
        <input type="hidden" name="prefix" value="rdfs: &lt;http://www.w3.org/2000/01/rdf-schema#&gt;"/>
        <input type="hidden" name="prefix" value="owl: &lt;http://www.w3.org/2002/07/owl#&gt;"/>
        <input type="hidden" name="interface-language" value="{$interface-language}"/>
        <xsl:choose>
          <xsl:when test="./c:tempvalues/c:tempvalues">
            <xsl:choose>
              <xsl:when test="./c:tempvalues/c:tempvalues/rdf:about">
                <input type="hidden" name="the-resource" value="{./c:tempvalues/c:tempvalues/rdf:about}"/>
              </xsl:when>
              <xsl:otherwise>
                <input type="hidden" name="title-field" value="rdfs:label-1"/>
                <input type="hidden" name="subjecturi-prefix" value="topicrelations/"/>
              </xsl:otherwise>
            </xsl:choose>
            <xsl:variable name="label" select="./c:tempvalues/c:tempvalues/rdfs:label"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:choose>
              <xsl:when test="./c:tempvalues/c:tempvalues/rdf:about">
                <input type="hidden" name="the-resource" value="{./c:tempvalues/c:tempvalues/rdf:about}"/>
              </xsl:when>
              <xsl:when test="./c:relation/rdf:RDF/*/@rdf:about">
                <input type="hidden" name="the-resource" value="{./c:relation/rdf:RDF/*/@rdf:about}"/>
              </xsl:when>
              <xsl:otherwise>
                <input type="hidden" name="title-field" value="rdfs:label-1"/>
                <input type="hidden" name="subjecturi-prefix" value="topicrelations/"/>
              </xsl:otherwise>
            </xsl:choose>
            <xsl:variable name="label" select="./c:tempvalues/c:tempvalues/rdfs:label"/>
          </xsl:otherwise>


        </xsl:choose>

        <h3>
          <i18n:text key="relationtype">Relasjonstype</i18n:text>
        </h3>
        <table>
          <tr>
            <th/>
            <th/>
            <th scope="col">
              <i18n:text key="language">Språk</i18n:text>
            </th>
          </tr>
          <xsl:for-each select="./c:relation/rdf:RDF/*/rdfs:label">
            <tr>
              <th scope="row">
                <i18n:text key="name">Navn</i18n:text>
              </th>
              <td>
                <input type="text" name="rdfs:label-{position()}" size="20" value="{.}"/>
              </td>
              <td>
                <select name="rdfs:label-{position()}">
                  <xsl:apply-templates select="/c:page/c:content/c:allanguages/rdf:RDF/lingvoj:Lingvo" mode="list-options">
                    <xsl:with-param name="default-language" select="./@xml:lang"/>
                    <xsl:sort lang="{$interface-language}" select="./rdfs:label[@xml:lang=$interface-language]"/>
                  </xsl:apply-templates>
                </select>
              </td>
            </tr>
          </xsl:for-each>
          <tr>
            <th scope="row">
              <i18n:text key="name">Navn</i18n:text>
            </th>
            <td>
              <input type="text" name="rdfs:label-{count(./c:relation/rdf:RDF/*/rdfs:label)+1}" size="20"/>
            </td>
            <td>
              <select name="rdfs:label-{count(./c:relation/rdf:RDF/*/rdfs:label)+1}">
                <xsl:apply-templates select="/c:page/c:content/c:allanguages/rdf:RDF/lingvoj:Lingvo" mode="list-options">
                  <xsl:with-param name="default-language" select="$interface-language"/>
                  <xsl:sort lang="{$interface-language}" select="./rdfs:label[@xml:lang=$interface-language]"/>
                </xsl:apply-templates>
              </select>
            </td>
          </tr>

          <tr id="addrelationbefore">
            <td/>
            <td/>
            <td>
              <a id="addrelation">
                <i18n:text key="addrelation">Legg til navn</i18n:text>
              </a>
            </td>
          </tr>

          <tr>
            <td>
              <xsl:choose>
                <xsl:when test="./c:relation/rdf:RDF/*/owl:inverseOf">
                  <input type="radio" name="relationtype" value="oneway"/>
                  <i18n:text key="oneway">Enveis</i18n:text>
                  <br/>
                  <input type="radio" name="relationtype" value="symmetric"/>
                  <i18n:text key="symmetric">Symmetrisk</i18n:text>
                  <br/>
                  <input type="radio" name="relationtype" value="inverse" checked="true"/>
                  <i18n:text key="inverse">Invers</i18n:text>
                  <br/>
                </xsl:when>
                <xsl:when test="./c:relation/rdf:RDF/*/rdf:type/@rdf:resource = 'http://www.w3.org/2002/07/owl#SymmetricProperty' or ./c:relation/rdf:RDF/owl:SymmetricProperty">
                  <input type="radio" name="relationtype" value="oneway"/>
                  <i18n:text key="oneway">Enveis</i18n:text>
                  <br/>
                  <input type="radio" name="relationtype" value="symmetric" checked="true"/>
                  <i18n:text key="symmetric">Symmetrisk</i18n:text>
                  <br/>
                  <input type="radio" name="relationtype" value="inverse"/>
                  <i18n:text key="inverse">Invers</i18n:text>
                  <br/>  
                </xsl:when>
                <xsl:otherwise>
                  <input type="radio" name="relationtype" value="oneway" checked="true"/>
                  <i18n:text key="oneway">Enveis</i18n:text>
                  <br/>
                  <input type="radio" name="relationtype" value="symmetric"/>
                  <i18n:text key="symmetric">Symmetrisk</i18n:text>
                  <br/>
                  <input type="radio" name="relationtype" value="inverse"/>
                  <i18n:text key="inverse">Invers</i18n:text>
                  <br/>  
                </xsl:otherwise>
              </xsl:choose>

              <script type="text/javascript">

                $(document).ready(function(){
                  if ($("input[name='relationtype']:checked").val() == 'inverse')
                    $("#inverserelation").show();
                  else
                    $("#inverserelation").hide();
                });


                $("input[name='relationtype']").change(
                function()
                {
                  $("input[name='relationtype']:checked").val() == 'inverse' ? $("#inverserelation").show() : $("#inverserelation").hide();
                }
                );
              </script>
            </td>
          </tr>




          <tr id="inverserelation" >
            <td>
            <label for="owl:inverseOf">
              <i18n:text key="inverseOf">Invers av</i18n:text>
            </label>
          </td>
            <td>
                <select id="owl:inverseOf" name="owl:inverseOf">
                  <xsl:for-each select="/c:page/c:content/c:allrelations/rdf:RDF/owl:ObjectProperty">
                    <xsl:sort select="./rdfs:label"/>
                      <xsl:choose>
                        <xsl:when test="./@rdf:about = /c:page/c:content/c:related/c:relation/rdf:RDF/*/owl:inverseOf/@rdf:resource">
                          <option value="{./@rdf:about}" selected="selected"><xsl:value-of select="./rdfs:label"/></option>
                        </xsl:when>
                        <xsl:otherwise>
                          <option value="{./@rdf:about}"><xsl:value-of select="./rdfs:label"/></option>
                        </xsl:otherwise>
                      </xsl:choose>
                  </xsl:for-each>
                </select>
              </td>
          </tr>


        </table>
        <input type="hidden" name="rdfs:subPropertyOf" value="http://www.w3.org/2004/02/skos/core#semanticRelation"/>
        <xsl:choose>
          <xsl:when test="./c:relation/rdf:RDF/owl:SymmetricProperty">
            <input type="hidden" name="a" value="http://www.w3.org/2002/07/owl#SymmetricProperty"/>
          </xsl:when>
          <xsl:otherwise>
            <input type="hidden" name="a" value="http://www.w3.org/2002/07/owl#ObjectProperty"/> 
          </xsl:otherwise>
        </xsl:choose>


        <xsl:call-template name="controlbutton">
          <xsl:with-param name="privilege">relation.edit</xsl:with-param>
          <xsl:with-param name="buttontext">
            <i18n:text key="button.saverelation">Lagre relasjonstype</i18n:text>
          </xsl:with-param>
        </xsl:call-template>

        <xsl:call-template name="controlbutton">
              <xsl:with-param name="privilege">relation.delete</xsl:with-param>
              <xsl:with-param name="buttontext">button.deleterelation</xsl:with-param>
              <xsl:with-param name="buttonname">actionbuttondelete</xsl:with-param>
            </xsl:call-template>


      </fieldset>

    </form>

  </xsl:template>


</xsl:stylesheet>