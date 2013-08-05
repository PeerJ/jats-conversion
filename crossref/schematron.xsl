<?xml version="1.0" standalone="yes"?>
<axsl:stylesheet xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:axsl="http://www.w3.org/1999/XSL/Transform" xmlns:sch="http://www.ascc.net/xml/schematron" xmlns:iso="http://purl.oclc.org/dsdl/schematron" xmlns:cr="http://www.crossref.org/schema/4.3.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" version="2.0" cr:dummy-for-xmlns="" xsi:dummy-for-xmlns="">

<!--PHASES-->


<!--PROLOG-->
<axsl:output xmlns:svrl="http://purl.oclc.org/dsdl/svrl" method="xml" omit-xml-declaration="no" standalone="yes" indent="yes"/>

<!--KEYS-->


<!--DEFAULT RULES-->


<!--MODE: SCHEMATRON-FULL-PATH-->
<axsl:template match="*|@*" mode="schematron-get-full-path"><axsl:apply-templates select="parent::*" mode="schematron-get-full-path"/><axsl:text>/</axsl:text><axsl:choose><axsl:when test="namespace-uri()=''"><axsl:value-of select="name()"/></axsl:when><axsl:otherwise><axsl:text>*:</axsl:text><axsl:value-of select="local-name()"/><axsl:text>[namespace-uri()='</axsl:text><axsl:value-of select="namespace-uri()"/><axsl:text>']</axsl:text></axsl:otherwise></axsl:choose><axsl:variable name="preceding" select="count(preceding-sibling::*[local-name()=local-name(current())                                   and namespace-uri() = namespace-uri(current())])"/><axsl:text>[</axsl:text><axsl:value-of select="1+ $preceding"/><axsl:text>]</axsl:text></axsl:template><axsl:template match="@*" mode="schematron-get-full-path"><axsl:apply-templates select="parent::*" mode="schematron-get-full-path"/>@*[local-name()='schema' and namespace-uri()='http://purl.oclc.org/dsdl/schematron']</axsl:template>

<!--MODE: GENERATE-ID-FROM-PATH -->
<axsl:template match="/" mode="generate-id-from-path"/><axsl:template match="text()" mode="generate-id-from-path"><axsl:apply-templates select="parent::*" mode="generate-id-from-path"/><axsl:value-of select="concat('.text-', 1+count(preceding-sibling::text()), '-')"/></axsl:template><axsl:template match="comment()" mode="generate-id-from-path"><axsl:apply-templates select="parent::*" mode="generate-id-from-path"/><axsl:value-of select="concat('.comment-', 1+count(preceding-sibling::comment()), '-')"/></axsl:template><axsl:template match="processing-instruction()" mode="generate-id-from-path"><axsl:apply-templates select="parent::*" mode="generate-id-from-path"/><axsl:value-of select="concat('.processing-instruction-', 1+count(preceding-sibling::processing-instruction()), '-')"/></axsl:template><axsl:template match="@*" mode="generate-id-from-path"><axsl:apply-templates select="parent::*" mode="generate-id-from-path"/><axsl:value-of select="concat('.@', name())"/></axsl:template><axsl:template match="*" mode="generate-id-from-path" priority="-0.5"><axsl:apply-templates select="parent::*" mode="generate-id-from-path"/><axsl:text>.</axsl:text><axsl:choose><axsl:when test="count(. | ../namespace::*) = count(../namespace::*)"><axsl:value-of select="concat('.namespace::-',1+count(namespace::*),'-')"/></axsl:when><axsl:otherwise><axsl:value-of select="concat('.',name(),'-',1+count(preceding-sibling::*[name()=name(current())]),'-')"/></axsl:otherwise></axsl:choose></axsl:template><!--Strip characters--><axsl:template match="text()" priority="-1"/>

