<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet 
   xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
   xmlns:xlink="http://www.w3.org/1999/xlink" 
   xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xmlns:mml="http://www.w3.org/1998/Math/MathML" 
   version="1.0">
 

<!-- ##################### MATCHING ELEMENT TEMPLATES ####################### -->
<!-- 
     Templates match elements for which stylistic rules have been defined.
	 In general, each matching template will apply tests by calling a
	 named template that implements the logic of the style test. This has
	 been done because multiple elements may need to apply the same test.
	 Once tests have been applied, each template then copies the current
	 context to the result true by calling a special "output" mode.
  -->
<!-- ######################################################################## -->

   <!-- *********************************************************** -->
   <!-- Match: abbrev
        1) cannot be empty
        2) check xlink:href content
     -->
	<xsl:template match="abbrev">
		<xsl:call-template name="empty-element-check"/>
      <xsl:call-template name="href-content-check"/>
      <xsl:apply-templates select="." mode="output"/>
		</xsl:template>

   <!-- *********************************************************** -->
   <!-- Match: abstract
        1) if abstract has sec, must have more than one 
		     or has p followed by sec
        2) If article-meta contains more than one abstract,
        first abstract does not require an abstract type, but all 
        the rest do.
        3) cannot be empty
		  4)  Title only allowed if it is different from
           "Abstract" 
		  5) If manuscript, do not allow attributes.
        -->
	 <xsl:template match="abstract">
		<xsl:call-template name="check-abstract-content"/>
		<xsl:call-template name="check-abstract-type"/>
		<xsl:call-template name="empty-element-check"/>
		<!--<xsl:call-template name="abstract-title-test"/>-->
		<xsl:call-template name="abstract-sec-test"/>
		<xsl:call-template name="article-pi-check"/>
	 <!--=======================================-->  
	   <!--Removed this test, KP 2015-11-03
	   Manuscript to follow PMC rules-->
	<!--=======================================--> 
		<!--<xsl:if test="$stream='manuscript'">
			<xsl:call-template name="abstract-attribute-test"/>
		</xsl:if>-->
	<!--=======================================--> 
		<xsl:apply-templates select="." mode="output"/>
	</xsl:template>

   <!-- *********************************************************** -->
   <!-- Match: ack
        1) should not appear in body
        2) cannot be empty
		  3) If manuscript, must have appropriate ID
     -->
   <xsl:template match="ack">
      <xsl:call-template name="empty-element-check"/>
      <xsl:call-template name="back-element-check"/>
		<xsl:call-template name="ms-stream-id-test"/>
      <xsl:apply-templates select="." mode="output"/>
		</xsl:template>

   <!-- *********************************************************** -->
   <!-- Match: aff
		  1) If manuscript, must have appropriate ID
      -->
   <xsl:template match="aff">
		<xsl:call-template name="ms-stream-id-test"/>
   		<xsl:call-template name="aff-xref-check"/>
      <xsl:apply-templates select="." mode="output"/>
   </xsl:template>	
	
	<!-- *********************************************************** -->
	<!-- Match: aff-alternatives
		-->
	<xsl:template match="aff-alternatives">
		<xsl:call-template name="aff-alternatives-content-check"/>
		<xsl:apply-templates select="." mode="output"/>
	</xsl:template>
	
   <!-- *********************************************************** -->
   <!-- Match: address
         1) cannot be empty
     -->
   <xsl:template match="address">
		<xsl:call-template name="empty-element-check"/>
      <xsl:apply-templates select="." mode="output"/>
		</xsl:template>

   <!-- *********************************************************** -->
   <!-- Match: alternatives
         1) only allowed in certain elements
         2) content is based on parent
     -->
   <xsl:template match="alternatives">
        	<xsl:if test="$stream != 'book'">
			<xsl:call-template name="alternatives-parent-check"/>
		</xsl:if>
		<xsl:call-template name="alternatives-content-check"/>
      <xsl:apply-templates select="." mode="output"/>
		</xsl:template>
		

    <!-- *********************************************************** -->
   <!-- Match: answer (BITS)
        1) 
     -->
   <!-- *********************************************************** -->
   <!--<xsl:template match="answer">
  
      <xsl:apply-templates select="." mode="output"/>
   </xsl:template>-->
   
   
   <!-- *********************************************************** -->
   <!-- Match: answer-set (BITS)
        1) 
     -->
   <!-- *********************************************************** -->
   <!--<xsl:template match="answer-set">
  
      <xsl:apply-templates select="." mode="output"/>
   </xsl:template>-->
      

   <!-- *********************************************************** -->
   <!-- Match: app
        1) cannot be empty
		  2) If manuscript, must have appropriate ID
     -->
   <xsl:template match="app">
      <xsl:call-template name="empty-element-check"/>
		<xsl:call-template name="ms-stream-id-test"/>
      <xsl:apply-templates select="." mode="output"/>
		</xsl:template>

   <!-- *********************************************************** -->
   <!-- Match: app-group
        1) cannot be empty
     -->
	<xsl:template match="app-group">   
		<xsl:call-template name="empty-element-check"/>
		<xsl:apply-templates select="." mode="output"/>
		</xsl:template>

   <!-- *********************************************************** -->
   <!-- Match: article
			1) The article-type attribute in article element is required. 
			2) @article-type must have recognized value. 
			3) If there is a product element in article-meta,
            then the article-type should be set to either
            book-review or product-review 
			4) If article-type is book review or product review
            then should have a product element. If not, issue a warning and
		      not an error.
		      EXCEPTION: scanning data does not require a product element.
			5) For a given article-type attribute, check if have the required
			   related-article element and the right related-article-type attribute  
			6) If manuscript, must have proper processing instructions
     -->
   <xsl:template match="article">
      <xsl:call-template name="attribute-present-not-empty">
         <xsl:with-param name="context" select="@article-type"/>
         <xsl:with-param name="attribute-name" select="'article-type'"/>
         <xsl:with-param name="test-name" select="'article-type attribute check'"/>
			</xsl:call-template>
		<!-- <xsl:call-template name="article-language-check"/> -->
      <xsl:call-template name="article-type-content-check"/>
      <xsl:call-template name="product-to-article-type-check"/>
      <xsl:call-template name="article-type-to-product-check"/>
      <xsl:call-template name="article-type-to-related-article-check"/>
   	<xsl:call-template name="article-release-delay-check"/>
   	<xsl:call-template name="collection-content-check"/>
   	<xsl:call-template name="correction-content-check"/>
		<xsl:if test="$stream='manuscript'">
			<xsl:call-template name="manuscript-pi-test"/>
         <xsl:call-template name="ms-floats-group-test"/>
		</xsl:if>		  
      <xsl:apply-templates select="." mode="output"/>
		</xsl:template>

   <!-- *********************************************************** -->
   <!-- Match: article-categories
        1) cannot be empty
		  2) for manuscript, only one subj-group is allowed with @subj-group-type
		     ='heading' and one subject 'Article'
     -->
	<xsl:template match="article-categories">   
		<xsl:call-template name="empty-element-check"/>
		<xsl:if test="$stream='manuscript'">
			<xsl:call-template name="ms-subj-group-test"/>
		</xsl:if>
		<xsl:if test="$stream='article'">
			<xsl:call-template name="article-subj-group-test"/>
		</xsl:if>
		<xsl:apply-templates select="." mode="output"/>
	</xsl:template>

   <!-- *********************************************************** -->
   <!-- Match: article-id
        1) must have pub-id-type and must be correct value
        2) element must have content
        3) If contains doi, must be right format 
		  4) If pub-id-type is "manuscript" the article must include the <?properties manuscript?> PI
     -->
   <!-- *********************************************************** -->
   <xsl:template match="article-id">  
      <xsl:call-template name="attribute-present-not-empty">
         <xsl:with-param name="context" select="@pub-id-type"/>
         <xsl:with-param name="attribute-name" select="'pub-id-type'"/>
         <xsl:with-param name="test-name" select="'pub-id-type attribute check'"/>
			</xsl:call-template>
      <xsl:call-template name="pub-id-type-check"/>
      <xsl:call-template name="article-id-content-check"/>
      <xsl:if test="@pub-id-type = 'doi'">
			<xsl:call-template name="doi-check">
				<xsl:with-param name="value" select="."/>
				</xsl:call-template>
			</xsl:if>
		<xsl:if test="$stream='manuscript' and @pub-id-type='manuscript'">
			<xsl:call-template name="ms-whitespace-check"/>
			</xsl:if>
      <xsl:apply-templates select="." mode="output"/>
		</xsl:template>

   <!-- *********************************************************** -->
   <!-- Match: article-meta
        1) cannot be empty 
		  2) must have article-categories children
        3) needs at least on heading subj-group
		  4) article must have an fpage or elocation-id
		  5) manuscript may not have most citation info
		  6) manuscript may have more than one abstract
		  (change on 2015-11-03 KP)
     -->
	<xsl:template match="article-meta">
		<xsl:call-template name="empty-element-check"/>
		<!-- xsl:call-template name="child-present">
			<xsl:with-param name="child" select="'article-id'"/>
			</xsl:call-template -->
		<xsl:if test="not(ancestor::sub-article) and not(ancestor::response)">
			<xsl:call-template name="child-present">
				<xsl:with-param name="child" select="'article-categories'"/>
			</xsl:call-template>
			<xsl:choose>
				<xsl:when test="$stream='article'">
					<xsl:call-template name="fpage-check"/>
					<xsl:call-template name="pub-date-check"/>
					<xsl:if test="contains(//processing-instruction('properties'),'manuscript')">
						<xsl:call-template name="ms-article-id-test"/>
					</xsl:if>
				</xsl:when>
				<xsl:when test="$stream='manuscript'">
					<xsl:call-template name="ms-article-meta-content-test"/>
					<!--<xsl:call-template name="ms-article-meta-abstract-test"/>-->
					<!--	<xsl:call-template name="ms-article-id-test"/>  -->
				</xsl:when>
			</xsl:choose>
		</xsl:if>
		<xsl:apply-templates select="." mode="output"/>
	</xsl:template>


   <!-- *********************************************************** -->
   <!-- Match: article-title
        1) Inside title-group, should not contain any fn
		   (should be placed in the back)
         2) Inside title-group, if there is an xref pointing to a fn,
           then the fn should be set in back/fn-group
        3) outside of citation and product, content should not all be formatted
     -->
	<xsl:template match="article-title">   
      <xsl:if test="ancestor::*[not(self::citation) and not(self::element-citation) and 
      				not(self::mixed-citation) and not(self::nlm-citation) and not(self::product)]">
         <xsl:call-template name="block-formatting-check">
            <xsl:with-param name="context" select="."/>
				</xsl:call-template>
			</xsl:if>
      <xsl:apply-templates select="." mode="output"/>
		</xsl:template>

   <!-- *********************************************************** -->
   <!-- Match: award-group
			1) cannot be empty.
			-->
   <xsl:template match="award-group">   
      <xsl:call-template name="empty-element-check"/>
      <xsl:apply-templates select="." mode="output"/>
		</xsl:template>
			
   <!-- *********************************************************** -->
   <!-- Match: award-id
			1) cannot be empty.
			-->
   <xsl:template match="award-id">   
      <xsl:call-template name="empty-element-check"/>
      <xsl:apply-templates select="." mode="output"/>
		</xsl:template>
			

   <!-- ********************************************* -->
   <!-- Match: back
        1) don't allow title or notes 
        2) if article has floating tables and figs,
           then must have a display-object section 
           in back
	    -->
	<xsl:template match="back">
		<xsl:call-template name="empty-element-check"/>
       <xsl:if test="$stream='manuscript'">
			<xsl:call-template name="ms-back-content-test"/>
			<xsl:call-template name="ms-back-display-object-test"/>
			</xsl:if>
		<xsl:apply-templates select="." mode="output"/>
		</xsl:template>
   
   <!-- *********************************************************** -->
   <!-- Match: bio
        1) check href content
		  2) cannot be empty
     -->
   <xsl:template match="bio">   
		<xsl:call-template name="href-content-check"/>
      <xsl:call-template name="empty-element-check"/>
      <xsl:apply-templates select="." mode="output"/>
		</xsl:template>

   <!-- *********************************************************** -->
   <!-- Match: body
        1) cannot be empty 
		  2) if manuscript, check that extended data figures are in
		     the appropriate section.
     -->
   <xsl:template match="body">
      <xsl:call-template name="empty-element-check"/>
		<xsl:if test="$stream='manuscript'">
			<xsl:call-template name="ms-extended-data-test"/>
 		</xsl:if>		  
      <xsl:apply-templates select="." mode="output"/>
		</xsl:template>

   <!-- *********************************************************** -->
   <!-- Match: book 
        1) cannot be empty 
     -->
   <xsl:template match="book">
      <xsl:call-template name="empty-element-check"/>
      <xsl:apply-templates select="." mode="output"/>
    </xsl:template>
    
   <!-- *********************************************************** -->
   <!-- Match: book-app (BITS2)
        1) cannot be empty 
     -->
   <xsl:template match="book-app">
      <xsl:call-template name="empty-element-check"/>
      <xsl:apply-templates select="." mode="output"/>
    </xsl:template>
    
   <!-- *********************************************************** -->
   <!-- Match: book-app-group (BITS2)
        1) cannot be empty 
     -->
   <xsl:template match="book-app-group">
      <xsl:call-template name="empty-element-check"/>
      <xsl:apply-templates select="." mode="output"/>
    </xsl:template>
    
    
   <!-- *********************************************************** -->
   <!-- Match: book-back (BITS)
        1) cannot be empty 
     -->
   <xsl:template match="book-back">
      <xsl:call-template name="empty-element-check"/>
      <xsl:apply-templates select="." mode="output"/>
    </xsl:template>
    
    
    <!-- *********************************************************** -->
   <!-- Match: book-body (BITS)
        1) cannot be empty 
     -->
   <xsl:template match="book-body">
      <xsl:call-template name="empty-element-check"/>
      <xsl:apply-templates select="." mode="output"/>
    </xsl:template>



   <!-- *********************************************************** -->
   <!-- Match: book-part

       Tests: 
        1) cannot be empty 
		  2) The book-part-type attribute is required
		  3) id is required
     -->
   <xsl:template match="book-part">
      <xsl:call-template name="empty-element-check"/>
      <xsl:call-template name="attribute-present-not-empty">
         <xsl:with-param name="context" select="@book-part-type"/>
         <xsl:with-param name="attribute-name" select="'book-part-type'"/>
         <xsl:with-param name="test-name" select="'book-part-type attribute check'"/>
			</xsl:call-template>
      <xsl:if test="normalize-space(parent::book-part-wrapper/@id) = '' ">
           <xsl:call-template name="attribute-present-not-empty">
             <xsl:with-param name="context" select="@id"/>
             <xsl:with-param name="attribute-name" select="'id'"/>
             <xsl:with-param name="test-name" select="'book-part id attribute check'"/>
          </xsl:call-template>
      </xsl:if>
      <xsl:apply-templates select="." mode="output"/>
		</xsl:template>
		

   <!-- *********************************************************** -->
   <!-- Match: book-part-wrapper (BITS)

       Tests: 
        1) cannot be empty 
     -->
   <xsl:template match="book-part-wrapper">
      <xsl:call-template name="empty-element-check"/>      
      <xsl:apply-templates select="." mode="output"/>
   </xsl:template>


    <!-- *********************************************************** -->
   <!-- Match: book-volume-id (BITS)
        1) cannot be empty 
     -->
   <xsl:template match="book-volume-id">
      <xsl:call-template name="empty-element-check"/>
      <xsl:apply-templates select="." mode="output"/>
    </xsl:template>


    <!-- *********************************************************** -->
   <!-- Match: book-volume-number (BITS)
        1) cannot be empty 
     -->
   <xsl:template match="book-volume-number">
      <xsl:call-template name="empty-element-check"/>
      <xsl:apply-templates select="." mode="output"/>
    </xsl:template>


   <!-- *********************************************************** -->
   <!-- Match: boxed-text
        1) cannot be empty 
		    2) in books, boxed-text in boxed-text may not be referenced
		    3) in books, floating boxes must be referenced.
     -->
   <xsl:template match="boxed-text">
		 <xsl:call-template name="ms-stream-id-test"/>
     <xsl:call-template name="empty-element-check"/>
		 <xsl:if test="($document-type='book' or $document-type='book-part') and ancestor::boxed-text">		  
			<xsl:call-template name="check-for-xref">	
				<xsl:with-param name="context" select="."/>
				<xsl:with-param name="inbox" select="'yes'"/>
				</xsl:call-template>
		 </xsl:if>
     <!-- Check for a cross-reference to a floating box. -->
     <!--<xsl:if test="$stream='book' and @position!='anchor' and not(ancestor::boxed-text)">		  
		   <xsl:call-template name="float-obj-check">	
				 <xsl:with-param name="context" select="."/>
			 </xsl:call-template>
		 </xsl:if>-->
     <xsl:apply-templates select="." mode="output"/>
   </xsl:template>


   <!-- *********************************************************** -->
   <!-- Match: caption
        1) cannot be empty 
     -->
   <xsl:template match="caption">
      <xsl:call-template name="empty-element-check"/>
      <xsl:call-template name="caption-format-test"/>
      <xsl:apply-templates select="." mode="output"/>
		</xsl:template>

   <!-- *********************************************************** -->
   <!-- Match: chapter-title
			1) cannot be empty.
			-->
   <xsl:template match="chapter-title">   
      <xsl:call-template name="empty-element-check"/>
      <xsl:apply-templates select="." mode="output"/>
		</xsl:template>

   <!-- *********************************************************** -->
   <!-- Match: chem-struct
        1) xlink:href cannot be empty
     -->
   <xsl:template match="chem-struct">
      <xsl:call-template name="href-content-check"/>
      <xsl:apply-templates select="." mode="output"/>
		</xsl:template>


   <!-- *********************************************************** -->
   <!-- Match: citation
        1) citation-type must be present and have correct value
        2) xlink:href cannot be empty
     -->
   <xsl:template match="citation">
      <xsl:call-template name="citation-type-value"/>
      <xsl:call-template name="href-content-check"/>
      <xsl:apply-templates select="." mode="output"/>
   </xsl:template>
	
	<!-- *********************************************************** -->
	<!-- Match: citation-alternatives 
		citation-alternatives-content-check
	-->
	<xsl:template match="citation-alternatives">
		<xsl:call-template name="citation-alternatives-content-check"/>
		<xsl:apply-templates select="." mode="output"/>
	</xsl:template>

   <!-- *********************************************************** -->
   <!-- Match: colgroup
        1) cannot be empty 
     -->
   <xsl:template match="colgroup">
      <xsl:call-template name="empty-element-check"/>
      <xsl:apply-templates select="." mode="output"/>
		</xsl:template>


   <!-- *********************************************************** -->
   <!-- Match: collab
        1) xlink:href cannot be empty
        2) cannot be empty
        3) collab-content-check
     -->
   <!-- *********************************************************** -->
   <xsl:template match="collab">   
      <xsl:call-template name="href-content-check"/>
   	<xsl:call-template name="empty-element-check"/>
      <xsl:call-template name="collab-content-check"/>
      <xsl:apply-templates select="." mode="output"/>
   </xsl:template>
	
	
	<!-- *********************************************************** -->
	<!-- Match: collab-alternatives
		1) cannot be empty
		2) collab-alternatives-content-check -->
	<!-- *********************************************************** -->
	<xsl:template match="collab-alternatives">
		<xsl:call-template name="href-content-check"/>
		<xsl:call-template name="collab-alternatives-content-check"/>
		<xsl:apply-templates select="." mode="output"/>
	</xsl:template>


    <!-- *********************************************************** -->
   <!-- Match: collection-id (BITS)
        1) cannot be empty 
     -->
   <xsl:template match="collection-id">
      <xsl:call-template name="empty-element-check"/>
      <xsl:apply-templates select="." mode="output"/>
    </xsl:template>


    <!-- *********************************************************** -->
   <!-- Match: collection-meta (BITS)
        1) cannot be empty 
     -->
   <xsl:template match="collection-meta">
      <xsl:call-template name="empty-element-check"/>
      <xsl:apply-templates select="." mode="output"/>
    </xsl:template>       
    

   <!-- *********************************************************** -->
   <!-- Match: compound-kwd-part
			1) cannot be empty.
			-->
   <xsl:template match="compound-kwd-part">   
      <xsl:call-template name="empty-element-check"/>
      <xsl:apply-templates select="." mode="output"/>
		</xsl:template>
			

   <!-- *********************************************************** -->
   <!-- Match: conference

       Tests: 
        1) cannot be empty 
     -->
   <!-- *********************************************************** -->
   <xsl:template match="conference">

      <xsl:call-template name="empty-element-check"/>

      <xsl:apply-templates select="." mode="output"/>
   </xsl:template>

   <!-- *********************************************************** -->
   <xsl:template match="contract-num">
   
      <xsl:call-template name="contract-num-linking"/>
              
      <!-- Test 2 
      <xsl:call-template name="xlink-attribute-check"/>-->

      	<xsl:apply-templates select="." mode="output"/>
   </xsl:template>


   <!-- *********************************************************** -->
   <!-- Match: contract-sponsor
        1) must link correctly 

   	2) no xlink attributes - Removed 12/20/06 for domain Blood
     -->
   <!-- *********************************************************** -->
   <xsl:template match="contract-sponsor">
   
      <xsl:call-template name="contract-sponsor-linking"/>
		
      <xsl:apply-templates select="." mode="output"/>

   </xsl:template>

   <!-- *********************************************************** -->
   <!-- Match: contrib
        1) @corresp, @deceased, @equal-contrib, @rid must be used
           correctly
        2) cannot be empty 
        
        3) no xlink attributes
        
     -->
   <!-- *********************************************************** -->
   <xsl:template match="contrib">
   
      <xsl:call-template name="empty-element-check"/>

		<xsl:choose>
			<xsl:when test="$stream='manuscript'">
      		<xsl:call-template name="ms-contrib-content-test"/>
 		     	<xsl:call-template name="ms-contrib-attribute-test"/>
				</xsl:when>
			<xsl:otherwise>
		      <xsl:call-template name="contrib-attribute-checking"/>
				</xsl:otherwise>
			</xsl:choose>
	
      <xsl:call-template name="contrib-author-notes-test"/>

      <xsl:call-template name="contrib-content-test"/>
	
     <!--  <xsl:call-template name="xlink-attribute-check"/>  -->

      <xsl:apply-templates select="." mode="output"/>
   </xsl:template>


   <!-- ********************************************* -->
   <!-- Match: contrib-group
        
        Tests:
        1) Only allow contrib and aff children
        2) If every contrib has an aff, then do 
           not allow another aff in contrib-group
           (all affiliation information should already
           have been presented); if there is an aff
           in contrib-group, then none of the
           contribs should contain an aff 
   	   3) If inside collab, can't have descendant collab
   -->
   <!-- ********************************************* -->   
   <xsl:template match="contrib-group">
   
      <xsl:call-template name="empty-element-check"/>
  
      <xsl:if test="$stream='manuscript'">
      	<xsl:call-template name="ms-contrib-group-content-test"/>
      	<xsl:call-template name="ms-contrib-group-aff-test"/>
      </xsl:if>
   	
   	<xsl:if test="parent::collab">
   		<xsl:call-template name="collab-contribgrp-check"/>
   	</xsl:if>
      
      <xsl:apply-templates select="." mode="output"/>
   </xsl:template>
   
   
	<!-- ********************************************* -->
	<!-- Match: contrib-id 
		 1) Must not be empty
		 2) contrib-id-check
	-->
	<!-- ********************************************* -->
	<xsl:template match="contrib-id">
		<xsl:call-template name="empty-element-check"/>
		<xsl:call-template name="contrib-id-check"/>
		<xsl:apply-templates select="." mode="output"/>
	</xsl:template>
   

   <!-- *********************************************************** -->
   <!-- Match: copyright-year
        1) must be valid value
     -->
   <!-- *********************************************************** -->
   <xsl:template match="copyright-year">
   
      <xsl:call-template name="copyright-year-check"/>
              
      <xsl:apply-templates select="." mode="output"/>
   </xsl:template>


   <!-- *********************************************************** -->
   <!-- Match: counts
        1) cannot be empty 
     -->
   <!-- *********************************************************** -->
   <xsl:template match="counts">
   
      <xsl:call-template name="empty-element-check"/>
              
      <xsl:apply-templates select="." mode="output"/>
   </xsl:template>


   <!-- *********************************************************** -->
   <!-- Match: date
        1) cannot be empty 
        2) must have correct use of date-type attribute
     -->
   <!-- *********************************************************** -->
   <xsl:template match="date">
   
      <xsl:call-template name="empty-element-check"/>
      
      <xsl:call-template name="history-date-type-attribute-check"/>
		
		<xsl:call-template name="date-check"/>
              
      <xsl:apply-templates select="." mode="output"/>
   </xsl:template>

   <!-- *********************************************************** -->
   <!-- Match: date-in-citation
			1) cannot be empty.
			-->
   <xsl:template match="date-in-citation">   
      <xsl:call-template name="empty-element-check"/>
      <xsl:apply-templates select="." mode="output"/>
		</xsl:template>
			

   <!-- *********************************************************** -->
   <!-- Match: day
        1) outside of citation, should have valid value 
     -->
   <!-- *********************************************************** -->
   <xsl:template match="day">
            <xsl:call-template name="day-check">
            <xsl:with-param name="context" select="."/>
         </xsl:call-template>
      <xsl:apply-templates select="." mode="output"/>
   </xsl:template>
   
   
   <!-- *********************************************************** -->
   <!-- Match: dedication (BITS)
        1) cannot be empty 
     -->
   <xsl:template match="dedication">
      <xsl:call-template name="empty-element-check"/>
      <xsl:apply-templates select="." mode="output"/>
    </xsl:template>       
    


   <!-- *********************************************************** -->
   <!-- Match: def-item
        1) cannot be empty 
     -->
   <!-- *********************************************************** -->
   <xsl:template match="def-item">
   
      <xsl:call-template name="empty-element-check"/>
              
      <xsl:apply-templates select="." mode="output"/>
   </xsl:template>


   <!-- *********************************************************** -->
   <!-- Match: def-list
        1) cannot be empty 
     -->
   <!-- *********************************************************** -->
   <xsl:template match="def-list">
   
      <xsl:call-template name="empty-element-check"/>
              
      <xsl:apply-templates select="." mode="output"/>
   </xsl:template>


   <!-- *********************************************************** -->
   <!-- Match: disp-quote
        1) cannot be empty 
		  2) In books, cannot contain <preformat>
     -->
   <!-- *********************************************************** -->
   <xsl:template match="disp-quote">

		<xsl:call-template name="ms-stream-id-test"/>

      <xsl:call-template name="empty-element-check"/>
              
		<xsl:if test="$stream='book'">
			<xsl:call-template name="disp-quote-content-check"/>
			</xsl:if>		  
				  
      <xsl:apply-templates select="." mode="output"/>
   </xsl:template>

   <!-- ********************************************* -->
   <!-- Match: disp-formula
        
        Tests:
           1) id attribute required
           2) Should not include non-formatting and
           mml:math characters        
           3) id atttribute content must be of correct
              form            
			  4) content should be one of 
			      -content in JATS emphasis elements and PCDATA, 
					 - one mml:math, or 
					 - one tex-math. 
					If more than one representation of the formula 
					is included, they must be tagged as alternatives 
					with the element (3.0+) or @alternate-form-of (2.3).                         -->
   <!-- ********************************************* -->   
	<xsl:template match="disp-formula">

		<xsl:call-template name="ms-stream-id-test"/>
      
		<xsl:if test="$stream='manuscript'">
			<xsl:call-template name="ms-disp-formula-content-test"/>
			<xsl:call-template name="id-content-test"/>
			</xsl:if>
      
		<xsl:call-template name="formula-content-test"/>
		
      <xsl:apply-templates select="." mode="output"/>
   </xsl:template>

   <!-- *********************************************************** -->
   <!-- Match: element-citation
			1) cannot be empty.
			2) @xlink:href cannot be empty
			-->
   <xsl:template match="element-citation">   
      <xsl:call-template name="empty-element-check"/>
		<xsl:call-template name="href-content-check"/>
      <xsl:apply-templates select="." mode="output"/>
		</xsl:template>
			

   <!-- *********************************************************** -->
   <!-- Match: email
        1) xlink:href cannot be empty
     -->
   <!-- *********************************************************** -->
   <xsl:template match="email">
   
      <xsl:call-template name="href-content-check"/>
              
      <xsl:apply-templates select="." mode="output"/>
   </xsl:template>


    <!-- *********************************************************** -->
   <!-- Match: ext-link
        1) if contains a DOI, must be correct format
        
        2) attributes must be correct 
        
        3) If a weblink, attribute values are constrained

        4) xlink:href cannot be empty
        
        5) if ancestor::license, check content
     -->
   <!-- *********************************************************** -->
   <xsl:template match="ext-link">
   
      <xsl:if test="@ext-link-type = 'doi'">
         <xsl:call-template name="doi-check">
            <xsl:with-param name="value" select="@xlink:href"/>
         </xsl:call-template>
      </xsl:if>

      <xsl:call-template name="ext-link-attribute-check"/>

      <xsl:if test="@ext-link-type='uri' or @ext-link-type='url'">
	   	<xsl:call-template name="web-ext-link-check"/>
      </xsl:if>
              
      <xsl:call-template name="href-content-check"/>
   	
   	<xsl:if test="ancestor::license">
   		<xsl:call-template name="license-ext-link-content-check">   			
   			<xsl:with-param name="context" select="."/>
   		</xsl:call-template>
   	</xsl:if>

      <xsl:apply-templates select="." mode="output"/>
   </xsl:template>


   <!-- *********************************************************** -->
   <!-- Match: fig
        1) cannot be empty 
        
	2) in books, figs in boxed-text may not be referenced
     -->
   <!-- *********************************************************** -->
   <xsl:template match="fig">
   
      <xsl:call-template name="empty-element-check"/>
		<xsl:call-template name="ms-stream-id-test"/>

		<xsl:if test="$stream='manuscript'">
			<xsl:call-template name="id-content-test"/>
		</xsl:if>
    
    <!--
        In Word books, if the figure is in a box,
        make sure it is not directly referenced
    -->
		<xsl:if test="$stream='book' and ancestor::boxed-text">		  
		<!-- Test 2 -->
			<xsl:call-template name="check-for-xref">	
				<xsl:with-param name="context" select="."/>
				<xsl:with-param name="inbox" select="'yes'"/>
			</xsl:call-template>
		</xsl:if>
    <!-- Check for a cross-reference to a floating figure. -->
    <!--<xsl:if test="$stream='book' and @position='float' and not(ancestor::boxed-text)">		  
		  <xsl:call-template name="float-obj-check">	
				<xsl:with-param name="context" select="."/>
			</xsl:call-template>
		</xsl:if>-->
			
    <xsl:apply-templates select="." mode="output"/>
   </xsl:template>


   <!-- ********************************************* -->
   <!-- Match: fig-group 
        
        Tests:
        1) Not allowed -->
   <!-- ********************************************* -->   
   <xsl:template match="fig-group">

      <xsl:call-template name="empty-element-check"/>
   	
		<xsl:if test="$stream='manuscript'">
			<xsl:call-template name="make-error">
				<xsl:with-param name="error-type" select="'element not allowed'"/>
				<xsl:with-param name="test-result">
					<xsl:text>&lt;fig-group&gt; not allowed. All figures should be tagged as 
					individual fig elements without a group.</xsl:text>
					</xsl:with-param>
				</xsl:call-template>
			</xsl:if>
		<xsl:if test="$stream='book' and ancestor::boxed-text">		  
		<!-- Test 3 -->
			<xsl:call-template name="check-for-xref">	
				<xsl:with-param name="context" select="."/>
				<xsl:with-param name="inbox" select="'yes'"/>
				</xsl:call-template>
			</xsl:if>

      <xsl:apply-templates select="." mode="output"/>
   </xsl:template>
	
	<!-- *********************************************************** -->
	<!-- Match: floats-group
		1) children must have position="float"
		2) cannot be empty 
		
		Note: this is a version 2 element
	-->
	<!-- *********************************************************** -->
	<xsl:template match="floats-group">
		<xsl:call-template name="floats-wrap-check"/>
		<xsl:apply-templates select="." mode="output"/>
		</xsl:template>
	
	<!-- *********************************************************** -->
	<!-- Match: floats-wrap
		1) children must have position="float"
		2) cannot be empty 
		
		Note: this is a version 2 element
	-->
	<!-- *********************************************************** -->
	<xsl:template match="floats-wrap">
		<xsl:call-template name="floats-wrap-check"/>
		<xsl:apply-templates select="." mode="output"/>
		</xsl:template>
	
   <!-- *********************************************************** -->
   <!-- Match: fn
        1) when inside author notes, fn-type cannot be certain values

        2) check attributes (id and symbol)
        
        3) article-level footnotes should be in back
        
        4) fn in tables should be in table-wrap-foot
     -->
   <!-- *********************************************************** -->
   <xsl:template match="fn">
   
		<xsl:call-template name="ms-stream-id-test"/>
		
		<xsl:if test="$stream='manuscript'">
			<xsl:call-template name="ms-footnote-license-check"/>
			</xsl:if>
			
      <xsl:if test="parent::author-notes">
         <xsl:call-template name="author-notes-fn-type-check">
            <xsl:with-param name="context" select="."/>
         </xsl:call-template>
      </xsl:if>

      <xsl:call-template name="fn-attribute-check"/>

      <!-- no longer testing location of footnote
		<xsl:call-template name="fn-location-check"/> -->

      <xsl:call-template name="table-fn-check"/>
              
      <xsl:apply-templates select="." mode="output"/>
   </xsl:template>


   <!-- *********************************************************** -->
   <!-- Match: fn-group
        1) should not appear in body
     -->
   <!-- *********************************************************** -->
   <xsl:template match="fn-group">
   
      <xsl:call-template name="back-element-check"/>
              
      <xsl:apply-templates select="." mode="output"/>
   </xsl:template>


   <!-- *********************************************************** -->
   <!-- Match: foreword (BITS)
        1) cannot be empty 
     -->
   <!-- *********************************************************** -->
   <xsl:template match="foreword">
      <xsl:call-template name="empty-element-check"/>
      <xsl:apply-templates select="." mode="output"/>
   </xsl:template>
      

   <!-- *********************************************************** -->
   <!-- Match: fpage
        1) In article-meta, should be followed by lpage
     -->
   <!-- *********************************************************** -->
   <xsl:template match="fpage">
   
      <xsl:call-template name="lpage-check"/>
              
      <xsl:apply-templates select="." mode="output"/>
   </xsl:template>

   <!-- ********************************************* -->
   <!-- Match: front
        
        Tests:
        1) Cannot contain notes                       -->
   <!-- ********************************************* -->   
   <xsl:template match="front">
   	<xsl:choose>
      	<xsl:when test="$stream='manuscript'">
      		<xsl:call-template name="ms-front-content-test"/>
				</xsl:when>
			<xsl:otherwise>
      		<xsl:call-template name="front-content-test"/>  
				</xsl:otherwise>
			</xsl:choose>
         
      <xsl:apply-templates select="." mode="output"/>
   </xsl:template>
   
   
   <!-- *********************************************************** -->
   <!-- Match: front-matter (BITS)
        1) cannot be empty 
     -->
   <xsl:template match="front-matter">
      <xsl:call-template name="empty-element-check"/>
      <xsl:apply-templates select="." mode="output"/>
    </xsl:template>    
   
   
   <!-- *********************************************************** -->
   <!-- Match: front-matter-part (BITS)
        1) cannot be empty 
     -->
   <xsl:template match="front-matter-part">
      <xsl:call-template name="empty-element-check"/>
      <xsl:apply-templates select="." mode="output"/>
    </xsl:template>    
    

   <!-- *********************************************************** -->
   <!-- Match: funding-group
			1) cannot be empty.
			-->
   <!-- *********************************************************** -->
   <xsl:template match="funding-group">   
      <xsl:call-template name="empty-element-check"/>
      <xsl:apply-templates select="." mode="output"/>
		</xsl:template>
			
   <!-- *********************************************************** -->
   <!-- Match: funding-source
			1) cannot be empty.
			2) @xlink:href cannot be empty.
			-->
   <!-- *********************************************************** -->
   <xsl:template match="funding-source">   
      <xsl:call-template name="empty-element-check"/>
		<xsl:call-template name="href-content-check"/>
      <xsl:apply-templates select="." mode="output"/>
		</xsl:template>

   <!-- *********************************************************** -->
   <!-- Match: funding-statement
			1) cannot be empty.
			2) @xlink:href cannot be empty.
			-->
   <!-- *********************************************************** -->
   <xsl:template match="funding-statement">   
      <xsl:call-template name="empty-element-check"/>
		<xsl:call-template name="href-content-check"/>
      <xsl:apply-templates select="." mode="output"/>
		</xsl:template>
			
			
   <!-- *********************************************************** -->
   <!-- Match: gloss-group
        1) cannot be empty 
     -->
   <!-- *********************************************************** -->
   <xsl:template match="gloss-group">
		<xsl:call-template name="empty-element-check"/>
		<xsl:apply-templates select="." mode="output"/>
		</xsl:template>


   <!-- *********************************************************** -->
   <!-- Match: glossary
        1) should not appear inside body
        2) cannot be empty
     -->
   <!-- *********************************************************** -->
   <xsl:template match="glossary">
		<xsl:call-template name="back-element-check"/>
		<xsl:call-template name="empty-element-check"/>
		<xsl:apply-templates select="." mode="output"/>
		</xsl:template>


   <!-- *********************************************************** -->
   <!-- Match: graphic
        1) check whether alt-version use is correct
        2) xlink:href cannot be empty
        
     -->
   <!-- *********************************************************** -->
   <xsl:template match="graphic">
		<xsl:call-template name="graphic-alt-version-check"/>
		<xsl:call-template name="href-content-check"/>
		<xsl:apply-templates select="." mode="output"/>
		</xsl:template>


   <!-- *********************************************************** -->
   <!-- Match: index (BITS)
        1) cannot be empty 
     -->
   <xsl:template match="index">
      <xsl:call-template name="empty-element-check"/>
      <xsl:apply-templates select="." mode="output"/>
    </xsl:template>    


   <!-- *********************************************************** -->
   <!-- Match: index-div (BITS)
        1) 
     -->
   <!--<xsl:template match="index-div">
      
      <xsl:apply-templates select="." mode="output"/>
    </xsl:template>-->    
    

   <!-- *********************************************************** -->
   <!-- Match: index-entry (BITS)
        1) 
     -->
   <!--<xsl:template match="index-entry">
      
      <xsl:apply-templates select="." mode="output"/>
    </xsl:template>-->   


   <!-- *********************************************************** -->
   <!-- Match: index-group (BITS)
        1) 
     -->
   <!--<xsl:template match="index-group">
      
      <xsl:apply-templates select="." mode="output"/>
    </xsl:template>-->    
    
    
  <!-- *********************************************************** -->
   <!-- Match: index-term (BITS)
        1) 
     -->
   <!--<xsl:template match="index-term">
      
      <xsl:apply-templates select="." mode="output"/>
    </xsl:template>-->   


  <!-- *********************************************************** -->
   <!-- Match: index-term-range-end (BITS)
        1) 
     -->
   <!--<xsl:template match="index-term-range-end">
     
      <xsl:apply-templates select="." mode="output"/>
    </xsl:template>-->    


  <!-- ********************************************* -->
   <!-- Match: inline-formula
        
        Tests:
 			  1) content should be one of 
			      -content in JATS emphasis elements and PCDATA, 
					 - one mml:math, or 
					 - one tex-math. 
					If more than one representation of the formula 
					is included, they must be tagged as alternatives 
					with the element (3.0+) or @alternate-form-of (2.3).                         -->
   <!-- ********************************************* -->   
	<xsl:template match="inline-formula">
     
		<xsl:call-template name="formula-content-test"/>
		
      <xsl:apply-templates select="." mode="output"/>
   </xsl:template>


   <!-- *********************************************************** -->
   <!-- Match: inline-graphic
        1) xlink:href cannot be empty
     -->
   <!-- *********************************************************** -->
   <xsl:template match="inline-graphic">
		<xsl:call-template name="href-content-check"/>
		<xsl:apply-templates select="." mode="output"/>
		</xsl:template>


   <!-- *********************************************************** -->
   <!-- Match: inline-supplementary-material
        1) xlink:href cannot be empty
     -->
   <!-- *********************************************************** -->
   <xsl:template match="inline-supplementary-material">
		<xsl:call-template name="href-content-check"/>
		<xsl:if test="@xlink:href">
	      <xsl:call-template name="href-ext-check">
 	        <xsl:with-param name="href" select="@xlink:href"/>
 	     </xsl:call-template>
		  </xsl:if> 
		<xsl:apply-templates select="." mode="output"/>
		</xsl:template>


   <!-- *********************************************************** -->
   <!-- Match: institution
        1) xlink:href cannot be empty
     -->
   <!-- *********************************************************** -->
   <xsl:template match="institution">
		<xsl:call-template name="href-content-check"/>
		<xsl:apply-templates select="." mode="output"/>
		</xsl:template>


   <!-- *********************************************************** -->
   <!-- Match: issn
        1) inside journal-meta, must have right form and required
           attributes 
        2) restrict pub-type values
     -->
   <!-- *********************************************************** -->
	<xsl:template match="issn">
		<xsl:call-template name="journal-meta-issn-check"/>
		<xsl:choose>
			<xsl:when test="ancestor::product or ancestor::citation or ancestor::element-citation
				 or ancestor::mixed-citation or ancestor::nlm-citation or $stream='manuscript'">
				<!-- Don't test these -->
			</xsl:when>
			<xsl:otherwise>
				<!-- Test 2 -->
				<xsl:call-template name="issn-pub-type-check">
					<xsl:with-param name="context" select="."/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:apply-templates select="." mode="output"/>
	</xsl:template>

   <!-- *********************************************************** -->
   <!-- Match: article-meta/issue|front-stub/issue
      1) Do not use <supplement> to tag <issue>
   -->
   <!-- *********************************************************** -->
   <xsl:template match="article-meta/supplement|front-stub/supplement">
      <xsl:if test="(child::text() and string-length(.) &lt; 25)
         or (title[not(preceding-sibling::*) and not(following-sibling::*)] and string-length(title) &lt; 25)
         or (bold[not(preceding-sibling::*) and not(following-sibling::*)] and string-length(bold) &lt; 25)
         or (italic[not(preceding-sibling::*) and not(following-sibling::*)] and string-length(italic) &lt; 25)
         ">
         <xsl:call-template name="supplemental-issue-check"/>
      </xsl:if>
      <xsl:apply-templates select="." mode="output"/>
   </xsl:template>

   <!-- *********************************************************** -->
   <!-- Match: issue-id
        1) if contains a DOI, must be correct format
     -->
   <!-- *********************************************************** -->
   <xsl:template match="issue-id">
		<xsl:if test="@pub-id-type = 'doi'">
			<xsl:call-template name="doi-check">
				<xsl:with-param name="value" select="."/>
				</xsl:call-template>
			</xsl:if>
		<xsl:apply-templates select="." mode="output"/>
		</xsl:template>
	
	
	<!-- *********************************************************** -->
	<!-- Match: issue
			1) cannot be empty.
			-->
	<!-- *********************************************************** -->
	<xsl:template match="issue">   
		<xsl:call-template name="empty-element-check"/>
		<xsl:apply-templates select="." mode="output"/>
	</xsl:template>

   <!-- *********************************************************** -->
   <!-- Match: issue-part
			1) cannot be empty.
			-->
   <!-- *********************************************************** -->
   <xsl:template match="issue-part">   
      <xsl:call-template name="empty-element-check"/>
      <xsl:apply-templates select="." mode="output"/>
		</xsl:template>
			
   <!-- *********************************************************** -->
   <!-- Match: issue-sponsor
			1) cannot be empty.
			-->
   <!-- *********************************************************** -->
   <xsl:template match="issue-sponsor">   
      <xsl:call-template name="empty-element-check"/>
      <xsl:apply-templates select="." mode="output"/>
		</xsl:template>
			
   <!-- *********************************************************** -->
   <!-- Match: journal-id
        1) Can't be empty and must have correct journal-id-type attribute
     -->
   <!-- *********************************************************** -->
	<xsl:template match="journal-id">
		<xsl:call-template name="journal-id-check"/>
		<xsl:apply-templates select="." mode="output"/>
		</xsl:template>


   <!-- *********************************************************** -->
   <!-- Match: journal-meta
        1) cannot be empty 
        2) Check if journal-title and issn are present 
     -->
   <!-- *********************************************************** -->
   <xsl:template match="journal-meta">
      <xsl:call-template name="empty-element-check"/>
      <xsl:call-template name="journal-meta-check"/>
      <xsl:apply-templates select="." mode="output"/>
		</xsl:template>

	<!-- *********************************************************** -->
	<!-- Match: kwd-group
        1) should have more than 1 kwd
     -->
	<!-- *********************************************************** -->
	<xsl:template match="kwd-group">
		<xsl:call-template name="kwd-group-check"/>
		<xsl:apply-templates select="." mode="output"/>
	</xsl:template>


   <!-- *********************************************************** -->
   <!-- Match: label
        1) content should not all be formatted
     -->
   <!-- *********************************************************** -->
   <xsl:template match="label">
      <xsl:call-template name="block-formatting-check"/>
      <xsl:apply-templates select="." mode="output"/>
   </xsl:template>


   <!-- *********************************************************** -->
   <!-- Match: license
        1) xlink:href cannot be empty
        2) license integrity check
     -->
   <!-- *********************************************************** -->
   <xsl:template match="license">
		<xsl:call-template name="href-content-check"/>
   		<xsl:call-template name="license-integrity-check">   			
   			<xsl:with-param name="context" select="."/>
   		</xsl:call-template>
		<xsl:apply-templates select="." mode="output"/>
		</xsl:template>

   <!-- *********************************************************** -->
   <!-- Match: license-p
			1) cannot be empty.
			-->
   <!-- *********************************************************** -->
   <xsl:template match="license-p">   
      <xsl:call-template name="empty-element-check"/>
      <xsl:apply-templates select="." mode="output"/>
		</xsl:template>
			
   <!-- *********************************************************** -->
   <!-- Match: list
        1) q-and-a list need to have correct content
        2) list-type attribute needs correct value
		  3) in books, lists may not have titles
		  4) in books, lists may not be referenced by xref
     -->
   <!-- *********************************************************** -->
   <xsl:template match="list">
    
		<xsl:call-template name="ms-stream-id-test"/>
  
      <xsl:call-template name="list-q-and-a-check"/>

      <xsl:call-template name="list-type-check"/>
              				
		<xsl:if test="$stream='book'">		  
		<!-- Test 4 -->
			<xsl:call-template name="check-for-xref">	
				<xsl:with-param name="context" select="."/>
				</xsl:call-template>
				<!--
			<xsl:if test="$editstyle='word'">
				<xsl:call-template name="list-title-check">
					<xsl:with-param name="context" select="."/>
					</xsl:call-template>
				</xsl:if>
				-->
			</xsl:if>
				  
      <xsl:apply-templates select="." mode="output"/>
   </xsl:template>
   

   <!-- *********************************************************** -->
   <!-- Match: list-item
        1) check content for disallowed children (like label)
		  2) in books, lists may not be referenced by xref
     -->
  <!-- ********************************************************************** -->
   <xsl:template match="list-item">
   
      <xsl:call-template name="list-item-content-check"/>
		
		<xsl:if test="$stream='book'">		  
			<xsl:call-template name="check-for-xref">	
				<xsl:with-param name="context" select="."/>
				</xsl:call-template>
			</xsl:if>
              
      <xsl:apply-templates select="." mode="output"/>
   </xsl:template>

   <!-- *********************************************************** -->
   <!-- Match: media
        1) xlink:href cannot be empty
     -->
   <!-- *********************************************************** -->
   <xsl:template match="media">
                 
      <xsl:call-template name="href-content-check"/>

      <xsl:apply-templates select="." mode="output"/>
   </xsl:template>
   
   <!-- *********************************************************** -->
   <!-- Match: mixed-citation
			1) cannot be empty.
			2) @xlink:href cannot be empty
			-->
   <!-- *********************************************************** -->
   <xsl:template match="mixed-citation">   
      <xsl:call-template name="empty-element-check"/>
		<xsl:call-template name="href-content-check"/>
      <xsl:apply-templates select="." mode="output"/>
		</xsl:template>
			

   <!-- *********************************************************** -->
   <!-- Match: mml:math
        1) cannot be empty 
        2) needs id 
		  3. cannot be just one character
     -->
   <!-- *********************************************************** -->
   <xsl:template match="mml:math">

      <xsl:call-template name="ms-stream-id-test"/>

      <xsl:call-template name="mathml-desc-text-check"/>

      <xsl:call-template name="mathml-id-check"/>
              
      <xsl:call-template name="mathml-top-level-el-check"/>

      <xsl:if test="@display">
         <xsl:call-template name="mml-attr-value-check">
            <xsl:with-param name="element-name" select="local-name(.)"/>
            <xsl:with-param name="attr-name" select="'display'"/>
            <xsl:with-param name="attr-value" select="concat('|',@display,'|')"/>
            <xsl:with-param name="attr-enumerated-values" select="
               '|block|inline|'"/>
         </xsl:call-template>
      </xsl:if>

	<xsl:apply-templates select="." mode="output"/>

   </xsl:template>

