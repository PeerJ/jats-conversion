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
  xmlns="http://www.crossref.org/schema/4.4.1"
  xsi:schemaLocation="http://www.crossref.org/schema/4.4.1 http://www.crossref.org/schema/deposit/crossref4.4.1.xsd
  http://www.crossref.org/fundref.xsd http://www.crossref.org/schema/deposit/fundref.xsd
  http://www.crossref.org/AccessIndicators.xsd http://www.crossref.org/schemas/AccessIndicators.xsd"
  exclude-result-prefixes="xlink">

  <xsl:output method="xml" indent="yes" encoding="UTF-8" standalone="yes" />

  <xsl:strip-space elements="aff"/>

  <xsl:variable name="article-meta" select="/article/front/article-meta"/>
  <xsl:variable name="article-id" select="$article-meta/article-id[@pub-id-type='publisher-id']"/>
  <!-- <xsl:variable name="doi" select="$article-meta/article-id[@pub-id-type='doi']"/> -->
  <xsl:variable name="url" select="$article-meta/self-uri/@xlink:href"/>

  <xsl:param name="doi"/>
  <xsl:param name="batchId" select="$doi"/>
  <xsl:param name="timestamp" />
  <xsl:param name="depositorName" />
  <xsl:param name="depositorEmail"/>
  <xsl:param name="isPreprintOf"/>
  <xsl:param name="previousVersionDoi"/>
  <xsl:param name="nextVersionDoi"/>



  <!-- root element -->

  <xsl:template match="/">
    <doi_batch version="4.4.1" xsi:schemaLocation="http://www.crossref.org/schema/4.4.1 http://www.crossref.org/schema/deposit/crossref4.4.1.xsd">
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

  <!-- posted_content  -->

  <xsl:template match="article">
    <xsl:variable name="meta" select="front/article-meta"/>
    <xsl:variable name="pub-date" select="$meta/pub-date[@date-type='pub'][@pub-type='epub']|$meta/pub-date[@date-type='preprint'][@pub-type='epreprint']"/>
    <posted_content type ="preprint" language="en" metadata_distribution_opts="any">

      <!-- group_title -->
      <group_title>
        <xsl:value-of select="front/journal-meta/journal-title-group/journal-title"/>

        <!-- <issn media_type="electronic">
        <xsl:value-of select="front/journal-meta/issn"/>
      </issn>

      <xsl:call-template name="archive-locations"/> -->
    </group_title>


    <xsl:apply-templates select="front/article-meta"/>

    <!-- journal issue -->
    <!-- <journal_issue>
    <publication_date media_type="online">
    <year><xsl:value-of select="$pub-date/year/@iso-8601-date"/></year>
  </publication_date>

  <journal_volume>
  <volume>
  <xsl:value-of select="$meta/volume"/>
</volume>
</journal_volume>
</journal_issue> -->

<!-- article -->
<!-- <journal_article publication_type="full_text"> -->
<!-- article metadata -->

<!-- references -->
<!-- note: only uses the first reference list -->
<!-- <xsl:apply-templates select="back/ref-list[1]"/> -->

<!-- components -->
<!-- <component_list>
<xsl:apply-templates select="body//fig[object-id[@pub-id-type='doi']]" mode="component"/>
<xsl:apply-templates select="body//table-wrap[object-id[@pub-id-type='doi']]" mode="component"/>
<xsl:apply-templates select="body//supplementary-material[object-id[@pub-id-type='doi']]" mode="component"/>
</component_list>
</journal_article> -->
</posted_content>
</xsl:template>

<!-- article metadata -->

