<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" exclude-result-prefixes="php"
		xmlns:php="http://php.net/xsl"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xlink="http://www.w3.org/1999/xlink">

	<xsl:output method="xml" encoding="utf-8" omit-xml-declaration="yes" indent="yes"
                doctype-public="-//NLM//DTD JATS (Z39.96) Journal Publishing DTD v1.1 20151215//EN"
                doctype-system="http://jats.nlm.nih.gov/publishing/1.1/JATS-journalpublishing1.dtd"/>
		
    <xsl:param name="timestamp"/>
    <xsl:param name="pub-year"/>
    <xsl:param name="pub-month"/>
    <xsl:param name="pub-month-digit"/>
    <xsl:param name="pub-day"/>
    <xsl:param name="pub-day-digit"/>

    <xsl:variable name="meta" select="/article/front/article-meta"/>
    <xsl:variable name="doi" select="$meta/article-id[@pub-id-type='doi']"/>
    <xsl:variable name="id" select="$meta/article-id[@pub-id-type='publisher-id']"/>
    <xsl:variable name="issn" select="/article/front/journal-meta/issn"/>
    <xsl:variable name="correction-id" select="concat($id, '/correction-', $timestamp)"/>
    <xsl:variable name="pub-date" select="concat($pub-year, '-', $pub-month, '-', $pub-day)"/>

    <xsl:template match="/article">
        <article article-type="correction" dtd-version="1.1">
            <front>
                <xsl:apply-templates select="front/journal-meta"/>
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
                    <xsl:value-of select="$pub-day-digit"/>
                </day>
                <month>
                    <xsl:value-of select="$pub-month-digit"/>
                </month>
                <year iso-8601-date="{$pub-year}">
                    <xsl:value-of select="$pub-year"/>
                </year>
            </pub-date>
            <pub-date pub-type="collection">
                <year>
                    <xsl:value-of select="$pub-year"/>
                </year>
            </pub-date>
            <xsl:apply-templates select="volume"/>
            <elocation-id>
                 <xsl:value-of select="concat('e', $correction-id)"/>
            </elocation-id>
            <permissions>
                <xsl:apply-templates select="permissions/license"/>
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
        <xsl:element name="{local-name()}">
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
</xsl:stylesheet>
