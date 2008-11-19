<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns="http://www.w3.org/1999/xhtml"
        xmlns:i18n="http://apache.org/cocoon/i18n/2.1"
        version="1.0">

  <xsl:template name="tablesorter">
    <xsl:param name="tableid"/>

    <script type="text/javascript">
      $(document).ready(function()
      {
        $("<xsl:value-of select="$tableid"/>").tablesorter( {sortList: [[0,1]]});
      }
      );
    </script>
  </xsl:template>
</xsl:stylesheet>

