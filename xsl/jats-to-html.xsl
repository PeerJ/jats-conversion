<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" exclude-result-prefixes="xlink mml php"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:mml="http://www.w3.org/1998/Math/MathML"
                xmlns:xlink="http://www.w3.org/1999/xlink"
                xmlns:php="http://php.net/xsl">

    <xsl:output method="xml" encoding="utf-8" omit-xml-declaration="yes" indent="yes"/>

    <xsl:strip-space elements="contrib"/>

    <xsl:param name="public-reviews" select="false()"/>
    <xsl:param name="static-root" select="''"/>
    <xsl:param name="search-root" select="''"/>
    <xsl:param name="download-prefix" select="'file'"/>
    <xsl:param name="publication-type" select="'publication'"/>
    <xsl:param name="self-uri" select="/article/front/article-meta/self-uri/@xlink:href"/>

    <xsl:variable name="meta" select="/article/front/article-meta"/>
    <xsl:variable name="id" select="$meta/article-id[@pub-id-type='publisher-id']"/>
    <xsl:variable name="doi" select="$meta/article-id[@pub-id-type='doi']"/>
    <xsl:variable name="title" select="$meta/title-group/article-title"/>
    <xsl:variable name="pub-date" select="$meta/pub-date[@date-type='pub'][@pub-type='epub']|$meta/pub-date[@date-type='preprint'][@pub-type='epreprint']"/>
    <xsl:variable name="authors" select="$meta/contrib-group[@content-type='authors']/contrib[@contrib-type='author']"/>
    <xsl:variable name="editors" select="$meta/contrib-group[@content-type='editors']/contrib[@contrib-type='editor']"/>

    <xsl:variable name="journal-meta" select="/article/front/journal-meta"/>
    <xsl:variable name="journal-title" select="$journal-meta/journal-title-group/journal-title"/>

    <xsl:variable name="end-punctuation">
        <xsl:text>.?!"')]}</xsl:text>
    </xsl:variable>

    <xsl:key name="ref" match="ref" use="@id"/>
    <xsl:key name="aff" match="aff" use="@id"/>
    <xsl:key name="corresp" match="corresp" use="@id"/> <!-- remove when converted -->

    <!-- article -->
    <xsl:template match="/article">
        <html>
            <!-- article head -->
            <head>
                <meta charset="utf-8"/>
                <meta name="robots" content="noindex"/>
                <title>
                    <xsl:value-of select="$title"/>
                </title>
                <link rel="canonical" href="{$id}"/>
                <xsl:apply-templates select="front/article-meta" mode="head"/>
                <xsl:apply-templates select="front/journal-meta" mode="head"/>
            </head>

            <!-- article body -->
            <body>
                <article itemscope="itemscope" itemtype="http://schema.org/ScholarlyArticle">
                    <xsl:apply-templates select="front/article-meta"/>
                    <xsl:apply-templates select="body"/>
                    <xsl:apply-templates select="back"/>
                    <xsl:apply-templates select="floats-group"/>
                </article>
            </body>
        </html>
    </xsl:template>

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
                <meta name="citation_journal_abbrev" content="{$journal-title}"/>
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

    <!-- front matter -->
    <xsl:template match="front/article-meta">
        <header class="{local-name()} front">
            <xsl:apply-templates select="$title"/>

            <div class="article-authors">
                <xsl:apply-templates select="$authors" mode="front"/>
            </div>

            <div id="article-information">
                <div class="article-notes">
                    <xsl:apply-templates select="contrib-group/aff" mode="front"/>
                    <xsl:apply-templates select="author-notes/fn" mode="front"/>
                </div>

                <dl class="article-identifiers">
                    <dt>
                        <!--<img src="http://www.crossref.org/images/citation_linking_graphic_12x54_trans.png"/>-->
                        <xsl:text>&#32;DOI</xsl:text>
                    </dt>
                    <dd>
                        <a href="http://dx.doi.org/{$doi}" itemprop="identifier">
                            <xsl:value-of select="concat('', $doi)"/>
                        </a>
                    </dd>
                </dl>

                <dl class="article-dates">
                    <dt>Published</dt>
                    <dd>
                        <time itemprop="datePublished">
                            <xsl:value-of select="$pub-date/@iso-8601-date"/>
                        </time>
                    </dd>

                    <xsl:if test="history/date[@date-type='accepted']/@iso-8601-date">
                        <dt>Accepted</dt>
                        <dd>
                            <time itemprop="dateModified">
                                <xsl:value-of select="history/date[@date-type='accepted']/@iso-8601-date"/>
                            </time>
                        </dd>
                    </xsl:if>

                    <xsl:if test="history/date[@date-type='received']/@iso-8601-date">
                        <dt>Received</dt>
                        <dd>
                            <time itemprop="dateCreated">
                                <xsl:value-of select="history/date[@date-type='received']/@iso-8601-date"/>
                            </time>
                        </dd>
                    </xsl:if>
                </dl>

                <xsl:if test="count($editors)">
                    <dl class="article-editors">
                        <dt>Academic Editor</dt>
                        <dd>
                            <xsl:for-each select="$editors">
                                <a href="editor-{ position() }" class="{local-name()}">
                                    <xsl:apply-templates select="node()|@*"/>
                                </a>
                            </xsl:for-each>
                        </dd>
                    </dl>
                </xsl:if>

                <dl class="article-subjects">
                    <dt>Subject Areas</dt>
                    <dd><xsl:apply-templates select="article-categories/subj-group[@subj-group-type='categories']/subject" mode="front"/></dd>

                    <dt>Keywords</dt>
                    <dd><xsl:apply-templates select="kwd-group[@kwd-group-type='author']/kwd" mode="front"/></dd>
                </dl>

                <dl class="article-license">
                    <xsl:apply-templates select="permissions/copyright-statement" mode="front"/>
                    <xsl:apply-templates select="permissions/license" mode="front"/>
                </dl>

                <xsl:call-template name="self-citation">
                    <xsl:with-param name="meta" select="."/>
                </xsl:call-template>

                <xsl:if test="$public-reviews">
                    <xsl:variable name="prefix">
                        <xsl:choose>
                            <xsl:when test="count($authors) = 1">The author has</xsl:when>
                            <xsl:otherwise>The authors have</xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable>
                    <div class="alert alert-success view-public-reviews"><xsl:value-of select="$prefix"/> chosen to make <a href="{$public-reviews}">the review history of this article</a> public.</div>
                </xsl:if>

                <!-- TODO: actual version -->
                <meta itemprop="version" content="1.0"/>
            </div>

            <div>
                <h2>Abstract</h2>
                <xsl:apply-templates select="abstract"/>
            </div>
        </header>
    </xsl:template>

    <!-- abstract -->
    <xsl:template match="abstract">
        <div class="{local-name()}" itemprop="description">
            <xsl:apply-templates select="node()|@*"/>
        </div>
    </xsl:template>

    <!-- aff -->
    <xsl:template match="aff" mode="front">
        <div itemscope="itemscope" itemtype="http://schema.org/Organization">
            <xsl:apply-templates select="@*"/>

            <span class="article-label-container">
                <xsl:apply-templates select="label"/>
                <xsl:if test="not(label)">&#160;</xsl:if><!-- non-breaking space, to prevent collapsing elements -->
            </span>

            <xsl:call-template name="affiliation-address"/>
        </div>
    </xsl:template>

    <!-- affiliation address -->
    <xsl:template name="affiliation-address">
        <xsl:variable name="address-parts" select="node()[not(local-name() = 'label')][not(self::text())]"/>

        <xsl:if test="count($address-parts)">
            <span itemprop="address">
                <xsl:for-each select="$address-parts">
                    <xsl:apply-templates select="."/>
                    <xsl:call-template name="comma-separator"/>
                </xsl:for-each>
            </span>
        </xsl:if>
    </xsl:template>

    <!-- affiliation address as text string -->
    <xsl:template name="affiliation-address-text">
        <xsl:variable name="address">
            <xsl:call-template name="affiliation-address"/>
        </xsl:variable>

        <xsl:value-of select="$address"/>
    </xsl:template>

    <!-- fn -->
    <xsl:template match="fn" mode="front">
        <div>
            <xsl:apply-templates select="@*"/>
            <span class="article-label-container">
                <xsl:apply-templates select="label"/>
                <xsl:if test="not(label)">&#160;</xsl:if>
                <!-- non-breaking space, to prevent collapsing elements -->
            </span>
            <span>
                <xsl:apply-templates select="node()[not(local-name() = 'label')]"/>
            </span>
        </div>
    </xsl:template>

    <xsl:template match="fn/label | aff/label">
        <a class="article-label">
            <xsl:apply-templates/>
        </a>
    </xsl:template>

    <xsl:template name="comma-separator">
        <xsl:param name="separator" select="', '"/>
        <xsl:if test="position() != last()">
            <xsl:value-of select="$separator"/>
        </xsl:if>
    </xsl:template>

    <xsl:template name="title-punctuation">
        <xsl:param name="title" select="."/>
        <xsl:variable name="last-character" select="substring($title, string-length($title))"/>
        <xsl:if test="not(contains($end-punctuation, $last-character))">
            <xsl:text>.</xsl:text>
        </xsl:if>
    </xsl:template>

    <!-- subject area -->
    <xsl:template match="subject" mode="front">
        <xsl:variable name="encoded-subject">
            <xsl:call-template name="urlencode">
                <xsl:with-param name="value" select="."/>
            </xsl:call-template>
        </xsl:variable>

        <a class="{local-name()}" itemprop="about" href="{$search-root}?filter={$encoded-subject}">
            <xsl:apply-templates select="node()|@*"/>
        </a>
        <xsl:call-template name="comma-separator"/>
    </xsl:template>

    <!-- keyword -->
    <xsl:template match="kwd" mode="front">
        <span class="{local-name()}" itemprop="keywords">
            <xsl:apply-templates select="node()|@*"/>
        </span>
        <xsl:call-template name="comma-separator"/>
    </xsl:template>

    <!-- copyright statement -->
    <xsl:template match="copyright-statement" mode="front">
        <dt>Copyright</dt>
        <dd>
            <xsl:text>©&#32;</xsl:text>
            <span itemprop="copyrightYear">
                <xsl:value-of select="../copyright-year"/>
            </span>
            <xsl:text>&#32;</xsl:text>
            <span itemprop="copyrightHolder">
                <xsl:value-of select="../copyright-holder"/>
            </span>
            <!--<xsl:apply-templates select="node()"/>-->
        </dd>
    </xsl:template>

    <!-- license -->
    <xsl:template match="license" mode="front">
        <dt>Licence</dt>
        <dd>
            <xsl:apply-templates select="node()"/>
        </dd>
    </xsl:template>

    <!-- license paragraph -->
    <xsl:template match="license-p">
        <span class="{local-name()}">
            <xsl:apply-templates select="node()|@*"/>
        </span>
    </xsl:template>

    <!-- funding-statement -->
    <xsl:template match="funding-statement" mode="back">
        <h3 class="heading">Funding</h3>
        <div>
            <xsl:apply-templates select="node()"/>
        </div>
    </xsl:template>

    <xsl:template match="body">
        <main>
            <div class="{local-name()}" lang="en">
                <xsl:apply-templates select="node()|@*"/>
            </div>

            <xsl:call-template name="footnotes">
                <xsl:with-param name="footnotes" select="descendant::fn[preceding-sibling::xref[@ref-type='fn']]"/>
            </xsl:call-template>
        </main>
    </xsl:template>

    <!-- don't display footnotes inline -->
    <xsl:template match="body//fn[preceding-sibling::xref[@ref-type='fn']]"/>

    <xsl:template name="footnotes">
        <xsl:param name="footnotes"/>

        <xsl:if test="$footnotes">
            <div id="article-footnotes">
                <xsl:for-each select="$footnotes">
                    <div class="fn article-footnote">
                        <xsl:apply-templates select="node()[not(local-name() = 'label')]|@*"/>
                    </div>
                </xsl:for-each>
            </div>
        </xsl:if>
    </xsl:template>

    <xsl:template match="back">
        <footer class="{local-name()}">
            <xsl:apply-templates select="node()|@*"/>
        </footer>
    </xsl:template>

    <xsl:template match="sec[@sec-type='additional-information']">
        <div class="{local-name()}">
            <xsl:apply-templates select="node()|@*"/>
            <xsl:apply-templates select="$meta/funding-group/funding-statement" mode="back"/>
        </div>
    </xsl:template>

    <!-- contrib in front matter -->
    <xsl:template match="contrib" mode="front">
        <span class="{local-name()}" itemscope="itemscope" itemtype="http://schema.org/Person">
            <xsl:apply-templates select="@*"/>

            <xsl:if test="@contrib-type = 'author'">
                <xsl:attribute name="itemprop">author</xsl:attribute>
            </xsl:if>

            <xsl:choose>
                <xsl:when test="@contrib-type = 'author'">
                    <xsl:variable name="author-index" select="count(preceding::contrib[@contrib-type='author']) + 1"/>
                    <a href="author-{$author-index}" rel="author"><xsl:apply-templates select="name | collab"/></a>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates select="name | collab"/>
                </xsl:otherwise>
            </xsl:choose>

            <xsl:choose>
                <xsl:when test="@corresp = 'yes' and email">
                    <xsl:call-template name="corresponding-email">
                        <xsl:with-param name="email" select="email"/>
                    </xsl:call-template>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates select="xref[@ref-type='corresp']" mode="author"/>
                </xsl:otherwise>
            </xsl:choose>

            <xsl:if test="@equal-contrib = 'yes'">
                <xsl:call-template name="equal-contribution"/>
            </xsl:if>

            <xsl:if test="@deceased = 'yes'">
                <xsl:call-template name="deceased"/>
            </xsl:if>

            <xsl:if test="xref">
                <xsl:variable name="xrefs">
                    <xsl:for-each select="xref[not(@ref-type='corresp')]">
                        <xsl:variable name="rid" select="@rid"/>
                        <xsl:variable name="ref" select="//*[@id=$rid]"/>
                        <xsl:if test="$ref/label">
                            <!--<xsl:variable name="ref-type" select="@ref-type"/>-->
                            <xsl:apply-templates select="$ref" mode="contrib-xref"/>
                            <xsl:call-template name="comma-separator">
                                <xsl:with-param name="separator" select="','"/>
                            </xsl:call-template>
                        </xsl:if>
                    </xsl:for-each>
                </xsl:variable>

                <xsl:if test="string-length($xrefs)">
                    <sup class="contrib-xref-group">
                       <xsl:copy-of select="$xrefs"/>
                    </sup>
                </xsl:if>
            </xsl:if>
        </span>
        <xsl:call-template name="comma-separator"/>

        <!--
            <xsl:variable name="contributorId" select="@id"/>
            <xsl:variable name="contribution" select="//fn-group[@content-type='author-contributions']//fn[@fn-type='con']//xref[@ref-type='contrib'][@rid=$contributorId]"/>
            <xsl:if test="$contribution">
                <xsl:apply-templates select="$contribution/ancestor::fn"/>
            </xsl:if>
        -->
    </xsl:template>

    <!-- affiliation/corresponding author/footnote link -->
    <xsl:template match="*" mode="contrib-xref">
        <a class="{local-name()} xref" href="#{@id}">
            <xsl:if test="local-name() = 'aff'">
                <xsl:attribute name="itemprop">affiliation</xsl:attribute>
                <xsl:attribute name="itemscope">itemscope</xsl:attribute>
                <xsl:attribute name="itemtype">http://schema.org/Organization</xsl:attribute>
                <xsl:attribute name="itemref"><xsl:value-of select="@id"/></xsl:attribute>
            </xsl:if>
            <xsl:value-of select="label"/>
        </a>
    </xsl:template>

    <!-- corresponding author (old-style; remove when converted) -->
    <xsl:template match="xref[@ref-type='corresp']" mode="author">
        <xsl:variable name="ref" select="key('corresp', @rid)"/>
        <xsl:call-template name="corresponding-email">
            <xsl:with-param name="email" select="$ref/email"/>
        </xsl:call-template>
    </xsl:template>

    <!-- email the corresponding author -->
    <xsl:template name="corresponding-email">
        <xsl:param name="email"/>
        <a class="corresp" href="mailto:{$email}" target="_blank" title="email the corresponding author" rel="tooltip" itemprop="email">
            <i class="icon-envelope">&#160;</i>
        </a>
    </xsl:template>

    <!-- authors with equal contributions -->
    <xsl:template name="equal-contribution">
        <span class="equal-contribution" title="These authors contributed equally to this work." rel="tooltip">
            <i class="icon-asterisk">&#160;</i>
        </span>
    </xsl:template>

    <!-- deceased authors -->
    <xsl:template name="deceased">
        <span class="deceased" title="Deceased" rel="tooltip">
            <i class="icon-star-empty">&#160;</i>
        </span>
    </xsl:template>

    <!-- any label -->
    <xsl:template match="label">
        <span class="article-label">
            <xsl:apply-templates select="node()|@*"/>
        </span>
    </xsl:template>

    <xsl:template match="label" mode="front">
        <span class="article-label">
            <xsl:apply-templates select="node()|@*"/>
        </span>
    </xsl:template>

    <xsl:template match="label" mode="caption">
        <span class="caption-label">
            <xsl:apply-templates select="node()|@*"/>
            <xsl:text>:&#32;</xsl:text>
        </span>
    </xsl:template>

    <!-- ordered list -->
    <xsl:template match="list[@list-type='order']">
        <ol class="{local-name()}">
            <xsl:apply-templates select="node()|@*"/>
        </ol>
    </xsl:template>

    <!-- unordered list -->
    <xsl:template match="list">
        <ul class="{local-name()}">
            <xsl:apply-templates select="node()|@*"/>
        </ul>
    </xsl:template>

    <!-- list item -->
    <xsl:template match="list-item">
        <li class="{local-name()}">
            <xsl:apply-templates select="node()|@*"/>
        </li>
    </xsl:template>

    <!-- paragraph -->
    <xsl:template match="p">
        <p>
            <xsl:apply-templates select="node()|@*"/>
        </p>
    </xsl:template>

    <!-- the article title -->
    <xsl:template match="article-title">
        <h1 class="{local-name()}" itemprop="name">
            <xsl:apply-templates select="node()|@*"/>
        </h1>
    </xsl:template>

    <!-- people -->
    <xsl:template match="person-group">
        <div class="{local-name()}">
            <xsl:apply-templates select="node()|@*"/>
        </div>
    </xsl:template>

    <!-- name -->
    <xsl:template name="name">
        <xsl:apply-templates select="given-names"/>
        <xsl:if test="surname">
            <xsl:text>&#32;</xsl:text>
            <xsl:apply-templates select="surname"/>
        </xsl:if>
        <xsl:if test="suffix">
            <xsl:text>&#32;</xsl:text>
            <xsl:apply-templates select="suffix"/>
        </xsl:if>
    </xsl:template>

    <xsl:template match="given-names">
        <span class="{local-name()}" itemprop="givenName">
            <xsl:apply-templates select="node()|@*"/>
        </span>
    </xsl:template>

    <xsl:template match="surname">
        <span class="{local-name()}" itemprop="familyName">
            <xsl:apply-templates select="node()|@*"/>
        </span>
    </xsl:template>

    <!-- name -->
    <xsl:template match="name">
        <span class="{local-name()}" itemprop="name">
            <xsl:call-template name="name"/>
        </span>
        <xsl:call-template name="comma-separator"/>
    </xsl:template>

    <xsl:template match="collab">
        <span class="{local-name()} name" itemprop="name">
            <xsl:apply-templates select="node()|@*"/>
        </span>
    </xsl:template>

    <!-- text formatting -->
    <!--
    <xsl:template match="italic">
        <span class="{local-name()}">
            <xsl:call-template name="add-style">
                <xsl:with-param name="style">font-style:italic</xsl:with-param>
            </xsl:call-template>
            <xsl:apply-templates select="node()|@*"/>
        </span>
    </xsl:template>

    <xsl:template match="bold">
        <span class="{local-name()}">
            <xsl:call-template name="add-style">
                <xsl:with-param name="style">font-weight:bold</xsl:with-param>
            </xsl:call-template>
            <xsl:apply-templates select="node()|@*"/>
        </span>
    </xsl:template>
    -->

    <xsl:template match="italic">
        <i>
            <xsl:apply-templates select="node()|@*"/>
        </i>
    </xsl:template>

    <xsl:template match="bold">
        <b>
            <xsl:apply-templates select="node()|@*"/>
        </b>
    </xsl:template>

    <xsl:template match="sub">
        <sub>
            <xsl:apply-templates select="node()|@*"/>
        </sub>
    </xsl:template>

    <xsl:template match="sup">
        <sup>
            <xsl:apply-templates select="node()|@*"/>
        </sup>
    </xsl:template>

    <xsl:template match="underline">
        <u>
            <xsl:apply-templates select="node()|@*"/>
        </u>
    </xsl:template>

    <xsl:template match="break">
        <br/>
    </xsl:template>

    <!-- style elements -->
    <xsl:template match="sc | strike | roman | sans-serif | monospace | overline">
        <span class="{local-name()}">
            <xsl:apply-templates select="node()|@*"/>
        </span>
    </xsl:template>

    <!-- inline elements -->
    <xsl:template
        match="abbrev | suffix | email | year | month | day
        | xref | contrib | source | volume | fpage | lpage | etal | pub-id
        | named-content | styled-content | funding-source | award-id | institution | country | addr-line
        | chem-struct">
        <span class="{local-name()}">
            <xsl:apply-templates select="node()|@*"/>
        </span>
    </xsl:template>

    <!-- links -->
    <xsl:template match="uri">
        <a class="{local-name()}">
            <xsl:attribute name="href">
                <xsl:choose>
                    <xsl:when test="@xlink:href">
                        <xsl:value-of select="@xlink:href"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="."/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>
            <xsl:apply-templates select="node()|@*"/>
        </a>
    </xsl:template>

    <!-- table elements -->
    <xsl:template match="table | tbody | thead | tfoot | column | tr | th | td | colgroup | col">
        <xsl:element name="{local-name()}">
            <xsl:apply-templates select="node()|@*"/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="table-wrap">
        <div class="{local-name()}">
            <xsl:apply-templates select="@*"/>
            <xsl:apply-templates select="caption" mode="table"/>
            <xsl:apply-templates/>
        </div>
    </xsl:template>

    <xsl:template match="table-wrap/alternatives">
        <div class="table-container">
            <xsl:apply-templates select="table"/>
        </div>

        <xsl:apply-templates select="../object-id[@pub-id-type='doi']" mode="caption"/>
    </xsl:template>

    <!-- table caption and label are handled elsewhere -->
    <xsl:template match="table-wrap/caption | table-wrap/label"></xsl:template>

    <xsl:template match="caption" mode="table">
        <div class="{local-name()}">
            <xsl:apply-templates select="@*"/>
            <xsl:apply-templates select="preceding-sibling::label" mode="caption"/>
            <xsl:apply-templates select="node()"/>
        </div>
    </xsl:template>

    <xsl:template match="table-wrap-foot/fn/p[normalize-space(.) = 'Notes.']">
        <p class="table-wrap-foot-notes">
            <b>Notes:</b>
        </p>
    </xsl:template>

    <!--<xsl:template match="table/label"></xsl:template>-->

    <!-- label with a paragraph straight afterwards -->
    <!--<xsl:template match="label[following-sibling::p]"></xsl:template>-->

    <!--
    <xsl:template match="label" mode="included-label">
        <span class="article-label">
            <xsl:apply-templates select="node()|@*"/>
        </span>
    </xsl:template>
    -->

    <xsl:template match="p[ancestor::caption]">
        <span class="{local-name()}">
            <xsl:apply-templates select="@*"/>
            <xsl:apply-templates select="node()"/>
        </span>
    </xsl:template>

    <xsl:template match="fn/p[preceding-sibling::label]">
        <span class="{local-name()}">
            <xsl:apply-templates select="@*"/>
            <!--<xsl:apply-templates select="preceding-sibling::label" mode="included-label"/>-->
            <xsl:apply-templates select="node()"/>
        </span>
    </xsl:template>


    <!-- object DOI -->
    <xsl:template match="object-id[@pub-id-type=doi]">
        <a class="{local-name()}" href="http://dx.doi.org/{.}">
            <xsl:apply-templates select="node()|@*"/>
        </a>
    </xsl:template>

    <!-- other object ID -->
    <xsl:template match="object-id"></xsl:template>

    <!-- sections -->
    <xsl:template match="sec">
        <section class="{local-name()}">
            <xsl:apply-templates select="node()|@*"/>
        </section>
    </xsl:template>

    <!-- section headings -->
    <xsl:template match="title">
        <xsl:variable name="heading-level"
                      select="count(ancestor::sec | ancestor::back | ancestor::fig | ancestor::g) + 1"/>

        <xsl:if test="$heading-level > 6">
            <xsl:variable name="heading-level">6</xsl:variable>
        </xsl:if>

        <xsl:variable name="heading">h<xsl:value-of select="$heading-level"/></xsl:variable>

        <xsl:element name="{$heading}">
            <xsl:attribute name="class">heading</xsl:attribute>
            <xsl:if test="parent::caption and ancestor::fig">
                <xsl:apply-templates select="../../label" mode="caption"/>
            </xsl:if>
            <xsl:if test="preceding-sibling::label">
                <xsl:apply-templates select="preceding-sibling::label" mode="caption"/>
            </xsl:if>
            <xsl:apply-templates select="node()|@*"/>
        </xsl:element>
    </xsl:template>

    <!-- additional material -->

    <xsl:template match="sec[@sec-type='additional-information']/title">
        <h2 class="heading">
            <xsl:apply-templates select="node()|@*"/>
        </h2>
    </xsl:template>

    <!-- links -->
    <xsl:template match="ext-link">
        <a class="{local-name()}" href="{@xlink:href}">
            <xsl:apply-templates select="node()|@*"/>
        </a>
    </xsl:template>

    <xsl:template match="ext-link[@ext-link-type='doi']">
        <xsl:variable name="encoded-doi">
            <xsl:call-template name="urlencode">
                <xsl:with-param name="value" select="@xlink:href"/>
            </xsl:call-template>
        </xsl:variable>

        <a class="{local-name()}" href="http://dx.doi.org/{$encoded-doi}">
            <xsl:apply-templates select="node()|@*"/>
        </a>
    </xsl:template>

    <xsl:template match="license-p/ext-link">
        <a class="{local-name()}" href="{@xlink:href}" rel="license">
            <xsl:apply-templates select="node()|@*"/>
        </a>
    </xsl:template>

    <!-- quotes -->
    <xsl:template match="disp-quote">
        <blockquote class="{local-name()}">
            <xsl:apply-templates select="node()|@*"/>
        </blockquote>
    </xsl:template>

    <!-- formulae -->
    <xsl:template match="inline-formula">
        <span class="{local-name()}">
            <xsl:apply-templates select="node()|@*"/>
        </span>
    </xsl:template>

    <!-- displ-formula has to be span, as it can appear inside a p -->
    <xsl:template match="disp-formula">
        <span class="{local-name()}">
            <xsl:apply-templates select="node()|@*"/>
        </span>
    </xsl:template>

    <xsl:template match="inline-formula/alternatives">
        <xsl:call-template name="formula-alternatives"/>
    </xsl:template>

    <xsl:template match="disp-formula/alternatives">
        <xsl:call-template name="formula-alternatives"/>
    </xsl:template>

    <xsl:template name="formula-alternatives">
        <xsl:choose>
            <xsl:when test="mml:math">
                <xsl:apply-templates select="mml:math"/>
            </xsl:when>
            <xsl:when test="inline-graphic">
                <xsl:apply-templates select="inline-graphic"/>
            </xsl:when>
            <xsl:when test="tex-math">
                <xsl:apply-templates select="tex-math"/>
            </xsl:when>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="tex-math">
        <span class="{local-name()}">
            <xsl:value-of select="."/>
        </span>
    </xsl:template>

    <!-- cross-reference -->
    <xsl:template match="xref">
        <a class="{local-name()} xref-{@ref-type}" href="#{@rid}">
            <xsl:apply-templates select="node()|@*"/>
        </a>
    </xsl:template>

    <!-- bibliographic reference -->
    <xsl:template match="xref[@ref-type='bibr']">
        <xsl:variable name="ref" select="key('ref', @rid)"/>
        <xsl:variable name="citation" select="$ref/element-citation"/>

        <xsl:variable name="title">
            <xsl:choose>
                <xsl:when test="$citation/article-title">
                    <xsl:value-of select="$citation/article-title"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$citation/source"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="ref-doi" select="$ref/*/pub-id[@pub-id-type='doi']"/>
        <xsl:variable name="ref-uri" select="$ref/*/comment/uri"/>
        <xsl:variable name="url">
            <xsl:call-template name="citation-url">
                <xsl:with-param name="citation" select="$citation"/>
            </xsl:call-template>
        </xsl:variable>

        <a class="{local-name()} xref-{@ref-type}" href="{$url}" title="{$title}">
            <xsl:apply-templates select="node()|@*"/>
        </a>
    </xsl:template>

    <!-- figure -->
    <xsl:template match="fig">
        <figure class="{local-name()}">
            <xsl:apply-templates select="@*"/>

            <div class="image-container">
                <xsl:apply-templates select="graphic" mode="fig"/>
            </div>

            <xsl:apply-templates select="caption" mode="fig"/>

            <xsl:apply-templates select="p"/>
        </figure>
    </xsl:template>

    <xsl:template match="caption" mode="fig">
        <figcaption>
            <xsl:if test="not(title)">
                <xsl:apply-templates select="preceding-sibling::label" mode="caption"/>
            </xsl:if>

            <xsl:apply-templates select="node()|@*"/>

            <div class="article-image-download">
                <xsl:variable name="fig-id" select="../@id"/>
                <a href="{$static-root}{$fig-id}-full.png" class="btn btn-mini" download="{$download-prefix}-{$id}-{$fig-id}.png">
                    <i class="icon-picture">&#160;</i>
                    <xsl:text>&#32;Download full-size image</xsl:text>
                </a>
            </div>

            <xsl:apply-templates select="../object-id[@pub-id-type='doi']" mode="caption"/>
        </figcaption>
    </xsl:template>

    <!-- DOI in a caption -->
    <xsl:template match="object-id[@pub-id-type='doi']" mode="caption">
        <div class="{local-name()} article-component-doi">
            <xsl:text>DOI:&#32;</xsl:text>
            <a href="{concat('http://dx.doi.org/', .)}" rel="tooltip" title="Cite this object using this DOI">
                <xsl:value-of select="."/>
            </a>
        </div>
    </xsl:template>

    <!-- figure title -->
    <xsl:template match="title[ancestor::table-wrap]">
        <div class="{local-name()}">
            <xsl:apply-templates select="node()|@*"/>
        </div>
    </xsl:template>

    <!-- figure title -->
    <xsl:template match="title" mode="fig">
        <div class="{local-name()}">
            <xsl:apply-templates select="node()|@*"/>
        </div>
    </xsl:template>

    <!-- graphic -->
    <xsl:template match="graphic | inline-graphic">
        <img class="{local-name()}" src="{$static-root}{@xlink:href}" data-filename="{@xlink:href}">
            <xsl:apply-templates select="@*"/>
        </img>
    </xsl:template>

    <!-- figure graphic -->
    <!-- TODO: image width and height -->
    <xsl:template match="graphic" mode="fig">
        <xsl:variable name="fig" select=".."/>
        <xsl:variable name="fig-id" select="$fig/@id"/>
        <a href="{$static-root}{$fig-id}-2x.jpg"
           title="View the full image">
            <img class="{local-name()}" src="{$static-root}{@xlink:href}"
                alt="{$fig/caption/title}" data-image-type="figure">
                <xsl:apply-templates select="@*"/>
            </img>
        </a>
    </xsl:template>

    <!-- list -->
    <xsl:template match="list[@list-type='order']">
        <ol>
            <xsl:apply-templates select="node()|@*"/>
        </ol>
    </xsl:template>

    <xsl:template match="list[@list-type='bullet']">
        <ul>
            <xsl:apply-templates select="node()|@*"/>
        </ul>
    </xsl:template>

    <!-- list item -->
    <xsl:template match="list-item">
        <li>
            <xsl:apply-templates select="node()|@*"/>
        </li>
    </xsl:template>

    <!-- definition list -->
    <xsl:template match="def-list">
        <dl>
            <xsl:apply-templates select="node()|@*"/>
        </dl>
    </xsl:template>

    <xsl:template match="def-item">
        <xsl:apply-templates select="term" mode="def-item"/>
        <xsl:apply-templates select="def" mode="def-item"/>
    </xsl:template>

    <xsl:template match="term" mode="def-item">
        <dt>
            <xsl:apply-templates select="node()|@*"/>
        </dt>
    </xsl:template>

    <xsl:template match="def" mode="def-item">
        <dd>
            <xsl:apply-templates select="node()|@*"/>
        </dd>
    </xsl:template>

    <!-- TODO -->
    <xsl:template match="list-item/label"></xsl:template>

    <!-- supplementary material -->
    <xsl:template match="supplementary-material">
        <div class="{local-name()} well well-small">
            <xsl:apply-templates select="@*"/>
            <h3 class="heading">
                <!--<xsl:apply-templates select="label/text()"/>-->
                <xsl:choose>
                    <xsl:when test="normalize-space(caption/title) != ''">
                        <xsl:apply-templates select="caption/title" mode="supp-title"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="label"/>
                    </xsl:otherwise>
                </xsl:choose>
            </h3>

            <xsl:apply-templates select="caption"/>
        </div>
    </xsl:template>

    <xsl:template match="supplementary-material/caption">
        <xsl:apply-templates select="node()|@*"/>
        <xsl:apply-templates select="../object-id[@pub-id-type='doi']" mode="caption"/>

        <xsl:variable name="filename" select="../@xlink:href"/>

        <xsl:variable name="encoded-filename">
            <xsl:call-template name="urlencode">
                <xsl:with-param name="value" select="$filename"/>
            </xsl:call-template>
        </xsl:variable>

        <div>
            <a href="{$static-root}{$encoded-filename}" class="btn article-supporting-download"
               download="{$filename}" data-filename="{$filename}">
                <i class="icon-download-alt">&#160;</i>
                <!--<xsl:value-of select="concat(' Download .', ../@mime-subtype)"/>-->
                <xsl:value-of select="' Download'"/>
            </a>
        </div>
    </xsl:template>

    <xsl:template match="supplementary-material/caption/title"></xsl:template>

    <xsl:template match="supplementary-material/caption/title" mode="supp-title">
        <!--<xsl:text>:&#32;</xsl:text>-->
        <xsl:apply-templates select="node()"/>
    </xsl:template>

    <!-- acknowledgments -->
    <xsl:template match="ack">
        <section class="{local-name()}" id="acknowledgements">
            <xsl:apply-templates select="@*"/>
            <h2 class="heading">Acknowledgements</h2>
            <xsl:apply-templates select="node()"/>
        </section>
    </xsl:template>

    <!-- appendices -->
    <xsl:template match="app-group">
        <xsl:apply-templates select="app"/>
    </xsl:template>

    <!-- appendix -->
    <xsl:template match="app">
        <section class="{local-name()}">
            <xsl:apply-templates select="node()|@*"/>
        </section>
    </xsl:template>

    <!-- appendix label -->
    <xsl:template match="app/label">
        <h2 class="heading">
            <xsl:apply-templates/>
        </h2>
    </xsl:template>

    <!-- appendix title -->
    <xsl:template match="app/title"/>

    <!-- reference list -->
    <xsl:template match="ref-list">
        <section class="ref-list-container" id="references">
            <xsl:apply-templates select="title"/>
            <ul class="{local-name()}">
                <xsl:apply-templates select="ref|@*"/>
            </ul>
        </section>
    </xsl:template>

    <!-- reference list item -->
    <xsl:template match="ref-list/ref">
        <li class="{local-name()}">
            <div class="citation" itemprop="citation" itemscope="itemscope">
                <xsl:choose>
                    <xsl:when test="element-citation/@publication-type = 'journal'">
                        <xsl:attribute name="itemtype">http://schema.org/ScholarlyArticle</xsl:attribute>
                    </xsl:when>
                    <xsl:when test="element-citation/@publication-type = 'book'">
                        <xsl:attribute name="itemtype">http://schema.org/Book</xsl:attribute>
                    </xsl:when>
                </xsl:choose>

                <xsl:apply-templates select="element-citation|@*"/>
            </div>
        </li>
    </xsl:template>

    <!-- journal citation -->
    <xsl:template match="element-citation[@publication-type='journal']">
        <xsl:variable name="authors" select="person-group[@person-group-type='author']"/>
        <xsl:if test="$authors or year">
            <span class="citation-authors-year">
                <xsl:apply-templates select="$authors" mode="citation"/>
                <xsl:apply-templates select="year" mode="citation"/>
            </span>
        </xsl:if>
        <cite itemprop="name">
            <xsl:apply-templates select="article-title" mode="citation"/>
        </cite>
        <span>
            <xsl:apply-templates select="source" mode="journal-citation"/>
            <xsl:text>&#32;</xsl:text>
            <xsl:apply-templates select="volume" mode="citation"/>
            <xsl:apply-templates select="issue" mode="citation"/>
            <xsl:apply-templates select="elocation-id" mode="citation"/>
            <xsl:apply-templates select="fpage" mode="citation"/>
            <xsl:text>&#32;</xsl:text>
            <xsl:apply-templates select="comment" mode="citation"/>
        </span>
    </xsl:template>

    <!-- book-like citations -->
    <xsl:template match="
        element-citation[@publication-type='book']
        | element-citation[@publication-type='conf-proceedings']
        | element-citation[@publication-type='confproc']
        | element-citation[@publication-type='other']
        ">
        <span class="citation-authors-year">
            <xsl:apply-templates select="person-group[not(@person-group-type='editor')]" mode="citation"/>
            <xsl:apply-templates select="year" mode="citation"/>
        </span>
        <cite class="article-title">
            <xsl:apply-templates select="article-title" mode="book-citation"/>
        </cite>
        <xsl:text>&#32;</xsl:text>
        <xsl:apply-templates select="source" mode="book-citation"/>
        <span>
            <xsl:apply-templates select="edition" mode="citation"/>
            <xsl:text>&#32;</xsl:text>
            <xsl:apply-templates select="publisher-name | institution" mode="citation"/>
            <xsl:text>&#32;</xsl:text>
            <xsl:apply-templates select="volume" mode="citation"/>
            <xsl:apply-templates select="fpage" mode="book-citation"/>
            <xsl:text>&#32;</xsl:text>
            <xsl:apply-templates select="pub-id[@pub-id-type='isbn']" mode="citation"/>
            <xsl:apply-templates select="comment" mode="citation"/>
        </span>
    </xsl:template>

    <!-- report citations -->
    <xsl:template match="element-citation[@publication-type='report']">
        <span class="citation-authors-year">
            <xsl:apply-templates select="person-group[@person-group-type='author'] | collab" mode="citation"/>
            <xsl:apply-templates select="year" mode="citation"/>
        </span>
        <span class="article-title">
            <xsl:apply-templates select="article-title" mode="citation"/>
            <xsl:text>&#32;</xsl:text>
            <xsl:apply-templates select="source" mode="report-citation"/>
        </span>
        <xsl:apply-templates select="institution" mode="report-citation"/>
        <xsl:apply-templates select="volume" mode="citation"/>
        <xsl:apply-templates select="fpage" mode="book-citation"/>
        <xsl:apply-templates select="comment" mode="citation"/>
    </xsl:template>

    <!-- thesis citations -->
    <xsl:template match="element-citation[@publication-type='thesis']">
        <span class="citation-authors-year">
            <xsl:apply-templates select="person-group[@person-group-type='author'] | collab" mode="citation"/>
            <xsl:apply-templates select="year" mode="citation"/>
        </span>
        <span class="article-title">
            <xsl:apply-templates select="article-title" mode="citation"/>
        </span>
        <xsl:text>&#32;</xsl:text>
        <xsl:apply-templates select="source" mode="thesis-citation"/>
        <xsl:apply-templates select="institution" mode="thesis-citation"/>
        <xsl:apply-templates select="comment" mode="citation"/>
    </xsl:template>

    <!-- working paper (preprint) citations -->
    <xsl:template match="element-citation[@publication-type='working-paper']">
        <span class="citation-authors-year">
            <xsl:apply-templates select="person-group[@person-group-type='author'] | collab" mode="citation"/>
            <xsl:apply-templates select="year" mode="citation"/>
        </span>
        <span class="article-title">
            <xsl:apply-templates select="article-title" mode="citation"/>
        </span>
        <xsl:text>&#32;</xsl:text>
        <xsl:apply-templates select="comment" mode="citation"/>
        <xsl:call-template name="preprint-label"/>
    </xsl:template>

    <!-- other citations (?) -->
    <xsl:template match="element-citation">
        <span class="citation-authors-year">
            <xsl:apply-templates select="person-group[@person-group-type='author']" mode="citation"/>
            <xsl:apply-templates select="year" mode="citation"/>
        </span>
        <span class="article-title">
            <xsl:apply-templates select="article-title" mode="citation"/>
            <xsl:text>&#32;</xsl:text>
            <xsl:apply-templates select="source" mode="book-citation"/>
        </span>
    </xsl:template>

    <xsl:template name="preprint-label">
        <xsl:choose>
            <xsl:when test="pub-id[@pub-id-type='arxiv']">
                <span class="label label-preprint">arXiv preprint</span>
            </xsl:when>
            <xsl:otherwise>
                <span class="label label-preprint">preprint</span>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="issn" mode="citation">
        <span class="{local-name()}">
            <xsl:apply-templates/>
        </span>
    </xsl:template>

    <!-- journal name -->
    <xsl:template match="source" mode="journal-citation">
        <span class="{local-name()}">
            <xsl:apply-templates/>
        </span>
    </xsl:template>

    <!-- report source -->
    <xsl:template match="source" mode="report-citation">
        <span class="{local-name()}">
            <xsl:apply-templates/>
        </span>
        <xsl:text>.</xsl:text>
        <xsl:text>&#32;</xsl:text>
    </xsl:template>

    <xsl:template match="institution" mode="report-citation">
        <span class="{local-name()}">
            <xsl:apply-templates/>
        </span>
        <xsl:text>&#32;</xsl:text>
    </xsl:template>

    <!-- thesis source -->
    <xsl:template match="source" mode="thesis-citation">
        <span class="{local-name()}">
            <xsl:apply-templates/>
        </span>
        <xsl:if test="following-sibling::institution">
            <xsl:text>,</xsl:text>
        </xsl:if>
        <xsl:text>&#32;</xsl:text>
   </xsl:template>

    <xsl:template match="institution" mode="thesis-citation">
        <span class="{local-name()}">
            <xsl:apply-templates/>
        </span>
        <xsl:if test="following-sibling::comment">
            <xsl:text>.</xsl:text>
        </xsl:if>
    </xsl:template>

    <!-- book source -->
    <xsl:template match="source" mode="book-citation">
        <xsl:variable name="editors" select="../person-group[@person-group-type='editor']"/>

        <xsl:if test="../article-title">
            <xsl:text>In:&#32;</xsl:text>
        </xsl:if>

        <xsl:apply-templates select="$editors" mode="book-citation"/>

        <span itemprop="name">
            <a class="{local-name()}" target="_blank">
                <xsl:attribute name="href">
                    <xsl:variable name="editor" select="$editors/name[1]/surname"/>
                    <xsl:variable name="query" select="concat('q=intitle:&quot;', ., '&quot; inauthor:&quot;', $editor, '&quot;')"/>
                    <xsl:value-of select="concat('https://www.google.co.uk/search?tbm=bks&amp;', $query)"/>
                </xsl:attribute>
                <xsl:apply-templates/>
            </a>

            <xsl:apply-templates select="../series" mode="book-citation"/>

            <xsl:if test="not(../edition)">.</xsl:if>
        </span>
    </xsl:template>

    <!-- citation editor names -->
    <xsl:template match="person-group[@person-group-type='editor']" mode="book-citation">
        <xsl:variable name="editors" select="count(name)"/>
        <xsl:apply-templates select="name" mode="citation"/>
        <xsl:choose>
            <xsl:when test="$editors > 1">
                <xsl:text>, eds.&#32;</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>, ed.&#32;</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="edition" mode="citation">
        <xsl:text>&#32;(</xsl:text>
            <span class="{local-name()}">
                <xsl:apply-templates/>
            </span>
        <xsl:text>).</xsl:text>
    </xsl:template>

    <xsl:template match="series" mode="book-citation">
        <xsl:text>,&#32;</xsl:text>
        <span class="{local-name()}">
            <xsl:apply-templates/>
        </span>
    </xsl:template>

    <xsl:template match="publisher-name | institution" mode="citation">
        <xsl:apply-templates select="../publisher-loc" mode="citation"/>
        <xsl:text>&#32;</xsl:text>
        <span class="publisher">
            <xsl:apply-templates/>
        </span>
        <xsl:text>.</xsl:text>
    </xsl:template>

    <xsl:template match="publisher-loc" mode="citation">
        <xsl:text>&#32;</xsl:text>
        <xsl:apply-templates/>
        <xsl:text>:</xsl:text>
    </xsl:template>

    <!-- link out from a citation title -->
    <xsl:template name="citation-url">
        <xsl:param name="citation"/>

        <xsl:variable name="doi" select="$citation/pub-id[@pub-id-type='doi']"/>
        <xsl:variable name="arxiv" select="$citation/pub-id[@pub-id-type='arxiv']"/>
        <xsl:variable name="uri" select="$citation/comment/uri"/>

        <xsl:choose>
            <xsl:when test="$doi">
                <xsl:variable name="encoded-doi">
                    <xsl:call-template name="urlencode">
                        <xsl:with-param name="value" select="$doi"/>
                    </xsl:call-template>
                </xsl:variable>

                <xsl:value-of select="concat('http://dx.doi.org/', $encoded-doi)"/>
            </xsl:when>
            <xsl:when test="$arxiv">
                <xsl:value-of select="concat('http://arxiv.org/abs/', $arxiv)"/>
            </xsl:when>
            <xsl:when test="$uri">
                <xsl:value-of select="$uri/@xlink:href"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:variable name="authors" select="$citation/person-group[@person-group-type='author']"/>

                <xsl:choose>
                    <xsl:when test="$citation/@publication-type = 'book'">
                        <xsl:choose>
                            <xsl:when test="$citation/article-title">
                                <xsl:variable name="query" select="concat('q=intitle:&quot;', $citation/article-title, '&quot; inauthor:&quot;', $authors/name[1]/surname, '&quot;')"/>
                                <xsl:value-of select="concat('http://scholar.google.com/scholar?', $query)"/>
                            </xsl:when>
                            <xsl:when test="$citation/source">
                                <xsl:variable name="editors" select="$citation/person-group[@person-group-type='editor']"/>
                                <xsl:variable name="author">
                                    <xsl:choose>
                                        <xsl:when test="$editors">
                                            <xsl:value-of select="editor/name[1]/surname"/>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:value-of select="$authors/name[1]/surname"/>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:variable>
                                <xsl:variable name="query" select="concat('q=intitle:&quot;', $citation/source, '&quot; inauthor:&quot;', $author, '&quot;')"/>
                                <xsl:value-of select="concat('https://www.google.co.uk/search?tbm=bks&amp;', $query)"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="concat('#', $citation/../@id)"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:choose>
                            <xsl:when test="$citation/article-title">
                                <xsl:variable name="query" select="concat('q=intitle:&quot;', $citation/article-title, '&quot; inauthor:&quot;', $authors/name[1]/surname, '&quot;')"/>
                                <xsl:value-of select="concat('http://scholar.google.com/scholar?', $query)"/>
                            </xsl:when>

                            <xsl:otherwise>
                                <xsl:value-of select="concat('#', $citation/../@id)"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="article-title" mode="citation">
        <a class="{local-name()}" target="_blank">
            <xsl:attribute name="href">
                <xsl:call-template name="citation-url">
                    <xsl:with-param name="citation" select=".."/>
                </xsl:call-template>
            </xsl:attribute>
            <xsl:if test="../pub-id[@pub-id-type='doi']">
                <xsl:attribute name="itemprop">url</xsl:attribute>
            </xsl:if>
            <xsl:apply-templates select="node()|@*"/>
            <xsl:apply-templates select="../named-content[@content-type='abstract-details']" mode="citation"/>
        </a>

        <xsl:call-template name="title-punctuation"/>
    </xsl:template>

    <xsl:template match="article-title" mode="book-citation">
        <a class="{local-name()}" target="_blank">
            <xsl:attribute name="href">
                <xsl:call-template name="citation-url">
                    <xsl:with-param name="citation" select=".."/>
                </xsl:call-template>
            </xsl:attribute>
            <xsl:apply-templates select="node()|@*"/>
            <xsl:apply-templates select="../named-content[@content-type='abstract-details']" mode="citation"/>
        </a>
        <xsl:call-template name="title-punctuation"/>
    </xsl:template>

    <!-- eg " abstract no. 35" -->
    <xsl:template match="named-content[@content-type='abstract-details']" mode="citation">
        <xsl:value-of select="concat(' [', ., ']')"/>
    </xsl:template>


    <xsl:template match="volume" mode="citation">
        <b class="{local-name()}">
            <xsl:apply-templates/>
        </b>
    </xsl:template>

    <xsl:template match="issue" mode="citation">
        <span class="{local-name()}">
            <xsl:text>(</xsl:text>
            <xsl:apply-templates/>
            <xsl:text>)</xsl:text>
        </span>
    </xsl:template>

    <xsl:template match="elocation-id" mode="citation">
        <xsl:if test="../volume">
            <xsl:text>:</xsl:text>
        </xsl:if>
        <span class="{local-name()}">
            <xsl:apply-templates/>
        </span>
    </xsl:template>

    <xsl:template match="fpage" mode="citation">
        <xsl:if test="../volume">
            <xsl:text>:</xsl:text>
        </xsl:if>
        <span class="{local-name()}">
            <xsl:apply-templates/>
        </span>
    </xsl:template>

    <xsl:template match="fpage" mode="book-citation">
        <xsl:if test="../volume">
            <xsl:text>:</xsl:text>
        </xsl:if>
        <xsl:choose>
            <xsl:when test="../lpage">
                <span class="fpage">
                    <xsl:apply-templates/>
                </span>
                <xsl:text>-</xsl:text>
                <span class="lpage">
                    <xsl:value-of select="../lpage"/>
                </span>
            </xsl:when>
            <xsl:otherwise>
                <span class="{local-name()}">
                    <xsl:apply-templates/>
                </span>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="year" mode="citation">
        <xsl:text>&#32;</xsl:text>
        <b class="{local-name()}" itemprop="datePublished">
            <xsl:apply-templates/>
        </b>
        <xsl:text>.&#32;</xsl:text>
    </xsl:template>

    <xsl:template match="comment" mode="citation">
        <xsl:text>&#32;</xsl:text>
        <span class="{local-name()}">
            <xsl:apply-templates/>
        </span>
    </xsl:template>

    <!-- citation author names -->

    <xsl:template match="person-group" mode="citation">
        <xsl:variable name="max" select="10"/>
        <xsl:variable name="people" select="name | collab"/>
        <b class="{local-name()}">
            <xsl:choose>
                <xsl:when test="count($people) &gt; $max">
                    <xsl:apply-templates select="$people[position() &lt; ($max + 1)]" mode="citation"/>
                    <span class="et-al">&#32;et al.</span>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates select="$people" mode="citation"/>
                    <xsl:text>.</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
        </b>
    </xsl:template>

    <xsl:template match="name" mode="citation">
        <span class="{local-name()}" itemprop="author" itemscope="itemscope" itemtype="http://schema.org/Person">
            <xsl:apply-templates select="surname"/>
            <xsl:if test="given-names">
                <xsl:text>&#32;</xsl:text>
                <xsl:apply-templates select="given-names"/>
            </xsl:if>
        </span>
        <xsl:call-template name="comma-separator"/>
    </xsl:template>

    <xsl:template match="collab" mode="citation">
        <b class="{local-name()}" itemprop="author" itemscope="itemscope">
            <xsl:apply-templates/>
        </b>
        <xsl:call-template name="comma-separator">
            <xsl:with-param name="separator" select="'. '"/>
        </xsl:call-template>
    </xsl:template>

    <!-- self citation -->
    <xsl:template name="self-citation">
        <xsl:param name="meta"/>

        <dl class="self-citation">
            <dt>Cite this article</dt>
            <dd>
                <span class="self-citation-author-year">
                    <xsl:value-of select="$authors[1]/name/surname"/>
                    <xsl:if test="count($authors) > 1">
                        <xsl:text>&#32;et al.</xsl:text>
                    </xsl:if>
                </span>
                <xsl:text>&#32;(</xsl:text>
                <span class="self-citation-year">
                    <xsl:value-of select="$pub-date/year"/>
                </span>
                <xsl:text>)&#32;</xsl:text>
                <xsl:apply-templates select="$title" mode="self-citation"/>
                <xsl:call-template name="title-punctuation">
                    <xsl:with-param name="title" select="$title"/>
                </xsl:call-template>
                <xsl:text>&#32;</xsl:text>
                <span class="self-citation-journal" itemprop="publisher">
                    <xsl:value-of select="$journal-title"/>
                </span>
                <xsl:text>&#32;</xsl:text>
                <span class="self-citation-volume">
                    <xsl:value-of select="$meta/volume"/>
                </span>
                <xsl:text>:</xsl:text>
                <span class="self-citation-elocation">
                    <xsl:value-of select="$meta/elocation-id"/>
                </span>
                <xsl:text>&#32;</xsl:text>
                <a href="http://dx.doi.org/{$doi}" itemprop="url">
                    <xsl:value-of select="concat('http://dx.doi.org/', $doi)"/>
                </a>
            </dd>
        </dl>
    </xsl:template>

    <xsl:template match="article-title" mode="self-citation">
        <span class="self-citation-title">
            <xsl:apply-templates select="node()|@*"/>
        </span>
    </xsl:template>

    <!-- "et al" -->
    <xsl:template match="person-group/etal">
        <span class="{local-name()}">et al.</span>
    </xsl:template>

    <!-- block elements -->
    <xsl:template match="*">
        <div class="{local-name()}">
            <xsl:apply-templates select="node()|@*"/>
        </div>
    </xsl:template>

    <!-- attributes to copy directly -->
    <xsl:template match="@id | @colspan | @rowspan | @style">
        <xsl:copy-of select="."/>
    </xsl:template>

    <!-- attributes that should be styles -->
    <xsl:template match="@valign">
        <xsl:call-template name="add-style">
            <xsl:with-param name="style" select="concat('vertical-align:', .)"/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template match="@align">
        <xsl:call-template name="add-style">
            <xsl:with-param name="style" select="concat('text-align:', .)"/>
        </xsl:call-template>
    </xsl:template>

    <!-- even though it's deprecated, need these -->
    <xsl:template match="colgroup/@valign | colgroup/@align | col/@valign | col/@align">
        <xsl:copy-of select="."/>
    </xsl:template>

    <!-- add to the style attribute -->
    <xsl:template name="add-style">
        <xsl:param name="style"/>
        <xsl:attribute name="style">
            <xsl:value-of select="normalize-space(concat(@style, ' ', $style, ';'))"/>
        </xsl:attribute>
    </xsl:template>

    <xsl:template match="@sec-type">
        <xsl:attribute name="id">
            <xsl:value-of select="."/>
        </xsl:attribute>
    </xsl:template>

    <!-- other attributes (ignore) -->
    <xsl:template match="@*">
        <xsl:attribute name="data-jats-{local-name()}">
            <xsl:value-of select="."/>
        </xsl:attribute>
    </xsl:template>

    <!-- ignore namespaced attributes -->
    <xsl:template match="@*[namespace-uri()]"></xsl:template>

    <!-- mathml root element -->
    <xsl:template match="mml:math">
        <math xmlns="http://www.w3.org/1998/Math/MathML">
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates mode="mathml"/>
        </math>
    </xsl:template>

    <!-- mathml (direct copy) -->
    <xsl:template match="*" mode="mathml">
        <xsl:element name="{local-name()}" xmlns="http://www.w3.org/1998/Math/MathML">
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates mode="mathml"/>
        </xsl:element>
        <!--<xsl:copy-of select="."/>-->
    </xsl:template>

    <!-- url-encode a string, if PHP functions are registered -->
    <xsl:template name="urlencode">
        <xsl:param name="value"/>

        <xsl:choose>
            <xsl:when test="function-available('php:function')">
                <xsl:value-of select="php:function('rawurlencode', string($value))"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$value"/><!-- TODO: replace special characters with XSL -->
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
</xsl:stylesheet>
