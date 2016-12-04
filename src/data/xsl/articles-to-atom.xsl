<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
                xmlns="http://www.w3.org/2005/Atom"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xlink="http://www.w3.org/1999/xlink"
                xmlns:xhtml="http://www.w3.org/1999/xhtml"
                exclude-result-prefixes="xlink">

    <xsl:output encoding="utf-8" indent="yes"/>
    <xsl:strip-space elements="title summary"/>

    <xsl:param name="now"/>
    <xsl:param name="publication"/>
    <xsl:param name="url"/>
    <xsl:param name="title"/>
    <xsl:param name="description"/>

    <xsl:param name="page" select="1"/>
    <xsl:param name="link-self"/>
    <xsl:param name="link-prev"/>
    <xsl:param name="link-next"/>
    <xsl:param name="link-atom"/>
    <xsl:param name="link-rss"/>
    <xsl:param name="link-rdf"/>
    <xsl:param name="link-html"/>
    <xsl:param name="link-json"/>

    <xsl:template match="/articles">
        <feed>
            <title><xsl:value-of select="$title"/></title>
            <id><xsl:value-of select="$url"/></id>
            <link rel="self" type="application/atom+xml" href="{$url}"/>
            <link rel="search" type="application/opensearchdescription+xml" href="osd.xml"/>
            <subtitle><xsl:value-of select="$description"/></subtitle>
            <updated><xsl:value-of select="$now"/></updated>

            <xsl:apply-templates select="front/article-meta"/>
        </feed>
    </xsl:template>

    <xsl:template match="article-meta">
        <xsl:variable name="pub-date" select="pub-date[@date-type='pub'][@pub-type='epub']|pub-date[@date-type='preprint'][@pub-type='epreprint']"/>
        <entry>
            <title>
                <xsl:value-of select="title-group/article-title"/>
            </title>
            <link rel="self" href="{self-uri/@xlink:href}"/>
            <link rel="license" href="{permissions/license/@xlink:href}"/>
            <link rel="alternate" type="text/html" href="{self-uri/@xlink:href}/"/>
            <link rel="enclosure" type="application/pdf" href="{self-uri/@xlink:href}.pdf"/>
            <id>
                <xsl:value-of select="self-uri/@xlink:href"/>
            </id>
            <updated>
                <xsl:value-of select="$pub-date/@iso-8601-date"/>
            </updated>
            <published>
                <!-- TODO: date first version was published -->
                <xsl:value-of select="$pub-date/@iso-8601-date"/>
            </published>
            <xsl:for-each select="contrib-group/contrib[@contrib-type='author']/name">
                <author>
                    <name>
                        <xsl:value-of select="given-names"/>
                        <xsl:text> </xsl:text>
                        <xsl:value-of select="surname"/>
                    </name>
                </author>
            </xsl:for-each>
            <xsl:for-each select="article-categories/subj-group[@subj-group-type='categories']/subject">
                <category term="{.}"/>
            </xsl:for-each>
            <xsl:apply-templates select="abstract"/>
        </entry>
    </xsl:template>

    <xsl:template match="abstract">
        <summary>
            <xsl:value-of select="."/>
        </summary>
        <content type="xhtml" xml:lang="en" xml:base="{../self-uri/@xlink:href}">
            <xhtml:div>
                <xsl:apply-templates/>
            </xhtml:div>
        </content>
    </xsl:template>

    <xsl:template match="p">
        <xhtml:p>
            <xsl:apply-templates/>
        </xhtml:p>
    </xsl:template>

    <xsl:template match="bold">
        <xhtml:b>
            <xsl:apply-templates/>
        </xhtml:b>
    </xsl:template>

    <xsl:template match="italic">
        <xhtml:i>
            <xsl:apply-templates/>
        </xhtml:i>
    </xsl:template>

    <xsl:template match="sup">
        <xhtml:sup>
            <xsl:apply-templates/>
        </xhtml:sup>
    </xsl:template>

    <xsl:template match="sub">
        <xhtml:sub>
            <xsl:apply-templates/>
        </xhtml:sub>
    </xsl:template>

    <xsl:template match="*">
        <xsl:apply-templates/>
    </xsl:template>
</xsl:stylesheet>
