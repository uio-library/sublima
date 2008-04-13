<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:include href="servlet:forms:/resource/internal/xsl/forms-page-styling.xsl"/>
    <xsl:include href="servlet:forms:/resource/internal/xsl/forms-field-styling.xsl"/>

    <!-- Location of the resources directories, where JS libs and icons are stored -->
    <xsl:param name="forms-resources"/>
    <xsl:param name="dojo-resources"/>

    <xsl:template match="head">
        <head>
            <xsl:apply-templates select="." mode="forms-page"/>
            <xsl:apply-templates select="." mode="forms-field"/>
            <xsl:apply-templates/>
        </head>
    </xsl:template>

    <xsl:template match="body">
        <body>
            <xsl:apply-templates select="." mode="forms-page"/>
            <xsl:apply-templates select="." mode="forms-field"/>
            <xsl:apply-templates/>
        </body>
    </xsl:template>

</xsl:stylesheet>