<!--SCHEMA METADATA-->
<axsl:template match="/"><svrl:schematron-output xmlns:svrl="http://purl.oclc.org/dsdl/svrl" title="CrossRef schema v. 4.3.0" schemaVersion="ISO19757-3"><svrl:ns-prefix-in-attribute-values uri="http://www.crossref.org/schema/4.3.0" prefix="cr"/><svrl:ns-prefix-in-attribute-values uri="http://www.w3.org/2001/XMLSchema-instance" prefix="xsi"/><svrl:active-pattern><axsl:apply-templates/></svrl:active-pattern><axsl:apply-templates select="/" mode="M3"/><svrl:active-pattern><axsl:apply-templates/></svrl:active-pattern><axsl:apply-templates select="/" mode="M4"/><svrl:active-pattern><axsl:apply-templates/></svrl:active-pattern><axsl:apply-templates select="/" mode="M5"/><svrl:active-pattern><axsl:apply-templates/></svrl:active-pattern><axsl:apply-templates select="/" mode="M6"/><svrl:active-pattern><axsl:apply-templates/></svrl:active-pattern><axsl:apply-templates select="/" mode="M7"/><svrl:active-pattern><axsl:apply-templates/></svrl:active-pattern><axsl:apply-templates select="/" mode="M8"/><svrl:active-pattern><axsl:apply-templates/></svrl:active-pattern><axsl:apply-templates select="/" mode="M9"/><svrl:active-pattern><axsl:apply-templates/></svrl:active-pattern><axsl:apply-templates select="/" mode="M10"/><svrl:active-pattern><axsl:apply-templates/></svrl:active-pattern><axsl:apply-templates select="/" mode="M11"/></svrl:schematron-output></axsl:template>

<!--SCHEMATRON PATTERNS-->
<svrl:title xmlns:svrl="http://purl.oclc.org/dsdl/svrl">CrossRef schema v. 4.3.0</svrl:title>

<!--PATTERN -->


	<!--RULE -->
<axsl:template match="cr:journal_metadata" priority="4000" mode="M3"><svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="cr:journal_metadata"/>

		<!--REPORT -->
<axsl:if test="."><svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="."><svrl:text>TITLE: <axsl:text/><axsl:value-of select="cr:full_title"/><axsl:text/> <axsl:text/><axsl:value-of select="cr:book_series_metadata/cr:titles/cr:title"/><axsl:text/>, ISSN(s): <axsl:text/><axsl:value-of select="cr:issn"/><axsl:text/></svrl:text></svrl:successful-report></axsl:if><axsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M3"/></axsl:template><axsl:template match="text()" priority="-1" mode="M3"/><axsl:template match="@*|node()" priority="-2" mode="M3"><axsl:apply-templates select="@*|node()" mode="M3"/></axsl:template>

<!--PATTERN -->


	<!--RULE -->
<axsl:template match="cr:pages/cr:first_page" priority="4000" mode="M4"><svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="cr:pages/cr:first_page"/>

		<!--ASSERT -->
<axsl:choose><axsl:when test="not(matches(.,'-'))"/><axsl:otherwise><svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(matches(.,'-'))"><svrl:diagnostic-reference diagnostic="W3a"><svrl:text>
         First Page for DOI: '<axsl:text/><axsl:value-of select="ancestor::cr:journal_article/cr:doi_data/cr:doi"/><axsl:text/>' contains '_'.  Deposit first page only.
      </svrl:text></svrl:diagnostic-reference><svrl:text>INFO: [3a]:'<axsl:text/><axsl:value-of select="ancestor::cr:journal_article/cr:doi_data/cr:doi"/><axsl:text/>'</svrl:text></svrl:failed-assert></axsl:otherwise></axsl:choose><axsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M4"/></axsl:template>

	<!--RULE -->
<axsl:template match="cr:pages/cr:first_page" priority="3999" mode="M4"><svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="cr:pages/cr:first_page"/>

		<!--ASSERT -->
<axsl:choose><axsl:when test="not(matches(.,'_'))"/><axsl:otherwise><svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(matches(.,'_'))"><svrl:diagnostic-reference diagnostic="W2a"><svrl:text>
         First Page for DOI: '<axsl:text/><axsl:value-of select="ancestor::cr:journal_article/cr:doi_data/cr:doi"/><axsl:text/>' contains '-'.  Deposit first page only.
      </svrl:text></svrl:diagnostic-reference><svrl:text>INFO: [2a]:'<axsl:text/><axsl:value-of select="ancestor::cr:journal_article/cr:doi_data/cr:doi"/><axsl:text/>'</svrl:text></svrl:failed-assert></axsl:otherwise></axsl:choose><axsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M4"/></axsl:template><axsl:template match="text()" priority="-1" mode="M4"/><axsl:template match="@*|node()" priority="-2" mode="M4"><axsl:apply-templates select="@*|node()" mode="M4"/></axsl:template>

