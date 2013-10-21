<?xml version="1.0"?>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                xmlns:xlink="http://www.w3.org/1999/xlink"
                xmlns="http://datacite.org/schema/kernel-2.2"
                xsi:schemaLocation="http://datacite.org/schema/kernel-2.2 http://schema.datacite.org/meta/kernel-2.2/metadata.xsd"
                exclude-result-prefixes="xlink">

    <xsl:output method="xml" indent="yes" encoding="UTF-8" standalone="yes"/>

    <xsl:strip-space elements="aff"/>

    <xsl:param name="itemVersion" select="'1'"/>
    <xsl:param name="doi" select="/article/front/article-meta/article-id[@pub-id-type='doi']"/>
    <xsl:param name="url" select="/article/front/article-meta/self-uri/@xlink:href"/>

    <!-- root element -->

    <xsl:template match="/">
        <xsl:apply-templates select="article/front/article-meta"/>
    </xsl:template>

    <!-- item metadata -->

    <xsl:template match="article-meta">
        <xsl:variable name="pub-date" select="pub-date[@date-type='pub'][@pub-type='epub']|pub-date[@date-type='preprint'][@pub-type='epreprint']"/>
        <resource xsi:schemaLocation="http://datacite.org/schema/kernel-2.2 http://schema.datacite.org/meta/kernel-2.2/metadata.xsd">
            <identifier identifierType="DOI">
                <xsl:value-of select="$doi"/>
            </identifier>
            <creators>
                <xsl:apply-templates select="contrib-group[@content-type='authors']/contrib[@contrib-type='author']"/>
            </creators>
            <titles>
                <xsl:apply-templates select="title-group/article-title" mode="title"/>
            </titles>
            <publisher>
                <xsl:apply-templates select="../journal-meta/publisher/publisher-name"/>
            </publisher>
            <publicationYear>
                <xsl:apply-templates select="$pub-date/year"/>
            </publicationYear>
            <subjects>
                <xsl:apply-templates select="article-categories/subj-group[@subj-group-type='categories']/subject"/>
            </subjects>
            <!--
            <contributors>
                <xsl:apply-templates select="contrib-group[@content-type='editors']/contrib[@contrib-type='editor']"/>
            </contributors>
            -->
            <dates>
                <!--
                <date dateType="Submitted">
                    <xsl:apply-templates select="history/date[@date-type='received']/@iso-8601-date"/>
                </date>
                -->
                <date dateType="Accepted">
                    <xsl:apply-templates select="history/date[@date-type='accepted']/@iso-8601-date"/>
                </date>
                <date dateType="Issued">
                    <xsl:apply-templates select="$pub-date/@iso-8601-date"/>
                </date>
            </dates>
            <language>eng</language>
            <resourceType resourceTypeGeneral="Text">Article</resourceType>
            <!--
            <relatedIdentifiers>
                <xsl:apply-templates select="../../back/ref-list/ref/pub-id[@pub-id-type='doi']"/>
            </relatedIdentifiers>
            -->
            <formats>
                <format>application/pdf</format>
                <format>application/xml</format>
                <format>text/html</format>
            </formats>
            <version>
                <xsl:value-of select="$itemVersion"/>
            </version>
            <rights>
                <xsl:value-of select="permissions/license/license-p"/>
                <xsl:text>&#32;</xsl:text>
                <xsl:value-of select="permissions/license/@xlink:href"/>
            </rights>
            <descriptions>
                <description descriptionType="Abstract">
                    <xsl:apply-templates select="abstract/p"/>
                </description>
            </descriptions>
        </resource>
    </xsl:template>

    <!-- article title -->

    <xsl:template match="article-title" mode="title">
        <title>
            <xsl:value-of select="."/>
        </title>
    </xsl:template>

    <!-- subject -->

    <xsl:template match="subject">
        <subject>
            <xsl:value-of select="."/>
        </subject>
    </xsl:template>

    <!-- contributors -->

    <xsl:template match="contrib[@contrib-type='author']">
        <creator>
            <creatorName>
                <xsl:apply-templates select="name|collab" mode="contrib"/>
            </creatorName>
        </creator>
    </xsl:template>

    <xsl:template match="contrib[@contrib-type='editor']">
        <contributor contributorType="Editor">
            <contributorName>
                <xsl:apply-templates select="name|collab" mode="contrib"/>
            </contributorName>
        </contributor>
        <creator>

        </creator>
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

    <xsl:template match="collab" mode="contrib">
        <xsl:apply-templates select="."/>
    </xsl:template>

    <!-- abstract paragraph -->
    <xsl:template match="abstract/p">
        <xsl:value-of select="."/>
        <xsl:if test="position() != last()">
            <xsl:text>&#10;&#10;</xsl:text>
        </xsl:if>
    </xsl:template>

    <!-- cited DOIs -->

    <!--
    <xsl:template match="ref/pub-id[@pub-id-type='doi']">
        <relatedIdentifier relatedIdentifierType="DOI" relationType="Cites">
            <xsl:value-of select="."/>
        </relatedIdentifier>
    </xsl:template>
    -->
</xsl:stylesheet>
