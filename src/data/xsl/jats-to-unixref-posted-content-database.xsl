<?xml version="1.0"?>
<!-- this is a inital covnverions of jats to CrossRef unixref jats-to-unixref.xsl altered to produce posted_content for preprints -->
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                xmlns:xlink="http://www.w3.org/1999/xlink"
                xmlns:fr="http://www.crossref.org/fundref.xsd"
                xmlns:rel="http://www.crossref.org/relations.xsd"
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

  <xsl:variable name="article-meta" select="/article/front/article-meta"/>
  <xsl:variable name="article-id" select="$article-meta/article-id[@pub-id-type='publisher-id']"/>
<!--	<xsl:variable name="doi" select="$article-meta/article-id[@pub-id-type='doi']"/>-->

  <xsl:param name="useThisUrl" />
  <xsl:variable name="url">
    <xsl:choose>
      <xsl:when test="$useThisUrl =''">
        <xsl:value-of select="$article-meta/self-uri/@xlink:href"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$useThisUrl"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:param name="doi"/>
  <xsl:param name="batchId" select="concat($doi, '/database')"/>
  <xsl:param name="timestamp"/>
  <xsl:param name="depositorName"/>
  <xsl:param name="depositorEmail"/>
  <xsl:param name="version"/>
  <xsl:param name="target"/>
  <xsl:param name="references"/>

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
      <email_address><xsl:value-of select="$depositorEmail"/></email_address>
    </depositor>
    <registrant>
      <xsl:value-of select="$depositorName"/>
    </registrant>
  </xsl:template>

  <!-- translate supplemental files into database   -->

  <xsl:template match="article">
    <xsl:variable name="meta" select="front/article-meta"/>
    <xsl:variable name="pub-date" select="$meta/pub-date[@date-type='pub'][@pub-type='epub']|$meta/pub-date[@date-type='preprint'][@pub-type='epreprint']"/>
    <!-- list supplemental files as datasets (database) awating a
    future verson (>4.4.1) of crossref that support SI for preprints -->
    <xsl:apply-templates select="body//supplementary-material[object-id[@pub-id-type='doi']]" mode="database"/>
  </xsl:template>

  <!-- zero-pad a month or day number -->
  <xsl:template match="month | day" mode="zero-pad-date">
    <xsl:variable name="text" select="text()"/>
    <xsl:if test="string-length($text) = 1">
      <xsl:text>0</xsl:text>
    </xsl:if>
    <xsl:value-of select="$text"/>
  </xsl:template>

  <!-- style markup for title -->

  <xsl:template match="bold" mode="title">
    <b><xsl:apply-templates mode="title"/></b>
  </xsl:template>

  <xsl:template match="italic" mode="title">
    <i><xsl:apply-templates mode="title"/></i>
  </xsl:template>

  <xsl:template match="underline" mode="title">
    <u><xsl:apply-templates mode="title"/></u>
  </xsl:template>

  <xsl:template match="overline" mode="title">
    <ovl><xsl:apply-templates mode="title"/></ovl>
  </xsl:template>

  <xsl:template match="sup" mode="title">
    <sup><xsl:apply-templates mode="title"/></sup>
  </xsl:template>

  <xsl:template match="sub" mode="title">
    <sub><xsl:apply-templates mode="title"/></sub>
  </xsl:template>

  <xsl:template match="sc" mode="title">
    <scp><xsl:apply-templates mode="title"/></scp>
  </xsl:template>

  <xsl:template match="monospace" mode="title">
    <tt><xsl:apply-templates mode="title"/></tt>
  </xsl:template>

  <!-- use tex-math instead of MathML for formulae until using MathML3 -->
  <xsl:template match="inline-formula" mode="title">
    <xsl:value-of select="alternatives/tex-math"/>
  </xsl:template>

  <xsl:template match="inline-formula" mode="abstract">
    <xsl:value-of select="alternatives/tex-math"/>
  </xsl:template>

  <!-- TODO: math markup -->

  <!-- publication date -->


  <!-- contributors -->

  <xsl:template match="contrib">
    <xsl:choose>
      <xsl:when test="name">
        <person_name contributor_role="author" sequence="additional">
          <xsl:call-template name="contributor-sequence"/>
          <xsl:apply-templates select="name" mode="contrib"/>
          <xsl:apply-templates select="xref[@ref-type='aff']" mode="contrib"/>
          <xsl:apply-templates select="contrib-id[@contrib-id-type='orcid']" mode="contrib"/>
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

  <xsl:template match="contrib-id[@contrib-id-type='orcid']" mode="contrib">
    <ORCID authenticated="true">
      <xsl:value-of select="concat('http://orcid.org/', .)"/>
    </ORCID>
  </xsl:template>

  <!-- affiliation -->

  <xsl:template match="xref[@ref-type='aff']" mode="contrib">
    <xsl:apply-templates select="//aff[@id=current()/@rid]" mode="contrib"/>
  </xsl:template>

  <xsl:template match="aff" mode="contrib">
    <affiliation>
      <xsl:apply-templates select="node()" mode="aff"/>
    </affiliation>
  </xsl:template>

  <!-- include most elements in affiliations -->
  <xsl:template match="*" mode="aff">
    <xsl:value-of select="."/>
    <xsl:if test="position() != last()">
      <xsl:text>, </xsl:text>
    </xsl:if>
  </xsl:template>

  <!-- don't include the label in affiliations -->
  <xsl:template match="label" mode="aff"/>

  <!-- ignore text nodes (commas) in affiliations -->
  <xsl:template match="text()" mode="aff"/>

  <!-- supplementary material database -->
  <xsl:template match="supplementary-material" mode="database">
    <database>
      <database_metadata language="en">
        <!-- contributors -->
        <contributors>
          <xsl:apply-templates select="../../../front/article-meta/contrib-group/contrib[@contrib-type='author']"/>
        </contributors>
        <xsl:apply-templates select="caption/title"/>
        <description>
          <xsl:apply-templates select="caption/p"/>
        </description>
      </database_metadata>
      <dataset>
        <rel:program name="relations">
          <rel:related_item>
            <rel:inter_work_relation relationship-type="isReferencedBy" identifier-type="doi">
              <xsl:value-of select="$doi"/>
            </rel:inter_work_relation>
          </rel:related_item>
        </rel:program>
        <doi_data>
          <doi><xsl:value-of select="concat($doi, '/', @id)"/></doi>
          <resource><xsl:value-of select="concat($url, '/', @id)"/></resource>
        </doi_data>
      </dataset>
    </database>
  </xsl:template>

  <!-- caption title -->
  <xsl:template match="caption/title">
    <titles>
      <title>
        <xsl:if test="../../label">
          <xsl:value-of select="concat(../../label, ': ')"/>
        </xsl:if>
        <xsl:apply-templates select="node()" mode="title"/>
      </title>
    </titles>
  </xsl:template>

  <!-- caption description -->
  <xsl:template match="caption/p" mode="database">
    <titles>
      <title>
        <xsl:if test="../../label">
          <xsl:value-of select="concat(../../label, ': ')"/>
        </xsl:if>
        <xsl:apply-templates select="node()" mode="title"/>
      </title>
    </titles>
  </xsl:template>

  <!-- http://help.crossref.org/include-abstracts-in-deposits -->
  <xsl:template match="node()" mode="abstract">
    <xsl:element name="jats:{local-name()}" namespace="http://www.ncbi.nlm.nih.gov/JATS1">
      <!--<xsl:copy-of select="namespace::*"/>-->
      <xsl:apply-templates select="node()|@*" mode="abstract"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="text()" mode="abstract">
    <xsl:value-of select="."/>
  </xsl:template>

  <xsl:template match="@*" mode="abstract">
    <xsl:attribute name="{name()}">
      <xsl:value-of select="."/>
    </xsl:attribute>
  </xsl:template>

  <xsl:template match="xref" mode="abstract">
    <xsl:apply-templates select="node()"/>
  </xsl:template>

  <!-- license URL -->
  <!-- http://tdmsupport.crossref.org/license-uris-technical-details/ -->
  <xsl:template match="permissions/license/@xlink:href" mode="access-indicators">
    <ai:program name="AccessIndicators">
      <ai:license_ref>
        <xsl:value-of select="."/>
      </ai:license_ref>
    </ai:program>
  </xsl:template>

  <!-- fundref -->
  <!-- http://help.crossref.org/fundref -->
  <xsl:template match="funding-group" mode="fundref">
    <fr:program>
      <xsl:apply-templates select="award-group/funding-source" mode="fundref"/>
    </fr:program>
  </xsl:template>

</xsl:stylesheet>
