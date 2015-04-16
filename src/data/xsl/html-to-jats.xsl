<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xlink="http://www.w3.org/1999/xlink">

    <xsl:output method="xml" encoding="utf-8" indent="yes"/>

    <xsl:template match="html">
        <xsl:apply-templates select="body/article"/>
    </xsl:template>

    <xsl:template match="article">
        <article>
            <front>
                <xsl:apply-templates select="header"/>
            </front>
            <main>
                <xsl:apply-templates select="section"/>
            </main>
            <back>
                <xsl:apply-templates select="footer"/>
            </back>
        </article>
    </xsl:template>

    <!-- header -->

    <xsl:template match="header">
        <xsl:apply-templates select="h1" mode="header"/>
    </xsl:template>

    <xsl:template match="h1" mode="header">
        <title>
            <xsl:apply-templates/>
        </title>
    </xsl:template>

    <!-- footer -->

    <xsl:template match="footer">
        <xsl:apply-templates select="div" mode="footer"/>
    </xsl:template>

    <xsl:template match="div" mode="footer">
        <section>
            <xsl:apply-templates select="@id"/>
            <xsl:apply-templates/>
        </section>
    </xsl:template>

    <!-- block-level elements -->

    <xsl:template match="section">
        <section>
            <xsl:apply-templates select="@data-section"/>
            <xsl:apply-templates/>
        </section>
    </xsl:template>

    <xsl:template match="h2 | h3 | h4 | h5 | h6">
        <heading>
            <xsl:apply-templates/>
        </heading>
    </xsl:template>

    <xsl:template match="p">
        <p>
            <xsl:apply-templates/>
        </p>
    </xsl:template>

    <!-- inline elements -->

    <xsl:template match="span[@itemprop]">
        <named-content content-type="{ @itemprop }">
            <xsl:apply-templates/>
        </named-content>
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

    <!--
    <xsl:template match="*">
        <xsl:element name="{local-name()}">
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates select="node()"/>
        </xsl:element>
    </xsl:template>
    -->

    <!-- continue through unknown elements -->
    <xsl:template match="*">
        <xsl:apply-templates/>
    </xsl:template>

    <!-- attributes -->
    <xsl:template match="@id">
        <xsl:copy-of select="."/>
    </xsl:template>

    <!-- section ids -->
    <xsl:template match="@data-section">
        <xsl:attribute name="id">
            <xsl:value-of select="."/>
        </xsl:attribute>
    </xsl:template>
</xsl:stylesheet>
