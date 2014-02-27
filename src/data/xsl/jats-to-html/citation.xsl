<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" exclude-result-prefixes="xlink"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xlink="http://www.w3.org/1999/xlink">

    <!-- journal citation -->
    <xsl:template match="element-citation[@publication-type='journal']">
        <xsl:variable name="authors" select="person-group[@person-group-type='author']"/>
        <xsl:if test="$authors or year">
            <span class="citation-authors-year">
                <xsl:apply-templates select="$authors" mode="citation"/>
                <xsl:apply-templates select="year" mode="citation"/>
            </span>
            <xsl:text>&#32;</xsl:text>
        </xsl:if>
        <cite itemprop="name">
            <xsl:apply-templates select="article-title" mode="citation"/>
        </cite>
        <xsl:text>&#32;</xsl:text>
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
        <xsl:text>&#32;</xsl:text>
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
            <xsl:apply-templates select="fpage" mode="citation"/>
            <xsl:text>&#32;</xsl:text>
            <xsl:apply-templates select="pub-id[@pub-id-type='isbn']" mode="citation"/>
            <xsl:apply-templates select="comment" mode="citation"/>
        </span>
    </xsl:template>

    <!-- report citations -->
    <xsl:template match="element-citation[@publication-type='report']">
        <span class="citation-authors-year">
            <xsl:apply-templates select="person-group[@person-group-type='author']" mode="citation"/>
            <xsl:apply-templates select="year" mode="citation"/>
        </span>
        <xsl:text>&#32;</xsl:text>
        <span class="article-title">
            <xsl:apply-templates select="article-title" mode="citation"/>
            <xsl:text>&#32;</xsl:text>
            <xsl:apply-templates select="source" mode="report-citation"/>
        </span>
        <xsl:apply-templates select="institution" mode="report-citation"/>
        <xsl:apply-templates select="volume" mode="citation"/>
        <xsl:apply-templates select="fpage" mode="citation"/>
        <xsl:apply-templates select="comment" mode="citation"/>
    </xsl:template>

    <!-- thesis citations -->
    <xsl:template match="element-citation[@publication-type='thesis']">
        <span class="citation-authors-year">
            <xsl:apply-templates select="person-group[@person-group-type='author']" mode="citation"/>
            <xsl:apply-templates select="year" mode="citation"/>
        </span>
        <xsl:text>&#32;</xsl:text>
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
            <xsl:apply-templates select="person-group[@person-group-type='author']" mode="citation"/>
            <xsl:apply-templates select="year" mode="citation"/>
        </span>
        <xsl:text>&#32;</xsl:text>
        <span class="article-title">
            <xsl:apply-templates select="article-title" mode="citation"/>
        </span>
        <xsl:apply-templates select="comment" mode="citation"/>
        <xsl:text>&#32;</xsl:text>
        <xsl:call-template name="preprint-label"/>
    </xsl:template>

    <!-- other citations (?) -->
    <xsl:template match="element-citation">
        <span class="citation-authors-year">
            <xsl:apply-templates select="person-group[@person-group-type='author']" mode="citation"/>
            <xsl:apply-templates select="year" mode="citation"/>
        </span>
        <xsl:text>&#32;</xsl:text>
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
        <xsl:apply-templates select="following-sibling::part-title" mode="book-citation-edition"/>
        <xsl:text>).</xsl:text>
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
        <xsl:variable name="uri" select="$citation/comment//uri"/>

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
            <xsl:when test="$uri/@xlink:href">
                <xsl:value-of select="$uri/@xlink:href"/>
            </xsl:when>
            <xsl:when test="$uri">
                <xsl:value-of select="$uri"/>
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
        <xsl:choose>
            <xsl:when test="../lpage">
                <span class="{local-name()}">
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
        <xsl:text>.</xsl:text>
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
        <span class="{local-name()}" itemprop="author" itemscope="itemscope">
            <xsl:apply-templates/>
        </span>
        <xsl:call-template name="comma-separator"/>
    </xsl:template>
</xsl:stylesheet>
