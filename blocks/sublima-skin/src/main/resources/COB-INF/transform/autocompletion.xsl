<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns="http://www.w3.org/1999/xhtml"
        version="1.0">

  <xsl:template name="autocompletion">
    <xsl:param name="baseurl"/>
    <xsl:param name="interface-language"/>
    <script type="text/javascript">
      var url = "<xsl:value-of select="$baseurl"/>" + "/autocomplete";
      $(document).ready(function(){

      $("#subject").autocomplete(url, {
        max: 50,
        minChars: 3,
        selectFirst: false,
        extraParams : { action:"topic", language:"<xsl:value-of select="$interface-language"/>"}
      });

      $("#keyword").autocomplete(url, {
        max: 50,
        minChars: 3,
        selectFirst: false,
        extraParams : { action:"topic", language:"<xsl:value-of select="$interface-language"/>"}
      });

      $("#publisher").autocomplete(url, {
        max: 50,
        minChars: 3,
        selectFirst: false,
        extraParams : { action:"publisher", language:"<xsl:value-of select="$interface-language"/>"}
      });


      });
    </script>
  </xsl:template>
</xsl:stylesheet>

