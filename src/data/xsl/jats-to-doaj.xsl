<?xml version="1.0"?>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                xmlns:xlink="http://www.w3.org/1999/xlink"
                xsi:schemaLocation="http://www.doaj.org/schemas/doajArticles.xsd http://www.doaj.org/schemas/doajArticles.xsd"
                exclude-result-prefixes="xlink xsi">

    <xsl:output method="xml" indent="yes" encoding="UTF-8" standalone="yes"/>

    <xsl:strip-space elements="aff"/>

    <!-- root element -->
    <xsl:template match="/">
        <records>
            <xsl:apply-templates select="article/front/article-meta"/>
        </records>
    </xsl:template>

    <!-- item metadata -->
    <xsl:template match="article-meta">
        <xsl:variable name="pub-date" select="pub-date[@date-type='pub'][@pub-type='epub']|pub-date[@date-type='preprint'][@pub-type='epreprint']"/>
        <record>
            <language>eng</language>

            <journalTitle>
                <xsl:value-of select="../journal-meta/journal-title-group/journal-title" />
            </journalTitle>

            <xsl:apply-templates select="../journal-meta/issn"/>

            <publicationDate>
                <xsl:value-of select="$pub-date/@iso-8601-date"/>
            </publicationDate>

            <volume>
                <xsl:value-of select="volume"/>
            </volume>

            <startPage>
                <xsl:value-of select="elocation-id"/>
            </startPage>

            <doi>
                <xsl:value-of select="article-id[@pub-id-type='doi']"/>
            </doi>

            <publisherRecordId>
                <xsl:value-of select="article-id[@pub-id-type='publisher-id']"/>
            </publisherRecordId>

            <documentType>article</documentType>

            <title language="eng">
                <xsl:apply-templates select="title-group/article-title" mode="title"/>
            </title>

            <authors>
                <xsl:apply-templates select="contrib-group[@content-type='authors']/contrib[@contrib-type='author']"/>
            </authors>

            <affiliationsList>
                <xsl:apply-templates select="contrib-group[@content-type='authors']/aff"/>
            </affiliationsList>

            <abstract language="eng">
                <xsl:apply-templates select="abstract/p"/>
            </abstract>

            <fullTextUrl format="pdf">
                <xsl:value-of select="concat(self-uri/@xlink:href, '.pdf')"/>
            </fullTextUrl>

            <keywords language="eng">
                <xsl:apply-templates select="kwd-group[@kwd-group-type='author']/kwd"/>
            </keywords>
        </record>
    </xsl:template>

    <!-- keyword -->
    <xsl:template match="kwd">
        <keyword>
            <xsl:value-of select="."/>
        </keyword>
    </xsl:template>

    <!-- contributors -->
    <xsl:template match="contrib[@contrib-type='author']">
        <author>
            <name>
                <xsl:apply-templates select="name|collab" mode="contrib"/>
            </name>
            <xsl:apply-templates select="email[1]" mode="contrib"/>
            <xsl:apply-templates select="xref[@ref-type='aff']" mode="contrib"/>
        </author>
    </xsl:template>

    <!-- author email -->
    <xsl:template match="email" mode="contrib">
        <email>
            <xsl:value-of select="."/>
        </email>
    </xsl:template>

    <!-- affiliation ids -->
    <xsl:template match="xref[@ref-type='aff']" mode="contrib">
        <affiliationId>
            <xsl:value-of select="@rid"/>
        </affiliationId>
    </xsl:template>

    <!-- contributor name -->
    <xsl:template match="name" mode="contrib">
        <xsl:if test="given-names">
            <xsl:value-of select="given-names"/>
            <xsl:text>&#32;</xsl:text>
        </xsl:if>
        <xsl:value-of select="surname"/>
        <xsl:if test="suffix">
            <xsl:text>&#32;</xsl:text>
            <xsl:apply-templates select="suffix"/>
        </xsl:if>
    </xsl:template>

    <!-- collab name -->
    <xsl:template match="collab" mode="contrib">
        <xsl:apply-templates select="."/>
    </xsl:template>

    <!-- affiliation -->
    <xsl:template match="aff">
        <affiliationName affiliationId="{@id}">
            <xsl:apply-templates select="node()" mode="aff"/>
        </affiliationName>
    </xsl:template>

    <!-- include most elements in affiliations -->
    <xsl:template match="*" mode="aff">
        <xsl:value-of select="."/>
        <xsl:if test="position() != last()">
            <xsl:text>, </xsl:text>
        </xsl:if>
    </xsl:template>

    <!-- don't include the label in affiliations -->
    <xsl:template match="label" mode="aff"/>

    <!-- ignore text nodes (commas) in affiliations -->
    <xsl:template match="text()" mode="aff"/>

    <!-- abstract paragraph -->
    <xsl:template match="abstract/p">
        <xsl:value-of select="."/>
        <xsl:if test="position() != last()">
            <xsl:text>&#10;&#10;</xsl:text>
        </xsl:if>
    </xsl:template>

    <!-- ISSN -->
    <xsl:template match="issn">
        <xsl:choose>
            <xsl:when test=".='0000-0000'">
                <!-- obmit out the placeholder ISSN - 0000-0000 -->
            </xsl:when>
            <xsl:otherwise>
                <eissn>
                    <xsl:value-of select="." />
                </eissn>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

</xsl:stylesheet>
