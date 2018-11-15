<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:str="http://exslt.org/strings"
                extension-element-prefixes="str">

    <!-- self citation -->
    <xsl:template name="self-citation">
        <xsl:param name="meta"/>

        <dl class="self-citation">
            <dt>Cite this article</dt>
            <dd>
                <xsl:call-template name="self-citation-authors"/>
                <xsl:text>&#32;</xsl:text>
                <span class="self-citation-year">
                    <xsl:value-of select="$pub-date/year"/>
                </span>
                <xsl:text>.&#32;</xsl:text>
                <xsl:apply-templates select="$title" mode="self-citation"/>
                <xsl:call-template name="title-punctuation">
                    <xsl:with-param name="title" select="$title"/>
                </xsl:call-template>
                <xsl:text>&#32;</xsl:text>
	            <span itemprop="isPartOf" itemscope="itemscope"
	                  itemtype="http://schema.org/PublicationVolume">
		            <span class="self-citation-journal"
		                  itemprop="isPartOf" itemscope="itemscope"
		                  itemtype="http://schema.org/Periodical">
			            <span itemprop="name">
				            <xsl:value-of select="$journal-title"/>
			            </span>
		            </span>
		            <xsl:text>&#32;</xsl:text>
		            <span class="self-citation-volume" itemprop="volumeNumber">
			            <xsl:value-of select="$meta/volume"/>
		            </span>
	            </span>
                <xsl:text>:</xsl:text>
                <span class="self-citation-elocation" itemprop="pageStart">
                    <xsl:value-of select="$meta/elocation-id"/>
                </span>
                <xsl:text>&#32;</xsl:text>
                <a href="https://doi.org/{$doi}" itemprop="url">
                    <xsl:value-of select="concat('https://doi.org/', $doi)"/>
                </a>
            </dd>
        </dl>
    </xsl:template>

    <!-- self citation author names -->
    <xsl:template name="self-citation-authors">
        <span class="self-citation-authors">
            <xsl:apply-templates select="$authors/name | $authors/collab" mode="self-citation"/>
            <xsl:text>.</xsl:text>
        </span>
    </xsl:template>

    <xsl:template match="article-title" mode="self-citation">
        <span class="self-citation-title">
            <xsl:apply-templates select="node()|@*"/>
        </span>
    </xsl:template>

       <xsl:template match="name" mode="self-citation">
        <xsl:apply-templates select="surname" mode="self-citation"/>
        <xsl:if test="given-names">
            <xsl:text>&#32;</xsl:text>
            <xsl:apply-templates select="given-names" mode="self-citation"/>
        </xsl:if>
        <xsl:if test="suffix">
            <xsl:text>&#32;</xsl:text>
            <xsl:apply-templates select="suffix" mode="self-citation"/>
        </xsl:if>
        <xsl:call-template name="comma-separator"/>
    </xsl:template>

    <xsl:template match="surname" mode="self-citation">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="suffix" mode="self-citation">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="given-names" mode="self-citation">
        <xsl:choose>
            <xsl:when test="@initials">
                <xsl:value-of select="@initials"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:for-each select="str:tokenize(., ' .')">
                    <xsl:value-of select="substring(., 1, 1)"/>
                </xsl:for-each>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="collab" mode="self-citation">
        <xsl:apply-templates/>
        <xsl:call-template name="comma-separator"/>
    </xsl:template>
</xsl:stylesheet>
