<?xml version="1.0" encoding="UTF-8"?>
<stylesheet version="1.0" xmlns="http://www.w3.org/1999/XSL/Transform"
            xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <!-- documentation: http://www.refman.com/support/risformat_intro.asp -->
    <output method="text" encoding="utf-8"/>

    <template match="/">
        <apply-templates select="article/front/article-meta"/>
    </template>

    <template match="article-meta">
        <text>TY  - JOUR</text>
        <text>&#10;</text><!-- newline -->
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

    <template match="article-id[@pub-id-type='doi']">
        <value-of select="concat('UR  - ', 'http://dx.doi.org/', .)"/>
        <text>&#10;</text>
        <value-of select="concat('DO  - ', .)"/>
        <text>&#10;</text>
    </template>

	<template match="article-title">
		<value-of select="concat('TI  - ', .)"/>
		<text>&#10;</text>
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
                <value-of select="concat($tag, '  - ', name/surname)"/>
                <apply-templates select="name/given-names" mode="name"/>
                <apply-templates select="name/suffix" mode="name"/>
            </when>
        </choose>

        <text>&#10;</text>
	</template>

    <template match="given-names | suffix" mode="name">
        <value-of select="concat(',', .)"/>
    </template>

    <template match="pub-date">
        <value-of select="concat('DA  - ', translate(@iso-8601-date,'-','/'))"/>
        <text>&#10;</text>
        <value-of select="concat('PY  - ', year/@iso-8601-date)"/>
        <text>&#10;</text>
    </template>

    <template match="kwd">
        <value-of select="concat('KW  - ', .)"/>
        <text>&#10;</text>
    </template>

    <template match="abstract">
        <value-of select="concat('AB  - ', .)"/>
        <text>&#10;</text>
    </template>

    <template match="volume">
        <value-of select="concat('VL  - ', .)"/>
        <text>&#10;</text>
    </template>

    <template match="elocation-id">
        <value-of select="concat('SP  - ', .)"/>
        <text>&#10;</text>
    </template>

    <template match="journal-title">
         <!-- journal title (new specification) -->
        <value-of select="concat('T2  - ', .)"/>
        <text>&#10;</text>
        <!-- journal title (old specification) -->
        <value-of select="concat('JO  - ', .)"/>
        <text>&#10;</text>
        <!-- abbreviated journal title -->
        <value-of select="concat('J2  - ', .)"/>
        <text>&#10;</text>
    </template>

    <template match="issn">
        <value-of select="concat('SN  - ', .)"/>
        <text>&#10;</text>
    </template>
</stylesheet>
