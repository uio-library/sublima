<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:c="http://xmlns.computas.com/cocoon"
        xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
        xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
        xmlns:lingvoj="http://www.lingvoj.org/ontology#"
        xmlns="http://www.w3.org/1999/xhtml"
        version="1.0">
  <xsl:template name="controlbutton" mode="list-options">
    <xsl:param name="privilege"/>
    <xsl:param name="buttontext"/>
    <xsl:choose>
      <xsl:when test="/c:page/c:userprivileges/c:privileges/c:privilege = $privilege">
        <input type="submit" value="{$buttontext}" name="actionbutton"/>
      </xsl:when>
      <xsl:otherwise>
        <input type="submit" value="{$buttontext}" name="actionbutton" disabled="true"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>


</xsl:stylesheet>