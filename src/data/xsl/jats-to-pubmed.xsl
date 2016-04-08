<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="xml" indent="yes" encoding="UTF-8" standalone="yes"
	            doctype-public="-//NLM//DTD PubMed//EN"
	            doctype-system="http://www.ncbi.nlm.nih.gov:80/entrez/query/static/PubMed.dtd"/>

	<!-- https://www.nlm.nih.gov/bsd/licensee/elements_descriptions.html -->

	<!--<xsl:strip-space elements="*"/>-->
	<!--<xsl:preserve-space elements="p"/>-->

	<xsl:variable name="journal-meta" select="/article/front/journal-meta"/>
	<xsl:variable name="article-meta" select="/article/front/article-meta"/>

	<xsl:key name="affiliations" match="aff" use="@id"/>

	<!-- root element -->
	<xsl:template match="/">
		<ArticleSet>
			<Article>
				<Journal>
					<PublisherName>
						<xsl:value-of select="$journal-meta/publisher/publisher-name"/>
					</PublisherName>

					<JournalTitle>
						<xsl:value-of select="$journal-meta/journal-title-group/journal-title"/>
					</JournalTitle>

					<Issn>
						<xsl:value-of select="$journal-meta/issn[@pub-type='epub']"/>
					</Issn>

					<Volume>
						<xsl:value-of select="$article-meta/volume"/>
					</Volume>

					<!--<Issue>
						<xsl:value-of select="$article-meta/issue"/>
					</Issue>-->

					<PubDate PubStatus="epublish">
						<xsl:apply-templates select="$article-meta/pub-date[@pub-type='epub']"/>
					</PubDate>
				</Journal>

				<!--<Replaces IdType="doi"></Replaces>-->

				<ArticleTitle>
					<xsl:value-of select="normalize-space($article-meta/title-group/article-title)"/>
				</ArticleTitle>

				<ELocationID EIdType="doi" ValidYN="Y">
					<xsl:value-of select="$article-meta/article-id[@pub-id-type='doi']"/>
				</ELocationID>

				<ELocationID EIdType="pii" ValidYN="Y">
					<xsl:value-of select="$article-meta/article-id[@pub-id-type='publisher-id']"/>
				</ELocationID>

				<Language>en</Language>

				<AuthorList>
					<xsl:apply-templates select="$article-meta/contrib-group/contrib[@contrib-type='author']"/>
				</AuthorList>

				<PublicationType>Journal Article</PublicationType>

				<ArticleIdList>
					<ArticleId IdType="pii">
						<xsl:value-of select="$article-meta/article-id[@pub-id-type='publisher-id']"/>
					</ArticleId>

					<ArticleId IdType="doi">
						<xsl:value-of select="$article-meta/article-id[@pub-id-type='doi']"/>
					</ArticleId>
				</ArticleIdList>

				<History>
					<PubDate PubStatus="received">
						<xsl:apply-templates select="$article-meta/history/date[@date-type='received']"/>
					</PubDate>

					<PubDate PubStatus="accepted">
						<xsl:apply-templates select="$article-meta/history/date[@date-type='accepted']"/>
					</PubDate>
				</History>

				<Abstract>
					<xsl:value-of select="normalize-space($article-meta/abstract)"/>
				</Abstract>

				<!--<CopyrightInformation>
					<xsl:value-of select="normalize-space($article-meta/permissions/copyright-statement)"/>
				</CopyrightInformation>-->
			</Article>

		</ArticleSet>
	</xsl:template>

	<!-- date -->
	<xsl:template match="pub-date | date">
		<Year>
			<xsl:value-of select="year"/>
		</Year>
		<Month>
			<xsl:value-of select="month"/>
		</Month>
		<Day>
			<xsl:value-of select="day"/>
		</Day>
	</xsl:template>

	<!-- contributor (e.g. author) -->
	<xsl:template match="contrib">
		<Author>
			<xsl:choose>
				<xsl:when test="collab">
					<CollectiveName>
						<xsl:value-of select="collab"/>
					</CollectiveName>
				</xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates select="name/given-names"/>
					<xsl:apply-templates select="name/surname"/>
					<xsl:apply-templates select="name/suffix"/>
					<xsl:apply-templates select="key('affiliations', xref[@ref-type='aff']/@rid)"/>
				</xsl:otherwise>
			</xsl:choose>
		</Author>
	</xsl:template>

	<!-- given names -->
	<xsl:template match="given-names">
		<xsl:variable name="names" select="normalize-space(.)"/>
		<xsl:choose>
			<xsl:when test="contains($names, ' ')">
				<FirstName EmptyYN="N">
					<xsl:value-of select="substring-before($names, ' ')"/>
				</FirstName>
				<MiddleName>
					<xsl:call-template name="remove-punctuation">
						<xsl:with-param name="text" select="substring-after($names, ' ')"/>
					</xsl:call-template>
				</MiddleName>
			</xsl:when>
			<xsl:otherwise>
				<FirstName>
					<xsl:attribute name="EmptyYN">
						<xsl:choose>
							<xsl:when test="normalize-space($names) = ''">
								<xsl:text>Y</xsl:text>
							</xsl:when>
							<xsl:otherwise>
								<xsl:text>N</xsl:text>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:attribute>
					<xsl:value-of select="$names"/>
				</FirstName>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- surname -->
	<xsl:template match="surname">
		<LastName>
			<xsl:value-of select="."/>
		</LastName>
	</xsl:template>

	<!-- name suffix -->
	<xsl:template match="suffix">
		<Suffix>
			<xsl:value-of select="."/>
		</Suffix>
	</xsl:template>

	<!-- affiliations -->
	<xsl:template match="aff">
		<AffiliationInfo>
			<Affiliation>
				<xsl:apply-templates select="node()[not(self::label)][not(self::text())]" mode="affiliation"/>
			</Affiliation>
		</AffiliationInfo>
	</xsl:template>

	<!-- affiliation part, comma-separated -->
	<xsl:template match="*" mode="affiliation">
		<xsl:value-of select="normalize-space(.)"/>
		<xsl:if test="position() != last()">
			<xsl:text>, </xsl:text>
		</xsl:if>
	</xsl:template>

	<!-- remove punctuation (only periods, so far) -->
	<xsl:template name="remove-punctuation">
		<xsl:param name="text"/>
		<xsl:value-of select="translate($text, '.', '')"/>
	</xsl:template>
</xsl:stylesheet>
