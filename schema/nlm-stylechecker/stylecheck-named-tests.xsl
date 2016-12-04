<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet 
   xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
   xmlns:xlink="http://www.w3.org/1999/xlink" 
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
   xmlns:mml="http://www.w3.org/1998/Math/MathML" 
   version="1.0">
   
   <xsl:output method="xml" 
       omit-xml-declaration="yes"
       encoding="UTF-8"
	   indent="yes"/>
		
<!-- style or stream-specific checks -->


   <xsl:template name="ms-abstract-sec-type-test">
      <xsl:if test="@sec-type">
         <xsl:if test="ancestor::abstract">
            <xsl:call-template name="make-error">
					<xsl:with-param name="error-type" select="'abstract sec-type check'"/>
              <xsl:with-param name="description">
                 <xsl:text>sections within abstract should not have @sec-type.</xsl:text>
              		</xsl:with-param>
					<xsl:with-param name="tg-target" select="'tags.html#el-abs'"/>
            </xsl:call-template>
         </xsl:if>
      </xsl:if>
   </xsl:template>


   <!-- ********************************************* -->
   <!-- Template: ms-article-meta-abstract-test
        
        One and only one abstract is required.
        Manuscripts may have more than one abstract.
        KP 2015-11-03
        
        Context: article-categories                   -->
   <!-- ********************************************* -->   
	<!--<xsl:template name="ms-article-meta-abstract-test">
		<xsl:if test="count(abstract) &gt; 1 and not(abstract/@abstract-type='graphical')">
			<xsl:call-template name="make-error">
				<xsl:with-param name="error-type">abstract count</xsl:with-param>
				<xsl:with-param name="description">
					<xsl:text>Article can only have more than one &lt;abstract&gt; if one of them is @abstract-type="graphical".</xsl:text>
					</xsl:with-param>
				<xsl:with-param name="tg-target" select="'tags.html#el-abs'"/>
				</xsl:call-template>
      	</xsl:if>
   </xsl:template>-->



   <!-- ********************************************* -->
   <!-- Template: ms-article-meta-content-test
        
        Do not allow the following elements inside
        article-meta:
        pub-date, volume, volume-id, issue,
        issue-id, issue-title, supplement, fpage,
        lpage, page-range, elocation-id, email, ext-link,
        uri, product, history, conference, aff
        
        Do not allow related-article unless article is
        correction or retraction
        
        Context: article-meta                         -->
   <!-- ********************************************* -->   
   <xsl:template name="ms-article-meta-content-test">
      <xsl:if test="volume | volume-id | issue |
        issue-id | issue-title | supplement | fpage |
        lpage | page-range | elocation-id | email | ext-link |
        uri | product | history | conference">
        <xsl:call-template name="make-error">
				<xsl:with-param name="error-type">article-meta content check</xsl:with-param>
				<xsl:with-param name="description">
              <xsl:text>The following elements should not appear inside &lt;article-meta&gt;: &lt;conference&gt;, &lt;ext-link&gt;, &lt;email&gt;, &lt;elocation-id&gt;, &lt;fpage&gt;, &lt;history&gt;, &lt;issue&gt;, &lt;issue-title&gt;, &lt;issue-id&gt;, &lt;lpage&gt;, &lt;page-range&gt;, &lt;product&gt;, &lt;supplement&gt;, &lt;uri&gt;, &lt;volume&gt;, &lt;volume-id&gt;</xsl:text>
           </xsl:with-param>
			<xsl:with-param name="tg-target" select="'tags.html#el-artmeta'"/>
        </xsl:call-template>
      </xsl:if>
   	<xsl:if test="related-article[not(@related-article-type='republished-article') and
   	   not(@related-article-type='concurrent-pub') and not(@related-article-type='updated-article') and 
			not(@related-article-type='addended-article')] 
			and not(/article/@article-type='correction') and 
			not(/article/@article-type='retraction') and 
			not(/article/@article-type='article-commentary') and 
			not(/article/@article-type='expression-of-concern')">
   		<xsl:call-template name="make-error">
   			<xsl:with-param name="error-type">article-meta content check</xsl:with-param>
   			<xsl:with-param name="description">
   				<xsl:text>Only corrections, retractions, addenda, expressions-of-concern, and article-commentary may contain &lt;related-article&gt;.</xsl:text>
   			</xsl:with-param>
   			<xsl:with-param name="tg-target" select="'tags.html#el-artmeta'"/>
   		</xsl:call-template>
   	</xsl:if>

   <!--======================================================-->
      <!--Removed this test, KP 2015-11-03-->
      <!--Manuscript to follow PMC rules-->
   <!--======================================================-->
		<!--<xsl:if test="trans-abstract and $art-lang-att='en'">
        <xsl:call-template name="make-error">
				<xsl:with-param name="error-type">article-meta content check</xsl:with-param>
				<xsl:with-param name="description">
              <xsl:text>&lt;trans-abstract&gt;should only be used to carry an English abstract in a non-English manuscript.</xsl:text>
           </xsl:with-param>
        </xsl:call-template>
			</xsl:if>-->
      <!--======================================================-->
      
	<!--	<xsl:if test="$art-lang-att!='en' and not(title-group/trans-title-group[@xml:lang='en']) and not(title-group/trans-title[@xml:lang='en'])">
   		<xsl:call-template name="make-error">
   			<xsl:with-param name="error-type">article-meta content check</xsl:with-param>
   			<xsl:with-param name="description">
   				<xsl:text>A non-English article must have an English title tagged as &lt;trans-title>.</xsl:text>
   			</xsl:with-param>
   		</xsl:call-template>
			</xsl:if>	-->
			
   </xsl:template>


	<xsl:template name="ms-title-group-check">
		<xsl:if test="trans-title and $art-lang-att='en'"> 
        <xsl:call-template name="make-error">
				<xsl:with-param name="error-type">trans-title check</xsl:with-param>
				<xsl:with-param name="description">
              <xsl:text>&lt;trans-title&gt;should only be used to carry an English title in a non-English manuscript.</xsl:text>
           </xsl:with-param>
        </xsl:call-template>
			</xsl:if>
		</xsl:template>



   <!-- ********************************************* -->
   <!-- Template: ms-article-id-test
        
        Must have an article-id with pub-id-type="manuscript"
        
        Context: article-meta                         -->
   <!-- ********************************************* -->   
   <xsl:template name="ms-article-id-test">
      <xsl:if test="not(article-id[@pub-id-type='manuscript'])">
        <xsl:call-template name="make-error">
				<xsl:with-param name="error-type">manuscript article-id check</xsl:with-param>
				<xsl:with-param name="description">
              <xsl:text>Manuscript content must have an &lt;article-id&gt; with @pub-id-type='manuscript'.</xsl:text>
           </xsl:with-param>
			<xsl:with-param name="tg-target" select="'tags.html#el-artmeta'"/>
        </xsl:call-template>
      </xsl:if>
   </xsl:template>


   <!-- ********************************************* -->
   <!-- Template: ms-back-content-test
        
        back should not contain title or notes   
        
        Context: back -->
   <!-- ********************************************* -->   
   <xsl:template name="ms-back-content-test">
      <xsl:if test="title">
         <xsl:call-template name="make-error">
				<xsl:with-param name="error-type">back content check</xsl:with-param>
            <xsl:with-param name="description">
               <xsl:text>&lt;back&gt; should not contain &lt;title&gt;</xsl:text>
            </xsl:with-param>
						<xsl:with-param name="tg-target" select="'tags.html#el-back'"/>
         </xsl:call-template>
      </xsl:if>
   </xsl:template>

   <!-- ********************************************* -->
   <!-- Template: ms-back-display-object-test
        
        If article is v 2.3 and has floating tables/figs, then
        the back must have a display-object section.
        
        If article is v 3.x or JATS and has floating tables/figs, then
        these should be contained in a floats-group within the
        article element.
                
        Context: back -->
   <!-- ********************************************* -->   
   <xsl:template name="ms-back-display-object-test">
      <xsl:if test="//fig[@position='float'] or //table-wrap[@position='float']">         
         <xsl:if test="$dtd-version='2'">
            <xsl:if test="not(sec[@sec-type = 'display-objects'])">
               <xsl:call-template name="make-error">
   				<xsl:with-param name="error-type">display objects test</xsl:with-param>
                 <xsl:with-param name="description">
                    <xsl:text>&lt;back&gt; must contain a &lt;sec&gt; with sec-type attribute set to 'display-objects' to contain floating figures and tables</xsl:text>
                 </xsl:with-param>
   				 <xsl:with-param name="tg-target" select="'dobs.html#figtab'"/>
               </xsl:call-template>  				
            </xsl:if>
         </xsl:if>  
         <xsl:if test="$dtd-version='3' or $dtd-version='j1'">
            <xsl:if test="sec[@sec-type = 'display-objects']">
               <xsl:call-template name="make-error">
                  <xsl:with-param name="error-type">display objects test</xsl:with-param>
                  <xsl:with-param name="description">
                     <xsl:text>&lt;back&gt; must no longer contain a &lt;sec&gt; with sec-type attribute set to 'display-objects' to contain floating figures and tables. They must now be contained in floats-group.</xsl:text>
                  </xsl:with-param>
                  <xsl:with-param name="tg-target" select="'dobs.html#figtab'"/>
               </xsl:call-template>
            </xsl:if>            
         </xsl:if>         
      </xsl:if>
   </xsl:template>

   <xsl:template name="ms-floats-group-test">
      <xsl:if test="$dtd-version = '3' or $dtd-version='j1'">
      <xsl:if test="//fig[@position='float'] or //table-wrap[@position='float']">
         <xsl:choose>
            <xsl:when test="child::floats-group"/>                           
            <xsl:otherwise>
               <xsl:call-template name="make-error">
                  <xsl:with-param name="error-type">floating objects test</xsl:with-param>
                  <xsl:with-param name="description">
                     <xsl:text>&lt;article&gt; must contain a &lt;floats-group&gt; to contain floating figures and tables.</xsl:text>
                  </xsl:with-param>                  
                  <xsl:with-param name="tg-target" select="'tags.html#el-floatsgrp'"/>
               </xsl:call-template>
            </xsl:otherwise>
         </xsl:choose>
         
         
      </xsl:if>    
     </xsl:if> 
   </xsl:template>
	
	
	<xsl:template name="ms-footnote-license-check">
		<xsl:variable name="fntext" select="."/>
		<xsl:choose>
		<xsl:when test="ancestor::table-wrap"/><!-- it is possible to have cc licenses for table material -->
		<xsl:when test="contains($fntext,'creativecommons.org') or contains(descendant::node()/@xlink:href,'creativecommons.org')">
               <xsl:call-template name="make-error">
                  <xsl:with-param name="error-type">license in footnote test</xsl:with-param>
                  <xsl:with-param name="description">
                     <xsl:text>License information must be included in &lt;license&gt; in &lt;permissions&gt;, not in a footnote.</xsl:text>
                  </xsl:with-param>                  
               </xsl:call-template>
			</xsl:when>
		<xsl:when test="contains($fntext,'Creative Commons')">
               <xsl:call-template name="make-error">
						<xsl:with-param name="class">warning</xsl:with-param>                  
						<xsl:with-param name="error-type">license in footnote test</xsl:with-param>
                  <xsl:with-param name="description">
                     <xsl:text>License information must be included in &lt;license&gt; in &lt;permissions&gt;, not in a footnote.</xsl:text>
                  </xsl:with-param>                  
               </xsl:call-template>
			</xsl:when>
		</xsl:choose>	
		</xsl:template>	
	
	
	
	
	
   <!-- ********************************************* -->
   <!-- Template: ms-contrib-attribute-test
        
        contrib-type should be set to "author" or 
        "editor"
        
        id attribute not allowed
        
        rid attribute not allowed
        
        xlink:atts not allowed
        
        See related test for author-note-type
        attributes.
        
        Context: contrib -->
   <!-- ********************************************* -->   
   <xsl:template name="ms-contrib-attribute-test">
   
      <xsl:if test="not(@contrib-type)">
         <xsl:call-template name="make-error">
				<xsl:with-param name="error-type" select="'contrib attribute'"/>
            <xsl:with-param name="description">
               <xsl:text>&lt;contrib&gt; must contain a contrib-type attribute</xsl:text>
            </xsl:with-param>
				 <xsl:with-param name="tg-target" select="'tags.html#el-contrib'"/>
         </xsl:call-template>
      </xsl:if>

      <xsl:if test="@contrib-type and (@contrib-type != 'author' and @contrib-type != 'editor')">
         <xsl:call-template name="make-error">
				<xsl:with-param name="error-type" select="'contrib attribute'"/>
            <xsl:with-param name="description">
               <xsl:text>contrib-type attribute must be set to either 'author' or 'editor'</xsl:text>
            </xsl:with-param>
				 <xsl:with-param name="tg-target" select="'tags.html#el-contrib'"/>
         </xsl:call-template>
      </xsl:if>

      <xsl:if test="@id">
         <xsl:call-template name="make-error">
				<xsl:with-param name="error-type" select="'contrib attribute'"/>
            <xsl:with-param name="description">
               <xsl:text>&lt;contrib&gt; should not contain an id attribute</xsl:text>
            </xsl:with-param>
				 <xsl:with-param name="tg-target" select="'tags.html#el-contrib'"/>
         </xsl:call-template>
      </xsl:if>

      <xsl:if test="@rid">
         <xsl:call-template name="make-error">
				<xsl:with-param name="error-type" select="'contrib attribute'"/>
            <xsl:with-param name="description">
               <xsl:text>&lt;contrib&gt; should not contain an rid attribute</xsl:text>
            </xsl:with-param>
				 <xsl:with-param name="tg-target" select="'tags.html#el-contrib'"/>
         </xsl:call-template>
      </xsl:if>
   </xsl:template>
   
   <!-- ********************************************* -->
   <!-- Template: ms-contrib-content-test
        
        Makes sure that the contrib has the following:
        1) name or collab
        
        Makes sure it does not use the following
        elements:
        1) address
        2) author-comment
        3) bio
        4) on-behalf-of
        5) uri
        6) xref where the ref-type != author-notes
        7) Only contains a single collab or name
        
        Context: contrib -->
   <!-- ********************************************* -->   
   <xsl:template name="ms-contrib-content-test">
   
      <!-- Make sure these elements not present -->
      <xsl:if test="address or author-comment or bio or uri[not(@content-type='orcid')]">
         <xsl:call-template name="make-error">
				<xsl:with-param name="error-type" select="'contrib content check'"/>
            <xsl:with-param name="description">
               <xsl:text>&lt;contrib&gt; should not contain any of the following elements: &lt;address&gt;, &lt;author-comment&gt;, &lt;bio&gt;, or &lt;uri&gt; that does not have @content-type="orcid".</xsl:text>
            </xsl:with-param>
				 <xsl:with-param name="tg-target" select="'tags.html#el-contrib'"/>
         </xsl:call-template>
      </xsl:if>
   </xsl:template>

   <!-- ********************************************* -->
   <!-- Template: ms-contrib-group-aff-test
        
        aff cannot be in both contrib-group and inside
        contrib; should either have a single aff
        for all contrib that is coded in the group,
        or a separate aff for each contrib.
        
        Context: contrib-group -->
   <!-- ********************************************* -->   
   <xsl:template name="ms-contrib-group-aff-test">
   
      <xsl:if test="aff and contrib/aff">
         <xsl:call-template name="make-error">
				<xsl:with-param name="error-type" select="'contrib group aff check'"/>
            <xsl:with-param name="description">
               <xsl:text>&lt;aff&gt; in &lt;contrib-group&gt; should apply to all &lt;contrib&gt; elements.</xsl:text>
            </xsl:with-param>
				 <xsl:with-param name="tg-target" select="'dobs.html#dob-auaff'"/>
         </xsl:call-template>
      </xsl:if>
   </xsl:template>

   <!-- ********************************************* -->
   <!-- Template: ms-contrib-group-content-test
        
        contrib-group only allowed to contain contrib
        and/or aff
        
        Context: contrib-group -->
   <!-- ********************************************* -->   
   <xsl:template name="ms-contrib-group-content-test">
   
      <xsl:if test="*[not(self::contrib) and not(self::aff) and not(self::on-behalf-of) and not(self::xref)]">
         <xsl:call-template name="make-error">
				<xsl:with-param name="error-type" select="'contrib group content check'"/>
            <xsl:with-param name="description">
               <xsl:text>&lt;contrib-group&gt; should only contain &lt;contrib&gt; and/or &lt;aff&gt; elements.</xsl:text>
            </xsl:with-param>
				 <xsl:with-param name="tg-target" select="'tags.html#el-cgroup'"/>
         </xsl:call-template>
      </xsl:if>
   
   </xsl:template>

   <!-- ********************************************* -->
   <!-- Template: ms-disp-formula-content-test
        
        disp-formula should not contain the 
        following: inline-graphic, tex-math, array, 
           chem-struct, graphic
        
        Context: disp-formula -->
   <!-- ********************************************* -->   
   <xsl:template name="ms-disp-formula-content-test">
      <xsl:if test="inline-graphic | tex-math | array | chem-struct">
         <xsl:call-template name="make-error">
				<xsl:with-param name="error-type" select="'display formula check'"/>
            <xsl:with-param name="description">
               <xsl:text>&lt;disp-formula&gt; cannot contain &lt;inline-graphic&gt;, &lt;tex-math&gt;, &lt;array&gt;, or &lt;chem-struct&gt; elements</xsl:text>
            </xsl:with-param>
				 <xsl:with-param name="tg-target" select="'tags.html#el-dispform'"/>
         </xsl:call-template>
      </xsl:if>
   </xsl:template>

   <!-- ********************************************* -->
   <!-- Template: ms-front-content-test
        
        Don't allow notes element in front.
        
        Context: front -->
   <!-- ********************************************* -->   
   <xsl:template name="ms-front-content-test">
      <xsl:if test="notes[not(@notes-type='related-article') and not(descendant::related-article)]">
         <xsl:call-template name="make-error">
				<xsl:with-param name="error-type" select="'front content check'"/>
				<xsl:with-param name="description">
               <xsl:text>&lt;front&gt; should not contain a &lt;notes&gt; element unless it is a disclaimer or it contains related article information. Place all notes inside &lt;author-notes&gt; or move to a &lt;fn-group&gt; in &lt;back&gt;.</xsl:text>
            	</xsl:with-param>
				 <xsl:with-param name="tg-target" select="'tags.html#el-front'"/>
         	</xsl:call-template>
      	</xsl:if>
		<xsl:call-template name="front-content-test"/>  
   </xsl:template>


	<xsl:template name="ms-stream-id-test">
		<xsl:if test="$stream='manuscript'">
			<xsl:call-template name="id-present-test"/>
			<xsl:call-template name="id-content-test"/>
			</xsl:if>
		</xsl:template>

   <!-- ********************************************* -->
   <!-- Template: manuscript-pi-test
        
        Tests that the manuscript has the PI
		  <?properties manuscript?>
		  
		  and has an <?origin?> PI with a known value                      
        
        If there is an error, returns error text; 
        otherwise returns empty-string   
        
        Context: article                              -->
   <!-- ********************************************* -->   
   <xsl:template name="manuscript-pi-test">
      <xsl:choose>
			<!-- temporary bypass of new PI rules -->
         <xsl:when test="//processing-instruction('nihms')"/>
			
         <xsl:when test="contains(//processing-instruction('properties'),'manuscript')">
            <!-- ## Test returns true when the <?properties manuscript?> PI is supplied ##-->
            <!-- Do nothing -->
         </xsl:when>
         <xsl:when test="//processing-instruction('nihms')">
				<!-- this is a temporary test to not fail manuscripts with the old PI -->
             <xsl:call-template name="make-error">
				 	<xsl:with-param name="class">warning</xsl:with-param>
					<xsl:with-param name="error-type">manuscript ProcessingInstruction check</xsl:with-param>
               <xsl:with-param name="description">
                  <xsl:text>&lt;?nihms?&gt; processing instruction is no longer fashionable. Use &lt;?properties manuscript?&gt; with the input stream identified in &lt;?origin ?&gt;</xsl:text>
               </xsl:with-param>
            </xsl:call-template>
         </xsl:when>
         <!-- manuscript pi is not available: report error inside the element -->
         <xsl:otherwise>
            <xsl:call-template name="make-error">
					<xsl:with-param name="error-type">manuscript ProcessingInstruction check</xsl:with-param>
               <xsl:with-param name="description">
                  <xsl:text>&lt;?properties manuscript?&gt; must be supplied in the manuscript.</xsl:text>
               </xsl:with-param>
            </xsl:call-template>
         </xsl:otherwise>
      </xsl:choose>
		
		
		<xsl:choose>
			<xsl:when test="count(//processing-instruction('origin')) &gt; 1">
            <xsl:call-template name="make-error">
					<xsl:with-param name="error-type">manuscript ProcessingInstruction check</xsl:with-param>
               <xsl:with-param name="description">
                  <xsl:text>only one &lt;?origin?&gt; PI may be supplied. It must correspond to the input streams 'nihpa', 'ukpmcpa', 'capmc', 'hal', 'hrams', 'nasapa', or 'hhmipa'.</xsl:text>
               </xsl:with-param>
            </xsl:call-template>
				</xsl:when>
				
				
			<!-- temporary bypass of new PI rules -->
         <xsl:when test="//processing-instruction('nihms')"/>
			
			<xsl:when test="not(//processing-instruction('origin'))">
            <xsl:call-template name="make-error">
					<xsl:with-param name="error-type">manuscript ProcessingInstruction check</xsl:with-param>
               <xsl:with-param name="description">
                  <xsl:text>&lt;?origin?&gt; PI must be supplied. It must correspond to the input streams 'nihpa', 'ukpmcpa', 'capmc', 'hal', 'hrams', or 'hhmipa' like &lt;?origin ukpmcpa?&gt;.</xsl:text>
               </xsl:with-param>
            </xsl:call-template>
				</xsl:when>
        	<xsl:when test="contains(//processing-instruction('origin'), 'nihpa')"/><!-- ok -->
        	<xsl:when test="contains(//processing-instruction('origin'), 'ukpmcpa')"/><!-- ok -->
        	<xsl:when test="contains(//processing-instruction('origin'), 'capmc')"/><!-- ok -->
        	<xsl:when test="contains(//processing-instruction('origin'), 'hal')"/><!-- ok -->
        	<xsl:when test="contains(//processing-instruction('origin'), 'hhmipa')"/><!-- ok -->
        	<xsl:when test="contains(//processing-instruction('origin'), 'hrams')"/><!-- ok -->
        	<xsl:when test="contains(//processing-instruction('origin'), 'hhspa')"/><!-- ok -->
        	<xsl:when test="contains(//processing-instruction('origin'), 'asms')"/><!-- ok -->
        	<xsl:when test="contains(//processing-instruction('origin'), 'aspa')"/><!-- ok -->
        	<xsl:when test="contains(//processing-instruction('origin'), 'vapa')"/><!-- ok -->
        	<xsl:when test="contains(//processing-instruction('origin'), 'nasapa')"/><!-- ok -->
        	<xsl:when test="contains(//processing-instruction('origin'), 'nistpa')"/><!-- ok -->
        	<xsl:when test="contains(//processing-instruction('origin'), 'ahrqpa')"/><!-- ok -->
			<xsl:otherwise>
            <xsl:call-template name="make-error">
					<xsl:with-param name="error-type">manuscript ProcessingInstruction check</xsl:with-param>
               <xsl:with-param name="description">
						<xsl:text>&lt;?origin </xsl:text>
						<xsl:value-of select="//processing-instruction('origin')"/>
                  <xsl:text>?&gt; is not an acceptable input stream. It must be one of 'nihpa', 'hhspa', 'ukpmcpa', 'capmc', 'hrams', 'hal', 'asms', 'aspa', 'vapa', 'nistpa', 'ahrqpa' or 'hhmipa'.</xsl:text>
               </xsl:with-param>
            	</xsl:call-template>
				</xsl:otherwise>
         </xsl:choose>
   </xsl:template>



   <!-- ********************************************* -->
   <!-- Template: ms-subj-group-test
        
        Article-categories must have a subj-group
        with a single subject of "Article" and an 
		  @subj-group-type="heading"
	  Exceptions:
	     Corrections may have "Correction" or "Erratum"
	     Retractions may have "Retraction" or "Erratum"
        
        Other subject groups can be inside the article
        categories, but they cannot have a subj-group
        attribute.
        
        Context: article-categories -->
   <!-- ********************************************* -->   
   <xsl:template name="ms-subj-group-test">
     <!-- Must have a subject group with proper attribute
          and subject and nothing else.
          
          Any other subj-groups can't have a type 
          attribute                                   -->
          
     <xsl:choose>
     	<!-- Only 1 sujb-group with @subj-group-type AND
     		@subj-group-type="heading" AND
     		heading is "Correction" or "Errara" when /article/@article-type="correction"; 
     		test is okay	-->
     	<xsl:when test="/article/@article-type='correction'
     		and count(subj-group[@subj-group-type])=1 
     		and subj-group/@subj-group-type[normalize-space() = 'heading']
     		and count(subj-group[normalize-space(@subj-group-type)='heading']/subject) = 1
     		and (normalize-space(subj-group[@subj-group-type='heading']/subject)='Correction' 
	     		or normalize-space(subj-group[@subj-group-type='heading']/subject)='Erratum')">
     		<!-- Do nothing-->
     	</xsl:when>
     	
     	<!-- Only 1 sujb-group with @subj-group-type AND
     		@subj-group-type="heading" AND
     		heading is "Retraction" or "Errata" when /article/@article-type="retraction"; 
     		test is okay	-->
     	<xsl:when test="/article/@article-type='retraction'
     		and count(subj-group[@subj-group-type])=1 
     		and subj-group/@subj-group-type[normalize-space() = 'heading']
     		and count(subj-group[normalize-space(@subj-group-type)='heading']/subject) = 1
     		and (normalize-space(subj-group[@subj-group-type='heading']/subject)='Retraction' 
     		or normalize-space(subj-group[@subj-group-type='heading']/subject)='Erratum')">
     		<!-- Do nothing-->
     	</xsl:when>    	
     	
     	<!-- ## Test returns true if there is only one subj-group with a subj-group-type attribute;
                furthermore, the value of the attribute must be heading; furthermore,
                that subj-group must have a single subject with content = 'Article'##-->
        <xsl:when test="count(subj-group[@subj-group-type])=1 
           and subj-group/@subj-group-type[normalize-space() = 'heading']
           and count(subj-group[normalize-space(@subj-group-type)='heading']/subject[normalize-space() = 'Article']) = 1">
           <!-- Do nothing-->
        </xsl:when>

        <xsl:otherwise>
           <xsl:call-template name="make-error">
			  	  <xsl:with-param name="error-type">subject-group checking</xsl:with-param>
              <xsl:with-param name="description">
                 <xsl:text>&lt;article-categories&gt; must contain a single default &lt;subj-group&gt; where the subj-group-type attribute is 'heading' and the subject content is 'Article'</xsl:text>
              </xsl:with-param>
				<xsl:with-param name="tg-target" select="'dobs.html#dob-subjects'"/>

           </xsl:call-template>
        </xsl:otherwise>
     </xsl:choose>
  	
     
     <!-- No emphasis in subjects -->
     <xsl:if test="subj-group/subject/bold
                or subj-group/subject/sup
                or subj-group/subject/sub
                or subj-group/subject/italic
                or subj-group/subject/monospace
                or subj-group/subject/overline
                or subj-group/subject/sc
                or subj-group/subject/strike
                or subj-group/subject/underline">
        <xsl:call-template name="make-error">
			   <xsl:with-param name="error-type">subject-group checking</xsl:with-param>
            <xsl:with-param name="description">
                <xsl:text>&lt;subject&gt; cannot contain emphasis elements</xsl:text>
            </xsl:with-param>
				<xsl:with-param name="tg-target" select="'genprac.html#formatting'"/>
        </xsl:call-template>
     </xsl:if>
   </xsl:template>
	
  <!-- ********************************************* -->
   <!-- Template: ms-extended-data-test
        
		  For Manuscripts.
		  
        If there is a fig or table-wrap with a title
		  that contains "Extended Data" or an xref that
		  contains the text Extended Data, then there must
		  be an extended data section in the manuscript 
        
        Context: article-categories -->
   <!-- ********************************************* -->   
	<xsl:template name="ms-extended-data-test">	
		<xsl:if test="//xref[contains(.,'Extended Data')] or
		              //xref[contains(.,'Extended data')] or
		              //xref[contains(.,'extended data')] or
		              //fig/label[contains(.,'Extended Data')] or
		              //fig/label[contains(.,'Extended data')] or
		              //fig/label[contains(.,'extended data')] or
		              //table-wrap/label[contains(.,'Extended Data')] or
		              //table-wrap/label[contains(.,'Extended data')] or
		              //table-wrap/label[contains(.,'extended data')] or
						  //boxed-text/label[contains(.,'Extended Data')] or
						  //boxed-text/label[contains(.,'Extended data')] or
		              //boxed-text/label[contains(.,'extended data')]">
			<xsl:choose>
				<xsl:when test="child::sec[@sec-type='extended-data']"/> <!-- good -->
				<xsl:otherwise>
      			 <xsl:call-template name="make-error">
			   		<xsl:with-param name="error-type">extended data checking</xsl:with-param>
            		<xsl:with-param name="description">
                <xsl:text>Manuscripts with Extended Data figures or tables must have an Extended Data section at the end of the body (but before any supplementary-material section).</xsl:text>
            </xsl:with-param>
        </xsl:call-template>
					</xsl:otherwise>		  
				</xsl:choose>			  
			</xsl:if>
		</xsl:template>
		
	<!-- ********************************************* -->
	<!-- Template: article-subj-group-test
        
        Article-categories must have a subj-group
        	with @subj-group-type="heading" or "part"
        	or no @subj-group-type specified
        
        Context: article-categories -->
	<!-- ********************************************* -->   
	<xsl:template name="article-subj-group-test">
		<xsl:choose>
			<xsl:when test="subj-group[@subj-group-type='heading']
				or subj-group[@subj-group-type='part']
				or subj-group[not(@subj-group-type)]">
				<!-- No error -->
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="make-error">
					<xsl:with-param name="error-type">subject-group checking</xsl:with-param>
					<xsl:with-param name="description">
						<xsl:text>&lt;article-categories&gt; must contain a &lt;subj-group&gt; with subj-group-type attribute 'heading'.</xsl:text>
					</xsl:with-param>
					<xsl:with-param name="tg-target" select="'dobs.html#dob-subjects'"/>					
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>


<!-- ######################### ERROR-TEST TEMPLATES ######################### -->
<!-- Templates that apply stylistic tests to the current context. Test names should indicate the
     element to which they apply, unless they are used by multiple elements. -->
<!-- ######################################################################## -->

   <!-- ********************************************* -->
   <!-- Template: abstract-attribute-test
         Removed this test, overhaul of manuscript
         stylecheck rules KP 2015-11-03
         Manuscript to follow PMC rules
        
        Context: abstract                             -->
   <!-- ********************************************* -->   
   <!--<xsl:template name="abstract-attribute-test">
      
      <xsl:if test="(@abstract-type and @abstract-type!='graphical') or @xml:lang">
         <xsl:call-template name="make-error">
				<xsl:with-param name="error-type">abstract attribute check</xsl:with-param>
            <xsl:with-param name="description">
               <xsl:text>Do not use abstract-type (except for @abstract-type="graphical") or xml:lang attributes.</xsl:text>
            </xsl:with-param>
				<xsl:with-param name="tg-target" select="'tags.html#el-abs'"/>
         </xsl:call-template>
      </xsl:if>
   </xsl:template>-->
   <!-- ********************************************* -->
	
	<!-- ********************************************* -->
	<!-- Template: abstract-sec-test
        	If abstract has 1 first-level section with only 2nd level sections
        	(no non-title content), warn that nesting may be wrong.
	-->
	<!-- ********************************************* -->   
	<xsl:template name="abstract-sec-test">
		<xsl:if test="sec and sec/sec">
			<xsl:if test="count(sec)=1 and count(sec/sec) > 1">
				<xsl:call-template name="make-error">
					<xsl:with-param name="error-type">abstract-sec-test</xsl:with-param>
					<xsl:with-param name="description">
						<xsl:text>abstract contains multiple nested sections; check that the structure is correct.</xsl:text>
					</xsl:with-param>
					<xsl:with-param name="class" select="'warning'"/>
				</xsl:call-template>
			</xsl:if>
		</xsl:if>
	</xsl:template>
   

  <!-- ********************************************* -->
   <!-- Template: abstract-title-test
        
        Abstract should only have a title if it is different
		  from 'Abstract'
        
        Context: abstract                             -->
   <!-- ********************************************* -->   
   <xsl:template name="abstract-title-test">
      <xsl:if test="translate(normalize-space(title), 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz') = 'abstract'">
         <xsl:call-template name="make-error">
            <xsl:with-param name="error-type">abstract title check</xsl:with-param>
            <xsl:with-param name="description">
               <xsl:text>&lt;title&gt; is only needed if it is not 'Abstract'.</xsl:text>
            	</xsl:with-param>
				<xsl:with-param name="tg-target" select="'tags.html#el-abs'"/>
				<xsl:with-param name="class">
					<xsl:choose>
						<xsl:when test="$stream='manuscript'">
							<xsl:text>error</xsl:text>
							</xsl:when>
						<xsl:otherwise>
							<xsl:text>warning</xsl:text>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:with-param>
         	</xsl:call-template>
      </xsl:if>
   </xsl:template>
   
   
	<!-- *********************************************************** -->
	<!-- Template: alternatives-child-count 
		Used for alternatives, *-alternatives: Error if fewer than 2 elements-->
	<!-- *********************************************************** -->
	<xsl:template name="alternatives-child-count">
		<xsl:param name="context"/>
		<xsl:if test="count($context/*) &lt; 2">
			<xsl:call-template name="make-error">
				<xsl:with-param name="error-type" select="concat(local-name($context),' error ')"/>
				<xsl:with-param name="description">
					<xsl:value-of select="local-name($context)"/>
					<xsl:text> must contain more than 1 child element.</xsl:text>
				</xsl:with-param>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
	
	<!-- *********************************************************** -->
	<!-- Template: aff-xref-check
		Affiliations must not contain xref ref-type="aff"		
		-->
	<!-- *********************************************************** -->
	<xsl:template name="aff-xref-check">
		<xsl:if test="descendant::xref[@ref-type='aff']">
			<xsl:call-template name="make-error">
				<xsl:with-param name="error-type">
					<xsl:text>aff check</xsl:text>
				</xsl:with-param>
				<xsl:with-param name="description">
					<xsl:text>Affiliations must not contain xrefs to affiliations.</xsl:text>
				</xsl:with-param>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
	

	<!-- *********************************************************** -->
	<!-- Template: aff-alternatives-content-check
		1) Must have more than 1 child
		2) Children must carry either @xml:lang or @specific-use
		3) If children specify @xml:lang, exactly 1 must be the same as /article 
			and all the values should be unique
		4) If any child specifies @specific-use, all must
			and all the values should be different
		-->
	<!-- *********************************************************** -->
	<xsl:template name="aff-alternatives-content-check">
		<xsl:param name="context" select="."/>
		
		<!-- 1 -->
		<xsl:call-template name="alternatives-child-count">
			<xsl:with-param name="context" select="."/>
		</xsl:call-template>
		
		<!-- 2 -->
		<xsl:if test="not($context/aff[@xml:lang]) and not($context/aff[@specific-use])">
			<xsl:call-template name="make-error">
				<xsl:with-param name="error-type">
					<xsl:text>aff-alternatives check</xsl:text>
				</xsl:with-param>
				<xsl:with-param name="description">
					<xsl:text>Elements in aff-alternatives must be distinguised by either @xml:lang or @specific-use.</xsl:text>
				</xsl:with-param>
				<xsl:with-param name="tg-target" select="'tags.html#el-aff-alternatives'"/>
			</xsl:call-template>
		</xsl:if>
		
		<!-- 3 -->
		<xsl:if test="$context/aff[@xml:lang]">			
			<xsl:call-template name="alternatives-xml-lang-check">
				<xsl:with-param name="context" select="'aff-alternatives'"/>
				<xsl:with-param name="nodes" select="$context/aff"/>				
			</xsl:call-template>
		</xsl:if>
		
		<!-- 4 -->
		<xsl:if test="$context/aff[@specific-use]">
			<xsl:call-template name="alternatives-specific-use-check">
				<xsl:with-param name="context" select="'aff-alternatives'"/>
				<xsl:with-param name="nodes" select="$context/aff"/>	
			</xsl:call-template>			
		</xsl:if>
	</xsl:template>


   <!-- *********************************************************** -->
   <!-- Template: alternatives-content-check 
   		1) Must have > 1 child
   		2) alternatives content depends on parent
     -->
   <!-- *********************************************************** -->
   <xsl:template name="alternatives-content-check">   	
   	<xsl:call-template name="alternatives-child-count">
   		<xsl:with-param name="context" select="."/>
   	</xsl:call-template>
		<xsl:choose>
			<xsl:when test="parent::chem-struct">
				<xsl:if test="chem-struct">
					<xsl:call-template name="make-error">
						<xsl:with-param name="error-type">alternatives content check</xsl:with-param>
               		<xsl:with-param name="description">
                  		<xsl:text>&lt;alternatives&gt; in &lt;</xsl:text>
								<xsl:value-of select="name(parent::node())"/>
								<xsl:text>&gt; may not contain &lt;</xsl:text>
								<xsl:value-of select="name(parent::node())"/>
								<xsl:text>&gt;.</xsl:text>
               		</xsl:with-param>
						<xsl:with-param name="tg-target" select="'tags.html#el-alternatives'"/>
            		</xsl:call-template>
					</xsl:if>
				</xsl:when>
			<xsl:when test="parent::inline-supplementary-material">
				<xsl:if test="inline-supplementary-material">
					<xsl:call-template name="make-error">
						<xsl:with-param name="error-type">alternatives content check</xsl:with-param>
               		<xsl:with-param name="description">
                  		<xsl:text>&lt;alternatives&gt; in &lt;</xsl:text>
								<xsl:value-of select="name(parent::node())"/>
								<xsl:text>&gt; may not contain &lt;</xsl:text>
								<xsl:value-of select="name(parent::node())"/>
								<xsl:text>&gt;.</xsl:text>
               		</xsl:with-param>
						<xsl:with-param name="tg-target" select="'tags.html#el-alternatives'"/> 
            		</xsl:call-template>
					</xsl:if>
				</xsl:when>
			<xsl:when test="parent::supplementary-material">
				<xsl:if test="supplementary-material">
					<xsl:call-template name="make-error">
						<xsl:with-param name="error-type">alternatives content check</xsl:with-param>
               		<xsl:with-param name="description">
                  		<xsl:text>&lt;alternatives&gt; in &lt;</xsl:text>
								<xsl:value-of select="name(parent::node())"/>
								<xsl:text>&gt; may not contain &lt;</xsl:text>
								<xsl:value-of select="name(parent::node())"/>
								<xsl:text>&gt;.</xsl:text>
               		</xsl:with-param>
						<xsl:with-param name="tg-target" select="'tags.html#el-alternatives'"/>
            		</xsl:call-template>
					</xsl:if>
				</xsl:when>
			<xsl:when test="parent::array">
				<xsl:if test="array">
					<xsl:call-template name="make-error">
						<xsl:with-param name="error-type">alternatives content check</xsl:with-param>
               		<xsl:with-param name="description">
                  		<xsl:text>&lt;alternatives&gt; in &lt;</xsl:text>
								<xsl:value-of select="name(parent::node())"/>
								<xsl:text>&gt; may not contain &lt;</xsl:text>
								<xsl:value-of select="name(parent::node())"/>
								<xsl:text>&gt;.</xsl:text>
               		</xsl:with-param>
						<xsl:with-param name="tg-target" select="'tags.html#el-alternatives'"/>
            		</xsl:call-template>
					</xsl:if>
			</xsl:when>
			
			<!-- Test that at least 1 of PMC's preferred elements exists -->
			
			<xsl:when test="parent::element-citation or
			                parent::mixed-citation or
								 parent::p">
				<xsl:if test="not(textual-form)">
					<xsl:call-template name="make-error">
						<xsl:with-param name="error-type">alternatives content check</xsl:with-param>
               		<xsl:with-param name="description">
                  		<xsl:text>&lt;alternatives&gt; in &lt;</xsl:text>
								<xsl:value-of select="name(parent::node())"/>
								<xsl:text>&gt; must contain &lt;textual-form&gt;.</xsl:text>
               		</xsl:with-param>
						<xsl:with-param name="tg-target" select="'tags.html#el-alternatives'"/> 
            		</xsl:call-template>
					</xsl:if>
				</xsl:when>
			<xsl:when test="parent::disp-quote or
			                parent::boxed-text or
								 parent::sig or
								 parent::sig-block or 
								 parent::glossary">
				<xsl:if test="not(textual-form) and not(graphic)">
					<xsl:call-template name="make-error">
						<xsl:with-param name="error-type">alternatives content check</xsl:with-param>
               		<xsl:with-param name="description">
                  		<xsl:text>&lt;alternatives&gt; in &lt;</xsl:text>
								<xsl:value-of select="name(parent::node())"/>
								<xsl:text>&gt; must contain one of these elements: &lt;textual-form&gt; or &lt;graphic&gt;.</xsl:text>
               		</xsl:with-param>
						<xsl:with-param name="tg-target" select="'tags.html#el-alternatives'"/> 
            		</xsl:call-template>
					</xsl:if>
				</xsl:when>
			<xsl:when test="parent::fig">
				<xsl:if test="not(media) and not(graphic)">
					<xsl:call-template name="make-error">
						<xsl:with-param name="error-type">alternatives content check</xsl:with-param>
               		<xsl:with-param name="description">
                  		<xsl:text>&lt;alternatives&gt; in &lt;</xsl:text>
								<xsl:value-of select="name(parent::node())"/>
               			<xsl:text>&gt; must contain one of these elements: &lt;media&gt; or &lt;graphic&gt;.</xsl:text>
               		</xsl:with-param>
						<xsl:with-param name="tg-target" select="'tags.html#el-alternatives'"/>
            		</xsl:call-template>
					</xsl:if>
				</xsl:when>
			<xsl:when test="parent::app">
				<xsl:if test="not(media) and not(textual-form) and not(table)">
					<xsl:call-template name="make-error">
						<xsl:with-param name="error-type">alternatives content check</xsl:with-param>
               		<xsl:with-param name="description">
                  		<xsl:text>&lt;alternatives&gt; in &lt;</xsl:text>
								<xsl:value-of select="name(parent::node())"/>
               			<xsl:text>&gt; must contain one of these elements: &lt;media&gt;, &lt;table&gt;, &lt;textual-form&gt;.</xsl:text>
               		</xsl:with-param>
						<xsl:with-param name="tg-target" select="'tags.html#el-alternatives'"/> 
            		</xsl:call-template>
					</xsl:if>
				</xsl:when>
			<xsl:when test="parent::chem-struct or
			                parent::chem-struct-wrap or
								 parent::disp-formula or
								 parent::inline-formula">
				<xsl:if test="not(tex-math) and not(graphic) and not(mml:math) and not(media)">
					<xsl:call-template name="make-error">
						<xsl:with-param name="error-type">alternatives content check</xsl:with-param>
               		<xsl:with-param name="description">
                  		<xsl:text>&lt;alternatives&gt; in &lt;</xsl:text>
								<xsl:value-of select="name(parent::node())"/>
               			<xsl:text>&gt; must contain one of these elements: &lt;tex-math&gt;, &lt;graphic&gt;, &lt;media&gt;, or &lt;mml:math&gt;.</xsl:text>
               		</xsl:with-param>
						<xsl:with-param name="tg-target" select="'tags.html#el-alternatives'"/> 
            		</xsl:call-template>
					</xsl:if>
				</xsl:when>
			<xsl:when test="parent::inline-supplementary-materials or
			                parent::supplementary-materials">
				<xsl:if test="not(textual-form) and not(graphic) and not(media) and not(table)">
					<xsl:call-template name="make-error">
						<xsl:with-param name="error-type">alternatives content check</xsl:with-param>
               		<xsl:with-param name="description">
                  		<xsl:text>&lt;alternatives&gt; in &lt;</xsl:text>
								<xsl:value-of select="name(parent::node())"/>
               			<xsl:text>&gt; must contain one of these elements: &lt;textual-form&gt;, &lt;graphic&gt;, &lt;media&gt; or &lt;table&gt;.</xsl:text>
               		</xsl:with-param>
						<xsl:with-param name="tg-target" select="'tags.html#el-alternatives'"/> 
            		</xsl:call-template>
					</xsl:if>
				</xsl:when>
			<xsl:when test="parent::array">
				<xsl:if test="not(textual-form) and not(preformat) and not(table)">
					<xsl:call-template name="make-error">
						<xsl:with-param name="error-type">alternatives content check</xsl:with-param>
               		<xsl:with-param name="description">
                  		<xsl:text>&lt;alternatives&gt; in &lt;</xsl:text>
								<xsl:value-of select="name(parent::node())"/>
               			<xsl:text>&gt; must contain one of these elements: &lt;textual-form&gt;, &lt;preformat&gt; or &lt;table&gt;.</xsl:text>
               		</xsl:with-param>
						<xsl:with-param name="tg-target" select="'tags.html#el-alternatives'"/> 
            		</xsl:call-template>
					</xsl:if>
				</xsl:when>
			<xsl:when test="parent::table-wrap">
				<xsl:if test="not(textual-form) and not(preformat) and not(table) and not(graphic) and not(array)">
					<xsl:call-template name="make-error">
						<xsl:with-param name="error-type">alternatives content check</xsl:with-param>
               		<xsl:with-param name="description">
                  		<xsl:text>&lt;alternatives&gt; in &lt;</xsl:text>
								<xsl:value-of select="name(parent::node())"/>
               			<xsl:text>&gt; must contain one of these elements: &lt;textual-form&gt;, &lt;preformat&gt;, &lt;array&gt; or &lt;table&gt;.</xsl:text>
               		</xsl:with-param>
						<xsl:with-param name="tg-target" select="'tags.html#el-alternatives'"/> 
            		</xsl:call-template>
					</xsl:if>
			</xsl:when>
			<xsl:when test="parent::td or parent::th">
				<xsl:if test="not(textual-form) and not(graphic)">
					<xsl:call-template name="make-error">
						<xsl:with-param name="error-type">alternatives content check</xsl:with-param>
						<xsl:with-param name="description">
							<xsl:text>&lt;alternatives&gt; in &lt;</xsl:text>
							<xsl:value-of select="name(parent::node())"/>
							<xsl:text>&gt; must contain one of these elements: &lt;textual-form&gt;, &lt;graphic&gt;.</xsl:text>
						</xsl:with-param>
						<xsl:with-param name="tg-target" select="'tags.html#el-alternatives'"/> 
					</xsl:call-template>
				</xsl:if>
			</xsl:when>
			</xsl:choose>
		</xsl:template>
	
   <!-- *********************************************************** -->
   <!-- Template: alternatives-parent-check 
   
     -->
   <!-- *********************************************************** -->
   <xsl:template name="alternatives-parent-check">
		<xsl:variable name="alternatives-parent-values" select="concat(
            'app ',
            'array ',
            'boxed-text ',
            'chem-struct ',
            'chem-struct-wrap ',
            'disp-formula ',
            'disp-quote ',
            'element-citation ',
            'fig ',
            'glossary ',
            'inline-supplementary-material ',
            'inline-formula ',
            'mixed-citation ',
            'p ',
	       'sig ',
            'sig-block ',
            'supplementary-material ',
            'table-wrap ',
            'td ',
            'th ',
 	        '')"/>
	  <xsl:variable name="is-in-approved-parent">
	     <xsl:call-template name="is-in-list">
		    <xsl:with-param name="list"  select="$alternatives-parent-values"/>
		    <xsl:with-param name="token" select="name(parent::node())"/>
		    <xsl:with-param name="case"  select="'1'"/>
		 	</xsl:call-template>
	  	</xsl:variable>
		<xsl:if test="$is-in-approved-parent!='1'">
			<xsl:call-template name="make-error">
				<xsl:with-param name="error-type">alternatives parent check</xsl:with-param>
               <xsl:with-param name="description">
                  <xsl:text>&lt;alternatives&gt; is only allowed in elements named:</xsl:text>
						<xsl:value-of select="$alternatives-parent-values"/>
						<xsl:text>.</xsl:text>
               </xsl:with-param>
				<xsl:with-param name="tg-target" select="'tags.html#el-alternatives'"/>
            </xsl:call-template>
			</xsl:if>
   </xsl:template>
	
	
	<!-- *********************************************************** -->
	<!-- Template: alternatives-specific-use-check 
		1) If any $nodes has @specific-use, all must
		2) Values of $nodes/@specific-use should all be unique
	-->
	<!-- *********************************************************** -->
	<xsl:template name="alternatives-specific-use-check">
		<xsl:param name="context"/>
		<xsl:param name="nodes"/>		
		<xsl:variable name="att-name" select="'specific-use'"/>
		<xsl:variable name="unique-values">
			<xsl:call-template name="alternatives-unique-att-values">
				<xsl:with-param name="nodes" select="$nodes"/>
				<xsl:with-param name="att-name" select="'specific-use'"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:if test="$nodes[not(@specific-use)]">
			<xsl:call-template name="make-error">
				<xsl:with-param name="error-type">
					<xsl:value-of select="$context"/>
					<xsl:text> check</xsl:text>
				</xsl:with-param>
				<xsl:with-param name="description">
					<xsl:text>[</xsl:text>
					<xsl:value-of select="local-name($nodes[1])"/>
					<xsl:text>] in [</xsl:text>
					<xsl:value-of select="$context"/>
					<xsl:text>] must all include @specific-use if any include it.</xsl:text>
				</xsl:with-param>
			</xsl:call-template>	
		</xsl:if>
		
		<xsl:if test="$unique-values='no'">
			<xsl:call-template name="make-error">
				<xsl:with-param name="error-type">
					<xsl:value-of select="$context"/>
					<xsl:text> check</xsl:text>
				</xsl:with-param>
				<xsl:with-param name="class" select="'warning'"/>
				<xsl:with-param name="description">
					<xsl:text>@specific-use on </xsl:text>
					<xsl:value-of select="$context"/>
					<xsl:text>/</xsl:text>
					<xsl:value-of select="local-name($nodes[1])"/>
					<xsl:text> should be unique.</xsl:text>
				</xsl:with-param>
			</xsl:call-template>
		</xsl:if>		
	</xsl:template>
	
	
	
	<!-- *********************************************************** -->
	<!-- Template: alternatives-unique-att-values
		$nodes = elements with attribute to check
		$att-name = name of attribute to check
		
		Checks uniquness of $att-name values across $nodes.
		Returns 'yes' if values are unique, 'no' if they are not.		
	-->
	<!-- *********************************************************** -->
	<xsl:template name="alternatives-unique-att-values">
		<xsl:param name="nodes"/>
		<xsl:param name="att-name"/>
		<xsl:variable name="my-att-value" select="$nodes[1]/@*[name(.)=$att-name]"/>
		<xsl:if test="$nodes">
			<xsl:choose>
				<xsl:when test="$my-att-value=$nodes[position() != 1]/@*[name(.)=$att-name]">
					<xsl:text>no</xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:choose>
						<xsl:when test="$nodes[2]">
							<xsl:call-template name="alternatives-unique-att-values">
								<xsl:with-param name="nodes" select="$nodes[position()>1]"/>
								<xsl:with-param name="att-name" select="$att-name"/>
							</xsl:call-template>
						</xsl:when>
						<xsl:otherwise>
							<xsl:text>yes</xsl:text>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:if>
	</xsl:template>
	
	
	<!-- *********************************************************** -->
	<!-- Template: alternatives-xml-lang-check
		1) Exactly 1 $nodes must have same @xml:lang as /article
		2) Values of $nodes/@xml:lang should all be unique
	-->
	<!-- *********************************************************** -->
	<xsl:template name="alternatives-xml-lang-check">
		<xsl:param name="context"/>		
		<xsl:param name="nodes"/>		
		<xsl:variable name="att-name" select="'xml:lang'"/>
		<xsl:variable name="unique-values">
			<xsl:call-template name="alternatives-unique-att-values">
				<xsl:with-param name="nodes" select="$nodes"/>
				<xsl:with-param name="att-name" select="'xml:lang'"/>
			</xsl:call-template>
		</xsl:variable>
		
		<xsl:if test="count($nodes[@xml:lang=$art-lang-att] | $nodes[not(@xml:lang)]) != 1">
			<xsl:call-template name="make-error">
				<xsl:with-param name="error-type">
					<xsl:value-of select="$context"/>
					<xsl:text> check</xsl:text>
				</xsl:with-param>
				<xsl:with-param name="description">
					<xsl:text>Exactly one [</xsl:text>
					<xsl:value-of select="local-name($nodes[1])"/>
					<xsl:text>] in [</xsl:text>
					<xsl:value-of select="$context"/>
					<xsl:text>] must have the @xml:lang as [article].</xsl:text>
				</xsl:with-param>
			</xsl:call-template>
		</xsl:if>
		
		<xsl:if test="$unique-values='no'">
			<xsl:call-template name="make-error">
				<xsl:with-param name="error-type">
					<xsl:value-of select="$context"/>
					<xsl:text> check</xsl:text>
				</xsl:with-param>
				<xsl:with-param name="class" select="'warning'"/>
				<xsl:with-param name="description">
					<xsl:text>@xml:lang on </xsl:text>
					<xsl:value-of select="$context"/>
					<xsl:text>/</xsl:text>
					<xsl:value-of select="local-name($nodes[1])"/>
					<xsl:text> should be unique.</xsl:text>
				</xsl:with-param>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
	
	
	
  <!-- *********************************************************** -->
   <!-- Template: article-id-content-check 
   
        article-id must have content
     -->
   <!-- *********************************************************** -->
   <xsl:template name="article-id-content-check">
      <xsl:param name="context" select="."/>

      <xsl:choose>
         <xsl:when test="contains($context[normalize-space()],' ') and @pub-id-type='manuscript'">
            <xsl:call-template name="make-error">
               <xsl:with-param name="error-type">article-id check</xsl:with-param>
               <xsl:with-param name="description">
                  <xsl:text>manuscript id must not contain a space</xsl:text>
               </xsl:with-param>
            </xsl:call-template>
				</xsl:when>
         <xsl:when test="$context[normalize-space()]">
            <!-- No problem -->
         </xsl:when>
         
         <xsl:otherwise>
            <xsl:call-template name="make-error">
               <xsl:with-param name="error-type">article-id check</xsl:with-param>
               <xsl:with-param name="description">
                  <xsl:text>article-id must contain a value</xsl:text>
               </xsl:with-param>
				<xsl:with-param name="tg-target" select="'tags.html#el-artid'"/>
            </xsl:call-template>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>

   <!-- *********************************************************** -->
   <!-- Template: article-language-check 
   
       check that articles that are supposed to be in english are englishy
     -->
   <!-- *********************************************************** -->
	<xsl:template name="article-language-check">
		<xsl:variable name="bodytext">
			<xsl:for-each select="descendant::p[parent::body or parent::sec]">
				<xsl:apply-templates mode="dumptext"/>
			</xsl:for-each>
		</xsl:variable>
		<xsl:if test="$art-lang-att='en'">
			<xsl:choose>
				<xsl:when test="contains($bodytext,' the ') and
					contains($bodytext,' a ') and 
					contains($bodytext,' is ')"/>
				<xsl:otherwise>
					<xsl:call-template name="make-error">
						<xsl:with-param name="error-type">language check</xsl:with-param>
						<xsl:with-param name="description">
							<xsl:text>article is listed with @xml:lang='en', but it does not seem to be English.</xsl:text>
						</xsl:with-param>
					</xsl:call-template>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:if>
		
	</xsl:template>

   <!-- *********************************************************** -->
   <!-- Template: article-pi-check 
   
        article with <?OLF?> may not have <?properties no_embargo?>
     -->
   <!-- *********************************************************** -->
   <xsl:template name="article-pi-check">
      <xsl:param name="context" select="."/>

         <xsl:if test="//processing-instruction('OLF') or contains(//processing-instruction('properties'),'OLF')">
				<xsl:if test="contains(//processing-instruction('properties'),'no_embargo')">
            <xsl:call-template name="make-error">
               <xsl:with-param name="error-type">article-pi check</xsl:with-param>
               <xsl:with-param name="description">
                  <xsl:text>article with an "Online First" processing instruction should not have a "No Embargo" processing-instruction.</xsl:text>
               </xsl:with-param>
            </xsl:call-template>
         </xsl:if>
         </xsl:if>
   </xsl:template>


   <!-- *********************************************************** -->
   <!-- Template: article-release-delay-check 
   
        article with <?OLF?> may not have <?properties no_embargo?>
     -->
   <!-- *********************************************************** -->
   <xsl:template name="article-release-delay-check">
      <xsl:param name="context" select="."/>

         <xsl:for-each select="//processing-instruction('release-delay')">
				<xsl:variable name="months" select="substring-before(.,'|')"/>
				<xsl:variable name="days" select="substring-after(.,'|')"/>
			
				<xsl:choose>

				<xsl:when test="normalize-space($months)='' or normalize-space($days)=''">
            <xsl:call-template name="make-error">
               <xsl:with-param name="error-type">release-delay-pi check</xsl:with-param>
               <xsl:with-param name="description">
                  <xsl:text>release-delay processing instruction must include a value for both months and days - even if it is "0" (zero).</xsl:text>
               </xsl:with-param>
				<xsl:with-param name="tg-target" select="'genprac.html#embargo'"/>
            </xsl:call-template>
         	</xsl:when> 
				
				<xsl:when test="normalize-space($months) = 'O' or normalize-space($days) = 'O'">
				<!-- check for capital 'oh' instead of zero -->
            <xsl:call-template name="make-error">
               <xsl:with-param name="error-type">release-delay-pi check</xsl:with-param>
               <xsl:with-param name="description">
                  <xsl:text>day and month values must be numbers. There is a capital 'oh' rather than a zero.</xsl:text>
               </xsl:with-param>
            	<xsl:with-param name="tg-target" select="'genprac.html#embargo'"/>
            </xsl:call-template>
         	</xsl:when> 
			
				<xsl:when test="not(contains(.,'|')) or (not(number($months)) and normalize-space($months) != '0') or (not(number($days)) and normalize-space($days) != '0')">
            <xsl:call-template name="make-error">
               <xsl:with-param name="error-type">release-delay-pi check</xsl:with-param>
               <xsl:with-param name="description">
                  <xsl:text>release-delay processing instruction must be of the form &lt;?release-delay x|y ?&gt; where x is the month value and y is the day value.</xsl:text>
               </xsl:with-param>
            	<xsl:with-param name="tg-target" select="'genprac.html#embargo'"/>
            </xsl:call-template>
         	</xsl:when> 
				
				</xsl:choose>
			
			
	<!--			<xsl:if test="not(contains(.,'|')) ">
            <xsl:call-template name="make-error">
               <xsl:with-param name="error-type">release-delay-pi check</xsl:with-param>
               <xsl:with-param name="description">
                  <xsl:text>NO PIPE.</xsl:text><xsl:value-of select="$months"/>[<xsl:value-of select="number($months)"/>]|<xsl:value-of select="$days"/>[<xsl:value-of select="number($days)"/>]{<xsl:value-of select="."/>}
               </xsl:with-param>
               <xsl:with-param name="tg-target" select="'genprac.html#embargo'"/>
            </xsl:call-template>
         </xsl:if>
			
			
				<xsl:if test="not(number($months)) and normalize-space($months) != '0'">
            <xsl:call-template name="make-error">
               <xsl:with-param name="error-type">release-delay-pi check</xsl:with-param>
               <xsl:with-param name="description">
                  <xsl:text>MONTH FAILED</xsl:text><xsl:value-of select="$months"/>[<xsl:value-of select="number($months)"/>]|<xsl:value-of select="$days"/>[<xsl:value-of select="number($days)"/>]{<xsl:value-of select="."/>}
               </xsl:with-param>
               <xsl:with-param name="tg-target" select="'genprac.html#embargo'"/>
            </xsl:call-template>
         </xsl:if>
			
			
				<xsl:if test="not(number($days)) and normalize-space($days) != '0'">
            <xsl:call-template name="make-error">
               <xsl:with-param name="error-type">release-delay-pi check</xsl:with-param>
               <xsl:with-param name="description">
                  <xsl:text>DAYS FAILED.</xsl:text><xsl:value-of select="$months"/>[<xsl:value-of select="number($months)"/>]|<xsl:value-of select="$days"/>[<xsl:value-of select="number($days)"/>]{<xsl:value-of select="."/>}
               </xsl:with-param>
               <xsl:with-param name="tg-target" select="'genprac.html#embargo'"/>
            </xsl:call-template>
         </xsl:if> -->
			
			
			
         </xsl:for-each>
   </xsl:template>


   <!-- *********************************************************** -->
   <!-- Template: article-type-content-check 
   
        Checks that article-type attribute has one of the allowed values. 
		This does nothing if no value is provided.
     -->
   <!-- *********************************************************** -->
   <xsl:template name="article-type-content-check">
      <xsl:param name="context" select="."/>
      
      <xsl:variable name="normalized" select="normalize-space($context/@article-type)"/>
      
      <xsl:choose>
         <!-- Not present -->
         <xsl:when test="string-length($normalized) = 0">
            <!-- Do nothing (will be covered by another test) -->
         </xsl:when>
         
         <!-- Recognized value: no problem -->
         <xsl:when test="                          
            $normalized = 'abstract'                          
            or $normalized = 'addendum'                          
            or $normalized = 'admin'                              
            or $normalized = 'advert'                          
            or $normalized = 'announcement'                          
            or $normalized = 'article-commentary'                          
            or $normalized = 'book-review'                          
            or $normalized = 'books-received'                          
            or $normalized = 'brief-report'                          
            or $normalized = 'calendar'                          
            or $normalized = 'case-report'                          
            or $normalized = 'collection'                          
            or $normalized = 'correction'                         
            or $normalized = 'cover'                          
            or $normalized = 'data-paper'                          
            or $normalized = 'discussion'                          
            or $normalized = 'editorial'                          
            or $normalized = 'expression-of-concern'                          
            or $normalized = 'filler'                          
            or $normalized = 'in-brief'                          
            or $normalized = 'index'                          
            or $normalized = 'introduction'                          
            or $normalized = 'letter'                          
            or $normalized = 'meeting-report'                          
            or $normalized = 'methods-article'                          
            or $normalized = 'news'                          
            or $normalized = 'obituary'                          
            or $normalized = 'oration'                          
            or $normalized = 'product-review'                          
            or $normalized = 'protocol'                          
            or $normalized = 'rapid-communication'                          
            or $normalized = 'reply'                          
            or $normalized = 'report'                          
            or $normalized = 'research-article'                         
            or $normalized = 'retraction'                          
            or $normalized = 'review-article'                          
            or $normalized = 'systematic-review'       
            or $normalized = 'toc'                          
            or $normalized = 'tutorial'                          
            or $normalized = 'other'">
            <!-- This is correct-->
         </xsl:when>

         <!-- In scanned articles, can also have the following article-types -->
      	<xsl:when test="//processing-instruction('properties')[contains(.,'scanned_data')] and $normalized = 'index'">
            <!-- This is correct -->
         </xsl:when>

         <xsl:otherwise>
            <xsl:call-template name="make-error">
               <xsl:with-param name="error-type">article-type attribute check</xsl:with-param>
               <xsl:with-param name="description">
                  <xsl:text>Unknown article-type value '</xsl:text><xsl:value-of select="$normalized"/>'.
               </xsl:with-param>
 				<xsl:with-param name="tg-target" select="'dobs.html#dob-arttype'"/>
           </xsl:call-template>
         </xsl:otherwise>
      </xsl:choose>      
   </xsl:template>


   <!-- *********************************************************** -->
   <!-- Template: article-type-to-product-check
        
        If the article-type indicates that this is a book-review
        or product-review, then there should be a product. Make 
        this a warning, however, and not an error.
        
        EXCEPTION: no warning at all if this is scanning
     -->
   <!-- *********************************************************** -->
   <xsl:template name="article-type-to-product-check">
      <xsl:param name="context" select="."/>

      <xsl:if test="$context/@article-type[.='book-review' or .='product-review']">
         <xsl:choose>
            <xsl:when test="$context/front/article-meta/product">
               <!-- This is correct -->
            </xsl:when>
            
            <!-- Scanning data does not require a product element -->
            <xsl:when test="//processing-instruction('properties')
			   [contains(.,'scanned_data')]">
               <!-- Ignore any missing product element -->
            </xsl:when>
            
            <xsl:otherwise>
               <xsl:call-template name="make-error">
                  <xsl:with-param name="error-type">article-type attribute check</xsl:with-param>
                  <xsl:with-param name="class" select="'warning'"/>
                  <xsl:with-param name="description">
                     <xsl:text>article-type is set to 'book-review' or 'product-review' but the
                     article does not contain a product element</xsl:text>
                  </xsl:with-param>
               	<xsl:with-param name="tg-target" select="'dobs.html#dob-arttype'"/>
               </xsl:call-template>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:if>
   </xsl:template>


   <!-- *********************************************************** -->
   <!-- Template: article-type-to-related-article-check 
   
        For a given article-type attribute, check if have the required
		related-article element 
        and the right related-article-type attribute
     -->
   <!-- *********************************************************** -->
   <xsl:template name="article-type-to-related-article-check">
      <xsl:param name="context" select="."/>
      
      <xsl:choose>
         <!-- Correction -->
         <xsl:when test="$context/@article-type[.='expression-of-concern']">
            <!-- Could have more than one related article element: be happy if at least one has the right type-->
            <xsl:choose>
               <xsl:when test="$context//related-article[@related-article-type='object-of-concern']
               					or $context//related-object[@link-type='object-of-concern']">
                  <!-- This is correct-->
               </xsl:when>

               <xsl:otherwise>
                  <xsl:call-template name="make-error">
                     <xsl:with-param name="error-type">article-type attribute check</xsl:with-param>
                     <xsl:with-param name="description">
                        <xsl:text>Expression of Concern should have a related-article element with the related-article-type attribute set to 'object-of-concern' or a related-object element with the link-type attribute set to 'object-of-concern'</xsl:text>
                     </xsl:with-param>
							<xsl:with-param name="class" select="'error'"/>
                  </xsl:call-template>
               </xsl:otherwise>
            </xsl:choose>
         </xsl:when>
         
         <!-- Correction -->
         <xsl:when test="$context/@article-type[.='correction']">
            <!-- Could have more than one related article element: be happy if at least one has the right type-->
            <xsl:choose>
            	<xsl:when test="$context//related-article[@related-article-type='corrected-article']
            					or $context//related-object[@link-type='corrected-article']">
                  <!-- This is correct-->            			
               </xsl:when>

               <xsl:otherwise>
                  <xsl:call-template name="make-error">
                     <xsl:with-param name="error-type">article-type attribute check</xsl:with-param>
                     <xsl:with-param name="description">
                        <xsl:text>Corrections should have a related-article element with the related-article-type attribute set to 'corrected-article' or a related-ojbect element with the link-type attribute set to 'corrected-article'</xsl:text>
                     </xsl:with-param>
							<xsl:with-param name="class" select="'warning'"/>
                  </xsl:call-template>
               </xsl:otherwise>
            </xsl:choose>
         </xsl:when>
         
         <!-- Retraction -->
         <xsl:when test="$context/@article-type[.='retraction']">
            <!-- Could have more than one related article element: be happy if at least one has the right type-->
            <xsl:choose>
               <xsl:when test="$context//related-article[@related-article-type='retracted-article']
               					or $context//related-object[@link-type='retracted-article']">
                  <!-- This is correct-->
               </xsl:when>
               
               <xsl:otherwise>
                  <xsl:call-template name="make-error">
                     <xsl:with-param name="error-type">article-type attribute check</xsl:with-param>
                     <xsl:with-param name="description">
                        <xsl:text>Retractions should have a related-article element with the related-article-type attribute set to 'retracted-article' or a related-object element with the link-type attribute set to 'retracted-article'</xsl:text>
                     </xsl:with-param>
							<xsl:with-param name="class" select="'warning'"/>
                  </xsl:call-template>
               </xsl:otherwise>
            </xsl:choose>
         </xsl:when>
         
         <!-- in brief -->
         <xsl:when test="$context/@article-type[.='in-brief']">
            <xsl:choose>
               <xsl:when test="not($context//related-article) and not($context//related-object)">
                  <!-- No related article links at all: that's ok -->
               </xsl:when>

               <xsl:when test="$context//related-article[@related-article-type='article-reference']
               					or $context//related-object[@link-type='article-reference']">
                  <!-- has at least one link of the right type -->
               </xsl:when>
               
               <!-- There are related article links, but none are of the right type: issue a warning -->
               <xsl:otherwise>
                  <xsl:call-template name="make-error">
                     <xsl:with-param name="error-type">article-type attribute check</xsl:with-param>
                     <xsl:with-param name="class" select="'warning'"/>
                     <xsl:with-param name="description">
                     		<xsl:choose>
                     			<xsl:when test="$context//related-object">
                     				<xsl:text>If an *in brief* article has a related-object element, the link-type attribute should be set to [article-reference], not </xsl:text>
                     				<xsl:value-of select="$context//related-object/@link-type"/>
                     			</xsl:when>
                     			<xsl:otherwise>
                     				<xsl:text>If an *in brief* article has a related-article element, the related-article-type attribute should be set to [article-reference], not </xsl:text>
                     				<xsl:value-of select="$context//related-article/@related-article-type"/>
                     			</xsl:otherwise>
                     		</xsl:choose>
				</xsl:with-param>
                  </xsl:call-template>
               </xsl:otherwise>
            </xsl:choose>
         </xsl:when>
         
         <!-- reply -->
         <xsl:when test="$context/@article-type[.='reply']">
            <!-- Could have more than one related article element: be happy if at least one has the right type-->
            <xsl:choose>
               <xsl:when test="$context//related-article[@related-article-type='letter']
               					or $context//related-object[@link-type='letter']">
                  <!-- This is correct-->
               </xsl:when>
               
               <!-- Scanning data does not require a related-article element -->
               <xsl:when test="//processing-instruction('properties')[contains(.,'scanned_data')]">
                  <!-- Ignore any missing related-article element -->
               </xsl:when>

               <xsl:otherwise>
                  <xsl:call-template name="make-error">
                     <xsl:with-param name="error-type">article-type attribute check</xsl:with-param>
                     <xsl:with-param name="class" select="'warning'"/>
                     <xsl:with-param name="description">
                        <xsl:text>Replies should have a related-article element with the related-article-type attribute set to 'letter', not '</xsl:text>
						<xsl:value-of select="$context//related-article/@related-article-type | $context//related-object/@link-type"/>'.
                     </xsl:with-param>
                  </xsl:call-template>
               </xsl:otherwise>
            </xsl:choose>
         </xsl:when>

         <!-- article-commentary -->
         <xsl:when test="$context/@article-type[.='article-commentary']">
            <!-- Could have more than one related article element: 
			     be happy if at least one has the right type-->
            <xsl:choose>
               <xsl:when test="$context//related-article[@related-article-type='commentary-article']
               					or $context//related-object[@link-type='commentary-article']">
                  <!-- This is correct-->
               </xsl:when>

               <!-- Scanning data does not require a related-article element -->
               <xsl:when test="//processing-instruction('properties')
			                     [contains(.,'scanned_data')]">
                  <!-- Ignore any missing related-article element -->
               </xsl:when>
               
               <xsl:otherwise>
                  <xsl:call-template name="make-error">
                     <xsl:with-param name="error-type">
					    article-type attribute check</xsl:with-param>
                     <xsl:with-param name="class" select="'warning'"/>
                     <xsl:with-param name="description">
                        <xsl:text>Commentaries should have a related-article element with the related-article-type attribute set to 'commentary-article' or a related-object element with the link-type set to 'commentary-article', not '</xsl:text>
						<xsl:value-of select="$context//related-article/@related-article-type | $context//related-object/@link-type"/>'.
                     </xsl:with-param>
                  </xsl:call-template>
               </xsl:otherwise>
            </xsl:choose>
         </xsl:when>         
      </xsl:choose>
   </xsl:template>


   <!-- *********************************************************** -->
   <!-- Template: attribute-present-not-empty 
   
        Checks that an attribute is present and that
        it has a non-empty value
     -->
   <!-- *********************************************************** -->
   <xsl:template name="attribute-present-not-empty">
      <xsl:param name="context" select="."/>
      <xsl:param name="attribute-name" select="''"/>
      <xsl:param name="test-name" select="'attribute present check'"/>
      
      <xsl:choose>
         <!-- Not present -->
         <xsl:when test="not($context)">
            <xsl:call-template name="make-error">
               <xsl:with-param name="error-type" select="$test-name"/>
               <xsl:with-param name="description">
                  <xsl:if test="string-length($attribute-name) &gt; 0">
                     <xsl:value-of select="$attribute-name"/>
                     <xsl:text> </xsl:text>
                  </xsl:if>
                  <xsl:text>attribute is required</xsl:text>
               </xsl:with-param>
            </xsl:call-template>
         </xsl:when>
         
         <!-- No value -->
         <xsl:when test="string-length(normalize-space($context)) = 0">
            <xsl:call-template name="make-error">
               <xsl:with-param name="error-type" select="$test-name"/>
               <xsl:with-param name="description">
                  <xsl:value-of select="name($context)"/>
                  <xsl:text> attribute must have a value</xsl:text>
               </xsl:with-param>
            </xsl:call-template>
         </xsl:when>
      </xsl:choose>
   </xsl:template>


   <!-- *********************************************************** -->
   <!-- Template: author-notes-fn-type-check
   
        Make sure that fn inside author-notes do not 
        have certain, disallowed, fn-type values.
     -->
   <!-- *********************************************************** -->
   <xsl:template name="author-notes-fn-type-check">
      <xsl:param name="context" select="."/>
      
      <xsl:if test="$context/@fn-type[                    
         . = 'abbr'                    
         or . = 'supplementary-material'
      ]">
         <xsl:call-template name="make-error">
            <xsl:with-param name="error-type" select="'author-notes fn check'"/>
            <xsl:with-param name="description">
               <xsl:text>fn inside author-notes should not have fn-type set to '</xsl:text>
               <xsl:value-of select="$context/@fn-type"/>
               <xsl:text>'</xsl:text>
            </xsl:with-param>
         </xsl:call-template>
      </xsl:if>
   </xsl:template>


   <!-- *********************************************************** -->
   <!-- Template: back-element-check 
   
        Certain elements should only appear in <back>
        Elements tested include:
         ack (should not be direct child of body)
         fn-group (should not be in a sec inside body)
         glossary (should not be in a sec inside body) WARNING
         notes   (should not appear in sec inside body)       
     -->
   <!-- *********************************************************** -->
   <xsl:template name="back-element-check">
      <xsl:param name="context" select="."/>
      
      <xsl:variable name="has-error">
         <xsl:choose>
            <xsl:when test="$context[self::ack]">
               <xsl:choose>
                  <xsl:when test="$context[parent::sec/ancestor::body or parent::body]">
                     <xsl:text>true</xsl:text>
                  </xsl:when>
                  
                  <xsl:otherwise>
                     <xsl:text>false</xsl:text>
                  </xsl:otherwise>
               </xsl:choose>
            </xsl:when>

            <xsl:when test="$context[self::fn-group] and
			   $document-type!='book' and $document-type!='book-part'">
               <xsl:choose>
                  <xsl:when test="$context[parent::boxed-text]">
                     <xsl:text>false</xsl:text>
                  </xsl:when>

                  <xsl:when test="$context[parent::sec/ancestor::body] and parent!='boxed-text'">
                     <xsl:text>true</xsl:text>
                  </xsl:when>
                  
                  <xsl:otherwise>
                     <xsl:text>false</xsl:text>
                  </xsl:otherwise>
               </xsl:choose>
            </xsl:when>

            <xsl:when test="$context[self::notes]">
               <xsl:choose>
                  <!-- Ignore disclaimer notes: will have a separate test -->
                  <xsl:when test="$context[@notes-type = 'disclaimer']">
                     <xsl:text>false</xsl:text>
                  </xsl:when>
                                    
                  <!-- Should not be a descendant of body -->
                  <xsl:when test="$context[parent::sec/ancestor::body]">
                     <xsl:text>true</xsl:text>
                  </xsl:when>
                  
                  <xsl:otherwise>
                     <xsl:text>false</xsl:text>
                  </xsl:otherwise>
               </xsl:choose>
            </xsl:when>
            
            <xsl:otherwise>
               <xsl:text>false</xsl:text>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      
      <!-- Output error if not correct -->
      <xsl:if test="$has-error = 'true'">
         <xsl:call-template name="make-error">
            <xsl:with-param name="error-type">back element checking</xsl:with-param>
            <xsl:with-param name="description">
               <xsl:value-of select="name($context)"/>
               <xsl:text> should be moved to the back matter</xsl:text>
            </xsl:with-param>
 				<xsl:with-param name="tg-target" select="'tags.html#el-back'"/>
         </xsl:call-template>
      </xsl:if>


      <xsl:variable name="has-warning">
         <xsl:choose>
 
            <xsl:when test="$context[self::glossary]">
               <xsl:choose>
                  <xsl:when test="$context[parent::sec/ancestor::body]">
                     <xsl:text>true</xsl:text>
                  </xsl:when>
                  
                  <xsl:otherwise>
                     <xsl:text>false</xsl:text>
                  </xsl:otherwise>
               </xsl:choose>
            </xsl:when>
       
            <xsl:otherwise>
               <xsl:text>false</xsl:text>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>


      <!-- Output error if not correct --> 
      <xsl:if test="$has-warning = 'true'">
         <xsl:call-template name="make-error">
            <xsl:with-param name="error-type">back element checking</xsl:with-param>
            <xsl:with-param name="description">
					<xsl:text>Unless it is required here for the flow of the article, </xsl:text>
               <xsl:value-of select="name($context)"/>
               <xsl:text> should be moved to the back matter</xsl:text>
            	</xsl:with-param>
				<xsl:with-param name="class" select="'warning'"/> 				
				<xsl:with-param name="tg-target" select="'tags.html#el-back'"/>
         </xsl:call-template>
      </xsl:if>




   </xsl:template>


   <!-- *********************************************************** -->
   <!-- Template: back-title-check 
   
        back should not have a title
     -->
   <!-- *********************************************************** -->
   <xsl:template name="back-title-check">
      <xsl:param name="context" select="."/>
      
      <xsl:call-template name="make-error">
         <xsl:with-param name="error-type" select="'back title check'"/>
         <xsl:with-param name="description">
            <xsl:text>title should not be set in back</xsl:text>
         </xsl:with-param>
 				<xsl:with-param name="tg-target" select="'tags.html#el-back'"/>
      </xsl:call-template>
   </xsl:template>



   <!-- *********************************************************** -->
   <!-- Template: block-formatting-check 
   
        Helper template takes an element and checks whether
        all the child nodes are wrapped in <italic> or
        <bold> or <sc> formatting. 
        
        For example:
           <title>
              <bold>Special</bold> <italic>features</italic>
           </title>
        
        If "title" were passed in as the context to check,
        the template will generate a warning because all the
        content is formatted. The assumption is that this is
        probably not correct PMC style because the 
        title has been formatted for presentation.
        
        However, this:
           <title>
              <bold>Special</bold> new <italic>features</italic>
           </title>
        
        Would not generate a warning because the word "new" was not
        formatted.
     -->
   <!-- *********************************************************** -->
   <xsl:template name="block-formatting-check">
      <xsl:param name="context" select="."/>
      
      <xsl:choose>
         <!-- If this is an empty element, then is unformatted -->
         <xsl:when test="$context[not(*) and not(text()[normalize-space()])]">
            <!-- do nothing -->
         </xsl:when>
         
         <!-- If the context has non-blank text nodes, then
          there are unformatted items -->
         <xsl:when test="$context/text()[normalize-space()]">
            <!-- do nothing -->
         </xsl:when>
         
         <!-- If there are elements other than the ones
              used for formatting, then this also is
              treated as unformatted content -->
         <xsl:when test="$context/*[not(self::italic)                           
            and not(self::bold)                           
            and not(self::sc)                          
            and not(self::sup)]">
            <!-- do nothing -->
         </xsl:when>
         
         <!-- Treat as if everything is wrapped in some kind of formatting -->
         <xsl:otherwise>
            <xsl:call-template name="make-error">
               <xsl:with-param name="error-type" select="'block-formatting check'"/>
               <xsl:with-param name="class" select="'warning'"/>
               <xsl:with-param name="description">
                  <xsl:text>Entire content of </xsl:text>
                  <xsl:value-of select="name($context)"/>
                  <xsl:text> should not be formatted</xsl:text>
               </xsl:with-param>
				<xsl:with-param name="tg-target" select="'genprac.html#formatting'"/>
            </xsl:call-template>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>



   <!-- ********************************************* -->
   <!-- Template: caption-format-test
        
        Check that p inside caption has mixed
        content and does not solely consist of a
        single formatting element like bold or
        italic. If the p only contains a single
        formatting element, then the author is
        probably attempting to impose presentational
        markup on the content.
        
        This template recurses on each p inside
        caption to check; if an invalid p is found,
        recursion stops and an error message is
        returned.
        
        Context: caption -->
   <!-- ********************************************* -->   
   <xsl:template name="caption-format-test">
      <xsl:param name="recursing"/>
      <xsl:param name="p-to-check"/>
      
      <xsl:choose>
         <!-- Initialization -->
         <xsl:when test="not($recursing)">
            <xsl:call-template name="caption-format-test">
               <xsl:with-param name="recursing" select="1"/>
               <xsl:with-param name="p-to-check" select="title | p"/>
            </xsl:call-template>
         </xsl:when>
         
         <!-- Base case: all done and no problems found -->
         <xsl:when test="not($p-to-check)"/>
         
         <!-- Testing: see if the p is alright. If it is, then recurse,
         if not, then report error and end -->
         <xsl:otherwise>
            <xsl:choose>
               <xsl:when test="count($p-to-check[1]/node()[not(self::text()[not(normalize-space())])]) = 1 and $p-to-check[1]/node()[self::bold or self::italic or self::monospace or self::sc or self::strike or self::underline]">
                  <xsl:call-template name="make-error">
							<xsl:with-param name="error-type" select="'caption-format'"/>
							<xsl:with-param name="class">
								<xsl:choose>
									<xsl:when test="$stream='manuscript'">error</xsl:when>
									<xsl:otherwise>warning</xsl:otherwise>
									</xsl:choose>
								</xsl:with-param>
                     <xsl:with-param name="description">
                        <xsl:text>Entire content of &lt;</xsl:text>
								<xsl:value-of select="name($p-to-check[1])"/>
								<xsl:text>&gt; in &lt;caption&gt; has been wrapped in a formatting tag (bold, italic, etc.)</xsl:text>
                     </xsl:with-param>
                  </xsl:call-template>
               </xsl:when>
               <xsl:otherwise>
                  <xsl:call-template name="caption-format-test">
                     <xsl:with-param name="recursing" select="1"/>
                     <xsl:with-param name="p-to-check" select="$p-to-check[position() != 1]"/>
							<xsl:with-param name="tg-target" select="'genprac.html#formatting'"/>
                  </xsl:call-template>
               </xsl:otherwise>
            </xsl:choose>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>





   <!-- *********************************************************** -->
   <!-- Template: check-abstract-content  -->
   <!-- *********************************************************** -->
   <xsl:template name="check-abstract-content">
      <xsl:param name="context" select="."/>

      <!-- Should have zero or more than one secs
		     or a sec that follows p  -->
		<xsl:choose>
			<xsl:when test="count($context/sec) = 0
	                   or count($context/sec) &gt; 1
                      or $context/sec[preceding-sibling::p]">
            <!-- No problem -->
				</xsl:when>
       <!-- beck removed 2015-01-28   <xsl:when test="count($context/sec)=1 and $context/sec/title">
             My title is not "Abstract", no problem 
            <xsl:variable name="my-title">
					<xsl:call-template name="capitalize">
						<xsl:with-param name="str">
							<xsl:value-of select="$context/sec/title"/>
							</xsl:with-param>
						</xsl:call-template>
					</xsl:variable>
				<xsl:if test="$my-title!='ABSTRACT'"/>
				</xsl:when>  -->
			<xsl:otherwise>
				<xsl:call-template name="make-error">
               <xsl:with-param name="error-type">abstract content check</xsl:with-param>
               <xsl:with-param name="description">
                  <xsl:text>Only use sec if abstract must be divided into multiple sections. Otherwise, simply tag with p elements.</xsl:text>
               	</xsl:with-param>
					<xsl:with-param name="tg-target" select="'tags.html#el-abs'"/>
            	</xsl:call-template>
         	</xsl:otherwise>
      	</xsl:choose>
			
  	</xsl:template>


	<!-- *********************************************************** -->
   <!-- Template: check-abstract-type 
        
		If there are preceding sibling abstracts, then this abstract
		must have an abstract-type attribute; however, allow one abstract
		to have no abstract-type because this will be the one rendered
		as the "default".
     -->
   <!-- *********************************************************** -->
	<xsl:template name="check-abstract-type">
      <xsl:param name="context" select="."/>
		<xsl:variable name="first-without" select="$context/parent::node()/abstract[not(@abstract-type)][1]"/>
      
		<xsl:choose>
         <!-- This is the first abstract without a type: that's ok -->
         <xsl:when test="$context[not(@abstract-type)]
		             and generate-id($context) = generate-id($first-without)"/>
         <!-- Has no abstract-type but is not the first: that's an error -->
         <xsl:when test="$context[not(@abstract-type)]">
            <xsl:call-template name="make-error">
               <xsl:with-param name="error-type">abstract type check</xsl:with-param>
               <xsl:with-param name="description">abstract requires an abstract-type attribute to distinguish it from the other abstracts in this article</xsl:with-param>
					<xsl:with-param name="tg-target" select="'tags.html#el-abs'"/>
            	</xsl:call-template>
         	</xsl:when>
      	</xsl:choose>
   	</xsl:template>


   <!-- *********************************************************** -->
   <!-- Template: check-for-xref
   
        Returns and error if the element has been referenced by an <xref>.
     -->
   <!-- *********************************************************** -->
	<xsl:template name="check-for-xref">
      <xsl:param name="context" select="."/>
      <xsl:param name="inbox"/>
		<xsl:variable name="ID" select="$context/@id"/>
		
		<xsl:if test="//xref[@rid = $ID] and $editstyle='word'">
			<xsl:call-template name="make-error">
				<xsl:with-param name="error-type">object reference check</xsl:with-param>
				<xsl:with-param name="description">
					<xsl:text>&lt;</xsl:text>
					<xsl:value-of select="name()"/>
					<xsl:text>&gt; may not be referenced directly</xsl:text>
					<xsl:if test="$inbox='yes'">
						<xsl:text> when it is in &lt;boxed-text&gt;</xsl:text>
						</xsl:if>
					<xsl:text>. Reference should be made to the ancestor </xsl:text>
					<xsl:choose>
						<xsl:when test="$inbox='yes'">
							<xsl:text>&lt;boxed-text&gt;.</xsl:text>
							</xsl:when>
						<xsl:otherwise>
							<xsl:text>&lt;sec&gt;.</xsl:text>
							</xsl:otherwise>
						</xsl:choose> 
				</xsl:with-param>
            </xsl:call-template>
			</xsl:if>
	</xsl:template>
  
  <!-- *********************************************************** -->
  <!-- Template: float-obj-check
       Checks to see if there is a reference to a floating object.
  -->
  <!-- *********************************************************** -->
   <xsl:template name="float-obj-check">
      <xsl:param name="context" select="."/>
      <xsl:variable name="ID" select="$context/@id"/>
      <xsl:variable name="ref-rid">
        <xsl:choose>
          <xsl:when test="//xref/@rid=$ID">
            <xsl:value-of select="//xref/@rid"/>
          </xsl:when>
          <xsl:when test="//related-object/@object-id=$ID">
            <xsl:value-of select="//related-object/@object-id"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="'missing'"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <xsl:if test="$ref-rid='missing'">
        <xsl:call-template name="make-error">
          <xsl:with-param name="error-type">No cross-reference to floating object </xsl:with-param>
          <xsl:with-param name="description">
            <xsl:value-of select="local-name($context)"/>
            <xsl:text> with id value </xsl:text>
            <xsl:value-of select="$ID"/>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:if>
   </xsl:template>

   <!-- *********************************************************** -->
   <!-- Template: child-present
   
      tests whether a specific child is present
	 -->
   <!-- *********************************************************** -->
   <xsl:template name="child-present">
      <xsl:param name="context" select="."/> 
      <xsl:param name="child"/> 
      
      <xsl:choose>
         <xsl:when test="child::node()[name()=$child]">
            <!-- This is correct -->
         </xsl:when>
         
         <!-- Have none -->
         <xsl:otherwise>
            <xsl:call-template name="make-error">
               <xsl:with-param name="error-type">required child</xsl:with-param>
               <xsl:with-param name="description">
						<xsl:text>&lt;</xsl:text>
						<xsl:value-of select="name($context)"/>
						<xsl:text>&gt; must have a child &lt;</xsl:text>
						<xsl:value-of select="$child"/>
						<xsl:text>&gt;.</xsl:text>
						</xsl:with-param>
            </xsl:call-template>
         </xsl:otherwise>
      </xsl:choose>                  
   </xsl:template> 


	<!-- *********************************************************** -->
	<!-- Template: citation-alternatives-content-check
		1) Must have more than 1 child
		For each unique child element:
		2) If >1 of me, we must have @xml:lang or @specific-use to differentiate 
		3) If >1 of me, and any specify @xml:lang, exactly 1 must be the same as /article 
			and all the values should be unique
		4) If >1 of me, and any specify @specific-use, all must
			and all the values should be unique
		-->
	<!-- *********************************************************** -->
	<xsl:template name="citation-alternatives-content-check">
		<xsl:param name="context" select="."/>
		
		<!-- 1 -->
		<xsl:call-template name="alternatives-child-count">
			<xsl:with-param name="context" select="."/>
		</xsl:call-template>	
		
		<xsl:if test="count($context/element-citation) > 1">
			<!-- element-citation: 2 -->
			<xsl:if test="not($context/element-citation[@xml:lang]) and not($context/element-citation[@specific-use])">
				<xsl:call-template name="make-error">
					<xsl:with-param name="error-type">
						<xsl:text>citation-alternatives check</xsl:text>
					</xsl:with-param>
					<xsl:with-param name="description">
						<xsl:text>Multiple element-citations in citation-alternatives must be distinguised by either @xml:lang or @specific-use.</xsl:text>
					</xsl:with-param>
					<xsl:with-param name="tg-target" select="'tags.html#el-citation-alternatives'"/>
				</xsl:call-template>
			</xsl:if>			
			<!-- element-citation: 3 -->
			<xsl:if test="$context/element-citation/@xml:lang">
				<xsl:call-template name="alternatives-xml-lang-check">
					<xsl:with-param name="context" select="'citation-alternatives'"/>
					<xsl:with-param name="nodes" select="$context/element-citation"/>
				</xsl:call-template>
			</xsl:if>
			<!-- element-citation: 4 -->
			<xsl:if test="$context/element-citation/@specific-use">
				<xsl:call-template name="alternatives-specific-use-check">
					<xsl:with-param name="context" select="'citation-alternatives'"/>
					<xsl:with-param name="nodes" select="$context/element-citation"/>
				</xsl:call-template>
			</xsl:if>			
		</xsl:if>
		
		<xsl:if test="count($context/mixed-citation) > 1">
			<!-- mixed-citation: 2 -->
			<xsl:if test="not($context/mixed-citation[@xml:lang]) and not($context/mixed-citation[@specific-use])">
				<xsl:call-template name="make-error">
					<xsl:with-param name="error-type">
						<xsl:text>citation-alternatives check</xsl:text>
					</xsl:with-param>
					<xsl:with-param name="description">
						<xsl:text>Multiple mixed-citations in citation-alternatives must be distinguised by either @xml:lang or @specific-use.</xsl:text>
					</xsl:with-param>
					<xsl:with-param name="tg-target" select="'tags.html#el-citation-alternatives'"/>
				</xsl:call-template>
			</xsl:if>			
			<!-- mixed-citation: 3 -->
			<xsl:if test="$context/mixed-citation/@xml:lang">
				<xsl:call-template name="alternatives-xml-lang-check">
					<xsl:with-param name="context" select="'citation-alternatives'"/>
					<xsl:with-param name="nodes" select="$context/mixed-citation"/>
				</xsl:call-template>
			</xsl:if>
			<!-- mixed-citation: 4 -->
			<xsl:if test="$context/mixed-citation/@specific-use">
				<xsl:call-template name="alternatives-specific-use-check">
					<xsl:with-param name="context" select="'citation-alternatives'"/>
					<xsl:with-param name="nodes" select="$context/mixed-citation"/>
				</xsl:call-template>
			</xsl:if>
		</xsl:if>	
	</xsl:template>
	

   <!-- *********************************************************** -->
   <!-- Template: citation-type-check
   
        Checks that citation-type is present and has a value
     -->
   <!-- *********************************************************** -->
   <xsl:template name="citation-type-value">
      <xsl:param name="context" select="."/>
      
      <xsl:call-template name="attribute-present-not-empty">
         <xsl:with-param name="context" select="$context/@citation-type"/>
         <xsl:with-param name="attribute-name" select="'citation-type'"/>
         <xsl:with-param name="test-name" select="'citation type checking'"/>
			<xsl:with-param name="tg-target" select="'tags.html#el-cit'"/>
      </xsl:call-template>      
   </xsl:template>
	
	
	<!-- *********************************************************** -->
	<!-- Template: collab-alternatives-content-check 
		1) Must have more than 1 child
		2) Children must carry either @xml:lang or @specific-use
		3) If children specify @xml:lang, exactly 1 must be the same as /article 
			and all the values should be unique
		4) If any child specifies @specific-use, all must
			and all the values should be different
		-->
	<!-- *********************************************************** -->
	<xsl:template name="collab-alternatives-content-check">
		<xsl:param name="context" select="."/>
		<!-- 1 -->
		<xsl:call-template name="alternatives-child-count">
			<xsl:with-param name="context" select="."/>
		</xsl:call-template>
		
		<!-- 2 -->
		<xsl:if test="not($context/collab[@xml:lang]) and not($context/collab[@specific-use])">
			<xsl:call-template name="make-error">
				<xsl:with-param name="error-type">
					<xsl:text>collab-alternatives check</xsl:text>
				</xsl:with-param>
				<xsl:with-param name="description">
					<xsl:text>Elements in collab-alternatives must be distinguised by either @xml:lang or @specific-use.</xsl:text>
				</xsl:with-param>				
				<xsl:with-param name="tg-target" select="'tags.html#el-collab-alternatives'"/>
			</xsl:call-template>
		</xsl:if>
		
		<!-- 3 -->
		<xsl:if test="$context/collab[@xml:lang]">			
			<xsl:call-template name="alternatives-xml-lang-check">
				<xsl:with-param name="context" select="'collab-alternatives'"/>
				<xsl:with-param name="nodes" select="$context/collab"/>				
			</xsl:call-template>
		</xsl:if>
		
		<!-- 4 -->
		<xsl:if test="$context/collab[@specific-use]">
			<xsl:call-template name="alternatives-specific-use-check">
				<xsl:with-param name="context" select="'collab-alternatives'"/>
				<xsl:with-param name="nodes" select="$context/collab"/>
			</xsl:call-template>			
		</xsl:if>
	</xsl:template>

	
	
	<!-- *********************************************************** -->
	<!-- Template: collab-content-check
		Must contain something other than contrib-group -->
	<!-- *********************************************************** -->
	<xsl:template name="collab-content-check">
		<xsl:param name="context" select="."/>
		<xsl:if test="normalize-space($context/text())=''  and not($context/*[not(self::contrib-group)])">
			<xsl:call-template name="make-error">
				<xsl:with-param name="error-type">collab error</xsl:with-param>
				<xsl:with-param name="description">
					<xsl:text>&lt;</xsl:text>
					<xsl:value-of select="name($context)"/>
					<xsl:text>&gt; must contain the collaboration name, not just a &lt;contrib-group&gt;.</xsl:text>
				</xsl:with-param>
			</xsl:call-template>
		</xsl:if>		
	</xsl:template>
	
	<!-- *********************************************************** -->
	<!-- Template:  collab-contribgrp-check
		1) collab/contrib-group/contrib/collab must not exist
		-->
	<!-- *********************************************************** -->
	<xsl:template name="collab-contribgrp-check">
		<xsl:param name="context" select="."/>
		<xsl:if test="$context/contrib/collab">
			<xsl:call-template name="make-error">
				<xsl:with-param name="error-type">contributor error</xsl:with-param>
				<xsl:with-param name="description">
					<xsl:text>&lt;</xsl:text>
					<xsl:value-of select="name($context)"/>
					<xsl:text>&gt; as child of &lt;collab&gt; must not contain &lt;collab&gt;.</xsl:text>
				</xsl:with-param>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
	

   <!-- *********************************************************** -->
   <!-- Template:  contract-num-linking 
   
        1) must have rid attribute
        2) contract-num must link to contract-sponsor
        
        2/24/06 lk removed this rule following discussion with jb
        3) contract-sponsor must link back to this contract-num
     -->
   <!-- *********************************************************** -->
   <xsl:template name="contract-num-linking">
      <xsl:param name="context" select="."/>
      
      <xsl:variable name="good-targets"
	     select="id($context/@rid)[self::contract-sponsor]"/>
      <xsl:variable name="bad-targets"
	     select="id($context/@rid)[not(self::contract-sponsor)]"/>
            
      <xsl:choose>
         <!-- No id attribute 
         <xsl:when test="not(@id[normalize-space()])">
            <xsl:call-template name="make-error">
               <xsl:with-param name="error-type">contract-element checking</xsl:with-param>
               <xsl:with-param name="description">
                  <xsl:text>contract-num must have an id attribute</xsl:text>
               </xsl:with-param>
            </xsl:call-template>
         </xsl:when> -->
         
         <!-- No rid attribute -->
         <xsl:when test="not(@rid[normalize-space()])">
            <xsl:call-template name="make-error">
               <xsl:with-param name="error-type">contract-element checking</xsl:with-param>
               <xsl:with-param name="description">
                  <xsl:text>contract-num must have an rid attribute</xsl:text>
               </xsl:with-param>
				<xsl:with-param name="tg-target" select="'tags.html#el-cnum'"/>
            </xsl:call-template>
         </xsl:when>
         
         <!-- Links to things that are not contract-sponsors -->
         <xsl:when test="$bad-targets">
            <xsl:call-template name="make-error">
               <xsl:with-param name="error-type">contract-element checking</xsl:with-param>
               <xsl:with-param name="description">
                  <xsl:text>contract-num should only link to contract-sponsor elements</xsl:text>
               </xsl:with-param>
				<xsl:with-param name="tg-target" select="'tags.html#el-cnum'"/>
            </xsl:call-template>
         </xsl:when>
         
      </xsl:choose>
      
   </xsl:template>

	<!-- *********************************************************** -->
	<!-- Template:  contract-sponsor-linking 
		See:    (http://jira/browse/PMC-5484)
		1) contract-sponsor must have:
		        an rid attribute that points to contract-num
		        or rid attribute that points to another contract-sponsor's @id
		        or an id attribute
		2) contract-num must link to contract-sponsor
		
     -->
   <!-- *********************************************************** -->
	<xsl:template name="contract-sponsor-linking">
		<xsl:param name="context" select="."/>
		
		<xsl:variable name="good-targets"
			select="id($context/@rid)[self::contract-num]"/>
		
		<xsl:variable name="contract-sponsor-ref-check">
			<xsl:for-each select="id(@rid)">
				<xsl:choose>
					<xsl:when test="self::contract-sponsor and contains($context/@rid, @id)"/>
					<xsl:otherwise>
						<xsl:text>badstyle</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:for-each>
		</xsl:variable>
		
		<xsl:variable name="bad-targets"
			select="id($context/@rid)[not(self::contract-num) and not(self::contract-sponsor)]"/>
		
		<xsl:choose>
			<!-- No id attribute -->
			<xsl:when test="(not(@id[normalize-space()]) and //contract-num)
				and not(@rid[normalize-space()])">
				<xsl:call-template name="make-error">
					<xsl:with-param name="error-type">contract-element checking</xsl:with-param>
					<xsl:with-param name="description">
						<xsl:text>contract-sponsor must have an id attribute or an rid attribute</xsl:text>
					</xsl:with-param>
					<xsl:with-param name="tg-target" select="'tags.html#cspons'"/>
				</xsl:call-template>
			</xsl:when>
			
			
			<!-- Links to things that are not contract-nums and not contract-sponsor -->
			<xsl:when test="$bad-targets or contains($contract-sponsor-ref-check, 'badstyle')">
				<xsl:call-template name="make-error">
					<xsl:with-param name="error-type">contract-element checking</xsl:with-param>
					<xsl:with-param name="description">
						<xsl:text>contract-sponsor should only link to contract-num or contract-sponsor elements</xsl:text>
					</xsl:with-param>
					<xsl:with-param name="tg-target" select="'tags.html#cspons'"/>
				</xsl:call-template>
			</xsl:when>
			
		</xsl:choose>
      
   </xsl:template>


   <!-- *********************************************************** -->
   <!-- Template: contrib-attribute-checking 

        If @corresp='yes' should not have an xref
        of type corresp; xref should also not point to 
        a corresp element. 
        
        If @deceased='yes' should not have an xref pointing
        to fn with fn-type='deceased'
        
        If @equal-contrib='yes' should not have xref
        pointing to fn with fn-type='equal'
                        
        @contrib-type must be set to either author or
        editor
                
        @rid cannot be set
        
        NB: must allow id attribute because this is
        provived in some source files and we do not
        wish to throw the information away.
   -->
   <!-- *********************************************************** -->
   <xsl:template name="contrib-attribute-checking">
      <xsl:param name="context" select="."/>
      
      <!-- corresp tests removed -->
      
      <!-- Check equal-contrib attribute -->
      <xsl:if test="$context/@equal-contrib='yes' and id($context/xref/@rid)/@fn-type[. = 'equal']">
         <xsl:call-template name="make-error">
            <xsl:with-param name="error-type"
			   select="'contrib attributes check'"/>
            <xsl:with-param name="description">
               <xsl:text>&lt;contrib&gt; should not have an equal-contrib attribute set to 'yes' and a fn where the fn-type is 'equal'</xsl:text>
            </xsl:with-param>
				<xsl:with-param name="tg-target" select="'tags.html#el-contrib'"/>
         </xsl:call-template>
      </xsl:if>      
      
      <!-- Check that the contrib-type is set to either author or editor -->
      <xsl:if test="$context[not(@contrib-type) 
	       or (@contrib-type != 'author'
		       and @contrib-type != 'editor'
			   and @contrib-type != 'reviewer') ]">
      		<xsl:choose>
      			<xsl:when test="$context/ancestor::collab">
      				<!-- Don't require @contrib-type on contrib as descendant of collab -->
      			</xsl:when>
      			<xsl:otherwise>
         <xsl:call-template name="make-error">
            <xsl:with-param name="error-type"
			   select="'contrib attributes check'"/>
				<xsl:with-param name="class" select="'warning'"/>
            <xsl:with-param name="description">
               <xsl:text>&lt;contrib&gt; must have a contrib-type attribute set to 'author' or 'editor'</xsl:text>
            </xsl:with-param>
				<xsl:with-param name="tg-target" select="'tags.html#el-contrib'"/>
         </xsl:call-template>
      			</xsl:otherwise>
      		</xsl:choose>
      </xsl:if>
      
   </xsl:template>

   <!-- ********************************************* -->
   <!-- Template: contrib-author-notes-test
   
        If @corresp='yes' should not have an xref
        of type corresp; xref should also not point to 
        a corresp element. 
        
        If @deceased='yes' should not have an xref pointing
        to fn with fn-type='deceased'
        
        If @equal-contrib='yes' should not have xref
        pointing to fn with fn-type='equal'
                        
        Context: contrib -->
   <!-- ********************************************* -->   
   <xsl:template name="contrib-author-notes-test">
		<!-- corresp test removed -->
      <xsl:if test="@deceased='yes' and id(xref/@rid)/@fn-type[. = 'deceased']">
         <xsl:call-template name="make-error">
					<xsl:with-param name="error-type" select="'author notes check'"/>
             <xsl:with-param name="description">
               <xsl:text>&lt;contrib&gt; should not have a deceased attribute set to 'yes' and a fn where the fn-type is 'deceased'</xsl:text>
            </xsl:with-param>
				<xsl:with-param name="tg-target" select="'tags.html#el-contrib'"/>
         </xsl:call-template>
      </xsl:if>

      <xsl:if test="@equal-contrib='yes' and id(xref/@rid)/@fn-type[. = 'equal']">
         <xsl:call-template name="make-error">
					<xsl:with-param name="error-type" select="'author notes check'"/>
             <xsl:with-param name="description">
               <xsl:text>&lt;contrib&gt; should not have an equal-contrib attribute set to 'yes' and a fn where the fn-type is 'equal'</xsl:text>
            </xsl:with-param>
				<xsl:with-param name="tg-target" select="'tags.html#el-contrib'"/>
         </xsl:call-template>
      </xsl:if>
   </xsl:template>
      

	<!-- *********************************************************** -->
	<!-- Template: contrib-content-test 
		1a) must contain either name or collab
		1b) must not contain collab and name
		1c) must contain only 1 name unless the others are index or different langs


		2) If collab, must not contain contrib-id
		
		-->
	<!-- *********************************************************** -->
   <xsl:template name="contrib-content-test">
      <xsl:choose>
      	<xsl:when test="not(collab)  
      				and not(collab-alternatives)
         				and not(name)
         				and not(name-alternatives)
         				and not(anonymous)">
            <xsl:call-template name="make-error">
					<xsl:with-param name="error-type" select="'contrib content check'"/>
               <xsl:with-param name="description">
                  <xsl:text>&lt;contrib&gt; must have one of the following: [collab, collab-alternatives, name, name-alternatives, anonymous].</xsl:text>
               </xsl:with-param>
				<xsl:with-param name="tg-target" select="'tags.html#el-contrib'"/>
            </xsl:call-template>
         </xsl:when>
         
         <xsl:when test="name and collab">
            <xsl:call-template name="make-error">
					<xsl:with-param name="error-type" select="'contrib content check'"/>
               <xsl:with-param name="description">
                  <xsl:text>&lt;contrib&gt; cannot contain a &lt;collab&gt; and a &lt;name&gt;</xsl:text>
               </xsl:with-param>
				<xsl:with-param name="tg-target" select="'tags.html#el-contrib'"/>
            </xsl:call-template>
         </xsl:when>

         <xsl:when test="$dtd-version!='j1' and count(name[not(@content-type='index') and not(contains(@content-type,'xml:lang'))]) &gt; 1">         	
         		<!-- Do not count name with either @content-type='index' or @content-type with xml:lang -->
            <xsl:call-template name="make-error">
					<xsl:with-param name="error-type" select="'contrib content check'"/>
               <xsl:with-param name="description">
                  <xsl:text>&lt;contrib&gt; should only contain a single &lt;name&gt; or a single &lt;collab&gt;</xsl:text>
               </xsl:with-param>
					<xsl:with-param name="tg-target" select="'tags.html#el-contrib'"/>
            </xsl:call-template>
         </xsl:when>
      	
      	<xsl:when test="$dtd-version='j1' and (count(name) > 1 or count(collab) > 1)">
      		<xsl:call-template name="make-error">
      			<xsl:with-param name="error-type" select="'contrib content check'"/>
      			<xsl:with-param name="description">
      				<xsl:choose>
      					<xsl:when test="count(collab) > 1">      						
      						<xsl:text>Alternate versions of [collab] must be tagged within [collab-alternatives].</xsl:text>
      					</xsl:when>
      					<xsl:otherwise>
      						<xsl:text>Alternate versions of [name] must be tagged within [name-alternatives].</xsl:text>
      					</xsl:otherwise>
      				</xsl:choose>
      			</xsl:with-param>
      			<xsl:with-param name="tg-target" select="'tags.html#el-contrib'"/>
      		</xsl:call-template>
      	</xsl:when>
      	
      </xsl:choose>
   	
   	<xsl:if test="collab and contrib-id">
   		<xsl:call-template name="make-error">
   			<xsl:with-param name="error-type" select="'contrib content check'"/>
   			<xsl:with-param name="description">
   				<xsl:text>contrib with collab must not include contrib-id.</xsl:text>
   			</xsl:with-param>
   			<xsl:with-param name="tg-target" select="'tags.html#el-contrib'"/>
   		</xsl:call-template>
   	</xsl:if>
      
   </xsl:template>
	
	
	<!-- *********************************************************** -->
	<!-- Template: contrib-id-check
		 1) must have @contrib-id-type
		 2) if @contrib-id-type='orcid', must conform to ORCID format
		-->
	<!-- *********************************************************** -->
	<xsl:template name="contrib-id-check"> 
		<xsl:param name="context" select="."/>
		<xsl:if test="not($context/@contrib-id-type)">
			<xsl:call-template name="make-error">
				<xsl:with-param name="error-type" select="'contrib-id check'"/>
				<xsl:with-param name="description">
					<xsl:text>contrib-id must include contrib-id-type attribute. </xsl:text>
				</xsl:with-param>
				<xsl:with-param name="tg-target" select="'tags.html#el-contribid'"/>
			</xsl:call-template>
		</xsl:if>
		<xsl:if test="$context/@contrib-id-type='orcid'">
			<xsl:choose>
				<xsl:when test="starts-with(.,'orcid.org') or
								starts-with(.,'http://orcid.org') or
								starts-with(.,'ORCID.org') or
								starts-with(.,'http://ORCID.org')">
					<!-- this is okay, output context -->
				</xsl:when>
				<xsl:otherwise>
					<xsl:call-template name="make-error">
						<xsl:with-param name="error-type" select="'ORCID contrib-id check'"/>
						<xsl:with-param name="description">
							<xsl:text>ORCID values must start with 'http://orcid.org/'</xsl:text>
						</xsl:with-param>
						<xsl:with-param name="tg-target" select="'tags.html#el-contribid'"/>
					</xsl:call-template>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:if>
	</xsl:template>


   <!-- *********************************************************** -->
   <!-- Template: copyright-year-check
   
        Make sure the year is valid
     -->
   <!-- *********************************************************** -->
   <xsl:template name="copyright-year-check">
      <xsl:param name="context" select="."/>
      
      <xsl:variable name="is-valid-year">
         <xsl:call-template name="is-year">
            <xsl:with-param name="input" select="normalize-space($context)"/>
         </xsl:call-template>
      </xsl:variable>
      
      <xsl:if test="$is-valid-year = 'false'">
         <xsl:call-template name="make-error">
            <xsl:with-param name="error-type" select="'copyright-year check'"/>
            <xsl:with-param name="description">
               <xsl:text>copyright-year does not contain a valid year</xsl:text>
            </xsl:with-param>
				<xsl:with-param name="tg-target" select="'tags.html#el-cyear'"/>
         </xsl:call-template>
      </xsl:if>
   </xsl:template>
	
	
	<!-- *********************************************************** -->
	<!-- Template: collection-content-check
   
        Content of correction notices must be in body, not abstract.     -->
	<!-- *********************************************************** -->
	<xsl:template name="collection-content-check">
		<xsl:param name="context" select="."/>
		<xsl:if test="$context/@article-type='collection'">
			<xsl:if test="not(count($context/sub-article) + count($context/response) > 1)">
				<xsl:call-template name="make-error">
					<xsl:with-param name="error-type">collection content check</xsl:with-param>
					<xsl:with-param name="description">
						<xsl:text>Articles with @article-type="collection" must have more than 1 sub-article or response.</xsl:text>
					</xsl:with-param>
				</xsl:call-template>
			</xsl:if>
		</xsl:if>
	</xsl:template>
	
	
	<!-- *********************************************************** -->
	<!-- Template: correction-content-check
   
        Content of correction notices must be in body, not abstract.     -->
	<!-- *********************************************************** -->
	<xsl:template name="correction-content-check">
		<xsl:param name="context" select="."/>
		<xsl:if test="$context/@article-type='correction'">
			<xsl:if test="not($context/body) and ($context/front//abstract)">
				<xsl:call-template name="make-error">
					<xsl:with-param name="error-type">correction content check</xsl:with-param>
					<xsl:with-param name="description">
						<xsl:text>Correction content must be in article body, not abstract.</xsl:text>
					</xsl:with-param>
				</xsl:call-template>
			</xsl:if>
			</xsl:if>
	</xsl:template>



   <!-- *********************************************************** -->
   <!-- Template: count-spaces
        
        Returns the number of spaces inside a submitted
        string. This can be used to determine the number
        of token present in a string. Input string should
        have normalize-space() called on it.
     -->
   <!-- *********************************************************** -->
   <xsl:template name="count-spaces">
      <xsl:param name="input"/>
      <xsl:param name="count" select="0"/>
      
      <xsl:choose>
         <!-- No more input, so return the count -->
         <xsl:when test="not($input)">
            <xsl:value-of select="$count"/>
         </xsl:when>
         
         <!-- No more spaces, so return the count-->
         <xsl:when test="not(contains($input, ' '))">
            <xsl:value-of select="$count"/>
         </xsl:when>
         
         <!-- Still have spaces to count, so increment and recurse -->
         <xsl:otherwise>
            <xsl:call-template name="count-spaces">
               <xsl:with-param name="input" select="substring-after($input, ' ')"/>
               <xsl:with-param name="count" select="$count + 1"/>
            </xsl:call-template>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>


   <!-- *********************************************************** -->
   <!-- Template: day-check 
   
        day elements should have a valid value
     -->
   <!-- *********************************************************** -->
   <xsl:template name="day-check">
      <xsl:param name="context" select="."/>
      <xsl:choose>
      	<xsl:when test="$context/ancestor::citation
      		or $context/ancestor::nlm-citation
      		or $context/ancestor::mixed-citation
      		or $context/ancestor::element-citation
      		or $context/ancestor::product">
      		<!-- Don't test these -->
      	</xsl:when>
      	<xsl:otherwise>
      		<xsl:variable name="is-valid-day">
      			<xsl:call-template name="is-day">
      				<xsl:with-param name="input" select="string($context)"/>
      			</xsl:call-template>
      		</xsl:variable>
      		
      		<xsl:if test="$is-valid-day = 'false'">
      			<xsl:call-template name="make-error">
      				<xsl:with-param name="error-type" select="'day check'"/>
      				<xsl:with-param name="description">
      					<xsl:text>day element should contain a numeric value between 1 and 31, inclusive</xsl:text>
      				</xsl:with-param>
      				<xsl:with-param name="tg-target" select="'tags.html#el-day'"/>
      			</xsl:call-template>
      		</xsl:if>
      	</xsl:otherwise>
      </xsl:choose>
   </xsl:template>


   <!-- *********************************************************** -->
   <!-- Template: disclaimer-notes-check 
   
        Any notes element with notes-type set to
        'disclaimer' must be located in front element.
     -->
   <!-- *********************************************************** -->
   <xsl:template name="disclaimer-notes-check">
      <xsl:param name="context" select="."/>
      
      <xsl:if test="$context/@notes-type = 'disclaimer' and $stream != 'book'">
         <xsl:choose>
            <xsl:when test="$context/parent::front">
               <!-- This is ok -->
            </xsl:when>
            
            <xsl:otherwise>
               <xsl:call-template name="make-error">
                  <xsl:with-param name="error-type" select="'disclaimer notes checking'"/>
                  <xsl:with-param name="description">
							<xsl:choose>
								<xsl:when test="$stream='manuscript'">
									<xsl:text>disclaimers should be set in an article-level footnote.</xsl:text>
									</xsl:when>
								<xsl:when test="$document-type!='book' and $document-type!='book-part'">
									<xsl:text>notes with notes-type attribute set to 'disclaimer' must be children of front element</xsl:text>
									</xsl:when>
								</xsl:choose>
                     
                  </xsl:with-param>
			<xsl:with-param name="tg-target">
				<xsl:choose>
					<xsl:when test="$stream='manuscript'">
						<xsl:text>dobs.html#dob-msdisc</xsl:text>
					</xsl:when>
					<xsl:when test="$document-type!='book' and $document-type!='book-part'">
						<xsl:text>dobs.html#dob-pmcdisc</xsl:text>
					</xsl:when>
				</xsl:choose>
			</xsl:with-param>
               </xsl:call-template>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:if>      
   </xsl:template>


   <!-- *********************************************************** -->
   <!-- Template: display-object-sec-check 
   
        When is a display objects sec, must:
        1) be located in back
        2) have correct title
        3) only contain the right content with correct position attributes
    -->
   <!-- *********************************************************** -->
   <xsl:template name="display-object-sec-check">
      <xsl:param name="context" select="."/>
      
      <xsl:if test="$context/@sec-type = 'display-objects'">
         <!-- Test 1: make sure this is located in back 
            LK 6/7/07: Added allowance for parent::sec to accomodate
			translating response/sub-article to section -->
         <xsl:if test="not($context/parent::back) and not($context/parent::sec)">
            <xsl:call-template name="make-error">
               <xsl:with-param name="error-type">display-objects sec check</xsl:with-param>
               <xsl:with-param name="description">
                  <xsl:text>display-objects sec should be located in back matter</xsl:text>
               </xsl:with-param>
            </xsl:call-template>      
         </xsl:if>

         <!-- Test 2: Check the title -->
         <!-- Determine what the title should be
         <xsl:variable name="correct-title">
            <xsl:call-template name="make-correct-title">
               <xsl:with-param name="figures" select="count($context//fig)"/>
               <xsl:with-param name="tables" select="count($context//table-wrap)"/>
            </xsl:call-template>
         </xsl:variable>
         
         <xsl:choose>
            <xsl:when test="$correct-title='INVALID CONTENT'"/>
            
             <xsl:when test="normalize-space($context/title) = 'Figures and Tables'"/>
            
             <xsl:when test="not($correct-title = normalize-space($context/title))">
               <xsl:call-template name="make-error">
                  <xsl:with-param name="error-type">display-objects sec check</xsl:with-param>
                  <xsl:with-param name="description">
                     <xsl:text>Incorrect title. Title should be '</xsl:text>
                     <xsl:value-of select="$correct-title"/>
                     <xsl:text>' and not '</xsl:text>
                     <xsl:value-of select="normalize-space($context/title)"/>
                     <xsl:text>'</xsl:text>
                  </xsl:with-param>
               </xsl:call-template>                                       
            </xsl:when>
         </xsl:choose>  -->

         <!-- Test 3: Make sure has only floating figs and tables (and isn't empty) -->
         <xsl:choose>
              <!-- Contains objects other than tables and figs objects -->
             <xsl:when test="$context/*[not(self::title)][not(self::fig)                                 
               and not(self::fig-group)                                 
               and not(self::table-wrap)                                 
               and not(self::table-wrap-group)]">
                <xsl:call-template name="make-error">
    
                   <xsl:with-param name="error-type">display-objects sec check</xsl:with-param>
                   <xsl:with-param name="description">
                      <xsl:text>Display objects section can only contain fig, table-wrap, fig-group and table-wrap-group</xsl:text>
                   </xsl:with-param>
                </xsl:call-template>                                       
             </xsl:when>
                          
             <!-- Non floating elements -->
             <xsl:when test="$context/*[not(self::title)][not(@position = 'float')]">
               <xsl:call-template name="make-error">
   
                  <xsl:with-param name="error-type">display-objects sec check</xsl:with-param>
                  <xsl:with-param name="description">
                     <xsl:text>Display objects section can only contain elements that have position attributes set to "float"</xsl:text>
                  </xsl:with-param>
               </xsl:call-template>                                       
            </xsl:when>
            
            <!-- No children -->
            <xsl:when test="not($context/*[not(self::title)])">
               <xsl:call-template name="make-error">
   
                  <xsl:with-param name="error-type">display-objects sec check</xsl:with-param>
                  <xsl:with-param name="description">
                     <xsl:text>Display objects section cannot be empty</xsl:text>
                  </xsl:with-param>
               </xsl:call-template>                                       
            </xsl:when>
         </xsl:choose>
      </xsl:if>
   </xsl:template>


   <!-- *********************************************************** -->
   <!-- Template: disp-quote-content-check
		Checks for the presence of <preformat> in <disp-quote>
		 in book content 
     -->
   <!-- *********************************************************** -->
   <xsl:template name="disp-quote-content-check">
      <xsl:if test="descendant::preformat">
			<xsl:call-template name="make-error">
				<xsl:with-param name="error-type">disp-quote content check</xsl:with-param>
				<xsl:with-param name="description">
					<xsl:text>&lt;disp-quote&gt; may not contain &lt;preformat&gt;. &lt;disp-quote&gt; wrapper is superfluous.</xsl:text>
					</xsl:with-param>
				</xsl:call-template>
			</xsl:if>
		</xsl:template>


   <!-- *********************************************************** -->
   <!-- Template: doi-check 
   
        Test takes in the value of the doi and tests it by
        calling another template. This test will probably only be 
        applied to the following:
           pub-id/@pub-id-type[.='doi'] 
           journal-id/@journal-id-type[.='doi']
           article-id/@pub-id-type[.='doi']
           related-article[@ext-link-type='doi']/@xlink:href
           issue-id[@pub-id-type = 'doi']
           ext-link[@ext-link-type = 'doi']/@xlink:href
           object-id[@pub-id-type = 'doi']
     -->
   <!-- *********************************************************** -->
   <xsl:template name="doi-check">
   	<xsl:param name="value"/>
      
      <xsl:variable name="good-doi">
         <xsl:call-template name="doi-format-test">
            <xsl:with-param name="doi" select="$value"/>
         </xsl:call-template>
      </xsl:variable>
      
      <xsl:if test="$good-doi = 'false'">
         <xsl:call-template name="make-error">
            <xsl:with-param name="error-type">doi format check</xsl:with-param>
            <xsl:with-param name="description">
               <xsl:text>Malformed doi value: '</xsl:text>
               <xsl:value-of select="$value"/>
               <xsl:text>'</xsl:text>
            </xsl:with-param>
         </xsl:call-template>                                       
      </xsl:if>
   </xsl:template>


   <!-- *********************************************************** -->
   <!-- Template: doi-format-test 

        Check the format of a doi and return true
        if well formed, false otherwise.
        
        Format is specified here:
        http://www.doi.org/handbook_2000/enumeration.html#2.2
     -->
   <!-- *********************************************************** -->
   <xsl:template name="doi-format-test">
      <xsl:param name="doi"/>
      
      <xsl:variable name="normalized-doi">
	     <xsl:call-template name="replace-substring">
	        <xsl:with-param name="main-string" select="normalize-space($doi)"/>
	        <xsl:with-param name="substring"   
			   select="'&#x0002f;'"/>
	        <xsl:with-param name="replacement" select="'/'"/>
	     </xsl:call-template>
      </xsl:variable>

      <!-- Format tests -->
      <xsl:choose>
         <!-- Cannot be empty -->
         <xsl:when test="not($normalized-doi)">
            <xsl:text>false</xsl:text>
         </xsl:when>
         
         <!-- No spaces allowed -->
         <xsl:when test="contains($normalized-doi, ' ')">
            <xsl:text>false</xsl:text>
         </xsl:when>
         
         <!-- Prefix must start with '10.' -->
         <xsl:when test="not(starts-with($normalized-doi, '10.'))">
            <xsl:text>false</xsl:text>
         </xsl:when>
         
         <!-- Must be something following the preamble in the prefix.
         In other words, cannot immediately follow the '10.' with a '/'-->
         <xsl:when test="substring($normalized-doi, 4,1) = '/'">
            <xsl:text>false</xsl:text>
         </xsl:when>
         
         <!-- '/' must separate prefix from the suffix -->
         <xsl:when test="not(contains(substring-after($normalized-doi, '10.'), '/'))">
            <xsl:text>false</xsl:text>
         </xsl:when>
         
         <!-- Must be content after the '/' to form the suffix -->
         <xsl:when test="not(substring-after($normalized-doi, '/'))">
            <xsl:text>false</xsl:text>
         </xsl:when>
         
         <!-- Must be OK!!-->
         <xsl:otherwise>
            <xsl:text>true</xsl:text>
         </xsl:otherwise>
      </xsl:choose>      
   </xsl:template>
	
	
	
	<!-- *********************************************************** -->
	<!-- Template: dup-pub-date-check 		
		1) Article cannot have more than 1 print pub-date;
		2) Article cannot have more than 1 electronic pub-date.		
		-->
	<!-- *********************************************************** -->
	<xsl:template name="dup-pub-date-check">
		<xsl:param name="context"/>
		<xsl:choose>
			<xsl:when test="$context/@pub-type='ppub'
							or $context/@publication-format='print' and $context/@date-type='pub'">
				<xsl:if test="$context/preceding-sibling::pub-date[@pub-type = 'ppub']
							or $context/preceding-sibling::pub-date[@date-type='pub'][@publication-format='print']">
					<xsl:call-template name="make-error">
						<xsl:with-param name="error-type" select="'pub-date checking'"/>
						<xsl:with-param name="description">
							<xsl:text>article-meta should only contain one print publication date</xsl:text>
						</xsl:with-param>
						<xsl:with-param name="tg-target" select="'tags.html#el-pubdate'"/>
					</xsl:call-template>
				</xsl:if>
			</xsl:when>
			<xsl:when test="$context/@pub-type='epub'
							or $context/@publication-format='electronic' and $context/@date-type='pub'">
				<xsl:if test="$context/preceding-sibling::pub-date[@pub-type = 'epub']
							or $context/preceding-sibling::pub-date[@date-type='pub'][@publication-format='electronic']">
					<xsl:call-template name="make-error">
						<xsl:with-param name="error-type" select="'pub-date checking'"/>
						<xsl:with-param name="description">
							<xsl:text>article-meta should only contain one electronic publication date</xsl:text>
						</xsl:with-param>
						<xsl:with-param name="tg-target" select="'tags.html#el-pubdate'"/>
					</xsl:call-template>
				</xsl:if>
			</xsl:when>
			<xsl:when test="$context/@pub-type='collection'
							or $context/@publication-format='electronic' and $context/@date-type='collection'">
				<xsl:if test="$context/preceding-sibling::pub-date[@pub-type = 'collection']
							or $context/preceding-sibling::pub-date[@date-type='collection'][@publication-format='electronic']">
					<xsl:call-template name="make-error">
						<xsl:with-param name="error-type" select="'pub-date checking'"/>
						<xsl:with-param name="description">
							<xsl:text>article-meta should only contain one collection date</xsl:text>
						</xsl:with-param>
						<xsl:with-param name="tg-target" select="'tags.html#el-pubdate'"/>
					</xsl:call-template>
				</xsl:if>
			</xsl:when>
		</xsl:choose>
	</xsl:template>


   <!-- *********************************************************** -->
   <!-- Template: empty-element-check

		Tests whether an element is empty. If it is, then the 
		template generates an error. Note caller can specify
		'strict' or 'loose'. The former reports an error if element
		is empty or it only contains whitespace. 'Loose' means that
		the element can't be empty, but that it's OK for it to have
		just whitespace. By default, the test is run under 'strict'
		mode unless 'loose' is specified.
     -->
   <!-- *********************************************************** -->
   <xsl:template name="empty-element-check">
      <xsl:param name="context" select="."/>
      <xsl:param name="mode" select="'strict'"/>
      
      <xsl:choose>
         <xsl:when test="$mode='strict'">
            <xsl:choose>
               <!-- Has elements or non-whitespace text: This is ok -->
               <xsl:when test="$context[* or text()[normalize-space()]]"/>
               <xsl:otherwise>
                  <xsl:call-template name="make-error">
                     <xsl:with-param name="error-type">empty element check</xsl:with-param>
                     <xsl:with-param name="description">
                        <xsl:value-of select="local-name($context)"/>
                        <xsl:text> should not be empty</xsl:text>
                     </xsl:with-param>
                  </xsl:call-template>
               </xsl:otherwise>            
            </xsl:choose>         
         </xsl:when>
         <xsl:when test="$mode = 'loose'">
            <xsl:choose>
               <!-- Has elements or any kind of text node: that's ok -->
               <xsl:when test="$context[* or text()]"/>
               <xsl:otherwise>
                  <xsl:call-template name="make-error">
                     <xsl:with-param name="error-type">empty element check</xsl:with-param>
                     <xsl:with-param name="description">
                        <xsl:value-of select="local-name($context)"/>
                        <xsl:text> should not be empty</xsl:text>
                     </xsl:with-param>
                  </xsl:call-template>
               </xsl:otherwise>            
            </xsl:choose>
         </xsl:when>
      </xsl:choose>      
  	 </xsl:template>


   <!-- *********************************************************** -->
   <!-- Template: epub-date-check
   
        there may only be one epub-date in the article
     -->
   <!-- *********************************************************** -->
	<xsl:template name="epub-date-check">
      <xsl:param name="context" select="."/>
       <xsl:if test="$context[@pub-type='epub']
	       and $context/following-sibling::pub-date[@pub-type='epub']">
            <xsl:call-template name="make-error">
               <xsl:with-param name="error-type"
			      select="'electronic pub-date check'"/>
               <xsl:with-param name="description">
                  <xsl:text> article may only have one 'epub' date.</xsl:text>
               </xsl:with-param>
				<xsl:with-param name="tg-target" select="'tags.html#el-pubdate'"/>
            </xsl:call-template>
			</xsl:if>
		<xsl:if test="$context/day and not($context/month)">
           <xsl:call-template name="make-error">
               <xsl:with-param name="error-type"
			      select="'date check'"/>
               <xsl:with-param name="description">
                  <xsl:text> date with a day must have a month.</xsl:text>
               </xsl:with-param>
            </xsl:call-template>
			</xsl:if>	
		<xsl:call-template name="is-valid-date"/>
		</xsl:template>
 
  <!-- *********************************************************** -->
   <!-- Template: date-check   
        1) cannot have month without day
        2) must be a valid date
     -->
   <!-- *********************************************************** -->
	<xsl:template name="date-check">
		<xsl:param name="context" select="."/>
		<xsl:if test="$context/day and not($context/month)">
			<xsl:call-template name="make-error">
				<xsl:with-param name="error-type"
					select="concat(local-name($context),' check')"/>
				<xsl:with-param name="description">
					<xsl:text> date with a day must have a month.</xsl:text>
				</xsl:with-param>
			</xsl:call-template>
		</xsl:if>
	   <xsl:if test="count($context/month) &gt; 1">
	      <xsl:call-template name="make-error">
	         <xsl:with-param name="error-type" select="concat(local-name($context),' check')"/>
	         <xsl:with-param name="description">
	            <xsl:text> date must not contain multiple month elements</xsl:text>
	         </xsl:with-param>
	      </xsl:call-template>
	   </xsl:if>
	   <xsl:call-template name="is-valid-date"/>
	</xsl:template>
	
	<!-- *********************************************************** -->
	<!-- Template: date-type-check
		Used for pub-date/@date-type: Must be recognized value
		-->
	<!-- *********************************************************** -->
	<xsl:template name="date-type-check">
		<xsl:param name="str"/>
		<xsl:if test="$str">
			<xsl:choose>
				<xsl:when test="$str='collection'
								or $str='corrected'
								or $str='preprint'
								or $str='pub'
								or $str='retracted'">
					<!-- these are okay -->
				</xsl:when>
				<xsl:when test="$stream='book'
								and $str='pubr'">
					<!-- these are okay for books-->
				</xsl:when>
				<xsl:otherwise>
					<xsl:call-template name="make-error">
						<xsl:with-param name="error-type">
							<xsl:text>pub-date/@date-type check</xsl:text>
						</xsl:with-param>
						<xsl:with-param name="description">
							<xsl:text>@date-type on [pub-date] must be an accepted value: corrected, preprint, pub, retracted. Value provided: </xsl:text>
							<xsl:value-of select="$str"/>
						</xsl:with-param>
							<xsl:with-param name="tg-target" select="'tags.html#el-pubdate'"/>
					</xsl:call-template>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:if>
	</xsl:template>
	
 
	<!-- *********************************************************** -->
	<!-- Template: is-valid-date   -->
	<!-- *********************************************************** -->
	<xsl:template name="is-valid-date">
		<xsl:variable name="day" select="number(day)"/>
		<xsl:variable name="month" select="number(month)"/>
		<xsl:variable name="year" select="number(year)"/>
		<xsl:choose>
			<xsl:when test="not(day)"/>
			<!-- January, March, May July, August, October, December may have up ot 31 days -->
			<xsl:when test="($month=1 or $month=3 or $month=5 or $month=7 or $month=8 or $month=10 or $month=12)
			                 and $day &lt;=31"/>
								  
			<!-- April, June, September, November may have up ot 30 days -->
			<xsl:when test="($month=4 or $month=6 or $month=9 or $month=11)
			                 and $day &lt;=30"/>
			
			<!-- February may have up to 29 days in a leap year and 28 in a common year -->
			<xsl:when test="$month=2">
				<xsl:variable name="leap">
					<xsl:call-template name="is-leap-year">
						<xsl:with-param name="year" select="$year"/>
						</xsl:call-template>
					</xsl:variable>
				<xsl:choose>
					<xsl:when test="$leap='no' and $day &lt;=28"/>
					<xsl:when test="$leap='no' and $day =29">
					   <xsl:call-template name="make-error">
               			<xsl:with-param name="error-type" select="'date validity check'"/>
               			<xsl:with-param name="description">
                  			<xsl:text> date is not valid. </xsl:text>
									<xsl:value-of select="$year"/>
									<xsl:text> is not a leap year.</xsl:text>
               				</xsl:with-param>
            				</xsl:call-template>
						</xsl:when>
					<xsl:when test="$leap='yes' and $day &lt;=29"/>
					<xsl:otherwise>           				
					   <xsl:call-template name="make-error">
               			<xsl:with-param name="error-type" select="'date validity check'"/>
               			<xsl:with-param name="description">
                  			<xsl:text> date is not valid. </xsl:text>
               				</xsl:with-param>
            				</xsl:call-template>
							</xsl:otherwise>
						</xsl:choose>
				</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="make-error">
					<xsl:with-param name="error-type" select="'date validity check'"/>
					<xsl:with-param name="description">
						<xsl:text> date is not valid.</xsl:text>
						</xsl:with-param>
					</xsl:call-template>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:template>

	<xsl:template name="is-leap-year">
		<xsl:param name="year"/>
		<xsl:choose>
			<xsl:when test="$year mod 4 = 0">
				<xsl:choose>
					<xsl:when test="$year mod 100 = 0">
						<xsl:choose>
							<xsl:when test="$year mod 400 = 0">
								<xsl:text>yes</xsl:text>
								</xsl:when>
							<xsl:otherwise>
								<xsl:text>no</xsl:text>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
					<xsl:otherwise>
						<xsl:text>yes</xsl:text>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
			<xsl:otherwise>
				<xsl:text>no</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:template>

	
   <!-- *********************************************************** -->
   <!-- Template: ext-link-attribute-check
   
        Check if the href attribute is present and if the 
        ext-link-type values are correct
     -->
   <!-- *********************************************************** -->
   <xsl:template name="ext-link-attribute-check">
      <xsl:param name="context" select="."/>
      
      <!-- Check for the href attribute -->
      <xsl:if test="$context[not(@xlink:href)]">
         <xsl:call-template name="make-error">
            <xsl:with-param name="error-type">ext-link check</xsl:with-param>
            <xsl:with-param name="description">
               <xsl:text>ext-link must have an xlink:href attribute</xsl:text>
            </xsl:with-param>
         </xsl:call-template>
      </xsl:if>
         
		<!-- These are values that are ok as ext-link-types and are documented in the 
		     Tagging Guidelines.
			  
			  NOTE: the comma after each value for nice display in error message. -->	
      <xsl:variable name="documented-elt-values" select="concat(
      			'bmrb, ',
				'DDBJ/EMBL/GenBank, ',
            		'doi, ',
            		'EBI:arrayexpress, ',
            		'EBI:ena, ',
            		'emblalign, ',
            		'ftp, ',
            		'geneweaver:geneset, ',
 				'NCBI:gene, ',
				'NCBI:geo, ',
				'NCBI:nucleotide, ',
				'NCBI:protein, ',
				'NCBI:pubchem-substance, ',
				'NCBI:pubchem-bioassay, ',
				'NCBI:pubchem-compound, ',
				'NCBI:refseq, ',
				'NCBI:reseq_gene, ',
				'NCBI:sra, ',
				'NCBI:structure, ',
				'NCBI:taxonomy, ',
            		'Omim, ',
            		'PDB, ',
            		'SwissProt, ',
            		'UniProt, ',
            		'uri, ',
            		'url, ',
	        '')"/>
		
		<!-- These are values that are ok but are not documented so won't show in the error message
		     as acceptable values -->	  
      <xsl:variable name="secret-elt-values" select="concat(
            'aoi ',
            'arrayexpress ',
            'biomodels ',
            'bsh ',
            'cdd ',
	    'clone ',
            'ec ',
            'ensembl ',
            'fmridc ',
            'gen ',
            'genbank ',
            'gene ',
            'genpept ',
            'geo ',
            'highwire ',
	      'hmh ',
            'mgi ',
		 'mmdb, ',
	    	 'nuccore ',
            'pgr ',
            'pir ',
            'pirdb ',
            'pmc ',
            'pmcid ',
            'pmid ',
            'pride ',
            'pubchem ',
            'pubmed ',
	    	 'pcsubstance ',
            'sgd ',
	      'snp ',
            'sprot ',
            'tax ',
            'wbase ',
	    'dare ',
		 'webcite',
	        '')"/>

	  <xsl:variable name="is-unchecked-elt-type">
	     <xsl:call-template name="is-in-list">
		    <xsl:with-param name="list"  select="concat(translate($documented-elt-values,',',''), translate($secret-elt-values,',',''))"/>
		    <xsl:with-param name="token" select="$context/@ext-link-type"/>
		    <!--<xsl:with-param name="case"  select="'1'"/> -->
		 </xsl:call-template>
	  </xsl:variable>
	     
      <!-- Check value of the ext-link-type -->
      <xsl:choose>
         <!-- No ext-link-type attribute -->
         <xsl:when test="$context[not(@ext-link-type)]">
            <xsl:call-template name="make-error">
               <xsl:with-param name="error-type">ext-link check</xsl:with-param>
               <xsl:with-param name="description">
                  <xsl:text>ext-link must have an ext-link-type attribute</xsl:text>
               </xsl:with-param>
            </xsl:call-template>
         </xsl:when>
      	
<!-- beck took this out 1/5/2009      	<xsl:when test="$context/@ext-link-type='email' and ($document-type='book' or $document-type='book-part')">
      	</xsl:when>  -->
        
      	<xsl:when test="$context/@ext-link-type='email'">
      		<xsl:call-template name="make-error">
      			<xsl:with-param name="error-type">ext-link check</xsl:with-param>
      			<xsl:with-param name="description">
      				<xsl:text>ext-link type email must be element email</xsl:text>
      			</xsl:with-param>
      		</xsl:call-template>
      	</xsl:when>
               
         <!-- Unrecognized value? It's an error. -->
         <xsl:when test="$is-unchecked-elt-type != 1">  
	    		 <xsl:message>[[$is-unchecked-elt-type:<xsl:value-of select="$is-unchecked-elt-type"/>]]</xsl:message>        
            <xsl:call-template name="make-error">
               <xsl:with-param name="error-type">ext-link check</xsl:with-param>
               <xsl:with-param name="description" select="concat(
                  'ext-link-type attribute value restricted to one of [',
				  $documented-elt-values, '], not [',
				  $context/@ext-link-type, '].')"/>
            </xsl:call-template>
         </xsl:when>

		 <!-- otherwise we're ok -->
      </xsl:choose>
   </xsl:template> <!-- ext-link-attribute-check -->


	<!-- *********************************************************** -->
	<!-- Template: floats-wrap-check 
		
		Element floats-wrap, must:
		1) only contain content with correct position attributes
		
		this is used for both floats-wrap (2) and floats-group (3)
	-->
	<!-- *********************************************************** -->
	<xsl:template name="floats-wrap-check">
		<xsl:param name="context" select="."/>
		
		<!-- Test 1: Make sure has only floating figs and tables (and isn't empty) -->
		<xsl:choose>				
			<!-- Non floating elements -->
			<xsl:when test="$context/*[not(self::title)][not(@position = 'float')]">
				<xsl:call-template name="make-error">
					
					<xsl:with-param name="error-type">floats check</xsl:with-param>
					<xsl:with-param name="description">
						<xsl:text>&lt;</xsl:text>
						<xsl:value-of select="name()"/>
						<xsl:text>&gt; may only contain elements that have a position attribute set to "float".</xsl:text>
					</xsl:with-param>
				</xsl:call-template>                                       
			</xsl:when>
			
			<!-- No children -->
			<xsl:when test="not($context/*[not(self::title)])">
				<xsl:call-template name="make-error">
					
					<xsl:with-param name="error-type">floats check</xsl:with-param>
					<xsl:with-param name="description">
						<xsl:text>&lt;</xsl:text>
						<xsl:value-of select="name()"/>
						<xsl:text>&gt; section may not be empty.</xsl:text>
					</xsl:with-param>
				</xsl:call-template>                                       
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	
   
   <!-- *********************************************************** -->
   <!-- Template: fn-attribute-check 
   
        fn should not use @symbol
     -->
   <!-- *********************************************************** -->
   <xsl:template name="fn-attribute-check">
      <xsl:param name="context" select="."/>
            
      <!-- Symbol attribute-->
      <xsl:if test="$context/@symbol">
         <xsl:call-template name="make-error">
            <xsl:with-param name="error-type" select="'fn checking'"/>
            <xsl:with-param name="description">
               <xsl:text>Do not use the symbol attribute. Place symbol information inside a label element.</xsl:text>
            </xsl:with-param>
				<xsl:with-param name="tg-target" select="'tags.html#el-fn'"/>
         </xsl:call-template>
      </xsl:if>
   </xsl:template>
   

   <!-- *********************************************************** -->
   <!-- Template:  fn-location-check OBSOLETE
   
        Article-level fn's should all be set in a 
        fn-group in back. The only fn's
        that should be excluded are those in:
        1) author-notes
        2) front matter notes 
        3) table-wrap: these (should) have been moved
           to a table-wrap-foot footnote
        4) boxed-text: boxed-text has, in the past,
           been allowed to have its own fn-group because it
           is generally laid-out in such a way that
           it requires its footnotes to stay within
           the box 
        This template gathers up all the fn's inside
        the front and the body that are not
        descendents of the 4 cases noted above.
        It then checks that all these fn's are inside a
        fn-group that is an ancestor of the back section.
		If not, then it issues an error.
     -->
   <!-- *********************************************************** -->
   <xsl:template name="fn-location-check-OBS">
      <xsl:param name="context" select="."/>
      
      <!-- Only check fn inside the front and body -->
      <xsl:choose>
         <!-- ignore for books -->
			<xsl:when test="$document-type='book' or $document-type='book-part'"/>
         <!-- Inside front matter -->
         <xsl:when test="$context/ancestor::front">
            <xsl:choose>
               <xsl:when test="$context/ancestor::*[                   
                  self::boxed-text                   
                  or self::author-notes                   
                  or self::notes                   
                  or self::table-wrap 
                  ]">
                  <!-- This is allowed -->
               </xsl:when>
               
               <!-- Must be an error -->
               <xsl:otherwise>
                  <xsl:call-template name="make-error">
                     <xsl:with-param name="error-type" select="'fn location checking'"/>
                     <xsl:with-param name="description">
                        <xsl:text>All article-level fn's should be located inside an fn-group in back</xsl:text>
                     </xsl:with-param>
                  </xsl:call-template>
               </xsl:otherwise>
            </xsl:choose>
         </xsl:when>
         
         <!-- Inside body -->
         <xsl:when test="$context/ancestor::body">
            <xsl:choose>
               <xsl:when test="$context/ancestor::*[                   
                  self::boxed-text or
                  self::table-wrap or
                  self::sec[@sec-type='subart'] or
                  self::fig
                  ]">
                  <!-- This is allowed -->
               </xsl:when>
               
               <!-- Must be an error -->
               <xsl:otherwise>
                  <xsl:call-template name="make-error">
                     <xsl:with-param name="error-type" select="'fn location checking'"/>
                     <xsl:with-param name="description">
                        <xsl:text>All article-level fn's should be located inside an fn-group in back</xsl:text>
                     </xsl:with-param>
                  </xsl:call-template>
               </xsl:otherwise>
            </xsl:choose>
         </xsl:when>
      </xsl:choose>
   </xsl:template> 
 

   <!-- *********************************************************** -->
   <!-- Template: formula-content-test 
				1) content should be one of 
			         -content in JATS emphasis elements and PCDATA, 
					    - one mml:math, or 
					    - one tex-math. 
					  If more than one representation of the formula 
					    is included, they must be tagged as alternatives 
					    with the element (3.0+) or @alternate-form-of (2.3).
				2) *-formula must not be recursive
   -->
   <!-- *********************************************************** -->
  <xsl:template name="formula-content-test">
      <xsl:param name="context" select="."/>
		<xsl:variable name="has-plaintextmath">
		   <xsl:if test="(normalize-space(translate(text(),',.?!:;&#x2003;)([]{}','')) or bold or italic or sup or sub) and not(descendant::xref)">yes</xsl:if>
			</xsl:variable>
		<xsl:variable name="has-mmlmath">
			<xsl:if test="mml:math">yes</xsl:if>
			</xsl:variable>
		<xsl:variable name="has-tex-math">
			<xsl:if test="tex-math">yes</xsl:if>
			</xsl:variable>
		<xsl:variable name="has-graphic-math">
			<xsl:if test="(graphic or inline-graphic) and $has-plaintextmath != 'yes'">yes</xsl:if>
			</xsl:variable>
		
		<!-- Test 1 -->
		<xsl:choose>
			<!-- rules for nlm 3.0 and newer - use <alternatives> -->
			<xsl:when test="/article/front/journal-meta/journal-title-group">
				<xsl:choose>
					<xsl:when test="($has-plaintextmath='yes' and $has-mmlmath='yes') or
					                ($has-plaintextmath='yes' and $has-tex-math='yes') or
					                ($has-plaintextmath='yes' and $has-graphic-math='yes') or
					                ($has-tex-math='yes' and $has-mmlmath='yes') or
					                ($has-tex-math='yes' and $has-graphic-math='yes') or
					                ($has-mmlmath='yes' and $has-graphic-math='yes')">
         			<xsl:call-template name="make-error">
            			<xsl:with-param name="error-type" select="'formula content checking'"/>
            			<xsl:with-param name="description">
               			<xsl:text>There should only be one formula represented in the &lt;</xsl:text>
								<xsl:value-of select="name()"/>
								<xsl:text> id="</xsl:text>
								<xsl:value-of select="@id"/>
								<xsl:text>"&gt; element.  If these are alternate forms of the same formula, they must all be wrapped in &lt;alternatives&gt;.
								If more than on formula is represented here, each should be in its own &lt;</xsl:text>
								<xsl:value-of select="name()"/>
								<xsl:text>&gt;.</xsl:text>
            				</xsl:with-param>
							<!-- <xsl:with-param name="tg-target" select="'tags.html#el-fpage'"/> -->
         				</xsl:call-template>
										 
						</xsl:when>
					<xsl:when test="count(mml:math) &gt; 1 or count(tex-math) &gt; 1">
         			<xsl:call-template name="make-error">
            			<xsl:with-param name="error-type" select="'formula content checking'"/>
            			<xsl:with-param name="description">
               			<xsl:text>There should only be one formula represented in the &lt;</xsl:text>
								<xsl:value-of select="name()"/>
								<xsl:text> id="</xsl:text>
								<xsl:value-of select="@id"/>
								<xsl:text>"&gt; element. If these are alternate forms of the same formula, they must all be wrapped in &lt;alternatives&gt;.
								If more than on formula is represented here, each should be in its own &lt;</xsl:text>
								<xsl:value-of select="name()"/>
								<xsl:text>&gt;.</xsl:text>
            				</xsl:with-param>
							<!-- <xsl:with-param name="tg-target" select="'tags.html#el-fpage'"/> -->
         				</xsl:call-template>
						</xsl:when>
					</xsl:choose>
				</xsl:when>
			<!-- rules for nlm 2.3 and earlier - use @alternate-version-of -->
			<xsl:otherwise>
				<xsl:choose>
					<xsl:when test="(($has-plaintextmath='yes' and $has-mmlmath='yes') or
					                ($has-plaintextmath='yes' and $has-tex-math='yes') or
					                ($has-plaintextmath='yes' and $has-graphic-math='yes') or
					                ($has-tex-math='yes' and $has-mmlmath='yes') or
					                ($has-tex-math='yes' and $has-graphic-math='yes') or
					                ($has-mmlmath='yes' and $has-graphic-math='yes')) and not(child::node()[@alternate-form-of])">
         			<xsl:call-template name="make-error">
            			<xsl:with-param name="error-type" select="'formula content checking'"/>
            			<xsl:with-param name="description">
               			<xsl:text>There should only be one formula represented in the &lt;</xsl:text>
								<xsl:value-of select="name()"/>
								<xsl:text> id="</xsl:text>
								<xsl:value-of select="@id"/>
								<xsl:text>"&gt; element.  Alternate forms of the same formula must be identified with @alternate-form-of.
								If more than on formula is represented here, each should be in its own &lt;</xsl:text>
								<xsl:value-of select="name()"/>
								<xsl:text>&gt;.</xsl:text>
            				</xsl:with-param>
							<!-- <xsl:with-param name="tg-target" select="'tags.html#el-fpage'"/> -->
         				</xsl:call-template>
										 
						</xsl:when>
					<xsl:when test="count(mml:math) &gt; 1 or count(tex-math) &gt; 1">
         			<xsl:call-template name="make-error">
            			<xsl:with-param name="error-type" select="'formula content checking'"/>
            			<xsl:with-param name="description">
               			<xsl:text>There should only be one formula represented in the &lt;</xsl:text>
								<xsl:value-of select="name()"/>
								<xsl:text> id="</xsl:text>
								<xsl:value-of select="@id"/>
								<xsl:text>"&gt; element.  Alternate forms of the same formula must be identified with @alternate-form-of.
								If more than on formula is represented here, each should be in its own &lt;</xsl:text>
								<xsl:value-of select="name()"/>
								<xsl:text>&gt;.</xsl:text>
            				</xsl:with-param>
							<!-- <xsl:with-param name="tg-target" select="'tags.html#el-fpage'"/> -->
         				</xsl:call-template>
						</xsl:when>
					</xsl:choose>
				</xsl:otherwise>
			</xsl:choose>
  			
  			<!-- Test 2 -->
  			<xsl:choose>
  				<xsl:when test="local-name($context)='disp-formula'">
  					<xsl:if test="descendant::disp-formula">
  						<xsl:call-template name="make-error">
  							<xsl:with-param name="error-type" select="'disp-formula checking'"/>
  							<xsl:with-param name="description">
  								<xsl:text>&lt;disp-formula> must not have descendant &lt;disp-formula&gt;</xsl:text>
  							</xsl:with-param>
  						</xsl:call-template>
  					</xsl:if>
  				</xsl:when>
  				<xsl:when test="local-name($context)='inline-formula'">
  					<xsl:if test="descendant::inline-formula">
  						<xsl:call-template name="make-error">
  							<xsl:with-param name="error-type" select="'disp-formula checking'"/>
  							<xsl:with-param name="description">  								
  								<xsl:text>&lt;inline-formula> must not have descendant &lt;inline-formula&gt;</xsl:text>
  							</xsl:with-param>
  						</xsl:call-template>
  					</xsl:if>
  				</xsl:when>
  			</xsl:choose>
  			
    </xsl:template> 

   <!-- *********************************************************** -->
   <!-- Template: fpage-check 
   
        fpage or elocation-id must be present in article.
     -->
   <!-- *********************************************************** -->
   <xsl:template name="fpage-check">
      <xsl:param name="context" select="."/>

      <xsl:if test="not(fpage) and not(elocation-id) and 
							not(contains(//processing-instruction('properties'),'OLF')) and 
							not(//processing-instruction('OLF')) and 
							not(contains(//processing-instruction('aheadofprint-preload'),'true')) and 
							not(contains(//processing-instruction('properties'),'scanned_data'))">
         <xsl:call-template name="make-error">
            <xsl:with-param name="error-type" select="'article-meta checking'"/>
            <xsl:with-param name="description">
               <xsl:text>Either &lt;fpage&gt; or &lt;elocation-id&gt; must be present in &lt;article-meta&gt;</xsl:text>
            </xsl:with-param>
				<xsl:with-param name="tg-target" select="'tags.html#el-fpage'"/>
         </xsl:call-template>
      </xsl:if>       
   </xsl:template>
  
   <!-- ********************************************* -->
   <!-- Template: front-content-test
        
        Don't allow notes element in front.
        
        Context: front -->
   <!-- ********************************************* -->   
   <xsl:template name="front-content-test">
      <xsl:if test="not(journal-meta)">
         <xsl:call-template name="make-error">
				<xsl:with-param name="error-type" select="'front content check'"/>
				<xsl:with-param name="description">
               <xsl:text>&lt;front&gt; requires &lt;journal-meta&gt; .</xsl:text>
            	</xsl:with-param>
				 <xsl:with-param name="tg-target" select="'tags.html#el-front'"/>
         	</xsl:call-template>
      	</xsl:if>
   </xsl:template>

   <!-- *********************************************************** -->
   <!-- Template: graphic-alt-version-check 
   
        If alt-version is specified, then there must
        be another element with alt-form-of that
        matches the graphic id.
     -->
   <!-- *********************************************************** -->
   <xsl:key name="id-to-alternate-form-of" 
            match="*[@alternate-form-of]"
			use="@alternate-form-of"/>
   <xsl:template name="graphic-alt-version-check">
      <xsl:param name="context" select="."/>
      
      <xsl:if test="$context[@alt-version = 'yes' and 
	                         not(key('id-to-alternate-form-of',@id))]">
         <xsl:call-template name="make-error">
            <xsl:with-param name="error-type" select="'alt-version checking'"/>
            <xsl:with-param name="description">
               <xsl:text>An alternate-form for this graphic is not declared in the instance.</xsl:text>
            </xsl:with-param>
         </xsl:call-template>
      </xsl:if>

   </xsl:template>

   <!-- *********************************************************** -->
   <!-- Template: supplemental-issue-check 
      
      Do not use <supplement> on article-meta/issue|front-stub/issue
   -->
   <!-- *********************************************************** -->
   <xsl:template name="supplemental-issue-check">
         <xsl:call-template name="make-error">
            <xsl:with-param name="error-type" select="'supplemental-issue-check'"/>
            <xsl:with-param name="description">
               <xsl:text>Do not use the &lt;supplement&gt; to identify a supplementary issue in &lt;article-meta&gt; or &lt;front-stub&gt;.</xsl:text>
            </xsl:with-param>
            <xsl:with-param name="tg-target" select="'tags.html#el-issue'"/>
         </xsl:call-template>
   </xsl:template>
   <!-- *********************************************************** -->
   <!-- Template: history-date-type-attribute-check 
        
        Check that history/date/@date-type is a known value.
     -->
   <!-- *********************************************************** -->
   <xsl:template name="history-date-type-attribute-check">
      <xsl:param name="context" select="."/>

	  <xsl:variable name="ok-date-types-article" select="concat(
	     'accepted ',
		'fascicular ', 
	     'online ',
	     'read ', 
		 'received ',
		 'rev-request ',
		 'rev-recd ',
		 '')"/>
	  <xsl:variable name="ok-date-types-rrn" select="concat(
	     'created ',
	     'accepted ',
		 'received ',
		 'rev-request ',
		 'rev-recd ',
		 '')"/>
          <xsl:variable name="ok-date-types-book" select="concat(
	     $ok-date-types-article, ' ',
		 'created ',
		 'updated ',
		 'revised ',
		 'reviewed ',
		 '')"/>
	  <xsl:variable name="ok-date-types-other" select="concat(
	     $ok-date-types-article, ' ',
		 'created ',
		 'updated ',
		 'revised ',
		 '')"/>

      <!-- created and updated apparently only allowed for non-articles? -->

      <xsl:choose>
			<xsl:when test="$stream='rrn'">
         	  <xsl:variable name="date-type-ok-rrn">
         	     <xsl:call-template name="is-in-list">
         		    <xsl:with-param name="list" select="$ok-date-types-rrn"/>
         		    <xsl:with-param name="token" select="$context/@date-type"/>
         		    <xsl:with-param name="case"  select="'1'"/>
         		 </xsl:call-template>
         	  </xsl:variable>
      		  <xsl:if test="$context[not(@date-type)] or
			                $date-type-ok-rrn!=1">
         		<xsl:call-template name="make-error">
            		<xsl:with-param name="error-type">date check</xsl:with-param>
            		<xsl:with-param name="description" select="concat(
               		   'date inside history must have date-type attribute ',
					   'with value from [', $ok-date-types-article, ']',
					   ', not [', @date-type, '].')"/>
       			</xsl:call-template>
       		  </xsl:if>
			</xsl:when>
			
			<xsl:when test="$stream='book'">
         	  <xsl:variable name="date-type-ok-book">
         	     <xsl:call-template name="is-in-list">
         		    <xsl:with-param name="list" select="$ok-date-types-book"/>
         		    <xsl:with-param name="token" select="$context/@date-type"/>
         		    <xsl:with-param name="case"  select="'1'"/>
         		 </xsl:call-template>
         	  </xsl:variable>
      		  <xsl:if test="$context[not(@date-type)] or
			                $date-type-ok-book!=1">
         		<xsl:call-template name="make-error">
            		<xsl:with-param name="error-type">date check</xsl:with-param>
            		<xsl:with-param name="description" select="concat(
               		   'date inside history must have date-type attribute ',
					   'with value from [', $ok-date-types-article, ']',
					   ', not [', @date-type, '].')"/>
       			</xsl:call-template>
       		  </xsl:if>
			</xsl:when>

			<xsl:when test="$document-type='article'">
         	  <xsl:variable name="date-type-ok-article">
         	     <xsl:call-template name="is-in-list">
         		    <xsl:with-param name="list" select="$ok-date-types-article"/>
         		    <xsl:with-param name="token" select="$context/@date-type"/>
         		    <xsl:with-param name="case"  select="'1'"/>
         		 </xsl:call-template>
         	  </xsl:variable>
      		  <xsl:if test="$context[not(@date-type)] or
			                $date-type-ok-article!=1">
         		<xsl:call-template name="make-error">
            		<xsl:with-param name="error-type">date check</xsl:with-param>
            		<xsl:with-param name="description" select="concat(
               		   'date inside history should have date-type attribute ',
					   'with value from [', $ok-date-types-article, ']',
					   ', not [', @date-type, '].')"/>
						<xsl:with-param name="class" select="'warning'"/>
       			</xsl:call-template>
       		  </xsl:if>
			</xsl:when>

			<xsl:otherwise>
         	  <xsl:variable name="date-type-ok-other">
         	     <xsl:call-template name="is-in-list">
         		    <xsl:with-param name="list" select="$ok-date-types-other"/>
         		    <xsl:with-param name="token" select="$context/@date-type"/>
         		    <xsl:with-param name="case"  select="'1'"/>
         		 </xsl:call-template>
         	  </xsl:variable>
      		  <xsl:if test="$context[not(@date-type)] or
			                $date-type-ok-other!=1">			         
         		<xsl:call-template name="make-error">
            		<xsl:with-param name="error-type">date check</xsl:with-param>
            		<xsl:with-param name="description" select="concat(
               		   'date inside history should have date-type attribute ',
					   'with value restricted to [ ', $ok-date-types-other,
					   '], not [', $context/@date-type,
					   '].')"/>
						<xsl:with-param name="class" select="'warning'"/>
         			</xsl:call-template>
      		  </xsl:if>
			</xsl:otherwise>
		</xsl:choose>
   	</xsl:template>
   

   <!-- *********************************************************** -->
   <!-- Template: href-content-check 
   
        1) xlink:href attributes cannot be empty 
        2) xlink:href cannot have leading or trailing spaces
     -->
   <!-- *********************************************************** -->
   <xsl:template name="href-content-check">
      <xsl:param name="context" select="."/>

		<xsl:if test="$context/@xlink:href and normalize-space($context/@xlink:href) = ''">
			<xsl:call-template name="make-error">
            <xsl:with-param name="error-type" select="'xlink:href checking'"/>
            <xsl:with-param name="description">
               <xsl:text>xlink:href attribute cannot be empty</xsl:text>
					</xsl:with-param>
				</xsl:call-template>
		</xsl:if>
   	<xsl:if test="normalize-space(@xlink:href)!=@xlink:href">	
   		<xsl:call-template name="make-error">
   			<xsl:with-param name="error-type" select="'xlink:href checking'"/>
   			<xsl:with-param name="description">
   				<xsl:text>xlink:href should not contain leading or trailing spaces.</xsl:text>
   			</xsl:with-param>
   		</xsl:call-template>
   	</xsl:if>
		</xsl:template>

   <!-- *********************************************************** -->
   <!-- Template: href-ext-check 
      
      xlink:href attributes must have a file extension in some contexts like supplementary-material and inline-supplementary-material.
   -->
   <!-- *********************************************************** -->

   <xsl:template name="href-ext-check">
      <xsl:param name="href"/>
      <xsl:variable name="substr-after-last-dot">
         <xsl:call-template name="substring-after-last-dot">
            <xsl:with-param name="str" select="$href"/>
         </xsl:call-template>
      </xsl:variable>
      <xsl:if test="not(contains($href, '.'))
         or (contains($href, '.') and string-length($substr-after-last-dot) &gt; 10)
         or (contains($href, '.') and (contains($substr-after-last-dot, '-') or contains($substr-after-last-dot, '_')))
         or $substr-after-last-dot = ''">
         <xsl:call-template name="make-error">
            <xsl:with-param name="error-type" select="'@xlink:href checking'"/>
            <xsl:with-param name="description">
               <xsl:text>@xlink:href requires a file extension in this context</xsl:text>
            </xsl:with-param>
         </xsl:call-template>
      </xsl:if>       
   </xsl:template>



   <!-- ********************************************* -->
   <!-- Template: id-present-test
        
        Check that the element has an id attribute.
        
        Caller must pass in the name of the element
        that is being checked so that it can be
        included in the error message.
        
        Context: various -->
   <!-- ********************************************* -->   
   <xsl:template name="id-present-test">
      <xsl:if test="not(@id)">
         <xsl:call-template name="make-error">
            <xsl:with-param name="error-type" select="'required id check'"/>
            <xsl:with-param name="description">
               <xsl:value-of select="name()"/>
               <xsl:text> requires an id attribute.</xsl:text>
            </xsl:with-param>         	
         	<xsl:with-param name="tg-target" select="'dobs.html#dob-ids'"/>
         </xsl:call-template>
      </xsl:if>
   </xsl:template>

   <!-- ********************************************* -->
   <!-- Template: id-content-test
        
        Make sure that the id has the correct content
        for the given parent.
        
        Context: various -->
   <!-- ********************************************* -->   
   <xsl:template name="id-content-test">
      <!-- Check the content of the id to make sure it
           starts with the right letter(s). Note that
           nothing is returned if there is no id attribute.
           Testing for the presence of an id attribute
           will be handled by a different template. -->
           
      <xsl:choose>
         <xsl:when test="self::p">
            <xsl:if test="not(starts-with(@id, 'P')) and @id">
               <xsl:call-template name="make-error">
           			<xsl:with-param name="error-type" select="'id content check'"/>
                  <xsl:with-param name="description">
                     <xsl:text>id attribute value in p must begin with 'P'.</xsl:text>
                  	</xsl:with-param>
			<xsl:with-param name="tg-target" select="'dobs.html#dob-ids'"/>
               </xsl:call-template>
            </xsl:if>
         </xsl:when>

         <xsl:when test="self::fig">
            <xsl:if test="not(starts-with(@id, 'F')) and @id">
               <xsl:call-template name="make-error">
           			<xsl:with-param name="error-type" select="'id content check'"/>
                  <xsl:with-param name="description">
   		            <xsl:text>id attribute value in fig must begin with 'F'.</xsl:text>
                  </xsl:with-param>               	
               	<xsl:with-param name="tg-target" select="'dobs.html#dob-ids'"/>
               </xsl:call-template>
            </xsl:if>
         </xsl:when>

         <xsl:when test="self::table-wrap">
            <xsl:if test="not(starts-with(@id, 'T')) and @id">
               <xsl:call-template name="make-error">
           			<xsl:with-param name="error-type" select="'id content check'"/>
                  <xsl:with-param name="description">
                     <xsl:text>id attribute value in table-wrap must begin with 'T'.</xsl:text>
                  </xsl:with-param>
               	<xsl:with-param name="tg-target" select="'dobs.html#dob-ids'"/>
               </xsl:call-template>
            </xsl:if>
         </xsl:when>
         
         <xsl:when test="self::disp-formula">
            <xsl:if test="not(starts-with(@id, 'FD')) and @id">
               <xsl:call-template name="make-error">
           			<xsl:with-param name="error-type" select="'id content check'"/>
                  <xsl:with-param name="description">
                     <xsl:text>id attribute value in disp-formula must begin with 'FD'.</xsl:text>
                  </xsl:with-param>
               	<xsl:with-param name="tg-target" select="'dobs.html#dob-ids'"/>
               </xsl:call-template>
            </xsl:if>
         </xsl:when>

         <xsl:when test="self::mml:math" xmlns:mml="http://www.w3.org/1998/Math/MathML">
            <xsl:if test="not(starts-with(@id, 'M')) and @id">
               <xsl:call-template name="make-error">
           			<xsl:with-param name="error-type" select="'id content check'"/>
                  <xsl:with-param name="description">
                     <xsl:text>id attribute value in mml:math must begin with 'M'.</xsl:text>
                  </xsl:with-param>
               	<xsl:with-param name="tg-target" select="'dobs.html#dob-ids'"/>
               </xsl:call-template>
            </xsl:if>
         </xsl:when>

         <xsl:when test="self::list">
            <xsl:if test="not(starts-with(@id, 'L')) and @id">
               <xsl:call-template name="make-error">
           			<xsl:with-param name="error-type" select="'id content check'"/>
                  <xsl:with-param name="description">
                     <xsl:text>id attribute value in list must begin with 'L'.</xsl:text>
                  </xsl:with-param>
               	<xsl:with-param name="tg-target" select="'dobs.html#dob-ids'"/>
               </xsl:call-template>
            </xsl:if>
         </xsl:when>

         <xsl:when test="self::disp-quote">
            <xsl:if test="not(starts-with(@id, 'Q')) and @id">
               <xsl:call-template name="make-error">
           			<xsl:with-param name="error-type" select="'id content check'"/>
                  <xsl:with-param name="description">
                     <xsl:text>id attribute value in disp-quote must begin with 'Q'.</xsl:text>
                  </xsl:with-param>
               	<xsl:with-param name="tg-target" select="'dobs.html#dob-ids'"/>
               </xsl:call-template>
            </xsl:if>
         </xsl:when>

         <xsl:when test="self::supplementary-material">
            <xsl:if test="not(starts-with(@id, 'SD')) and @id">
               <xsl:call-template name="make-error">
           			<xsl:with-param name="error-type" select="'id content check'"/>
                  <xsl:with-param name="description">
                     <xsl:text>id attribute value in supplementary-material must begin with 'SD'.</xsl:text>
                  </xsl:with-param>
               	<xsl:with-param name="tg-target" select="'dobs.html#dob-ids'"/>
               </xsl:call-template>
            </xsl:if>
         </xsl:when>
         
         <xsl:when test="self::sec">
            <xsl:if test="not(starts-with(@id, 'S')) and @id">
               <xsl:call-template name="make-error">
           			<xsl:with-param name="error-type" select="'id content check'"/>
                  <xsl:with-param name="description">
                     <xsl:text>id attribute value in sec must begin with 'S'.</xsl:text>
                  </xsl:with-param>
               	<xsl:with-param name="tg-target" select="'dobs.html#dob-ids'"/>
               </xsl:call-template>
            </xsl:if>
         </xsl:when>
          
         <xsl:when test="self::ack">
            <xsl:if test="not(starts-with(@id, 'S')) and @id">
                <xsl:call-template name="make-error">
           			<xsl:with-param name="error-type" select="'id content check'"/>
                  <xsl:with-param name="description">
                     <xsl:text>id attribute value in ack must begin with 'S'.</xsl:text>
                  </xsl:with-param>
                	<xsl:with-param name="tg-target" select="'dobs.html#dob-ids'"/>
               </xsl:call-template>
            </xsl:if>
         </xsl:when>

         <xsl:when test="self::aff">
            <xsl:if test="not(starts-with(@id, 'A')) and @id">
               <xsl:call-template name="make-error">
           			<xsl:with-param name="error-type" select="'id content check'"/>
                  <xsl:with-param name="description">
                     <xsl:text>id attribute value in aff must begin with 'A'.</xsl:text>
                  </xsl:with-param>
               	<xsl:with-param name="tg-target" select="'dobs.html#dob-ids'"/>
               </xsl:call-template>
            </xsl:if>
         </xsl:when>

         <xsl:when test="self::app">
            <xsl:if test="not(starts-with(@id, 'APP')) and @id">
               <xsl:call-template name="make-error">
           			<xsl:with-param name="error-type" select="'id content check'"/>
                  <xsl:with-param name="description">
                     <xsl:text>id attribute value in app must begin with 'APP'.</xsl:text>
                  </xsl:with-param>
               	<xsl:with-param name="tg-target" select="'dobs.html#dob-ids'"/>
               </xsl:call-template>
            </xsl:if>
         </xsl:when>

         <xsl:when test="self::boxed-text">
            <xsl:if test="not(starts-with(@id, 'BX')) and @id">
               <xsl:call-template name="make-error">
           			<xsl:with-param name="error-type" select="'id content check'"/>
                  <xsl:with-param name="description">
                     <xsl:text>id attribute value in boxed-text must begin with 'BX'.</xsl:text>
                  </xsl:with-param>
               	<xsl:with-param name="tg-target" select="'dobs.html#dob-ids'"/>
               </xsl:call-template>
            </xsl:if>
         </xsl:when>

         <xsl:when test="self::fn and ancestor::table-wrap">
            <xsl:if test="not(starts-with(@id, 'TFN')) and @id">
               <xsl:call-template name="make-error">
	        			<xsl:with-param name="error-type" select="'id content check'"/>
                 <xsl:with-param name="description">
                     <xsl:text>id attribute value in fn must begin with 'TFN'.</xsl:text>
                 </xsl:with-param>
               	<xsl:with-param name="tg-target" select="'dobs.html#dob-ids'"/>
               </xsl:call-template>
            </xsl:if>
         </xsl:when>

         <xsl:when test="self::fn">
            <xsl:if test="not(starts-with(@id, 'FN')) and @id">
               <xsl:call-template name="make-error">
           			<xsl:with-param name="error-type" select="'id content check'"/>
                  <xsl:with-param name="description">
                     <xsl:text>id attribute value in fn must begin with 'FN'.</xsl:text>
                  </xsl:with-param>
               	<xsl:with-param name="tg-target" select="'dobs.html#dob-ids'"/>
              </xsl:call-template>
            </xsl:if>
         </xsl:when>

         <xsl:when test="self::ref">
            <xsl:if test="not(starts-with(@id, 'R')) and @id">
               <xsl:call-template name="make-error">
           			<xsl:with-param name="error-type" select="'id content check'"/>
                  <xsl:with-param name="description">
                     <xsl:text>id attribute value in ref must begin with 'R'.</xsl:text>
                  </xsl:with-param>
               	<xsl:with-param name="tg-target" select="'dobs.html#dob-ids'"/>
               </xsl:call-template>
            </xsl:if>
         </xsl:when>
       </xsl:choose>
      
   </xsl:template>

   <!-- *********************************************************** -->
   <!-- Template: is-day
        Input string cannot be empty and must be
        an integer between 1 and 31.
        
        Returns true if a day, false otherwise
     -->
   <!-- *********************************************************** -->
   <xsl:template name="is-day">
      <xsl:param name="input"/>

      <xsl:choose>
         <xsl:when test="not($input)">
            <xsl:text>false</xsl:text>
         </xsl:when>
         
         <xsl:when test="string-length(normalize-space($input)) = 0 
            or string(number($input)) = 'NaN'                           
            or number($input) &gt; 31                           
            or number($input) &lt; 1">
            <xsl:text>false</xsl:text>
         </xsl:when>
         
         <xsl:otherwise>
            <xsl:text>true</xsl:text>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>


   <!-- *********************************************************** -->
   <!-- Template: is-month
        
        Returns true if:
        -not empty string
        -integer from 1 to 12
        -recognized name in any case (must set a param for this)
        
        Param:
           accept-name   Whether a name like "January" is OK
                         Set to true if will accept this value; 
                         defaults to false.
     -->
   <!-- *********************************************************** -->
   <xsl:template name="is-month">
      <xsl:param name="input"/>
      <xsl:param name="accept-name" select="'false'"/>
      
      <xsl:choose>
         <xsl:when test="not($input)">
            <xsl:text>false</xsl:text>         
         </xsl:when>
                  
         <!-- Zero length string -->
         <xsl:when test="string-length(normalize-space($input)) = 0"> 
            <xsl:text>false</xsl:text>
         </xsl:when>
         
         <!-- Can accept named values and we know this is not a number:
			  so check if this is a valid name -->
         <xsl:when test="$accept-name = 'true' and string(number($input)) = 'NaN'">
            <xsl:variable name="normalized-month">
	 		   <xsl:call-template name="capitalize">
				  <xsl:with-param name="str" select="normalize-space($input)"/>
			   </xsl:call-template>
			</xsl:variable>

            <xsl:choose>
               <xsl:when test="$normalized-month = 'JANUARY'
                           or $normalized-month = 'FEBRUARY'
                           or $normalized-month = 'MARCH'
                           or $normalized-month = 'APRIL'
                           or $normalized-month = 'MAY'
                           or $normalized-month = 'JUNE'
                           or $normalized-month = 'JULY'
                           or $normalized-month = 'AUGUST'
                           or $normalized-month = 'SEPTEMBER'
                           or $normalized-month = 'OCTOBER'
                           or $normalized-month = 'NOVEMBER'
                           or $normalized-month = 'DECEMBER'">
                  <xsl:text>true</xsl:text>
               </xsl:when>
               
               <!-- Also accept three letter abbreviations -->
               <xsl:when test="$normalized-month = 'JAN'
                            or $normalized-month = 'FEB'
                            or $normalized-month = 'MAR'
                            or $normalized-month = 'APR'
                            or $normalized-month = 'MAY'
                            or $normalized-month = 'JUN'
                            or $normalized-month = 'JUL'
                            or $normalized-month = 'AUG'
                            or $normalized-month = 'SEP'
                            or $normalized-month = 'OCT'
                            or $normalized-month = 'NOV'
                            or $normalized-month = 'DEC'">
                  <xsl:text>true</xsl:text>
               </xsl:when>
               
               <xsl:otherwise>
                  <xsl:text>false</xsl:text>
               </xsl:otherwise>
            </xsl:choose>
         </xsl:when>
         
         <!-- Not accepting named values and this is not a number: error -->
         <xsl:when test="string(number($input)) = 'NaN'">
            <xsl:text>false</xsl:text>
         </xsl:when>
         
         <!-- Number is out of range -->
         <xsl:when test="number($input) &gt; 12 or number($input) &lt; 1">
            <xsl:text>false</xsl:text>
         </xsl:when>
         
         <!-- Must be ok -->
         <xsl:otherwise>
            <xsl:text>true</xsl:text>
         </xsl:otherwise>         
      </xsl:choose>
   </xsl:template>


   <!-- *********************************************************** -->
   <!-- Template: is-season
        
        Can't be empty, must be a known season name, a
        season range, or a month range. For the month range, this 
        calls another template.
     -->
   <!-- *********************************************************** -->
   <xsl:template name="is-season">
      <xsl:param name="input"/>
      
      <xsl:variable name="normalized-input-case">
	     <xsl:call-template name="capitalize">
	        <xsl:with-param name="str" select="normalize-space($input)"/>
	     </xsl:call-template>
      </xsl:variable>
	        
      <xsl:choose>
         <xsl:when test="not($input)">
            <xsl:text>false</xsl:text>
         </xsl:when>
         
         <!-- Zero-length string -->
         <xsl:when test="string-length($normalized-input-case) = 0">
            <xsl:text>false</xsl:text>
         </xsl:when>
         
         <!-- Known season when case is not considered -->
         <xsl:when test="                
            $normalized-input-case    = 'SPRING'                 
            or $normalized-input-case = 'SUMMER'                
            or $normalized-input-case = 'AUTUMN'                
            or $normalized-input-case = 'FALL'                
            or $normalized-input-case = 'WINTER'">
            <xsl:text>true</xsl:text>
         </xsl:when>
         
         <!-- Known quarters when case is not considered -->
         <xsl:when test="                
            $normalized-input-case    = 'FIRST QUARTER'                 
            or $normalized-input-case = '1ST QUARTER'                
            or $normalized-input-case = 'SECOND QUARTER'                
            or $normalized-input-case = '2ND QUARTER'                
            or $normalized-input-case = 'THIRD QUARTER'                
            or $normalized-input-case = '3RD QUARTER'                
            or $normalized-input-case = 'FOURTH QUARTER'                
            or $normalized-input-case = '4TH QUARTER'">
            <xsl:text>true</xsl:text>
         </xsl:when>
         
         <!-- Need to check if this is a range -->
         <xsl:otherwise>		 
            <xsl:variable name="is-three-letter-range">
               <xsl:call-template name="test-month-range">
                  <xsl:with-param name="range" select="$normalized-input-case"/>
                  <xsl:with-param name="comparison-string"
				    select="'JAN-FEB-MAR-APR-MAY-JUN-JUL-AUG-SEP-OCT-NOV-DEC-'"/>
               </xsl:call-template>
            </xsl:variable>
                  
            <xsl:variable name="is-full-name-range">
               <xsl:call-template name="test-month-range">
                  <xsl:with-param name="range" select="$normalized-input-case"/>
                  <xsl:with-param name="comparison-string" select="'JANUARY-FEBRUARY-MARCH-APRIL-MAY-JUNE-JULY-AUGUST-SEPTEMBER-OCTOBER-NOVEMBER-DECEMBER-'"/>
               </xsl:call-template>
            </xsl:variable>

            <xsl:variable name="is-long-name-abbreviated-range">
               <xsl:call-template name="test-month-range">
                  <xsl:with-param name="range" select="$normalized-input-case"/>
                  <xsl:with-param name="comparison-string" select="'JAN-FEB-MARCH-APRIL-MAY-JUNE-JULY-AUG-SEP-SEPT-OCT-NOV-DEC-'"/>
               </xsl:call-template>
            </xsl:variable>
            
            <xsl:variable name="is-named-season-range-with-fall">
               <xsl:call-template name="test-month-range">
                  <xsl:with-param name="range" select="$normalized-input-case"/>
                  <xsl:with-param name="comparison-string" select="'SPRING-SUMMER-FALL-WINTER-SPRING-'"/>
               </xsl:call-template>
            </xsl:variable>

            <xsl:variable name="is-named-season-range-with-autumn">
               <xsl:call-template name="test-month-range">
                  <xsl:with-param name="range" select="$normalized-input-case"/>
                  <xsl:with-param name="comparison-string" select="'SPRING-SUMMER-AUTUMN-WINTER-SPRING-'"/>
               </xsl:call-template>
            </xsl:variable>
			
                              
            <!-- Report the results -->
            <xsl:choose>
               <xsl:when test="$is-three-letter-range = 'true'">
                  <xsl:text>true</xsl:text>
               </xsl:when>
                     
               <xsl:when test="$is-full-name-range = 'true'">
                  <xsl:text>true</xsl:text>
               </xsl:when>
               
               <xsl:when test="$is-named-season-range-with-fall = 'true'">
                  <xsl:text>true</xsl:text>
               </xsl:when>

               <xsl:when test="$is-named-season-range-with-autumn = 'true'">
                  <xsl:text>true</xsl:text>
               </xsl:when>

               <xsl:when test="$is-full-name-range = 'true'">
                  <xsl:text>true</xsl:text>
               </xsl:when>

               <xsl:when test="$is-long-name-abbreviated-range = 'true'">
                  <xsl:text>true</xsl:text>
               </xsl:when>

               <xsl:otherwise>
                  <xsl:text>false</xsl:text>
               </xsl:otherwise>
            </xsl:choose>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>


   <!-- *********************************************************** -->
   <!-- Template: is-year
        
        Make sure that the year element only contains
        an integer value between the upper and lower
        limits, which default to 1700 and 2100, inclusive.        
   -->
   <!-- *********************************************************** -->
   <xsl:template name="is-year">
      <xsl:param name="input"/>
      <xsl:param name="lower-limit" select="1700"/>
      <xsl:param name="upper-limit" select="2100"/>
      
      <xsl:choose>
         <xsl:when test="not($input)">
            <xsl:text>false</xsl:text>
         </xsl:when>
         
         <!-- 0 length -->
         <xsl:when test="string-length(normalize-space($input)) = 0">
            <xsl:text>false</xsl:text>
         </xsl:when>
         
         <!-- Not a number or out of range -->
         <xsl:when test="string(number($input)) = 'NaN'
	                  or number($input) &gt; $upper-limit
					  or number($input) &lt; $lower-limit">
            <xsl:text>false</xsl:text>
         </xsl:when>
         
         <xsl:otherwise>
            <xsl:text>true</xsl:text>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>


   <!-- *********************************************************** -->
   <!-- Template: issn-problem
        
        For checking journal-meta: examines issn element and checks that the
        form is: \d{4}-\d{3}(\d|X). 
        
        Returns "true" when has a problem, false otherwise 
	 -->
   <!-- *********************************************************** -->
   <xsl:template name="issn-problem">
      <xsl:param name="issn" select="''"/>
      
      <xsl:choose>
			<!-- odd ISSN with only 7 digits; skip the tests for these values -->
			<xsl:when test="$issn='1873-781'">
				<xsl:text>false</xsl:text>
				</xsl:when>
				
         <!-- Empty issn -->
         <xsl:when test="string-length(normalize-space($issn)) = 0">
            <xsl:text>true</xsl:text>
         </xsl:when>

         <!-- Wrong number of characters -->
         <xsl:when test="string-length(normalize-space($issn)) != 9">
            <xsl:text>true</xsl:text>
         </xsl:when>
         
         <!-- First char not a digit -->
         <xsl:when test="string(number(substring($issn, 1, 1))) = 'NaN'">
            <xsl:text>true</xsl:text>
         </xsl:when>
         
         <!-- Second char not a digit -->
         <xsl:when test="string(number(substring($issn, 2, 1))) = 'NaN'">
            <xsl:text>true</xsl:text>
         </xsl:when>
         
         <!-- Third char not a digit -->
         <xsl:when test="string(number(substring($issn, 3, 1))) = 'NaN'">
            <xsl:text>true</xsl:text>
         </xsl:when>

         <!-- Fourth char not a digit -->
         <xsl:when test="string(number(substring($issn, 4, 1))) = 'NaN'">
            <xsl:text>true</xsl:text>
         </xsl:when>

         <!-- Fifth char not a dash -->
         <xsl:when test="substring($issn, 5, 1) != '-'">
            <xsl:text>true</xsl:text>
         </xsl:when>

         <!-- Sixth char not a digit -->
         <xsl:when test="string(number(substring($issn, 6, 1))) = 'NaN'">
            <xsl:text>true</xsl:text>
         </xsl:when>

         <!-- Seventh char not a digit -->
         <xsl:when test="string(number(substring($issn, 7, 1))) = 'NaN'">
            <xsl:text>true</xsl:text>
         </xsl:when>

         <!-- Eighth char not a digit -->
         <xsl:when test="string(number(substring($issn, 8, 1))) = 'NaN'">
            <xsl:text>true</xsl:text>
         </xsl:when>

         <!-- Ninth char not a digit and not 'X' -->
         <xsl:when test="string(number(substring($issn, 9, 1))) = 'NaN'
	                 and substring($issn, 9, 1) != 'X'">
            <xsl:text>true</xsl:text>
         </xsl:when>

         <!-- Must be OK -->
         <xsl:otherwise>
            <xsl:text>false</xsl:text>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
	
	
	<!-- *********************************************************** -->
	<!-- Template: issn-pub-type-check -->
	<!-- *********************************************************** -->
	<xsl:template name="issn-pub-type-check">
		<xsl:if test="@pub-type and not(@pub-type='ppub') and not(@pub-type='epub')">
			<xsl:call-template name="make-error">
				<xsl:with-param name="error-type"
					select="'pub-type attribute check'"/>
				<xsl:with-param name="description">
					<xsl:text>@pub-type may only be set to ppub or epub on element issn.</xsl:text>
				</xsl:with-param>
				<xsl:with-param name="tg-target" select="'tags.html#el-issn'"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>

   
   <!-- *********************************************************** -->
   <!-- Template: journal-id-check 
   
        If article has a journal-meta element, then:
        1) journal-id cannot be empty if it is present
        2) journal-id/@journal-id-type must be present, with values from:
           archive, aggregator, doi, index, issn, pmc, publisher-id, iso-abbrev, or nlm-ta
     -->
   <!-- *********************************************************** -->
   <xsl:template name="journal-id-check">
      <xsl:param name="context" select="."/> <!-- Will be journal-id -->

      <!-- If present, journal-id cannot be empty -->
      <xsl:if test="$context[not(normalize-space())]">
         <xsl:call-template name="make-error">
            <xsl:with-param name="error-type">journal-meta-check</xsl:with-param>
            <xsl:with-param name="description">
               <xsl:text>journal-id element cannot be empty</xsl:text>
            </xsl:with-param>
         </xsl:call-template>
      </xsl:if>
      
      <!-- journal id element must have journal-id-type attribute -->
      <xsl:if test="$context[not(@journal-id-type)]">
         <xsl:call-template name="make-error">
            <xsl:with-param name="error-type">journal-meta-check</xsl:with-param>
            <xsl:with-param name="description">
               <xsl:text>journal-id element must have a journal-id-type attribute</xsl:text>
            </xsl:with-param>
         </xsl:call-template>
      </xsl:if>
 
 	<xsl:variable name="ok-journal-id-type-values" select="concat( 
			'archive ',          
			'aggregator ',  
			'coden ',  
			'doi ',        
			'hwp ',     
			'index ',
			'iso-abbrev ',            
			'issn ',  
			'nlm-journal-id ',
			'nlm-ta ',
			'pmc ',  
			'pubmed-jr-id ',        
			'publisher-id ', 
			'sc',
			   '')"/>

			<xsl:variable name="jidt-ok">
			   <xsl:call-template name="is-in-list">
			      <xsl:with-param name="list"  select="$ok-journal-id-type-values"/>
			      <xsl:with-param name="token" select="$context/@journal-id-type"/>
			      <xsl:with-param name="case"  select="'1'"/>
			   </xsl:call-template>
			</xsl:variable>

        <xsl:if test="$jidt-ok != 1">
	        <xsl:call-template name="make-error">
            <xsl:with-param name="error-type">journal-meta-check</xsl:with-param>
            <xsl:with-param name="description">
               <xsl:text>journal-id-type attribute value is restricted to: 'archive', 'aggregator', 'coden', 'doi', 'hwp', 'index', 'iso-abbrev', 'issn', 'nlm-ta', 'pmc', 'publisher-id', 'sc'</xsl:text>
            </xsl:with-param>
         </xsl:call-template>
			</xsl:if>
   </xsl:template>
   

   <!-- *********************************************************** -->
   <!-- Template: journal-meta-check 
   
        If article has a journal-meta element, then:
        1) journal-title is required
        2) issn is required
     -->
   <!-- *********************************************************** -->
   <xsl:template name="journal-meta-check">
      <xsl:param name="context" select="."/> <!-- Will be journal-meta -->
      
      <!-- journal-title is required  in v1 and v1; journal-title-group is required in v3-->
        <xsl:choose>
            <!-- Scanning data does not require a journal-title -->
            <xsl:when test="//processing-instruction('properties')
			                   [contains(.,'scanned_data')] or ancestor::issue-admin"/>
            <xsl:otherwise>
            	<xsl:choose>
            		<xsl:when test="journal-title[normalize-space()] or journal-title-group/journal-title[normalize-space()]">
            			<!-- data is okay -->
            		</xsl:when>
            		<xsl:otherwise>
               			<xsl:call-template name="make-error">
               				<xsl:with-param name="error-type">journal-meta-check</xsl:with-param>
               				<xsl:with-param name="description">
               					<xsl:text>journal-title is required</xsl:text>
               				</xsl:with-param>
               				<xsl:with-param name="tg-target" select="'tags.html#el-jmeta'"/>
               			</xsl:call-template>
            		</xsl:otherwise>
            	</xsl:choose>
            </xsl:otherwise>
        </xsl:choose>

      <!-- Check whether issn is present: but only if this is
           a "domain" that requires an issn -->
		<xsl:choose>
			<xsl:when test="//processing-instruction('noissn')"/>
      <!--	<xsl:when test="contains($domains-no-issn, concat('|',/article/front/journal-meta/journal-id[@journal-id-type='pmc'],'|'))"/>  True if not listed in param -->
      <!--	<xsl:when test="contains($domains-no-issn, concat('|',//journal-meta/pmc-abbreviation,'|'))"/>  True if not listed in param: issue-admin.xsd doc --> 
		  <!-- manuscripts do not require issn -->
        <xsl:when test="$stream='manuscript' or contains(//processing-instruction('properties'),'manuscript')"/>
        <xsl:when test="$stream='rrn' "/>
		  <xsl:otherwise>
         	<!-- Check that issn is present -->
         	<xsl:if test="not(issn[normalize-space()]) and not(issn-l[normalize-space()])">
            	<xsl:call-template name="make-error">
	               <xsl:with-param name="error-type">journal-meta-check</xsl:with-param>
   	               <xsl:with-param name="description">
      	              <xsl:text>issn is required</xsl:text>
         		   </xsl:with-param>
						<xsl:with-param name="tg-target" select="'tags.html#el-jmeta'"/>
        		</xsl:call-template>
         	</xsl:if>
      	  </xsl:otherwise>
	    </xsl:choose>
      
   </xsl:template>

   <!-- *********************************************************** -->
   <!-- Template: journal-meta-issn-check 
   
       1) issn must follow form \d{4}-\d{3}(\d|X)
       2) issn must have a pub-type attribute
     -->
   <!-- *********************************************************** -->
   <xsl:template name="journal-meta-issn-check">
      <xsl:param name="context" select="."/> <!-- Will be issn -->
      
      <!-- Only run this test on issn inside journal-meta -->
      <xsl:if test="$context/ancestor::journal-meta
			    and not($stream='manuscript')">

         <!-- Check if form is correct -->
         <xsl:variable name="bad-form">
            <xsl:call-template name="issn-problem">
               <xsl:with-param name="issn" select="$context"/>
            </xsl:call-template>
         </xsl:variable>
         
         <xsl:if test="$bad-form = 'true'">
            <xsl:call-template name="make-error">
               <xsl:with-param name="error-type">journal-meta-check</xsl:with-param>
               <xsl:with-param name="description">
                  <xsl:text>issn does not have the correct form. Must be: \d{4}-\d{3}(\d|X)</xsl:text>
               </xsl:with-param>
							<xsl:with-param name="tg-target" select="'tags.html#el-issn'"/>
            </xsl:call-template>
         </xsl:if>

         <!-- Make sure has a pub-type attribute-->
         <xsl:if test="$context[not(@pub-type)]">
            <xsl:call-template name="make-error">
               <xsl:with-param name="error-type">journal-meta-check</xsl:with-param>
               <xsl:with-param name="description">
                  <xsl:text>issn must have a pub-type attribute</xsl:text>
               </xsl:with-param>
							<xsl:with-param name="tg-target" select="'tags.html#el-issn'"/>
            </xsl:call-template>
         </xsl:if>
      </xsl:if>
   </xsl:template> 
	
	
	<!-- *********************************************************** -->
	<!-- Template: kwd-group-check    
       1) should have more than 1 kwd; warn if on 1 and it contains commas
       	or semi-colons. Only concerned with <kwd>
     -->
	<!-- *********************************************************** -->	
	<xsl:template name="kwd-group-check">
		<xsl:if test="count(kwd)=1 and count(*)=1">
			<xsl:if test="contains(kwd, ',') or contains(kwd,';')">
				<xsl:call-template name="make-error">
					<xsl:with-param name="error-type">kwd-group-check</xsl:with-param>
					<xsl:with-param name="description">
						<xsl:text>kwd-group has only 1 kwd with punctuation; check that keywords are tagged correctly.</xsl:text>
					</xsl:with-param>
					<xsl:with-param name="class" select="'warning'"/>
				</xsl:call-template>
			</xsl:if>
		</xsl:if>
	</xsl:template>
	
	
	<!-- *********************************************************** -->
	<!-- Template: license-ext-link-content-check
		See PMC-15983
		Content of ext-link should 
			- match @xlink:href or
			- be @xlink:href withoutthe "http://" or "http://www" or "www" or
			- not be a URI at all		
	-->
	<!-- *********************************************************** -->
		<xsl:template name="license-ext-link-content-check">		
		<xsl:param name="context"/>
		<xsl:param name="str" select="normalize-space($context//text())"/>
		<xsl:choose>
			<xsl:when test="$context/@xlink:href=$str">
				<!-- attribute and content match, we're good -->
			</xsl:when>
			<xsl:when test="not(contains($str,'http')) and not(contains($str,'www'))">
				<!-- content doesn't appear to be URI, we're good -->
			</xsl:when>
			<xsl:when test="(contains($str,'http') or contains($str,'www')) and (string-length($str) - string-length(translate($str,' ','')) > 1)">
				<!-- content contains URI and multiple spaces; likely a sentence -->
			</xsl:when>
			<xsl:when test="starts-with($context/@xlink:href,'http://')">
				<xsl:choose>
					<xsl:when test="$str=substring-after($context/@xlink:href,'http://')">
						<!-- attribute and content almost match, we're good -->
					</xsl:when>
					<xsl:when test="$str=substring-after($context/@xlink:href,'http://www.')">
						<!-- attribute and content almost match, we're good -->
					</xsl:when>
					<xsl:when test="substring($str,string-length($str),1)='/' and $context/@xlink:href=substring($str,1,string-length($str)-1)">
						<!-- attribute and content almost match, we're good -->
					</xsl:when>
					<xsl:when test="substring(@xlink:href,string-length(@xlink:href),1)='/' and $str=substring(@xlink:href,1,string-length(@xlink:href)-1)">
						<!-- attribute and content almost match, we're good -->
					</xsl:when>
					<xsl:otherwise>
						<xsl:call-template name="make-error">
							<xsl:with-param name="error-type">license/ext-link check</xsl:with-param>
							<xsl:with-param name="description">
								<xsl:text>URIs in ext-link content and @xlink:href do not match</xsl:text>
							</xsl:with-param>
							<xsl:with-param name="tg-target" select="'tags.html#el-extlink'"/>
						</xsl:call-template>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="starts-with($context/@xlink:href,'www.')">
				<xsl:if test="$str=substring-after($context/@xlink:href,'www.')">
					<!-- attribute and content almost match, we're good -->
				</xsl:if>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="make-error">
					<xsl:with-param name="error-type">license/ext-link check</xsl:with-param>
					<xsl:with-param name="description">
						<xsl:text>URIs in ext-link content and @xlink:href do not match</xsl:text>
					</xsl:with-param>
					<xsl:with-param name="tg-target" select="'tags.html#el-extlink'"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
		
	</xsl:template>
	
	
	<!-- *********************************************************** -->
	<!-- Template: license-integrity-check
		See PMC-15983
		1) If license has @xlink:href, it should not have descendant ext-link
		2) If license has @xlink:href and ext-link, the xlink:href values must match
	-->
	<!-- *********************************************************** -->
	<xsl:template name="license-integrity-check">
		<xsl:param name="context"/>
		<xsl:if test="$context/@xlink:href[contains(.,'creativecommons.org/licenses')]">
			<xsl:choose>
				<xsl:when test="$context//ext-link[contains(@xlink:href,'creativecommons.org/licenses')]">
					<xsl:variable name="str" select="$context//ext-link/@xlink:href[contains(.,'creativecommons.org/licenses')]"/>
					<xsl:choose>
						<xsl:when test="$context/@xlink:href=$str">
							<!-- ext-link points to same uri as license, we're okay -->
						</xsl:when>
						<xsl:when test="translate($context/@xlink:href,'/','')=translate($str,'/','')">
							<!-- ext-link points to same uri as license (once slashes are removed), we're probably okay -->
						</xsl:when>
						<xsl:when test="starts-with($context/@xlink:href,'http://')">
							<xsl:choose>
								<xsl:when test="$str=substring-after($context/@xlink:href,'http://')">
									<!-- attribute and content almost match, we're good -->
								</xsl:when>
								<xsl:when test="$str=substring-after($context/@xlink:href,'http://www.')">
									<!-- attribute and content almost match, we're good -->
								</xsl:when>
								<xsl:when test="contains($str,'www.') and 
										(substring-after($str,'www.')=substring-after($context/@xlink:href,'www.') or
										substring-after($str,'www.')=substring-after($context/@xlink:href,'http://'))">
									<!-- CC license URIs work with either http://www. or http:// -->
									<xsl:message><xsl:value-of select="$str"/>|<xsl:value-of select="$context/@xlink:href"/></xsl:message>
								</xsl:when>
								<xsl:otherwise>
									<xsl:call-template name="make-error">
										<xsl:with-param name="error-type">license check</xsl:with-param>
										<xsl:with-param name="description">
											<xsl:text>Do not include different @xlink:href values on &lt;license&gt; and an &lt;ext-link&gt; descendant of &lt;license&gt;.</xsl:text>
										</xsl:with-param>								
										<xsl:with-param name="tg-target" select="'dobs.html#dob-license'"/>
									</xsl:call-template>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<xsl:when test="starts-with($context/@xlink:href,'www.')">
							<xsl:choose>
								<xsl:when test="$str=substring-after($context/@xlink:href,'www.')">
									<!-- attribute and content almost match, we're good -->
								</xsl:when>
								<xsl:when test="starts-with($str,'http://') and 
									substring-after($str,'http://')=substring-after($context/@xlink:href,'www.')">
									<!-- CC license URIs work with either http://www. or http:// -->
								</xsl:when>
								<xsl:otherwise>
									<xsl:call-template name="make-error">
										<xsl:with-param name="error-type">license check</xsl:with-param>
										<xsl:with-param name="description">
											<xsl:text>Do not include different @xlink:href values on &lt;license&gt; and an &lt;ext-link&gt; descendant of &lt;license&gt;.</xsl:text>
										</xsl:with-param>								
										<xsl:with-param name="tg-target" select="'dobs.html#dob-license'"/>
									</xsl:call-template>
								</xsl:otherwise>	
							</xsl:choose>
						</xsl:when>
						<xsl:otherwise>
							<xsl:call-template name="make-error">
								<xsl:with-param name="error-type">license check</xsl:with-param>
								<xsl:with-param name="description">
									<xsl:text>Do not include different @xlink:href values on &lt;license&gt; and an &lt;ext-link&gt; descendant of &lt;license&gt;.</xsl:text>
								</xsl:with-param>								
								<xsl:with-param name="tg-target" select="'dobs.html#dob-license'"/>
							</xsl:call-template>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:otherwise>
					<!-- no descendant ext-link, no problem -->
				</xsl:otherwise>
			</xsl:choose>			
		</xsl:if>
		<xsl:if test="count($context//ext-link) > 1">
			<xsl:choose>
				<xsl:when test="$context//ext-link[contains(@xlink:href,'creativecommons.org/licenses')]">
					<xsl:variable name="nodes" select="$context//ext-link[contains(@xlink:href,'creativecommons.org/licenses')]"/>					
					<xsl:if test="count($nodes) > 1">
						<xsl:call-template name="license-ext-link-recursion">
							<xsl:with-param name="nodes" select="$nodes"/>
						</xsl:call-template>
					</xsl:if>
				</xsl:when>
			</xsl:choose>
		</xsl:if>
	</xsl:template>
	
	<xsl:template name="license-ext-link-recursion">
		<xsl:param name="nodes"/>
		<xsl:variable name="one" select="substring-after($nodes[1]/@xlink:href,'licenses')"/>
		<xsl:variable name="two" select="substring-after($nodes[2]/@xlink:href,'licenses')"/>
		<xsl:variable name="onestr">
			<xsl:choose>
				<xsl:when test="contains($one,'legalcode')">
					<xsl:value-of select="translate(substring-before($one,'legalcode'),'/','')"/>
					</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="translate($one,'/','')"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
		<xsl:variable name="twostr">
			<xsl:choose>
				<xsl:when test="contains($two,'legalcode')">
					<xsl:value-of select="translate(substring-before($two,'legalcode'),'/','')"/>
					</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="translate($two,'/','')"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>

			
		<xsl:if test="$nodes[2]">
			<xsl:choose>
				<xsl:when test="$twostr != $onestr">  
					<xsl:call-template name="make-error">
						<xsl:with-param name="error-type">Creative Commons license check</xsl:with-param>
						<xsl:with-param name="description">License element must not contain different Creative Common license URIs.
						<xsl:value-of select="substring-after($nodes[1]/@xlink:href,'licenses')"/> != <xsl:value-of select="substring-after($nodes[2]/@xlink:href,'licenses')"/>
						<!-- $onestr="<xsl:value-of select="$onestr"/>"; $twostr="<xsl:value-of select="$twostr"/>"||$one="<xsl:value-of select="$one"/>"; $two="<xsl:value-of select="$two"/>-->
					</xsl:with-param>
					</xsl:call-template>
				</xsl:when>
				<xsl:otherwise>
					<xsl:call-template name="license-ext-link-recursion">
						<xsl:with-param name="nodes" select="$nodes[position() > 1]"/>
					</xsl:call-template>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:if>
	</xsl:template>
	
   

   <!-- *********************************************************** -->
   <!-- Template: list-item-content-check
        
        1) do not allow label
	    2) in books, do not allow boxed-text, table, fig, graphic
     -->
   <!-- *********************************************************** -->
   <xsl:template name="list-item-content-check">
      <xsl:param name="context" select="."/>
      
	  <!-- TEST 1 -->
      <xsl:if test="$context[@list-type!='simple']/label">
         <xsl:call-template name="make-error">
            <xsl:with-param name="error-type" select="'list-item checking'"/>
            <xsl:with-param name="description">
               <xsl:text>label should not be used inside list-item</xsl:text>
            </xsl:with-param>
				<xsl:with-param name="tg-target" select="'tags.html#el-litem'"/>
         </xsl:call-template>
      </xsl:if>
		
	  <!-- TEST 2 -->
      <!--<xsl:if test="$document-type='book' or $document-type='book-part'">
      <xsl:if test="descendant::boxed-text[not(@position='anchor')] |
           descendant::table-wrap[not(@position='anchor')] | 
	   descendant::fig[not(@position='anchor')]">	
         <xsl:call-template name="make-error">
            <xsl:with-param name="error-type" select="'list-item checking'"/>
            <xsl:with-param name="description">
               <xsl:text>&lt;list-item&gt; should not included boxed-text, figures, or tables. Use a simpler structure.</xsl:text>
            </xsl:with-param>
         </xsl:call-template>
      </xsl:if>
      </xsl:if>-->
   </xsl:template>
      

   <!-- *********************************************************** -->
   <!-- Template:  list-q-and-a-check 
   
        For all QandA-type lists, make sure that
        the list actually contains some paragraphs where
        the content-type is 'question' and/or 'answer'.
        If the list does not contain any questions or
        answers, then it probably shouldn't be tagged 
        as QandA.
        
        Not attempting to enforce any other form at
        this time because the use of a list for 
        questions and answers is largely presentational.
	 -->
   <!-- *********************************************************** -->
   <xsl:template name="list-q-and-a-check">
      <xsl:param name="context" select="."/>
      
      <xsl:if test="$context[@list-type = 'QandA']">
         <xsl:choose>
            <xsl:when test="$context//p
			   [@content-type='question' or @content-type='answer']">
               <!-- No problem -->
            </xsl:when>
            
            <xsl:otherwise>
               <xsl:call-template name="make-error">
                  <xsl:with-param name="error-type">q and answer list check</xsl:with-param>
                  <xsl:with-param name="description">
                     <xsl:text>list with list-content set to 'QandA' should contain paragraphs with the content-type attribute set to 'question' or 'answer'</xsl:text>
                  </xsl:with-param>
							<xsl:with-param name="tg-target" select="'dobs.html#dob-qanda'"/>
               </xsl:call-template>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:if>
   </xsl:template> 
   
   <!-- *********************************************************** -->
   <!-- Template: list-type-check
        
        List type attribute is restricted to the enumerated values.
     -->
   <!-- *********************************************************** -->
   <xsl:template name="list-type-check">
      <xsl:param name="context" select="."/>
      
	  <xsl:variable name="ok-list-types" select="concat(
            'order ',
            'bullet ',
            'alpha-lower ',
            'alpha-upper ',
            'roman-lower ',
            'roman-upper ',
            'simple ',
            'QandA ',
	        '')"/>
	  <xsl:variable name="is-ok-list-type">
	     <xsl:call-template name="is-in-list">
		    <xsl:with-param name="list"  select="$ok-list-types"/>
		    <xsl:with-param name="token" select="$context/@list-type"/>
		    <xsl:with-param name="case"  select="'1'"/>
		 </xsl:call-template>
	  </xsl:variable>

      <xsl:choose>
         <xsl:when test="$context[not(@list-type)]">
            <!-- ignore -->
         </xsl:when>
         
         <!-- This list has a list-type: check the values -->
         <xsl:when test="$is-ok-list-type != '1'">
               <xsl:call-template name="make-error">
                  <xsl:with-param name="error-type" select="'list-type check'"/>
                  <xsl:with-param name="description" select="concat(
                     'list-type attribute restricted to [', $ok-list-types,
					 '], not [', $context/@list-type, '].')"/>
							<xsl:with-param name="tg-target" select="'tags.html#el-list'"/>
               </xsl:call-template>
         </xsl:when>
      </xsl:choose>
   </xsl:template> 
   

   <!-- *********************************************************** -->
   <!-- Template: list-title-check
        
        List title should not be tagged in book content
	 -->
   <!-- *********************************************************** -->
   <xsl:template name="list-title-check">
      <xsl:param name="context" select="."/>
      
		<xsl:if test="title">
			<xsl:call-template name="make-error">
				<xsl:with-param name="error-type" select="'list title check'"/>
				<xsl:with-param name="description">
					<xsl:text>Lists may not have titles in book content.</xsl:text>
                  </xsl:with-param>
               </xsl:call-template>
         </xsl:if>
   </xsl:template> 

   
   <!-- *********************************************************** -->
   <!-- Template: lpage-check 
   
        If a fpage is tagged, then there should also be
        a lpage. This is confined to article-meta content.
     -->
   <!-- *********************************************************** -->
   <xsl:template name="lpage-check">
      <xsl:param name="context" select="."/> <!-- will be fpage -->
      
      <xsl:if test="$context/parent::article-meta">
         <xsl:choose>
            <xsl:when test="$context/following-sibling::lpage">
               <!-- This is correct -->
            </xsl:when>            
            <xsl:otherwise>
               <xsl:call-template name="make-error">
                  <xsl:with-param name="error-type" select="'lpage checking'"/>
                  <xsl:with-param name="description">
                     <xsl:text>lpage should follow fpage missing</xsl:text>
                  </xsl:with-param>
               </xsl:call-template>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:if>
   </xsl:template>


   <!-- *********************************************************** -->
   <!-- Template: make-correct-title 

        Make the title for a disp-objects section, based on the number of 
        figures and tables. This can then be compared 
        to the actual title to see if it is correct.  
     -->
   <!-- *********************************************************** -->
   <xsl:template name="make-correct-title">
      <xsl:param name="figures"/>
      <xsl:param name="tables"/>
      
      <xsl:choose>
         <xsl:when test="$figures=1 and $tables=0">
            <xsl:text>Figure</xsl:text>
         </xsl:when>
         
         <xsl:when test="$figures &gt; 1 and $tables=0">
            <xsl:text>Figures</xsl:text>
         </xsl:when>
         
         <xsl:when test="$figures=0 and $tables=1">
            <xsl:text>Table</xsl:text>
         </xsl:when>
         
         <xsl:when test="$figures=0 and $tables &gt; 1">
            <xsl:text>Tables</xsl:text>
         </xsl:when>
         
         <xsl:when test="$figures &gt; 1 and $tables &gt; 1">
            <xsl:text>Figures and Tables</xsl:text>
         </xsl:when>

         <xsl:when test="$figures=1 and $tables &gt; 1">
            <xsl:text>Figure and Tables</xsl:text>
         </xsl:when>

         <xsl:when test="$figures &gt; 1 and $tables=1">
            <xsl:text>Figures and Table</xsl:text>
         </xsl:when>

         <xsl:when test="$figures=1 and $tables=1">
            <xsl:text>Figure and Table</xsl:text>
         </xsl:when>
         
         <xsl:otherwise>
            <xsl:text>INVALID CONTENT</xsl:text>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>


   <!-- *********************************************************** -->
   <!-- Template: mathml-depricate-atts-chk 
      
      Make sure that mathml elements do not use deprecated attributes
      as defined here http://www.w3.org/TR/2003/REC-MathML2-20031021/chapter3.html#presm.deprecatt
      http://jira/browse/PMC-8144
      
   -->
   <!-- *********************************************************** -->
   <xsl:template name="mathml-depricate-atts-chk">
      <xsl:param name="context" select="."/> <!-- will be mml:math//* -->

         <xsl:choose>
            <xsl:when test="$style='manuscript'">
               <xsl:if test="(contains(translate(@fontsize, '0123456789', '9999999999'),'9') or @fontsize='inherited')
                  or (@fontweight='normal' or @fontweight='bold' or @fontweight='inherited')
                  or (self::mi and @fontstyle='italic')
                  or (not(self::mi) and (@fontstyle='italic' or @fontstyle='normal')) or (@color)">
                  <xsl:call-template name="make-error">
                     <xsl:with-param name="error-type" select="'mathml deprecated attribute(s)'"/>
                     <xsl:with-param name="description">
                        <xsl:text>Use of deprecated mml:math attribute fontsize, fontweight, fontstyle, fontfamily, or color</xsl:text>
                     </xsl:with-param>
                     <xsl:with-param name="class" select="'error'"/>
                     <xsl:with-param name="tglink" select="'http://www.ncbi.nlm.nih.gov/pmc/pmcdoc/tagging-guidelines/manuscript/tags.html#el-math'"/>
                  </xsl:call-template>
               </xsl:if>
            </xsl:when>
            <xsl:when test="$style='article'">
               <xsl:if test="(contains(translate(@fontsize, '0123456789', '9999999999'),'9') or @fontsize='inherited')
                  or (@fontweight='normal' or @fontweight='bold' or @fontweight='inherited')
                  or (self::mi and @fontstyle='italic')
                  or (not(self::mi) and (@fontstyle='italic' or @fontstyle='normal')) or (@color)">
                  <xsl:call-template name="make-error">
                     <xsl:with-param name="error-type" select="'mathml deprecated attribute(s)'"/>
                     <xsl:with-param name="description">
                        <xsl:text>Use of deprecated mml:math attribute fontsize, fontweight, fontstyle, fontfamily, or color</xsl:text>
                     </xsl:with-param>
                     <xsl:with-param name="class" select="'warning'"/>
                     <xsl:with-param name="tglink" select="'http://www.ncbi.nlm.nih.gov/pmc/pmcdoc/tagging-guidelines/article/tags.html#el-math'"/>
                  </xsl:call-template>
               </xsl:if>
            </xsl:when>
         </xsl:choose>
   </xsl:template>

   <!-- *********************************************************** -->
   <!-- Template: mathml-nihms-exclusions 
      
      NIHMS requested that <mml:mlabeledtr> and <mml:malignmark/> be depricated for their system due to consistent misuse.
      http://jira/browse/PMC-8144
      
   -->
   <!-- *********************************************************** -->
   <xsl:template name="mathml-nihms-specific">
      <xsl:param name="context" select="."/> <!-- will be mml:math//* -->
      <xsl:if test="$style='manuscript'
         and *[local-name()='mlabeledtr' or local-name()='malignmark']">
         <xsl:call-template name="make-error">
            <xsl:with-param name="error-type" select="'mathml deprecated element(s)'"/>
            <xsl:with-param name="description">
               <xsl:text>Found mml:mlabeledtr or mml:malignmark</xsl:text>
            </xsl:with-param>
            <xsl:with-param name="class" select="'error'"/>
            <xsl:with-param name="tglink" select="'http://www.ncbi.nlm.nih.gov/pmc/pmcdoc/tagging-guidelines/manuscript/tags.html#el-math'"/>
         </xsl:call-template>
      </xsl:if>
   </xsl:template>


   <!-- *********************************************************** -->
   <!-- Template: mathml-id-check 
        
        Make sure that mathml elements have an id
        attribute
	 -->
   <!-- *********************************************************** -->
   <xsl:template name="mathml-id-check">
      <xsl:param name="context" select="."/> <!-- will be mml:math -->
      
      <!-- Report an error -->
      <xsl:if test="not($context/@id)">
         <xsl:call-template name="make-error">
            <xsl:with-param name="error-type" select="'mathml id check'"/>
            <xsl:with-param name="description">
               <xsl:text>mml:math elements must have an id attribute</xsl:text>
            </xsl:with-param>
         </xsl:call-template>
      </xsl:if>
   </xsl:template> 
   

   <!-- *********************************************************** -->
   <!-- Template: mathml-repeated-element-check 
        
        Make sure that mathml elements have an id
        attribute -->
   <!-- *********************************************************** -->
	<xsl:template name="mathml-repeated-element-check">
		<xsl:param name="context" select="."/> 
		<xsl:param name="report-level" select="'error'"/>
		<xsl:variable name="mv">
			<xsl:choose>
				<xsl:when test="@mathvariant">
					<xsl:value-of select="@mathvariant"/>
					</xsl:when>
				<xsl:otherwise>
					<xsl:text>none</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
		<xsl:variable name="fs1mv">
			<xsl:choose>
				<xsl:when test="normalize-space(following-sibling::node()[1]/@mathvariant)">
					<xsl:value-of select="normalize-space(following-sibling::node()[1]/@mathvariant)"/>
					</xsl:when>
				<xsl:otherwise>
					<xsl:text>none</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
		<xsl:variable name="fs2mv">
			<xsl:choose>
				<xsl:when test="normalize-space(following-sibling::node()[2]/@mathvariant)">
					<xsl:value-of select="normalize-space(following-sibling::node()[2]/@mathvariant)"/>
					</xsl:when>
				<xsl:otherwise>
					<xsl:text>none</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
		
		<xsl:choose>
			<!-- special processing for mn -->
			<xsl:when test="name($context)='mml:mn' and name(following-sibling::node()[1])='' and name($context)=name(following-sibling::node()[2])">
				<xsl:choose>
					<xsl:when test="$mv!=$fs2mv"/>
					<xsl:when test="parent::mml:msubsup or
										 parent::mml:msub or
										 parent::mml:msup or
										 parent::mml:mfrac or 
										 parent::mml:munderover or
					                                         parent::mml:mroot or
										 parent::mml:mmultiscripts or 
										 parent::mml:mfenced[@separators]"/>
					<xsl:otherwise>
					<xsl:call-template name="make-error">
						<xsl:with-param name="error-type" select="'mathml element check'"/>
						<xsl:with-param name="class" select="$report-level"/>
						<xsl:with-param name="description">
							<xsl:value-of select="name($context)"/>
							<xsl:text> should not follow itself. This is meaningless tagging.</xsl:text>
						</xsl:with-param>
					</xsl:call-template>
				</xsl:otherwise>
				</xsl:choose>
				</xsl:when>
			<xsl:when test="name($context)=name(following-sibling::node()[1]) and name($context)='mml:mn'">
				<xsl:choose>
					<xsl:when test="$mv!=$fs1mv"/>
					<xsl:when test="parent::mml:msubsup or
										 parent::mml:msub or
										 parent::mml:msup or
										 parent::mml:mfrac or 
										 parent::mml:munderover or
					                parent::mml:mroot or parent::mml:mmultiscripts or
										 parent::mml:mfenced[@separators]"/>
					<xsl:otherwise>
					<xsl:call-template name="make-error">
						<xsl:with-param name="error-type" select="'mathml element check'"/>
						<xsl:with-param name="class" select="$report-level"/>
						<xsl:with-param name="description">
							<xsl:value-of select="name($context)"/>
							<xsl:text> should not follow itself. This is meaningless tagging.</xsl:text>
						</xsl:with-param>
					</xsl:call-template>
				</xsl:otherwise>
				</xsl:choose>
				</xsl:when>
				
			<!-- elements followed by whitespace nodes followed by same elements pass,
				but should not, check following node 2 -->
			<xsl:when test="name(following-sibling::node()[1])=''">
				<xsl:if test="name($context)=name(following-sibling::node()[2])
					and not(parent::mml:msubsup)
					and not(parent::mml:msub) and not(parent::mml:msup)
					and not(parent::mml:mfrac) and not(parent::mml:munderover)
					and not(parent::mml:mroot) and not(parent::mml:mfenced[@separators])">
					<xsl:call-template name="make-error">
						<xsl:with-param name="error-type" select="'mathml element check'"/>
						<xsl:with-param name="class" select="$report-level"/>
						<xsl:with-param name="description">
							<xsl:value-of select="name($context)"/>
							<xsl:text> should not follow itself. This is meaningless tagging.</xsl:text>
						</xsl:with-param>
					</xsl:call-template>
				</xsl:if>
			</xsl:when>
			<xsl:otherwise>
				<xsl:if test="name($context)=name(following-sibling::node()[1])
					and not(parent::mml:msubsup)
					and not(parent::mml:msub) and not(parent::mml:msup)
					and not(parent::mml:mfrac) and not(parent::mml:munderover)
					and not(parent::mml:mroot) and not(parent::mml:mfenced[@separators])">
					<xsl:call-template name="make-error">
						<xsl:with-param name="error-type" select="'mathml element check'"/>
						<xsl:with-param name="class" select="$report-level"/>
						<xsl:with-param name="description">
							<xsl:value-of select="name($context)"/>
							<xsl:text>  should not follow itself. This is meaningless tagging.</xsl:text>
						</xsl:with-param>
					</xsl:call-template>
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template> 


   <!-- *********************************************************** -->
   <!-- Template: mathml-top-level-el-check 
      
      Make sure that prescripts or none do not exist at top level
      
   -->
   <!-- *********************************************************** -->
   <xsl:template name="mathml-top-level-el-check">
      <xsl:if test="*[local-name()='prescripts' or local-name()='none']">
         <xsl:call-template name="make-error">
            <xsl:with-param name="error-type" select="'mathml top level element check'"/>
            <xsl:with-param name="description">
               <xsl:text>mathml elements prescripts and none are not allowed as children of the math element</xsl:text>
            </xsl:with-param>
         </xsl:call-template>
      </xsl:if>
		
		
		<!-- test for a single child of mml:math called mml:mrow. Error in manuscript. otherwise, warning 
		<xsl:if test="count(*)=1 and local-name(*)='mrow'">
         <xsl:call-template name="make-error">
            <xsl:with-param name="error-type" select="'mathml top level element check'"/>
            <xsl:with-param name="description">
					<xsl:choose>
						<xsl:when test="$stream='manuscript'">
               		<xsl:text>mathml must not contain only a single &lt;mml:mrow&gt; child.</xsl:text>
							</xsl:when>
						<xsl:otherwise>
               		<xsl:text>mathml should not contain only a single &lt;mml:mrow&gt; child.</xsl:text>
							</xsl:otherwise>
							</xsl:choose>
            </xsl:with-param>
             <xsl:with-param name="class" >
					<xsl:choose>
						<xsl:when test="$stream='manuscript'">
               		<xsl:text>error</xsl:text>
							</xsl:when>
						<xsl:otherwise>
               		<xsl:text>warning</xsl:text>
							</xsl:otherwise>
							</xsl:choose>
            </xsl:with-param>
         </xsl:call-template>
			</xsl:if>-->
		
   </xsl:template>


   <!-- *********************************************************** -->
   <!-- Template: mathml-mrow-content-check 
      
      1. mrow should not contain just mrow(s)
		2. mrow should have more than one child.
		
		These will be errors in manuscripts and warnings everywhere else. 
      
   -->
   <!-- *********************************************************** -->
   <xsl:template name="mathml-mrow-content-check">
		<xsl:variable name="errlevel">
			<xsl:choose>
				<xsl:when test="$stream='manuscript'">error</xsl:when>
				<xsl:otherwise>warning</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			
		<!-- test for single child of mrow -->
		<xsl:if test="count(*)=1">
         <xsl:call-template name="make-error">
            <xsl:with-param name="error-type" select="'mathml mrow element check'"/>
            <xsl:with-param name="description">
               <xsl:text>&lt;mml:mrow&gt; should not be used to wrap a single child element.</xsl:text>
            	</xsl:with-param>
				<xsl:with-param name="class">
					<xsl:value-of select="$errlevel"/>
					</xsl:with-param>
         </xsl:call-template>
			</xsl:if>	


		<!-- test for mrow only having mrow children -->
		<xsl:if test="not(child::*[not(local-name()='mrow')])">
         <xsl:call-template name="make-error">
            <xsl:with-param name="error-type" select="'mathml mrow element check'"/>
            <xsl:with-param name="description">
               <xsl:text>&lt;mml:mrow&gt; should not be used to wrap only child &lt;mml:mrow&gt; elements.</xsl:text>
            	</xsl:with-param>
				<xsl:with-param name="class">
					<xsl:value-of select="$errlevel"/>
					</xsl:with-param>
         </xsl:call-template>
			</xsl:if>	



		</xsl:template>

   <!-- *********************************************************** -->
   <!-- Template: mathml-parent-el-check 
      
      Make sure that context element exists only within specified parent element
      
   -->
   <!-- *********************************************************** -->
   <xsl:template name="mathml-parent-el-check">
      <xsl:param name="expected-parent"/>
      
      <xsl:if test="not(parent::*[local-name()=$expected-parent])">
         <xsl:call-template name="make-error">
            <xsl:with-param name="error-type" select="'mathml parent element check'"/>
            <xsl:with-param name="description">
               <xsl:text>mathml element </xsl:text>
               <xsl:value-of select="local-name(.)"/>
               <xsl:text> must be a child of the </xsl:text>
               <xsl:value-of select="$expected-parent"/>
               <xsl:text> element</xsl:text>
            </xsl:with-param>
         </xsl:call-template>
      </xsl:if>
   </xsl:template>



   <!-- *********************************************************** -->
   <!-- Template: mathml-subsup-fence-check 
      
      Make sure that msub|msup|msubsup
   -->
   <!-- *********************************************************** -->
   <xsl:template name="mathml-subsup-fence-check">
      <!-- Report an error -->
      <xsl:if test="translate(normalize-space(*[1]), ']})&#x03009;&#x0232A;&#x027E9;', ']]]]]]') = ']'">
         <xsl:call-template name="make-error">
            <xsl:with-param name="error-type" select="'mathml closing fence nesting check'"/>
            <xsl:with-param name="description">
               <xsl:text>mml:msub mml:msup mml:msubsup elements must wrap the entire expression they affect.</xsl:text>
            </xsl:with-param>
         </xsl:call-template>
      </xsl:if>
   </xsl:template> 
   
   <!-- *********************************************************** -->
   <!-- Template: mml-child-count-check 
      
      Enforce MML 2.0 strict rules for child element counts
   -->
   <!-- *********************************************************** -->
   <xsl:template name="mml-child-count-check">
      <xsl:param name="name"/>
      <xsl:param name="child-count"/>
      <xsl:if test="count(./*) != $child-count">
         <xsl:call-template name="make-error">
            <xsl:with-param name="error-type" select="'mathml element child count check'"/>
            <xsl:with-param name="description">
               <xsl:text>mathml element </xsl:text>
               <xsl:value-of select="$name"/>
               <xsl:text> must have </xsl:text>
               <xsl:value-of select="$child-count"/>
               <xsl:text> child elements.</xsl:text>
            </xsl:with-param>
         </xsl:call-template>
      </xsl:if>
   </xsl:template>

   <!-- *********************************************************** -->
   <!-- Template: mml-attr-value-check 
      
      Enforce MML 2.0 strict rules for math attributes
   -->
   <!-- *********************************************************** -->
   <xsl:template name="mml-attr-value-check">
      <xsl:param name="element-name"/>
      <xsl:param name="attr-name"/>
      <xsl:param name="attr-value"/>
      <xsl:param name="attr-enumerated-values"/>
      <xsl:param name="mult-values"/>
      
      <xsl:variable name="attr-value-acceptable">
         <xsl:choose>
            <xsl:when test="$mult-values = 1
               and contains($attr-value, ' ')">
               <xsl:variable name="mult-values-valid">
                  <xsl:call-template name="iterate-pipe-str">
                     <xsl:with-param name="test-str" select="translate(normalize-space($attr-value), ' ', '|')"/>
                     <xsl:with-param name="accepted-values" select="$attr-enumerated-values"/>
                  </xsl:call-template>
               </xsl:variable>
               <xsl:if test="contains($mult-values-valid, '0')">no</xsl:if>
            </xsl:when>

            <xsl:when test="$mult-values = 0
               and (not(contains($attr-enumerated-values, $attr-value))
               or contains($attr-value, ' '))">no</xsl:when>
            <xsl:when test="$mult-values = 1
               and not(contains($attr-value, ' '))
               and not(contains($attr-enumerated-values, $attr-value))">no</xsl:when>
         </xsl:choose>
      </xsl:variable>
      
      <xsl:if test="$attr-value-acceptable = 'no'">
         <xsl:call-template name="make-error">
            <xsl:with-param name="error-type" select="'mathml attribute value check'"/>
            <xsl:with-param name="description">
               <xsl:text>mathml element </xsl:text>
               <xsl:value-of select="$element-name"/>
               <xsl:text>/@</xsl:text>
               <xsl:value-of select="$attr-name"/>
               <xsl:text> may contain only the following values </xsl:text>
               <xsl:value-of select="$attr-enumerated-values"/>
               <xsl:text> not: </xsl:text>
               <xsl:value-of select="translate(normalize-space($attr-value), ' ', '|')"/>
            </xsl:with-param>
         </xsl:call-template>
      </xsl:if>
   </xsl:template>

<xsl:template name="iterate-pipe-str">
   <xsl:param name="test-str"/>
   <xsl:param name="accepted-values"/>
   <xsl:param name="result"/>
   <xsl:variable name="first-value">
      <xsl:value-of select="substring-before(substring-after($test-str, '|'), '|')"/>
   </xsl:variable>
<!--   <xsl:message>
      <xsl:text>&#xA;#########DEBUG#########&#xA;</xsl:text>
      <xsl:text>iterate-pipe-str: </xsl:text>
      <xsl:value-of select="$test-str"/>
      <xsl:text>&#xA;#########DEBUG#########&#xA;</xsl:text>
   </xsl:message>-->
   
   
   <xsl:choose>
      <xsl:when test="$first-value = ''">
         <xsl:value-of select="$result"/>            
      </xsl:when>
      <xsl:when test="contains($accepted-values, $first-value)">
<!--         <xsl:message>
            <xsl:text>&#xA;#########DEBUG#########&#xA;</xsl:text>
            <xsl:text>ACCEPTABLE: </xsl:text>
            <xsl:value-of select="$first-value"/>
            <xsl:text>&#xA;#########DEBUG#########&#xA;</xsl:text>
         </xsl:message>-->
         <xsl:call-template name="iterate-pipe-str">
            <xsl:with-param name="test-str" select="substring-after($test-str, concat('|', $first-value))"/>
            <xsl:with-param name="accepted-values" select="$accepted-values"/>
            <xsl:with-param name="result" select="$result"/>
         </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
<!--         <xsl:message>
            <xsl:text>&#xA;#########DEBUG#########&#xA;</xsl:text>
            <xsl:text>UNACCEPTABLE: </xsl:text>
            <xsl:value-of select="$first-value"/>
            <xsl:text>&#xA;#########DEBUG#########&#xA;</xsl:text>
         </xsl:message>-->
         <xsl:call-template name="iterate-pipe-str">
            <xsl:with-param name="test-str" select="substring-after($test-str, concat('|', $first-value, '|'))"/>
            <xsl:with-param name="accepted-values" select="$accepted-values"/>
            <xsl:with-param name="result" select="concat($result, 0)"/>
         </xsl:call-template>
      </xsl:otherwise>
   </xsl:choose>
   
   
</xsl:template>

   <!-- *********************************************************** -->
   <!-- Template: mathml-desc-text-check 
      
      Make sure descendent::text() exists, otherwise mathml is empty
   -->
   <!-- *********************************************************** -->
   <xsl:template name="mathml-desc-text-check">
      <xsl:choose>
         <xsl:when test=".//node()[normalize-space(self::text())]"/>
         <xsl:otherwise>
            <xsl:call-template name="make-error">
               <xsl:with-param name="error-type">empty math check</xsl:with-param>
               <xsl:with-param name="description">
                  <xsl:value-of select="local-name(.)"/>
                  <xsl:text> must have a non-whitespace descendant-or-self text node</xsl:text>
               </xsl:with-param>
            </xsl:call-template>
         </xsl:otherwise>            
      </xsl:choose>
   </xsl:template>
   

   <!-- *********************************************************** -->
   <!-- Template: month-check 
   
        Outside of citation elements, make sure that month 
        elements only contain an integer value 
        between 1 and 12 inclusive. -->
   <!-- *********************************************************** -->
   <xsl:template name="month-check">
      <xsl:param name="context" select="."/>
      
   	<xsl:choose>
   		<xsl:when test="$context/ancestor::citation
   			or $context/ancestor::nlm-citation
   			or $context/ancestor::mixed-citation
   			or $context/ancestor::element-citation
   			or $context/ancestor::product">
      		<!-- Don't test these except for numeric test in manuscripts -->
				<xsl:if test="$stream='manuscript' and number($context) &gt; 12">
               <xsl:call-template name="make-error">
                  <xsl:with-param name="error-type" select="'month check'"/>
                  <xsl:with-param name="description">
                     <xsl:text>month as a number should have a value between 1 and 12, inclusive.</xsl:text>
                  </xsl:with-param>
						<xsl:with-param name="tg-target" select="'tags.html#el-month'"/>
               </xsl:call-template>
					</xsl:if>
      	</xsl:when>
      	
         <xsl:otherwise>
            <!-- Check the content by calling a template -->
            <xsl:variable name="is-valid-month">
               <xsl:call-template name="is-month">
                  <xsl:with-param name="input" select="string($context)"/>
               </xsl:call-template>
            </xsl:variable>
            
            <xsl:if test="$is-valid-month = 'false'">
               <xsl:call-template name="make-error">
                  <xsl:with-param name="error-type" select="'month check'"/>
                  <xsl:with-param name="description">
                     <xsl:text>month element should contain a numeric value between 1 and 12, inclusive</xsl:text>
                  </xsl:with-param>
						<xsl:with-param name="tg-target" select="'tags.html#el-month'"/>
               </xsl:call-template>
            </xsl:if>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template> 
	
	<!-- *********************************************************** -->
	<!-- Template: ms-whitespace-check
		In manuscript stream, elements (called from article-id) must not 
		have extra whitespace in content.
		-->
	<!-- *********************************************************** -->
	<xsl:template name="ms-whitespace-check">
		<xsl:variable name="content" select="."/>
		<xsl:variable name="clean-content" select="normalize-space()"/>
      <xsl:if test="$content != $clean-content">
          <xsl:call-template name="make-error">
             <xsl:with-param name="error-type" select="'manuscript whitespace check'"/>
             <xsl:with-param name="description">
                <xsl:text>Manuscript has extra whitespace characters in mixed content elements.</xsl:text>
                </xsl:with-param>
             </xsl:call-template>
         </xsl:if>
		
		</xsl:template>


	
	<!-- *********************************************************** -->
	<!-- Template: name-alternatives-content-check
		1) Must have more than 1 child
		2) Children must carry either @xml:lang or @specific-use
		3) If children specify @xml:lang, exactly 1 must be the same as /article 
			and all the values should be unique
		4) If any child specifies @specific-use, all must
			and all the values should be different
		-->
	<!-- *********************************************************** -->
	<xsl:template name="name-alternatives-content-check">
		<xsl:param name="context"/>
		<!-- 1 -->
		<xsl:call-template name="alternatives-child-count">
			<xsl:with-param name="context" select="."/>
		</xsl:call-template>
		
		<!-- 2 -->
		<xsl:if test="count($context/name[not(@content-type='index')]) > 1">
			<xsl:if test="not($context/name[not(@content-type='index')][@xml:lang]) 
					and not($context/name[not(@content-type='index')][@specific-use])">
				<xsl:call-template name="make-error">
					<xsl:with-param name="error-type">
						<xsl:text>name-alternatives check</xsl:text>
					</xsl:with-param>
					<xsl:with-param name="description">
						<xsl:text>Elements in name-alternatives must be distinguised by either @xml:lang or @specific-use.</xsl:text>
					</xsl:with-param>				
					<xsl:with-param name="tg-target" select="'tags.html#el-name-alternatives'"/>
				</xsl:call-template>
			</xsl:if>
			
			<!-- 3 -->
			<xsl:if test="$context/name[@xml:lang]">			
				<xsl:call-template name="alternatives-xml-lang-check">
					<xsl:with-param name="context" select="'name-alternatives'"/>
					<xsl:with-param name="nodes" select="$context/name[not(@content-type='index')]"/>
				</xsl:call-template>
			</xsl:if>
			
			<!-- 4 -->
			<xsl:if test="$context/name[@specific-use]">
				<xsl:call-template name="alternatives-specific-use-check">
					<xsl:with-param name="context" select="'name-alternatives'"/>
					<xsl:with-param name="nodes" select="$context/name[not(@content-type='index')]"/>
				</xsl:call-template>			
			</xsl:if>
		</xsl:if>
	</xsl:template>
	
	
	<!-- *********************************************************** -->
	<!-- Template: name-content-check 
			If only given-name, @name-style must be 'given-only'
	-->
	<!-- *********************************************************** -->
	<xsl:template name="name-content-check">
		<xsl:param name="context"/>
		<xsl:if test="not($context/surname) and not($context/@name-style='given-only')">
			<xsl:call-template name="make-error">
				<xsl:with-param name="error-type">
					<xsl:text>name check</xsl:text>
				</xsl:with-param>
				<xsl:with-param name="description">
					<xsl:text>When name only contains given-names, it must specify @name-style="given-only".</xsl:text>
				</xsl:with-param>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>


   <!-- *********************************************************** -->
   <!-- Template: named-content-type-check  
        Checks values of @content-type on <named-content> for books
     -->
   <!-- *********************************************************** -->
	<xsl:template name="named-content-type-check">
		<xsl:param name="context" select="."/>
	   
	   <!--The values figlistContribs and omitted-link are temporary-->

        <xsl:variable name="ok-types">
		   <!--<xsl:value-of select="concat(
		      'chapter-subtitle ',
		      'studies teaser brand_name ',
		      'figlistContribs omitted-link ',
		     'light-blue light-pink light-yellow light-green light-orange ',
		     'consensus light-grey pageobject highlight ',
		     'intro-subsect-header ',
			  'ncbi-app ncbi-app-a ncbi-arg-a ncbi-ccode ncbi-cgi ncbi-class ',
			  'ncbi-cmd ncbi-cmd-sm ncbi-code ncbi-code-sm ncbi-compiler ',
			  'ncbi-conf-flag ncbi-conf-var ncbi-config ncbi-cvs-date ',
			  'ncbi-cvs-path ncbi-cvs-rev ncbi-dir ncbi-env ncbi-file ',
			  'ncbi-func ncbi-interface ncbi-keyword ncbi-lib ncbi-macro ',
			  'ncbi-make-flag ncbi-make-var ncbi-menu ncbi-monospace ncbi-note ',
			  'ncbi-os ncbi-output ncbi-path ncbi-platform ncbi-proj ncbi-reg ',
			  'ncbi-reg-var ncbi-script ncbi-script-a ncbi-term ncbi-type ',
			  'ncbi-url ncbi-util ncbi-value ncbi-var ',
			  '')"/>-->          
           <xsl:value-of select="concat(
	      'label ',
	      'created-date updaterev-date p ',
	      'created-date2 updated-date2 revised-date2 ',
	      'part-history tocContribs alt-title ',
	       'tocPubDate tocPubName tocPubLoc tocPubInfo ',
              'chapter-subtitle subtitle st-sep ',
              'studies teaser drug_brandname drug_genericname drug_synonymname ',
              'light-blue light-pink light-yellow light-green light-orange ',
	      'blue red yellow green orange pink ',
              'consensus light-grey pageobject highlight ',
              'intro-subsect-header ',
              'ncbi-app ncbi-class ncbi-cmd ncbi-code ',
              'ncbi-func ncbi-lib ncbi-macro ncbi-monospace ',
              'ncbi-path ncbi-type ncbi-var ',
	      'signature ',
	      'award-recipient ',
	      'synonym related_terms ',
	      'margin-note ', 
	      'phonetic consumer-route ',
	      'highlight-1 highlight-2 highlight-3 highlight-4 ',
	      'multi-link multi-link-term ', 
              '')"/>
	      
		<!--ML: Removed the following unused types from list: 
		brand_name figlistContribs omitted-link alt-name 
		sup sub xref surname given-names name -->
	           <!-- Add book-specific types when doing a book -->
		   <!--xsl:if test="$document-type='book' or $document-type='book-part'">
   	   	      <xsl:value-of select="concat(
			  ' tocContribs signature xref sup sub name surname given-names ',
			  '')"/>
		   </xsl:if-->
		</xsl:variable>

		<!-- Is the current type in the list of known types? -->
		<xsl:variable name="is-ok">
		   <xsl:call-template name="is-in-list">
		      <xsl:with-param name="list"  select="$ok-types"/>
		      <xsl:with-param name="token" select="$context/@content-type"/>
		      <xsl:with-param name="case"  select="'1'"/>
		   </xsl:call-template>
		</xsl:variable>

		<xsl:if test="$is-ok != '1'">
			<xsl:call-template name="make-error">
				<xsl:with-param name="error-type"
				   select="'named-content type check'"/>
				<xsl:with-param name="description" select="concat(
				   'content-type attribute is [', $context/@content-type,
				   '], but should be one of [', $ok-types,
				   '].')"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>


   <!-- *********************************************************** -->
   <!-- Template: NORMALIZE-TO-ALPHANUMERIC  
        
        Converts a string to only Latin 1 alphanumeric characters
        by replacing all non-alphanumerics to spaces.
        For example: May 23, 2004 => May 23  2004 

        WARNING: Does not normalize-space the result.
    -->
   <!-- *********************************************************** -->
   <xsl:template name="normalize-to-alphanumeric">
      <xsl:param name="input"/>
		<xsl:variable name="alnumLat1" select="'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789'"/>
      
	  <!-- obsolete:
      <xsl:variable name="alphanumeric-test" select="translate(
	     substring($input, 1, 1),
         'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789',
         'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX')"/>
	    -->
            
      <xsl:choose>
         <!-- All done -->
         <xsl:when test="not($input)"/>
         
         <!-- First char is alphanumeric, so include it in result  -->
         <xsl:when
		     test="contains($alnumLat1,substring($input,1,1))">
            <xsl:value-of select="substring($input, 1,1)"/>
         </xsl:when>
         <!-- obsolete:
         <xsl:when test="$alphanumeric-test = 'X'">
            <xsl:value-of select="substring($input, 1,1)"/>
         </xsl:when>
         -->

         <!-- First char is not alphanumeric, so replace it with a space -->
         <xsl:otherwise>
            <xsl:text> </xsl:text>
         </xsl:otherwise>
      </xsl:choose>
      
      <!-- Continue recursion on remainder of string -->
      <xsl:if test="$input">
         <xsl:call-template name="normalize-to-alphanumeric">
            <xsl:with-param name="input" select="substring($input, 2)"/>
         </xsl:call-template>
      </xsl:if>
   </xsl:template>
   

   <!-- *********************************************************** -->
   <!-- Template: notes-in-proof-check  
        
        Should only be located in back. This duplicates
        some of the effort of check-for-back-elements,
        but is more stringent: it won't allow note-in-proof in
        abstracts or ack or app, etc.
     -->
   <!-- *********************************************************** -->
   <xsl:template name="notes-in-proof-check">
      <xsl:param name="context" select="."/><!-- will be notes -->
      
      <xsl:if test="$context[@notes-type = 'note-in-proof'][not(parent::back)]">
         <xsl:call-template name="make-error">
            <xsl:with-param name="error-type" select="'notes in proof check'"/>
            <xsl:with-param name="description">
               <xsl:text>note-in-proof should be a direct child of back</xsl:text>
            </xsl:with-param>
				<xsl:with-param name="tg-target" select="'dobs.html#dob-notesip'"/>
         </xsl:call-template>
      </xsl:if>
   </xsl:template> 

   
   <!-- *********************************************************** -->
   <!-- Template: oa-license-present
   
        If <open-access> is used in the document, there must be a license
		  element present at the article/book level.
		  
		  This is a 3.0 test only. It does not check CONTENT of the license.
     -->
   <!-- *********************************************************** -->
   <xsl:template name="oa-license-present">
		<xsl:if test="not(/article/front/article-meta/permissions/license)">
         <xsl:call-template name="make-error">
            <xsl:with-param name="error-type" select="'OA license check'"/>
            <xsl:with-param name="description">
               <xsl:text>A &lt;license&gt; must be present in the article-level &lt;permissions&gt; when an OA funder has been identified in &lt;open-access&gt;.</xsl:text>
            </xsl:with-param>
         	<xsl:with-param name="tg-target" select="'tags.html#el-openaccess'"/>
         </xsl:call-template>
			</xsl:if>
		</xsl:template>
		


   <!-- *********************************************************** -->
   <!-- Template: preformat-line-length-check
        PARAMS:
           context      per usual
		   string       (this is never passed)

        No line in preformat may be greater than 76 chars in books
     -->
   <!-- *********************************************************** -->
   <xsl:template name="preformat-line-length-check">
      <xsl:param name="context" select="."/>
      <xsl:param name="stringA"  select="translate($context,'&#xA;','&#xD;')"/>
      <xsl:param name="string"  select="translate($stringA,'&#x02028;','&#xD;')"/>

	  <xsl:choose>
		 <xsl:when test="$string = ''"/>

		 <xsl:when test="contains($string,'&#xD;')">
		
			<xsl:choose>
				<xsl:when test="string-length(substring-before($string,'&#xD;')) &gt; 76">
					<xsl:call-template name="make-error">
						<xsl:with-param name="error-type" select="'preformat line length check'"/>
						<xsl:with-param name="description">
							<xsl:text>No line inside &lt;preformat&gt; may be greater than 76 characters.[</xsl:text>
							<xsl:value-of select="string-length(substring-before($string,'&#xD;'))"/>
							<xsl:text> chars]. "</xsl:text>
							<xsl:value-of select="substring-before($string,'&#xD;')"/>
							<xsl:text>"</xsl:text>
						 </xsl:with-param>
		 			   </xsl:call-template>
				</xsl:when>
				<xsl:otherwise>
					<xsl:call-template name="preformat-line-length-check">
						<xsl:with-param name="context" select="substring-after($string,'&#xD;')"/>
					</xsl:call-template> 
				</xsl:otherwise>
			</xsl:choose>
		 </xsl:when>

		 <xsl:when test="string-length($string) &gt; 76">
			<xsl:call-template name="make-error">
				<xsl:with-param name="error-type" select="'preformat line length check'"/>
				<xsl:with-param name="description" select="concat(
					'No line inside &lt;preform&gt; should be ',
					'greater than 76 characters, but this one is ',
					string-length($string), ': [', $string,
				    '].')"/>
			  </xsl:call-template>
		 </xsl:when>
		 <xsl:otherwise>
		    <!-- seems ok -->
		 </xsl:otherwise>
	  </xsl:choose>
   </xsl:template>


   <!-- *********************************************************** -->
   <!-- Template: product-to-article-type-check 
   
        If there is a product element in article-meta,
           then the article-type should be set to either
           book-review or product-review
     -->
   <!-- *********************************************************** -->
   <xsl:template name="product-to-article-type-check">
      <xsl:param name="context" select="."/> <!-- Will be article -->
      
      <!-- Run the test if there is a product -->
      <xsl:if test="$context/front/article-meta/product">
         <xsl:choose>
            <xsl:when test="$context/@article-type
			   [.='book-review' or .='product-review']">
               <!-- This is correct-->
            </xsl:when>
            
            <xsl:otherwise>
               <xsl:call-template name="make-error">
                  <xsl:with-param name="error-type">article-type attribute-check</xsl:with-param>
                  <xsl:with-param name="description">
                     <xsl:text>article-meta contains a product element: article-type attribute should be set to 'book-review' or 'product-review'</xsl:text>
                  </xsl:with-param>
               </xsl:call-template>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:if>
   </xsl:template> 

   <!-- *********************************************************** -->
   <!-- Template: pub-date-check  
        Notes: Called from article-meta match; confirms we have "real" pub-date. 
        		Content checking done in pub-date-content-check.
        
	        For Articles
	        	1) there must be a pub-date of a type other than nihms-submitted
	        	2) if there is a collection pub-date, epub date must exist and
	        		have both day and month
     -->
   <!-- *********************************************************** -->
	<xsl:template name="pub-date-check">
		<xsl:choose>
			<xsl:when test="pub-date[@pub-type='collection'] or pub-date[@date-type='collection'][@publication-format='electronic']">
				<xsl:choose>
					<xsl:when test="pub-date[@pub-type='epub']/day and pub-date[@pub-type='epub']/month">
						<!-- do nothing -->
					</xsl:when>
					<xsl:when test="pub-date[@pub-type='epub']/processing-instruction('pmc-write-epub-date')">
						<!-- do nothing -->
					</xsl:when>
					<xsl:when test="not(pub-date[@pub-type='epub']) and not(pub-date[@date-type='pub'][@publication-format='electronic'])">
						<xsl:call-template name="make-error">
							<xsl:with-param name="error-type">pub-date check</xsl:with-param>
							<xsl:with-param name="description">
								<xsl:text>articles with a collection date must also have an e-pub date.</xsl:text>
							</xsl:with-param>
						</xsl:call-template>
					</xsl:when>					
					<xsl:when test="(not(pub-date[@pub-type='epub']/day) or not(pub-date[@pub-type='epub']/month))
						and (not(pub-date[@date-type='pub'][@publication-format='electronic']/day) 
								or not(pub-date[@date-type='pub'][@publication-format='electronic']/month))">
						<xsl:call-template name="make-error">
							<xsl:with-param name="error-type">pub-date check</xsl:with-param>
							<xsl:with-param name="description">
								<xsl:text>articles with a collection date must have an e-pub date with day and month.</xsl:text>
							</xsl:with-param>
						</xsl:call-template>
					</xsl:when>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="pub-date[@pub-type] and (pub-date[@pub-type!='nihms-submitted' and @pub-type!='pmc-release'])"/>
			<xsl:when test="pub-date[@date-type][@publication-format]"/>
			<xsl:otherwise>
				<xsl:call-template name="make-error">
					<xsl:with-param name="error-type">pub-date check</xsl:with-param>
					<xsl:with-param name="description">
						<xsl:text>article-meta must contain a real publication date.</xsl:text>
					</xsl:with-param>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>  
	</xsl:template>
	
	
	<!-- *********************************************************** -->
	<!-- Template: pub-date-conflict-check
		ppub and collection dates not allowed in the same article
		-->
	<!-- *********************************************************** -->
	<xsl:template name="pub-date-conflict-check">
		<xsl:param name="context"/>
		<xsl:choose>
			<xsl:when test="$context/@pub-type">
				<xsl:if test="$context/@pub-type='ppub'">
					<xsl:if test="$context/following-sibling::pub-date[@pub-type='collection']
						or $context/following-sibling::pub-date[@publication-format='collection'][@date-type='pub']">
						<xsl:call-template name="make-error">
							<xsl:with-param name="error-type">pub-date check</xsl:with-param>
							<xsl:with-param name="description">
								<xsl:text>Articles must not contain both print and collection dates.</xsl:text>
							</xsl:with-param>
						</xsl:call-template>
					</xsl:if>
				</xsl:if>
				<xsl:if test="$context/@pub-type='collection'">
					<xsl:if test="$context/following-sibling::pub-date[@pub-type='ppub']
						or $context/following-sibling::pub-date[@publication-format='print'][@date-type='pub']">
						<xsl:call-template name="make-error">
							<xsl:with-param name="error-type">pub-date check</xsl:with-param>
							<xsl:with-param name="description">
								<xsl:text>Articles must not contain both print and collection dates.</xsl:text>
							</xsl:with-param>
						</xsl:call-template>
					</xsl:if>
				</xsl:if>
			</xsl:when>
			<xsl:when test="$context/@publication-format">
				<xsl:if test="$context/@publication-format='print' and $context/@date-type='pub'">
					<xsl:if test="$context/following-sibling::pub-date[@pub-type='collection']
						or $context/following-sibling::pub-date[@publication-format='collection'][@date-type='pub']">
						<xsl:call-template name="make-error">
							<xsl:with-param name="error-type">pub-date check</xsl:with-param>
							<xsl:with-param name="description">
								<xsl:text>Articles must not contain both print and collection dates.</xsl:text>
							</xsl:with-param>
						</xsl:call-template>
					</xsl:if>
				</xsl:if>
				<xsl:if test="$context/@publication-format='collection' and $context/@date-type='pub'">
					<xsl:if test="$context/following-sibling::pub-date[@pub-type='ppub']
						or $context/following-sibling::pub-date[@publication-format='print'][@date-type='pub']">
						<xsl:call-template name="make-error">
							<xsl:with-param name="error-type">pub-date check</xsl:with-param>
							<xsl:with-param name="description">
								<xsl:text>Articles must not contain both print and collection dates.</xsl:text>
							</xsl:with-param>
						</xsl:call-template>
					</xsl:if>
				</xsl:if>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
		
		
	<!-- *********************************************************** -->
	<!-- Template: pub-date-content-check
		1) date must be valid
		2) pub-type or date-type + publication-format must be recognized value
			or combination
		3) 
		-->
	<!-- *********************************************************** -->
	<xsl:template name="pub-date-content-check">
		<xsl:param name="context"/>
		<xsl:choose>
			<xsl:when test="$context/@pub-type">
				<xsl:call-template name="pub-type-check"/>
			</xsl:when>
			<xsl:when test="$context/@date-type and $context/@publication-format">
				<xsl:call-template name="date-type-check">
					<xsl:with-param name="str" select="$context/@date-type"/>
				</xsl:call-template>
				<xsl:call-template name="publication-format-check">
					<xsl:with-param name="str" select="$context/@publication-format"/>
				</xsl:call-template>
			</xsl:when>			
		</xsl:choose>
		<xsl:if test="$context/@publication-format and $context/@pub-type">
			<xsl:call-template name="make-error">
				<xsl:with-param name="error-type">pub-date check</xsl:with-param>
				<xsl:with-param name="description">
					<xsl:text>[pub-date] must have either [@pub-type] or [@date-type + @publication-format]. Do not use [@pub-type] with [@publication-format].</xsl:text>
				</xsl:with-param>
			</xsl:call-template>
		</xsl:if>
		<xsl:call-template name="date-check"/>
	</xsl:template>

		
		
		
   <!-- *********************************************************** -->
   <!-- Template: pub-id-check  
        Notes:    Restrict pub-id/@pub-id-type to known values, if present.
                 If not present, that's also an error.
     -->
   <!-- *********************************************************** -->
   <xsl:template name="pub-id-check">
      <xsl:param name="context" select="."/> <!-- pub-id -->
 
   	<xsl:variable name="ok-names" select="$pub-id-type-values"/>

	  <xsl:variable name="is-ok">
	     <xsl:call-template name="is-in-list">
		    <xsl:with-param name="list"  select="$ok-names"/>
		    <xsl:with-param name="token" select="$context/@pub-id-type"/>
		    <xsl:with-param name="case"  select="'1'"/>
		 </xsl:call-template>
	  </xsl:variable>

	  <xsl:if test="@pub-id-type = '' or $is-ok != '1'">
         <xsl:call-template name="make-error">
            <xsl:with-param name="error-type" select="'pub-id check'"/>
            <xsl:with-param name="description">
               <xsl:value-of select="concat(
			   'pub-id-type is [', @pub-id-type, 
			   '], but must be one of [', $ok-names,
			   '].')"/>
            </xsl:with-param>
         </xsl:call-template>
	  </xsl:if>
   </xsl:template>
   

   <!-- *********************************************************** -->
   <!-- Template: pub-id-type-check 
        NOTES:    pub-id-type attribute must match approved values 
                  *and* must be present.
     -->
   <!-- *********************************************************** -->
   <xsl:template name="pub-id-type-check">
      <xsl:param name="context" select="."/>

		<xsl:variable name="ok-names">
	  		<xsl:choose>
				<xsl:when test="$stream='manuscript'">
					<xsl:value-of select="'manuscript other publisher-id doi'"/>
					</xsl:when>
				<xsl:when test="$stream='rrn'">
					<xsl:value-of select="'knolid other publisher-id doi art-access-id pmid'"/>
					</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$pub-id-type-values"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
		<xsl:variable name="is-ok">
			<xsl:call-template name="is-in-list">
				<xsl:with-param name="list"  select="$ok-names"/>
				<xsl:with-param name="token" select="$context/@pub-id-type"/>
				<xsl:with-param name="case"  select="'1'"/>
				</xsl:call-template>
			</xsl:variable>

		<xsl:if test="@pub-id-type = '' or $is-ok != '1'">
			<xsl:call-template name="make-error">
				<xsl:with-param name="error-type">article-id check</xsl:with-param>
				<xsl:with-param name="description">
					<xsl:value-of select="concat(
				     'article-id must contain a recognized pub-id-type ',
					 'attribute value (not ', @pub-id-type,').')"/>
               </xsl:with-param>
            </xsl:call-template>
      </xsl:if>
   </xsl:template> 


   
   <!-- *********************************************************** -->
   <!-- Template: pub-type-check
   
        Examines pub-date elements for valid pub-type attributes. 
        Specifically:
        1) @pub-type is required
        2) value of attribute is restricted to listed values, except:
        3) value can be "collection" only for pub-date
           elements; must also have another pub-date
           with @pub-type='epub'  
        4) value can be "nihms-submitted" or "pmc-release"
           if there is an nihms processing instruction
     -->
   <!-- *********************************************************** -->
   <xsl:template name="pub-type-check">
      <xsl:param name="context" select="."/> <!-- pub-date -->

	  <xsl:variable name="ok-pub-types" select="concat(
              'epub ',
              'ppub ',
              'epub-ppub ',
              'epreprint ',
              'ppreprint ',
              'ecorrected ',
              'pcorrected ',
              'eretracted ',
              'pretracted ', 
		   'nihms-submitted ', 
		 '')"/>
      
      <xsl:choose>
         <!-- Can have pub-type = 'nihms-submitted' or "pmc-release"
		      if there is a nihms processing instruction -->
         <xsl:when test="$context[self::pub-date]
		    [@pub-type = 'nihms-submitted' and 
			 (contains(//processing-instruction('origin'),'nihms') or
			  contains(//processing-instruction('properties'),'manuscript'))]">
            <!-- Do nothing -->
         </xsl:when>
         
			<!-- regular articles can have date "pmc-release" -->
         <xsl:when test="$context[self::pub-date]
		    [@pub-type = 'pmc-release' ]">
            <!-- Do nothing -->
         </xsl:when>
         
         <!-- Bad value: pub-date can have @pub-type  equal to "collection"
              when another pub-date has a pub-type attribute equal to "epub" -->
         <xsl:when test="$context[self::pub-date][@pub-type ='collection']
         				or $context[self::pub-date][@date-type='collection'][@publication-format='electronic']">
            <xsl:if test="not(//pub-date[@pub-type = 'epub']) 
            			and not(//pub-date[@date-type='pub'][@publication-format='electronic'])
            			and not(/article[@article-type='correction'])">
               <xsl:call-template name="make-error">
                  <xsl:with-param name="error-type"
				      select="'pub-type attribute check'"/>
                  <xsl:with-param name="description">
                  	<xsl:choose>
                  		<xsl:when test="$context[self::pub-date][@pub-type='collection']">
                  			<xsl:value-of select="concat('pub-type attribute can be set to [collection] only ',
					 'when article has another pub-date element with ',
					 'pub-type attribute set to [epub].')"/>
                  		</xsl:when>
                  		<xsl:otherwise>
                  			<xsl:value-of select="concat('publication-format attribute can be set to [collection] only ',
                  				'when article has another pub-date element with ',
                  				'publication-format set to [electronic] and date-type set to [pub].')"/>
                  		</xsl:otherwise>
                  	</xsl:choose>
                  	</xsl:with-param>
				<xsl:with-param name="tg-target" select="'tags.html#el-pubdate'"/>
               </xsl:call-template>
            </xsl:if>
         </xsl:when>
         

         
         <!-- Bad value: output error -->
         <xsl:when test="not($context/@pub-type)              
            or not($context[@pub-type='epub'             
            or @pub-type='ppub'             
            or @pub-type='epub-ppub'             
            or @pub-type='epreprint'             
            or @pub-type='ppreprint'             
            or @pub-type='ecorrected'             
            or @pub-type='pcorrected'             
            or @pub-type='eretracted'             
            or @pub-type='pretracted'
            or @pub-type='nihms-submitted'])
	    and $stream!='book'">
         
            <xsl:call-template name="make-error">
               <xsl:with-param name="error-type"
			      select="'pub-type attribute check'"/>
               <xsl:with-param name="description" select="concat(
                  '[', name($context),
                  '] element requires a pub-type attribute with one of the ',
				  'values: [', $ok-pub-types, '], not [',
				  @pub-type, '].')"/>
				<xsl:with-param name="tg-target" select="'tags.html#el-pubdate'"/>
            </xsl:call-template>
         </xsl:when>
	 <!--Books-->
	 <xsl:when test="not($context/@pub-type)              
            or not($context[@pub-type='epub'             
            or @pub-type='ppub'             
            or @pub-type='epubr'             
            or @pub-type='ppubr'])
	    and $stream = 'book'">         
            <xsl:call-template name="make-error">
               <xsl:with-param name="error-type"
			      select="'pub-type attribute check'"/>
               <xsl:with-param name="description" select="concat(
                  '[', name($context),
                  '] element requires a pub-type attribute with one of the  values: [epub ppub epubr ppubr], not [',
				  @pub-type, '].')"/>
            </xsl:call-template>
         </xsl:when>
      </xsl:choose>
   </xsl:template>
	

	<!-- *********************************************************** -->
	<!-- Template: publication-format-check -->
	<!-- *********************************************************** -->
	<xsl:template name="publication-format-check">
		<xsl:param name="str"/>
		<xsl:if test="$str">
			<xsl:choose>
				<xsl:when test="$str='electronic' or $str='print' or $str='electronic-print' or $str='collection'">
					<!-- these are okay -->
				</xsl:when>
				<xsl:otherwise>
					<xsl:call-template name="make-error">
						<xsl:with-param name="error-type">
							<xsl:text>pub-date/@date-type check</xsl:text>
						</xsl:with-param>
						<xsl:with-param name="description">
							<xsl:text>@publication-format on [pub-date] must be an accepted value: print, electronic, electronic-print. Value provided: </xsl:text>
							<xsl:value-of select="$str"/>
						</xsl:with-param>
						<xsl:with-param name="tg-target" select="'tags.html#el-pubdate'"/>
					</xsl:call-template>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:if>
	</xsl:template>


   <!-- *********************************************************** -->
   <!-- Template: punctuation-in-xref 
   
        Xrefs inside contrib should not have a trailing
        "," in the content. Formatting should be supplied
        by the renderer.
     -->
   <!-- *********************************************************** -->
   <xsl:template name="punctuation-in-xref">
      <xsl:param name="context" select="."/>

      <!-- xref content has a trailing comma: that's suspicious -->
      <xsl:if test="$context[normalize-space()]
	     [substring(normalize-space(.), string-length(normalize-space(.)), 1)
		   = ',']">
         <xsl:call-template name="make-error">
            <xsl:with-param name="error-type" select="'xref content check'"/>
            <xsl:with-param name="class" select="'warning'"/>
            <xsl:with-param name="description">
               <xsl:text>Do not place punctuation at the end of xref content to separate contiguous xrefs</xsl:text>
            </xsl:with-param>
         </xsl:call-template>
      </xsl:if>
   </xsl:template> 
   

   <!-- *********************************************************** -->
   <!-- Template: ref-check 
   
        All ref elements must have an id attribute.
      -->
   <!-- *********************************************************** -->
   <xsl:template name="ref-check">
      <xsl:param name="context" select="."/>

      <!-- Error case: no id or empty id attribute -->
      <xsl:if test="$context[not(@id)] or $context/@id[not(normalize-space())]">
         <xsl:call-template name="make-error">
            <xsl:with-param name="error-type" select="'ref checking'"/>
            <xsl:with-param name="description">
               <xsl:text>ref element must have a non-empty id attribute</xsl:text>
            </xsl:with-param>
         </xsl:call-template>
      </xsl:if>
   </xsl:template> 

   
   <!-- *********************************************************** -->
   <!-- Template: related-article-check 
   
        related article elements must have the following:
        1) @related-article-type required and restricted to given list.
        2) @id required
        3) @ext-link-type required
	 -->
   <!-- *********************************************************** -->
   <xsl:template name="related-article-check">
      <xsl:param name="context" select="."/>
      <xsl:choose>
         <!-- PMC-type links must have citation info, id, and 
		      related-article-type attributes -->
         <xsl:when test="$context[@ext-link-type = 'pmc']">
            <xsl:if test="not($context[@id and @related-article-type and @vol and @page])
            	and not($context[@id and @related-article-type and @vol and @elocation-id])">
            <xsl:call-template name="make-error">
               <xsl:with-param name="error-type" select="'related-article check'"/>
               <xsl:with-param name="description">
			      <xsl:value-of select="concat(
                     'related-article element is missing one or more of ',
				     'the following attributes: related-article-type, id, ',
				     'vol, and page or elocation-id. Attributes present are: ')"/>
				  <xsl:for-each select="$context/@*">
				     <xsl:value-of select="concat(name(),' ')"/>
				  </xsl:for-each>
				  <xsl:text>.</xsl:text>
               </xsl:with-param>
				<xsl:with-param name="tg-target" select="'tags.html#el-relart'"/>
            </xsl:call-template>
            </xsl:if>
         	
         	<xsl:if test="@xlink:href and
         		not(number(@xlink:href)) and not(number(substring-after(@xlink:href,'PMC')))">
         		<xsl:call-template name="make-error">
         			<xsl:with-param name="error-type" select="'related-article check'"/>
         			<xsl:with-param name="description">
         				<xsl:text>xlink:href may only be a PMCID if ext-link-type="pmc". </xsl:text>
         				<xsl:value-of select="@xlink:href"/>
         				<xsl:text> is not a PMCID.</xsl:text>
         			</xsl:with-param>
         			<xsl:with-param name="tg-target" select="'tags.html#el-relart'"/>
         		</xsl:call-template>
         	</xsl:if>
         	
         </xsl:when>
                 
         <!-- All other links need id, ext-link-type, related-article-type
		      and xlink:href -->
         <xsl:when test="not($context/@related-article-type) ">
			  <xsl:call-template name="make-error">
               <xsl:with-param name="error-type" select="'related-article check'"/>
               <xsl:with-param name="description">
                  <xsl:text>related-article element is missing related-article-type attribute</xsl:text>
               </xsl:with-param>
				<xsl:with-param name="tg-target" select="'tags.html#el-relart'"/>
            </xsl:call-template>
         </xsl:when>
         <xsl:when test="not($context/@id)">
			  <xsl:call-template name="make-error">
               <xsl:with-param name="error-type" select="'related-article check'"/>
               <xsl:with-param name="description">
                  <xsl:text>related-article element is missing an id attribute</xsl:text>
               </xsl:with-param>
				<xsl:with-param name="tg-target" select="'tags.html#el-relart'"/>
            </xsl:call-template>
         </xsl:when>      
         
      </xsl:choose>
   	
   	<xsl:variable name="ok-list" select="concat(
   		'addendum ',
   		'addended-article ',
   		'alt-language ',
   		'article-reference ',
   		'article-response ',
   		'commentary ',
   		'commentary-article ',
   		'companion ',
   		'concurrent-pub ',
   		'continued-by ',
   		'continues ',
   		'corrected-article ',
   		'correction-forward ',
   		'data-paper ',
   		'data-paper-referrer ',
   		'letter ',
   		'letter-reply ',
   		'object-of-concern ',
   		'peer-review ',
   		'peer-reviewed-article ',
   		'repub-note ',
   		'repub-note-target ',
   		'republication ',
   		'republished-article ',
   		'retracted-article ',
   		'retraction-forward ',
   		'update-in ',
   		'update-of ',
   		'updated-article ',
   		'update ',
   		'')"/>
   	
   	<xsl:variable name="rat-ok">
   		<xsl:call-template name="is-in-list">
   			<xsl:with-param name="list"  select="$ok-list"/>
   			<xsl:with-param name="token" select="$context/@related-article-type"/>
   			<xsl:with-param name="case"  select="'1'"/>
   		</xsl:call-template>
   	</xsl:variable>
   	
   	<!-- Check the related-article-type values -->
   	<xsl:variable name="rel-art-value"
   		select="$context/@related-article-type"/>
   	<xsl:if test="$rat-ok != 1">
   		<xsl:call-template name="make-error">
   			<xsl:with-param name="error-type" select="'related-article check'"/>
   			<xsl:with-param name="description" select="concat(
   				'related-article-type attribute is restricted to one of [',
   				$ok-list, '], not [', $context/@related-article-type,
   				'].')"/>
   			<xsl:with-param name="tg-target" select="'tags.html#el-relart'"/>
   		</xsl:call-template>
   	</xsl:if>
   	
   	<!-- Check the ext-link-type values -->
   	<xsl:variable name="ok-ext-link-values" select="concat(
   		'aoi ',
   		'doi ',
   		'ec ',
   		'email ',
   		'ftp ',
   		'gen ',
   		'genpept ',
   		'highwire ',
   		'pdb ',
   		'pgr ',
   		'pir ',
   		'pirdb ',
   		'pmc ',
   		'pmcid ',
   		'pmid ',
   		'pubmed ',
   		'sprot ',
   		'uri ',
   		'')"/>
   	<xsl:variable name="elv-ok">
   		<xsl:call-template name="is-in-list">
   			<xsl:with-param name="list"  select="$ok-ext-link-values"/>
   			<xsl:with-param name="token" select="$context/@ext-link-type"/>
   			<xsl:with-param name="case"  select="'1'"/>
   		</xsl:call-template>
   	</xsl:variable>
   	
   	<xsl:if test="$elv-ok != 1">
   		<xsl:call-template name="make-error">
   			<xsl:with-param name="error-type" select="'related-article check'"/>
   			<xsl:with-param name="description" select="concat(
   				'ext-link-type attribute is restricted to one of [',
   				$ok-ext-link-values, '], not [',
   				$context/@ext-link-type, '].')"/>
   			<xsl:with-param name="tg-target" select="'tags.html#el-relart'"/>
   		</xsl:call-template>    
   	</xsl:if>
   	
   	<!-- now check relationship between ext-link-type and xlink:href -->
   	
   	<xsl:if test="$context/@xlink:href and not($context/@ext-link-type) ">
   		<xsl:call-template name="make-error">
   			<xsl:with-param name="error-type" select="'related-article check'"/>
   			<xsl:with-param name="description">
   				<xsl:text>related-article element must have @ext-link-type to classify the value in @xlink:href.</xsl:text>
   			</xsl:with-param>
   			<xsl:with-param name="tg-target" select="'tags.html#el-relart'"/>
   		</xsl:call-template>
   	</xsl:if>			
   </xsl:template>
	
   <!-- *********************************************************** -->
   <!-- Template: ms-related-article-check 
   
	 -->
   <!-- *********************************************************** -->
   <xsl:template name="ms-related-article-check">

   	<xsl:if test="@related-article-type!='corrected-article' and 
		              @related-article-type!='retracted-article' and 
						  @related-article-type!='commentary-article' and 
						  @related-article-type!='concurrent-pub' and 
						  @related-article-type!='republished-article' and 
						  @related-article-type!='updated-article' and 
						  @related-article-type!='addended-article' and 
						  @related-article-type!='object-of-concern'">
   		<xsl:call-template name="make-error">
   			<xsl:with-param name="error-type">related-article type check</xsl:with-param>
   			<xsl:with-param name="description">
   				<xsl:text>&lt;related-article&gt; must contain an @related-article-type with the value "commentary-article", "corrected-article", "addended-article", "expression-of-concern", or "retracted-article", not </xsl:text>
 					<xsl:value-of select="@related-article-type"/>
					<xsl:text>.</xsl:text>
   			</xsl:with-param>
   	   		</xsl:call-template>
   	</xsl:if>
   	
   	<xsl:if test="not(@ext-link-type='pmcid') and not(@ext-link-type='pmid')">
   		<xsl:call-template name="make-error">
   			<xsl:with-param name="error-type">related-article @ext-link-type check</xsl:with-param>
   			<xsl:with-param name="description">
   				<xsl:text>&lt;related-article&gt; must contain an @ext-link-type with the value "pmcid" and the @xlink:href must include a PMC ID or PubMed ID.</xsl:text>
   			</xsl:with-param>
   	   		</xsl:call-template>
   	</xsl:if>
   	
   	<xsl:if test="not(number(@xlink:href))">
   		<xsl:call-template name="make-error">
   			<xsl:with-param name="error-type">related-article @xlink:href check</xsl:with-param>
   			<xsl:with-param name="description">
   				<xsl:text>&lt;related-article&gt; must contain an @xlink:href that contains a PMC ID or PubMed ID.</xsl:text>
   			</xsl:with-param>
   	   		</xsl:call-template>
   	</xsl:if>
   	


		</xsl:template>
		
   <!-- *********************************************************** -->
   <!-- Template: related-object-check 
   
        related-object elements must have the following:
        1) @id required
        2) @*-id-type required for each supplied @*-id
        3) object must have at least one @*-id
        4) if @document-type="article", @document-id-type must be an approved value
	  5) if @document-type="article", @link-type must be an approved value        
	 -->
   <!-- *********************************************************** -->
   <xsl:template name="related-object-check">
   	<xsl:param name="context" select="."/>
		<!-- @id required -->
		<xsl:if test="not(@id)">
			<xsl:call-template name="make-error">
				<xsl:with-param name="error-type" select="'related-object check'"/>
				<xsl:with-param name="description">
					<xsl:text>&lt;related-object&gt; requires an @id.</xsl:text>
               </xsl:with-param>
				<xsl:with-param name="tg-target" select="'tags.html#el-relobj'"/>
            </xsl:call-template>
			</xsl:if>
		<!-- @id-type required for each target id-->
		<xsl:if test="(@source-id and not(@source-id-type)) or
		              		(@document-id and not(@document-id-type)) or 
						(@object-id and not(@object-id-type))">
			<xsl:call-template name="make-error">
				<xsl:with-param name="error-type" select="'related-object check'"/>
				<xsl:with-param name="description">
					<xsl:text>Every target id attribute (@source-id, @document-id, @object-id) requires a target id-type attribute (@source-id-type, @document-id-type, @object-id-type) to identify it.</xsl:text>
              		 </xsl:with-param>
				<xsl:with-param name="tg-target" select="'tags.html#el-relobj'"/>
            	</xsl:call-template>
		</xsl:if>
   		<!-- Must describe something -->
   		<xsl:if test="not(@source-id) and not(@document-id) and not(@object-id)">
			<xsl:call-template name="make-error">
				<xsl:with-param name="error-type" select="'related-object check'"/>
				<xsl:with-param name="description">
					<xsl:text>&lt;related-object&gt; must must describe a link to something: a work, a document in a work, or an object in a document in a work.</xsl:text>
       	   		</xsl:with-param>
				<xsl:with-param name="tg-target" select="'tags.html#el-relobj'"/>
        		   </xsl:call-template>
   		</xsl:if>
   		<!-- If describing an article, @document-id-type must be doi, pmcid, or pmid -->
   		<xsl:if test="@document-type='article'">
   			<xsl:choose>
	   			<xsl:when test="@document-id-type='doi' or @document-id-type='pmcid' or @document-id-type='pmid'">
	   				<!-- these are okay -->
	   			</xsl:when>
   				<xsl:otherwise>
   					<xsl:call-template name="make-error">
   						<xsl:with-param name="error-type" select="'related-object check'"/>
   						<xsl:with-param name="description">&lt;related-object&gt; with document-type="article" must have document-id-type of [doi | pmcid | pmid]. Supplied value is [<xsl:value-of select="@document-id-type"/>].</xsl:with-param>
   					</xsl:call-template>
   				</xsl:otherwise>
   			</xsl:choose>
   		</xsl:if>
   		<!-- If describing an article, @document-id must exist -->
   		<xsl:if test="@document-type='article' and not(@document-id)">
   			<xsl:call-template name="make-error">
   				<xsl:with-param name="error-type" select="'related-object check'"/>
   				<xsl:with-param name="description">&lt;related-object&gt; with document-type="article" must have a document-id.</xsl:with-param>
   			</xsl:call-template>
   		</xsl:if>
   		<!-- If describing an article, @link-type must be recognized value -->
   		<xsl:if test="@document-type='article'">
   			<xsl:variable name="ok-list" select="concat(
   				'addendum ',
   				'addended-article ',
   				'alt-language ',
   				'article-reference ',
   				'article-response ',
   				'commentary ',
   				'commentary-article ',
   				'companion ',
   				'concurrent-pub ',
   				'continued-by ',
   				'continues ',
   				'corrected-article ',
   				'correction-forward ',
   				'letter ',
   				'letter-reply ',
   				'object-of-concern ',
   				'repub-note ',
   				'repub-note-target ',
   				'republication ',
   				'republished-article ',
   				'retracted-article ',
   				'retraction-forward ',
   				'update-in ',
   				'update-of ',
   				'updated-article ',
   				'update ',
   				'peer-review ',
   				'peer-reviewed-article ',
   				'')"/>
   			
   			<xsl:variable name="rat-ok">
   				<xsl:call-template name="is-in-list">
   					<xsl:with-param name="list"  select="$ok-list"/>
   					<xsl:with-param name="token" select="$context/@link-type"/>
   					<xsl:with-param name="case"  select="'1'"/>
   				</xsl:call-template>
   			</xsl:variable>
   			
   			<!-- Check the related-article-type values -->
   			<xsl:variable name="rel-art-value"
   				select="$context/@link-type"/>
   			<xsl:if test="$rat-ok != 1">
   				<xsl:call-template name="make-error">
   					<xsl:with-param name="error-type" select="'related-object check'"/>
   					<xsl:with-param name="description" select="concat(
   						'link-type attribute is restricted to one of [',
   						$ok-list, '], not [', $context/@link-type,
   						'].')"/>
   					<xsl:with-param name="tg-target" select="'tags.html#el-relobj'"/>
   				</xsl:call-template>
   			</xsl:if>
   		</xsl:if>
	</xsl:template>
<!-- end related-object -->
	
	<!-- *********************************************************** -->
	<!-- Template: related-article-xlink-extlinktype-check 
		1) If the xlink:href is a DOI, ext-link-type must be 'doi' or 'DOI' 
	-->
	<!-- *********************************************************** -->
	<xsl:template name="related-article-xlink-extlinktype-check">
		<xsl:param name="context" select="."/>		
		<xsl:variable name="eltype" select="$context/@ext-link-type"/>		
		<xsl:variable name="href" select="$context/@xlink:href"/>		
		<xsl:variable name="good-doi">
			<xsl:call-template name="doi-format-test">
				<xsl:with-param name="doi" select="$href"/>
			</xsl:call-template>
		</xsl:variable>
		
		<xsl:if test="$good-doi = 'true' and $eltype!='doi' and $eltype!='DOI'">
			<xsl:call-template name="make-error">
				<xsl:with-param name="error-type" select="'related-article check'"/>
				<xsl:with-param name="description">
					<xsl:text>&lt;related-article&gt; xlink:href is a DOI but the ext-link-type is </xsl:text>
					<xsl:value-of select="$eltype"/>
					<xsl:text>.</xsl:text>
				</xsl:with-param>
				<xsl:with-param name="tg-target" select="'tags.html#el-relart'"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
	
	
	<!-- *********************************************************** -->
	<!-- Template: related-article-self-test 
		1) Related-articlecannot point to itself unless the related-article-type is
		    "peer-reviewed-article".
		    For letters and replies, issue a warning, not a failure.
	-->
	<!-- *********************************************************** -->
	<xsl:template name="related-article-self-test">
		<xsl:variable name="vol" select="/article/front/article-meta/volume"/>
		<xsl:variable name="page">
			<xsl:choose>
				<xsl:when  test="/article/front/article-meta/elocation-id">
					<xsl:value-of select="/article/front/article-meta/elocation-id"/>
				</xsl:when>
				<xsl:when test="/article/front/article-meta/fpage[@seq]">
					<xsl:value-of select="concat(/article/front/article-meta/fpage,/article/front/article-meta/fpage/@seq)"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="/article/front/article-meta/fpage"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="doi" select="/article/front/article-meta/article-id[@pub-id-type='doi']"/>
		<xsl:variable name="arttype" select="/article/@article-type"/>
		<xsl:choose>
			<xsl:when test="@ext-link-type='doi'">
				<xsl:if test="@xlink:href=$doi">
					<xsl:choose>
						<xsl:when test="@related-article-type='peer-reviewed-article'"/>
						<xsl:otherwise>
							<xsl:call-template name="make-error">
								<xsl:with-param name="error-type" select="'related-article check'"/>
								<xsl:with-param name="class">
									<xsl:choose>
										<xsl:when test="$arttype='letter' or $arttype='reply' or @related-article-type='alt-language'">
											<xsl:text>warning</xsl:text>
										</xsl:when>
										<xsl:otherwise>
											<xsl:text>error</xsl:text>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:with-param>
								<xsl:with-param name="description">
									<xsl:text>&lt;related-article&gt; DOI is the same as the article DOI.</xsl:text>
								</xsl:with-param>
								<xsl:with-param name="tg-target" select="'tags.html#el-relart'"/>
							</xsl:call-template>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
			</xsl:when>
			<xsl:when test="@page and @vol and not(@journal-id)">
				<xsl:if test="@page=$page and @vol=$vol">
					<xsl:call-template name="make-error">
						<xsl:with-param name="error-type" select="'related-article check'"/>
						<xsl:with-param name="class">
							<xsl:choose>
								<xsl:when test="$arttype='letter' or $arttype='reply' or @related-article-type='alt-language'">
									<xsl:text>warning</xsl:text>
								</xsl:when>
								<xsl:otherwise>
									<xsl:text>error</xsl:text>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:with-param>
						<xsl:with-param name="description">
							<xsl:text>&lt;related-article&gt; volume and page point to the containing article.</xsl:text>
						</xsl:with-param>
						<xsl:with-param name="tg-target" select="'tags.html#el-relart'"/>
					</xsl:call-template>
				</xsl:if>
			</xsl:when>			
		</xsl:choose>
	</xsl:template>	
	
	

   <!-- *********************************************************** -->
   <!-- Template: related-article-to-article-type-attribute
     -->
   <!-- *********************************************************** -->
   <xsl:template name="related-article-to-article-type-attribute">
      <xsl:param name="context" select="."/>
      
      <xsl:variable name="art-type" select=
	     "normalize-space($context/ancestor::article/@article-type)"/>
   	
   	<xsl:variable name="context-name" select="local-name($context)"/>
   	<xsl:variable name="context-att-name">
   		<xsl:choose>
   			<xsl:when test="$context-name='related-object'">
   				<xsl:text>link-type</xsl:text>
   			</xsl:when>
   			<xsl:otherwise>
   				<xsl:text>related-article-type</xsl:text>
   			</xsl:otherwise>
   		</xsl:choose>
   	</xsl:variable>
   	
   	<xsl:variable name="context-type-att">
   		<xsl:choose>
   			<xsl:when test="$context-name='related-object'">
   				<xsl:value-of select="$context/@link-type"/>
   			</xsl:when>
   			<xsl:otherwise>
   				<xsl:value-of select="$context/@related-article-type"/>
   			</xsl:otherwise>
   		</xsl:choose>
   	</xsl:variable> 

	  <xsl:variable name="msg_start">
	  	<xsl:value-of select="concat('Either the ',$context-att-name,' attribute in ',
	  		$context-name,' is incorrect or the article-type attribute in &lt;article&gt; is incorrect. The ',$context-att-name,
	  		' suggests that this article' )"/>
	  </xsl:variable>
            
      <xsl:choose>
         <!-- Stop if there is no article-type attribute -->
         <xsl:when test="string-length($art-type) = 0"/>

         <xsl:when test="$context-type-att='addended-article'">
            <xsl:choose>
               <!-- This is correct -->
               <xsl:when test="$art-type = 'addendum'"/>
               
               <!-- Report problem -->
               <xsl:otherwise>
                  <xsl:call-template name="make-error">
                  	<xsl:with-param name="error-type" select="concat($context-att-name,' check')"/>
                     <xsl:with-param name="description" select="concat(
					    $msg_start,
						' addends the ',$context-name, '. ',
						'However, the article-type attribute is [', $art-type,
                        '] instead of [addendum].')"/>
                  </xsl:call-template>
               </xsl:otherwise>
            </xsl:choose>
         </xsl:when>

      	<xsl:when test="$context-type-att='commentary-article'">
            <xsl:choose>
               <!-- This is correct -->
               <xsl:when test="                                        
                  $art-type = 'editorial'
                  or $art-type = 'letter'
                  or $art-type = 'discussion'
                  or $art-type = 'expression-of-concern'
                  or $art-type = 'article-commentary'"/>
               <!-- Report problem -->
               <xsl:otherwise>
                  <xsl:call-template name="make-error">
                     <xsl:with-param name="error-type" select="concat($context-att-name,' check')"/>
                     <xsl:with-param name="description" select="concat(
					    $msg_start,
						' comments on the ', $context-name, '. ',
						'However, the article-type attribute is [', $art-type,
                        '] instead of [article-commentary].')"/>
                  </xsl:call-template>
               </xsl:otherwise>
            </xsl:choose>
         </xsl:when>

         <!--<xsl:when test="$context[@related-article-type = 'corrected-article']">-->
      	<xsl:when test="$context-type-att='corrected-article'">
            <xsl:choose>
               <!-- This is correct -->
               <xsl:when test="$art-type = 'correction'"/>
               
               <!-- Report problem -->
               <xsl:otherwise>
                  <xsl:call-template name="make-error">
                  	<xsl:with-param name="error-type" select="concat($context-att-name,' check')"/>
                     <xsl:with-param name="description" select="concat(
					    $msg_start,
						' corrects the ', $context-name, '. ',
						'However, the article-type attribute is [', $art-type,
                        '] instead of [correction].')"/>
                  </xsl:call-template>
               </xsl:otherwise>
            </xsl:choose>
         </xsl:when>
         
         <xsl:when test="$context-type-att='retracted-article'">
            <xsl:choose>
               <!-- This is correct -->
               <xsl:when test="$art-type = 'retraction'"/>
               
               <!-- Report problem -->
               <xsl:otherwise>
                  <xsl:call-template name="make-error">
                  	<xsl:with-param name="error-type" select="concat($context-att-name,' check')"/>
                     <xsl:with-param name="description" select="concat(
					    $msg_start,
						' retracts the ', $context-name, '. ',
						'However, the article-type attribute is [', $art-type,
                        '] instead of [retraction].')"/>
                  </xsl:call-template>
               </xsl:otherwise>
            </xsl:choose>
         </xsl:when>         
      </xsl:choose>
   </xsl:template>


   <!-- *********************************************************** -->
   <!-- Template: season-check 
        
        Check each season element that is not a 
        descendant of citation to make sure that
        it only contains the following values: 
        
        1) Named season (Spring,
        Summer, Autumn, Fall, Winter)
        
        2) Named month range (either full name or
           abbreviated; eg, Jan-Feb or January-February)
           
        2a) Abbreviated months of 3-letter for the "long"
           names and than March to July in long form
        
        3) Named season range (Spring-Summer)
     -->
   <!-- *********************************************************** -->
   <xsl:template name="season-check">
      <xsl:param name="context" select="."/>

      <xsl:choose>
         <xsl:when test="$context/ancestor::citation or $context/ancestor::nlm-citation
         	or $context/ancestor::element-citation or $context/ancestor::mixed-citation">
            <!-- Don't  test these -->
         </xsl:when>
         
         <!-- Call template to check the content -->
         <xsl:otherwise>
            <xsl:variable name="is-valid-season">
               <xsl:call-template name="is-season">
                  <xsl:with-param name="input" select="string($context)"/>
               </xsl:call-template>
            </xsl:variable>
			            
            <xsl:if test="$is-valid-season = 'false'">
               <xsl:call-template name="make-error">
                  <xsl:with-param name="error-type" select="'season checking'"/>
                  <xsl:with-param name="description">
                     <xsl:text>season should only contain a named season (Spring, Summer, Fall, Autumn, Winter), 
                     a month range (Jan-Feb or January-February), or a named season range (Spring-Summer). Current content is: </xsl:text>
                     <xsl:value-of select="$context"/>
                  </xsl:with-param>
				<xsl:with-param name="tg-target" select="'tags.html#el-season'"/>
               </xsl:call-template>
            </xsl:if>
         </xsl:otherwise>                  
      </xsl:choose>
   </xsl:template>


   <!-- *********************************************************** -->
   <!-- Template: sec-type-check 
   
        Check the title in each section inside the article
        to make sure that the sec-type is correct.
        
        Note: We only enforce sec-type in first-level sections; it
		is not incorrect to have a sec-type set in a lower-level sec, but
		we don't check them.
		
		As of 2015-07-21 we no longer enforce @sec-type values on first level sections. 
     -->
   <!-- *********************************************************** -->
   <xsl:template name="sec-type-check">
      <xsl:param name="context" select="."/>
      
      <!-- Only look at first level secs with titles -->
      <xsl:if test="$context/parent::body and $context/title[normalize-space()]">
         <xsl:variable name="title">
		    <xsl:call-template name="capitalize">
			   <xsl:with-param name="str" select="$context/title"/>
			</xsl:call-template>
         </xsl:variable>
            
         <xsl:choose>
            <!-- materials|methods -->
            <xsl:when test="                   
                  $title = 'MATERIALS &amp; METHODS'                
               or $title = 'MATERIALS AND METHODS'                
               or $title = 'METHODS &amp; MATERIALS'                
               or $title = 'METHODS AND MATERIALS'">
               <xsl:choose>
                  <xsl:when test="$context/@sec-type[contains(., 'methods')]">
                     <!-- this is right -->
                  </xsl:when>
                  
                  <xsl:otherwise>
                     <xsl:call-template name="make-error">
                        <xsl:with-param name="error-type">sec-type checking</xsl:with-param>
                        <xsl:with-param name="description">
                           <xsl:text>sec should have sec-type attribute set to 'materials|methods'</xsl:text>
                        </xsl:with-param>
								<xsl:with-param name="tg-target" select="'dobs.html#dob-methods'"/>
                     </xsl:call-template>
                  </xsl:otherwise>
               </xsl:choose>                  
            </xsl:when>
         
            <!-- methods -->
            <xsl:when test="                   
               $title = 'CASES &amp; METHODS'                
               or $title = 'CASES AND METHODS'                
               or $title = 'EXPERIMENTAL PROCEDURE'                
               or $title = 'EXPERIMENTAL PROCEDURES'                
               or $title = 'METHOD'                
               or $title = 'METHODOLOGY'                
               or $title = 'METHODS'                
               or $title = 'METHODS &amp; RESULTS'                
               or $title = 'METHODS AND RESULTS'                
               or $title = 'PATIENTS &amp; METHODS'                
               or $title = 'PATIENTS AND METHODS'                
               or $title = 'PROCEDURES'">
               <xsl:choose>
                  <xsl:when test="$context/@sec-type[contains(., 'methods')] or //sec/@sec-type[contains(., 'methods')]">
                     <!-- this is right -->
                  </xsl:when>
                  
                  <xsl:otherwise>
                     <xsl:call-template name="make-error">
                        <xsl:with-param name="error-type">sec-type checking</xsl:with-param>
                        <xsl:with-param name="description">
                           <xsl:text>sec should have sec-type attribute set to 'methods'</xsl:text>
                        </xsl:with-param>
								<xsl:with-param name="tg-target" select="'dobs.html#dob-methods'"/>
                     </xsl:call-template>
                  </xsl:otherwise>
               </xsl:choose>                  
            </xsl:when>

            <!-- materials -->
            <xsl:when test="                   
               $title = 'MATERIAL &amp; PARTICIPANTS'                
               or $title = 'MATERIAL AND PARTICIPANTS'                
               or $title = 'MATERIALS'                
               or $title = 'MATERIALS &amp; PARTICIPANTS'                
               or $title = 'MATERIALS AND PARTICIPANTS'                
               or $title = 'PARTICIPANTS &amp; MATERIALS'                
               or $title = 'PARTICIPANTS AND MATERIALS'                
               or $title = 'PATIENTS &amp; MATERIALS'                
               or $title = 'PATIENTS AND MATERIALS'                
               or $title = 'SUBJECTS &amp; MATERIALS'                
               or $title = 'SUBJECTS AND MATERIALS'">
               <xsl:choose>
                  <xsl:when test="$context/@sec-type[contains(., 'materials')]">
                     <!-- this is right -->
                  </xsl:when>
                  
                  <xsl:otherwise>
                     <xsl:call-template name="make-error">
                        <xsl:with-param name="error-type">sec-type checking</xsl:with-param>
                        <xsl:with-param name="description">
                           <xsl:text>sec should have sec-type attribute set to 'materials'</xsl:text>
                        </xsl:with-param>
								<xsl:with-param name="tg-target" select="'dobs.html#dob-methods'"/>
                     </xsl:call-template>
                  </xsl:otherwise>
               </xsl:choose>                  
            </xsl:when>
            
           <!-- extended-data -->
            <xsl:when test="                   
               $title = 'EXTENDED DATA' and $stream='manuscript'">
               <xsl:choose>
                  <xsl:when test="$context/@sec-type='extended-data'">
                     <!-- this is right -->
                  </xsl:when>
                  
                  <xsl:otherwise>
                     <xsl:call-template name="make-error">
                        <xsl:with-param name="error-type">sec-type checking</xsl:with-param>
                        <xsl:with-param name="description">
                           <xsl:text>sec should have sec-type attribute set to 'extended-data'.</xsl:text>
                        </xsl:with-param>
	                 </xsl:call-template>
                  </xsl:otherwise>
               </xsl:choose>                  
            </xsl:when>
            
            <!-- signature -->
            <xsl:when test="                
               $title    = 'SIGNATURE'                
               or $title = 'SIGNATURES'">
               <xsl:choose>
                  <xsl:when test="$context/@sec-type = 'signature'">
                     <!-- this is right -->
                  </xsl:when>
                  
                  <xsl:otherwise>
                     <xsl:call-template name="make-error">
                        <xsl:with-param name="error-type">sec-type checking</xsl:with-param>
                        <xsl:with-param name="description">
                           <xsl:text>sec should have sec-type attribute set to 'signature'</xsl:text>
                        </xsl:with-param>
								<xsl:with-param name="tg-target" select="'dobs.html#dob-sig'"/>
                     </xsl:call-template>
                  </xsl:otherwise>
               </xsl:choose>                  
            </xsl:when>
         </xsl:choose>
      </xsl:if>
   </xsl:template> 

   <!-- *********************************************************** -->
   <!-- Template: ms-extended-data-sec-title-test 
	
   		In Manuscripts, any section with the @sec-type='extended-data' must:
			1) have a title of "Extended Data"
			2) contain at least one figure or table
   		-->
   <!-- *********************************************************** -->
 	<xsl:template name="ms-extended-data-sec-test">
		<xsl:if test="@sec-type='extended-data'">
			<xsl:choose>
				<xsl:when test="normalize-space(title)='Extended Data'"/><!-- good -->
				<xsl:otherwise>
                <xsl:call-template name="make-error">
                   <xsl:with-param name="error-type">section title checking</xsl:with-param>
                        <xsl:with-param name="description">
                           <xsl:text>sec with @sec-type='extended-data' must have a &lt;title&gt; of "Extended Data".</xsl:text>
                        </xsl:with-param>
                     </xsl:call-template>
					</xsl:otherwise>
				</xsl:choose>
				
		<xsl:if test="not(fig) and not(table-wrap)">
                <xsl:call-template name="make-error">
                   <xsl:with-param name="error-type">extended data section check</xsl:with-param>
                        <xsl:with-param name="description">
                           <xsl:text>Extended Data section must contain at least a figure or table.</xsl:text>
                        </xsl:with-param>
                     </xsl:call-template>
			</xsl:if>		


            <xsl:if test="fig[@position!='anchor'] or table-wrap[@position!='anchor'] or boxed-text[@position!='anchor']">
               <xsl:call-template name="make-error">
   
                  <xsl:with-param name="error-type">extended data object check</xsl:with-param>
                  <xsl:with-param name="description">
                     <xsl:text>Extended Data objects must have position attributes set to "anchor"</xsl:text>
                  </xsl:with-param>
               </xsl:call-template>                                       
            </xsl:if>
            


				
			</xsl:if>
		</xsl:template>
  
   <!-- *********************************************************** -->
   <!-- Template: string-conf 
   		string-conference may not contain string-conference
   		-->
   <!-- *********************************************************** -->
	<xsl:template name="string-conf-element-check">
		<xsl:if test="string-conf">
         <xsl:call-template name="make-error">
            <xsl:with-param name="class" select="'warning'"/>
            <xsl:with-param name="error-type">string-conference check</xsl:with-param>
            <xsl:with-param name="description">
               <xsl:text>&lt;string-conf&gt; may not contain a child &lt;string-conf&gt;.</xsl:text>
            </xsl:with-param>
         	<!-- Not specified in TG; string-conf is only in Green and TG are strictly for Blue
 				<xsl:with-param name="tg-target" select="'style.html'"/>  -->
        </xsl:call-template>
      </xsl:if>
				</xsl:template>
			
   <!-- *********************************************************** -->
   <!-- Template: string-date-check 
   
        String date should only contain values that
        cannot be tagged with month, day, season
        and year attributes. Template checks content
        of string-date to see whether it is a recognizable
        pattern that could be tagged normally.
        Recognized patterns are as follows:
        
        Three tokens:
           Day Month Year
           Month Day Year 
           Month Month Year 
           Season Season Year
           
        Two tokens:
          Month Year  
          Season Year
        
        Month values might be numeric or named.
     -->
   <!-- *********************************************************** -->
   <xsl:template name="string-date-check">
      <xsl:param name="context" select="."/> <!-- string-date -->
      
      <!-- Get the date content with all non-alphanumerics stripped out -->
      <xsl:variable name="normalized-date">
         <xsl:call-template name="normalize-to-alphanumeric">
            <!-- Iterate over the nodes and make sure there is
                 whitespace between each so that adjacent elements (like
                 month and year) do not get run together-->
            <xsl:with-param name="input">
               <xsl:for-each select="$context/node()">
                  <xsl:value-of select="."/>
                  <xsl:text> </xsl:text>
               </xsl:for-each>
            </xsl:with-param>
         </xsl:call-template>
      </xsl:variable>
      
      <!-- Now count how many spaces there are -->
      <xsl:variable name="number-of-spaces">
         <xsl:call-template name="count-spaces">
            <xsl:with-param name="input" select="normalize-space($normalized-date)"/>
         </xsl:call-template>
      </xsl:variable>
      
      <!-- Now count the tokens: = one more than the number of spaces -->
      <xsl:variable name="number-of-tokens" select="$number-of-spaces + 1"/>
      
      <!-- Now check whether the tokens fit a known pattern that should have been
            tagged as something other than string-date -->
      <xsl:choose>
         <!-- Two tokens: put everything in upper case -->
         <xsl:when test="$number-of-tokens = 2">
            <xsl:variable name="token1">
			   <xsl:call-template name="capitalize">
	              <xsl:with-param name="str" select="
	                 substring-before(normalize-space($normalized-date), ' ')"/>
	           </xsl:call-template>
	        </xsl:variable>

            <xsl:variable name="token2">
	            <xsl:call-template name="capitalize">
	               <xsl:with-param name="str" select="
					  substring-after(normalize-space($normalized-date), ' ')"/>
	           </xsl:call-template>
	        </xsl:variable>
            
            <!-- See if token 1 is a month -->
            <xsl:variable name="token1-is-month">
               <xsl:call-template name="is-month">
                  <xsl:with-param name="input" select="$token1"/>
                  <xsl:with-param name="accept-name" select="'true'"/>
               </xsl:call-template>
            </xsl:variable>
            
            <!-- See if token 1 is a season -->
            <xsl:variable name="token1-is-season">
               <xsl:call-template name="is-season">
                  <xsl:with-param name="input" select="$token1"/>
               </xsl:call-template>
            </xsl:variable>
            
            <!-- See if token 2 is a year -->
            <xsl:variable name="token2-is-year">
               <xsl:call-template name="is-year">
                  <xsl:with-param name="input" select="$token2"/>
               </xsl:call-template>
            </xsl:variable>
            
            <!-- Now try to detect the pattern  -->
            <xsl:choose>
               <xsl:when test="$token1-is-month = 'true' and $token2-is-year = 'true'">
                  <xsl:call-template name="make-error">
      
                     <xsl:with-param name="error-type">string-date checking</xsl:with-param>
                     <xsl:with-param name="description">
                        <xsl:text>It appears that string-date could have been tagged as &lt;date&gt;&lt;month/&gt;&lt;year/&gt;&lt;/date&gt;</xsl:text>
                     </xsl:with-param>
                  </xsl:call-template>
               </xsl:when>
               
               <xsl:when test="$token1-is-season = 'true' and 
			                   $token2-is-year = 'true'">
                  <xsl:call-template name="make-error">
      
                     <xsl:with-param name="error-type">string-date checking</xsl:with-param>
                     <xsl:with-param name="description">
                        <xsl:text>It appears that string-date could have been tagged as &lt;date&gt;&lt;season/&gt;&lt;year/&gt;&lt;/date&gt;</xsl:text>
                     </xsl:with-param>
                  </xsl:call-template>
               </xsl:when>
            </xsl:choose>
         </xsl:when>
         
         <!-- Three tokens: put everything in upper case -->
         <xsl:when test="$number-of-tokens = 3">
            <xsl:variable name="token1">
	           <xsl:call-template name="capitalize">
	              <xsl:with-param name="str" select="
					 substring-before(normalize-space($normalized-date), ' ')"/>
               </xsl:call-template>
            </xsl:variable>

            <xsl:variable name="token2">
	           <xsl:call-template name="capitalize">
	              <xsl:with-param name="str"  select="
					 substring-before(substring-after(
					    normalize-space($normalized-date), ' '), ' ')"/>
               </xsl:call-template>
            </xsl:variable>

            <xsl:variable name="token3">
	           <xsl:call-template name="capitalize">
	              <xsl:with-param name="str" select="
				     substring-after(substring-after(
					    normalize-space($normalized-date), ' '), ' ')"/>
               </xsl:call-template>
            </xsl:variable>
                  
            <xsl:variable name="token1-is-day">
               <xsl:call-template name="is-day">
                  <xsl:with-param name="input" select="$token1"/>
               </xsl:call-template>
            </xsl:variable>
            
            <xsl:variable name="token1-is-month">
               <xsl:call-template name="is-month">
                  <xsl:with-param name="input" select="$token1"/>
                  <xsl:with-param name="accept-name" select="'true'"/>
               </xsl:call-template>
            </xsl:variable>

            <xsl:variable name="token2-is-month">
               <xsl:call-template name="is-month">
                  <xsl:with-param name="input" select="$token2"/>
                  <xsl:with-param name="accept-name" select="'true'"/>
               </xsl:call-template>
            </xsl:variable>

            <xsl:variable name="token1-is-season">
               <xsl:call-template name="is-season">
                  <xsl:with-param name="input" select="$token1"/>
               </xsl:call-template>
            </xsl:variable>

            <xsl:variable name="token2-is-season">
               <xsl:call-template name="is-season">
                  <xsl:with-param name="input" select="$token2"/>
               </xsl:call-template>
            </xsl:variable>

            <xsl:variable name="token2-is-day">
               <xsl:call-template name="is-day">
                  <xsl:with-param name="input" select="$token2"/>
               </xsl:call-template>
            </xsl:variable>

            <xsl:variable name="token3-is-year">
               <xsl:call-template name="is-year">
                  <xsl:with-param name="input" select="$token3"/>
               </xsl:call-template>
            </xsl:variable>
            
            <!-- Try to detect a pattern -->
            <xsl:choose>
               <xsl:when test="$token1-is-day = 'true' and
			      $token2-is-month = 'true' and $token3-is-year = 'true'">
                  <xsl:call-template name="make-error">
                     <xsl:with-param name="error-type">string-date checking</xsl:with-param>
                     <xsl:with-param name="description">
                        <xsl:text>It appears that string-date could have been tagged as &lt;date&gt;&lt;day/&gt;&lt;month/&gt;&lt;year/&gt;&lt;/date&gt;</xsl:text>
                     </xsl:with-param>
                  </xsl:call-template>
               </xsl:when>
               
               <xsl:when test="$token1-is-month = 'true' and
			                   $token2-is-day = 'true' and
							   $token3-is-year = 'true'">
                  <xsl:call-template name="make-error">
                     <xsl:with-param name="error-type">string-date checking</xsl:with-param>
                     <xsl:with-param name="description">
                        <xsl:text>It appears that string-date could have been tagged as &lt;date&gt;&lt;month/&gt;&lt;day/&gt;&lt;year/&gt;&lt;/date&gt;</xsl:text>
                     </xsl:with-param>
                  </xsl:call-template>
               </xsl:when>
               
               <xsl:when test="($token1-is-month = 'true'
	                 and $token2-is-month = 'true' and $token3-is-year = 'true')
                  or ($token1-is-season = 'true' and $token2-is-season = 'true'
	                 and $token3-is-year = 'true')">
                  <!-- Before treating as an error, see if this could have
                       truly been a season -->
                  <xsl:variable name="is-range">
                     <xsl:call-template name="is-season">
                        <xsl:with-param name="input"
						   select="concat($token1, '-', $token2)"/>
                     </xsl:call-template>
                  </xsl:variable> 
                  
                  <xsl:if test="$is-range = 'true'">
                     <xsl:call-template name="make-error">
                        <xsl:with-param name="error-type">string-date checking</xsl:with-param>
                        <xsl:with-param name="description">
                           <xsl:text>It appears that string-date could have been tagged as &lt;date&gt;&lt;season/&gt;&lt;year/&gt;&lt;/date&gt;</xsl:text>
                        </xsl:with-param>
                     </xsl:call-template>
                  </xsl:if>
               </xsl:when>
            </xsl:choose>
         </xsl:when>
         
         <!-- Could not deal with any other number of tokens, so let it go -->
      </xsl:choose>
   </xsl:template> 

	<!-- *********************************************************** -->
	<!-- Template:string-name-content-check
			String name must not contain >1 surname or >1 given-names-->
	<!-- *********************************************************** -->
	<xsl:template name="string-name-content-check">
		<xsl:if test="count(surname) > 1 or count(given-names)>1">
			<xsl:call-template name="make-error">
				<xsl:with-param name="error-type">string-name checking</xsl:with-param>
				<xsl:with-param name="description">
					<xsl:text>String-name must not contain more than 1 &lt;surname&gt; or more than 1 &lt;given-names&gt;</xsl:text>
				</xsl:with-param>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>


	<!-- *********************************************************** -->
	<!-- Template: subarticle-doi-check
		Values of $my-doi, $parent-doi should not match -->
	<!-- *********************************************************** -->
	<xsl:template name="subarticle-doi-check">
		<xsl:param name="my-doi"/>
		<xsl:param name="parent-doi"/>
		<xsl:choose>
			<xsl:when test="$parent-doi=''">
				<!-- No $parent-doi is okay -->
			</xsl:when>
			<xsl:when test="$parent-doi = $my-doi">
				<xsl:call-template name="make-error">					
					<xsl:with-param name="class" select="'warning'"/>
					<xsl:with-param name="error-type">DOI checking</xsl:with-param>
					<xsl:with-param name="description">
						<xsl:text>DOIs for &gt;sub-article&lt; and &gt;response&lt; should not be the same as the parent &gt;article&lt;</xsl:text>
					</xsl:with-param>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<!-- No conflict -->
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>



   <!-- *********************************************************** -->
   <!-- Template: subj-group-check 
                   
        1) subj-group[@subj-group-type='heading'] can only have a single subject child 
        2) compound-subject not allowed in subj-group[@subj-group-type='heading']   
        3) Warning if have more than one subj-group[@subj-group-type = 'heading'] -->
   <!-- *********************************************************** -->
   <xsl:template name="subj-group-check">
      <xsl:param name="context" select="."/>
      
      <!-- Too many subjects -->
      <xsl:if test="$context[@subj-group-type = 'heading'] and 
	                count($context/subject) &gt; 1">
         <xsl:call-template name="make-error">
            <xsl:with-param name="error-type">subj-group checking</xsl:with-param>
            <xsl:with-param name="description">
               <xsl:text>subj-group with subj-group-type attribute set to "heading" can only contain a single subject element</xsl:text>
            </xsl:with-param>
				<xsl:with-param name="tg-target" select="'tags.html#el-artcat'"/>
         </xsl:call-template>
      </xsl:if>
   	
   	<!-- Do not allow compound-subject in heading subject-group -->
   	<xsl:if test="$context[@subj-group-type='heading'] and compound-subject">
   		<xsl:call-template name="make-error">
   			<xsl:with-param name="error-type">subj-group checking</xsl:with-param>
   			<xsl:with-param name="description">
   				<xsl:text>subj-group with subj-group-type="heading" must not contain compound-subject</xsl:text>
   			</xsl:with-param>
   			<xsl:with-param name="tg-target" select="'dobs.html#dob-subjects'"/>
   		</xsl:call-template>
   	</xsl:if>
      
      <!-- Too many subj-groups: only issue a warning as this might be acceptable -->
      <xsl:if test="$context[@subj-group-type = 'heading'] and
	     $context/preceding-sibling::subj-group[@subj-group-type = 'heading']">
         <xsl:call-template name="make-error">
            <xsl:with-param name="class" select="'warning'"/>
            <xsl:with-param name="error-type">subj-group checking</xsl:with-param>
            <xsl:with-param name="description">
               <xsl:text>More than one subj-group has a subj-group-type attribute set to 'heading'</xsl:text>
            </xsl:with-param>
 				<xsl:with-param name="tg-target" select="'tags.html#el-artcat'"/>
        </xsl:call-template>
      </xsl:if>
   	
   	  <!-- Heading subjects must not be inline-graphic -->
   	  <xsl:if test="$context[@subj-group-type='heading'] and
   	  		$context[@subj-group-type='heading']/subject/inline-graphic and
   	  		normalize-space($context[@subj-group-type='heading']/subject[inline-graphic])=''">
   	  	<xsl:call-template name="make-error">
   	  		<xsl:with-param name="error-type">subj-group checking</xsl:with-param>
   	  		<xsl:with-param name="description">
   	  			<xsl:text>subj-group with subj-group-type="heading" must not contain inline-graphics</xsl:text>
   	  		</xsl:with-param>
   	  		<xsl:with-param name="tg-target" select="'tags.html#el-artcat'"/>
   	  	</xsl:call-template>
   	  </xsl:if>
   </xsl:template> 


   <!-- *********************************************************** -->
   <!-- Template: table-fn-check 
   
        fn inside a table must be a direct child of 
        table-wrap-foot -->
   <!-- *********************************************************** -->
   <xsl:template name="table-fn-check">
      <xsl:param name="context" select="."/>
      
      <xsl:if test="$context/ancestor::table-wrap">
         <xsl:choose>
            <xsl:when test="$context/parent::table-wrap-foot">
               <!-- This is correct -->
            </xsl:when>
            <xsl:when test="$stream='book'"/>
            <xsl:otherwise>
               <xsl:call-template name="make-error">
                  <xsl:with-param name="error-type"
				     select="'table footnote checking'"/>
                  <xsl:with-param name="description">
                     <xsl:text>table footnotes must be direct children of table-wrap-foot</xsl:text>
                  </xsl:with-param>
               </xsl:call-template>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:if>      
   </xsl:template> 

   
   <!-- *********************************************************** -->
   <!-- Template: test-month-range
        
        Checks whether a supplied month range is 
        valid. When first called, receives the 
        content of the season element. It then
        breaks this into a start and end range
        and tests each piece. If the range
        is valid, returns "true"; otherwise
        returns "false".
        
        Month ranges are only valid if:
        1) sentence case three letter values used (Jan,
           Feb, Mar, Apr, May, Jun, Jul, Aug,
           Sep, Oct, Noc, Dec)
        2) Only a hyphen or &#x2013; separate
           the months
        3) Months are in sequential order (not Dec-Jan
           or Apr-Apr)
     -->
   <!-- *********************************************************** -->
   <xsl:template name="test-month-range">
      <xsl:param name="range"/> <!-- Initial content of season -->
      <xsl:param name="comparison"/> <!-- First value to compare -->
      <xsl:param name="next-comparison" select="''"/>   <!-- Second value to compare -->
      <!-- Holds valid month values to compare -->
      <xsl:param name="comparison-string"
	     select="'Jan-Feb-Mar-Apr-May-Jun-Jul-Aug-Sep-Oct-Nov-Dec-'"/> 
      <xsl:param name="recursing"/> <!-- Flag indicates if in recursion -->
	  
      <xsl:choose>
         <!-- Initialization -->
         <xsl:when test="not($recursing)">
            <!-- Change the ndash character to a simple hyphen for simplicity
            	(this implies it's ok to use either a hyphen or an ndash -->
         	<xsl:variable name="normalized-range">
         		<xsl:choose>
         			<xsl:when test="contains($range,'&#x02013;')">
         				<xsl:value-of select="substring-before($range,
         					'&#x02013;')"/>
         				<xsl:text>-</xsl:text>
         				<xsl:value-of select="substring-after($range,
         					'&#x02013;')"/>
         			</xsl:when>
         			<xsl:when test="contains($range,
                     '&#x02010;')">
         				<xsl:value-of select="substring-before($range,
                     '&#x02010;')"/>
         				<xsl:text>-</xsl:text>
         				<xsl:value-of select="substring-after($range,
                     '&#x02010;')"/>
         			</xsl:when>
         			<xsl:when test="contains($range,
                     '/')">
         				<xsl:value-of select="substring-before($range,
                     '/')"/>
         				<xsl:text>-</xsl:text>
         				<xsl:value-of select="substring-after($range,
                     '/')"/>
         			</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$range"/>
					</xsl:otherwise>
         		</xsl:choose>
         	</xsl:variable>

            <!-- 4/12/06: LK commented out this replaced this variable
			    with above choose. The entity
            	processing makes this translate moot. 
            	<xsl:variable name="normalized-range"
				   select="translate($range, '&#x2013;&#x2010;', '!-!-')"/>
			  -->
            <xsl:choose>
               <!-- No hyphen in original string: cannot be valid -->
               <xsl:when test="not(contains($normalized-range, '-'))">
                  <xsl:text>false</xsl:text>
               </xsl:when>
               
               <!-- More than one hyphen: can't be valid -->
               <xsl:when test="
				      contains(substring-before($normalized-range, '-'), '-')
			       or contains(substring-after($normalized-range, '-'), '-')">
                  <xsl:text>false</xsl:text>
               </xsl:when>
               
               <!-- No start or end of range: can't be valid -->
               <xsl:when test="
                    not(substring-before($normalized-range, '-'))
				 or not(substring-after($normalized-range, '-'))">
                  <xsl:text>false</xsl:text>
               </xsl:when>
               
               <!-- Recursion -->
               <xsl:otherwise>			   
                  <xsl:call-template name="test-month-range">
                     <xsl:with-param name="recursing" select="1"/>
                     <xsl:with-param name="comparison" select=
					    "normalize-space(substring-before($normalized-range, '-'))"/>
                     <xsl:with-param name="next-comparison" select="
					    normalize-space(substring-after($normalized-range, '-'))"/>
                     <xsl:with-param name="comparison-string"
					    select="$comparison-string"/>
                  </xsl:call-template>
               </xsl:otherwise>
            </xsl:choose>
         </xsl:when>
         
         <!-- Haven't found a comparison match: can't be valid -->
         <xsl:when test="not($comparison-string)">
            <xsl:text>false</xsl:text>
         </xsl:when>
         
         <!-- Found a match -->
         <xsl:when test="starts-with($comparison-string, concat($comparison, '-'))">
            <xsl:choose>
               <!-- Nothing left to check, so range must be valid -->
               <xsl:when test="not($next-comparison)">
                  <xsl:text>true</xsl:text>
               </xsl:when>
               
               <!-- Something else to check: so need to recurse on remainder -->
               <xsl:otherwise>
                  <xsl:call-template name="test-month-range">
                     <xsl:with-param name="recursing" select="1"/>
                     <xsl:with-param name="comparison" select="$next-comparison"/>
                     <xsl:with-param name="comparison-string"
					    select="substring-after($comparison-string, '-')"/>
                  </xsl:call-template>
               </xsl:otherwise>
            </xsl:choose>
         </xsl:when>
         
         <!-- No match yet, need to keep looking in the comparison string -->
         <xsl:otherwise>
            <xsl:call-template name="test-month-range">
               <xsl:with-param name="recursing" select="1"/>
               <xsl:with-param name="comparison-string"
			      select="substring-after($comparison-string, '-')"/>
               <xsl:with-param name="comparison" select="$comparison"/>
               <xsl:with-param name="next-comparison" select="$next-comparison"/>
            </xsl:call-template>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template> <!-- test-month-range -->


   <!-- *********************************************************** -->
   <!-- Template: tex-math-content-check 
        
        Make sure that tex-math elements 
		  	1. Contain the string "begin{document}"
			2. do not have escaped characters beyond XML defined set
	 -->
   <!-- *********************************************************** -->
   <xsl:template name="tex-math-content-check">
      <xsl:param name="context" select="."/> 
      
      <!-- Report an error if latex beginning or ending document notations are not present-->
      <xsl:if test="not(contains(.,'begin{document}')) or not(contains(.,'end{document}'))">
         <xsl:call-template name="make-error">
            <xsl:with-param name="error-type" select="'tex-math content check'"/>
            <xsl:with-param name="description">
               <xsl:text>&lt;tex-math&gt; must contain a complete Late&#x3c7; document.</xsl:text>
            	</xsl:with-param>
         	</xsl:call-template>
			</xsl:if>
			
		<xsl:if test="contains(.,'&#x26;#')">	
        <xsl:call-template name="make-error">
            <xsl:with-param name="error-type" select="'tex-math content check'"/>
            <xsl:with-param name="description">
               <xsl:text>All characters in &lt;tex-math&gt; must be described with Late&#x3c7; character codes. There may not be any character entities except for those defined by XML [&amp;amp; (&amp;), &amp;lt;(&lt;), &amp;gt; (&gt;), &amp;quot; (&quot;), &amp;apos; (&apos;)].</xsl:text>
            	</xsl:with-param>
         	</xsl:call-template>
      	</xsl:if>
   </xsl:template> 

   <!-- *********************************************************** -->
   <!-- Template: tex-math-id-check 
        
        Make sure that tex-math elements have an id
        attribute
	 -->
   <!-- *********************************************************** -->
   <xsl:template name="tex-math-id-check">
      <xsl:param name="context" select="."/> <!-- will be mml:math -->
      
      <!-- Report an error -->
      <xsl:if test="not($context/@id)">
         <xsl:call-template name="make-error">
            <xsl:with-param name="error-type" select="'tex-math id check'"/>
            <xsl:with-param name="description">
               <xsl:text>&lt;tex-math&gt; must have an id attribute</xsl:text>
            </xsl:with-param>
         </xsl:call-template>
      </xsl:if>
   </xsl:template> 

   <!-- *********************************************************** -->
   <!-- Template: title-fn-check  
   
        article-title and subtitle should not contain footnotes.
     -->
   <!-- *********************************************************** -->
   <xsl:template name="title-fn-check-OBS">
      <xsl:param name="context" select="."/>
      
      <xsl:if test="$context/fn">
         <xsl:call-template name="make-error">
            <xsl:with-param name="error-type">article-title/subtitle check</xsl:with-param>
            <xsl:with-param name="description">
               <xsl:text>fn should be placed in back matter</xsl:text>
            </xsl:with-param>
				<xsl:with-param name="tg-target" select="'dobs.html#dob-atitle'"/>
         </xsl:call-template>
      </xsl:if>
   </xsl:template>


   <!-- *********************************************************** -->
   <!-- Template: title-fn-xref-check
   
      Inside title-group, if there is an xref pointing to a fn, then the fn
	  should be set in back/fn-group or it should be located in front/notes or
      in author-notes.
     -->
   <!-- *********************************************************** -->
   <xsl:template name="title-fn-xref-check">
      <xsl:param name="context" select="."/>
      
      <xsl:if test="
	      id($context/xref[@ref-type = 'fn']/@rid)
             [not(self::fn/parent::fn-group/parent::back) and
			  not(self::fn/ancestor::notes/parent::front) and
			  not(self::fn/ancestor::author-notes)]">
         <!-- Test will return elements pointed to be the fn xref that are
		      NOT in back/fn-group -->
         <xsl:call-template name="make-error">
            <xsl:with-param name="error-type">article-title/subtitle check</xsl:with-param>
            <xsl:with-param name="description">
               <xsl:text>Contains an xref pointing to a fn that is not inside back/fn-group</xsl:text>
            </xsl:with-param>
				<xsl:with-param name="tg-target" select="'dobs.html#dob-atitle'"/>
         </xsl:call-template>
      </xsl:if>
   </xsl:template> 


   <!-- *********************************************************** -->
   <!-- Template: trans-abstract-check
		  1) xml:lang must be different from xml:lang on article
		  
     -->
   <!-- *********************************************************** -->
	<xsl:template name="trans-abstract-check">		
		<xsl:param name="context" select="."/>
		<xsl:variable name="local-lang">
			<xsl:call-template name="knockdown">
				<xsl:with-param name="str" select="$context/@xml:lang"/>
				</xsl:call-template>
			</xsl:variable>
		<xsl:if test="$local-lang=$art-lang-att">
				<xsl:call-template name="make-error">
            	<xsl:with-param name="error-type">trans-abstract language attribute check</xsl:with-param>
            	<xsl:with-param name="description">
						<xsl:text>The &lt;trans-abstract&gt; should have a different @xml:lang value than the article. Both are '</xsl:text>
						<xsl:value-of select="$local-lang"/>
               	<xsl:text>'.</xsl:text>
            		</xsl:with-param>
        		</xsl:call-template>
			</xsl:if>
	   
	   <!--======================================================-->
	   <!--Removed this test, KP 2015-11-03-->
	   <!--Manuscript to follow PMC rules-->
	   <!--======================================================-->
		<!--<xsl:if test="$stream='manuscript' and $local-lang!='en'">
				<xsl:call-template name="make-error">
            	<xsl:with-param name="error-type">trans-abstract check</xsl:with-param>
            	<xsl:with-param name="description">
						<xsl:text>The &lt;trans-abstract&gt; should only be used to carry an English abstract in a non-English manuscript.</xsl:text>
            		</xsl:with-param>
        		</xsl:call-template>
		</xsl:if>-->
	   <!--======================================================-->
		</xsl:template>
	
	
	<!-- *********************************************************** -->
	<!-- Template: trans-atts-check
		  1) xml:lang must exist		  
     -->
	<!-- *********************************************************** -->
	<xsl:template name="trans-atts-check">
		<xsl:param name="context"/>
		<xsl:if test="not($context/@xml:lang)">
			<xsl:call-template name="make-error">
				<xsl:with-param name="error-type">
					<xsl:value-of select="concat(local-name($context),' language attribute check')"/>
				</xsl:with-param>
				<xsl:with-param name="description">
					<xsl:value-of select="concat(local-name($context), ' must include the xml:lang attribute.')"/>
				</xsl:with-param>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
	

   <!-- *********************************************************** -->
   <!-- Template: trans-title-content-check
		  1) xml:lang must be different from xml:lang on article
		  
     -->
   <!-- *********************************************************** -->
	<xsl:template name="trans-title-check">
		<xsl:variable name="local-lang">
			<xsl:call-template name="knockdown">
				<xsl:with-param name="str">
					<xsl:choose>
						<xsl:when test="parent::trans-title-group/@xml:lang">
							<xsl:value-of select="parent::trans-title-group/@xml:lang"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="./@xml:lang"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:with-param>
			</xsl:call-template>
		</xsl:variable>
	   
<!--    <xsl:message>
	      <xsl:text>&#xA;######DEBUG#######DEBUG######</xsl:text>
	      <xsl:text>&#xA;art-lang-att=&#xA;</xsl:text>
	      <xsl:value-of select="$art-lang-att"/>
	      <xsl:text>&#xA;local-lang=&#xA;</xsl:text>
	      <xsl:value-of select="$local-lang"/>
	      <xsl:text>&#xA;./@xml:lang=&#xA;</xsl:text>
	      <xsl:value-of select="./@xml:lang"/>
	      <xsl:text>&#xA;/article/@xml:lang=&#xA;</xsl:text>
	      <xsl:value-of select="/article/@xml:lang"/>
	      <xsl:text>######DEBUG#######DEBUG######</xsl:text>
	   </xsl:message> -->
 
	   
		<xsl:if test="$local-lang=$art-lang-att and not(ancestor::ref)">
				<xsl:call-template name="make-error">
            	<xsl:with-param name="error-type">trans-title language attribute check</xsl:with-param>
            	<xsl:with-param name="description">
						<xsl:text>The &lt;trans-title&gt; should have a different @xml:lang value than the article. trans-title/@xml:lang='</xsl:text>
            	   <xsl:value-of select="$local-lang"/><xsl:text>'.</xsl:text>
            	   <xsl:text>article/@xml:lang='</xsl:text>
            	   <xsl:value-of select="$art-lang-att"/><xsl:text>'.</xsl:text>
            		</xsl:with-param>
        		</xsl:call-template>
			</xsl:if>
	   <!--======================================================-->
	   <!--Removed this test, KP 2015-11-03-->
	   <!--Manuscript to follow PMC rules-->
	   <!--======================================================-->
		<!--<xsl:if test="$stream='manuscript' and $local-lang!='en' and not(ancestor::ref)">
				<xsl:call-template name="make-error">
            	<xsl:with-param name="error-type">trans-title check</xsl:with-param>
            	<xsl:with-param name="description">
						<xsl:text>The &lt;trans-title&gt; should only be used to carry an English title in a non-English manuscript.</xsl:text>
            		</xsl:with-param>
        		</xsl:call-template>
		</xsl:if>-->
	   <!--======================================================-->
		</xsl:template>

   <!-- *********************************************************** -->
   <!-- Template: trans-title-group-content-check
		  2) children must either have @xml:lang that agrees or have
		     no @xml:lang
		  3) Each child must have a corresponding element in the 
		     parent::title-group except for fn-group 
     -->
   <!-- *********************************************************** -->
	<xsl:template name="trans-title-group-content-check">
		<xsl:for-each select="child::node()">
			<xsl:if test="@xml:lang and @xml:lang!=parent::trans-title-group/@xml:lang">
				<xsl:call-template name="make-error">
            	<xsl:with-param name="error-type">trans-title-group language attribute check</xsl:with-param>
            	<xsl:with-param name="description">
						<xsl:text>If </xsl:text>
						<xsl:value-of select="name()"/>
               	<xsl:text> has an @xml:lang, its value must match the @xml:lang on the parent &lt;trans-title-group&gt;.</xsl:text>
            		</xsl:with-param>
					<xsl:with-param name="tg-target" select="'tags.html#el-transtitlegrp'"/>
         		</xsl:call-template>
				</xsl:if>
			<xsl:if test="name()='trans-subtitle' and not(ancestor::title-group/subtitle) and not(ancestor::journal-title-group/journal-subtitle)"> 
				<xsl:call-template name="make-error">
            	<xsl:with-param name="error-type">trans-subtitle check</xsl:with-param>
            	<xsl:with-param name="description">
               	<xsl:text>&lt;trans-subtitle&gt; must correspond to a &lt;subtitle&gt; in the ancestor &lt;</xsl:text>
						<xsl:value-of select="name(parent::trans-title-group/parent::node())"/>						
						<xsl:text>&gt;.</xsl:text>
            		</xsl:with-param>
					<xsl:with-param name="tg-target" select="'tags.html#el-transtitlegrp'"/>
         		</xsl:call-template>
				</xsl:if>
			</xsl:for-each>
	</xsl:template>

   <!-- *********************************************************** -->
   <!-- Template: web-ext-link-check  
   
        For every ext-link[@ext-link-type='uri'] AND
        all ext-link[contains(@xlink:href, 'http://') or contains(., 'http://')]
        
        The following must be true:
        
        1) ext-link-type must be set to uri
        2) xlink:href must start-with http://
     -->
   <!-- *********************************************************** -->
   <xsl:template name="web-ext-link-check">
      <xsl:param name="context" select="."/> <!-- ext-link-->
      
      <xsl:if test="$context[          
         @ext-link-type='uri'          
         or contains(@xlink:href, 'http://')          
         or contains(., 'http://')]">
         
         <!-- Must have ext-link-type set to uri -->
         <xsl:choose>
            <xsl:when test="$context[@ext-link-type = 'uri']">
               <!-- No problem -->
            </xsl:when>
               
            <xsl:otherwise>
               <!-- report error -->
               <xsl:call-template name="make-error">
                  <xsl:with-param name="error-type">web links checking</xsl:with-param>
                  <xsl:with-param name="description">
                     <xsl:text>ext-link-type attribute should be set to 'uri' for web links</xsl:text>
                  </xsl:with-param>
               </xsl:call-template>                     
            </xsl:otherwise>
         </xsl:choose>
            
         <!-- xlink:href must start with http://-->
         <xsl:choose>
            <xsl:when test="$context[starts-with(normalize-space(@xlink:href), 'http://')]">
               <!-- No problem-->
            </xsl:when>
            
            <!-- No xlink:href: this is caught elsewhere -->
            <xsl:when test="not(xlink:href)"/>
            
            <xsl:otherwise>
               <!-- Report error -->
               <xsl:call-template name="make-error">
                  <xsl:with-param name="error-type">web links checking</xsl:with-param>
                  <xsl:with-param name="description">
                     <xsl:text>xlink:href should begin with 'http://'</xsl:text>
                  </xsl:with-param>
               </xsl:call-template>                                          
            </xsl:otherwise>
         </xsl:choose>      
      </xsl:if>      
   </xsl:template> 


   <!-- *********************************************************** -->
   <!-- Template: write-xref-error-description 
   
        Helper for the check-xrefs template. This 
        generates the text for the error description
        
		NOTES: This is always called from within the description parameter
		       of a call to make-error. Therefore, the call to make-error 
			   should move in here, simplifying all the calls.

        Params:
           -xref: the xref node in error
           -expected-target: expected target     
     -->
   <!-- *********************************************************** -->
   <xsl:template name="write-xref-error-description">
      <xsl:param name="xref"/>
      <xsl:param name="expected-target"/>
      
      <xsl:text>xref (rid="</xsl:text>
      <xsl:value-of select="$xref/@rid"/>
      <xsl:text>") with attribute ref-type="</xsl:text>
      <xsl:value-of select="$xref/@ref-type"/>
      <xsl:text>" does not point to </xsl:text>
      <xsl:value-of select="$expected-target"/>
      <xsl:text>. Referenced element is actually of type </xsl:text>
      <xsl:value-of select="name(id($xref/@rid))"/>
      <xsl:text>.</xsl:text>
   </xsl:template> 


   <!-- *********************************************************** -->
   <!-- Template: xlink-attribute-check 
   
        Makes sure that xlink attributes are NOT used.
        Currently applies to the following elements:
           contract-num
           contract-sponsor
           contrib
     -->
   <!-- *********************************************************** -->
   <xsl:template name="xlink-attribute-check">
      <xsl:param name="context" select="."/>

         <!-- Has an xlink attribute: must be wrong.
		      Note: xlink:type is FIXED by the DTD and so is always present.
		   -->
         <xsl:if test="$context/@xlink:*[not(name() = 'xlink:type')]">
            <xsl:call-template name="make-error">
               <xsl:with-param name="error-type" select="'xlink-attribute checking'"/>
               <xsl:with-param name="description">
                  <xsl:text>xlink attributes should not be used in this element</xsl:text>
               </xsl:with-param>
            </xsl:call-template>
         </xsl:if>
   </xsl:template> 


   <!-- *********************************************************** -->
   <!-- Template: xref-check 
   
        Check that the rid in xref points
        to the appropriate thing based on the value of @type.
     -->
   <!-- *********************************************************** -->
   <xsl:template name="xref-check">
      <xsl:param name="context" select="."/>

	  <xsl:variable name="RID"    select="@rid"/>
	  <xsl:variable name="tnode"  select="id($context/@rid)"/>
	  <xsl:variable name="tname"  select="name(id($context/@rid))"/>
	  <xsl:variable name="ttoken" select="concat(' ',$tname,' ')"/>
      
	  <xsl:choose>
         <xsl:when test="$context[@ref-type and not(@rid)] and $stream!='rrn'">
            <xsl:call-template name="make-error">
               <xsl:with-param name="error-type">xref checking</xsl:with-param>
               <xsl:with-param name="description">
                  <xsl:text>xref element has ref-type attribute but no rid attribute.</xsl:text>
               </xsl:with-param>
				<xsl:with-param name="tg-target" select="'tags.html#el-xref'"/>
            </xsl:call-template>
         </xsl:when>

		<xsl:when test="not(id($context/@rid))">
            <xsl:call-template name="make-error">
               <xsl:with-param name="error-type">xref checking</xsl:with-param>
               <xsl:with-param name="class">warning</xsl:with-param>
               <xsl:with-param name="description">
                  <xsl:text>target of &lt;xref&gt; is not in this document.</xsl:text>
               </xsl:with-param>
				<xsl:with-param name="tg-target" select="'tags.html#el-xref'"/>
            </xsl:call-template>
			</xsl:when> 

         <xsl:when test="$context/@ref-type='aff'">
         	<xsl:if test="not(id($context/@rid)[self::aff]) 
         			and not(id($context/@rid)[self::aff-alternatives])
         			and not(id($context/@rid)[self::target/parent::aff])">
               <xsl:call-template name="make-error">   
                  <xsl:with-param name="error-type">xref checking</xsl:with-param>
                  <xsl:with-param name="description">
                     <xsl:call-template name="write-xref-error-description">
                        <xsl:with-param name="xref" select="$context"/>
                        <xsl:with-param name="expected-target" select="'an aff element'"/>
                     </xsl:call-template>
                  </xsl:with-param>
				<xsl:with-param name="tg-target" select="'tags.html#el-xref'"/>
               </xsl:call-template>
            </xsl:if>
         </xsl:when>
         
         <!-- Xref of type app must point to app OR section inside an app -->
	     <xsl:when test="$context/@ref-type='app'">
	        <xsl:if test="not(id($context/@rid)[self::app 
	        										or self::app-group 
	        										or self::sec/ancestor::app 
	        										or self::sec/parent::back 
	        										or self::book-part[@book-part-type='appendix']
												or self::book-app
												or self::book-app-group
												or self::book-part-wrapper[book-app]
												or self::book-part-wrapper[book-app-group]
												or self::book-part-wrapper[book-part/@book-part-type='appendix']])
	        			and not(id($context/@rid)[self::target/ancestor::app-group
	        										or self::target/parent::sec/parent::back
	        										or self::target/ancestor::book-part[@book-part-type='appendix']])">
	           <xsl:call-template name="make-error">   
	              <xsl:with-param name="error-type">xref checking</xsl:with-param>
	              <xsl:with-param name="description">
	                 <xsl:call-template name="write-xref-error-description">
	                    <xsl:with-param name="xref" select="$context"/>
	                    <xsl:with-param name="expected-target" select=
	                       "'an app element, app-group element, a sec inside an app, or a sec inside back'"/>
	                 </xsl:call-template>
	              </xsl:with-param>
	              <xsl:with-param name="tg-target" select="'tags.html#el-xref'"/>
	           </xsl:call-template>
	        </xsl:if>
	     </xsl:when> 
         
         <xsl:when test="$context/@ref-type='author-notes' or
		                 $context/@ref-type='author-note'">
            <xsl:if test="not(id($context/@rid)[self::author-notes 
            										or self::fn/parent::author-notes 
            										or self::corresp/parent::author-notes 
            										or parent::boxed-text[@content-type='author-notes']])
            			and not(id($context/@rid)[self::target/ancestor::author-notes
            										or self::target/ancestor::boxed-text[@content-type='author-notes']])">
               <xsl:call-template name="make-error">   
                  <xsl:with-param name="error-type">xref checking</xsl:with-param>
                  <xsl:with-param name="description">
                     <xsl:call-template name="write-xref-error-description">
                        <xsl:with-param name="xref" select="$context"/>
                        <xsl:with-param name="expected-target" select=
						  "'an author-notes element or a fn or corresp inside author-notes'"/>
                     </xsl:call-template>
                  </xsl:with-param>
               </xsl:call-template>
            </xsl:if>
         </xsl:when>
         
         <xsl:when test="$context/@ref-type='bibr'">
            <xsl:if test="not(id($context/@rid)[self::citation or self::ref or self::note or self::mixed-citation or self::element-citation])">
               <xsl:call-template name="make-error">   
                  <xsl:with-param name="error-type">xref checking</xsl:with-param>
                  <xsl:with-param name="description">
                     <xsl:call-template name="write-xref-error-description">
                        <xsl:with-param name="xref" select="$context"/>
                        <xsl:with-param name="expected-target"
						   select="'a citation or ref element'"/>
                     </xsl:call-template>
                  </xsl:with-param>
               </xsl:call-template>
            </xsl:if>
         </xsl:when>
         
         <xsl:when test="$context/@ref-type='boxed-text'">
            <xsl:if test="not(id($context/@rid)[self::boxed-text])
            			and not(id($context/@rid)[self::target/ancestor::boxed-text])">
               <xsl:call-template name="make-error">   
                  <xsl:with-param name="error-type">xref checking</xsl:with-param>
                  <xsl:with-param name="description">
                     <xsl:call-template name="write-xref-error-description">
                        <xsl:with-param name="xref" select="$context"/>
                        <xsl:with-param name="expected-target"
						   select="'a boxed-text element'"/>
                     </xsl:call-template>
                  </xsl:with-param>
               </xsl:call-template>
            </xsl:if>
         </xsl:when>
         
         <xsl:when test="$context/@ref-type='chem'">
            <xsl:if test="not(id($context/@rid)
			   [self::chem-struct or 
			    self::chem-struct-wrapper or 
			    self::disp-formula or
			    self::disp-formula-group or 
				self::fig or 
				self::supplementary-material])">
               <xsl:call-template name="make-error">   
                  <xsl:with-param name="error-type">xref checking</xsl:with-param>
                  <xsl:with-param name="description">
                     <xsl:call-template name="write-xref-error-description">
                        <xsl:with-param name="xref" select="$context"/>
                        <xsl:with-param name="expected-target" select="concat(
						   'elements of type: chem-struct, chem-struct-wrapper,',
						   ' disp-formula, disp-formual-group, fig, or supplementary-material')"/>
                     </xsl:call-template>
                  </xsl:with-param>
               </xsl:call-template>
            </xsl:if>
         </xsl:when>
         
         <xsl:when test="$context/@ref-type='contrib'">
            <xsl:if test="not(id($context/@rid)[self::contrib])">
               <xsl:call-template name="make-error">   
                  <xsl:with-param name="error-type">xref checking</xsl:with-param>
                  <xsl:with-param name="description">
                     <xsl:call-template name="write-xref-error-description">
                        <xsl:with-param name="xref" select="$context"/>
                        <xsl:with-param name="expected-target"
						   select="'a contrib element'"/>
                     </xsl:call-template>
                  </xsl:with-param>
               </xsl:call-template>
            </xsl:if>
         </xsl:when>
         
         <xsl:when test="$context/@ref-type='corresp'">
            <xsl:if test="not(id($context/@rid)[self::corresp 
            									   or self::fn 
            									   or self::author-notes 
            									   or parent::boxed-text[@content-type='author-notes']])
            			and not(id($context/@rid)[self::target/ancestor::corresp
            										or self::target/ancestor::fn
            										or self::target/ancestor::author-notes
            										or self::target/ancestor::boxed-text[@context-type='author-notes']])">
               <xsl:call-template name="make-error">   
                  <xsl:with-param name="error-type">xref checking</xsl:with-param>
                  <xsl:with-param name="description">
                     <xsl:call-template name="write-xref-error-description">
                        <xsl:with-param name="xref" select="$context"/>
                        <xsl:with-param name="expected-target" select="'a corresp element, a fn element, or an author-notes element'"/>
                     </xsl:call-template>
                  </xsl:with-param>
               </xsl:call-template>
            </xsl:if>
         </xsl:when>
         
         <xsl:when test="$context/@ref-type='disp-formula'">
            <xsl:if test="not(id($context/@rid)[self::disp-formula
            									or self::disp-formula-group 
            									or self::fig 
            									or self::supplementary-material 
            									or self::inline-formula])
            			and not(id($context/@rid)[self::target/ancestor::disp-formula
            									or self::target/ancestor::disp-formula-group
            									or self::target/ancestor::fig
            									or self::target/ancestor::supplementary-material
            									or self::target/ancestor::inline-formula])">
               <xsl:call-template name="make-error">   
                  <xsl:with-param name="error-type">xref checking</xsl:with-param>
                  <xsl:with-param name="description">
                     <xsl:call-template name="write-xref-error-description">
                        <xsl:with-param name="xref" select="$context"/>
                        <xsl:with-param name="expected-target" select="'an element of type disp-formula, disp-formula-group, inline-formula, fig, or supplementary-material'"/>
                     </xsl:call-template>
                  </xsl:with-param>
               </xsl:call-template>
            </xsl:if>
         </xsl:when>
         
         <xsl:when test="$context/@ref-type='fig' or $context/@ref-type='plate' or $context/@ref-type='scheme'">
            <xsl:if test="not(id($context/@rid)[self::fig or self::fig-group])
            			and not(id($context/@rid)[self::target/ancestor::fig or self::target/ancestor::fig-group])">
               <xsl:call-template name="make-error">   
                  <xsl:with-param name="error-type">xref checking</xsl:with-param>
                  <xsl:with-param name="description">
                     <xsl:call-template name="write-xref-error-description">
                        <xsl:with-param name="xref" select="$context"/>
                        <xsl:with-param name="expected-target" select="'a fig or fig-group element'"/>
                     </xsl:call-template>
                  </xsl:with-param>
               </xsl:call-template>
            </xsl:if>
         </xsl:when>
         
         <xsl:when test="$context/@ref-type='fn'">
            <xsl:if test="not(id($context/@rid)[self::fn or self::author-notes])
            			and not(id($context/@rid)[self::target/ancestor::fn or self::target/ancestor::author-notes])">
               <xsl:call-template name="make-error">   
                  <xsl:with-param name="error-type">xref checking</xsl:with-param>
                  <xsl:with-param name="description">
                     <xsl:call-template name="write-xref-error-description">
                        <xsl:with-param name="xref" select="$context"/>
                        <xsl:with-param name="expected-target" select="'a fn element or an author-notes element'"/>
                     </xsl:call-template>
                  </xsl:with-param>
               </xsl:call-template>
            </xsl:if>
         </xsl:when>
         
         <xsl:when test="$context/@ref-type='kwd'">
            <xsl:if test="not(id($context/@rid)[self::kwd or self::kwd-group])
            			and not(id($context/@rid)[self::target/ancestor::kwd or self::target/ancestor::kwd-group])">
               <xsl:call-template name="make-error">   
                  <xsl:with-param name="error-type">xref checking</xsl:with-param>
                  <xsl:with-param name="description">
                     <xsl:call-template name="write-xref-error-description">
                        <xsl:with-param name="xref" select="$context"/>
                        <xsl:with-param name="expected-target" select="'a kwd or kwd-group element'"/>
                     </xsl:call-template>
                  </xsl:with-param>
               </xsl:call-template>
            </xsl:if>
         </xsl:when>
         
		 <!-- Code here previously required a target list-item
			  to in turn contain a list, but the doc doesn't require that.
           -->
         <xsl:when test="$context/@ref-type='list'">
            <xsl:if test="not(id($context/@rid)[self::list 
            									or self::list-item 
            									or self::def-list 
            									or self::def-item 
            									or self::def 
            									or self::glossary 
            									or self::gloss-group])
            			and not(id($context/@rid)[self::target/ancestor::list 
						            			or self::target/ancestor::list-item 
						            			or self::target/ancestor::def-list 
						            			or self::target/ancestor::def-item 
						            			or self::target/ancestor::def 
						            			or self::target/ancestor::glossary 
						            			or self::target/ancestor::gloss-group])">
               <xsl:call-template name="make-error">   
                  <xsl:with-param name="error-type">xref checking</xsl:with-param>
                  <xsl:with-param name="description">
                     <xsl:call-template name="write-xref-error-description">
                        <xsl:with-param name="xref" select="$context"/>
                        <xsl:with-param name="expected-target" select="'an element of type list, list-item, glossary, gloss-group, def-list, or def-item'"/>
                     </xsl:call-template>
                  </xsl:with-param>
               </xsl:call-template>
            </xsl:if>
         </xsl:when>
                               
         <xsl:when test="$context/@ref-type='sec'">
            <xsl:if test="not(id($context/@rid)[self::sec 
            									or self::ack 
            									or self::app 
            									or self::boxed-text 
            									or self::notes 
            									or self::book-part 
										or self::book-part-wrapper 
										or self::front-matter-part
										or self::preface
										or self::foreword
										or self::dedication
            									or self::ref-list])
            			and not(id($context/@rid)[self::target/ancestor::sec 
            									or self::target/ancestor::ack 
            									or self::target/ancestor::app 
            									or self::target/ancestor::boxed-text 
            									or self::target/ancestor::notes 
            									or self::target/ancestor::book-part 
										or self::target/ancestor::book-part-wrapper 
										or self::target/ancestor::front-matter-part
										or self::target/ancestor::preface
										or self::target/ancestor::foreword
										or self::target/ancestor::dedication
            									or self::target/ancestor::ref-list])">
               <xsl:call-template name="make-error">   
                  <xsl:with-param name="error-type">xref checking</xsl:with-param>
                  <xsl:with-param name="description">
                     <xsl:call-template name="write-xref-error-description">
                        <xsl:with-param name="xref" select="$context"/>
                        <xsl:with-param name="expected-target" select="'an element of type sec, ack, app, boxed-text, ref-list, or notes'"/>
                     </xsl:call-template>
                  </xsl:with-param>
               </xsl:call-template>
            </xsl:if>
         </xsl:when>
         
         <xsl:when test="$context/@ref-type='statement'">
            <xsl:if test="not(id($context/@rid)[self::statement])
            			and not(id($context/@rid)[self::target/ancestor::statement])">
               <xsl:call-template name="make-error">   
                  <xsl:with-param name="error-type">xref checking</xsl:with-param>
                  <xsl:with-param name="description">
                     <xsl:call-template name="write-xref-error-description">
                        <xsl:with-param name="xref" select="$context"/>
                        <xsl:with-param name="expected-target"
						   select="'a statement element'"/>
                     </xsl:call-template>
                  </xsl:with-param>
               </xsl:call-template>
            </xsl:if>
         </xsl:when>
         
         <xsl:when test="$context/@ref-type='supplementary-material'">
            <xsl:if test="not(id($context/@rid)[self::supplementary-material
            									or ancestor::supplementary-material
            									or self::sec[@sec-type='supplementary-material']])
            			and not(id($context/@rid)[self::target/ancestor::supplementary-material
            									or ancestor::target/ancestor::supplementary-material
            									or self::target/ancestor::sec[@sec-type='supplementary-material']])">
               <xsl:call-template name="make-error">   
                  <xsl:with-param name="error-type">xref checking</xsl:with-param>
                  <xsl:with-param name="description">
                     <xsl:call-template name="write-xref-error-description">
                        <xsl:with-param name="xref" select="$context"/>
                        <xsl:with-param name="expected-target" select="concat(
						   'a supplementary-material element or its children, ',
						   'or a sec where the sec-type is ',
						   '[supplementary material].')"/>
                     </xsl:call-template>
                  </xsl:with-param>
               </xsl:call-template>
            </xsl:if>
         </xsl:when>
         
         <xsl:when test="$context/@ref-type='table'">
            <xsl:if test="not(id($context/@rid)[self::table-wrap
            									or self::table-wrap-group])
            			and not(id($context/@rid)[self::target/ancestor::table-wrap
            									or self::target/ancestor::table-wrap-group])">
               <xsl:call-template name="make-error">   
                  <xsl:with-param name="error-type">xref checking</xsl:with-param>
                  <xsl:with-param name="description">
                     <xsl:call-template name="write-xref-error-description">
                        <xsl:with-param name="xref" select="$context"/>
                        <xsl:with-param name="expected-target" select=
						   "'a table-wrap or table-wrap-group element'"/>
                     </xsl:call-template>
                  </xsl:with-param>
               </xsl:call-template>
            </xsl:if>
         </xsl:when>
         
         <xsl:when test="$context/@ref-type='table-fn'">
            <xsl:if test="not(id($context/@rid)[(self::fn and ancestor::table-wrap) 
            									or self::td])
            			and not(id($context/@rid)[(self::target/ancestor::fn and ancestor::table-wrap) 
            									or self::target/ancestor::td])">
               <xsl:call-template name="make-error">   
                  <xsl:with-param name="error-type">xref checking</xsl:with-param>
                  <xsl:with-param name="description">
                     <xsl:call-template name="write-xref-error-description">
                        <xsl:with-param name="xref" select="$context"/>
                        <xsl:with-param name="expected-target"
						   select="'a fn element inside a table-wrap or a td'"/>
                     </xsl:call-template>
                  </xsl:with-param>
               </xsl:call-template>
            </xsl:if>
         </xsl:when>            
      </xsl:choose>
   </xsl:template> <!-- xref-check -->



   <!-- *********************************************************** -->
   <!-- Template: year-check  
   
        Outside of citation elements be sure that year 
        elements only contain an integer value 
        between 1700 and 2100, inclusive.
     -->
   <!-- *********************************************************** -->
   <xsl:template name="year-check">
      <xsl:param name="context" select="."/>
      
      <xsl:choose>
         <xsl:when test="$context/ancestor::citation
         			  or $context/ancestor::nlm-citation
         			  or $context/ancestor::mixed-citation
         			  or $context/ancestor::element-citation
	                  or $context/ancestor::product">
            <!-- Don't test these -->
				</xsl:when>
         <xsl:otherwise>
            <xsl:variable name="is-valid-year">
               <xsl:call-template name="is-year">
                  <xsl:with-param name="input">
							<xsl:choose>
								<xsl:when test="string-length(translate($context,'abcdefghijklmnopqrstuvwxyz','')) &lt; string-length($context)">
									<xsl:value-of select="string(translate($context,'abcdefghijklmnopqrstuvwxyz',''))"/>
									</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="string($context)"/>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:with-param>
               </xsl:call-template>
            </xsl:variable>
            
            <xsl:if test="$is-valid-year = 'false'">
               <xsl:call-template name="make-error">
                  <xsl:with-param name="error-type" select="'year check'"/>
                  <xsl:with-param name="description" select="concat(
                     'year element should contain a numeric value ',
					 'between 1700 and 2100, inclusive, not [', $context,
					 '].')"/>
				<xsl:with-param name="tg-target" select="'tags.html#el-year'"/>
               </xsl:call-template>
            </xsl:if>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>


</xsl:stylesheet>
