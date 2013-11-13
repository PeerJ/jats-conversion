<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xlink="http://www.w3.org/1999/xlink">

    <xsl:output method="xml" encoding="utf-8" omit-xml-declaration="yes" indent="yes"/>

    <xsl:template match="html">
        <xsl:apply-templates select="body"/>
    </xsl:template>

    <xsl:template match="body">
        <p>
            <xsl:apply-templates/>
        </p>
    </xsl:template>

    <xsl:template match="a">
        <ext-link ext-link-type="uri" xlink:href="{@href}">
            <xsl:apply-templates/>
        </ext-link>
    </xsl:template>

    <xsl:template match="i | em">
        <italic>
            <xsl:apply-templates/>
        </italic>
    </xsl:template>

    <xsl:template match="b | strong">
        <bold>
            <xsl:apply-templates/>
        </bold>
    </xsl:template>

    <xsl:template match="sub">
        <sub>
            <xsl:apply-templates/>
        </sub>
    </xsl:template>

    <xsl:template match="sup">
        <sup>
            <xsl:apply-templates/>
        </sup>
    </xsl:template>

    <xsl:template match="u">
        <underline>
            <xsl:apply-templates/>
        </underline>
    </xsl:template>

    <xsl:template match="br">
        <break/>
    </xsl:template>

    <xsl:template match="*">
        <xsl:element name="{local-name()}">
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates select="node()"/>
        </xsl:element>
    </xsl:template>
</xsl:stylesheet>