<!--PATTERN -->


	<!--RULE -->
<axsl:template match="cr:pages/cr:last_page" priority="4000" mode="M5"><svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="cr:pages/cr:last_page"/>

		<!--ASSERT -->
<axsl:choose><axsl:when test="not(matches(.,'-'))"/><axsl:otherwise><svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(matches(.,'-'))"><svrl:diagnostic-reference diagnostic="W3b"><svrl:text>
        Last Page for DOI: '<axsl:text/><axsl:value-of select="ancestor::cr:journal_article/cr:doi_data/cr:doi"/><axsl:text/>' contains _'.  Deposit first page only.
      </svrl:text></svrl:diagnostic-reference><svrl:text>INFO: [3b]:'<axsl:text/><axsl:value-of select="ancestor::cr:journal_article/cr:doi_data/cr:doi"/><axsl:text/>'</svrl:text></svrl:failed-assert></axsl:otherwise></axsl:choose><axsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M5"/></axsl:template>

	<!--RULE -->
<axsl:template match="cr:pages/cr:last_page" priority="3999" mode="M5"><svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="cr:pages/cr:last_page"/>

		<!--ASSERT -->
<axsl:choose><axsl:when test="not(matches(.,'_'))"/><axsl:otherwise><svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(matches(.,'_'))"><svrl:diagnostic-reference diagnostic="W2b"><svrl:text>
        Last Page for DOI: '<axsl:text/><axsl:value-of select="ancestor::cr:journal_article/cr:doi_data/cr:doi"/><axsl:text/>' contains '-'.  Deposit first page only.
      </svrl:text></svrl:diagnostic-reference><svrl:text>INFO: [2b]:'<axsl:text/><axsl:value-of select="ancestor::cr:journal_article/cr:doi_data/cr:doi"/><axsl:text/>'</svrl:text></svrl:failed-assert></axsl:otherwise></axsl:choose><axsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M5"/></axsl:template><axsl:template match="text()" priority="-1" mode="M5"/><axsl:template match="@*|node()" priority="-2" mode="M5"><axsl:apply-templates select="@*|node()" mode="M5"/></axsl:template>

<!--PATTERN -->


	<!--RULE -->
<axsl:template match="cr:edition_number" priority="4000" mode="M6"><svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="cr:edition_number"/>

		<!--ASSERT -->
<axsl:choose><axsl:when test="not(matches(.,'[Nn][Oo]'))"/><axsl:otherwise><svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(matches(.,'[Nn][Oo]'))"><svrl:diagnostic-reference diagnostic="W5"><svrl:text>
        Value for edition is '<axsl:text/><axsl:value-of select="ancestor::cr:journal_issue/cr:issue"/><axsl:text/>'  - text 'edition' 'no' or 'number' should not appear in edition_number element. Deposit edition number only.
</svrl:text></svrl:diagnostic-reference><svrl:text>INFO: [5] issue value = <axsl:text/><axsl:value-of select="ancestor::cr:journal_issue/cr:issue"/><axsl:text/></svrl:text></svrl:failed-assert></axsl:otherwise></axsl:choose>

		<!--ASSERT -->
<axsl:choose><axsl:when test="not(matches(.,'[Nn][Oo]\.'))"/><axsl:otherwise><svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(matches(.,'[Nn][Oo]\.'))"><svrl:diagnostic-reference diagnostic="W5"><svrl:text>
        Value for edition is '<axsl:text/><axsl:value-of select="ancestor::cr:journal_issue/cr:issue"/><axsl:text/>'  - text 'edition' 'no' or 'number' should not appear in edition_number element. Deposit edition number only.
</svrl:text></svrl:diagnostic-reference><svrl:text>INFO: [5] issue value = <axsl:text/><axsl:value-of select="ancestor::cr:journal_issue/cr:issue"/><axsl:text/></svrl:text></svrl:failed-assert></axsl:otherwise></axsl:choose>

		<!--ASSERT -->
<axsl:choose><axsl:when test="not(matches(.,'[Ee][Dd]'))"/><axsl:otherwise><svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(matches(.,'[Ee][Dd]'))"><svrl:diagnostic-reference diagnostic="W5"><svrl:text>
        Value for edition is '<axsl:text/><axsl:value-of select="ancestor::cr:journal_issue/cr:issue"/><axsl:text/>'  - text 'edition' 'no' or 'number' should not appear in edition_number element. Deposit edition number only.
