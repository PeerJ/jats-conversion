<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <!-- "meta" tags, article -->
    <xsl:template match="article-meta" mode="head">
        <meta name="citation_title" content="{$title}"/>
        <meta name="citation_date" content="{$pub-date/@iso-8601-date}"/>
        <meta name="citation_doi" content="{$doi}"/>
        <meta name="citation_language" content="en"/>
        <meta name="citation_pdf_url" content="{$self-uri}.pdf"/>
        <meta name="citation_fulltext_html_url" content="{$self-uri}"/>

        <xsl:choose>
            <xsl:when test="$publication-type = 'publication'">
                <meta name="citation_volume" content="{volume}"/>
                <meta name="citation_firstpage" content="{elocation-id}"/>
            </xsl:when>
            <xsl:when test="$publication-type = 'preprint'">
                <!-- note: no citation_volume for preprints -->
                <meta name="citation_technical_report_number" content="{elocation-id}"/>
            </xsl:when>
        </xsl:choose>

        <xsl:apply-templates select="$authors/name" mode="citation-author"/>

        <meta name="citation_authors">
            <xsl:attribute name="content">
                <xsl:for-each select="$authors/name">
                    <xsl:value-of select="surname"/>
                    <xsl:if test="given-names">
                        <xsl:text>,&#32;</xsl:text>
                        <xsl:value-of select="given-names"/>
                    </xsl:if>
                    <xsl:call-template name="comma-separator">
                        <xsl:with-param name="separator" select="'; '"/>
                    </xsl:call-template>
                </xsl:for-each>
            </xsl:attribute>
        </meta>

        <meta name="citation_author_institutions">
            <xsl:attribute name="content">
                <xsl:for-each select="contrib-group[@content-type='authors']/aff">
                    <xsl:call-template name="affiliation-address-text"/>
                    <xsl:call-template name="comma-separator">
                        <xsl:with-param name="separator" select="'; '"/>
                    </xsl:call-template>
                </xsl:for-each>
            </xsl:attribute>
        </meta>

        <meta name="description">
            <xsl:attribute name="content">
                <xsl:value-of select="normalize-space(abstract)"/>
                <!--<xsl:value-of select="substring(normalize-space(abstract), 1, 500)"/>-->
                <!--<xsl:text>[&#8230;]</xsl:text>-->
            </xsl:attribute>
        </meta>

        <meta name="citation_keywords">
            <xsl:attribute name="content">
                <xsl:for-each select="kwd-group/kwd">
                    <xsl:value-of select="."/>
                    <xsl:call-template name="comma-separator">
                        <xsl:with-param name="separator" select="'; '"/>
                    </xsl:call-template>
                </xsl:for-each>
            </xsl:attribute>
        </meta>
    </xsl:template>

    <!-- "meta" tags, journal -->
    <xsl:template match="journal-meta" mode="head">
        <xsl:choose>
            <xsl:when test="$publication-type = 'publication'">
                <meta name="citation_journal_title" content="{$journal-title}"/>
                <meta name="citation_journal_abbrev" content="{$abbrev-journal-title}"/>
            </xsl:when>
            <xsl:when test="$publication-type = 'preprint'">
                <meta name="citation_technical_report_institution" content="{$journal-title}"/>
                <!-- note: no citation_journal_abbrev for preprints -->
            </xsl:when>
        </xsl:choose>
        <meta name="citation_publisher" content="{publisher/publisher-name}"/>
        <meta name="citation_issn" content="{issn}"/>
    </xsl:template>

    <!-- citation_author, citation_author_institution, citation_author_email -->
    <xsl:template match="name" mode="citation-author">
        <meta name="citation_author">
            <xsl:attribute name="content">
                <xsl:call-template name="name"/>
            </xsl:attribute>
        </meta>

        <xsl:variable name="affid" select="../xref[@ref-type='aff']/@rid"/>

        <xsl:if test="$affid">
            <xsl:apply-templates select="key('aff', $affid)" mode="citation-author"/>
        </xsl:if>

        <xsl:choose>
            <!-- new-style corresp -->
            <xsl:when test="../email">
                <meta name="citation_author_email" content="{../email}"/>
            </xsl:when>
            <!-- old-style corresp; remove once converted -->
            <xsl:otherwise>
                <xsl:variable name="correspid" select="../xref[@ref-type='corresp']/@rid"/>
                <xsl:if test="$correspid">
                    <xsl:variable name="corresp" select="key('corresp', $correspid)"/>
                    <meta name="citation_author_email" content="{$corresp/email}"/>
                </xsl:if>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="aff" mode="citation-author">
        <meta name="citation_author_institution">
            <xsl:attribute name="content">
                <xsl:call-template name="affiliation-address-text"/>
            </xsl:attribute>
        </meta>
    </xsl:template>
</xsl:stylesheet>
