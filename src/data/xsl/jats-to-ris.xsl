<?xml version="1.0" encoding="UTF-8"?>
<stylesheet version="1.0" xmlns="http://www.w3.org/1999/XSL/Transform">
    <!-- documentation: http://www.refman.com/support/risformat_intro.asp -->
    <output method="text" encoding="utf-8"/>

    <template match="/">
        <apply-templates select="article/front/article-meta"/>
    </template>

    <template match="article-meta">
        <call-template name="item">
            <with-param name="key">TY</with-param>
            <with-param name="value">JOUR</with-param>
        </call-template>
        <apply-templates select="article-id[@pub-id-type='doi']"/>
        <apply-templates select="title-group/article-title"/>
        <apply-templates select="contrib-group/contrib"/>
        <apply-templates select="pub-date[@date-type='pub'][@pub-type='epub']|pub-date[@date-type='preprint'][@pub-type='epreprint']"/>
        <apply-templates select="kwd-group[@kwd-group-type='author']/kwd"/>
        <apply-templates select="abstract"/>
        <apply-templates select="volume"/>
        <apply-templates select="elocation-id"/>
        <apply-templates select="../journal-meta/journal-title-group/journal-title"/>
        <apply-templates select="../journal-meta/issn"/>
        <text>ER  -&#32;</text><!-- space at the end, might not be necessary -->
    </template>

    <template name="item">
        <param name="key"/>
        <param name="value" select="."/>
        <value-of select="concat($key, '  - ', $value, '&#10;')"/>
    </template>

    <template match="article-id[@pub-id-type='doi']">
        <call-template name="item">
            <with-param name="key">UR</with-param>
            <with-param name="value" select="concat('https://doi.org/', .)"/>
        </call-template>
        <call-template name="item">
            <with-param name="key">DO</with-param>
        </call-template>
    </template>

	<template match="article-title">
        <call-template name="item">
            <with-param name="key">TI</with-param>
        </call-template>
	</template>

    <!-- contributors (authors and editors) -->
	<template match="contrib">
        <variable name="type" select="@contrib-type"/>

        <variable name="tag">
            <choose>
                <when test="$type = 'author'">AU</when>
                <when test="$type = 'editor'">A2</when><!-- ED -->
                <otherwise>A3</otherwise>
            </choose>
        </variable>

        <choose>
            <when test="name">
                <call-template name="item">
                    <with-param name="key" select="$tag"/>
                    <with-param name="value">
                        <value-of select="name/surname"/>
                        <apply-templates select="name/given-names" mode="name"/>
                        <apply-templates select="name/suffix" mode="name"/>
                    </with-param>
                </call-template>
            </when>
        </choose>
	</template>

    <template match="given-names | suffix" mode="name">
        <value-of select="concat(',', .)"/>
    </template>

    <template match="pub-date">
        <call-template name="item">
            <with-param name="key">DA</with-param>
            <with-param name="value" select="translate(@iso-8601-date,'-','/')"/>
        </call-template>
        <call-template name="item">
            <with-param name="key">PY</with-param>
            <with-param name="value" select="year/@iso-8601-date"/>
        </call-template>
    </template>

    <template match="kwd">
        <call-template name="item">
            <with-param name="key">KW</with-param>
        </call-template>
    </template>

    <template match="abstract">
        <call-template name="item">
            <with-param name="key">AB</with-param>
        </call-template>
    </template>

    <template match="volume">
        <call-template name="item">
            <with-param name="key">VL</with-param>
        </call-template>
    </template>

    <template match="elocation-id">
        <call-template name="item">
            <with-param name="key">SP</with-param>
        </call-template>
    </template>

    <template match="journal-title">
         <!-- journal title (new specification) -->
        <call-template name="item">
            <with-param name="key">T2</with-param>
        </call-template>
        <!-- journal title (old specification) -->
        <call-template name="item">
            <with-param name="key">JO</with-param>
        </call-template>
        <!-- abbreviated journal title -->
        <call-template name="item">
            <with-param name="key">J2</with-param>
        </call-template>
    </template>
    <!-- issn -->

    <template match="issn">
        <choose>
            <when test=".='0000-0000'">
                <!-- obmit the placeholder ISSN of 0000-0000 -->
            </when>
            <otherwise>
                <call-template name="item">
                    <with-param name="key">SN</with-param>
                </call-template>
            </otherwise>
        </choose>
    </template>
</stylesheet>