</svrl:text></svrl:diagnostic-reference><svrl:text>INFO: [5] issue value = <axsl:text/><axsl:value-of select="ancestor::cr:journal_issue/cr:issue"/><axsl:text/></svrl:text></svrl:failed-assert></axsl:otherwise></axsl:choose>

		<!--ASSERT -->
<axsl:choose><axsl:when test="not(matches(.,'[Ee][Dd]\.'))"/><axsl:otherwise><svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(matches(.,'[Ee][Dd]\.'))"><svrl:diagnostic-reference diagnostic="W5"><svrl:text>
        Value for edition is '<axsl:text/><axsl:value-of select="ancestor::cr:journal_issue/cr:issue"/><axsl:text/>'  - text 'edition' 'no' or 'number' should not appear in edition_number element. Deposit edition number only.
</svrl:text></svrl:diagnostic-reference><svrl:text>INFO: [5] issue value = <axsl:text/><axsl:value-of select="ancestor::cr:journal_issue/cr:issue"/><axsl:text/></svrl:text></svrl:failed-assert></axsl:otherwise></axsl:choose>

		<!--ASSERT -->
<axsl:choose><axsl:when test="not(matches(.,'[Ee][Dd][Ii][Tt][Ii][Oo][Nn]'))"/><axsl:otherwise><svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(matches(.,'[Ee][Dd][Ii][Tt][Ii][Oo][Nn]'))"><svrl:diagnostic-reference diagnostic="W5"><svrl:text>
        Value for edition is '<axsl:text/><axsl:value-of select="ancestor::cr:journal_issue/cr:issue"/><axsl:text/>'  - text 'edition' 'no' or 'number' should not appear in edition_number element. Deposit edition number only.
</svrl:text></svrl:diagnostic-reference><svrl:text>INFO: [5] issue value = <axsl:text/><axsl:value-of select="ancestor::cr:journal_issue/cr:issue"/><axsl:text/></svrl:text></svrl:failed-assert></axsl:otherwise></axsl:choose>

		<!--ASSERT -->
<axsl:choose><axsl:when test="not(matches(.,'[Nn][Uu][Mm][Bb][Ee][Rr]'))"/><axsl:otherwise><svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(matches(.,'[Nn][Uu][Mm][Bb][Ee][Rr]'))"><svrl:diagnostic-reference diagnostic="W5"><svrl:text>
        Value for edition is '<axsl:text/><axsl:value-of select="ancestor::cr:journal_issue/cr:issue"/><axsl:text/>'  - text 'edition' 'no' or 'number' should not appear in edition_number element. Deposit edition number only.
</svrl:text></svrl:diagnostic-reference><svrl:text>INFO: [5] issue value = <axsl:text/><axsl:value-of select="ancestor::cr:journal_issue/cr:issue"/><axsl:text/></svrl:text></svrl:failed-assert></axsl:otherwise></axsl:choose><axsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M6"/></axsl:template><axsl:template match="text()" priority="-1" mode="M6"/><axsl:template match="@*|node()" priority="-2" mode="M6"><axsl:apply-templates select="@*|node()" mode="M6"/></axsl:template>

<!--PATTERN -->


	<!--RULE -->
<axsl:template match="*[upper-case(cr:surname)]" priority="4000" mode="M7"><svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="*[upper-case(cr:surname)]"/>

		<!--ASSERT -->
<axsl:choose><axsl:when test="true()"/><axsl:otherwise><svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="true()"><svrl:diagnostic-reference diagnostic="W9"><svrl:text>
          Deposited value of surname for DOI '<axsl:text/><axsl:value-of select="ancestor::cr:journal_article/cr:doi_data/cr:doi"/><axsl:text/>' is all upper case: '<axsl:text/><axsl:value-of select="."/><axsl:text/>'. 
</svrl:text></svrl:diagnostic-reference><svrl:text>INFO: [9]:DOI: '<axsl:text/><axsl:value-of select="ancestor::cr:journal_article/cr:doi_data/cr:doi"/><axsl:text/> </svrl:text></svrl:failed-assert></axsl:otherwise></axsl:choose><axsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M7"/></axsl:template>

	<!--RULE -->
<axsl:template match="cr:contributors" priority="3999" mode="M7"><svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="cr:contributors"/>

		<!--ASSERT -->
