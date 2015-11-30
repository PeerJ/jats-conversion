<?xml version="1.0" encoding="UTF-8"?>
<stylesheet version="1.0" exclude-result-prefixes="xlink"
            xmlns="http://www.w3.org/1999/XSL/Transform"
            xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
            xmlns:cc="http://web.resource.org/cc/"
            xmlns:dc="http://purl.org/dc/elements/1.1/"
            xmlns:rights="http://ns.adobe.com/xap/1.0/rights/"
            xmlns:terms="http://purl.org/dc/terms/"
            xmlns:pdf="http://ns.adobe.com/pdf/1.3/"
            xmlns:foaf="http://xmlns.com/foaf/0.1/"
            xmlns:bibo="http://purl.org/ontology/bibo/"
            xmlns:prism="http://prismstandard.org/namespaces/basic/2.0/"
            xmlns:xlink="http://www.w3.org/1999/xlink">

    <output encoding="utf-8" indent="yes"/>

    <param name="homepage"/>

    <template match="/">
        <apply-templates select="article/front/article-meta"/>
    </template>

    <template match="article-meta">
        <variable name="journal-meta" select="../journal-meta"/>
        <variable name="journal-title" select="$journal-meta/journal-title-group/journal-title"/>

        <variable name="id" select="article-id[@pub-id-type='publisher-id']/text()"/>
        <variable name="doi" select="article-id[@pub-id-type='doi']/text()"/>
        <variable name="url" select="concat('https://doi.org/', $doi)"/>
        <variable name="uri" select="concat('info:doi/', $doi)"/>
        <variable name="title" select="title-group/article-title"/>
        <variable name="pub-date" select="pub-date[@date-type='pub'][@pub-type='epub']|pub-date[@date-type='preprint'][@pub-type='epreprint']"/>

        <variable name="authors" select="contrib-group/contrib[@contrib-type='author']/name"/>

        <variable name="license" select="permissions/license/@xlink:href"/>
        <variable name="license-text" select="concat(permissions/license/license-p, ' ', $license)"/>

        <!--<x:xmpmeta>-->
            <rdf:RDF>
                <rdf:Description rdf:about="{$uri}">
                    <rdf:type rdf:resource="http://purl.org/ontology/bibo/AcademicArticle"/>

                    <comment>Dublin Core: basic, literal properties</comment>
                    <dc:format>application/pdf</dc:format>
                    <dc:identifier>
                        <value-of select="concat('doi:', $doi)"/>
                    </dc:identifier>
                    <dc:title>
                        <value-of select="$title"/>
                    </dc:title>
                    <for-each select="contrib-group/contrib[@contrib-type='author']/name">
                        <dc:creator>
                            <value-of select="given-names"/>
                            <text> </text>
                            <value-of select="surname"/>
                        </dc:creator>
                    </for-each>
                    <for-each select="article-categories/subj-group/subject">
                        <dc:subject>
                            <value-of select="."/>
                        </dc:subject>
                    </for-each>
                    <dc:description>
                        <value-of select="abstract"/>
                    </dc:description>
                    <!--TODO-->
                    <dc:publisher>
                        <value-of select="$journal-meta/publisher/publisher-name"/>
                    </dc:publisher>
                    <dc:rights>
                        <!--
                        <text>Copyright ©&#160;</text>
                        <value-of select="permissions/copyright-year"/>
                        <text> </text>
                        <value-of select="permissions/copyright-holder"/>
                        -->
                        <value-of select="$license-text"/>
                    </dc:rights>

                    <comment>DCMI Metadata Terms: extra, complex properties</comment>
                    <terms:abstract>
                        <value-of select="abstract"/>
                    </terms:abstract>
                    <terms:bibliographicCitation>
                        <value-of select="$authors[1]/surname"/>
                        <if test="count($authors) > 1">
                            <value-of select="' et al.'"/>
                        </if>
                        <value-of select="concat(' (', $pub-date/year, ') ')"/>
                        <value-of select="concat($title, '. ')"/>
                        <value-of select="concat($journal-title, ' ')"/>
                        <value-of select="concat(volume, ':', elocation-id)"/>
                        <value-of select="concat(' ', $url)"/>
                    </terms:bibliographicCitation>
                    <!--TODO-->
                    <for-each select="$authors">
                        <variable name="index" select="position()"/>
                        <!--<terms:creator rdf:ID="author-{$index}">-->
                        <!-- could make authors into separate objects -->
                        <terms:creator>
                            <terms:Agent>
                                <foaf:familyName>
                                    <value-of select="surname"/>
                                </foaf:familyName>
                                <foaf:givenName>
                                    <value-of select="given-names"/>
                                </foaf:givenName>
                                <!--foaf:nick?-->
                            </terms:Agent>
                        </terms:creator>
                    </for-each>
                    <terms:dateSubmitted>
                        <value-of select="history/date[@date-type='received']/@iso-8601-date"/>
                    </terms:dateSubmitted>
                    <terms:dateAccepted>
                        <value-of select="history/date[@date-type='accepted']/@iso-8601-date"/>
                    </terms:dateAccepted>
                    <terms:issued>
                        <value-of select="$pub-date/@iso-8601-date"/>
                    </terms:issued>
                    <terms:format>
                        <terms:MediaTypeOrExtent>
                            <rdf:value>application/pdf</rdf:value>
                        </terms:MediaTypeOrExtent>
                    </terms:format>
                    <terms:format>
                        <terms:MediaTypeOrExtent>
                            <rdf:value>text/html</rdf:value>
                        </terms:MediaTypeOrExtent>
                    </terms:format>
                    <terms:format>
                        <terms:MediaTypeOrExtent>
                            <rdf:value>application/xml</rdf:value>
                        </terms:MediaTypeOrExtent>
                    </terms:format>
                    <terms:identifier>
                        <value-of select="concat('doi:', $doi)"/>
                    </terms:identifier>
                    <terms:isPartOf rdf:resource="urn:issn:{$journal-meta/issn}"/>
                    <terms:license>
                        <terms:LicenseDocument rdf:about="{$license}"/>
                    </terms:license>
                    <terms:rights>
                        <terms:RightsStatement rdf:about="{$license}legalcode"/>
                    </terms:rights>
                    <terms:publisher>
                        <terms:Agent>
                            <foaf:name>
                                <value-of select="$journal-meta/publisher/publisher-name"/>
                            </foaf:name>
                            <foaf:homepage>
                                <value-of select="$homepage"/>
                            <!--
                                <value-of select="$journal-meta/publisher/publisher-loc/uri"/>
                            -->
                            </foaf:homepage>
                        </terms:Agent>
                    </terms:publisher>
                    <for-each select="article-categories/subj-group/subject">
                        <terms:subject rdf:parseType="Resource">
                            <rdf:value>
                                <value-of select="."/>
                            </rdf:value>
                        </terms:subject>
                    </for-each>
                    <terms:title>
                        <value-of select="title-group/article-title"/>
                    </terms:title>
                    <terms:type rdf:resource="http://purl.org/dc/dcmitype/Text"/>

                    <comment>BIBO: extra bibliographic properties</comment>
                    <bibo:authorList rdf:parseType="Collection">
                        <for-each select="$authors">
                            <variable name="index" select="position()"/>
                            <!--
                            <terms:Agent rdf:about="#author-{$index}">
                              <rdf:value><value-of select="given-names"/>&#160;<value-of select="surname"/></rdf:value>
                            </terms:Agent>
                            -->
                            <foaf:Agent>
                                <foaf:familyName>
                                    <value-of select="surname"/>
                                </foaf:familyName>
                                <foaf:givenName>
                                    <value-of select="given-names"/>
                                </foaf:givenName>
                                <!--foaf:nick?-->
                            </foaf:Agent>
                        </for-each>
                    </bibo:authorList>
                    <bibo:doi>
                        <value-of select="$doi"/>
                    </bibo:doi>
                    <bibo:uri>
                        <value-of select="$uri"/>
                    </bibo:uri>
                    <bibo:volume>
                        <value-of select="volume"/>
                    </bibo:volume>

                    <comment>PRISM</comment>
                    <prism:url>
                        <value-of select="$url"/>
                    </prism:url>
                    <prism:doi>
                        <value-of select="$doi"/>
                    </prism:doi>
                    <prism:issn>
                        <value-of select="$journal-meta/issn"/>
                    </prism:issn>
                    <prism:volume>
                        <value-of select="volume"/>
                    </prism:volume>
                    <prism:publicationName>
                        <value-of select="$journal-meta/journal-title-group/journal-title"/>
                    </prism:publicationName>
                    <prism:publicationDate>
                        <value-of select="$pub-date/@iso-8601-date"/>
                    </prism:publicationDate>
                    <prism:copyright>
                        <value-of select="permissions/copyright-statement"/>
                    </prism:copyright>

                    <comment>PDF: keywords</comment>
                    <pdf:Keywords>
                        <for-each select="kwd-group[@kwd-group-type='author']/kwd">
                            <value-of select="."/>
                            <if test="position() != last()"><text>,</text></if>
                        </for-each>
                    </pdf:Keywords>

                    <comment>rights: PDF rights</comment>
                    <rights:Marked>
                        <choose>
                            <when test="permissions/copyright-statement">True</when>
                            <otherwise>False</otherwise>
                        </choose>
                    </rights:Marked>
                    <!--<rights:WebStatement></rights:WebStatement>-->
                    <rights:UsageTerms>
                        <value-of select="$license-text"/>
                    </rights:UsageTerms>

                    <comment>license: Creative Commons license</comment>
                    <cc:license rdf:resource="{$license}"/>
                    <cc:attributionURL rdf:resource="{$url}"/>
                    <cc:attributionName>
                        <value-of select="permissions/copyright-holder"/>
                    </cc:attributionName>
                </rdf:Description>

                <comment>Periodical</comment>
                <rdf:Description rdf:about="urn:issn:{$journal-meta/issn}"
                                 xmlns:dc="http://purl.org/dc/elements/1.1/"
                                 xmlns:bibo="http://purl.org/ontology/bibo/">
                    <rdf:type rdf:resource="http://purl.org/ontology/bibo/Periodical"/>
                    <dc:title>
                        <value-of select="$journal-meta/journal-title-group/journal-title"/>
                    </dc:title>
                    <bibo:uri>
                        <value-of select="$homepage"/>
                    </bibo:uri>
                    <bibo:issn>
                        <value-of select="$journal-meta/issn"/>
                    </bibo:issn>
                </rdf:Description>
            </rdf:RDF>
        <!--</x:xmpmeta>-->
    </template>
</stylesheet>
