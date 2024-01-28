<?xml version="1.0" encoding="utf-8"?> 
<!--
===========================================================================
 
                            PUBLIC DOMAIN NOTICE
               National Center for Biotechnology Information
 
  This software is a "United States Government Work" under the
  terms of the United States Copyright Act.  It was written as part of
  the author's official duties as a United States Government employee and
  thus cannot be copyrighted.  This software is freely available
  to the public for use.  The National Library of Medicine and the U.S.
  Government have not placed any restriction on its use or reproduction.
 
  Although all reasonable efforts have been taken to ensure the accuracy
  and reliability of the software and data, the NLM and the U.S.
  Government do not and cannot warrant the performance or results that
  may be obtained by using this software or data.  The NLM and the U.S.
  Government disclaim all warranties, express or implied, including
  warranties of performance, merchantability or fitness for any particular
  purpose.
 
  Please cite NCBI in any work or product based on this material.
 
 ===========================================================================
 -->
<!-- ************************************************************************ -->
<!--                                     NLM STYLECHECKER
                                           Version 5.39
    
    Stylesheet tests an XML instance to determine whether it conforms to correct
    PMC style as defined in the Tagging Guidelines located at:
    
     For Journal Articles:
      https://www.ncbi.nlm.nih.gov/pmc/pmcdoc/tagging-guidelines/article/style.html
     
     For Manuscripts:
      https://www.ncbi.nlm.nih.gov/pmc/pmcdoc/tagging-guidelines/manuscript/style.html
        
    For Books
      https://www.ncbi.nlm.nih.gov/pmc/pmcdoc/tagging-guidelines/book/style.html
     
    Output from this stylesheet will have the following structure:
      -<ERR> will be the root element
      -Content of ERR will be a copy of the input XML
      -Original DOCTYPE from input XML will be removed
      -<error> elements will be inserted near the point of any style errors that
       must be corrected
      -<warning> elements will be inserted near any content that looks
       suspicious; the tagging should be checked, but does not need
       to be changed to conform to PMC style
      -<error> and <warning> taggs will contain the name of the style test
        followed by a description of the error or warning
      
     The output can be run against style-reporter.xsl to make an HTML report.
     
     
     There are two Stylesheet-level parameters that may be passed into the
        stylechecker:
         
         style - this parameter describes the style that you wish to test
                 your file against. If no style parameter is declared. the 
                 stylechecker will use 'article'. Currently, the values are:
                    
                    manuscript - for nihms manuscript style
                    book - for book content in PMC
                    article - for published articles (this is the default)
                    
        editstyle - this is a parameter that is available to identify 
                 	  content that has been created with a MS Word XML authoring
                    program using Word Styles here at NCBI. Currently only the
                    value 'word' is recognized, and it is only being applied
                    to $style='book' content.
                    
     
     
     
   PMC Project Revision notes:

   November 13, 2023
        Cut release branch for Version 5.39.
        Public release of 4th quarter changes will occur on December 12, 2023.

   October 13, 2023
        Added new test to href-content-check to disallow xlink:href (on ext-link) that
        start with the # character.

   October 10, 2023
        Updated third test in list-continued-check to run only when @id is non-empty.

   September 25, 2023
        Updated col, colgroup, th, and td handlers in stylecheck-match-templates.xsl
        to call table-span-check only when @span, @colspan, or @rowspan are present.
        Commented out check-prohibited-math-characters-outside-math-context in
        stylecheck-helper-templates.xsl.

   September 12, 2023: Version 5.38
        Public release of 3rd quarter changes.

   August 10, 2023
        Cut release branch for Version 5.38.
        Public release of 3rd quarter changes will occur on September 12, 2023.

   July 30, 2023
        Added new condition to name-content-check to disallow surname if name[@name-style="given-only"].

   June 28, 2023
        Added @related-article-type="author-comment" to related-article-to-article-type-attribute.

   June 16, 2023
        Removed SwissProt from article-documented-elt-values.

   June 13, 2023: Version 5.37
        Public release of 2nd quarter changes.

   June 1, 2023
        Added new check for name parts tagged as punctuation only.

   May 16, 2023
         Cut release branch for Version 5.37.
         Public release of 2nd quarter changes will occur on June 13, 2023.

   April 24, 2023
         Removed "QandA" from set of allowed @list-type values.

   April 11, 2023
         Updated pub-date-conflict-check to look for @date-type="collection"
         and @publication-format="electronic".
         Removed "collection" from list of allowed values in publication-format-check.

   March 31, 2023
         Added "mult-values" param to call to mml-attr-value-check for mathml 
         attributes @display, @mathvariant, and @equalrows.

   March 29, 2023
         Added new test copyright-statement-check_v2 that makes the presence of
         license info in <copyright-statement> an error if no <license> exists.

   March 13, 2023
         Updated journal-meta-issn-check to allow @publication-format on issn.
         Added new test issn-publication-format-check to ensure that the value
         of @publication-format is 'print' or 'electronic'.

   March 7, 2023: Version 5.36
         Public release of 1st quarter changes

   March 1, 2023
         Added new test disp-formula-content-test 

   February 7, 2023
         Cut release branch for Version 5.36
         Public release of 1st quarter changes will occur on March 7, 2023

   December 20, 2022
         Added new PI value 'gatesmanu' to manuscript-pi-test

   December 9, 2022: Version 5.35
         Public release of 4th quarter changes

   November 30, 2022
         In pub-date-content-check, added check that @date-type and
         @publication-format coexist

   November 17, 2022
         Added new test issue-id-check-issue-exists

   November 9, 2022
         Cut release branch for Version 5.35
         Public release of 4th quarter changes will occur on December 9, 2022

   October 27, 2022
         Removed PACTR from article-documented-elt-values

   October 6, 2022
         Added new tests volume-count-check and issue-count-check, and called them from
         article-meta and front-stub

   September 22, 2022
         Added new test book-abstract-length-test

   September 21, 2022
         Removed unused @ext-link-type values from variable 'article-supported-elt-values'
  
   September 20, 2022
         Allowed the ext-link-type = 'ccdc' (Cambridge Crystallographic Data Centre)

   September 9, 2022: Version 5.34
         Public release of 3rd quarter changes

   August 5, 2022
         Cut release branch for Version 5.34
         Public release of 3rd quarter changes: September 9, 2022

   July 28, 2022
         Updated formula-content-test to look at all text() nodes, not just
         the first

   June 9, 2022: Version 5.33
         Public release of 2nd quarter changes
   
   May 17, 2022
         Removed set of undocumented ext-link types 

   May 13, 2022
         Added new test disp-level-check

   May 11, 2022
         Added @ext-link-type values pombase, flybase, wormbase, mirbase, rfam,
         pfam, prosite, and swiss-model

   May 9, 2022
         Cut release branch for Version 5.33
         Public release of 2nd quarter changes: June 9, 2022

   May 4, 2022
         Adjusted ms-footnote-license-check to issue a warning in all cases

   April 26, 2022
         Added support for @article-type and @related-article-type values that can
         appear in peer-review content

   February 10, 2022 Version 5.32
	 Public release of 1st quarter changes 

   January 31, 2022
         In check for duplicate @specific-use, allow duplicates if elements are
         differentiated by @xml:lang
   
   January 24, 2022
         Allowed for empty role if a @content-type containing a CRediT URL is present.   

   November 29, 2021
         Disallowed empty ali:license_ref

   October 28, 2021
         In @ext-link-type check, separated allowed and supported values in books
         and allowed and supported values in articles into four lists to allow for
         better detail in errors

   October 26, 2021
         Adjusted first test in ms-footnote-license-check to avoid issuing an error
         for casual mentions of Creative Commons licenses

   October 25, 2021 Version 5.31
         Public release of 4th quarter changes

   September 1, 2021
         Added @custom-type check to article-id, fn, person-group, pub-id, and xref 
						
   July 27, 2021 Version 5.30
						Public release of 3rd quarter changes

   June 4, 2021
         Disallowed more than one article-id with certain @pub-id-type values

   April 29, 2021 Version 5.30
				 		Public release of 2nd quarter changes
    
   April 29, 2021
         Disallowed more than one ali:license_ref with a Creative Commons URL per license
         
    April 9, 2021
         Added test to check that ali:license_ref and ext-link in license match
         Required canonical Creative Common URLs in licenses
   
   April 6, 2021
         Removed the requirement that link text and URL must match for external links in licenses
         
  January 26, 2021
         Disallowed XLink namespace URIs other than http://www.w3.org/1999/xlink
	     
   December 11, 2020
          PMC-44617: For element pub-id, added pmid-check to make sure PMIDs do not contain letters and
	     do not start with a zero

   December 7, 2020
          MS-4151: Allow doi in related-article links and republications as corrections for manuscripts
   
   November 30, 2020
          Allowed ack in body for books
          
   November 10, 2020
          Fix rules for maligngroup
          
   November 5, 2020
          Updated rules for maligngroup to allow for implied mrow in mtd with multiple children
          
   August 24, 2020
            Updated error message in license-integrity-check to mirror message in 
               license-ext-link-content-check

   August 17, 2020
            Updated error message in license-ext-link-content-check
            
   August 11, 2020: Version 5.27
            Public release of 3rd quarter changes
   
   July 2, 2020
            Added check for '10..' in DOI value   
   
   June 29, 2020
            xref should have @ref-type value   
   
   June 15, 2020: Version 5.26
            Public release of 2nd quarter changes
   
   June 5, 2020:
            Disallowed the continued-from attribute on a list to point to an element that is not list
            Disallowed circular references in continued-from attributes on lists
            
   May 21, 2020:
            Add parent and ancestor tests for maligngroup element
   
   April 30, 2020:
            Allowed the related-article types 'preprint' and 'published-article'
  
   April 7, 2020:
            Disallowed empty fpage, lpage, and elocation-id elements
            
   March 31, 2020:
            Allowed article-type 'chapter-article'
            Updated sub-article check to allow correction, retraction, expression-of-concern when
              sub-article is in a different language than the parent article
            Allowed any value for season if an @iso-8601-date is present

   March 23, 2020:
            Expanded media in alternatives check to include inline-media, graphic, and inline-graphic.
            Removed unused test in alternatives-content-check.
            
   March 11, 2020:
            Media in alternatives can point to external site iff there is another media specifying a local file

   March 6, 2020:
            Allowed xrefs with ref-type=supplementary-material to point to inline-supplementary-material
	      
   February 25, 2020:
            Disallowed non-numeric values in the colspan, rowspan, and span table attributes
             
   February 11, 2020: Version 5.25
		     Public release of 1st quarter changes   
   
   November 22, 2019:
             Added warning for multiple tbody elements in books tables

   November 13, 2019:
             Disallowed multiple child math elements in alternatives

   November 12, 2019: Version 5.24
	         Public release of 4th quarter changes   
  
   October 15, 2019:
              Disallowed continued-from attributes referencing the parent list
	       

   September 25, 2019:
              Added EBI:emdb and sasbdb to the list of allowed ext-link-type values
	      
   August 20, 2019:
              Refined article-type-to-related-article-check to produce an error for a correction/retraction without a proper @related-article-type 

   August 16, 2019:
              Check for presence of xlink:href in inline-supplementary-material

   August 13, 2019: Version 5.23
              Public release of 3rd quarter changes

   July 1, 2019:
              Added Xpath context to the following checks:
                  day-check
                  formula-content-test
                  href-content-check
                  href-ext-check
                  license-ext-link-content-check
                  month-check
                  xref-check

   June 5, 2019:
              Added error type 'related-article letter reply check' for related-article-self-test warnings 

   May 28, 2019:
              Allowed xrefs with ref-type=sec to point to (BITS) question and answer elements

   May 20, 2019: Version 5.22.1
              Fixed link generation in HTML style report  
        	
   May 15, 2019: Version 5.22
              Public release of 2nd quarter changes   
        	
   March 7, 2019:
              Updated license integrity check to recognize license URI in ali:license_ref
   
   February 25, 2019:
              Added values retraction-republication and retracted-republished-article to allowed @related-article-type values 
              Added retracted-republished-article to the existing related-article-to-artucle-type test; article-type must be retraction
              
    February 12, 2019: Version 5.21
              Public release of 1st quarter changes   
        	
    January 2, 2019:
              Applied alternatives content check when parent is bio   
        	
    December 10, 2018:
              Added values reprint and reprinted-article to allowed @related-article-type values   
        	
    November 13, 2018: Version 5.20
              Public release of 4th quarter changes
    
    October 29, 2018:
              Required xrefs with ref-type=aff in books to point to an aff element within the same sec-meta, book-part-meta, book-meta, or collection-meta as the xref itself.
              Required @id on various elements 
              
    September 25, 2018:
              Expanded href file extension string limit from 10 to 15
    
    August 14, 2018: Version 5.19
              Public release of 3rd quarter changes
    
    July 16, 2018:
             Expanded list of documented ext-link-type values

    July 9, 2018:
             Removed contrib-author-notes-test
             Removed deceased and equal-contrib tests from content-attribute-checking

    June 11, 2018:
             Required book-part-id and book-id to not be empty
             Required book-part-id-type on book-part-id and book-id-type on book-id
	     Required DOI syntax for book-id and book-part-id marked as 'doi'
	     
    May 9, 2018: Version 5.18
              Public release of 2nd quarter changes
    
    April 9, 2018:
             Modified contrib-content-test to produce an error when a contrib contains both name and name-alternatives
	
    April 9, 2018:
             Applied article-type-content-check to responses and sub-articles 
	
    March 15, 2018:
             Updated related-article-check error message for missing attributes 
	
    February 21, 2018:
             Required title and ID on every main chunk of a book
             Required book-title and publisher in book-meta 
	
    February 13, 2018: Version 5.17
              Public release of 1st quarter changes
    
    January 23, 2018
              Added "update" as an approved pub-date @date-type
    
    December 21, 2017
              Dropped empty-element-check from string-date when not a child of a date element
    
    December 1, 2017
              Modified article-type-to-related-article-check to produce an error when a correction or retraction contains no related-article element 
    
    November 14, 2017: Version 5.16
              Public release of 4th quarter changes
    
    November 13, 2017
              Updated names for a few tests: "contrib attributes check" to "equal contrib attributes check"; "date check" to "electronic date check"; "date check" to "rrn date check"; "date check" to "book date check"; "date check" to "article date check"; "license check" to "cc no uri license check"
	      
    August 15, 2017
              Updated test for @xml:lang on trans-title so that the trans-title/@xml:lang
              could be the same as the /article/@xml:lang IF the article-title was different
              from /article/@xml:lang
   
    August 10, 2017: Version 5.15
              Public release of 3rd quarter changes
    
    June 1, 2017
              Added bio as an approved parent of alternatives.
              
              Modified href extension check to permit extensions containing an underscore.
              
    May 9, 2017: Version 5.14
              Public release of 2nd quarter changes
              
    March 30, 2017
              Expanded formula-content-test to report inline-formula within disp-formula, and vice versa. 
   
    February 27, 2017
    	PMC-29933 - Remove collab-contrib-grp-check because we have content 
		that has contrib-group associated with a collab that has 
		collab members. pmcdata/frontiers/frontpediatrics/5-2017/noissue/00018/
		
    February 14, 2017: Version 5.13
              Public release of 1st quarter changes
              
    January 31, 2017
   	Added copyright license check: copyright-statement must not contain license information
   	
   	Added warning for Creative Commons license statements with no license URI.
   
    December 21, 2016
              Apply history-date-type-attribute-check only to dates within history
   
    November 14, 2016:
              Updates for NLM Biomedical Journal Digitization: history-date-type-attribute-check

    November 8, 2016: Version 5.12
              Public release of 4th quarter changes
              
    September 28, 2016
              pub-date must contain no more than one month element
    
    September 21, 2016
              Expression of concern without related-article is reclassified from warning to error
    
    September 6, 2016
              Allow anonymous in contrib
    
    August 9, 2016: Version 5.11
              Public release of 3rd quarter changes
              
    July 14, 2016
              Updates for NLM Biomedical Journal Digitization:
                 Project-specific @article-type values, history-date-type-attribute-check,
                 pub-id-type-value, and pagination rule
   
    July 10, 2016
              Recognize Unicode em-space as plain-text math.   		
   
    February 17, 2016
              Allow @article-type="expression-of-concern" and @related-article-type
                   of "object-of-concern" for manuscripts.
					
    February 9, 2016: Version 5.10
              Public release of 1st quarter changes
	
    January 4, 2016:
              Allow consecutive mml:mn when they have different @mathvariant
                   values. 
                   <mml:mn>1</mml:mn><mml:mn mathvariant="bold">8</mml:mn> is ok
                   <mml:mn>1</mml:mn><mml:mn>8</mml:mn> is not ok
	 
    August 3, 2015: Version 5.9
              Public release of 3rd quarter changes  

    July 30, 2015:
              In contrib-id-check, ORCID check allows all-cap or lower-case
   
    July 27, 2015:
              Added related-article-type value 'data-paper'     
    
    July 13, 2015:
              Added string-name-content-check: string-name must not have
                   more than 1 surname or given-names element
              inline-formula and disp-formula must have descendant
                   inline-formula or disp-formula, respectively
   
    July 9, 2015:
              New test correction-content-check: correction content must be
                   in body, not abstract
              New test collection-content-check: collection articles must have
                   more than 1 sub-article|response                      
   
    March 18, 2015:
              Modified related-article-self-test; alt-language related-articles 
                   generate warnings, not errors
   
    February 9, 2015: Version 5.8
                      Public release of 1st quarter changes  
   
    January 12, 2015:
                      Added check for related-articles pointing to the containing article.
   
    November 19, 2014:
                      Increased allowable $substr-after-last-dot in named template
                        href-ext-check to 10; received file type 'sas7bdat'

    November 13, 2014: Version 5.7
                      Public release of 4th quarter changes
   
    September 5, 2014:
    				Added related-article-type values "continues" and "continued-by". 
    
    August 12, 2014: Version 5.6
    				Public release of 3rd quarter changes
   
    July 8, 2014: 
    				Added checking for Extended Data sections in the manuscript stream.
    				  - any manuscript with a figure or table whose label contains "Extended Data"
    				    or with an <xref> that contains "Extended Data" must have a first level 
    				    section at the end of the <body> (but before any Supplementary Material 
    				    section) that has @sec-type="extended-data" and <title>Extended Data</title>.
    				  - this section must contain at least one figure or table
	 
    July 1, 2014:   
    				Added check in contrib-id that ORCID values must start with 
    				  http://orcid.org or orcid.org

    May 20, 2014:
    				In template=mathml-repeated-element-check, allow repeating elements
    				  if parent::mml:mfenced[@separators]
    				
    May 7, 2014:
    				Added 'online' as alllowed @date-type value in history/date
    
    May 6, 2014:
    				Added 'sc' (Silverchair) to allowed journal-id-type values
    				
    April 14, 2014:
    				Updated stylechecker-version to 5.5
    				Added aff-xref-check
    				Added pub-date-conflict-check
    				Added 'collection' to allowed values in publication-format-check
    				
    March 21, 2014:
    				Added param pub-id-type-values to use in both named templates
    				 pub-id-check and pub-id-type-check to keep consistent values. 
   
    March 11, 2014:
    				Modified subj-group checks; at least one subj-group with
    				  subj-group-type="heading" or "part" or no subj-group-type
    				  must exist.
   
    February 10, 2014: Version 5.4
                        Public release of 1st quarter changes
   
    January 21, 2014:
    				Expanded xref-check to allow element [target] withing existing
    				  allowed structures to be a valid match
   
    December 23, 2013:
                     subj-group[@subj-group-type="heading"] cannot have a 
                       subject with only an <inline-graphic>
   
    December 3, 2013:
                    Added explicit test for @xml:lang on all trans-* elements

    December 2, 2013:
                    Add newer pub-date attributes specifying electronic collection to 
                      dup-pub-date-check
                      pub-date-check
                      pub-type-check
                      date-type-check
   
    November 25, 2013:
                    Modified license-ext-link-content-check to exclude strings that are
                    	likely sentences containing URIs.
   
    November 8, 2013: Version 5.3
                    Public release of 4th quarter changes
		
	October 31, 2013:
	 			Allowed <target> to be empty - to act as a milestone.
	
    September 25, 2013:
    			Added allowed values to ext-link-type:
    				bmrb, EBI:arrayexpress, ERI:ena, geneweaver:geneset
    			Allowed Winter-Spring as a range for <season>
    			In license//ext-link checking, do not allow multiple creativecommons.org/licenses
    				URI values in a single license
    
    September 4, 2013:
                   Allow related-object in lieu of related-article; related-object 
                   	now included in:
	                  article-type-to-related-article-check
	                  related-article-to-article-type-check
   
    August 16, 2013:
                   added "arxiv" as allowed value in template pub-id-type 
   
    August 12, 2013: Version 5.2
                    Public release of 3rd quarter changes                    
    July 16, 2013: 
                    Unescaped spaces will cause malformed DOI error    
    July 1, 2013:
                   Warn if count(abstract/sec)=1 and count(abstract/sec/sec) > 1
                   Warn if kwd-group has only 1 <kwd> which contains punctuation                    
    May 28, 2013: 
                    Empty element check on issue
                    Normalize space in math fence checks
                    
    May 10, 2013: Version 5.1
                    Public release of changes from 4/3/13, 3/1/13
    April 3, 2013: 
                    Added collection pub-type to dup-pub-date-check
    March 1, 2013: 
	               Added 'referee-report' to allowed related-article-type values
	               Removed abstract title test
   
   	January 15, 2013: Version 5.0
   					xref-type="list" may point to def element ("def" not allowed in Blue)
   					alternatives allowed in td, th
   					Allow single characters tagged as math
   					Enforce license integrity rules
   					tex-math must not include non-TeX entities
   					tex-math must include \begin{document} and \end{document}
   					collab must have content other than contrib-group
   					contrib-group//collab must not contain contrib-group
   					Formulas (disp or inline) must not have >1 mml:math, tex-math 
   						unless wrapped in alternatives
   					Updates for JATS 1.0:
	   					pub-date rules expanded to include new attributes:
	   						pub-date checks accommodate date-type + publication-format
	   						pub-date/@date-type must be recognized value
	   						pub-date/@publication-format must be print, electronic, or electronic-print
	   					compound-subject is not allowed in subj-group[@subj-group-type="heading"]
	   					contrib-id not allowed in contrib[collab]
	   					contrib must not have > 1 name, use name-alternatives
	   					In aff-, citation-, collab-, name-alternatives	   						
	   						children should specify either @xml:lang or @specific-use
	   						if children specify @xml:lang, exactly 1 must have same value as /article/@xml:lang
	   							including inherited values
	   						if children specify @specific-use, all must include it
	   						values of @xml:lang and @specific-use should be unique
	   						Variations:
	   						- in citation-alternatives, rules apply when > 1 of a given element 
	   							(element- or mixed-citation), not across all elements
	   						- in name-alternatives, name[@content-type="index"] is not included	   						
	   					If name has given-names only, @name-style must be specified
   
	April 6, 2011 - updated ext-link-type value testing for values documented in PMC Tagging
							 Guidelines. 

    	January 11, 2011: We no longer allow sec-type display-objects for version 3 manuscripts. Floating objects
                      must be contained in a floats-group
                      
   	August 25, 2010: Version 4.2.2
   					Allowed disp-formula-group as target of xref/@ref-type="disp-formula" and "chem"
   
     April 28, 2010: Version 4.2.0
     					When a pub-date has @pub-type="collection", the required pub-date @pub-type="epub" 
     						must have both day and month
     					Related article elements with @ext-link-type="pmc" must have either @vol and @page 
     						OR @vol and @elocation-id
     					Related article elements with @ext-link-type="pmc" should not have @xlink:href 
     						unless @xlink:href value is a PMCID
     					Manuscripts with @article-type="correction" may have subject "Correction" or "Errata"
     					Manuscripts with @article-type="retraction" may have subject "Retraction"
     					Manuscripts with @article-type="correction" or "retraction" must have related-article 
     
     June 23, 2009: Version 4.0.6
	 					Citation exceptions expanded to include new mixed- and element-citation						
						
	 June 16, 2009: Version 4.0.5
     					Attribute id is required on sub-article and response
     					Element alternatives must have more than 1 child
     						
	April 15, 2009: Version 4.0.4
					Contract-sponsor must have an rid attribute that points to contract-num;
						or rid attribute that points to contract-sponsor's @id; 
						or an id attribute
					Contract-num must link to contract-sponsor
   
	February 13, 2009: Version 4.0.3
						Allow trans-abstract in manuscript xml.
						
	November 25, 2008: Version 4.0.1
						Added rules to enforce PMC Tagging Style for <alternatives>

	November 23, 2008: Version 4.0
						Added rules to support PMC Tagging Style for documents using
						version 3.0 of the NLM Journal DTDs.
	
						Added a check to article-meta test in article mode to require 
						a pub-date of a type other than 'nihms-submitted'
						
						
		
	
	April 30, 2008:	Version 3.4	
						Fixed problem in stylecheck-named-tests that was reporting 
						hyphenated season values as style errors
	
	April 1, 2008
						removed requirement for contract-sponsor to have an id if there is 
					   no contract-num in the file
	
	March 5, 2008
					added some checks for MathML content:
						- expanded the check for single-character mathml to include 
						  grandchild of mml:math
						- added template "mathml-repeated-element-check" and tested
						  mml:mn and mml:mtext against it.
						  
						  mml:mn immediately followed by mml:mn is an error
						  mml:mtext immediately followed by mml:mtext is a warning

	 
	 February 26, 2008  Version 3.3
	 					added hhmipa as an allowed value for the origin PI
						cleaned up nonspecific match of text()
						in month-check, day-check, year-check, added 
						   $context/ancestor::nlm-citation to the exclusions

	 
	 January 25, 2008
	 					allowed 'alt-language' as a related-article-type	 
	 
	 
	 January 21,2008: Version 3.2
	 					Remove rule requiring only one of @corresp on <contrib> or
						  correspondence footnote.
						Related article does not require ext-link-type if there is 
						  no xlink:href. But it should still have an ID.
						  
	 
	 November 7, 2007: Version 3.1.4
	 							Allowed <notes> in <back> for the manuscript workflow.
	 
	 July 3, 2007: Added test to require <journal-meta>
	 
    May 2, 2007: Version 3.1.3
                        PMC Style change: Floating objects no longer have
                        to be in sec-type="display-objects"
                        Removed: floating-object-check
                        Added: floats-wrap-check                            
                            
                        allowed journal-id-type values 'pubmed-jr-id' and 
                            'nlm-journal-id'
                        Loosened math character check to test for ancestor
                            rather than just parent being a math element.   

     March 26, 2007: Version 3.1.2: Allows 'hwp' as a value for 
                          @journal-id-type.
     
     March 21, 2007: Version 3.1.1: No longer complains about xlink 
                     attributes on <contrib>
     
     February2007: Version 3.1: Some xsl errors fixed.
     
     February2007: Version 3.0: One stylechecker written for articles, 
                   manuscripts, and books.
     
    12/8/2005: Style checker redesigned so that it does not rely on
               extension functions
    2005-07-10: Set "." as default context param throughout.
  -->