<axsl:choose><axsl:when test="count(cr:person_name) &gt;= 1"/><axsl:otherwise><svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="count(cr:person_name) &gt;= 1"><svrl:diagnostic-reference diagnostic="W10"><svrl:text>
          Only single contributor is present for DOI '<axsl:text/><axsl:value-of select="ancestor::cr:journal_article/cr:doi_data/cr:doi"/><axsl:text/>'. Deposit all authors.
      </svrl:text></svrl:diagnostic-reference><svrl:text>INFO: [10]:'<axsl:text/><axsl:value-of select="ancestor::cr:journal_article/cr:doi_data/cr:doi"/><axsl:text/>'.</svrl:text></svrl:failed-assert></axsl:otherwise></axsl:choose><axsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M7"/></axsl:template>

	<!--RULE -->
<axsl:template match="cr:given_name" priority="3998" mode="M7"><svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="cr:given_name"/>

		<!--ASSERT -->
<axsl:choose><axsl:when test="string-length(.) &gt; 1"/><axsl:otherwise><svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="string-length(.) &gt; 1"><svrl:diagnostic-reference diagnostic="W11"><svrl:text>
          INFO: Deposited value of given_name for DOI '<axsl:text/><axsl:value-of select="ancestor::cr:journal_article/cr:doi_data/cr:doi"/><axsl:text/>' is '<axsl:text/><axsl:value-of select="."/><axsl:text/>'. Deposit full names.</svrl:text></svrl:diagnostic-reference><svrl:text>INFO: [11]: DOI: '<axsl:text/><axsl:value-of select="ancestor::cr:journal_article/cr:doi_data/cr:doi"/><axsl:text/>'</svrl:text></svrl:failed-assert></axsl:otherwise></axsl:choose><axsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M7"/></axsl:template>

	<!--RULE -->
<axsl:template match="cr:surname" priority="3997" mode="M7"><svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="cr:surname"/>

		<!--ASSERT -->
<axsl:choose><axsl:when test="not(matches(., '[Jj][Rr]\.'))"/><axsl:otherwise><svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(matches(., '[Jj][Rr]\.'))"><svrl:diagnostic-reference diagnostic="W12"><svrl:text>
         Surname '<axsl:text/><axsl:value-of select="."/><axsl:text/>' contains 'Jr.' DOI: '<axsl:text/><axsl:value-of select="ancestor::cr:journal_article/cr:doi_data/cr:doi"/><axsl:text/>'
         </svrl:text></svrl:diagnostic-reference><svrl:text>INFO: [12] :DOI: '<axsl:text/><axsl:value-of select="ancestor::cr:journal_article/cr:doi_data/cr:doi"/><axsl:text/>'</svrl:text></svrl:failed-assert></axsl:otherwise></axsl:choose><axsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M7"/></axsl:template><axsl:template match="text()" priority="-1" mode="M7"/><axsl:template match="@*|node()" priority="-2" mode="M7"><axsl:apply-templates select="@*|node()" mode="M7"/></axsl:template>

<!--PATTERN -->


	<!--RULE -->
<axsl:template match="cr:journal_issue/cr:issue" priority="4000" mode="M8"><svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="cr:journal_issue/cr:issue"/>

		<!--ASSERT -->
<axsl:choose><axsl:when test="not(matches(.,'[Nn][Oo]'))"/><axsl:otherwise><svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(matches(.,'[Nn][Oo]'))"><svrl:diagnostic-reference diagnostic="W13"><svrl:text>
        Value for issue is '<axsl:text/><axsl:value-of select="ancestor::cr:journal_issue/cr:issue"/><axsl:text/>'  - text 'issue' should not appear in issue element. Deposit issue number only.
</svrl:text></svrl:diagnostic-reference><svrl:text>INFO: [13] issue value = <axsl:text/><axsl:value-of select="ancestor::cr:journal_issue/cr:issue"/><axsl:text/></svrl:text></svrl:failed-assert></axsl:otherwise></axsl:choose>

		<!--ASSERT -->
<axsl:choose><axsl:when test="not(matches(.,'[Nn][Oo]\.'))"/><axsl:otherwise><svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(matches(.,'[Nn][Oo]\.'))"><svrl:diagnostic-reference diagnostic="W13"><svrl:text>
        Value for issue is '<axsl:text/><axsl:value-of select="ancestor::cr:journal_issue/cr:issue"/><axsl:text/>'  - text 'issue' should not appear in issue element. Deposit issue number only.