<xsl:template match="article-meta">
  <xsl:variable name="pub-date" select="pub-date[@date-type='pub'][@pub-type='epub']|pub-date[@date-type='preprint'][@pub-type='epreprint']"/>
  <xsl:variable name="accepted-date" select="history/date[@date-type='accepted']"/>

  <!-- contributors -->
  <contributors>
    <xsl:apply-templates select="contrib-group/contrib[@contrib-type='author']"/>
  </contributors>

  <!-- titles -->
  <titles>
    <xsl:apply-templates select="title-group/article-title" mode="title"/><!-- TODO: markup? -->
  </titles>

  <!-- posted_date -->
  <posted_date media_type="online">
    <month>
      <xsl:apply-templates select="$pub-date/month" mode="zero-pad-date"/>
    </month>
    <day>
      <xsl:apply-templates select="$pub-date/day" mode="zero-pad-date"/>
    </day>
    <year>
      <xsl:value-of select="$pub-date/year/@iso-8601-date"/>
    </year>
  </posted_date>

  <!-- acceptance_date -->
  <xsl:if test="accepted-date">
    <acceptance_date media_type="online">
      <month>
        <xsl:apply-templates select="$accepted-date/month" mode="zero-pad-date"/>
      </month>
      <day>
        <xsl:apply-templates select="$accepted-date/day" mode="zero-pad-date"/>
      </day>
      <year>
        <xsl:value-of select="$accepted-date/year/@iso-8601-date"/>
      </year>
    </acceptance_date>
  </xsl:if>
  <!-- TODO institution, will accept a Pull Request that implements this.  -->
  <!-- Wrapper element for information about an organization that sponsored or hosted an item but is not the publisher of the item. -->
  <!-- http://data.crossref.org/reports/help/schema_doc/4.4.1/schema_4_4_1.html#http___www.crossref.org_schema_4.4.1_institution -->

  <!-- item_number -->
  <!-- as this can be used as the page number in citations (though first_page takes precedence), use the elocation-id with the "e" prefix rather than the actual article id -->
  <!-- http://help.crossref.org/using_best_practices_depositing -->
  <item_number item_number_type="article-number">
    <xsl:value-of select="elocation-id"/>
    <!--<xsl:value-of select="$article-id"/>-->
  </item_number>

  <!-- abstract -->
  <xsl:apply-templates select="abstract" mode="abstract"/>

  <!-- fundref -->
  <xsl:apply-templates select="funding-group" mode="fundref"/>

  <!-- license URL -->
  <xsl:apply-templates select="permissions/license/@xlink:href" mode="access-indicators"/>

  <!-- relatedItems -->
  <xsl:call-template name="relatedItems"/>

  <doi_data>
    <doi>
      <xsl:value-of select="$doi"/>
    </doi>
    <resource>
      <xsl:value-of select="self-uri/@xlink:href"/>
    </resource>
    <xsl:call-template name="tdm"/>
    <xsl:call-template name="crawler"/>
  </doi_data>

  <!-- <identifier id_type="doi">
  <xsl:value-of select="$doi"/>
</identifier> -->


<!-- end of article -->
</xsl:template>


<xsl:template name="relatedItems">
  <xsl:if test="$isPreprintOf or $previousVersionDoi or $nextVersionDoi or //supplementary-material[object-id[@pub-id-type='doi']] ">
    <rel:program>
      <xsl:apply-templates select="//supplementary-material[object-id[@pub-id-type='doi']]" mode="related-item"/>
      <xsl:if test="$isPreprintOf">
        <rel:related_item>
          <rel:intra_work_relation relationship-type="isPreprintOf" identifier-type="doi">
            <xsl:value-of select="$isPreprintOf"/>
          </rel:intra_work_relation>
        </rel:related_item>
      </xsl:if>
      <xsl:if test="$previousVersionDoi">
        <rel:related_item>
          <rel:intra_work_relation relationship-type="isVariantFormOf" identifier-type="doi">
            <xsl:value-of select="$previousVersionDoi"/>
          </rel:intra_work_relation>
        </rel:related_item>
      </xsl:if>
      <xsl:if test="$nextVersionDoi">
        <rel:related_item>
          <rel:intra_work_relation relationship-type="isReplacedBy" identifier-type="doi">
            <xsl:value-of select="$nextVersionDoi"/>
          </rel:intra_work_relation>
        </rel:related_item>
      </xsl:if>
    </rel:program>
  </xsl:if>
</xsl:template>

<relatedIdentifiers>
  <!--<xsl:apply-templates select="../../back/ref-list/ref/pub-id[@pub-id-type='doi']"/>-->
  <xsl:if test="$previousVersionDoi">
    <relatedIdentifier relatedIdentifierType="DOI" relationType="IsNewVersionOf">
      <xsl:value-of select="$previousVersionDoi"/>
    </relatedIdentifier>
  </xsl:if>
  <xsl:if test="$nextVersionDoi">
    <relatedIdentifier relatedIdentifierType="DOI" relationType="IsPreviousVersionOf">
      <xsl:value-of select="$nextVersionDoi"/>
    </relatedIdentifier>
  </xsl:if>
</relatedIdentifiers>

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

<!--
<xsl:template match="tex-math" mode="title"/>

<xsl:template match="mml:*" mode="title">
<xsl:copy-of select="."/>
</xsl:template>
-->

<!-- TODO: math markup -->

<!-- publication date -->