<!-- ************************************************************************ -->


<xsl:stylesheet 
   xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
   xmlns:xlink="http://www.w3.org/1999/xlink" 
   xmlns:mml="http://www.w3.org/1998/Math/MathML" 
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xmlns:ali="http://www.niso.org/schemas/ali/1.0/"
   version="1.0">
   
   <xsl:output method="xml" 
       omit-xml-declaration="yes"
       encoding="UTF-8"
       indent="yes"/>

   <!-- ==================================================================== -->
   <!--
                                  INCLUDES
     -->
   <!-- ==================================================================== -->
   <xsl:include href="stylecheck-match-templates.xsl"/>
   <xsl:include href="stylecheck-helper-templates.xsl"/>
   <xsl:include href="stylecheck-named-tests.xsl"/>

 
   <!-- ==================================================================== -->
   <!--                                                                      -->
   <!--                        GLOBAL PARAMETERS                             -->
   <!-- ==================================================================== -->

   <!-- Name of the XML/NXML file being processed   -->
   <xsl:param name="filename"/>

   <!-- If "true" then output messages to standard error; do not if "false" -->
   <xsl:param name="messages" select="'false'"/>

  <!-- If "yes" then notice names will be written to <error> and <warning> as 
       the value of @notice -->
   <xsl:param name="notices" select="'no'"/>

   <!-- Consider the document-type to be the type-name of the root element. -->
   <xsl:param name="document-type" select="
      name(/child::node()[not(self::comment()) and 
                          not(self::processing-instruction()) and 
                          not(self::text())])"/>

   <!-- Indicate our own version -->
   <xsl:param name="stylechecker-version"     select="'5.39'"/>
   <xsl:param name="stylechecker-mainline"    select="'nlm-stylechecker5.xsl'"/>

   <!-- The 'style' selects the rules that can be applied by the stylechecker.
        However, it is not used directly except to set $stream, below.
            Values include:
                article - for articles (the default)
                manuscript - for manuscripts
                book - for book content  
     -->
	<xsl:param name="style">
		<xsl:choose>
			<xsl:when test="name(/*)='book-part' or name(/*)='book' or name(/*)='book-part-wrapper'">
				<xsl:text>book</xsl:text>
            </xsl:when>
			<!-- How can we sniff for a manuscript? -->
			<xsl:when test="//processing-instruction('nihms')">
				<xsl:text>manuscript</xsl:text>
            </xsl:when>
			<!-- How can we sniff for a Rapid Research Note? -->
			<xsl:when test="contains(//processing-instruction('properties'),'RRN')">
				<xsl:text>rrn</xsl:text>
            </xsl:when>
			<xsl:otherwise>
				<xsl:text>article</xsl:text>
            </xsl:otherwise>
			</xsl:choose>
		</xsl:param>	   


   <!-- When $editstyle='word', that means it's a book that was converted from
        an MS Word(tm) document. -->
	<xsl:param name="editstyle">
		<xsl:variable name="flag">wordconverted='yes'</xsl:variable>
		<xsl:if test="contains(string(/processing-instruction('metadata')),$flag)">word</xsl:if>
		</xsl:param>

	<xsl:param name="stream">
		<xsl:choose>
			<xsl:when test="$style='manuscript' or
                         $style='book'">
				<xsl:value-of select="$style"/>
				</xsl:when>
			<xsl:when test="$style='article'">
				<xsl:text>article</xsl:text>
				</xsl:when>
			<xsl:when test="$style='rrn'">
				<xsl:text>rrn</xsl:text>
				</xsl:when>
			<xsl:otherwise> 
				<!-- error, but try to recover -->
				<xsl:text>article</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:param>

    
	<xsl:param name="content-title">
		<xsl:value-of select="/book/book-meta/book-title-group/book-title"/>
		<xsl:value-of select="/book-part/book-part-meta/title-group/title"/>
		<xsl:value-of select="/book-part-wrapper/book-part/book-part-meta/title-group/title"/>
		<xsl:value-of select="/article/front/article-meta/title-group/article-title"/>
		</xsl:param>

	<xsl:param name="dtd-version">
		<xsl:variable name="attvalue" select="substring-before(/node()/@dtd-version,'.')"/>
		<xsl:choose>
			<xsl:when test="not(/node()/@dtd-version)"> and unknown version </xsl:when>
			<xsl:when test="$attvalue='1' and /article/front/journal-meta/journal-title-group">j1</xsl:when>
			<xsl:when test="$attvalue='1' and (/book-part-wrapper | /book/namespace::xi)">b1</xsl:when>
			<xsl:when test="$attvalue='2' and (/book-part-wrapper | /book/namespace::xi)">b2</xsl:when>
			<xsl:when test="$attvalue='3'">3</xsl:when>
			<xsl:when test="$attvalue='2' or $attvalue='1'">2</xsl:when>
			<xsl:otherwise>[<xsl:value-of select="/node()/@dtd-version"/>||<xsl:value-of select="$attvalue"/>]</xsl:otherwise>
			</xsl:choose>
		</xsl:param>

	<xsl:param name="art-lang-att">
		<xsl:choose>
			<xsl:when test="/article/@xml:lang">
				<xsl:call-template name="knockdown">
					<xsl:with-param name="str" select="/article/@xml:lang"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="/book-part/@xml:lang | /book/@xml:lang | /book-part-wrapper/@xml:lang">
				<xsl:call-template name="knockdown">
					<xsl:with-param name="str" select="/*/@xml:lang"/>
				</xsl:call-template>
			</xsl:when>			
			<xsl:otherwise>
				<xsl:text>en</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:param>
	
	<xsl:param name="pub-id-type-values" select="' accession aggregator archive art-access-id arxiv coden custom doaj doi index isbn manuscript medline other pii pmc pmc-scan pmcid pmid publisher-id publisher-manuscript sici std-designation '"/>

	<xsl:key name="el-by-id" match="*[@id]" use="@id"/>

   <!-- ********************************************************************* -->
   <!-- Template: / 
        
        Process all children of the document root 
     -->
   <!-- ********************************************************************* -->
	<xsl:template match="/">
		<ERR>
			<xsl:processing-instruction name="SC-DETAILS">
				<xsl:if test="$stream != $style">
					<xsl:text>******* ERROR: $style WAS NOT PASSED CORRECTLY *******</xsl:text>
			   	</xsl:if>
				<xsl:text>Style checking applied for document with the root element "</xsl:text>
				<xsl:value-of select="$document-type"/>
				<xsl:text>"  with version </xsl:text>
				<xsl:value-of select="$stylechecker-version"/>
				<xsl:text> of the NLM XML StyleChecker. </xsl:text>
				<xsl:text>||</xsl:text>
				<xsl:text>The document is being checked against the PMC Tagging Guidelines rules for "</xsl:text>
				<xsl:value-of select="$stream"/>
				<xsl:text>" for content tagged using </xsl:text>
				<xsl:choose>
					<xsl:when test="$dtd-version='2'">
						<xsl:text> version 2.3 or earlier </xsl:text>
						</xsl:when>
					<xsl:when test="$dtd-version='3'">
						<xsl:text> version 3.0 </xsl:text>
					</xsl:when>
					<xsl:when test="$dtd-version='j1'">
						<xsl:text> version 1.0 </xsl:text>
					</xsl:when>
					<xsl:when test="$dtd-version='b1'">
						<xsl:text>version 1.0 </xsl:text>
					</xsl:when>
					<xsl:when test="$dtd-version='b2'">
						<xsl:text>version 2.0 </xsl:text>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$dtd-version"/>
						</xsl:otherwise>
					</xsl:choose>
				<xsl:text>of the </xsl:text>
				<xsl:choose>
					<xsl:when test="$dtd-version='j1'">
						<xsl:text>JATS DTD. </xsl:text>
					</xsl:when>
					<xsl:when test="$dtd-version='b1'">
						<xsl:text>BITS DTD. </xsl:text>
					</xsl:when>
					<xsl:when test="$dtd-version='b2'">
						<xsl:text>BITS DTD. </xsl:text>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>NLM DTD. </xsl:text>
					</xsl:otherwise>
				</xsl:choose>
				<xsl:text>||</xsl:text>
				<xsl:text> The document was tagged with the language attribute value "</xsl:text>
				<xsl:value-of select="$art-lang-att"/>
				<xsl:text>". </xsl:text>
				</xsl:processing-instruction>
			<xsl:processing-instruction name="TITLE">
				<xsl:value-of select="$content-title"/>
				</xsl:processing-instruction>
			<xsl:apply-templates/>
		</ERR>
		</xsl:template>

</xsl:stylesheet>