<!-- *********************************************************** -->
<!-- Match: mml:math//*
   1) check all descendant elements for deprecated attributes and elements
   2) mn should not follow itself. 2 mn elements in a row should be combined into 1 mn
   3) mtext should not follow itself, consecutive mtext should be combined into 1 mtext
   4) sub and superscripts must enclose the entire expression, not just the end fence.
   5) enforce MathML strict rules for child element counts
-->
<!-- *********************************************************** -->

   <xsl:template match="mml:math//*">

      <xsl:call-template name="mathml-depricate-atts-chk"/>
      <xsl:call-template name="mathml-nihms-specific"/>

      <!-- Enforce MathML Strict DTD Rules -->
      <xsl:if test="@mathvariant">
         <xsl:call-template name="mml-attr-value-check">
            <xsl:with-param name="element-name" select="local-name(.)"/>
            <xsl:with-param name="attr-name" select="'mathvariant'"/>
            <xsl:with-param name="attr-value" select="concat('|',@mathvariant,'|')"/>
            <xsl:with-param name="attr-enumerated-values" select="
               '|normal|bold|italic|bold-italic|double-struck|bold-fraktur|script|bold-script|fraktur|sans-serif|bold-sans-serif|sans-serif-italic|sans-serif-bold-italic|monospace|'"/>
         </xsl:call-template>
      </xsl:if>

      <xsl:if test="@numalign">
         <xsl:call-template name="mml-attr-value-check">
            <xsl:with-param name="element-name" select="local-name(.)"/>
            <xsl:with-param name="attr-name" select="'numalign'"/>
            <xsl:with-param name="attr-value" select="concat('|',@numalign,'|')"/>
            <xsl:with-param name="attr-enumerated-values" select="
               '|left|center|right|'"/>
            <xsl:with-param name="mult-values" select="0"/>
         </xsl:call-template>
      </xsl:if>      

      <xsl:if test="@denomalign">
         <xsl:call-template name="mml-attr-value-check">
            <xsl:with-param name="element-name" select="local-name(.)"/>
            <xsl:with-param name="attr-name" select="'denomalign'"/>
            <xsl:with-param name="attr-value" select="concat('|',@denomalign,'|')"/>
            <xsl:with-param name="attr-enumerated-values" select="
               '|left|center|right|'"/>
            <xsl:with-param name="mult-values" select="0"/>
         </xsl:call-template>
      </xsl:if> 

      <xsl:if test="@rowalign">
         <xsl:call-template name="mml-attr-value-check">
            <xsl:with-param name="element-name" select="local-name(.)"/>
            <xsl:with-param name="attr-name" select="'rowalign'"/>
            <xsl:with-param name="attr-value" select="concat('|',@rowalign,'|')"/>
            <xsl:with-param name="attr-enumerated-values" select="
               '|top|bottom|center|baseline|axis|'"/>
            <xsl:with-param name="mult-values" select="1"/>
         </xsl:call-template>
      </xsl:if>

      <xsl:if test="@columnalign">