</svrl:text></svrl:diagnostic-reference><svrl:text>INFO: [13] issue value = <axsl:text/><axsl:value-of select="ancestor::cr:journal_issue/cr:issue"/><axsl:text/></svrl:text></svrl:failed-assert></axsl:otherwise></axsl:choose>

		<!--ASSERT -->
<axsl:choose><axsl:when test="not(matches(.,'[Ii][Ss][Ss][Uu][Ee]\.'))"/><axsl:otherwise><svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(matches(.,'[Ii][Ss][Ss][Uu][Ee]\.'))"><svrl:diagnostic-reference diagnostic="W13"><svrl:text>
        Value for issue is '<axsl:text/><axsl:value-of select="ancestor::cr:journal_issue/cr:issue"/><axsl:text/>'  - text 'issue' should not appear in issue element. Deposit issue number only.
</svrl:text></svrl:diagnostic-reference><svrl:text>INFO: [13] issue value = <axsl:text/><axsl:value-of select="ancestor::cr:journal_issue/cr:issue"/><axsl:text/></svrl:text></svrl:failed-assert></axsl:otherwise></axsl:choose>

		<!--ASSERT -->
<axsl:choose><axsl:when test="not(matches(.,'[Ii][Ss][Ss][Uu][Ee]'))"/><axsl:otherwise><svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(matches(.,'[Ii][Ss][Ss][Uu][Ee]'))"><svrl:diagnostic-reference diagnostic="W13"><svrl:text>
        Value for issue is '<axsl:text/><axsl:value-of select="ancestor::cr:journal_issue/cr:issue"/><axsl:text/>'  - text 'issue' should not appear in issue element. Deposit issue number only.
</svrl:text></svrl:diagnostic-reference><svrl:text>INFO: [13] issue value = <axsl:text/><axsl:value-of select="ancestor::cr:journal_issue/cr:issue"/><axsl:text/></svrl:text></svrl:failed-assert></axsl:otherwise></axsl:choose>

		<!--ASSERT -->
<axsl:choose><axsl:when test="not(matches(.,'[Nn][Uu][Mm][Bb][Ee][Rr]\.'))"/><axsl:otherwise><svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(matches(.,'[Nn][Uu][Mm][Bb][Ee][Rr]\.'))"><svrl:diagnostic-reference diagnostic="W13"><svrl:text>
        Value for issue is '<axsl:text/><axsl:value-of select="ancestor::cr:journal_issue/cr:issue"/><axsl:text/>'  - text 'issue' should not appear in issue element. Deposit issue number only.
</svrl:text></svrl:diagnostic-reference><svrl:text>INFO: [13] issue value = <axsl:text/><axsl:value-of select="ancestor::cr:journal_issue/cr:issue"/><axsl:text/></svrl:text></svrl:failed-assert></axsl:otherwise></axsl:choose>

		<!--ASSERT -->
<axsl:choose><axsl:when test="not(matches(.,'[Nn][Uu][Mm][Bb][Ee][Rr]'))"/><axsl:otherwise><svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(matches(.,'[Nn][Uu][Mm][Bb][Ee][Rr]'))"><svrl:diagnostic-reference diagnostic="W13"><svrl:text>
        Value for issue is '<axsl:text/><axsl:value-of select="ancestor::cr:journal_issue/cr:issue"/><axsl:text/>'  - text 'issue' should not appear in issue element. Deposit issue number only.
</svrl:text></svrl:diagnostic-reference><svrl:text>INFO: [13] issue value = <axsl:text/><axsl:value-of select="ancestor::cr:journal_issue/cr:issue"/><axsl:text/></svrl:text></svrl:failed-assert></axsl:otherwise></axsl:choose><axsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M8"/></axsl:template><axsl:template match="text()" priority="-1" mode="M8"/><axsl:template match="@*|node()" priority="-2" mode="M8"><axsl:apply-templates select="@*|node()" mode="M8"/></axsl:template>

<!--PATTERN -->


	<!--RULE -->
<axsl:template match="cr:journal_article/cr:titles" priority="4000" mode="M9"><svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="cr:journal_article/cr:titles"/>

		<!--REPORT -->
