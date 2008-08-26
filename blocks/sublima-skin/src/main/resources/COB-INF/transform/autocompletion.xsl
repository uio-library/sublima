<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns="http://www.w3.org/1999/xhtml"
    version="1.0">
  
  <xsl:template name="autocompletion">
    <script type="text/javascript">
      $(document).ready(function(){
      $("#subject").autocomplete("autocomplete", {
      minChars: 3,
      extraParams : { action:"topic", locale:"<xsl:value-of select="$interface-language"/>" }
      });
      
      $("#publisher").autocomplete("autocomplete", {
            minChars: 3,
	    extraParams : { action:"publisher", locale:"<xsl:value-of select="$interface-language"/>" }
	    });
	    });
    </script>
  </xsl:template>
</xsl:stylesheet>

