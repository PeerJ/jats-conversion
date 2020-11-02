<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xlink="http://www.w3.org/1999/xlink">

    <!-- front matter -->
    <xsl:template match="front/article-meta">
        <header class="{local-name()} front">
            <xsl:apply-templates select="$title"/>

            <div class="article-authors">
                <xsl:apply-templates select="$authors" mode="front"/>
                <xsl:apply-templates select="$meta/contrib-group[@content-type='authors']/on-behalf-of"/>
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
                        <a href="https://doi.org/{$doi}" itemprop="sameAs">
                            <xsl:value-of select="concat('', $doi)"/>
                        </a>
                        <meta itemprop="sameAs" content="info:doi/{$doi}"/>
                    </dd>
                </dl>

                <dl class="article-dates">
                    <!-- TODO: handle multiple "corrected" dates -->
                    <xsl:if test="history/date[@date-type='corrected']/@iso-8601-date">
                        <dt>Corrected</dt>
                        <dd>
	                    <!-- note: dateCorrected is not a real property -->
                            <time data-itemprop="dateCorrected">
                                <xsl:value-of select="history/date[@date-type='corrected']/@iso-8601-date"/>
                            </time>
                        </dd>
                    </xsl:if>

                    <dt>Published</dt>
                    <dd>
                        <time itemprop="datePublished">
                            <xsl:value-of select="$pub-date/@iso-8601-date"/>
                        </time>
                    </dd>

                    <xsl:if test="history/date[@date-type='accepted']/@iso-8601-date">
                        <dt>Accepted</dt>
                        <dd>
	                    <!-- note: dateAccepted is not a real property -->
                            <time data-itemprop="dateAccepted">
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

                <xsl:if test="count($editors) > 0">
                    <dl class="article-editors">
                        <dt>Academic Editor</dt>
                        <xsl:for-each select="$editors">
                            <dd itemprop="editor" itemscope="itemscope" itemtype="http://schema.org/Person">
                                <a itemprop="url" href="editor-{ position() }" class="{local-name()}">
                                    <xsl:apply-templates select="node()|@*"/>
                                </a>
                            </dd>
                        </xsl:for-each>
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

                <!-- the "version" custom-meta might not be present -->
                <xsl:if test="$itemVersion">
                    <meta itemprop="version" content="{$itemVersion}"/>
                </xsl:if>
            </div>

            <xsl:apply-templates select="abstract"/>
            <xsl:apply-templates select="../notes[@notes-type='author-note']"/>
        </header>
    </xsl:template>

    <!-- abstract -->
    <xsl:template match="abstract">
        <div>
            <h2>Abstract</h2>
            <div class="{local-name()}" itemprop="description">
                <xsl:apply-templates select="node()|@*"/>
            </div>
        </div>
    </xsl:template>

    <!-- author note -->
    <xsl:template match="notes[@notes-type='author-note']">
        <div>
            <h2>Author Comment</h2>
            <div class="{local-name()}">
                <xsl:apply-templates select="node()|@*"/>
            </div>
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

        <xsl:if test="count($address-parts) > 0">
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

    <!-- contrib in front matter -->
    <xsl:template match="contrib" mode="front">
        <span class="{local-name()}" itemscope="itemscope" itemtype="http://schema.org/Person">
            <xsl:apply-templates select="@*"/>

            <xsl:if test="@contrib-type = 'author'">
                <xsl:attribute name="itemprop">author</xsl:attribute>
            </xsl:if>

            <xsl:choose>
                <xsl:when test="@contrib-type = 'author'">
	                <xsl:variable name="author-url">
		                <xsl:choose>
			                <xsl:when test="@xlink:href">
				                <xsl:value-of select="@xlink:href"/>
			                </xsl:when>
			                <xsl:when test="@deceased or collab">
				                <xsl:value-of select="''"/>
			                </xsl:when>
			                <xsl:otherwise>
				                <xsl:variable name="author-index" select="count(preceding::contrib[@contrib-type='author'][not(@deceased)][not(collab)]) + 1"/>
				                <xsl:value-of select="concat('author-', $author-index)"/>
			                </xsl:otherwise>
		                </xsl:choose>
	                </xsl:variable>

	                <xsl:choose>
		                <xsl:when test="$author-url != ''">
	                        <a href="{$author-url}" rel="author" itemprop="url"><xsl:apply-templates select="name | collab"/></a>
		                </xsl:when>
	                    <xsl:otherwise>
		                    <span><xsl:apply-templates select="name | collab"/></span>
	                    </xsl:otherwise>
	                </xsl:choose>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates select="name | collab"/>
                    <!--<xsl:apply-templates select="on-behalf-of"/>--><!-- TODO: display as footnote/xref? -->
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

                <xsl:if test="string-length($xrefs) > 0">
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
        <a class="corresp" href="mailto:{$email}" target="_blank" title="email the corresponding author" data-toggle="tooltip" itemprop="email"><i class="icon-envelope">&#8203;</i></a>
    </xsl:template>

    <!-- authors with equal contributions -->
    <xsl:template name="equal-contribution">
        <span class="equal-contribution" title="These authors contributed equally to this work." data-toggle="tooltip"><i class="icon-asterisk">&#8203;</i></span>
    </xsl:template>

    <!-- deceased authors -->
    <xsl:template name="deceased">
      <span class="deceased" title="Deceased" data-toggle="tooltip"><b>&#8224;</b></span>
    </xsl:template>

    <xsl:template match="label" mode="front">
        <span class="article-label">
            <xsl:apply-templates select="node()|@*"/>
        </span>
    </xsl:template>

    <xsl:template match="on-behalf-of">
        <xsl:text>, </xsl:text>
        <span class="{local-name()}">
            <xsl:apply-templates select="node()|@*"/>
        </span>
    </xsl:template>
</xsl:stylesheet>