<axsl:if test="not(matches(.,' '))"><svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(matches(.,' '))"><svrl:diagnostic-reference diagnostic="W14"><svrl:text>
        Value for article title is '<axsl:text/><axsl:value-of select="ancestor::cr:journal_article/cr:titles/cr:title"/><axsl:text/>' This is a single word title.
</svrl:text></svrl:diagnostic-reference><svrl:text>INFO: [14]:'<axsl:text/><axsl:value-of select="ancestor::cr:journal_article/cr:doi_data/cr:doi"/><axsl:text/>'</svrl:text></svrl:successful-report></axsl:if><axsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M9"/></axsl:template><axsl:template match="text()" priority="-1" mode="M9"/><axsl:template match="@*|node()" priority="-2" mode="M9"><axsl:apply-templates select="@*|node()" mode="M9"/></axsl:template>

<!--PATTERN -->


	<!--RULE -->
<axsl:template match="cr:doi" priority="4000" mode="M10"><svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="cr:doi"/>

		<!--ASSERT -->
<axsl:choose><axsl:when test="translate(.,'./():0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ_abcdefghijklmnopqrstuvwxyz-1234567890','') = ''"/><axsl:otherwise><svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="translate(.,'./():0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ_abcdefghijklmnopqrstuvwxyz-1234567890','') = ''"><svrl:diagnostic-reference diagnostic="A1"><svrl:text>
         DOI <axsl:text/><axsl:value-of select="."/><axsl:text/> contains a character not in the allowed DOI character set.
         </svrl:text></svrl:diagnostic-reference><svrl:text>INFO: [A1]<axsl:text/><axsl:value-of select="."/><axsl:text/></svrl:text></svrl:failed-assert></axsl:otherwise></axsl:choose><axsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M10"/></axsl:template><axsl:template match="text()" priority="-1" mode="M10"/><axsl:template match="@*|node()" priority="-2" mode="M10"><axsl:apply-templates select="@*|node()" mode="M10"/></axsl:template>

<!--PATTERN -->


	<!--RULE -->
<axsl:template match="cr:given_name" priority="4000" mode="M11"><svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="cr:given_name"/>

		<!--ASSERT -->
<axsl:choose><axsl:when test="translate(.,'. ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz','') = ''"/><axsl:otherwise><svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="translate(.,'. ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz','') = ''"><svrl:diagnostic-reference diagnostic="A2g"><svrl:text>
          Deposited value of surname or given name for DOI '<axsl:text/><axsl:value-of select="ancestor::cr:journal_article/cr:doi_data/cr:doi"/><axsl:text/>' is: '<axsl:text/><axsl:value-of select="."/><axsl:text/>'. Names with numbers or punctuation will be rejected.
</svrl:text></svrl:diagnostic-reference><svrl:text>INFO: [A2]: DOI: '<axsl:text/><axsl:value-of select="ancestor::cr:journal_article/cr:doi_data/cr:doi"/><axsl:text/>'</svrl:text></svrl:failed-assert></axsl:otherwise></axsl:choose><axsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M11"/></axsl:template>

	<!--RULE -->
<axsl:template match="cr:surname" priority="3999" mode="M11"><svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="cr:surname"/>

		<!--ASSERT -->
<axsl:choose><axsl:when test="translate(.,'. ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz','') = ''"/><axsl:otherwise><svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="translate(.,'. ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz','') = ''"><svrl:diagnostic-reference diagnostic="A2s"><svrl:text>
          Deposited value of surname or given name for DOI '<axsl:text/><axsl:value-of select="ancestor::cr:journal_article/cr:doi_data/cr:doi"/><axsl:text/>' is: '<axsl:text/><axsl:value-of select="."/><axsl:text/>'. Names with numbers or punctuation will be rejected.
</svrl:text></svrl:diagnostic-reference><svrl:text>INFO: [A2] :DOI: '<axsl:text/><axsl:value-of select="ancestor::cr:journal_article/cr:doi_data/cr:doi"/><axsl:text/>'</svrl:text></svrl:failed-assert></axsl:otherwise></axsl:choose><axsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M11"/></axsl:template><axsl:template match="text()" priority="-1" mode="M11"/><axsl:template match="@*|node()" priority="-2" mode="M11"><axsl:apply-templates select="@*|node()" mode="M11"/></axsl:template></axsl:stylesheet>
