<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns="http://www.w3.org/1999/xhtml"
        xmlns:i18n="http://apache.org/cocoon/i18n/2.1"
        version="1.0">

  <xsl:template name="selectmultiple">
    <xsl:param name="selectionid"/>
    <xsl:param name="tempid"/>
    <xsl:param name="position"/>

    <script type="text/javascript">
      $(document).ready(function() {

        $('#add<xsl:value-of select="$position"/>').click(function() {
          return !$('<xsl:value-of select="$tempid"/> option:selected').remove().appendTo('<xsl:value-of select="$selectionid"/>');
        });
        $('#remove<xsl:value-of select="$position"/>').click(function() {
          return !$('<xsl:value-of select="$selectionid"/> option:selected').remove().appendTo('<xsl:value-of select="$tempid"/>');
        });

        $('<xsl:value-of select="$tempid"/>').dblclick(function() {
          return !$('<xsl:value-of select="$tempid"/> option:selected').remove().appendTo('<xsl:value-of select="$selectionid"/>');
        });
        $('<xsl:value-of select="$selectionid"/>').dblclick(function() {
          return !$('<xsl:value-of select="$selectionid"/> option:selected').remove().appendTo('<xsl:value-of select="$tempid"/>');
        });

        $('form').submit(function() {
          $('<xsl:value-of select="$selectionid"/> option').each(function(i) {
          $(this).attr("selected", "selected");
          });
        });
      });
    </script>
  </xsl:template>
</xsl:stylesheet>

