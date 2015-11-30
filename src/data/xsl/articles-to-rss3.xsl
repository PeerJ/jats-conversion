<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xlink="http://www.w3.org/1999/xlink"
                exclude-result-prefixes="xlink">

    <xsl:output method="text" encoding="utf-8" indent="no" omit-xml-declaration="yes"/>

    <xsl:strip-space elements="*"/>

    <xsl:param name="now"/>
    <xsl:param name="publication"/>
    <xsl:param name="url"/>
    <xsl:param name="creator"/>
    <xsl:param name="title"/>
    <xsl:param name="description"/>

    <xsl:template match="/">
        <xsl:value-of select="concat('title: ', $title)"/>
        <xsl:text>&#10;</xsl:text>
        <xsl:value-of select="concat('description: ', $description)"/>
        <xsl:text>&#10;</xsl:text>
        <xsl:value-of select="concat('link: ', $url)"/>
        <xsl:text>&#10;</xsl:text>
        <xsl:value-of select="concat('creator: ', $creator, ' ', $publication)"/>
        <xsl:text>&#10;</xsl:text>
        <xsl:value-of select="concat('errorsTo: ', $creator, ' ', $publication)"/>
        <xsl:text>&#10;</xsl:text>
        <xsl:text>language: en</xsl:text>
        <xsl:text>&#10;</xsl:text>
        <xsl:text>&#10;</xsl:text>
        <xsl:apply-templates select="articles/front/article-meta"/>
    </xsl:template>

    <xsl:template match="article-meta">
        <xsl:variable name="pub-date" select="pub-date[@date-type='pub'][@pub-type='epub']|pub-date[@date-type='preprint'][@pub-type='epreprint']"/>
        <xsl:text>title: </xsl:text>
        <xsl:value-of select="title-group/article-title"/>
        <xsl:text>&#10;</xsl:text>
        <xsl:text>link: </xsl:text>
        <xsl:value-of select="self-uri/@xlink:href"/>
        <xsl:text>&#10;</xsl:text>
        <xsl:text>last-modified: </xsl:text>
        <xsl:value-of select="$pub-date/@iso-8601-date"/>
        <xsl:text>&#10;</xsl:text>
        <xsl:text>description: </xsl:text>
        <xsl:value-of select="normalize-space(abstract)"/>
        <xsl:text>&#10;</xsl:text>
        <xsl:for-each select="contrib-group/contrib[@contrib-type='author']/name">
            <xsl:text>creator: </xsl:text>
            <xsl:value-of select="given-names"/>
            <xsl:text> </xsl:text>
            <xsl:value-of select="surname"/>
            <xsl:text>&#10;</xsl:text>
        </xsl:for-each>
        <xsl:text>uri: </xsl:text>
        <xsl:value-of select="concat('https://doi.org/', article-id[@pub-id-type='doi'])"/>
        <xsl:text>&#10;</xsl:text>
        <xsl:text>license: </xsl:text>
        <xsl:value-of select="permissions/license/@xlink:href"/>
        <xsl:text>&#10;</xsl:text>
        <xsl:text>rights: </xsl:text>
        <xsl:value-of select="permissions/copyright-statement"/>
        <xsl:text>&#10;</xsl:text>
        <xsl:text>&#10;</xsl:text>
    </xsl:template>

    <xsl:template match="*"/>
</xsl:stylesheet>
