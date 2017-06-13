<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" exclude-result-prefixes="php"
                xmlns:php="http://php.net/xsl"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xlink="http://www.w3.org/1999/xlink">

    <xsl:output method="xml" encoding="utf-8" omit-xml-declaration="yes" indent="yes"
                doctype-public="-//NLM//DTD JATS (Z39.96) Journal Publishing DTD v1.1 20151215//EN"
                doctype-system="http://jats.nlm.nih.gov/publishing/1.1/JATS-journalpublishing1.dtd"/>

    <xsl:param name="pub-year"/>
    <xsl:param name="pub-month"/>
    <xsl:param name="pub-month-digit"/>
    <xsl:param name="pub-day"/>
    <xsl:param name="pub-day-digit"/>
    <xsl:param name="id"/>
    <xsl:param name="uri"/>
    <xsl:param name="doi"/>

    <xsl:variable name="meta" select="/article/front/article-meta"/>
    <xsl:variable name="related-doi" select="$meta/article-id[@pub-id-type='doi']"/>
    <xsl:variable name="issn" select="/article/front/journal-meta/issn"/>
    <xsl:variable name="pub-date" select="concat($pub-year, '-', $pub-month, '-', $pub-day)"/>
    <!-- Using xsl:copy-of causes issues as copy-of also copies the namespaces,
    which leads to a invalid correction.  Copy-namespaces='no' is xslt 2.0 or greater.
    So until we update XSLT we use this xsl:copy-of replacement notes:
    https://stackoverflow.com/questions/19998180/xsl-copy-nodes-without-xmlns
    -->
    <!-- BEGIN xsl:copy-of replacement -->
    <xsl:template match="*" mode="copy">
        <xsl:element name="{name()}" namespace="{namespace-uri()}">
            <xsl:apply-templates select="@*|node()" mode="copy" />
        </xsl:element>
    </xsl:template>
    <xsl:template match="@*|text()|comment()" mode="copy">
        <xsl:copy/>
    </xsl:template>
    <!-- END xsl:copy-of replacement -->

    <xsl:template match="/article">
        <article article-type="correction" dtd-version="1.1">
            <front>
                <xsl:apply-templates select="front/journal-meta"/>
                <xsl:apply-templates select="front/article-meta"/>
            </front>
            <body>
                <sec>
                    <title></title>
                    <!-- content here -->
                </sec>
            </body>
        </article>
    </xsl:template>

    <xsl:template match="article-meta">
        <article-meta>
            <article-id pub-id-type="publisher-id">
                <xsl:value-of select="$id"/>
            </article-id>
            <article-id pub-id-type="doi">
                <xsl:value-of select="$doi"/>
            </article-id>
            <article-categories>
                <subj-group subj-group-type="heading">
                    <subject>Correction</subject>
                </subj-group>
            </article-categories>
            <title-group>
                <xsl:apply-templates select="title-group/article-title" mode="correction"/>
            </title-group>
            <!-- use xsl:copy-of replacement, see above, for contrib-group: -->
            <xsl:apply-templates mode="copy"
                                 select="contrib-group[@content-type='authors']" />
            <xsl:apply-templates select="aff"/>
            <!-- use xsl:copy-of replacement, see above, for author-notes too: -->
            <xsl:apply-templates mode="copy" select="author-notes"/>
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
                    <!-- TODO: year of original article? -->
                </year>
            </pub-date>
            <xsl:apply-templates select="volume"/>
            <elocation-id>
                <xsl:value-of select="concat('e', $id)"/>
            </elocation-id>
            <permissions>
                <xsl:apply-templates select="permissions/license"/>
                <!-- TODO: different? -->
            </permissions>
            <self-uri xlink:href="{$uri}"/>
            <related-article related-article-type="corrected-article"
                             journal-id-type="issn" journal-id="{$issn}"
                             vol="{volume}" elocation-id="{elocation-id}"
                             ext-link-type="doi" xlink:href="{$related-doi}">
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
