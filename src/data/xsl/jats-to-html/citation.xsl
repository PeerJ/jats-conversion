<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" exclude-result-prefixes="xlink"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xlink="http://www.w3.org/1999/xlink">

    <!-- journal citation -->
    <xsl:template match="element-citation[@publication-type='journal']">
        <xsl:call-template name="authors-year"/>
        <cite itemprop="name">
            <xsl:apply-templates select="article-title" mode="citation"/>
        </cite>
        <xsl:text>&#32;</xsl:text>
        <span>
	        <xsl:choose>
		        <xsl:when test="issue">
			        <!-- if an issue exists, the source and volume are part of it -->
			        <xsl:apply-templates select="issue" mode="journal-citation"/>
		        </xsl:when>
		        <xsl:when test="volume">
			        <!-- if a volume exists, the source is part of it -->
			        <xsl:apply-templates select="volume" mode="journal-citation"/>
		        </xsl:when>
		        <xsl:otherwise>
			        <xsl:apply-templates select="source" mode="journal-citation"/>
			        <xsl:text>&#32;</xsl:text>
		        </xsl:otherwise>
	        </xsl:choose>
            <xsl:apply-templates select="elocation-id" mode="citation"/>
            <xsl:call-template name="pagination"/>
            <xsl:text>&#32;</xsl:text>
            <xsl:call-template name="comment"/>
        </span>
    </xsl:template>

    <!-- book citations -->
    <xsl:template match="element-citation[@publication-type='book']">
        <xsl:call-template name="authors-year"/>
        <cite class="article-title">
            <xsl:apply-templates select="article-title" mode="citation"/>
        </cite>
        <xsl:text>&#32;</xsl:text>
        <xsl:apply-templates select="source" mode="book-citation"/>
        <span>
            <xsl:apply-templates select="edition" mode="citation"/>
            <xsl:text>&#32;</xsl:text>
            <xsl:apply-templates select="publisher-name | institution" mode="citation"/>
            <xsl:text>&#32;</xsl:text>
            <xsl:apply-templates select="volume" mode="citation"/>
            <xsl:call-template name="pagination"/>
            <xsl:text>&#32;</xsl:text>
            <xsl:apply-templates select="pub-id[@pub-id-type='isbn']" mode="citation"/>
            <xsl:call-template name="comment"/>
        </span>
    </xsl:template>

    <!-- conference proceedings -->
    <xsl:template match="element-citation[@publication-type='conf-proceedings']
					   | element-citation[@publication-type='confproc']">
        <xsl:call-template name="authors-year"/>
        <cite class="article-title">
            <xsl:apply-templates select="article-title" mode="citation"/>
        </cite>
        <xsl:text>&#32;</xsl:text>
        <xsl:apply-templates select="conf-name | source" mode="book-citation"/>
        <span>
            <xsl:apply-templates select="conf-loc" mode="citation"/>
            <xsl:apply-templates select="conf-date" mode="citation"/>
            <xsl:apply-templates select="conf-sponsor" mode="citation"/>
            <xsl:text>&#32;</xsl:text>
            <xsl:apply-templates select="edition" mode="citation"/>
            <xsl:text>&#32;</xsl:text>
            <xsl:apply-templates select="publisher-name | institution" mode="citation"/>
            <xsl:text>&#32;</xsl:text>
            <xsl:apply-templates select="volume" mode="citation"/>
            <xsl:call-template name="pagination"/>
            <xsl:text>&#32;</xsl:text>
            <xsl:apply-templates select="pub-id[@pub-id-type='isbn']" mode="citation"/>
            <xsl:call-template name="comment"/>
        </span>
    </xsl:template>

    <!-- report citations -->
    <xsl:template match="element-citation[@publication-type='report']">
        <xsl:call-template name="authors-year"/>
        <span class="article-title">
            <xsl:apply-templates select="article-title" mode="citation"/>
            <xsl:text>&#32;</xsl:text>
            <xsl:apply-templates select="source" mode="report-citation"/>
        </span>
        <xsl:apply-templates select="institution" mode="report-citation"/>
        <xsl:apply-templates select="volume" mode="citation"/>
        <xsl:call-template name="pagination"/>
        <xsl:call-template name="comment"/>
    </xsl:template>

    <!-- thesis citations -->
    <xsl:template match="element-citation[@publication-type='thesis']">
        <xsl:call-template name="authors-year"/>
        <cite class="article-title">
            <xsl:apply-templates select="article-title" mode="citation"/>
        </cite>
        <xsl:text>&#32;</xsl:text>
        <xsl:apply-templates select="source" mode="thesis-citation"/>
        <xsl:apply-templates select="institution" mode="thesis-citation"/>
        <xsl:call-template name="comment"/>
        <xsl:call-template name="publication-type-label"/>
    </xsl:template>

    <!-- working paper (preprint) citations -->
    <xsl:template match="element-citation[@publication-type='working-paper']">
        <xsl:call-template name="authors-year"/>
        <cite class="article-title">
            <xsl:apply-templates select="article-title" mode="citation"/>
        </cite>
        <xsl:apply-templates select="version" mode="citation"/>
        <xsl:call-template name="comment"/>
        <xsl:call-template name="publication-type-label"/>
    </xsl:template>

    <!-- software citations -->
    <xsl:template match="element-citation[@publication-type='software']">
        <xsl:call-template name="authors-year"/>
        <cite class="article-title">
            <!-- the title may be in "data-title" (since JATS 1.1) or "source" -->
            <xsl:choose>
                <xsl:when test="data-title">
                    <xsl:apply-templates select="data-title" mode="citation"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates select="source" mode="citation"/>
                </xsl:otherwise>
            </xsl:choose>
        </cite>
        <!-- if the title is in "data-title", "source" is used for the host -->
        <xsl:if test="data-title">
            <xsl:apply-templates select="source" mode="citation"/>
        </xsl:if>
        <span>
            <xsl:choose>
                <xsl:when test="version">
                    <xsl:apply-templates select="version" mode="citation"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates select="edition" mode="software-citation"/>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:apply-templates select="publisher-name | institution" mode="citation"/>
        </span>
        <xsl:call-template name="comment"/>
        <xsl:call-template name="publication-type-label"/>
    </xsl:template>

    <!-- data citations -->
    <xsl:template match="element-citation[@publication-type='data']">
        <xsl:call-template name="authors-year"/>
        <cite class="article-title">
            <xsl:apply-templates select="data-title" mode="citation"/>
        </cite>
        <xsl:text>&#32;</xsl:text>
        <xsl:apply-templates select="source" mode="citation"/>
        <xsl:apply-templates select="version" mode="citation"/>
        <xsl:call-template name="comment"/>
        <xsl:call-template name="publication-type-label"/>
    </xsl:template>

    <!-- tweet citations -->
    <xsl:template match="element-citation[@publication-type='tweet']">
        <!-- assuming only one author -->
        <xsl:variable name="name-alternatives" select="person-group[@person-group-type='author']/name-alternatives"/>

        <span class="citation-authors-year">
            <b>
                <xsl:apply-templates select="$name-alternatives/name" mode="citation"/>
                <xsl:text>&#32;</xsl:text>
                <xsl:value-of select="concat('(@', $name-alternatives/string-name[@content-type='twitter-username'], ')')"/>
                <xsl:text>.</xsl:text>
            </b>
            <xsl:apply-templates select="year" mode="citation"/>
        </span>
        <xsl:text>&#32;</xsl:text>
        <cite class="article-title">
            <xsl:apply-templates select="article-title" mode="citation"/>
        </cite>
        <xsl:text>&#32;</xsl:text>
        <!-- TODO: hyperlink the date instead? -->
        <time datetime="{date[@date-type='pub']/@iso-8601-date}">
            <xsl:call-template name="format-date">
                <xsl:with-param name="value" select="date[@date-type='pub']/@iso-8601-date"/>
                <xsl:with-param name="format" select="'g:i A - j M Y'"/>
            </xsl:call-template>
        </time>
        <xsl:text>&#32;</xsl:text>
        <xsl:call-template name="publication-type-label"/>
    </xsl:template>

    <!-- "other" citations -->
    <xsl:template match="element-citation[@publication-type='other']">
        <xsl:call-template name="authors-year"/>
        <cite class="article-title">
            <xsl:apply-templates select="article-title" mode="citation"/>
        </cite>
        <xsl:text>&#32;</xsl:text>
        <xsl:apply-templates select="source" mode="citation"/>
        <span>
            <xsl:apply-templates select="edition" mode="citation"/>
            <xsl:text>&#32;</xsl:text>
            <xsl:apply-templates select="publisher-name | institution" mode="citation"/>
            <xsl:text>&#32;</xsl:text>
            <xsl:apply-templates select="volume" mode="citation"/>
            <xsl:call-template name="pagination"/>
            <xsl:text>&#32;</xsl:text>
            <xsl:apply-templates select="pub-id[@pub-id-type='isbn']" mode="citation"/>
            <xsl:call-template name="comment"/>
        </span>
    </xsl:template>

    <!-- other citations (?) -->
    <xsl:template match="element-citation">
        <xsl:call-template name="authors-year"/>
        <cite class="article-title">
            <xsl:apply-templates select="article-title" mode="citation"/>
        </cite>
        <xsl:text>&#32;</xsl:text>
        <xsl:apply-templates select="source" mode="citation"/>
    </xsl:template>

    <!-- page range(s) -->
    <xsl:template name="pagination">
        <xsl:choose>
            <xsl:when test="page-range">
                <xsl:apply-templates select="page-range" mode="citation"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates select="fpage" mode="citation"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="publication-type-label">
        <xsl:text>&#32;</xsl:text>
        <span class="{concat('label label-', @publication-type)}">
            <xsl:choose>
                <xsl:when test="@publication-type='working-paper'">
                    <xsl:text>preprint</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="@publication-type"/>
                </xsl:otherwise>
            </xsl:choose>
        </span>
    </xsl:template>

    <xsl:template match="issn" mode="citation">
        <span class="{local-name()}">
            <xsl:apply-templates/>
        </span>
    </xsl:template>

    <!-- journal name -->
	<xsl:template match="source" mode="journal-citation">
		<span class="{local-name()}"
		      itemprop="isPartOf" itemscope="itemscope"
		      itemtype="http://schema.org/Periodical">
			<span itemprop="name">
				<xsl:apply-templates/>
			</span>
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

    <!-- other source -->
    <xsl:template match="source" mode="citation">
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
    <xsl:template match="source | conf-name" mode="book-citation">
        <xsl:variable name="editors" select="../person-group[@person-group-type='editor']"/>

        <xsl:if test="../article-title">
            <xsl:text>In:&#32;</xsl:text>
        </xsl:if>

        <xsl:apply-templates select="$editors" mode="book-citation"/>

        <span itemprop="name">
            <a class="{local-name()}" target="_blank">
                <xsl:attribute name="href">
	                <xsl:value-of select="concat('https://scholar.google.com/scholar_lookup?title=', ., '&amp;author=', $editors/name[1]/surname, '&amp;publication_year=', ../year/@iso-8601-date)"/>
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
        <xsl:apply-templates select="following-sibling::part-title" mode="book-citation-edition"/>
        <xsl:text>).</xsl:text>
    </xsl:template>

    <xsl:template match="edition" mode="software-citation">
        <xsl:text>&#32;(</xsl:text>
        <span class="{local-name()}">
            <xsl:apply-templates/>
        </span>
        <xsl:text>).</xsl:text>
    </xsl:template>

    <xsl:template match="version" mode="citation">
        <xsl:text>&#32;</xsl:text>
        <span class="version-container">
            <span class="{local-name()}">
                <xsl:apply-templates/>
            </span>
        </span>
        <xsl:text>&#32;</xsl:text>
    </xsl:template>

    <xsl:template match="part-title" mode="book-citation-edition">
        <xsl:text>,&#32;</xsl:text>
        <span class="{local-name()}">
            <xsl:apply-templates/>
        </span>
    </xsl:template>

    <xsl:template match="series" mode="book-citation">
        <xsl:text>,&#32;</xsl:text>
        <span class="{local-name()}">
            <xsl:apply-templates/>
        </span>
    </xsl:template>

    <xsl:template match="conf-sponsor" mode="citation">
        <xsl:text>&#32;</xsl:text>
        <span class="{local-name()}">
            <xsl:apply-templates/>
        </span>
        <xsl:text>.</xsl:text>
    </xsl:template>

    <xsl:template match="conf-loc" mode="citation">
        <xsl:text>&#32;</xsl:text>
        <span class="{local-name()}">
            <xsl:apply-templates/>
        </span>
        <xsl:choose>
            <xsl:when test="../conf-date">
                <xsl:text>,</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>.</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="conf-date" mode="citation">
        <xsl:text>&#32;</xsl:text>
        <span class="{local-name()}">
            <xsl:apply-templates/>
        </span>
        <xsl:text>.</xsl:text>
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
        <xsl:variable name="uri" select="$citation/uri"/>
        <xsl:variable name="comment-uri" select="$citation/comment//uri"/>

        <xsl:choose>
            <xsl:when test="$doi">
                <xsl:variable name="encoded-doi">
                    <xsl:call-template name="urlencode">
                        <xsl:with-param name="value" select="$doi"/>
                    </xsl:call-template>
                </xsl:variable>

                <xsl:value-of select="concat('https://doi.org/', $encoded-doi)"/>
            </xsl:when>
            <xsl:when test="$arxiv">
                <xsl:value-of select="concat('http://arxiv.org/abs/', $arxiv)"/>
            </xsl:when>
            <xsl:when test="$uri/@xlink:href">
                <xsl:value-of select="$uri/@xlink:href"/>
            </xsl:when>
            <xsl:when test="$uri">
                <xsl:value-of select="$uri"/>
            </xsl:when>
            <xsl:when test="$comment-uri/@xlink:href">
                <xsl:value-of select="$comment-uri/@xlink:href"/>
            </xsl:when>
            <xsl:when test="$comment-uri">
                <xsl:value-of select="$comment-uri"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:variable name="authors" select="$citation/person-group[@person-group-type='author']"/>

                <xsl:choose>
                    <xsl:when test="$citation/@publication-type = 'book'">
                        <xsl:choose>
                            <xsl:when test="$citation/article-title">
                                <xsl:value-of select="concat('https://scholar.google.com/scholar_lookup?title=', $citation/article-title, '&amp;author=', $authors/name[1]/surname, '&amp;publication_year=', $citation/year/@iso-8601-date)"/>
                            </xsl:when>
                            <xsl:when test="$citation/source">
                                <xsl:variable name="editors" select="$citation/person-group[@person-group-type='editor']"/>
                                <xsl:variable name="author">
                                    <xsl:choose>
                                        <xsl:when test="$editors">
                                            <xsl:value-of select="$editors/name[1]/surname"/>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:value-of select="$authors/name[1]/surname"/>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:variable>
	                            <xsl:value-of select="concat('https://scholar.google.com/scholar_lookup?title=', $citation/source, '&amp;author=', $author, '&amp;publication_year=', $citation/year/@iso-8601-date)"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="concat('#', $citation/../@id)"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:choose>
                            <xsl:when test="$citation/article-title">
                                <xsl:value-of select="concat('https://scholar.google.com/scholar_lookup?title=', $citation/article-title, '&amp;author=', $authors/name[1]/surname, '&amp;publication_year=', $citation/year/@iso-8601-date)"/>
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

    <xsl:template match="article-title | data-title" mode="citation">
        <a class="{local-name()}" target="_blank" itemprop="url">
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

	<xsl:template match="volume" mode="journal-citation">
		<span class="{local-name()}"
		      itemprop="isPartOf" itemscope="itemscope"
		      itemtype="http://schema.org/PublicationVolume">
			<xsl:apply-templates select="../source" mode="journal-citation"/>
			<xsl:text>&#32;</xsl:text>
			<b itemprop="volumeNumber">
				<xsl:apply-templates/>
			</b>
		</span>
	</xsl:template>

    <xsl:template match="volume" mode="citation">
        <b class="{local-name()}">
            <xsl:apply-templates/>
        </b>
    </xsl:template>

	<xsl:template match="issue" mode="journal-citation">
		<span class="{local-name()}"
		      itemprop="isPartOf" itemscope="itemscope"
		      itemtype="http://schema.org/PublicationIssue">
			<!-- if a volume exists, the source is part of it -->
			<xsl:choose>
				<xsl:when test="../volume">
					<xsl:apply-templates select="../volume" mode="journal-citation"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates select="../source" mode="journal-citation"/>
					<xsl:text>&#32;</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:text>(</xsl:text>
			<span itemprop="issueNumber">
				<xsl:apply-templates/>
			</span>
			<xsl:text>)</xsl:text>
		</span>
	</xsl:template>

    <xsl:template match="elocation-id" mode="citation">
        <xsl:if test="../volume">
            <xsl:text>:</xsl:text>
        </xsl:if>
        <span class="{local-name()}" itemprop="pageStart">
            <xsl:apply-templates/>
        </span>
    </xsl:template>

    <xsl:template match="page-range" mode="citation">
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
        <xsl:choose>
            <xsl:when test="../lpage and . != ../lpage">
                <span class="{local-name()}" itemprop="pageStart">
                    <xsl:apply-templates/>
                </span>
                <xsl:text>-</xsl:text>
                <span class="lpage" itemprop="pageEnd">
                    <xsl:value-of select="../lpage"/>
                </span>
            </xsl:when>
            <xsl:otherwise>
                <span class="{local-name()}" itemprop="pageStart">
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
        <xsl:text>.</xsl:text>
    </xsl:template>

    <xsl:template match="comment" mode="citation">
        <xsl:text>&#32;</xsl:text>
        <span class="{local-name()}">
            <xsl:apply-templates/>
        </span>
    </xsl:template>

    <!-- comments, access date -->
    <xsl:template name="comment">
        <xsl:apply-templates select="comment" mode="citation"/>
        <xsl:apply-templates select="date-in-citation[@content-type='access-date']" mode="citation"/>
    </xsl:template>

    <!-- citation author names -->
    <xsl:template name="authors-year">
        <xsl:variable name="authors" select="person-group[not(@person-group-type='editor')]"/>
        <xsl:variable name="author-names" select="$authors/name | $authors/collab"/>

        <xsl:if test="$author-names or year">
            <span class="citation-authors-year">
                <xsl:if test="$author-names">
                    <b>
                        <xsl:apply-templates select="$author-names" mode="citation"/>
                        <xsl:text>.</xsl:text>
                    </b>
                </xsl:if>
                <xsl:apply-templates select="year" mode="citation"/>
            </span>
            <xsl:text>&#32;</xsl:text>
        </xsl:if>
    </xsl:template>

    <!-- name -->
    <xsl:template match="name" mode="citation">
        <xsl:variable name="person-type" select="parent::person-group/@person-group-type"/>

        <span class="{local-name()}" itemprop="author" itemscope="itemscope" itemtype="http://schema.org/Person">
            <xsl:apply-templates select="surname"/>
            <xsl:if test="given-names">
                <xsl:text>&#32;</xsl:text>
                <xsl:apply-templates select="given-names"/>
            </xsl:if>
        </span>

        <xsl:if test="$person-type != '' and $person-type != 'author' and $person-type != 'editor'">
            <xsl:text>&#32;(</xsl:text>
            <span class="person-type">
                <xsl:call-template name="ucfirst">
                    <xsl:with-param name="text" select="$person-type"/>
                </xsl:call-template>
            </span>
            <xsl:text>)</xsl:text>
        </xsl:if>

        <xsl:call-template name="comma-separator"/>
    </xsl:template>

    <!-- collaboration name -->
    <xsl:template match="collab" mode="citation">
        <span class="{local-name()}" itemprop="author" itemscope="itemscope">
            <xsl:apply-templates/>
        </span>
        <xsl:call-template name="comma-separator"/>
    </xsl:template>

    <!-- access date -->
    <xsl:template match="date-in-citation[@content-type='access-date']" mode="citation">
        <xsl:text>&#32;</xsl:text>
        <span class="access-date">
            <xsl:text>(accessed&#32;</xsl:text>
            <time class="{local-name()}" datetime="{@iso-8601-date}">
                <xsl:apply-templates/>
            </time>
            <xsl:text>)</xsl:text>
        </span>
    </xsl:template>

    <!-- convert the first letter of a string to uppercase -->
    <xsl:template name="ucfirst">
        <xsl:param name="text"/>
        <xsl:value-of select="translate(substring($text, 1, 1) , 'abcdefghijklmnopqrstuvwxyz', 'ABCDEFGHIJKLMNOPQRSTUVWXYZ')"/>
        <xsl:value-of select="substring($text, 2, string-length($text) - 1)"/>
    </xsl:template>
</xsl:stylesheet>
