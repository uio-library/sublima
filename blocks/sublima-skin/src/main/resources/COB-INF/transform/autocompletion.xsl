<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns="http://www.w3.org/1999/xhtml"
    version="1.0">
  
  <xsl:template name="autocompletion">
    <script type="text/javascript">
      $(document).ready(function(){
      $("#subject").autocomplete("autocomplete", {
        max: 50,
        minChars: 3,
        extraParams : { action:"topic"}
      });
      
      $("#publisher").autocomplete("autocomplete", {
        max: 50,
        minChars: 3,
	      extraParams : { action:"publisher"}
	    });

       $("#keyword").autocomplete("autocomplete", {
        max: 50,
        minChars: 3,
	      extraParams : { action:"topic"}
	    });
      });
    </script>
  </xsl:template>
</xsl:stylesheet>

