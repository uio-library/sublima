<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns="http://www.w3.org/1999/xhtml"
    version="1.0">
  
  <xsl:template name="autocompletion">
    <script type="text/javascript">
      $(document).ready(function(){
      $("#subject").autocomplete("autocomplete", {
        max: 20,
        minChars: 3,
        extraParams : { action:"topic", locale:"<xsl:value-of select="$interface-language"/>" }
      });
      
      $("#publisher").autocomplete("autocomplete", {
        max: 20,
        minChars: 3,
	      extraParams : { action:"publisher", locale:"<xsl:value-of select="$interface-language"/>" }
	    });

       $("#keyword").autocomplete("autocomplete", {
        max: 20,
        minChars: 3,
	      extraParams : { action:"topic", locale:"<xsl:value-of select="$interface-language"/>" }
	    });
      });
    </script>
  </xsl:template>
</xsl:stylesheet>