<!--         <xsl:message>
            <xsl:text>&#xA;#########DEBUG#########&#xA;</xsl:text>
            <xsl:text>COLALIGN: </xsl:text>
            <xsl:value-of select="@columnalign"/>
            <xsl:text>&#xA;#########DEBUG#########&#xA;</xsl:text>
         </xsl:message>-->
         <xsl:call-template name="mml-attr-value-check">
            <xsl:with-param name="element-name" select="local-name(.)"/>
            <xsl:with-param name="attr-name" select="'columnalign'"/>
            <xsl:with-param name="attr-value" select="concat('|',@columnalign,'|')"/>
            <xsl:with-param name="attr-enumerated-values" select="
               '|left|right|center|'"/>
            <xsl:with-param name="mult-values" select="1"/>
         </xsl:call-template>
      </xsl:if>

      <xsl:if test="@groupalign">
         <xsl:call-template name="mml-attr-value-check">
            <xsl:with-param name="element-name" select="local-name(.)"/>
            <xsl:with-param name="attr-name" select="'groupalign'"/>
            <xsl:with-param name="attr-value" select="concat('|',@groupalign,'|')"/>
            <xsl:with-param name="attr-enumerated-values" select="
               '|left|right|center|decimalpoint|'"/>
            <xsl:with-param name="mult-values" select="1"/>
         </xsl:call-template>
      </xsl:if>

      <xsl:if test="@equalrows">
         <xsl:call-template name="mml-attr-value-check">
            <xsl:with-param name="element-name" select="local-name(.)"/>
            <xsl:with-param name="attr-name" select="'equalrows'"/>
            <xsl:with-param name="attr-value" select="concat('|',@equalrows,'|')"/>
            <xsl:with-param name="attr-enumerated-values" select="
               '|true|false|'"/>
         </xsl:call-template>
      </xsl:if>

      <xsl:if test="@equalcolumns">
         <xsl:call-template name="mml-attr-value-check">
            <xsl:with-param name="element-name" select="local-name(.)"/>
            <xsl:with-param name="attr-name" select="'equalcolumns'"/>
            <xsl:with-param name="attr-value" select="concat('|',@equalcolumns,'|')"/>
            <xsl:with-param name="attr-enumerated-values" select="
               '|true|false|'"/>
            <xsl:with-param name="mult-values" select="0"/>
         </xsl:call-template>
      </xsl:if>

      <xsl:if test="@bevelled">
         <xsl:call-template name="mml-attr-value-check">
            <xsl:with-param name="element-name" select="local-name(.)"/>
            <xsl:with-param name="attr-name" select="'bevelled'"/>
            <xsl:with-param name="attr-value" select="concat('|',@bevelled,'|')"/>
            <xsl:with-param name="attr-enumerated-values" select="
               '|true|false|'"/>
            <xsl:with-param name="mult-values" select="0"/>
         </xsl:call-template>
      </xsl:if>

      <xsl:if test="local-name(.) = 'mn'">
         <xsl:call-template name="mathml-repeated-element-check"/>
      </xsl:if>
      
      <xsl:if test="local-name(.) = 'mtext'">
         <xsl:call-template name="mathml-repeated-element-check">
            <xsl:with-param name="report-level" select="'warning'"/>
         </xsl:call-template>
      </xsl:if>

   <!-- BECK - turning off mathml-subsup-fence-check
	  <xsl:if test="local-name(.) = 'msup'
         or local-name(.) = 'msub'
         or local-name(.) = 'msubsup'">
         <xsl:call-template name="mathml-subsup-fence-check"/>   
      </xsl:if>  -->

      <xsl:if test="local-name(.) = 'mfrac'
         or local-name(.) = 'mroot'
         or local-name(.) = 'msub'
         or local-name(.) = 'msup'
         or local-name(.) = 'munder'
         or local-name(.) = 'mover'">
         <xsl:call-template name="mml-child-count-check">
            <xsl:with-param name="name" select="local-name(.)"/>
            <xsl:with-param name="child-count" select="2"/>
         </xsl:call-template>
      </xsl:if>
      
      <xsl:if test="local-name(.) = 'munderover'
         or local-name(.) = 'msubsup'">
         <xsl:call-template name="mml-child-count-check">
            <xsl:with-param name="name" select="local-name(.)"/>
            <xsl:with-param name="child-count" select="3"/>
         </xsl:call-template>
      </xsl:if>

      <xsl:if test="local-name(.) = 'semantics'">
         <xsl:call-template name="mathml-parent-el-check">
            <xsl:with-param name="expected-parent" select="'math'"/>
         </xsl:call-template>
      </xsl:if>

      <xsl:if test="local-name(.) = 'annotation'
         or local-name(.) = 'annotation-xml'">
         <xsl:call-template name="mathml-parent-el-check">
            <xsl:with-param name="expected-parent" select="'semantics'"/>
         </xsl:call-template>
      </xsl:if>

      <xsl:if test="local-name(.) = 'mprescripts'
         or local-name(.) = 'none'">
         <xsl:call-template name="mathml-parent-el-check">
            <xsl:with-param name="expected-parent" select="'mmultiscripts'"/>
         </xsl:call-template>
      </xsl:if>

    <!--   <xsl:if test="local-name(.) = 'mrow'">
         <xsl:call-template name="mathml-mrow-content-check"/>
       </xsl:if>  -->


      <xsl:apply-templates select="." mode="output"/>
   </xsl:template>

    <!-- *********************************************************** -->
   <!-- Match: monospace
        1) cannot be empty 
     -->
   <!-- *********************************************************** -->
   <xsl:template match="monospace">
   
      <xsl:call-template name="empty-element-check"/>
              
      <xsl:apply-templates select="." mode="output"/>
   </xsl:template>


   <!-- *********************************************************** -->
   <!-- Match: month
        1) cannot be empty 
        2) outside of citation, must have valid value 
     -->
   <!-- *********************************************************** -->
   <xsl:template match="month">
   
      <xsl:call-template name="empty-element-check"/>

      <xsl:call-template name="month-check"/>
              
      <xsl:apply-templates select="." mode="output"/>
   </xsl:template>


   <!-- *********************************************************** -->
   <!-- Match: name
        1) cannot be empty 
        2) if only given-names, name-style must be specified
     -->
   <!-- *********************************************************** -->
   <xsl:template match="name">   
      <xsl:call-template name="empty-element-check"/>
   	<xsl:call-template name="name-content-check">
   		<xsl:with-param name="context" select="."/>
   	</xsl:call-template>              
      <xsl:apply-templates select="." mode="output"/>
   </xsl:template>
	
	<!-- *********************************************************** -->
	<!-- Match: name-alternatives
		1) name-alternatives-content-check
	-->
	<!-- *********************************************************** -->
	<xsl:template match="name-alternatives">
		<xsl:call-template name="name-alternatives-content-check">
			<xsl:with-param name="context" select="."/>
		</xsl:call-template>
		<xsl:apply-templates select="." mode="output"/>
	</xsl:template>
	

   <!-- *********************************************************** -->
   <!-- Match: named-book-part-body (BITS)
        1) cannot be empty 
     -->
   <!-- *********************************************************** -->
   <xsl:template match="named-book-part-body">
      <xsl:call-template name="empty-element-check"/>
      <xsl:apply-templates select="." mode="output"/>
   </xsl:template>
   

   <!-- *********************************************************** -->
   <!-- Match: named-content
        1) cannot be empty 
        2) xlink:href cannot be empty
		  3) content-types for book should be in list ncbi_app, ncbi_class, ncbi_cmd, ncbi_code
		     ncbi_func, ncbi_lib, ncbi_macro, ncbi_monospace, ncbi_path, ncbi_type, ncbi_var

        
     -->
   <!-- *********************************************************** -->
   <xsl:template match="named-content">
   
      <xsl:call-template name="empty-element-check"/>

      <xsl:call-template name="href-content-check"/>
        
		 <xsl:if test="$stream='book'">

			<xsl:call-template name="named-content-type-check">
				<xsl:with-param name="context" select="."/>
				</xsl:call-template>
			</xsl:if>	 	  
      <xsl:apply-templates select="." mode="output"/>
   </xsl:template>
   
   
    <!-- *********************************************************** -->
   <!-- Match: nav-pointer (BITS)
        1) 
     -->
   <!-- *********************************************************** -->
   <!--<xsl:template match="nav-pointer">
  
      <xsl:apply-templates select="." mode="output"/>
   </xsl:template>-->
   
   
    <!-- *********************************************************** -->
   <!-- Match: nav-pointer-group (BITS)
        1) 
     -->
   <!-- *********************************************************** -->
   <!--<xsl:template match="nav-pointer-group">
  
      <xsl:apply-templates select="." mode="output"/>
   </xsl:template>-->   
   


   <!-- *********************************************************** -->
   <!-- Match: note
        1) cannot be empty 
     -->
   <!-- *********************************************************** -->
   <xsl:template match="note">
   
      <xsl:call-template name="empty-element-check"/>
              
      <xsl:apply-templates select="." mode="output"/>
   </xsl:template>


   <!-- *********************************************************** -->
   <!-- Match: notes
        1) should not appear in front (except as disclaimer) and
           not in body
        2) if a disclaimer, must be in front
        3) cannot be empty 
        4) note in proof should be in back
     -->
   <!-- *********************************************************** -->
   <xsl:template match="notes">
      <xsl:call-template name="back-element-check"/>
      <xsl:call-template name="disclaimer-notes-check"/>
      <xsl:call-template name="empty-element-check"/>
      <xsl:call-template name="notes-in-proof-check"/>
      <xsl:apply-templates select="." mode="output"/>
		</xsl:template>


   <!-- *********************************************************** -->
   <!-- Match: object-id
        1) if contains a doi, make sure is right format
        2) cannot be empty
     -->
   <!-- *********************************************************** -->
   <xsl:template match="object-id">
      <xsl:call-template name="empty-element-check"/>
      <xsl:if test="@pub-id-type = 'doi'">
         <xsl:call-template name="doi-check">
            <xsl:with-param name="value" select="."/>
         	</xsl:call-template>
      	</xsl:if>
      <xsl:apply-templates select="." mode="output"/>
		</xsl:template>

   <!-- *********************************************************** -->
   <!-- Match: open-access
			1) cannot be empty.
			2) If this element is in the document, a <license> must 
			   also be present.
			Note: this is a 3.0 test.
			-->
   <!-- *********************************************************** -->
   <xsl:template match="open-access">   
      <xsl:call-template name="empty-element-check"/>
		<xsl:call-template name="oa-license-present"/>
      <xsl:apply-templates select="." mode="output"/>
		</xsl:template>
			
   <!-- *********************************************************** -->
   <!-- Match: overline
        1) cannot be empty 
     -->
   <!-- *********************************************************** -->
   <xsl:template match="overline">
      <xsl:call-template name="empty-element-check"/>
       <xsl:apply-templates select="." mode="output"/>
		</xsl:template>


   <!-- *********************************************************** -->
   <!-- Match: p
        1) when child of caption and abstract, content should not
           all be formatted 
        
        2) cannot be empty
     -->
   <!-- *********************************************************** -->
   <xsl:template match="p">

      <xsl:if test="ancestor::abs or ancestor::body or ancestor::app">
			<xsl:call-template name="ms-stream-id-test"/>
			</xsl:if>
   
      <xsl:if test="parent::abstract or parent::caption">
         <xsl:call-template name="block-formatting-check">
            <xsl:with-param name="context" select="."/>
         	</xsl:call-template>
      	</xsl:if>
              
      <xsl:call-template name="empty-element-check"/>

      <xsl:apply-templates select="." mode="output"/>
   </xsl:template>



   <!-- *********************************************************** -->
   <!-- Match: page-range
        1) cannot be empty 
     -->
   <!-- *********************************************************** -->
   <xsl:template match="page-range">
		<xsl:call-template name="empty-element-check"/>
		<xsl:apply-templates select="." mode="output"/>
		</xsl:template>


   <!-- *********************************************************** -->
   <!-- Match: patent
        1) cannot be empty 
     -->
   <!-- *********************************************************** -->
   <xsl:template match="patent">
      <xsl:call-template name="empty-element-check"/>
      <xsl:apply-templates select="." mode="output"/>
		</xsl:template>
   

   <!-- *********************************************************** -->
   <!-- Match: person-group
        1) cannot be empty 
     -->
   <!-- *********************************************************** -->
   <xsl:template match="person-group">
      <xsl:call-template name="empty-element-check"/>
      <xsl:apply-templates select="." mode="output"/>
		</xsl:template>
   

   <!-- *********************************************************** -->
   <!-- Match: phone
        1) cannot be empty 
     -->
   <!-- *********************************************************** -->
   <xsl:template match="phone">
      <xsl:call-template name="empty-element-check"/>
      <xsl:apply-templates select="." mode="output"/>
		</xsl:template>
		
		
   <!-- *********************************************************** -->
   <!-- Match: preface (BITS)
        1) cannot be empty 
     -->
   <!-- *********************************************************** -->
   <xsl:template match="preface">
      <xsl:call-template name="empty-element-check"/>
      <xsl:apply-templates select="." mode="output"/>
		</xsl:template>
   

   <!-- *********************************************************** -->
   <!-- Match: prefix
        1) cannot be empty 
     -->
   <!-- *********************************************************** -->
   <xsl:template match="prefix">
      <xsl:call-template name="empty-element-check"/>
      <xsl:apply-templates select="." mode="output"/>
		</xsl:template>
   

   <!-- *********************************************************** -->
   <!-- Match: preformat
        1) cannot be empty 
		  2) in books cannot have lines > 76 chars 
     -->
   <!-- *********************************************************** -->
   <xsl:template match="preformat">
   
      <xsl:call-template name="empty-element-check"/>

		<!--<xsl:if test="$editstyle='word' and $stream='book'">      
			<xsl:call-template name="preformat-line-length-check">
				<xsl:with-param name="context" select="."/>
				</xsl:call-template>
			</xsl:if>-->
              
      <xsl:apply-templates select="." mode="output"/>
   </xsl:template>
   
   <!-- *********************************************************** -->
   <!-- Match: principal-award-recipient
			1) cannot be empty.
			-->
   <!-- *********************************************************** -->
   <xsl:template match="principal-award-recipient">   
      <xsl:call-template name="empty-element-check"/>
      <xsl:apply-templates select="." mode="output"/>
		</xsl:template>
			
   <!-- *********************************************************** -->
   <!-- Match: principal-investigator
			1) cannot be empty.
			-->
   <!-- *********************************************************** -->
   <xsl:template match="principal-investigator">   
      <xsl:call-template name="empty-element-check"/>
      <xsl:apply-templates select="." mode="output"/>
		</xsl:template>
			

   <!-- *********************************************************** -->
   <!-- Match: private-char
        1) cannot be empty 
     -->
   <!-- *********************************************************** -->
   <xsl:template match="private-char">
      <xsl:call-template name="empty-element-check"/>
      <xsl:apply-templates select="." mode="output"/>
		</xsl:template>
   

   <!-- *********************************************************** -->
   <!-- Match: product
        1) cannot be empty 
        2) xlink:href cannot be empty
     -->
   <!-- *********************************************************** -->
   <xsl:template match="product">
      <xsl:call-template name="empty-element-check"/>
      <xsl:call-template name="href-content-check"/>
		<xsl:apply-templates select="." mode="output"/>
		</xsl:template>

   <!-- *********************************************************** -->
   <!-- Match: pub-date
        1) cannot be empty 
        2) cannot duplicate electronic or print pub-ddate
        3) must be valid date
        4) restrict pub-type attribute values
     -->
   <!-- *********************************************************** -->
	<xsl:template match="pub-date">
		<xsl:call-template name="empty-element-check"/>
		<xsl:call-template name="dup-pub-date-check">
			<xsl:with-param name="context" select="."/>			
		</xsl:call-template>
		<xsl:call-template name="pub-date-conflict-check">
			<xsl:with-param name="context" select="."/>
		</xsl:call-template>
		<xsl:call-template name="pub-date-content-check">
			<xsl:with-param name="context" select="."/>
		</xsl:call-template>
		<xsl:apply-templates select="." mode="output"/>
	</xsl:template>


   <!-- *********************************************************** -->
   <!-- Match: pub-id
        1) if contains doi, must be right format
		     BECK - not taking responsibility for DOIs in reflist
        2) cannot be empty 
        3) pub-id-type attribute must have approved value
     -->
   <!-- *********************************************************** -->
   <xsl:template match="pub-id">
   
      <xsl:if test="@pub-id-type = 'doi'">
         <xsl:call-template name="doi-check">
            <xsl:with-param name="value" select="."/>
         </xsl:call-template>
      </xsl:if>

      <xsl:call-template name="empty-element-check"/>

      <xsl:call-template name="pub-id-check"/>

      <xsl:apply-templates select="." mode="output"/>
   </xsl:template>

   <!-- *********************************************************** -->
   <!-- Match: publisher
        1) cannot be empty 
     -->
   <!-- *********************************************************** -->
   <xsl:template match="publisher">
      <xsl:call-template name="empty-element-check"/>
      <xsl:apply-templates select="." mode="output"/>
		</xsl:template>


   <!-- *********************************************************** -->
   <!-- Match: publisher-loc
        1) cannot be empty 
     -->
   <!-- *********************************************************** -->
   <xsl:template match="publisher-loc">
      <xsl:call-template name="empty-element-check"/>
      <xsl:apply-templates select="." mode="output"/>
		</xsl:template>
   

   <!-- *********************************************************** -->
   <!-- Match: publisher-name
        1) cannot be empty 
     -->
   <!-- *********************************************************** -->
   <xsl:template match="publisher-name">
      <xsl:call-template name="empty-element-check"/>
      <xsl:apply-templates select="." mode="output"/>
		</xsl:template>


   <!-- *********************************************************** -->
   <!-- Match: question (BITS)
        1) cannot be empty 
     -->
   <!-- *********************************************************** -->
   <xsl:template match="question">
      <xsl:call-template name="empty-element-check"/>
      <xsl:apply-templates select="." mode="output"/>
    </xsl:template>
    
     
   <!-- *********************************************************** -->
   <!-- Match: question-preamble (BITS2)
     -->
   <!-- *********************************************************** -->
   <!--<xsl:template match="question-preamble">      
      <xsl:apply-templates select="." mode="output"/>
    </xsl:template>-->
    
    
   <!-- *********************************************************** -->
   <!-- Match: question-preamble (BITS2)
     -->
   <!-- *********************************************************** -->
   <!--<xsl:template match="question-preamble">      
      <xsl:apply-templates select="." mode="output"/>
    </xsl:template>-->
    
    
   <!-- *********************************************************** -->
   <!-- Match: question-wrap-group (BITS2)
     -->
   <!-- *********************************************************** -->
   <!--<xsl:template match="question-wrap-group">      
      <xsl:apply-templates select="." mode="output"/>
    </xsl:template>-->
		

   <!-- *********************************************************** -->
   <!-- Match: ref
        1) cannot be empty 
        2) must have id
     -->
   <!-- *********************************************************** -->
   <xsl:template match="ref">
		<xsl:call-template name="ms-stream-id-test"/>
      <xsl:call-template name="empty-element-check"/>
      <xsl:call-template name="ref-check"/>
      <xsl:apply-templates select="." mode="output"/>
		</xsl:template>


  <!-- ********************************************************************* -->
   <!-- Match: ref-list
        1) cannot be empty 
     -->
   <!-- *********************************************************** -->
   <xsl:template match="ref-list">
      <xsl:call-template name="empty-element-check"/>
      <xsl:apply-templates select="." mode="output"/>
		</xsl:template>


   <!-- *********************************************************** -->
   <!-- Match: related-article
        1) Make sure the related-article-type matches the article-type attribute 
        2) if contains a doi, must be correct format
        3) requires certain attributes and attribute values
        4) 
        5) xlink:href cannot be empty
        6) if @xlink:href is a doi, @ext-link-type must be "doi"
       -->
   <!-- *********************************************************** -->
   <xsl:template match="related-article">
   
      <xsl:call-template name="related-article-to-article-type-attribute"/>
      
      <!-- Test 2-->
      <xsl:if test="@ext-link-type = 'doi'">
         <xsl:call-template name="doi-check">
            <xsl:with-param name="value" select="@xlink:href"/>
         	</xsl:call-template>
      	</xsl:if>
      
      <!-- Test 3-->
      <xsl:call-template name="related-article-check"/>
   	
   	
		<!-- Test 4 -->
		<xsl:if test="$stream='manuscript'">
			<xsl:call-template name="ms-related-article-check"/>
		</xsl:if>
   	
	<!-- Test 5 -->
      <xsl:call-template name="href-content-check"/>
   	
   	<!-- Test 6 -->
   	<xsl:if test="starts-with(@xlink:href,'10.')">
   		<xsl:call-template name="related-article-xlink-extlinktype-check"/>
   	</xsl:if>
   	
   	<!-- Test 7 -->
   	<xsl:call-template name="related-article-self-test"/>
              
      <xsl:apply-templates select="." mode="output"/>
   </xsl:template>
   

   <!-- *********************************************************** -->
   <!-- Match: related-object
        1) Make sure the ids and id-types attributes are paired 
        -->
   <!-- *********************************************************** -->
   <xsl:template match="related-object">
		<xsl:choose>
         <xsl:when test="$stream='book'"/>
			<xsl:otherwise>
				<xsl:call-template name="related-object-check"/> 
 				</xsl:otherwise>
			</xsl:choose>
      <xsl:if test="@source-id-type = 'doi'">
         <xsl:call-template name="doi-check">
            <xsl:with-param name="value" select="@source-id"/>
         	</xsl:call-template>
      	</xsl:if>
      <xsl:if test="@document-id-type = 'doi'">
         <xsl:call-template name="doi-check">
            <xsl:with-param name="value" select="@document-id"/>
         	</xsl:call-template>
      	</xsl:if>
      <xsl:if test="@object-id-type = 'doi'">
         <xsl:call-template name="doi-check">
            <xsl:with-param name="value" select="@object-id"/>
         	</xsl:call-template>
      	</xsl:if>
   	<xsl:if test="@document-type='article'">
   		<xsl:call-template name="related-article-to-article-type-attribute"/>
   	</xsl:if>
      <xsl:apply-templates select="." mode="output"/>
   </xsl:template>
   


   <!-- *********************************************************** -->
   <!-- Match: response
        Manuscripts: 
        1) Cannot be present
        
        Non-manuscripts:
        1) Cannot be empty
        2) Must have @id
        3) Must have @response-type | @article-type
        4) DOI should not be the same as the parent article
     -->
   <!-- *********************************************************** -->
   <xsl:template match="response | sub-article">
     	<xsl:choose>
   		<xsl:when test="$stream='manuscript'">
	      <xsl:call-template name="make-error">
				<xsl:with-param name="error-type" select="'illegal child'"/>
   	      	<xsl:with-param name="description">
      	      <xsl:text>&lt;</xsl:text>
					<xsl:value-of select="name()"/>
					<xsl:text>&gt; should not be used in a manuscript</xsl:text>
         		</xsl:with-param>
      		</xsl:call-template>
   		</xsl:when>
     		<xsl:otherwise>  	
   			<xsl:call-template name="empty-element-check"/>
			<xsl:call-template name="id-present-test"/>
			<xsl:call-template name="attribute-present-not-empty">
				<xsl:with-param name="attribute-name">
					<xsl:choose>
						<xsl:when test="local-name(.)='response'">
							<xsl:text>response-type</xsl:text>
						</xsl:when>
						<xsl:otherwise>
							<xsl:text>article-type</xsl:text>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:with-param>
			</xsl:call-template>
     			<xsl:if test="front/article-meta/article-id[@pub-id-type='doi'] | front-stub/article-id[@pub-id-type='doi']">
   				<xsl:call-template name="subarticle-doi-check">
   					<xsl:with-param name="my-doi" 
   					select="front/article-meta/article-id[@pub-id-type='doi'] | front-stub/article-id[@pub-id-type='doi']"/>
   					<xsl:with-param name="parent-doi"
   						select="/article/front/article-meta/article-id[@pub-id-type='doi']"/>
   				</xsl:call-template>
   			</xsl:if>
   		</xsl:otherwise>
     	</xsl:choose>   	
      <xsl:apply-templates select="." mode="output"/>
   </xsl:template>
   

   <!-- *********************************************************** -->
   <!-- Match: role
        1) cannot be empty 
     -->
   <!-- *********************************************************** -->
   <xsl:template match="role">
      <xsl:call-template name="empty-element-check"/>
      <xsl:apply-templates select="." mode="output"/>
		</xsl:template>
   
   <!-- *********************************************************** -->
   <!-- Match: roman
        1) cannot be empty 
     -->
   <!-- *********************************************************** -->
   <xsl:template match="roman">
      <xsl:call-template name="empty-element-check"/>
      <xsl:apply-templates select="." mode="output"/>
		</xsl:template>
   

   <!-- *********************************************************** -->
   <!-- Match: sc
        1) cannot be empty 
     -->
   <!-- *********************************************************** -->
   <xsl:template match="sc">
		<xsl:call-template name="empty-element-check"/>
		<xsl:apply-templates select="." mode="output"/>
		</xsl:template>


   <!-- *********************************************************** -->
   <!-- Match: season
        1) cannot be empty 
        2) must have valid form
     -->
   <!-- *********************************************************** -->
   <xsl:template match="season">
      <xsl:call-template name="empty-element-check"/>
      <xsl:call-template name="season-check"/>
      <xsl:apply-templates select="." mode="output"/>
		</xsl:template>


   <!-- *********************************************************** -->
   <!-- Match: sec
        1) if a display-objects sec, must conform to rules
        2) cannot be empty 
        3) first-level secs need to have correct sec-type
     -->
   <!-- *********************************************************** -->
   <xsl:template match="sec">
   
		<xsl:call-template name="ms-stream-id-test"/>
		
      <xsl:call-template name="display-object-sec-check"/>

      <xsl:call-template name="empty-element-check"/>
      
      <xsl:if test="$stream='manuscript'">
			<xsl:call-template name="ms-abstract-sec-type-test"/>
			<xsl:call-template name="ms-extended-data-sec-test"/>
      	</xsl:if>
      
     <!-- As of 2015-07-21 we no longer enforce @sec-type values on first level sections.
	  <xsl:choose>
         <xsl:when test="$stream='book' or $stream='rrn'"/>
         <xsl:otherwise>
            <xsl:call-template name="sec-type-check"/>
         </xsl:otherwise>
      </xsl:choose> -->
              
      <xsl:apply-templates select="." mode="output"/>
   </xsl:template>
   
   
   <!-- *********************************************************** -->
   <!-- Match: see (BITS)
        1) 
     -->
   <!-- *********************************************************** -->
   <!--<xsl:template match="see">
  
      <xsl:apply-templates select="." mode="output"/>
   </xsl:template>-->
   
   
   <!-- *********************************************************** -->
   <!-- Match: see-also (BITS)
        1) 
     -->
   <!-- *********************************************************** -->
   <!--<xsl:template match="see-also">
  
      <xsl:apply-templates select="." mode="output"/>
   </xsl:template>-->
   
 
    <!-- *********************************************************** -->
   <!-- Match: see-also-entry (BITS)
        1) 
     -->
   <!-- *********************************************************** -->
   <!--<xsl:template match="see-also-entry">
  
      <xsl:apply-templates select="." mode="output"/>
   </xsl:template>-->
   
   
      <!-- *********************************************************** -->
   <!-- Match: see-entry (BITS)
        1) 
     -->
   <!-- *********************************************************** -->
   <!--<xsl:template match="see-entry">
  
      <xsl:apply-templates select="." mode="output"/>
   </xsl:template>-->
   
 
  <!-- ********************************************************************* -->
   <!-- Match: self-uri
        1) xlink:href cannot be empty
     -->
   <!-- *********************************************************** -->
   <xsl:template match="self-uri">
      <xsl:call-template name="href-content-check"/>
      <xsl:apply-templates select="." mode="output"/>
		</xsl:template>


   <!-- *********************************************************** -->
   <!-- Match: series
        1) cannot be empty 
     -->
   <!-- *********************************************************** -->
   <xsl:template match="series">
      <xsl:call-template name="empty-element-check"/>
      <xsl:apply-templates select="." mode="output"/>
		</xsl:template>
   

   <!-- *********************************************************** -->
   <!-- Match: series-text
        1) cannot be empty 
     -->
   <!-- *********************************************************** -->
   <xsl:template match="series-text">
      <xsl:call-template name="empty-element-check"/>
      <xsl:apply-templates select="." mode="output"/>
		</xsl:template>
   

   <!-- *********************************************************** -->
   <!-- Match: series-title
        1) cannot be empty 
     -->
   <!-- *********************************************************** -->
   <xsl:template match="series-title">
      <xsl:call-template name="empty-element-check"/>
      <xsl:apply-templates select="." mode="output"/>
		</xsl:template>


   <!-- *********************************************************** -->
   <!-- Match: source
        1) cannot be empty 
     -->
   <!-- *********************************************************** -->
	<xsl:template match="source">
		<xsl:call-template name="empty-element-check"/>
		<xsl:apply-templates select="." mode="output"/>
		</xsl:template>
   

   <!-- *********************************************************** -->
   <!-- Match: speaker
        1) cannot be empty 
     -->
   <!-- *********************************************************** -->
   <xsl:template match="speaker">
		<xsl:call-template name="empty-element-check"/>
		<xsl:apply-templates select="." mode="output"/>
		</xsl:template>
   

   <!-- *********************************************************** -->
   <!-- Match: speech
        1) cannot be empty 
     -->
   <!-- *********************************************************** -->
   <xsl:template match="speech">
		<xsl:call-template name="empty-element-check"/>
		<xsl:apply-templates select="." mode="output"/>
		</xsl:template>
   

   <!-- *********************************************************** -->
   <!-- Match: statement
        1) cannot be empty 
     -->
   <!-- *********************************************************** -->
   <xsl:template match="statement">
      <xsl:call-template name="empty-element-check"/>
      <xsl:apply-templates select="." mode="output"/>
		</xsl:template>
   

   <!-- *********************************************************** -->
   <!-- Match: std
        1) cannot be empty 
     -->
   <!-- *********************************************************** -->
   <xsl:template match="std">
      <xsl:call-template name="empty-element-check"/>
      <xsl:apply-templates select="." mode="output"/>
		</xsl:template>
   

   <!-- *********************************************************** -->
   <!-- Match: strike
        1) cannot be empty 
     -->
   <!-- *********************************************************** -->
   <xsl:template match="strike">
      <xsl:call-template name="empty-element-check"/>
      <xsl:apply-templates select="." mode="output"/>
		</xsl:template>
   
   <!-- *********************************************************** -->
   <!-- Match: string-conference
        1) may not contain a child string-conference 
     -->
   <!-- *********************************************************** -->
   <xsl:template match="string-conf">
      <xsl:call-template name="string-conf-element-check"/>
      <xsl:apply-templates select="." mode="output"/>
		</xsl:template>
   

   <!-- *********************************************************** -->
   <!-- Match: string-date
        1) cannot be empty 
        2) Values cannot have been tagged as regular date elements
		  3) IS NOT ALLOWED
     -->
   <!-- *********************************************************** -->
   <xsl:template match="string-date">
      <xsl:call-template name="empty-element-check"/>
		<xsl:if test="not(preceding-sibling::year)">   
			<xsl:call-template name="make-error">
             <xsl:with-param name="error-type">date content check</xsl:with-param>
             <xsl:with-param name="description">
                 <xsl:text>All dates must contain parsed content. &lt;string-date&gt; is not allowed.</xsl:text>
             	</xsl:with-param>
				</xsl:call-template>
			</xsl:if>
		<xsl:apply-templates select="." mode="output"/>
		</xsl:template>
   

   <!-- *********************************************************** -->
   <!-- Match: string-name
        1) cannot be empty 
        2) must not have multiple name components
     -->
   <!-- *********************************************************** -->
   <xsl:template match="string-name">
      <xsl:call-template name="empty-element-check"/>
   	<xsl:call-template name="string-name-content-check"/>
      <xsl:apply-templates select="." mode="output"/>
		</xsl:template>
   

   <!-- *********************************************************** -->
   <!-- Match: sub
        1) cannot be empty 
     -->
   <!-- *********************************************************** -->
   <xsl:template match="sub">
      <xsl:call-template name="empty-element-check"/>
      <xsl:apply-templates select="." mode="output"/>
		</xsl:template>
   

   <!-- *********************************************************** -->
   <!-- Match: subj-group
        1) cannot be empty 
        2) heading type subj-group can only have a 
           single subject; should only have a single
           heading type subj-group
           
     -->
   <!-- *********************************************************** -->
   <xsl:template match="subj-group">
      <xsl:call-template name="empty-element-check"/>
      <xsl:call-template name="subj-group-check"/>
      <xsl:apply-templates select="." mode="output"/>
		</xsl:template>
   

   <!-- *********************************************************** -->
   <!-- Match: subject
        1) cannot be empty 
		  2) only allows formatting <italic>, <sub>, <sup>
		  3) does not allow the use of <xref>
     -->
   <!-- *********************************************************** -->
   <xsl:template match="subject">
   
      <xsl:call-template name="empty-element-check"/>

     <xsl:if test="bold
                or monospace
                or overline
                or sc
                or strike
                or underline">
        <xsl:call-template name="make-error">
             <xsl:with-param name="error-type">subject content check</xsl:with-param>
            <xsl:with-param name="description">
                <xsl:text>&lt;subject&gt; cannot contain emphasis elements</xsl:text>
            </xsl:with-param>
        </xsl:call-template>
     </xsl:if>

     <xsl:if test="xref">
        <xsl:call-template name="make-error">
             <xsl:with-param name="error-type">subject content check</xsl:with-param>
            <xsl:with-param name="description">
                <xsl:text>subject should not contain xref element</xsl:text>
            </xsl:with-param>
        </xsl:call-template>
     </xsl:if>
              
      <xsl:apply-templates select="." mode="output"/>
   </xsl:template>
   

   <!-- *********************************************************** -->
   <!-- Match: subtitle
        1) should not contain fn
        
        2) If there is an xref pointing to a fn,
           then the fn should be set in back/fn-group
        
        3) outside of citation and product, content should not
           all be formatted
        
        4) cannot be empty    
        
     -->
   <!-- *********************************************************** -->
   <xsl:template match="subtitle">
		<xsl:if test="ancestor::*[not(self::citation) and not(self::product) 
			and not(self::element-citation) and not(self::mixed-citation) and not(self::nlm-citation)]">
         <xsl:call-template name="block-formatting-check">
            <xsl:with-param name="context" select="."/>
         	</xsl:call-template>
      	</xsl:if>
		<xsl:call-template name="empty-element-check"/>
      <xsl:apply-templates select="." mode="output"/>
		</xsl:template>

   <!-- *********************************************************** -->
   <!-- Match: suffix
        1) cannot be empty 
     -->
   <!-- *********************************************************** -->
   <xsl:template match="suffix">
      <xsl:call-template name="empty-element-check"/>
      <xsl:apply-templates select="." mode="output"/>
		</xsl:template>
   

   <!-- *********************************************************** -->
   <!-- Match: sup
        1) cannot be empty 
     -->
   <!-- *********************************************************** -->
   <xsl:template match="sup">
      <xsl:call-template name="empty-element-check"/>
      <xsl:apply-templates select="." mode="output"/>
		</xsl:template>
   

   <!-- *********************************************************** -->
   <!-- Match: supplement
        1) cannot be empty 
     -->
   <!-- *********************************************************** -->
   <xsl:template match="supplement">
      <xsl:call-template name="empty-element-check"/>
      <xsl:apply-templates select="." mode="output"/>
		</xsl:template>
   

   <!-- *********************************************************** -->
   <!-- Match: supplementary-material
        1) xlink:href cannot be empty
        2) @xlink:href on graphic, media, or supplementary-material elements must have file extension
     -->
   <!-- *********************************************************** -->
   <xsl:template match="supplementary-material">
 		<xsl:call-template name="ms-stream-id-test"/>
      <xsl:call-template name="href-content-check"/>

      <xsl:choose>
         <xsl:when test="graphic[@xlink:href]">
            <xsl:call-template name="href-ext-check">
               <xsl:with-param name="href" select="graphic/@xlink:href"/>
            </xsl:call-template>
         </xsl:when>
         <xsl:when test="media[@xlink:href]">
            <xsl:call-template name="href-ext-check">
               <xsl:with-param name="href" select="media/@xlink:href"/>
            </xsl:call-template>
         </xsl:when>
         <xsl:when test="@xlink:href">
            <xsl:call-template name="href-ext-check">
               <xsl:with-param name="href" select="@xlink:href"/>
            </xsl:call-template>
         </xsl:when>
      </xsl:choose>
      
      <xsl:apply-templates select="." mode="output"/>
		</xsl:template>


   <!-- *********************************************************** -->
   <!-- Match: surname
        1) cannot be empty 
     -->
   <!-- *********************************************************** -->
   <xsl:template match="surname">
      <xsl:call-template name="empty-element-check"/>
      <xsl:apply-templates select="." mode="output"/>
	</xsl:template>
   

   <!-- *********************************************************** -->
   <!-- Match: table
        1) cannot be empty 
     -->
   <!-- *********************************************************** -->
   <xsl:template match="table">
      <xsl:call-template name="empty-element-check"/>
      <xsl:apply-templates select="." mode="output"/>
		</xsl:template>
   

   <!-- *********************************************************** -->
   <!-- Match: table-wrap
        1) cannot be empty 
        		  
	2) in books, figs in boxed-text may not be referenced
     -->
   <!-- *********************************************************** -->
   <xsl:template match="table-wrap">
 
		<xsl:call-template name="ms-stream-id-test"/>
 
      <xsl:call-template name="empty-element-check"/>

	  <xsl:if test="$stream='book' and ancestor::boxed-text">		  
			<xsl:call-template name="check-for-xref">	
				<xsl:with-param name="context" select="."/>
				<xsl:with-param name="inbox" select="'yes'"/>
				</xsl:call-template>
	  </xsl:if>
    <!-- Check for a cross-reference to a floating table. -->  
    <!-- <xsl:if test="$stream='book' and @position!='anchor' and not(ancestor::boxed-text)">		  
		   <xsl:call-template name="float-obj-check">	
				 <xsl:with-param name="context" select="."/>
			 </xsl:call-template>
		 </xsl:if>-->
              
      <xsl:apply-templates select="." mode="output"/>
   </xsl:template>


   <!-- *********************************************************** -->
   <!-- Match: table-wrap-foot
        1) cannot be empty 
     -->
   <!-- *********************************************************** -->
   <xsl:template match="table-wrap-foot">   
      <xsl:call-template name="empty-element-check"/>
              
      <xsl:apply-templates select="." mode="output"/>
   </xsl:template>
   

   <!-- *********************************************************** -->
   <!-- Match: table-wrap-group
        1) cannot be empty 
        
        2) in books, figs in boxed-text may not be referenced
     -->
   <!-- *********************************************************** -->
   <xsl:template match="table-wrap-group">
      <xsl:call-template name="empty-element-check"/>
      
		<xsl:if test="$stream='book' and ancestor::boxed-text">		  
			<xsl:call-template name="check-for-xref">	
				<xsl:with-param name="context" select="."/>
				<xsl:with-param name="inbox" select="'yes'"/>
				</xsl:call-template>
			</xsl:if>
			
		<xsl:if test="$stream='manuscript'">
			<xsl:call-template name="make-error">
				<xsl:with-param name="error-type" select="'element not allowed'"/>
       	  <xsl:with-param name="description">
            	<xsl:text>table-wrap-group not allowed. All tables should be tagged as 
            	individual table-wrap elements without a group.</xsl:text>
         		</xsl:with-param>
				</xsl:call-template>
			</xsl:if>
			
		
              
      <xsl:apply-templates select="." mode="output"/>
   </xsl:template>
   

   <!-- *********************************************************** -->
   <!-- Match: target
        1) cannot be empty 
     -->
   <!-- *********************************************************** -->
   <xsl:template match="target">
      <!-- <xsl:call-template name="empty-element-check"/>  -->
      <xsl:apply-templates select="." mode="output"/>
		</xsl:template>
   

   <!-- *********************************************************** -->
   <!-- Match: tbody
        1) cannot be empty 
     -->
   <!-- *********************************************************** -->
   <xsl:template match="tbody">
      <xsl:call-template name="empty-element-check"/>
      <xsl:apply-templates select="." mode="output"/>
		</xsl:template>
   

   <!-- *********************************************************** -->
   <!-- Match: term
        1) cannot be empty 
     -->
   <!-- *********************************************************** -->
   <xsl:template match="term">
      <xsl:call-template name="empty-element-check"/>
       <xsl:apply-templates select="." mode="output"/>
		</xsl:template>
   

   <!-- *********************************************************** -->
   <!-- Match: term-head
        1) cannot be empty 
     -->
   <!-- *********************************************************** -->
   <xsl:template match="term-head">
      <xsl:call-template name="empty-element-check"/>
      <xsl:apply-templates select="." mode="output"/>
		</xsl:template>
   

   <!-- *********************************************************** -->
   <!-- Match: tex-math
        1) cannot be empty 
     -->
   <!-- *********************************************************** -->
   <xsl:template match="tex-math">
		<xsl:call-template name="empty-element-check"/>
      <xsl:call-template name="tex-math-id-check"/>
		<xsl:call-template name="tex-math-content-check"/>
      <xsl:apply-templates select="." mode="output"/>
		</xsl:template>
   
   <!-- *********************************************************** -->
   <!-- Match: textual-form
        1) cannot be empty 
     -->
   <!-- *********************************************************** -->
   <xsl:template match="textual-form">
      <xsl:call-template name="empty-element-check"/>
      <xsl:apply-templates select="." mode="output"/>
		</xsl:template>
   

   <!-- *********************************************************** -->
   <!-- Match: tfoot
        1) cannot be empty 
     -->
   <!-- *********************************************************** -->
   <xsl:template match="tfoot">
   
      <xsl:call-template name="empty-element-check"/>
              
      <xsl:apply-templates select="." mode="output"/>
   </xsl:template>
   

   <!-- *********************************************************** -->
   <!-- Match: thead
        1) cannot be empty 
     -->
   <!-- *********************************************************** -->
   <xsl:template match="thead">
   
      <xsl:call-template name="empty-element-check"/>
              
      <xsl:apply-templates select="." mode="output"/>
   </xsl:template>
   

   <!-- *********************************************************** -->
   <!-- Match: time-stamp
        1) cannot be empty 
     -->
   <!-- *********************************************************** -->
   <xsl:template match="time-stamp">
   
      <xsl:call-template name="empty-element-check"/>
              
      <xsl:apply-templates select="." mode="output"/>
   </xsl:template>


   <!-- *********************************************************** -->
   <!-- Match: title
        1) when in back, title should not be used
        
        2) content should not all be formatted 
        
        3) cannot be empty outside of sec and app
     -->
   <!-- *********************************************************** -->
   <xsl:template match="title">
      <xsl:if test="parent::back">
         <xsl:call-template name="back-title-check">
            <xsl:with-param name="context" select="."/>
         </xsl:call-template>
      </xsl:if>
      
      <xsl:call-template name="block-formatting-check"/>
      
      <xsl:if test="parent::*[not(self::sec) and not(self::app)] or
	                ($document-type='book' and not(parent::sec[@sec-type='figs-and-tables'])) or
                   ($document-type='book-part' and not(parent::sec[@sec-type='figs-and-tables' or @sec-type='link-group']))">
         <xsl:call-template name="empty-element-check">
            <xsl:with-param name="context" select="."/>
         </xsl:call-template>
      </xsl:if>

      <xsl:apply-templates select="." mode="output"/>
   </xsl:template>


   <!-- *********************************************************** -->
   <!-- Match: title-group
        1) cannot be empty 
     -->
   <!-- *********************************************************** -->
   <xsl:template match="title-group">
      <xsl:call-template name="empty-element-check"/>
      <!--======================================================-->
      <!--Removed this test, overhaul of manuscript
         stylecheck rules KP 2015-11-03-->
      <!--Manuscript to follow PMC rules-->
      <!--======================================================-->
		<!--<xsl:if test="$stream='manuscript'">
			<xsl:call-template name="ms-title-group-check"/>
			</xsl:if>-->
      <!--======================================================-->
		
      <xsl:apply-templates select="." mode="output"/>

		
		</xsl:template>
		

   <!-- *********************************************************** -->
   <!-- Match: toc (BITS)
        1) 
     -->
   <!-- *********************************************************** -->
   <!--<xsl:template match="toc">   
      
      <xsl:apply-templates select="." mode="output"/>
   </xsl:template>-->


   <!-- *********************************************************** -->
   <!-- Match: toc-div (BITS)
        1) 
     -->
   <!-- *********************************************************** -->
   <!--<xsl:template match="toc-div">   
     
      <xsl:apply-templates select="." mode="output"/>
   </xsl:template>-->
		
		
   <!-- *********************************************************** -->
   <!-- Match: toc-entry (BITS)
        1) cannot be empty 
     -->
   <!-- *********************************************************** -->
   <xsl:template match="toc-entry">   
      <xsl:call-template name="empty-element-check"/>
      <xsl:apply-templates select="." mode="output"/>
   </xsl:template>
		
		
   <!-- *********************************************************** -->
   <!-- Match: toc-group (BITS)
        1) 
     -->
   <!-- *********************************************************** -->
   <!--<xsl:template match="toc-group">   
     
      <xsl:apply-templates select="." mode="output"/>
   </xsl:template>-->
		


   <!-- *********************************************************** -->
   <!-- Match: tr
        1) cannot be empty 
     -->
   <!-- *********************************************************** -->
   <xsl:template match="tr">   
      <xsl:call-template name="empty-element-check"/>
      <xsl:apply-templates select="." mode="output"/>
		</xsl:template>
   

   <!-- *********************************************************** -->
   <!-- Match: trans-abstract
        1) cannot be empty 
     -->
   <!-- *********************************************************** -->
   <xsl:template match="trans-abstract">
      <xsl:call-template name="empty-element-check"/>
   	<xsl:call-template name="trans-atts-check">
   		<xsl:with-param name="context" select="."/>
   	</xsl:call-template>
      <xsl:call-template name="trans-abstract-check">
      	<xsl:with-param name="context" select="."/>
      </xsl:call-template>
      <xsl:apply-templates select="." mode="output"/>
		</xsl:template>
   

   <!-- *********************************************************** -->
   <!-- Match: trans-source
        1) cannot be empty 
     -->
   <!-- *********************************************************** -->
   <xsl:template match="trans-source">
   	<xsl:call-template name="empty-element-check"/>
   	<xsl:call-template name="trans-atts-check">
   		<xsl:with-param name="context" select="."/>
   	</xsl:call-template>
      <xsl:apply-templates select="." mode="output"/>
		</xsl:template>
   
   <!-- *********************************************************** -->
   <!-- Match: trans-subtitle
        1) cannot be empty 
     -->
   <!-- *********************************************************** -->
   <xsl:template match="trans-subtitle">
   	<xsl:call-template name="empty-element-check"/>
      <xsl:apply-templates select="." mode="output"/>
		</xsl:template>
   

   <!-- *********************************************************** -->
   <!-- Match: trans-title
        1) cannot be empty 
     -->
   <!-- *********************************************************** -->
   <xsl:template match="trans-title">
   	<xsl:call-template name="empty-element-check"/>
      <xsl:call-template name="trans-title-check"/>
      <xsl:apply-templates select="." mode="output"/>
		</xsl:template>
   

   <!-- *********************************************************** -->
   <!-- Match: trans-title-group
		  1) must have @xml:lang (enforced by dtd)
		  2) children must either have @xml:lang that agrees or have
		     no @xml:lang
		  3) Each child must have a corresponding element in the 
		     parent::title-group except for fn-group 
     -->
   <!-- *********************************************************** -->
   <xsl:template match="trans-title-group">
   	<xsl:call-template name="trans-title-group-content-check"/>
      <xsl:apply-templates select="." mode="output"/>
		</xsl:template>
   

   <!-- *********************************************************** -->
   <!-- Match: underline
        1) cannot be empty 
     -->
   <!-- *********************************************************** -->
   <xsl:template match="underline">
      <xsl:call-template name="empty-element-check"/>
      <xsl:apply-templates select="." mode="output"/>
		</xsl:template>
   

   <!-- *********************************************************** -->
   <!-- Match: uri
        1) xlink:href cannot be empty
     -->
   <!-- *********************************************************** -->
   <xsl:template match="uri">
      <xsl:call-template name="href-content-check"/>
       <xsl:apply-templates select="." mode="output"/>
		</xsl:template>


   <!-- *********************************************************** -->
   <!-- Match: verse-group
        1) cannot be empty 
     -->
   <!-- *********************************************************** -->
   <xsl:template match="verse-group">
      <xsl:call-template name="empty-element-check"/>
      <xsl:apply-templates select="." mode="output"/>
   </xsl:template>
   

   <!-- *********************************************************** -->
   <!-- Match: verse-line
        1) cannot be empty 
     -->
   <!-- *********************************************************** -->
   <xsl:template match="verse-line">
      <xsl:call-template name="empty-element-check"/>
      <xsl:apply-templates select="." mode="output"/>
		</xsl:template>
   

   <!-- *********************************************************** -->
   <!-- Match: volume
        1) cannot be empty 
     -->
   <!-- *********************************************************** -->
   <xsl:template match="volume">
      <xsl:call-template name="empty-element-check"/>
      <xsl:apply-templates select="." mode="output"/>
		</xsl:template>
   
   <!-- *********************************************************** -->
   <!-- Match: volume-id
        1) cannot be empty 
     -->
   <!-- *********************************************************** -->
   <xsl:template match="volume-id">
      <xsl:call-template name="empty-element-check"/>
      <xsl:apply-templates select="." mode="output"/>
		</xsl:template>
   
      <!-- *********************************************************** -->
   <!-- Match: volume-in-collection (BITS)
        1) cannot be empty 
     -->
   <!-- *********************************************************** -->
   <xsl:template match="volume-in-collection">
      <xsl:call-template name="empty-element-check"/>
      <xsl:apply-templates select="." mode="output"/>
		</xsl:template>
		
  <!-- *********************************************************** -->
   <!-- Match: volume-number (BITS)
        1) cannot be empty 
     -->
   <!-- *********************************************************** -->
   <xsl:template match="volume-number">
      <xsl:call-template name="empty-element-check"/>
      <xsl:apply-templates select="." mode="output"/>
		</xsl:template>
   

   <!-- *********************************************************** -->
   <!-- Match: volume-series
        1) cannot be empty 
     -->
   <!-- *********************************************************** -->
   <xsl:template match="volume-series">
      <xsl:call-template name="empty-element-check"/>
      <xsl:apply-templates select="." mode="output"/>
		</xsl:template>
   

   <!-- *********************************************************** -->
   <!-- Match: x
        1) cannot be empty 
     -->
   <!-- *********************************************************** -->
   <xsl:template match="x">
      <xsl:call-template name="empty-element-check">
         <xsl:with-param name="context" select="."/>
         <xsl:with-param name="mode" select="'loose'"/>
			</xsl:call-template>
      <xsl:apply-templates select="." mode="output"/>
		</xsl:template>


   <!-- *********************************************************** -->
   <!-- Match: xref
        1) Content should not have trailing punctuation (warning) in articles
        2) Must point to the right thing based on the ref-type
     -->
   <!-- *********************************************************** -->
   <xsl:template match="xref">
		<xsl:choose>
			<xsl:when test="$stream='book'"/>
			<xsl:otherwise>
   		   <xsl:call-template name="punctuation-in-xref"/>
				</xsl:otherwise>
			</xsl:choose>
      <xsl:call-template name="xref-check"/>
      <xsl:apply-templates select="." mode="output"/>
		</xsl:template>



  <!-- ********************************************************************* -->
   <!-- Match: year
        1) cannot be empty 
        2) content must be in range
     -->
   <!-- *********************************************************** -->
   <xsl:template match="year">
		<xsl:call-template name="empty-element-check"/>
      <xsl:call-template name="year-check"/>
      <xsl:apply-templates select="." mode="output"/>
		</xsl:template>



























































</xsl:stylesheet>
