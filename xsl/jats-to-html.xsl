<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" exclude-result-prefixes="xlink mml"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:mml="http://www.w3.org/1998/Math/MathML"
                xmlns:xlink="http://www.w3.org/1999/xlink">

    <xsl:output method="xml" encoding="utf-8" omit-xml-declaration="yes" indent="yes"/>

    <xsl:strip-space elements="contrib"/>

    <xsl:param name="static-root" select="''"/>

    <xsl:variable name="meta" select="/article/front/article-meta"/>
    <xsl:variable name="id" select="$meta/article-id[@pub-id-type='publisher-id']"/>
    <xsl:variable name="doi" select="$meta/article-id[@pub-id-type='doi']"/>
    <xsl:variable name="title" select="$meta/title-group/article-title"/>
    <xsl:variable name="pub-date" select="$meta/pub-date[@date-type='pub'][@pub-type='epub']"/>
    <xsl:variable name="authors" select="$meta/contrib-group[@content-type='authors']/contrib[@contrib-type='author']"/>
    <xsl:variable name="editors" select="$meta/contrib-group[@content-type='editors']/contrib[@contrib-type='editor']"/>

    <xsl:variable name="journal-meta" select="/article/front/journal-meta"/>
    <xsl:variable name="journal-title" select="$journal-meta/journal-title-group/journal-title"/>

    <!-- article -->
    <xsl:template match="/article">
        <html>
            <!-- article head -->
            <head>
                <meta charset="utf-8"/>
                <meta name="robots" content="noindex"/>
                <title>
                    <xsl:apply-templates select="$title/node()"/>
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
        <meta name="citation_pdf_url" content="{self-uri/@xlink:href}.pdf"/>
        <meta name="citation_fulltext_html_url" content="{self-uri/@xlink:href}"/>
        <meta name="citation_volume" content="{volume}"/>
        <meta name="citation_firstpage" content="{elocation-id}"/>

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
                    <xsl:apply-templates select="node()[not(local-name() = 'label')]"/>
                    <xsl:call-template name="comma-separator">
                        <xsl:with-param name="separator" select="'; '"/>
                    </xsl:call-template>
                </xsl:for-each>
            </xsl:attribute>
        </meta>

        <meta name="description">
            <xsl:attribute name="content">
                <xsl:value-of select="normalize-space(abstract)"/>
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
        <meta name="citation_journal_title" content="{$journal-title}"/>
        <meta name="citation_journal_abbrev" content="{$journal-title}"/>
        <meta name="citation_publisher" content="{publisher/publisher-name}"/>
        <meta name="citation_issn" content="{issn[@pub-type='epub']}"/>
    </xsl:template>

    <!-- "meta" tags, references -->
    <xsl:template match="ref-list" mode="head">
    </xsl:template>

    <!-- front mattter -->
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

                    <dt>Accepted</dt>
                    <dd>
                        <time itemprop="dateModified">
                            <xsl:value-of select="history/date[@date-type='accepted']/@iso-8601-date"/>
                        </time>
                    </dd>

                    <dt>Received</dt>
                    <dd>
                        <time itemprop="dateCreated">
                            <xsl:value-of select="history/date[@date-type='received']/@iso-8601-date"/>
                        </time>
                    </dd>
                </dl>

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

    <!-- aff or fn -->
    <xsl:template match="aff | fn | corresp" mode="front">
        <div>
            <xsl:apply-templates select="@*"/>
            <span class="article-label-container">
                <xsl:apply-templates select="label"/>
                <xsl:if test="not(label)">&#160;</xsl:if><!-- non-breaking space, to prevent collapsing elements -->
            </span>
            <span>
                <xsl:choose>
                    <xsl:when test="local-name() = 'corresp'">
                        <xsl:text>Corresponding author:&#32;</xsl:text>
                        <a href="mailto:{email}" target="_new">
                            <xsl:value-of select="email"/>
                        </a>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:apply-templates select="node()[not(local-name() = 'label')]"/>
                    </xsl:otherwise>
                </xsl:choose>
            </span>
        </div>
    </xsl:template>

    <xsl:template match="fn/label | aff/label | corresp/label">
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

    <!-- subject area -->
    <xsl:template match="subject" mode="front">
        <span class="{local-name()}" itemprop="about">
            <xsl:apply-templates select="node()|@*"/>
        </span>
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
        </main>
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
        <span class="{local-name()}">
            <xsl:apply-templates select="@*"/>

            <xsl:choose>
                <xsl:when test="@contrib-type = 'author'">
                    <xsl:variable name="author-index" select="count(preceding::contrib[@contrib-type='author']) + 1"/>
                    <a href="author-{$author-index}" rel="author" itemprop="author">
                        <xsl:apply-templates select="name"/>
                    </a>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates select="name"/>
                </xsl:otherwise>
            </xsl:choose>

            <xsl:if test="xref">
                <xsl:apply-templates select="xref[@ref-type='corresp']" mode="author"/>
                <sup class="contrib-xref-group">
                    <xsl:for-each select="xref[not(@ref-type='corresp')]">
                        <xsl:variable name="rid" select="@rid"/>
                        <xsl:variable name="ref" select="//*[@id=$rid]"/>
                        <xsl:if test="$ref/label">
                            <xsl:apply-templates select="$ref" mode="contrib-xref"/>
                            <xsl:call-template name="comma-separator">
                                <xsl:with-param name="separator" select="','"/>
                            </xsl:call-template>
                        </xsl:if>
                    </xsl:for-each>
                </sup>
            </xsl:if>
        </span>
        <xsl:call-template name="comma-separator"/>
    </xsl:template>

    <!-- affiliation/corresponding author/footnote link -->
    <xsl:template match="*" mode="contrib-xref">
        <a class="{local-name()} xref" href="#{@id}">
            <xsl:value-of select="label"/>
        </a>
    </xsl:template>

    <!-- corresponding author -->
    <xsl:template match="xref[@ref-type='corresp']" mode="author">
        <xsl:variable name="rid" select="@rid"/>
        <xsl:variable name="ref" select="//corresp[@id=$rid]"/>
        <a class="{local-name()} corresp" href="mailto:{$ref/email}" target="_new" title="email the corresponding author" rel="tooltip">
            <i class="icon-envelope">&#160;</i>
        </a>
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

    <!-- name -->
    <xsl:template match="name">
        <span class="{local-name()}">
            <xsl:call-template name="name"/>
        </span>
        <xsl:call-template name="comma-separator"/>
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

    <!-- style elements -->
    <xsl:template match="sc | strike | roman | sans-serif | monospace | overline">
        <span class="{local-name()}">
            <xsl:apply-templates select="node()|@*"/>
        </span>
    </xsl:template>

    <!-- inline elements -->
    <xsl:template
        match="abbrev | surname | given-names | suffix | email | year | month | day
        | xref | contrib | source | volume | fpage | lpage | etal | pub-id
        | named-content | funding-source | award-id | institution | country | addr-line
        | chem-struct">
        <span class="{local-name()}">
            <xsl:apply-templates select="node()|@*"/>
        </span>
    </xsl:template>

    <!-- links -->
    <xsl:template match="uri">
        <a class="{local-name()}" href="{.}">
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

    <xsl:template match="p[ancestor::caption]">
        <span class="{local-name()}">
            <xsl:apply-templates select="@*"/>
            <xsl:apply-templates select="node()"/>
        </span>
    </xsl:template>

    <xsl:template match="fn/p[preceding-sibling::label]">
        <span class="{local-name()}">
            <xsl:apply-templates select="@*"/>
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
        <a class="{local-name()}" href="http://dx.doi.org/{@xlink:href}">
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
        <xsl:variable name="rid" select="@rid"/>
        <xsl:variable name="ref" select="//ref[@id=$rid]"/>
        <xsl:variable name="title">
            <xsl:choose>
                <xsl:when test="$ref/*/article-title">
                    <xsl:value-of select="$ref/*/article-title"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$ref/*/source"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="ref-doi" select="$ref/*/pub-id[@pub-id-type='doi']"/>
        <xsl:variable name="ref-uri" select="$ref/*/comment/uri"/>
        <xsl:variable name="url">
            <xsl:choose>
            <xsl:when test="$ref-doi">
                <xsl:value-of select="concat('http://dx.doi.org/', $ref-doi)"/>
            </xsl:when>
            <xsl:when test="$ref-uri">
                <xsl:value-of select="$ref-uri"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="concat('http://scholar.google.com/scholar?q=intitle:&quot;', $title, '&quot;')"/>
            </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <xsl:variable name="ref-type" select="$ref/element-citation/@publication-type"/>

        <cite itemprop="citation" itemscope="itemscope" itemref="{@rid}">
            <xsl:apply-templates select="@*"/>
            <xsl:attribute name="itemtype">
                <xsl:choose>
                    <xsl:when test="$ref-type = 'journal'">
                        <xsl:text>http://schema.org/ScholarlyArticle</xsl:text>
                    </xsl:when>
                    <xsl:when test="$ref-type = 'book'">
                        <xsl:text>http://schema.org/Book</xsl:text>
                    </xsl:when>
                </xsl:choose>
            </xsl:attribute>
            <a class="{local-name()} xref-{@ref-type}" href="{$url}" title="{$title}">
                <xsl:apply-templates select="node()|@*"/>
            </a>
        </cite>
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
            <img class="{local-name()}"
                 src="{$static-root}{$fig-id}-1x.jpg"
                 data-image-id="{$fig-id}"
                 alt="{$fig/caption/title}">
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
        <xsl:variable name="href" select="../@xlink:href"/>

        <div>
            <a href="{$static-root}{$href}" class="article-supporting-download" download="{$href}" data-filename="{$href}">
                <xsl:value-of select="$href"/>
            </a>
        </div>
    </xsl:template>

    <xsl:template match="supplementary-material/caption/title"></xsl:template>

    <xsl:template match="supplementary-material/caption/title" mode="supp-title">
        <xsl:apply-templates select="node()"/>
    </xsl:template>

    <!-- acknowledgments -->
    <xsl:template match="ack">
        <section class="{local-name()}" id="acknowledgements">
            <h2 class="heading">Acknowledgements</h2>
            <xsl:apply-templates select="node()|@*"/>
        </section>
    </xsl:template>

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
            <xsl:apply-templates select="element-citation|@*"/>
        </li>
    </xsl:template>

    <!-- journal citation -->
    <xsl:template match="element-citation[@publication-type='journal']">
        <div class="citation {local-name()}" itemscope="itemscope" itemtype="http://schema.org/ScholarlyArticle" id="{../@id}">
            <xsl:variable name="authors" select="person-group[@person-group-type='author']"/>
            <xsl:if test="$authors or year">
                <span class="citation-authors-year">
                    <xsl:apply-templates select="$authors" mode="citation"/>
                    <xsl:apply-templates select="year" mode="citation"/>
                </span>
            </xsl:if>
            <span itemprop="name">
                <xsl:apply-templates select="article-title" mode="citation"/>
            </span>
            <span>
                <xsl:apply-templates select="source" mode="journal-citation"/>
                <xsl:text>&#32;</xsl:text>
                <xsl:apply-templates select="volume" mode="citation"/>
                <xsl:apply-templates select="issue" mode="citation"/>
                <xsl:apply-templates select="fpage" mode="citation"/>
                <xsl:text>&#32;</xsl:text>
            </span>
        </div>
    </xsl:template>

    <!-- book-like citations -->
    <xsl:template match="
        element-citation[@publication-type='book']
        | element-citation[@publication-type='conf-proceedings']
        | element-citation[@publication-type='confproc']
        | element-citation[@publication-type='other']
        ">
        <div class="citation {local-name()}" itemscope="itemscope" id="{../@id}">
            <xsl:if test="@publication-type = 'book'">
                <xsl:variable name="itemtype">http://schema.org/Book</xsl:variable>
            </xsl:if>

            <span class="citation-authors-year">
                <xsl:apply-templates select="person-group[@person-group-type='author']" mode="citation"/>
                <xsl:apply-templates select="year" mode="citation"/>
            </span>
            <span class="article-title">
                <xsl:apply-templates select="article-title" mode="citation"/>
                <xsl:text>&#32;</xsl:text>
                <xsl:apply-templates select="source" mode="book-citation"/>
            </span>
            <span>
                <xsl:apply-templates select="edition" mode="citation"/>
                <xsl:text>&#32;</xsl:text>
                <xsl:apply-templates select="volume" mode="citation"/>
                <xsl:apply-templates select="fpage" mode="book-citation"/>
                <xsl:text>&#32;</xsl:text>
                <xsl:apply-templates select="pub-id[@pub-id-type='isbn']" mode="citation"/>

                <xsl:apply-templates select="publisher-name" mode="citation"/>
            </span>
        </div>
    </xsl:template>

    <!-- other citations -->
    <xsl:template match="element-citation[@publication-type='other']">
        <div class="citation {local-name()}" itemscope="itemscope" id="{../@id}">
            <xsl:if test="person-group or year">
                <span class="citation-authors-year">
                    <xsl:apply-templates select="person-group" mode="citation"/>
                    <xsl:apply-templates select="year" mode="citation"/>
                </span>
            </xsl:if>
            <xsl:apply-templates select="comment" mode="citation"/>
        </div>
    </xsl:template>

    <xsl:template match="issn" mode="citation">
        <span class="{local-name()}">
            <xsl:apply-templates/>
        </span>
    </xsl:template>

    <xsl:template match="source" mode="journal-citation">
        <i class="{local-name()}">
            <xsl:apply-templates/>
        </i>
    </xsl:template>

    <xsl:template match="source" mode="book-citation">
        <a class="{local-name()}" href="{concat('http://books.google.com/books?q=intitle:&quot;', ., '&quot;')}" target="_new">
            <xsl:apply-templates/>
            <xsl:text>.</xsl:text>
        </a>
    </xsl:template>

    <xsl:template match="edition" mode="citation">
        <span class="{local-name()}">
            <xsl:text>(</xsl:text>
            <xsl:apply-templates/>
            <xsl:text>)</xsl:text>
        </span>
    </xsl:template>

    <xsl:template match="publisher-name" mode="citation">
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

    <xsl:template match="article-title" mode="citation">
        <xsl:variable name="doi" select="../pub-id[@pub-id-type='doi']"/>

        <a class="{local-name()}" target="_new">
            <xsl:attribute name="href">
                <xsl:choose>
                    <xsl:when test="$doi">
                        <xsl:value-of select="concat('http://dx.doi.org/', $doi)"/>
                    </xsl:when>
                    <xsl:when test="../comment/uri">
                        <xsl:value-of select="../comment/uri/@xlink:href"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="concat('http://scholar.google.com/scholar?q=intitle:&quot;', ., '&quot;')"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>
            <xsl:if test="$doi">
                <xsl:attribute name="itemprop">url</xsl:attribute>
            </xsl:if>
            <xsl:apply-templates select="node()|@*"/>
            <xsl:text>.</xsl:text>
        </a>
    </xsl:template>

    <xsl:template match="volume" mode="citation">
        <span class="{local-name()}">
            <xsl:apply-templates/>
        </span>
    </xsl:template>

    <xsl:template match="issue" mode="citation">
        <span class="{local-name()}">
            <xsl:text>(</xsl:text>
            <xsl:apply-templates/>
            <xsl:text>)</xsl:text>
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
        <xsl:choose>
            <xsl:when test="../lpage">
                <xsl:text>&#32;pp&#32;</xsl:text>
                <span class="fpage">
                    <xsl:apply-templates/>
                </span>
                <xsl:text>-</xsl:text>
                <span class="lpage">
                    <xsl:value-of select="../lpage"/>
                </span>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>p&#32;</xsl:text>
                <span class="{local-name()}">
                    <xsl:apply-templates/>
                </span>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="year" mode="citation">
        <xsl:text>&#32;(</xsl:text>
        <span class="{local-name()}" itemprop="datePublished">
            <xsl:apply-templates/>
        </span>
        <xsl:text>)&#32;</xsl:text>
    </xsl:template>

    <xsl:template match="comment" mode="citation">
        <span class="{local-name()}">
            <xsl:apply-templates/>
        </span>
    </xsl:template>

    <!-- citation author names -->

    <xsl:template match="person-group" mode="citation">
        <xsl:variable name="max" select="10"/>
        <xsl:variable name="citation-authors" select="name | collab"/>
        <xsl:apply-templates select="$citation-authors[position() &lt; ($max + 1)]" mode="citation"/>
        <xsl:if test="count($citation-authors) &gt; $max">
            <span class="et-al"> et al.</span>
        </xsl:if>
    </xsl:template>

    <xsl:template match="name" mode="citation">
        <span class="{local-name()}" itemprop="author">
            <xsl:apply-templates select="surname"/>
            <xsl:if test="given-names">
                <xsl:text>&#32;</xsl:text>
                <xsl:apply-templates select="given-names"/>
            </xsl:if>
        </span>
        <xsl:call-template name="comma-separator"/>
    </xsl:template>

    <xsl:template match="collab" mode="citation">
        <span class="{local-name()}" itemprop="author">
            <xsl:apply-templates/>
        </span>
        <xsl:call-template name="comma-separator"/>
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
                <xsl:text>.&#32;</xsl:text>
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

    <!-- ref id is on the child div instead -->
    <xsl:template match="ref/@id"></xsl:template>

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

    <!-- mathml elements (remove namespace prefix) -->
    <xsl:template match="*" mode="mathml">
        <xsl:element name="{local-name()}" xmlns="http://www.w3.org/1998/Math/MathML">
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates mode="mathml"/>
        </xsl:element>
    </xsl:template>
</xsl:stylesheet>
