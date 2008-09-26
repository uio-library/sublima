<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:c="http://xmlns.computas.com/cocoon"
        xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
        xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
        xmlns:lingvoj="http://www.lingvoj.org/ontology#"
        xmlns:i18n="http://apache.org/cocoon/i18n/2.1"
        xmlns="http://www.w3.org/1999/xhtml"
        version="1.0">
  <xsl:template name="controlbutton" mode="list-options">
    <xsl:param name="privilege"/>
    <xsl:param name="buttontext"/>
    <xsl:param name="buttonname">actionbutton</xsl:param>

    <xsl:choose>
      <xsl:when test="/c:page/c:userprivileges/c:privileges/c:privilege = $privilege">
        <input type="submit" value="{$buttontext}" name="{$buttonname}" i18n:attr="value"/>
      </xsl:when>
      <xsl:otherwise>
        <input type="submit" value="{$buttontext}" name="{$buttonname}" disabled="true" i18n:attr="value"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>


</xsl:stylesheet>