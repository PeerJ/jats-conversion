<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
            exclude-result-prefixes="xlink"
            xmlns="http://purl.org/rss/1.0/"
            xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
            xmlns:xlink="http://www.w3.org/1999/xlink"
            xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
            xmlns:dc="http://purl.org/dc/elements/1.1/"
            xmlns:cc="http://web.resource.org/cc/"
            xmlns:terms="http://purl.org/dc/terms/"
            xmlns:foaf="http://xmlns.com/foaf/0.1/"
            xmlns:bibo="http://purl.org/ontology/bibo/"
            xmlns:prism="http://prismstandard.org/namespaces/basic/2.0/"
            >

    <xsl:output encoding="utf-8" indent="yes"/>

    <xsl:strip-space elements="title description terms:bibliographicCitation terms:abstract"/>

    <xsl:param name="now"/>
    <xsl:param name="issn"/>
    <xsl:param name="publication"/>
    <xsl:param name="url"/>
    <xsl:param name="logo"/>
    <xsl:param name="publisher"/>
    <xsl:param name="creator"/>

    <xsl:template match="/articles">
        <rdf:RDF>
            <channel rdf:about="{$url}/index.rss1">
                <title><xsl:value-of select="$publication"/></title>
                <link><xsl:value-of select="$url"/></link>
                <description><xsl:value-of select="concat('Recent articles published in ', $publication)"/></description>
                <image rdf:resource="{$logo}"/>

                <dc:publisher><xsl:value-of select="$publisher"/></dc:publisher>
                <dc:creator><xsl:value-of select="$creator"/></dc:creator>
                <dc:date><xsl:value-of select="$now"/></dc:date>

                <prism:publicationName><xsl:value-of select="$publication"/></prism:publicationName>
                <prism:issn>
                    <xsl:value-of select="$issn"/>
                </prism:issn>

                <items>
                    <rdf:Seq>
                        <xsl:apply-templates select="front/article-meta" mode="items"/>
                    </rdf:Seq>
                </items>
            </channel>

            <xsl:apply-templates select="front/article-meta"/>

            <xsl:comment>Periodical</xsl:comment>
            <bibo:Periodical rdf:about="urn:issn:{$issn}">
                <dc:title><xsl:value-of select="$publication"/></dc:title>
                <bibo:uri><xsl:value-of select="$url"/></bibo:uri>
                <bibo:issn>
                    <xsl:value-of select="$issn"/>
                </bibo:issn>
            </bibo:Periodical>
        </rdf:RDF>
    </xsl:template>

    <xsl:template match="article-meta" mode="items">
        <rdf:li rdf:resource="{self-uri/@xlink:href}"/>
    </xsl:template>

    <xsl:template match="article-meta">
        <xsl:variable name="journal-meta" select="../journal-meta"/>
        <xsl:variable name="journal-title" select="$journal-meta/journal-title-group/journal-title"/>

        <xsl:variable name="id" select="article-id[@pub-id-type='publisher-id']/text()"/>
        <xsl:variable name="doi" select="article-id[@pub-id-type='doi']/text()"/>
        <xsl:variable name="url" select="self-uri/@xlink:href"/>
        <xsl:variable name="title" select="title-group/article-title"/>
        <xsl:variable name="pub-date" select="pub-date[@date-type='pub'][@pub-type='epub']|pub-date[@date-type='preprint'][@pub-type='epreprint']"/>

        <xsl:variable name="authors" select="contrib-group/contrib[@contrib-type='author']/name"/>

        <xsl:variable name="license" select="permissions/license/@xlink:href"/>
        <xsl:variable name="license-text" select="concat(permissions/license/license-p, ' ', $license)"/>

        <item rdf:about="{$url}">
            <rdf:type rdf:resource="http://purl.org/ontology/bibo/AcademicArticle"/>

            <link>
                <xsl:value-of select="$url"/>
            </link>
            <title>
                <xsl:value-of select="title-group/article-title"/>
            </title>
            <description>
                <xsl:value-of select="abstract"/>
            </description>

            <xsl:comment>Dublin Core: basic, literal properties</xsl:comment>
            <dc:format>application/pdf</dc:format>
            <dc:format>text/html</dc:format>
            <dc:identifier>
                <xsl:value-of select="concat('doi:', $doi)"/>
            </dc:identifier>
            <dc:title>
                <xsl:value-of select="title-group/article-title"/>
            </dc:title>
            <xsl:for-each select="contrib-group/contrib[@contrib-type='author']/name">
                <dc:creator>
                    <xsl:value-of select="given-names"/>
                    <xsl:text> </xsl:text>
                    <xsl:value-of select="surname"/>
                </dc:creator>
            </xsl:for-each>
            <xsl:for-each select="article-categories/subj-group/subject">
                <dc:subject>
                    <xsl:value-of select="."/>
                </dc:subject>
            </xsl:for-each>
            <dc:description>
                <xsl:value-of select="concat('doi:', $doi)"/>
            </dc:description>
            <dc:publisher>
                <xsl:value-of select="$journal-meta/publisher/publisher-name"/>
            </dc:publisher>
            <dc:rights>
                <xsl:value-of select="concat('©&#160;', permissions/copyright-year, '&#160;', permissions/copyright-holder)"/>
            </dc:rights>

            <xsl:comment>DCMI Metadata Terms: extra, complex properties</xsl:comment>
            <terms:abstract>
                <xsl:value-of select="abstract"/>
            </terms:abstract>
            <terms:bibliographicCitation>
                <xsl:value-of select="$authors[1]/surname"/>
                <xsl:if test="count($authors) > 1">
                    <xsl:value-of select="' et al.'"/>
                </xsl:if>
                <xsl:value-of select="concat(' (', $pub-date/year, ') ')"/>
                <xsl:value-of select="concat($title, '. ')"/>
                <xsl:value-of select="concat($journal-title, ' ')"/>
                <xsl:value-of select="concat(volume, ':', elocation-id)"/>
                <xsl:value-of select="concat(' http://dx.doi.org/', $doi)"/>
            </terms:bibliographicCitation>
            <terms:dateSubmitted>
                <xsl:value-of select="history/date[@date-type='received']/@iso-8601-date"/>
            </terms:dateSubmitted>
            <terms:dateAccepted>
                <xsl:value-of select="history/date[@date-type='accepted']/@iso-8601-date"/>
            </terms:dateAccepted>
            <terms:issued>
                <xsl:value-of select="$pub-date/@iso-8601-date"/>
            </terms:issued>
            <terms:isPartOf rdf:resource="urn:issn:{$issn}"/>
            <terms:license>
                <terms:LicenseDocument rdf:about="{$license}"/>
            </terms:license>

            <xsl:comment>BIBO: extra bibliographic properties</xsl:comment>
            <bibo:authorList rdf:parseType="Collection">
                <xsl:for-each select="$authors">
                    <xsl:variable name="index" select="position()"/>
                    <!--
                    <terms:Agent rdf:about="#author-{$index}">
                      <rdf:value><xsl:value-of select="given-names"/>&#160;<xsl:value-of select="surname"/></rdf:value>
                    </terms:Agent>
                    -->
                    <!-- could make authors into separate objects -->
                    <foaf:Agent>
                        <foaf:familyName>
                            <xsl:value-of select="surname"/>
                        </foaf:familyName>
                        <foaf:givenName>
                            <xsl:value-of select="given-names"/>
                        </foaf:givenName>
                        <!--foaf:nick?-->
                    </foaf:Agent>
                </xsl:for-each>
            </bibo:authorList>
            <bibo:doi>
                <xsl:value-of select="$doi"/>
            </bibo:doi>
            <bibo:uri>
                <xsl:value-of select="$url"/>
            </bibo:uri>
            <bibo:volume>
                <xsl:value-of select="volume"/>
            </bibo:volume>

            <xsl:comment>PRISM (duplicates data in other namespaces)</xsl:comment>
            <prism:url>
                <xsl:value-of select="$url"/>
            </prism:url>
            <prism:doi>
                <xsl:value-of select="$doi"/>
            </prism:doi>
            <prism:issn>
                <xsl:value-of select="$issn"/>
            </prism:issn>
            <prism:volume>
                <xsl:value-of select="volume"/>
            </prism:volume>
            <prism:publicationName>
                <xsl:value-of select="$journal-title"/>
            </prism:publicationName>
            <prism:publicationDate>
                <xsl:value-of select="$pub-date/@iso-8601-date"/>
            </prism:publicationDate>
            <prism:copyright>
                <xsl:value-of select="permissions/copyright-statement"/>
            </prism:copyright>

            <xsl:comment>license</xsl:comment>
            <cc:license rdf:resource="{$license}"/>
            <cc:attributionURL rdf:resource="{$url}"/>
            <cc:attributionName>
                <xsl:value-of select="permissions/copyright-holder"/>
            </cc:attributionName>
        </item>
    </xsl:template>
</xsl:stylesheet>
