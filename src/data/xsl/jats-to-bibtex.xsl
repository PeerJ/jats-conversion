<?xml version="1.0" encoding="UTF-8"?>
<stylesheet version="1.0"
            xmlns="http://www.w3.org/1999/XSL/Transform"
            xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <!-- documentation: http://www.refman.com/support/risformat_intro.asp -->
    <output method="text" encoding="utf-8"/>

    <variable name="month-abbreviations" select="'  janfebmaraprmayjunjulaugsepoctnovdec'"/>

    <template match="/">
        <apply-templates select="article/front/article-meta"/>
    </template>

    <template match="article-meta">
        <text>@article{</text>
        <value-of select="article-id[@pub-id-type='doi']"/>
        <text>,&#10;</text>
        <apply-templates select="title-group/article-title"/>
        <apply-templates select="contrib-group[@content-type='authors']"/>
        <apply-templates select="pub-date[@date-type='pub'][@pub-type='epub']|pub-date[@date-type='preprint'][@pub-type='epreprint']"/>
        <apply-templates select="kwd-group[@kwd-group-type='author']"/>
        <apply-templates select="abstract"/>
        <apply-templates select="volume"/>
        <apply-templates select="elocation-id"/>
        <apply-templates select="../journal-meta/journal-title-group/journal-title"/>
        <apply-templates select="../journal-meta/issn"/>
        <apply-templates select="article-id[@pub-id-type='doi']"/><!-- always at the end, to avoid trailing comma -->
        <text>}</text>
    </template>

    <!-- with brackets around the value -->
    <template name="item">
        <param name="key"/>
        <param name="value"/>
        <param name="suffix" select="','"/>
        <value-of select="concat(' ', $key, ' = {', $value, '}', $suffix, '&#10;')"/>
    </template>

    <!-- without brackets around the value -->
    <template name="raw-item">
        <param name="key"/>
        <param name="value"/>
        <param name="suffix" select="','"/>
        <value-of select="concat(' ', $key, ' = ', $value, $suffix, '&#10;')"/>
    </template>

    <template match="article-id[@pub-id-type='doi']">
        <call-template name="item">
            <with-param name="key">url</with-param>
            <with-param name="value" select="concat('https://doi.org/', .)"/>
        </call-template>

        <call-template name="item">
            <with-param name="key">doi</with-param>
            <with-param name="value" select="."/>
            <with-param name="suffix" select="''"/><!-- no trailing comma on the last entry -->
        </call-template>
    </template>

	<template match="article-title">
        <call-template name="item">
            <with-param name="key">title</with-param>
            <with-param name="value">
                <apply-templates mode="markup"/>
            </with-param>
        </call-template>
    </template>

    <template match="contrib-group[@content-type='authors']">
        <call-template name="item">
            <with-param name="key">author</with-param>
            <with-param name="value">
                <apply-templates select="contrib[@contrib-type='author']"/>
            </with-param>
        </call-template>
    </template>

    <!-- contributors (authors and editors) -->
	<template match="contrib[@contrib-type='author']">
        <choose>
            <when test="name">
                <value-of select="name/surname"/>
                <apply-templates select="name/suffix" mode="name"/>
                <apply-templates select="name/given-names" mode="name"/>
            </when>
        </choose>

        <if test="position() != last()">
            <value-of select="' and '"/>
        </if>
	</template>

    <template match="given-names | suffix" mode="name">
        <value-of select="concat(', ', .)"/>
    </template>

    <template match="kwd-group[@kwd-group-type='author']">
        <call-template name="item">
            <with-param name="key">keywords</with-param>
            <with-param name="value">
                <apply-templates select="kwd"/>
            </with-param>
        </call-template>
    </template>

    <template match="kwd">
        <value-of select="."/>

        <if test="position() != last()">
            <value-of select="', '"/>
        </if>
    </template>

    <template match="pub-date">
        <apply-templates select="year"/>
        <apply-templates select="month"/>
    </template>

    <template match="year | volume">
        <call-template name="raw-item">
            <with-param name="key" select="local-name()"/>
            <with-param name="value" select="."/>
        </call-template>
    </template>

    <template match="month">
        <call-template name="raw-item">
            <with-param name="key" select="local-name()"/>
            <with-param name="value">
                <value-of select="substring($month-abbreviations, number(.) * 3, 3)"/>
            </with-param>
        </call-template>
    </template>

    <template match="abstract">
        <call-template name="item">
            <with-param name="key">abstract</with-param>
            <with-param name="value">
                <apply-templates mode="markup"/>
            </with-param>
        </call-template>
    </template>

    <template match="elocation-id">
        <call-template name="item">
            <with-param name="key">pages</with-param>
            <with-param name="value" select="."/>
        </call-template>
    </template>

    <template match="journal-title">
        <call-template name="item">
            <with-param name="key">journal</with-param>
            <with-param name="value" select="."/>
        </call-template>
    </template>

    <template match="issn">
        <choose>
            <when test=".='0000-0000'">
                <!-- miss out the placeholder ISSN - 0000-0000 -->
            </when>
            <otherwise>
                <call-template name="item">
                    <with-param name="key">issn</with-param>
                    <with-param name="value" select="."/>
                </call-template>
            </otherwise>
        </choose>
    </template>

    <!-- formatting markup -->
    <!-- see http://www.tei-c.org/release/doc/tei-xsl-common2/slides/teilatex-slides3.html -->

    <template match="*" mode="markup">
        <xsl:apply-templates mode="markup"/>
    </template>

    <template match="bold" mode="markup">
        <xsl:text>\textbf{</xsl:text>
        <xsl:apply-templates mode="markup"/>
        <xsl:text>}</xsl:text>
    </template>

    <template match="italic" mode="markup">
        <xsl:text>\textit{</xsl:text>
        <xsl:apply-templates mode="markup"/>
        <xsl:text>}</xsl:text>
    </template>

    <template match="underline" mode="markup">
        <xsl:text>\uline{</xsl:text>
        <xsl:apply-templates mode="markup"/>
        <xsl:text>}</xsl:text>
    </template>

    <template match="overline" mode="markup">
        <xsl:text>\textoverbar{</xsl:text>
        <xsl:apply-templates mode="markup"/>
        <xsl:text>}</xsl:text>
    </template>

    <template match="sup" mode="markup">
        <xsl:text>\textsuperscript{</xsl:text>
        <xsl:apply-templates mode="markup"/>
        <xsl:text>}</xsl:text>
    </template>

    <template match="sub" mode="markup">
        <xsl:text>\textsubscript{</xsl:text>
        <xsl:apply-templates mode="markup"/>
        <xsl:text>}</xsl:text>
    </template>

    <template match="sc" mode="markup">
        <xsl:text>\textsc{</xsl:text>
        <xsl:apply-templates mode="markup"/>
        <xsl:text>}</xsl:text>
    </template>

    <template match="monospace" mode="markup">
        <xsl:text>\texttt{</xsl:text>
        <xsl:apply-templates mode="markup"/>
        <xsl:text>}</xsl:text>
    </template>
</stylesheet>