<xsl:template match="pub-date">
  <month><xsl:value-of select="month"/></month>
  <day><xsl:value-of select="day"/></day>
  <year><xsl:value-of select="year"/></year>
</xsl:template>

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

<!-- reference list -->

<xsl:template match="ref-list">
  <citation_list>
    <xsl:apply-templates select="ref"/>
  </citation_list>
</xsl:template>

<!-- citation -->

<xsl:template match="ref">
  <xsl:apply-templates select="element-citation">
    <xsl:with-param name="key" select="concat($doi, '/ref-', position())"/>
  </xsl:apply-templates>
</xsl:template>

<!-- citation -->
<xsl:template match="element-citation">
  <xsl:param name="key"/>
  <citation key="{$key}">
    <xsl:apply-templates select="issn" mode="citation"/>
    <xsl:apply-templates select="source" mode="citation"/>
    <xsl:call-template name="citation-author"/>
    <xsl:apply-templates select="volume" mode="citation"/>
    <xsl:apply-templates select="issue" mode="citation"/>
    <xsl:apply-templates select="edition" mode="citation"/>
    <xsl:apply-templates select="fpage | elocation-id" mode="citation"/>
    <xsl:apply-templates select="year" mode="citation"/>
    <xsl:apply-templates select="pub-id[@pub-id-type='doi'][1]" mode="citation"/>
    <xsl:apply-templates select="article-title | data-title" mode="citation"/>

    <!-- unstructured citations -->
    <xsl:if test="not(article-title) and not(source)">
      <xsl:apply-templates select="comment" mode="citation"/>
    </xsl:if>
  </citation>
</xsl:template>

<xsl:template match="pub-id[@pub-id-type='doi']" mode="citation">
  <doi>
    <xsl:apply-templates/>
  </doi>
</xsl:template>

<xsl:template match="issn" mode="citation">
  <issn>
    <xsl:apply-templates/>
  </issn>
</xsl:template>

<xsl:template match="source" mode="citation">
  <journal_title>
    <xsl:apply-templates/>
  </journal_title>
</xsl:template>

<xsl:template match="source[../@publication-type='book']" mode="citation">
  <volume_title>
    <xsl:apply-templates/>
  </volume_title>
</xsl:template>

<xsl:template match="edition" mode="citation">
  <edition_number>
    <xsl:choose>
      <xsl:when test="@designator">
        <xsl:value-of select="@designator"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates/>
      </xsl:otherwise>
    </xsl:choose>
  </edition_number>
</xsl:template>

<xsl:template match="fpage" mode="citation">
  <first_page>
    <xsl:apply-templates/>
  </first_page>
</xsl:template>

<xsl:template match="elocation-id" mode="citation">
  <first_page>
    <xsl:apply-templates/>
  </first_page>
</xsl:template>

<xsl:template match="article-title" mode="citation">
  <article_title>
    <xsl:apply-templates/>
  </article_title>
</xsl:template>

<xsl:template match="data-title" mode="citation">
  <article_title>
    <xsl:apply-templates/>
  </article_title>
</xsl:template>

<xsl:template match="volume" mode="citation">
  <volume>
    <xsl:apply-templates/>
  </volume>
</xsl:template>

<xsl:template match="issue" mode="citation">
  <issue>
    <xsl:apply-templates/>
  </issue>
</xsl:template>

<xsl:template match="comment" mode="citation">
  <unstructured_citation>
    <xsl:value-of select="."/>
  </unstructured_citation>
</xsl:template>

<xsl:template match="year" mode="citation">
  <cYear>
    <xsl:choose>
      <xsl:when test="@iso-8601-date">
        <xsl:value-of select="@iso-8601-date"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="."/>
      </xsl:otherwise>
    </xsl:choose>
  </cYear>
</xsl:template>

<!-- citation author names -->

<xsl:template name="citation-author">
  <xsl:variable name="people" select="person-group[@person-group-type='author']"/>
  <xsl:choose>
    <xsl:when test="collab">
      <xsl:apply-templates select="collab[1]" mode="citation"/>
    </xsl:when>
    <xsl:when test="$people/name">
      <xsl:apply-templates select="$people/name[1]" mode="citation"/>
    </xsl:when>
    <xsl:when test="$people/collab">
      <xsl:apply-templates select="$people/collab[1]" mode="citation"/>
    </xsl:when>
  </xsl:choose>
</xsl:template>

<xsl:template match="name" mode="citation">
  <author>
    <xsl:apply-templates select="surname"/>
  </author>
</xsl:template>

<xsl:template match="collab" mode="citation">
  <author>
    <xsl:apply-templates/>
  </author>
