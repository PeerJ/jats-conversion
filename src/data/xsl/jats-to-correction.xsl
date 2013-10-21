<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" exclude-result-prefixes="php"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:mml="http://www.w3.org/1998/Math/MathML"
                xmlns:xlink="http://www.w3.org/1999/xlink"
                xmlns:php="http://php.net/xsl">

	<xsl:output method="xml" encoding="utf-8" omit-xml-declaration="yes" indent="yes"
                doctype-public="-//NLM//DTD JATS (Z39.96) Journal Publishing DTD v1.0 20120330//EN"
                doctype-system="http://jats.nlm.nih.gov/publishing/1.0/JATS-journalpublishing1.dtd"/>
		
    <xsl:param name="timestamp"/>
    <xsl:param name="pub-year"/>
    <xsl:param name="pub-month"/>
    <xsl:param name="pub-day"/>

    <xsl:variable name="meta" select="/article/front/article-meta"/>
    <xsl:variable name="doi" select="$meta/article-id[@pub-id-type='doi']"/>
    <xsl:variable name="id" select="$meta/article-id[@pub-id-type='publisher-id']"/>
    <xsl:variable name="issn" select="/article/front/journal-meta/issn"/>
    <xsl:variable name="correction-id" select="concat($id, '/correction-', $timestamp)"/>
    <xsl:variable name="pub-date" select="concat($pub-year, '-', $pub-month, '-', $pub-day)"/>

    <xsl:template match="/article">
        <article article-type="correction" dtd-version="1.0">
            <front>
                <xsl:copy-of select="front/journal-meta"/>
                <xsl:apply-templates select="front/article-meta"/>
            </front>
            <body/>
        </article>
    </xsl:template>

    <xsl:template match="article-meta">
        <article-meta>
            <article-id pub-id-type="publisher-id">
                <xsl:value-of select="$correction-id"/>
            </article-id>
            <article-categories>
                <subj-group subj-group-type="heading">
                    <subject>Correction</subject>
                </subj-group>
            </article-categories>
            <title-group>
                <xsl:apply-templates select="title-group/article-title" mode="correction"/>
            </title-group>
            <!--
            <xsl:copy-of select="contrib-group[@content-type='authors']"/>
            <xsl:copy-of select="author-notes"/>
            -->
            <pub-date pub-type="epub" date-type="pub" iso-8601-date="{$pub-date}">
                <day>
                    <xsl:value-of select="$pub-day"/>
                </day>
                <month>
                    <xsl:value-of select="$pub-month"/>
                </month>
                <year iso-8601-date="{$pub-year}">
                    <xsl:value-of select="$pub-year"/>
                </year>
            </pub-date>
            <xsl:copy-of select="volume"/>
            <permissions>
                <xsl:copy-of select="permissions/license"/>
            </permissions>
            <self-uri xlink:href="{concat(self-uri/@xlink:href, '/correction-', $timestamp)}"/>
            <related-article related-article-type="corrected-article"
                             journal-id-type="issn" journal-id="{$issn}"
                             vol="{volume}" elocation-id="{elocation-id}"
                             ext-link-type="doi" xlink:href="{$doi}">
                <xsl:apply-templates select="title-group/article-title"/>
            </related-article>
        </article-meta>
    </xsl:template>

    <xsl:template match="article-title" mode="correction">
        <article-title>
            <xsl:text>Correction: </xsl:text>
            <xsl:apply-templates select="node()"/>
        </article-title>
    </xsl:template>

    <xsl:template match="*">
        <xsl:copy-of select="."/>
    </xsl:template>
</xsl:stylesheet>
