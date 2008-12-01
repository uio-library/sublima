<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns="http://www.w3.org/1999/xhtml"
        xmlns:i18n="http://apache.org/cocoon/i18n/2.1"
        xmlns:c="http://xmlns.computas.com/cocoon"
        xmlns:lingvoj="http://www.lingvoj.org/ontology#"
        xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
        xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
        version="1.0">
  <xsl:import href="rdfxml2html-lang-dropdown.xsl"/>

  <xsl:template name="addinputfieldscript">
    <xsl:param name="values"/>
    <xsl:param name="template"/>
    <xsl:param name="count"/>
    <xsl:param name="linkid"/>
    <xsl:param name="appendto"/>


   <script type="text/javascript">

      // Hook up the add button handler.
      $(
      function(){
        // Get a reference to the values text area.
        var jValues = $( "#<xsl:value-of select="$values"/>" );

        // Get a refernece to the template text area.
        var jTemplate = $( "#<xsl:value-of select="$template"/>" );

        // Keep track of the templates created.
        var intCount = <xsl:value-of select="$count"/>;

        // Get the add new upload link.
        var jAddNewUpload = $( "#<xsl:value-of select="$linkid"/>" );

        // Hook up the click event.
        jAddNewUpload
          .attr( "href", "javascript:void( 0 )" )
          // Bind the click event.
          .click(
            function(){
            // Get the new element from our jQuery
            // template. When we do this, we are going
            // to pass in some values that can be
            // leveraged.
            jElement = jTemplate.template(
            eval( "(" + jValues.val() + ")" )
            );

            // Increment the count.
            intCount++;

            // Add the element to the page.
            $( "#<xsl:value-of select="$appendto"/>" ).before( jElement );
            }
          );
        }
      );

    </script>

  </xsl:template>
</xsl:stylesheet>