</xsl:template>

<!-- figure component -->

<xsl:template match="fig" mode="component">
  <component parent_relation="isPartOf">
    <xsl:apply-templates select="caption/title"/>
    <xsl:if test="graphic/@mimetype and graphic/@mime-subtype">
      <format mime_type="{graphic/@mimetype}/{graphic/@mime-subtype}"/>
    </xsl:if>
    <doi_data>
      <doi><xsl:value-of select="object-id[@pub-id-type='doi']"/></doi>
      <resource><xsl:value-of select="concat($url, '/', @id)"/></resource>
    </doi_data>
  </component>
</xsl:template>

<!-- table component -->

<xsl:template match="table-wrap" mode="component">
  <component parent_relation="isPartOf">
    <xsl:apply-templates select="caption/title"/>
    <format mime_type="text/html"/>
    <doi_data>
      <doi><xsl:value-of select="object-id[@pub-id-type='doi']"/></doi>
      <resource><xsl:value-of select="concat($url, '/', @id)"/></resource>
    </doi_data>
  </component>
</xsl:template>

<!-- supplementary material component -->

<xsl:template match="supplementary-material" mode="component">
  <component parent_relation="isPartOf">
    <xsl:apply-templates select="caption/title"/>
    <xsl:if test="@mimetype and @mime-subtype">
      <format mime_type="{@mimetype}/{@mime-subtype}"/>
    </xsl:if>
    <doi_data>
      <doi><xsl:value-of select="object-id[@pub-id-type='doi']"/></doi>
      <resource><xsl:value-of select="concat($url, '/', @id)"/></resource>
    </doi_data>
  </component>
</xsl:template>

<!-- supplementary material component -->

<xsl:template match="supplementary-material" mode="related-item">
  <rel:related_item>
    <rel:description><xsl:apply-templates select="caption/title"/></rel:description>
    <rel:inter_work_relation relationship-type="references" identifier-type="doi">
      <xsl:value-of select="object-id[@pub-id-type='doi']"/>
    </rel:inter_work_relation>
  </rel:related_item>
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

<xsl:template match="funding-group/award-group/funding-source" mode="fundref">
  <fr:assertion name="fundgroup">
    <!-- TODO: in JATS 1.1d1 the name and ID/DOI may be in a wrapper -->
    <!--
    <xsl:choose>
    <xsl:when test="institution-wrap">
    <xsl:variable name="institution-id" select="institution-wrap/institution-id[@institution-id-type='FundRef']"/>
    <fr:assertion name="funder_name">
    <xsl:value-of select="institution-wrap/institution"/>
  </fr:assertion>
  <xsl:if test="$institution-id">
  <fr:assertion name="funder_identifier">
  <xsl:value-of select="$institution-id"/>
</fr:assertion>
</xsl:if>
</xsl:when>
<xsl:otherwise>
<fr:assertion name="funder_name">
<xsl:value-of select="."/>
</fr:assertion>
</xsl:otherwise>
</xsl:choose>
-->
<fr:assertion name="funder_name">
  <xsl:value-of select="."/>
</fr:assertion>
<xsl:apply-templates select="../award-id" mode="fundref"/>
</fr:assertion>
</xsl:template>

<xsl:template match="award-id" mode="fundref">
  <fr:assertion name="award_number">
    <xsl:value-of select="."/>
  </fr:assertion>
</xsl:template>

<!-- full-text URLs -->
<!-- http://tdmsupport.crossref.org/full-text-uris-technical-details/ -->
<xsl:template name="tdm">
  <collection property="text-mining">
    <item>
      <resource content_version="vor" mime_type="application/pdf">
        <xsl:value-of select="concat($url, '.pdf')"/>
      </resource>
    </item>
    <item>
      <resource content_version="vor" mime_type="application/xml">
        <xsl:value-of select="concat($url, '.xml')"/>
      </resource>
    </item>
    <item>
      <resource content_version="vor" mime_type="text/html">
        <xsl:value-of select="concat($url, '.html')"/>
      </resource>
    </item>
  </collection>
</xsl:template>

<!-- crawler full-text URLs for Similarity Check -->
<!-- https://support.crossref.org/hc/en-us/articles/215774943-Depositing-as-crawled-URLs-for-Similarity-Check -->
<xsl:template name="crawler">
  <collection property="crawler-based">
    <item crawler="iParadigms">
      <resource>
        <xsl:value-of select="concat($url, '.pdf')"/>
      </resource>
    </item>
  </collection>
</xsl:template>
</xsl:stylesheet>
