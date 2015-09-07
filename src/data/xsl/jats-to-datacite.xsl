<?xml version="1.0"?>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                xmlns:xlink="http://www.w3.org/1999/xlink"
                xmlns="http://datacite.org/schema/kernel-3"
                xsi:schemaLocation="http://datacite.org/schema/kernel-3 http://schema.datacite.org/meta/kernel-3/metadata.xsd"
                exclude-result-prefixes="xlink">

    <xsl:output method="xml" indent="yes" encoding="UTF-8" standalone="yes"/>

    <!--<xsl:strip-space elements="aff"/>-->

    <xsl:param name="previousVersionDoi"/>
    <xsl:param name="nextVersionDoi"/>

    <xsl:variable name="doi" select="/article/front/article-meta/article-id[@pub-id-type='doi']"/>
    <xsl:variable name="itemVersion" select="/article/front/article-meta/custom-meta-group/custom-meta[meta-name='version']/meta-value"/>

    <!-- root element -->

    <xsl:template match="/">
        <xsl:apply-templates select="article/front/article-meta"/>
    </xsl:template>

    <!-- item metadata -->

    <xsl:template match="article-meta">
        <xsl:variable name="pub-date" select="pub-date[@date-type='pub'][@pub-type='epub']|pub-date[@date-type='preprint'][@pub-type='epreprint']"/>
        <resource xsi:schemaLocation="http://datacite.org/schema/kernel-3 http://schema.datacite.org/meta/kernel-3/metadata.xsd">
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
                <xsl:apply-templates select="../journal-meta/journal-title-group/journal-title"/>
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
            <relatedIdentifiers>
                <!--<xsl:apply-templates select="../../back/ref-list/ref/pub-id[@pub-id-type='doi']"/>-->
                <xsl:if test="$previousVersionDoi">
                    <relatedIdentifier relatedIdentifierType="DOI" relationType="IsNewVersionOf">
                        <xsl:value-of select="$previousVersionDoi"/>
                    </relatedIdentifier>
                </xsl:if>
                <xsl:if test="$nextVersionDoi">
                    <relatedIdentifier relatedIdentifierType="DOI" relationType="IsPreviousVersionOf">
                        <xsl:value-of select="$nextVersionDoi"/>
                    </relatedIdentifier>
                </xsl:if>
            </relatedIdentifiers>
            <formats>
                <format>application/pdf</format>
                <format>application/xml</format>
                <format>text/html</format>
            </formats>
            <version>
                <xsl:choose>
                    <!-- the "version" custom-meta may not be present -->
                    <xsl:when test="$itemVersion">
                        <xsl:value-of select="$itemVersion"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text>1</xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
            </version>
            <rightsList>
                <rights rightsURI="{permissions/license/@xlink:href}">
                    <!-- TODO: markup? -->
                    <xsl:value-of select="permissions/license/license-p"/>
                </rights>
            </rightsList>
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
            <!-- TODO: markup? -->
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
            <xsl:apply-templates select="name|collab" mode="contrib"/>
            <xsl:apply-templates select="contrib-id[@contrib-id-type='orcid']"/>
            <!-- TODO: affiliation? -->
        </creator>
    </xsl:template>

    <xsl:template match="contrib-id[@contrib-id-type='orcid']">
        <nameIdentifier schemeURI="http://orcid.org/" nameIdentifierScheme="ORCID">
            <xsl:value-of select="."/>
        </nameIdentifier>
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
        <creatorName>
            <xsl:if test="given-names">
                <xsl:value-of select="given-names"/>
                <xsl:text>&#32;</xsl:text>
            </xsl:if>
            <xsl:value-of select="surname"/>
            <xsl:if test="suffix">
                <xsl:text>&#32;</xsl:text>
                <xsl:apply-templates select="suffix"/>
            </xsl:if>
        </creatorName>
    </xsl:template>

    <xsl:template match="collab" mode="contrib">
        <creatorName>
            <xsl:apply-templates select="."/>
        </creatorName>
    </xsl:template>

    <!-- abstract paragraph; no markup except for <br/> -->
    <xsl:template match="abstract/p">
        <xsl:value-of select="."/>
        <xsl:if test="position() != last()">
            <xsl:text>&#10;</xsl:text>
            <br/>
            <xsl:text>&#10;</xsl:text>
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
