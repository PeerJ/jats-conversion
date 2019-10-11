<?xml version="1.0"?>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                xmlns:xlink="http://www.w3.org/1999/xlink"
                xmlns:fr="http://www.crossref.org/fundref.xsd"
                xmlns:jats="http://www.ncbi.nlm.nih.gov/JATS1"
                xmlns:mml="http://www.w3.org/1998/Math/MathML"
                xmlns:ai="http://www.crossref.org/AccessIndicators.xsd"
                xmlns:str="http://exslt.org/strings"
                xmlns="http://www.crossref.org/schema/4.4.2"
                xsi:schemaLocation="http://www.crossref.org/schema/4.4.2 http://www.crossref.org/schema/deposit/crossref4.4.2.xsd
  http://www.crossref.org/fundref.xsd http://www.crossref.org/schema/deposit/fundref.xsd
  http://www.crossref.org/AccessIndicators.xsd http://www.crossref.org/schemas/AccessIndicators.xsd"
                exclude-result-prefixes="xlink">

  <xsl:output method="xml" indent="yes" encoding="UTF-8" standalone="yes" />

  <xsl:strip-space elements="aff"/>
  
  <xsl:variable name="meta" select="/article/front/article-meta"/>
  <xsl:variable name="doi" select="$meta/article-id[@pub-id-type='doi']"/>
  <xsl:variable name="url" select="$meta/self-uri/@xlink:href"/>

  <xsl:param name="batchId" select="$doi"/>
  <xsl:param name="timestamp"/>
  <xsl:param name="depositorName"/>
  <xsl:param name="depositorEmail"/>
  <xsl:param name="archiveLocations"/>
  <xsl:param name="doi_data_doi"/>
  <xsl:param name="doi_data_resource"/>

  <!-- root element -->

  <xsl:template match="/">
    <doi_batch version="4.4.2" xsi:schemaLocation="http://www.crossref.org/schema/4.4.2 http://www.crossref.org/schema/deposit/crossref4.4.2.xsd">
      <head>
        <xsl:call-template name="deposition"/>
      </head>
      <body>
        <xsl:apply-templates select="article"/>
      </body>
    </doi_batch>
  </xsl:template>

  <!-- deposition metadata -->

  <xsl:template name="deposition">
    <doi_batch_id>
      <xsl:value-of select="$batchId"/>
    </doi_batch_id>

    <timestamp>
      <xsl:value-of select="$timestamp"/>
    </timestamp>

    <depositor>
      <depositor_name>
        <xsl:value-of select="$depositorName"/>
      </depositor_name>

      <email_address>
        <xsl:value-of select="$depositorEmail"/>
      </email_address>
    </depositor>

    <registrant>
      <xsl:value-of select="$depositorName"/>
    </registrant>
  </xsl:template>

  <!-- item metadata -->

  <xsl:template match="article">
    <xsl:variable name="pub-date" select="$meta/pub-date[@date-type='pub'][@pub-type='epub']"/>

    <journal>
      <!-- journal -->
      <journal_metadata language="en" reference_distribution_opts="any">
        <full_title>
          <xsl:value-of select="front/journal-meta/journal-title-group/journal-title"/>
        </full_title>

        <xsl:apply-templates select="front/journal-meta/issn"/>
        <xsl:call-template name="doi_data"/>
      </journal_metadata>

      <!-- journal issue -->
      <journal_issue>
        <publication_date media_type="online">
          <year>
            <xsl:value-of select="$pub-date/year/@iso-8601-date"/>
          </year>
        </publication_date>
        <journal_volume>
          <volume>
            <xsl:value-of select="$meta/volume"/>
          </volume>
        </journal_volume>
      </journal_issue>

      <!-- article -->
      <journal_article publication_type="full_text">
        <!-- article metadata -->
        <xsl:apply-templates select="$meta"/>
      </journal_article>
    </journal>
  </xsl:template>

  <!-- issn -->

  <xsl:template match="issn">
    <xsl:choose>
      <xsl:when test=".='0000-0000'">
        <!-- miss out the placeholder ISSN - 0000-0000
        JATS must have a ISSN set but Crossref 4.4.1 onwards is optional -->
      </xsl:when>
      <xsl:otherwise>
        <issn media_type="electronic">
          <xsl:value-of select="."/>
        </issn>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- doi_data, used when submitting a journal article with out a journal issn -->

  <xsl:template name="doi_data">
    <xsl:choose>
      <xsl:when test="$doi_data_doi">
        <doi_data>
          <doi>
            <xsl:value-of select="$doi_data_doi"/>
          </doi>
          <xsl:choose>
            <xsl:when test="$doi_data_resource">
              <resource>
                <xsl:value-of select="$doi_data_resource"/>
              </resource>
            </xsl:when>
          </xsl:choose>
        </doi_data>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <!-- article metadata -->

  <xsl:template match="article-meta">
    <xsl:variable name="pub-date" select="pub-date[@date-type='pub'][@pub-type='epub']"/>

    <titles>
      <xsl:apply-templates select="title-group/article-title" mode="title"/>
    </titles>

    <contributors>
      <xsl:apply-templates select="contrib-group/contrib[@contrib-type='author']"/>
    </contributors>

    <publication_date media_type="online">
      <month>
        <xsl:apply-templates select="$pub-date/month" mode="zero-pad-date"/>
      </month>
      <day>
        <xsl:apply-templates select="$pub-date/day" mode="zero-pad-date"/>
      </day>
      <year>
        <xsl:value-of select="$pub-date/year/@iso-8601-date"/>
      </year>
    </publication_date>

    <pages>
      <first_page>
        <xsl:value-of select="elocation-id"/>
      </first_page>
    </pages>

    <publisher_item>
      <!-- http://help.crossref.org/using_best_practices_depositing -->
      <item_number item_number_type="article-number">
        <xsl:value-of select="elocation-id"/>
      </item_number>
      <identifier id_type="doi">
        <xsl:value-of select="$doi"/>
      </identifier>
    </publisher_item>

    <doi_data>
      <doi>
        <xsl:value-of select="$doi"/>
      </doi>
      <resource>
        <xsl:value-of select="self-uri/@xlink:href"/>
      </resource>
    </doi_data>
  </xsl:template>

  <!-- zero-pad a month or day number -->
  <xsl:template match="month | day" mode="zero-pad-date">
    <xsl:variable name="text" select="text()"/>
    <xsl:if test="string-length($text) = 1">
      <xsl:text>0</xsl:text>
    </xsl:if>
    <xsl:value-of select="$text"/>
  </xsl:template>

  <!-- article title -->

  <xsl:template match="article-title" mode="title">
    <title>
      <xsl:apply-templates mode="title"/>
    </title>
  </xsl:template>

  <!-- style markup for title -->

  <xsl:template match="bold" mode="title">
    <b>
      <xsl:apply-templates mode="title"/>
    </b>
  </xsl:template>

  <xsl:template match="italic" mode="title">
    <i>
      <xsl:apply-templates mode="title"/>
    </i>
  </xsl:template>

  <xsl:template match="underline" mode="title">
    <u>
      <xsl:apply-templates mode="title"/>
    </u>
  </xsl:template>

  <xsl:template match="overline" mode="title">
    <ovl>
      <xsl:apply-templates mode="title"/>
    </ovl>
  </xsl:template>

  <xsl:template match="sup" mode="title">
    <sup>
      <xsl:apply-templates mode="title"/>
    </sup>
  </xsl:template>

  <xsl:template match="sub" mode="title">
    <sub>
      <xsl:apply-templates mode="title"/>
    </sub>
  </xsl:template>

  <xsl:template match="sc" mode="title">
    <scp>
      <xsl:apply-templates mode="title"/>
    </scp>
  </xsl:template>

  <xsl:template match="monospace" mode="title">
    <tt>
      <xsl:apply-templates mode="title"/>
    </tt>
  </xsl:template>

  <!-- use tex-math instead of MathML for formulae until using MathML3 -->
  <xsl:template match="inline-formula" mode="title">
    <xsl:value-of select="alternatives/tex-math"/>
  </xsl:template>

  <!-- contributors -->

  <xsl:template match="contrib">
    <xsl:choose>
      <xsl:when test="name">
        <person_name contributor_role="author" sequence="additional">
          <xsl:call-template name="contributor-sequence"/>
          <xsl:apply-templates select="name" mode="contrib"/>
        </person_name>
      </xsl:when>
      <xsl:when test="collab">
        <organization contributor_role="author" sequence="additional">
          <xsl:call-template name="contributor-sequence"/>
          <xsl:value-of select="collab"/><!-- string value -->
        </organization>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="contributor-sequence">
    <xsl:choose>
      <!-- TODO: check for equal-contrib -->
      <xsl:when test="position() = 1">
        <xsl:attribute name="sequence">first</xsl:attribute>
      </xsl:when>
      <xsl:otherwise>
        <xsl:attribute name="sequence">additional</xsl:attribute>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- contributor name -->

  <xsl:template match="name" mode="contrib">
    <!-- there must be a surname, so use given-names as surname if needed -->
    <xsl:choose>
      <xsl:when test="surname">
        <xsl:if test="given-names">
          <given_name>
            <xsl:value-of select="given-names"/>
          </given_name>
        </xsl:if>

        <surname>
          <xsl:value-of select="surname"/>
        </surname>
      </xsl:when>

      <xsl:otherwise>
        <surname>
          <xsl:value-of select="given-names"/>
        </surname>
      </xsl:otherwise>
    </xsl:choose>

    <xsl:if test="suffix">
      <suffix>
        <xsl:apply-templates select="suffix"/>
      </suffix>
    </xsl:if>
  </xsl:template>
</xsl:stylesheet>
