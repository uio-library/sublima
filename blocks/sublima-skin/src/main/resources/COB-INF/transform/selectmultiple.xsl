<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns="http://www.w3.org/1999/xhtml"
    xmlns:i18n="http://apache.org/cocoon/i18n/2.1"
    version="1.0">

  <xsl:template name="selectmultiple">
    <xsl:param name="selectionid"/>

    <script type="text/javascript">
      $(document).ready(function() {
      var id = "<xsl:value-of select="$selectionid"/>";
        $(id).asmSelect({
          addItemTarget: 'top',
          animate: false,
          highlight: true,
          sortable: true,
          removeLabel: '<i18n:text key="remove">Remove</i18n:text>',
          highlightAddedLabel:'<i18n:text key="added">Added</i18n:text>',
          highlightRemovedLabel: '<i18n:text key="removed">Removed</i18n:text>'
        });
      });
    </script>
  </xsl:template>
</xsl:stylesheet>

