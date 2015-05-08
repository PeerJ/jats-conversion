<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xlink="http://www.w3.org/1999/xlink"
                xmlns:atom="http://www.w3.org/2005/Atom"
                exclude-result-prefixes="xlink">

    <xsl:output encoding="utf-8" indent="yes"/>

    <xsl:strip-space elements="title description"/>

    <xsl:param name="now"/>
    <xsl:param name="publication"/>
    <xsl:param name="url"/>
    <xsl:param name="link"/>
    <xsl:param name="title"/>
    <xsl:param name="description"/>

    <xsl:template match="/articles">
        <rss version="2.0">
            <channel>
                <title><xsl:value-of select="$title"/></title>
                <link><xsl:value-of select="$link"/></link>
                <atom:link rel="self" type="application/rss+xml" href="{$url}"/>
                <description><xsl:value-of select="$description"/></description>
                <pubDate><xsl:value-of select="$now"/></pubDate>
                <language>en</language>

                <xsl:apply-templates select="front/article-meta"/>
            </channel>
        </rss>
    </xsl:template>

    <xsl:template match="article-meta">
        <xsl:variable name="pub-date" select="pub-date[@date-type='pub'][@pub-type='epub']|pub-date[@date-type='preprint'][@pub-type='epreprint']"/>
        <item>
            <link>
                <xsl:value-of select="self-uri/@xlink:href"/>
            </link>
            <title>
                <xsl:value-of select="title-group/article-title"/>
            </title>
            <pubDate>
                <xsl:value-of select="$pub-date/@iso-8601-date"/>
            </pubDate>
            <xsl:for-each select="article-categories/subj-group[@subj-group-type='categories']/subject">
                <category>
                    <xsl:value-of select="."/>
                </category>
            </xsl:for-each>
            <description>
                <xsl:value-of select="abstract"/>
            </description>
        </item>
    </xsl:template>
</xsl:stylesheet>
