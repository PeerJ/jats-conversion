<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet 
   xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
   xmlns:xlink="http://www.w3.org/1999/xlink" 
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
   xmlns:mml="http://www.w3.org/1998/Math/MathML" 
   xmlns:ali="http://www.niso.org/schemas/ali/1.0/"
   version="1.0">
   


<!-- ######################## HELPER TEMPLATES ############################## -->
<!--
      Templates for 'everything else'.
  -->
<!-- ######################################################################## -->

   
   <!-- ********************************************* -->
   <!-- Template: node() | @* 
        Mode: output
        
        Copy all nodes and attributes to output after
        being checked by special processing rules.    -->
   <!-- ********************************************* -->   
   <xsl:template match="* | @*" mode="output">
      <xsl:copy>
         <xsl:apply-templates select="@*"/>
         <xsl:apply-templates />
      </xsl:copy>
   </xsl:template>
	
	<xsl:template match="@xsi:noNamespaceSchemaLocation"/>


   <!-- ********************************************* -->
   <!-- Template: node() | @* 
        
        Copy all nodes and attributes to output that
        do not have special processing rules
     -->
   <!-- ********************************************* -->   
   <xsl:template match="* | @*">
      <xsl:copy>
         <!-- Copy out all attributes -->
         <xsl:apply-templates select="@*"/>
         
         <!-- Copy all children -->
         <xsl:apply-templates />
      </xsl:copy>
   </xsl:template>



   <!-- ********************************************************************* -->
   <!-- Template: make-error
        
        Outputs an error or warning element with the provided
	    type and description. 

        PARAMS:
		   error-type    
		   description   Long text of error message  
		   class         "error": style-check should fail (the default).
		                 "warning": style-check can still pass.
						 other value: the message becomes a "warning",
						 and a note is added warning about the bad value.
		                 This is done to guard against typing mistakes.
     -->
   <!-- ********************************************************************* -->
   <xsl:template name="make-error">
      <xsl:param name="error-type"  select="''"/>
      <xsl:param name="description" select="''"/>
      <xsl:param name="tg-target" select="''"/>
      <xsl:param name="class"       select="'error'"/>
     
      <xsl:variable name="class-type">
         <xsl:choose>
            <xsl:when test="$class = 'error'">
               <xsl:text>error</xsl:text>
            </xsl:when>
            <xsl:otherwise>
               <xsl:text>warning</xsl:text>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>

	<xsl:variable name="errpath">
	<xsl:for-each select="ancestor-or-self::*">
		<xsl:variable name="name" select="name()"/>
    	<xsl:text/>/<xsl:value-of select="name()"/><xsl:text/>
		<xsl:choose>
			<xsl:when test="@id">
				<xsl:text>[</xsl:text>
				<xsl:value-of select="concat('@id=&quot;',@id,'&quot;')"/>
				<xsl:text>]</xsl:text>
				</xsl:when>
				
			<xsl:when test="preceding-sibling::node()[name()=$name]">
				<xsl:text>[</xsl:text>
				<xsl:value-of select="count(preceding-sibling::node()[name()=$name])+1"/>
				<xsl:text>]</xsl:text>
				</xsl:when>
			</xsl:choose>
	</xsl:for-each>
		</xsl:variable>


      <!-- Make sure have all needed values, otherwise don't output -->
      <xsl:if test="string-length($error-type) &gt; 0 and
	                string-length($description) &gt; 0">
         <xsl:element name="{$class-type}">
			<xsl:choose>
				<xsl:when test="$notices='yes'">
					<xsl:attribute name="notice">
					<xsl:value-of select="concat('sc:',translate(normalize-space($error-type),' ','_'))"/>
						</xsl:attribute>
					</xsl:when>
					<xsl:otherwise>
            		<xsl:value-of select="normalize-space($error-type)"/>
            		<xsl:text>: </xsl:text>
						</xsl:otherwise>
					</xsl:choose>
            <xsl:value-of select="$description"/>
				<xsl:if test="$stream='manuscript'">
					<xsl:text> (</xsl:text>
					<xsl:value-of select="$errpath"/>
					<xsl:text>)</xsl:text>
					</xsl:if>
         <xsl:if test="string-length($tg-target) &gt; 0">
				<xsl:call-template name="tglink">
					<xsl:with-param name="tg-target" select="$tg-target"/>
					</xsl:call-template>
				</xsl:if>
         </xsl:element>
         
         <xsl:call-template name="output-message">
            <xsl:with-param name="class" select="$class-type"/>
            <xsl:with-param name="errpath" select="$errpath"/>
            <xsl:with-param name="description">
			   <xsl:value-of select="$description"/>
			   <xsl:if test="$class!='error' and $class!='warning'">
			      <xsl:text>   *** Error class was neither 'error' nor 'warning' ***   </xsl:text>
			   </xsl:if>
			</xsl:with-param>
            <xsl:with-param name="type" select="$error-type"/>
         </xsl:call-template>
      </xsl:if>    
   </xsl:template> 

	<xsl:template name="tglink">
		<xsl:param name="tg-target"/>
		<xsl:variable name="base">
			<xsl:choose>
				<xsl:when test="$stream='book'">
					<xsl:value-of select="'https://www.ncbi.nlm.nih.gov/pmc/pmcdoc/tagging-guidelines/book/'"/>
					</xsl:when>
				<xsl:when test="$stream='manuscript'">
					<xsl:value-of select="'https://www.ncbi.nlm.nih.gov/pmc/pmcdoc/tagging-guidelines/manuscript/'"/>
					</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="'https://www.ncbi.nlm.nih.gov/pmc/pmcdoc/tagging-guidelines/article/'"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
		<xsl:text> </xsl:text>
		<tlink>
			<xsl:attribute name="target">	
				<xsl:value-of select="concat($base,$tg-target)"/>
				</xsl:attribute>
			<xsl:text>(Tagging Guidelines)</xsl:text>
		</tlink>
		</xsl:template>
				
		

   <!-- ********************************************************************* -->
   <!-- TEMPLATE: output-message
        Takes an error message and outputs it. Does nothing if $messages
	    global is set to false or if the xsl:message element is not available.
        
        PARAMS:
		   class, description, type: (as for make-error)
           -path: path to output the error log (Eh? No such param)
		CALLED:   Only from make-error, above.
     -->
   <!-- ********************************************************************* -->
   <xsl:template name="output-message">
      <xsl:param name="class" select="'error'"/>
      <xsl:param name="description" select="''"/>
      <xsl:param name="errpath" />
      <xsl:param name="type" select="''"/>
      
      <!--<xsl:variable name="descriptor">
         <xsl:choose>
            <xsl:when test="$class='warning'">
               <xsl:text> (warning)</xsl:text>
            </xsl:when>

            <xsl:otherwise>
               <xsl:text></xsl:text>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      
      <xsl:if test="element-available('xsl:message') and $messages = 'true'">
         <xsl:message terminate="no">
            <xsl:value-of select="concat($type, $descriptor)"/>
            <xsl:text>: </xsl:text>
            <xsl:value-of select="$description"/>
				<xsl:if test="$errpath!=''">
					<xsl:text> (</xsl:text>
					<xsl:value-of select="$errpath"/>
					<xsl:text>)</xsl:text>
					<!-\-</xsl:if>-\->
            <xsl:text disable-output-escaping="yes">&#10;</xsl:text>
         </xsl:message>
      </xsl:if>-->
   </xsl:template>

		
			
			
   <!-- ********************************************************************* -->
   <!-- Template: text(), and 
                  NAMED check-prohibited-math-characters-outside-math-context

        Scans all text nodes for prohibited characters, outside math context
        
     -->
   <!-- ********************************************************************* -->
   <!-- ********************************************************************* -->
	
	<xsl:template name="check-prohibited-math-characters-outside-math-context">
		<!-- keeping this as the template is called from a importing secondary checker for books -->
	</xsl:template>
	
   <!-- <xsl:template match="text()" name="check-prohibited-math-characters-outside-math-context">

        <!-/- are we in math context ?-/->
   	  <xsl:if test="not(ancestor::node()[local-name() = 'math'
					    or local-name() = 'inline-formula'
					    or local-name() = 'disp-formula'
					    or local-name() = 'tex-math'])">

            <!-/- here you can list using "OR" a banch of contains function calls 
                to check prohibited  characters.  -/->
            <xsl:if test="contains(., '&#xFE37;')">
                
                <xsl:call-template name="make-error">
                  <xsl:with-param name="error-type" select="'math character check'"/>
                  <xsl:with-param name="description">
                     <xsl:text>prohibited character is being used outside of math context in this node.</xsl:text>
                  </xsl:with-param>
                </xsl:call-template>

      	    </xsl:if>

	  </xsl:if>

      <!-/- If we are in the text() node copy its content to the output, 
           otherwise we're in the attribute node, and we do not do output here, 
           because it is done in other place. -/->
      <xsl:if test="(name(.)='')">
         <xsl:copy-of select="."/>
      </xsl:if>
   </xsl:template> -->


   <!-- ********************************************************************* -->
   <!-- <xsl:template match="@*" mode="check-prohibited-math-characters-outside-math-context">
      <xsl:call-template name="check-prohibited-math-characters-outside-math-context"/>
   </xsl:template> -->


	<xsl:template name="capitalize">
		<xsl:param name="str"/>
		<xsl:value-of select="translate($str, 'abcdefghijklmnopqrstuvwxyz', 'ABCDEFGHIJKLMNOPQRSTUVWXYZ')"/>
		</xsl:template>

	<xsl:template name="knockdown">
		<xsl:param name="str"/>
		<xsl:value-of select="translate($str,'ABCDEFGHIJKLMNOPQRSTUVWXYZ','abcdefghijklmnopqrstuvwxyz')"/>
		</xsl:template>

    <!-- ==================================================================== -->
    <!-- TEMPLATE: replace-substring

   Removes/replaces all occurrences of a 'substring' in the original string.
   If no replacement is specified, then the specified substring
   is removed. If no substring is specified or the substring is
   an empty string, then the template simply returns the original string.
         
   Parameters:
      main-string: main string to operate on
      substring: substring to locate in main string
      replacement: replacement string for the substring 
   -->
    <!-- ==================================================================== -->
    <xsl:template name="replace-substring">
        <xsl:param name="main-string"/>
        <xsl:param name="substring"/>
        <xsl:param name="replacement"/>
       
        <xsl:choose>
           <!-- Error case -->
           <xsl:when test="not($substring)">
              <xsl:value-of select="$main-string"/>
           </xsl:when>
            
           <!-- Base Case: no more substrings to remove -->
           <xsl:when test="not(contains($main-string, $substring))">
              <xsl:value-of select="$main-string"/>
           </xsl:when>
                    
           <!-- Case 1: Substring is in the main string -->
           <xsl:otherwise>
              <xsl:value-of select="substring-before($main-string, $substring )"/>
              <xsl:value-of select="$replacement"/>
              <xsl:call-template name="replace-substring">
                 <xsl:with-param name="main-string"
                    select="substring-after($main-string, $substring)"/>
                 <xsl:with-param name="substring" select="$substring"/>
                 <xsl:with-param name="replacement" select="$replacement"/>
              </xsl:call-template>
           </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- ==================================================================== -->
    <!-- TEMPLATE: is-in-list (aka contains-token)
        PARAMS:
           list   String containing list of acceptable items
           token  Token to look for in list
           case   Regard case when matching (default = 0 = ignore)
           delim  Char that separates items in list (default = ' ')
        NOTES:    Return 1 if $token occurs in $list (say, of month-names).
                  Tokens in $list must be separated by spaces, unless
                     a different char or string is specified in $delim.
                  Unless $case is true, case will be ignored.
        WARNING:  If $token = '', returns nil.
        ADDED:    sjd, ~2006-10.
     -->
    <!-- ==================================================================== -->
    <xsl:template name="is-in-list">
      <xsl:param name="list"/>
      <xsl:param name="token"/>
      <xsl:param name="case"  select="0"/>
      <xsl:param name="delim" select="' '"/>

      <!-- Make sure the list of tokens is capped if needed, and has delims -->
      <xsl:variable name="myList">
         <xsl:choose>
            <xsl:when test="$case">
               <xsl:value-of select="concat($delim,$list,$delim)"/>
            </xsl:when>
            <xsl:otherwise>
               <xsl:call-template name="capitalize">
                  <xsl:with-param name="str"
                      select="concat($delim,$list,$delim)"/>
               </xsl:call-template>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>

      <!-- Same for token to look for (exactly one delim at each end) -->
      <xsl:variable name="myToken">
         <xsl:if test="substring($token,1,1)!=$delim">
            <xsl:value-of select="$delim"/>
         </xsl:if>
         <xsl:choose>
            <xsl:when test="$case">
               <xsl:value-of select="$token"/>
            </xsl:when>
            <xsl:otherwise>
               <xsl:call-template name="capitalize">
                  <xsl:with-param name="str" select="$token"/>
               </xsl:call-template>
            </xsl:otherwise>
         </xsl:choose>
         <xsl:if test="substring($token,string-length($token))!=$delim">
            <xsl:value-of select="$delim"/>
         </xsl:if>
      </xsl:variable>

      <!-- Now that we're normalized, the test is easy -->
      <xsl:if test="$myToken!='' and contains($myList,$myToken)">1</xsl:if>
    </xsl:template>


   <!-- Outputs the substring after the last dot in the input string -->
   <xsl:template name="substring-after-last-dot">
      <xsl:param name="str"/>
      <xsl:if test="$str">
         <xsl:choose>
            <xsl:when test="contains($str,'.')">
               <xsl:call-template name="substring-after-last-dot">
                  <xsl:with-param name="str"
                     select="substring-after($str,'.')"/>
               </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
               <xsl:value-of select="$str"/>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:if>
   </xsl:template>

<xsl:template name="get-context">
	<xsl:text>(context: </xsl:text>
	<xsl:choose>
		<xsl:when test="@id">
			<xsl:value-of select="name()"/>
			<xsl:text>[@id="</xsl:text>
			<xsl:value-of select="@id"/>
			<xsl:text>"]</xsl:text>
			</xsl:when>
		<xsl:otherwise>
			<xsl:call-template name="nodePath"/>
			</xsl:otherwise>
		</xsl:choose>
	<xsl:text> )</xsl:text>
	</xsl:template>

	<xsl:template name="nodePath">
		<xsl:for-each select="ancestor-or-self::*">
			<xsl:variable name="nm" select="name()"/>
			<xsl:variable name="pos" select="count(preceding-sibling::node()[name() = $nm])"/>
			<xsl:variable name="more" select="count(following-sibling::node()[name() = $nm])"/>
			<xsl:variable name="poslabel">
				<xsl:if test="($pos + 1 &gt; 1) or ($more &gt; 0)">
					<xsl:text>[</xsl:text><xsl:value-of select="$pos + 1"/><xsl:text>]</xsl:text>
					</xsl:if>
				</xsl:variable>

            <xsl:choose>
               <xsl:when test="name() = 'warning'">
                  <xsl:text>/error</xsl:text>
               </xsl:when>
               
               <xsl:otherwise>
                  <xsl:value-of select="concat('/',name(),$poslabel)"/>               
               </xsl:otherwise>
            </xsl:choose>
		</xsl:for-each>
		</xsl:template>
	
	<xsl:template name="canonical-cc-license-urls">
		<!-- list of canonical cc license urls as provided by cc with publicdomain/mark/1.0 added  -->
		<xsl:value-of
			select="
				concat(
				' creativecommons.org/licenses/by-nc-nd/4.0',
				' creativecommons.org/licenses/by-nc-sa/4.0',
				' creativecommons.org/licenses/by-nc/4.0',
				' creativecommons.org/licenses/by-nd/4.0',
				' creativecommons.org/licenses/by-sa/4.0',
				' creativecommons.org/licenses/by/4.0',
				
				' creativecommons.org/licenses/by-nc-nd/3.0',
				' creativecommons.org/licenses/by-nc-nd/3.0/am',
				' creativecommons.org/licenses/by-nc-nd/3.0/at',
				' creativecommons.org/licenses/by-nc-nd/3.0/au',
				' creativecommons.org/licenses/by-nc-nd/3.0/az',
				' creativecommons.org/licenses/by-nc-nd/3.0/br',
				' creativecommons.org/licenses/by-nc-nd/3.0/ca',
				' creativecommons.org/licenses/by-nc-nd/3.0/ch',
				' creativecommons.org/licenses/by-nc-nd/3.0/cl',
				' creativecommons.org/licenses/by-nc-nd/3.0/cn',
				' creativecommons.org/licenses/by-nc-nd/3.0/cr',
				' creativecommons.org/licenses/by-nc-nd/3.0/cz',
				' creativecommons.org/licenses/by-nc-nd/3.0/de',
				' creativecommons.org/licenses/by-nc-nd/3.0/ec',
				' creativecommons.org/licenses/by-nc-nd/3.0/ee',
				' creativecommons.org/licenses/by-nc-nd/3.0/eg',
				' creativecommons.org/licenses/by-nc-nd/3.0/es',
				' creativecommons.org/licenses/by-nc-nd/3.0/fr',
				' creativecommons.org/licenses/by-nc-nd/3.0/ge',
				' creativecommons.org/licenses/by-nc-nd/3.0/gr',
				' creativecommons.org/licenses/by-nc-nd/3.0/gt',
				' creativecommons.org/licenses/by-nc-nd/3.0/hk',
				' creativecommons.org/licenses/by-nc-nd/3.0/hr',
				' creativecommons.org/licenses/by-nc-nd/3.0/ie',
				' creativecommons.org/licenses/by-nc-nd/3.0/igo',
				' creativecommons.org/licenses/by-nc-nd/3.0/it',
				' creativecommons.org/licenses/by-nc-nd/3.0/lu',
				' creativecommons.org/licenses/by-nc-nd/3.0/nl',
				' creativecommons.org/licenses/by-nc-nd/3.0/no',
				' creativecommons.org/licenses/by-nc-nd/3.0/nz',
				' creativecommons.org/licenses/by-nc-nd/3.0/ph',
				' creativecommons.org/licenses/by-nc-nd/3.0/pl',
				' creativecommons.org/licenses/by-nc-nd/3.0/pr',
				' creativecommons.org/licenses/by-nc-nd/3.0/pt',
				' creativecommons.org/licenses/by-nc-nd/3.0/ro',
				' creativecommons.org/licenses/by-nc-nd/3.0/rs',
				' creativecommons.org/licenses/by-nc-nd/3.0/sg',
				' creativecommons.org/licenses/by-nc-nd/3.0/th',
				' creativecommons.org/licenses/by-nc-nd/3.0/tw',
				' creativecommons.org/licenses/by-nc-nd/3.0/ug',
				' creativecommons.org/licenses/by-nc-nd/3.0/us',
				' creativecommons.org/licenses/by-nc-nd/3.0/ve',
				' creativecommons.org/licenses/by-nc-nd/3.0/vn',
				' creativecommons.org/licenses/by-nc-nd/3.0/za',
				
				' creativecommons.org/licenses/by-nc-sa/3.0',
				' creativecommons.org/licenses/by-nc-sa/3.0/am',
				' creativecommons.org/licenses/by-nc-sa/3.0/at',
				' creativecommons.org/licenses/by-nc-sa/3.0/au',
				' creativecommons.org/licenses/by-nc-sa/3.0/az',
				' creativecommons.org/licenses/by-nc-sa/3.0/br',
				' creativecommons.org/licenses/by-nc-sa/3.0/ca',
				' creativecommons.org/licenses/by-nc-sa/3.0/ch',
				' creativecommons.org/licenses/by-nc-sa/3.0/cl',
				' creativecommons.org/licenses/by-nc-sa/3.0/cn',
				' creativecommons.org/licenses/by-nc-sa/3.0/cr',
				' creativecommons.org/licenses/by-nc-sa/3.0/cz',
				' creativecommons.org/licenses/by-nc-sa/3.0/de',
				' creativecommons.org/licenses/by-nc-sa/3.0/ec',
				' creativecommons.org/licenses/by-nc-sa/3.0/ee',
				' creativecommons.org/licenses/by-nc-sa/3.0/eg',
				' creativecommons.org/licenses/by-nc-sa/3.0/es',
				' creativecommons.org/licenses/by-nc-sa/3.0/fr',
				' creativecommons.org/licenses/by-nc-sa/3.0/ge',
				' creativecommons.org/licenses/by-nc-sa/3.0/gr',
				' creativecommons.org/licenses/by-nc-sa/3.0/gt',
				' creativecommons.org/licenses/by-nc-sa/3.0/hk',
				' creativecommons.org/licenses/by-nc-sa/3.0/hr',
				' creativecommons.org/licenses/by-nc-sa/3.0/ie',
				' creativecommons.org/licenses/by-nc-sa/3.0/igo',
				' creativecommons.org/licenses/by-nc-sa/3.0/it',
				' creativecommons.org/licenses/by-nc-sa/3.0/lu',
				' creativecommons.org/licenses/by-nc-sa/3.0/nl',
				' creativecommons.org/licenses/by-nc-sa/3.0/no',
				' creativecommons.org/licenses/by-nc-sa/3.0/nz',
				' creativecommons.org/licenses/by-nc-sa/3.0/ph',
				' creativecommons.org/licenses/by-nc-sa/3.0/pl',
				' creativecommons.org/licenses/by-nc-sa/3.0/pr',
				' creativecommons.org/licenses/by-nc-sa/3.0/pt',
				' creativecommons.org/licenses/by-nc-sa/3.0/ro',
				' creativecommons.org/licenses/by-nc-sa/3.0/rs',
				' creativecommons.org/licenses/by-nc-sa/3.0/sg',
				' creativecommons.org/licenses/by-nc-sa/3.0/th',
				' creativecommons.org/licenses/by-nc-sa/3.0/tw',
				' creativecommons.org/licenses/by-nc-sa/3.0/ug',
				' creativecommons.org/licenses/by-nc-sa/3.0/us',
				' creativecommons.org/licenses/by-nc-sa/3.0/ve',
				' creativecommons.org/licenses/by-nc-sa/3.0/vn',
				' creativecommons.org/licenses/by-nc-sa/3.0/za',
				
				' creativecommons.org/licenses/by-nc/3.0',
				' creativecommons.org/licenses/by-nc/3.0/am',
				' creativecommons.org/licenses/by-nc/3.0/at',
				' creativecommons.org/licenses/by-nc/3.0/au',
				' creativecommons.org/licenses/by-nc/3.0/az',
				' creativecommons.org/licenses/by-nc/3.0/br',
				' creativecommons.org/licenses/by-nc/3.0/ca',
				' creativecommons.org/licenses/by-nc/3.0/ch',
				' creativecommons.org/licenses/by-nc/3.0/cl',
				' creativecommons.org/licenses/by-nc/3.0/cn',
				' creativecommons.org/licenses/by-nc/3.0/cr',
				' creativecommons.org/licenses/by-nc/3.0/cz',
				' creativecommons.org/licenses/by-nc/3.0/de',
				' creativecommons.org/licenses/by-nc/3.0/ec',
				' creativecommons.org/licenses/by-nc/3.0/ee',
				' creativecommons.org/licenses/by-nc/3.0/eg',
				' creativecommons.org/licenses/by-nc/3.0/es',
				' creativecommons.org/licenses/by-nc/3.0/fr',
				' creativecommons.org/licenses/by-nc/3.0/ge',
				' creativecommons.org/licenses/by-nc/3.0/gr',
				' creativecommons.org/licenses/by-nc/3.0/gt',
				' creativecommons.org/licenses/by-nc/3.0/hk',
				' creativecommons.org/licenses/by-nc/3.0/hr',
				' creativecommons.org/licenses/by-nc/3.0/ie',
				' creativecommons.org/licenses/by-nc/3.0/igo',
				' creativecommons.org/licenses/by-nc/3.0/it',
				' creativecommons.org/licenses/by-nc/3.0/lu',
				' creativecommons.org/licenses/by-nc/3.0/nl',
				' creativecommons.org/licenses/by-nc/3.0/no',
				' creativecommons.org/licenses/by-nc/3.0/nz',
				' creativecommons.org/licenses/by-nc/3.0/ph',
				' creativecommons.org/licenses/by-nc/3.0/pl',
				' creativecommons.org/licenses/by-nc/3.0/pr',
				' creativecommons.org/licenses/by-nc/3.0/pt',
				' creativecommons.org/licenses/by-nc/3.0/ro',
				' creativecommons.org/licenses/by-nc/3.0/rs',
				' creativecommons.org/licenses/by-nc/3.0/sg',
				' creativecommons.org/licenses/by-nc/3.0/th',
				' creativecommons.org/licenses/by-nc/3.0/tw',
				' creativecommons.org/licenses/by-nc/3.0/ug',
				' creativecommons.org/licenses/by-nc/3.0/us',
				' creativecommons.org/licenses/by-nc/3.0/ve',
				' creativecommons.org/licenses/by-nc/3.0/vn',
				' creativecommons.org/licenses/by-nc/3.0/za',
				
				' creativecommons.org/licenses/by-nd/3.0',
				' creativecommons.org/licenses/by-nd/3.0/am',
				' creativecommons.org/licenses/by-nd/3.0/at',
				' creativecommons.org/licenses/by-nd/3.0/au',
				' creativecommons.org/licenses/by-nd/3.0/az',
				' creativecommons.org/licenses/by-nd/3.0/br',
				' creativecommons.org/licenses/by-nd/3.0/ca',
				' creativecommons.org/licenses/by-nd/3.0/ch',
				' creativecommons.org/licenses/by-nd/3.0/cl',
				' creativecommons.org/licenses/by-nd/3.0/cn',
				' creativecommons.org/licenses/by-nd/3.0/cr',
				' creativecommons.org/licenses/by-nd/3.0/cz',
				' creativecommons.org/licenses/by-nd/3.0/de',
				' creativecommons.org/licenses/by-nd/3.0/ec',
				' creativecommons.org/licenses/by-nd/3.0/ee',
				' creativecommons.org/licenses/by-nd/3.0/eg',
				' creativecommons.org/licenses/by-nd/3.0/es',
				' creativecommons.org/licenses/by-nd/3.0/fr',
				' creativecommons.org/licenses/by-nd/3.0/ge',
				' creativecommons.org/licenses/by-nd/3.0/gr',
				' creativecommons.org/licenses/by-nd/3.0/gt',
				' creativecommons.org/licenses/by-nd/3.0/hk',
				' creativecommons.org/licenses/by-nd/3.0/hr',
				' creativecommons.org/licenses/by-nd/3.0/ie',
				' creativecommons.org/licenses/by-nd/3.0/igo',
				' creativecommons.org/licenses/by-nd/3.0/it',
				' creativecommons.org/licenses/by-nd/3.0/lu',
				' creativecommons.org/licenses/by-nd/3.0/nl',
				' creativecommons.org/licenses/by-nd/3.0/no',
				' creativecommons.org/licenses/by-nd/3.0/nz',
				' creativecommons.org/licenses/by-nd/3.0/ph',
				' creativecommons.org/licenses/by-nd/3.0/pl',
				' creativecommons.org/licenses/by-nd/3.0/pr',
				' creativecommons.org/licenses/by-nd/3.0/pt',
				' creativecommons.org/licenses/by-nd/3.0/ro',
				' creativecommons.org/licenses/by-nd/3.0/rs',
				' creativecommons.org/licenses/by-nd/3.0/sg',
				' creativecommons.org/licenses/by-nd/3.0/th',
				' creativecommons.org/licenses/by-nd/3.0/tw',
				' creativecommons.org/licenses/by-nd/3.0/ug',
				' creativecommons.org/licenses/by-nd/3.0/us',
				' creativecommons.org/licenses/by-nd/3.0/ve',
				' creativecommons.org/licenses/by-nd/3.0/vn',
				' creativecommons.org/licenses/by-nd/3.0/za',
				
				' creativecommons.org/licenses/by-sa/3.0',
				' creativecommons.org/licenses/by-sa/3.0/am',
				' creativecommons.org/licenses/by-sa/3.0/at',
				' creativecommons.org/licenses/by-sa/3.0/au',
				' creativecommons.org/licenses/by-sa/3.0/az',
				' creativecommons.org/licenses/by-sa/3.0/br',
				' creativecommons.org/licenses/by-sa/3.0/ca',
				' creativecommons.org/licenses/by-sa/3.0/ch',
				' creativecommons.org/licenses/by-sa/3.0/cl',
				' creativecommons.org/licenses/by-sa/3.0/cn',
				' creativecommons.org/licenses/by-sa/3.0/cr',
				' creativecommons.org/licenses/by-sa/3.0/cz',
				' creativecommons.org/licenses/by-sa/3.0/de',
				' creativecommons.org/licenses/by-sa/3.0/ec',
				' creativecommons.org/licenses/by-sa/3.0/ee',
				' creativecommons.org/licenses/by-sa/3.0/eg',
				' creativecommons.org/licenses/by-sa/3.0/es',
				' creativecommons.org/licenses/by-sa/3.0/fr',
				' creativecommons.org/licenses/by-sa/3.0/ge',
				' creativecommons.org/licenses/by-sa/3.0/gr',
				' creativecommons.org/licenses/by-sa/3.0/gt',
				' creativecommons.org/licenses/by-sa/3.0/hk',
				' creativecommons.org/licenses/by-sa/3.0/hr',
				' creativecommons.org/licenses/by-sa/3.0/ie',
				' creativecommons.org/licenses/by-sa/3.0/igo',
				' creativecommons.org/licenses/by-sa/3.0/it',
				' creativecommons.org/licenses/by-sa/3.0/lu',
				' creativecommons.org/licenses/by-sa/3.0/nl',
				' creativecommons.org/licenses/by-sa/3.0/no',
				' creativecommons.org/licenses/by-sa/3.0/nz',
				' creativecommons.org/licenses/by-sa/3.0/ph',
				' creativecommons.org/licenses/by-sa/3.0/pl',
				' creativecommons.org/licenses/by-sa/3.0/pr',
				' creativecommons.org/licenses/by-sa/3.0/pt',
				' creativecommons.org/licenses/by-sa/3.0/ro',
				' creativecommons.org/licenses/by-sa/3.0/rs',
				' creativecommons.org/licenses/by-sa/3.0/sg',
				' creativecommons.org/licenses/by-sa/3.0/th',
				' creativecommons.org/licenses/by-sa/3.0/tw',
				' creativecommons.org/licenses/by-sa/3.0/ug',
				' creativecommons.org/licenses/by-sa/3.0/us',
				' creativecommons.org/licenses/by-sa/3.0/ve',
				' creativecommons.org/licenses/by-sa/3.0/vn',
				' creativecommons.org/licenses/by-sa/3.0/za',
				
				' creativecommons.org/licenses/by/3.0',
				' creativecommons.org/licenses/by/3.0/am',
				' creativecommons.org/licenses/by/3.0/at',
				' creativecommons.org/licenses/by/3.0/au',
				' creativecommons.org/licenses/by/3.0/az',
				' creativecommons.org/licenses/by/3.0/br',
				' creativecommons.org/licenses/by/3.0/ca',
				' creativecommons.org/licenses/by/3.0/ch',
				' creativecommons.org/licenses/by/3.0/cl',
				' creativecommons.org/licenses/by/3.0/cn',
				' creativecommons.org/licenses/by/3.0/cr',
				' creativecommons.org/licenses/by/3.0/cz',
				' creativecommons.org/licenses/by/3.0/de',
				' creativecommons.org/licenses/by/3.0/ec',
				' creativecommons.org/licenses/by/3.0/ee',
				' creativecommons.org/licenses/by/3.0/eg',
				' creativecommons.org/licenses/by/3.0/es',
				' creativecommons.org/licenses/by/3.0/fr',
				' creativecommons.org/licenses/by/3.0/ge',
				' creativecommons.org/licenses/by/3.0/gr',
				' creativecommons.org/licenses/by/3.0/gt',
				' creativecommons.org/licenses/by/3.0/hk',
				' creativecommons.org/licenses/by/3.0/hr',
				' creativecommons.org/licenses/by/3.0/ie',
				' creativecommons.org/licenses/by/3.0/igo',
				' creativecommons.org/licenses/by/3.0/it',
				' creativecommons.org/licenses/by/3.0/lu',
				' creativecommons.org/licenses/by/3.0/nl',
				' creativecommons.org/licenses/by/3.0/no',
				' creativecommons.org/licenses/by/3.0/nz',
				' creativecommons.org/licenses/by/3.0/ph',
				' creativecommons.org/licenses/by/3.0/pl',
				' creativecommons.org/licenses/by/3.0/pr',
				' creativecommons.org/licenses/by/3.0/pt',
				' creativecommons.org/licenses/by/3.0/ro',
				' creativecommons.org/licenses/by/3.0/rs',
				' creativecommons.org/licenses/by/3.0/sg',
				' creativecommons.org/licenses/by/3.0/th',
				' creativecommons.org/licenses/by/3.0/tw',
				' creativecommons.org/licenses/by/3.0/ug',
				' creativecommons.org/licenses/by/3.0/us',
				' creativecommons.org/licenses/by/3.0/ve',
				' creativecommons.org/licenses/by/3.0/vn',
				' creativecommons.org/licenses/by/3.0/za',
				
				' creativecommons.org/licenses/by-nc-nd/2.5',
				' creativecommons.org/licenses/by-nc-nd/2.5/ar',
				' creativecommons.org/licenses/by-nc-nd/2.5/au',
				' creativecommons.org/licenses/by-nc-nd/2.5/bg',
				' creativecommons.org/licenses/by-nc-nd/2.5/br',
				' creativecommons.org/licenses/by-nc-nd/2.5/ca',
				' creativecommons.org/licenses/by-nc-nd/2.5/ch',
				' creativecommons.org/licenses/by-nc-nd/2.5/cn',
				' creativecommons.org/licenses/by-nc-nd/2.5/co',
				' creativecommons.org/licenses/by-nc-nd/2.5/dk',
				' creativecommons.org/licenses/by-nc-nd/2.5/es',
				' creativecommons.org/licenses/by-nc-nd/2.5/hr',
				' creativecommons.org/licenses/by-nc-nd/2.5/hu',
				' creativecommons.org/licenses/by-nc-nd/2.5/il',
				' creativecommons.org/licenses/by-nc-nd/2.5/in',
				' creativecommons.org/licenses/by-nc-nd/2.5/it',
				' creativecommons.org/licenses/by-nc-nd/2.5/mk',
				' creativecommons.org/licenses/by-nc-nd/2.5/mt',
				' creativecommons.org/licenses/by-nc-nd/2.5/mx',
				' creativecommons.org/licenses/by-nc-nd/2.5/my',
				' creativecommons.org/licenses/by-nc-nd/2.5/nl',
				' creativecommons.org/licenses/by-nc-nd/2.5/pe',
				' creativecommons.org/licenses/by-nc-nd/2.5/pl',
				' creativecommons.org/licenses/by-nc-nd/2.5/pt',
				' creativecommons.org/licenses/by-nc-nd/2.5/scotland',
				' creativecommons.org/licenses/by-nc-nd/2.5/se',
				' creativecommons.org/licenses/by-nc-nd/2.5/si',
				' creativecommons.org/licenses/by-nc-nd/2.5/tw',
				' creativecommons.org/licenses/by-nc-nd/2.5/za',
				
				' creativecommons.org/licenses/by-nc-sa/2.5',
				' creativecommons.org/licenses/by-nc-sa/2.5/ar',
				' creativecommons.org/licenses/by-nc-sa/2.5/au',
				' creativecommons.org/licenses/by-nc-sa/2.5/bg',
				' creativecommons.org/licenses/by-nc-sa/2.5/br',
				' creativecommons.org/licenses/by-nc-sa/2.5/ca',
				' creativecommons.org/licenses/by-nc-sa/2.5/ch',
				' creativecommons.org/licenses/by-nc-sa/2.5/cn',
				' creativecommons.org/licenses/by-nc-sa/2.5/co',
				' creativecommons.org/licenses/by-nc-sa/2.5/dk',
				' creativecommons.org/licenses/by-nc-sa/2.5/es',
				' creativecommons.org/licenses/by-nc-sa/2.5/hr',
				' creativecommons.org/licenses/by-nc-sa/2.5/hu',
				' creativecommons.org/licenses/by-nc-sa/2.5/il',
				' creativecommons.org/licenses/by-nc-sa/2.5/in',
				' creativecommons.org/licenses/by-nc-sa/2.5/it',
				' creativecommons.org/licenses/by-nc-sa/2.5/mk',
				' creativecommons.org/licenses/by-nc-sa/2.5/mt',
				' creativecommons.org/licenses/by-nc-sa/2.5/mx',
				' creativecommons.org/licenses/by-nc-sa/2.5/my',
				' creativecommons.org/licenses/by-nc-sa/2.5/nl',
				' creativecommons.org/licenses/by-nc-sa/2.5/pe',
				' creativecommons.org/licenses/by-nc-sa/2.5/pl',
				' creativecommons.org/licenses/by-nc-sa/2.5/pt',
				' creativecommons.org/licenses/by-nc-sa/2.5/scotland',
				' creativecommons.org/licenses/by-nc-sa/2.5/se',
				' creativecommons.org/licenses/by-nc-sa/2.5/si',
				' creativecommons.org/licenses/by-nc-sa/2.5/tw',
				' creativecommons.org/licenses/by-nc-sa/2.5/za',
				
				' creativecommons.org/licenses/by-nc/2.5',
				' creativecommons.org/licenses/by-nc/2.5/ar',
				' creativecommons.org/licenses/by-nc/2.5/au',
				' creativecommons.org/licenses/by-nc/2.5/bg',
				' creativecommons.org/licenses/by-nc/2.5/br',
				' creativecommons.org/licenses/by-nc/2.5/ca',
				' creativecommons.org/licenses/by-nc/2.5/ch',
				' creativecommons.org/licenses/by-nc/2.5/cn',
				' creativecommons.org/licenses/by-nc/2.5/co',
				' creativecommons.org/licenses/by-nc/2.5/dk',
				' creativecommons.org/licenses/by-nc/2.5/es',
				' creativecommons.org/licenses/by-nc/2.5/hr',
				' creativecommons.org/licenses/by-nc/2.5/hu',
				' creativecommons.org/licenses/by-nc/2.5/il',
				' creativecommons.org/licenses/by-nc/2.5/in',
				' creativecommons.org/licenses/by-nc/2.5/it',
				' creativecommons.org/licenses/by-nc/2.5/mk',
				' creativecommons.org/licenses/by-nc/2.5/mt',
				' creativecommons.org/licenses/by-nc/2.5/mx',
				' creativecommons.org/licenses/by-nc/2.5/my',
				' creativecommons.org/licenses/by-nc/2.5/nl',
				' creativecommons.org/licenses/by-nc/2.5/pe',
				' creativecommons.org/licenses/by-nc/2.5/pl',
				' creativecommons.org/licenses/by-nc/2.5/pt',
				' creativecommons.org/licenses/by-nc/2.5/scotland',
				' creativecommons.org/licenses/by-nc/2.5/se',
				' creativecommons.org/licenses/by-nc/2.5/si',
				' creativecommons.org/licenses/by-nc/2.5/tw',
				' creativecommons.org/licenses/by-nc/2.5/za',
				
				' creativecommons.org/licenses/by-nd/2.5',
				' creativecommons.org/licenses/by-nd/2.5/ar',
				' creativecommons.org/licenses/by-nd/2.5/au',
				' creativecommons.org/licenses/by-nd/2.5/bg',
				' creativecommons.org/licenses/by-nd/2.5/br',
				' creativecommons.org/licenses/by-nd/2.5/ca',
				' creativecommons.org/licenses/by-nd/2.5/ch',
				' creativecommons.org/licenses/by-nd/2.5/cn',
				' creativecommons.org/licenses/by-nd/2.5/co',
				' creativecommons.org/licenses/by-nd/2.5/dk',
				' creativecommons.org/licenses/by-nd/2.5/es',
				' creativecommons.org/licenses/by-nd/2.5/hr',
				' creativecommons.org/licenses/by-nd/2.5/hu',
				' creativecommons.org/licenses/by-nd/2.5/il',
				' creativecommons.org/licenses/by-nd/2.5/in',
				' creativecommons.org/licenses/by-nd/2.5/it',
				' creativecommons.org/licenses/by-nd/2.5/mk',
				' creativecommons.org/licenses/by-nd/2.5/mt',
				' creativecommons.org/licenses/by-nd/2.5/mx',
				' creativecommons.org/licenses/by-nd/2.5/my',
				' creativecommons.org/licenses/by-nd/2.5/nl',
				' creativecommons.org/licenses/by-nd/2.5/pe',
				' creativecommons.org/licenses/by-nd/2.5/pl',
				' creativecommons.org/licenses/by-nd/2.5/pt',
				' creativecommons.org/licenses/by-nd/2.5/scotland',
				' creativecommons.org/licenses/by-nd/2.5/se',
				' creativecommons.org/licenses/by-nd/2.5/si',
				' creativecommons.org/licenses/by-nd/2.5/tw',
				' creativecommons.org/licenses/by-nd/2.5/za',
				
				' creativecommons.org/licenses/by-sa/2.5',
				' creativecommons.org/licenses/by-sa/2.5/ar',
				' creativecommons.org/licenses/by-sa/2.5/au',
				' creativecommons.org/licenses/by-sa/2.5/bg',
				' creativecommons.org/licenses/by-sa/2.5/br',
				' creativecommons.org/licenses/by-sa/2.5/ca',
				' creativecommons.org/licenses/by-sa/2.5/ch',
				' creativecommons.org/licenses/by-sa/2.5/cn',
				' creativecommons.org/licenses/by-sa/2.5/co',
				' creativecommons.org/licenses/by-sa/2.5/dk',
				' creativecommons.org/licenses/by-sa/2.5/es',
				' creativecommons.org/licenses/by-sa/2.5/hr',
				' creativecommons.org/licenses/by-sa/2.5/hu',
				' creativecommons.org/licenses/by-sa/2.5/il',
				' creativecommons.org/licenses/by-sa/2.5/in',
				' creativecommons.org/licenses/by-sa/2.5/it',
				' creativecommons.org/licenses/by-sa/2.5/mk',
				' creativecommons.org/licenses/by-sa/2.5/mt',
				' creativecommons.org/licenses/by-sa/2.5/mx',
				' creativecommons.org/licenses/by-sa/2.5/my',
				' creativecommons.org/licenses/by-sa/2.5/nl',
				' creativecommons.org/licenses/by-sa/2.5/pe',
				' creativecommons.org/licenses/by-sa/2.5/pl',
				' creativecommons.org/licenses/by-sa/2.5/pt',
				' creativecommons.org/licenses/by-sa/2.5/scotland',
				' creativecommons.org/licenses/by-sa/2.5/se',
				' creativecommons.org/licenses/by-sa/2.5/si',
				' creativecommons.org/licenses/by-sa/2.5/tw',
				' creativecommons.org/licenses/by-sa/2.5/za',
				
				' creativecommons.org/licenses/by/2.5',
				' creativecommons.org/licenses/by/2.5/ar',
				' creativecommons.org/licenses/by/2.5/au',
				' creativecommons.org/licenses/by/2.5/bg',
				' creativecommons.org/licenses/by/2.5/br',
				' creativecommons.org/licenses/by/2.5/ca',
				' creativecommons.org/licenses/by/2.5/ch',
				' creativecommons.org/licenses/by/2.5/cn',
				' creativecommons.org/licenses/by/2.5/co',
				' creativecommons.org/licenses/by/2.5/dk',
				' creativecommons.org/licenses/by/2.5/es',
				' creativecommons.org/licenses/by/2.5/hr',
				' creativecommons.org/licenses/by/2.5/hu',
				' creativecommons.org/licenses/by/2.5/il',
				' creativecommons.org/licenses/by/2.5/in',
				' creativecommons.org/licenses/by/2.5/it',
				' creativecommons.org/licenses/by/2.5/mk',
				' creativecommons.org/licenses/by/2.5/mt',
				' creativecommons.org/licenses/by/2.5/mx',
				' creativecommons.org/licenses/by/2.5/my',
				' creativecommons.org/licenses/by/2.5/nl',
				' creativecommons.org/licenses/by/2.5/pe',
				' creativecommons.org/licenses/by/2.5/pl',
				' creativecommons.org/licenses/by/2.5/pt',
				' creativecommons.org/licenses/by/2.5/scotland',
				' creativecommons.org/licenses/by/2.5/se',
				' creativecommons.org/licenses/by/2.5/si',
				' creativecommons.org/licenses/by/2.5/tw',
				' creativecommons.org/licenses/by/2.5/za',
				
				' creativecommons.org/licenses/by-nc-nd/2.1/au',
				' creativecommons.org/licenses/by-nc-nd/2.1/ca',
				' creativecommons.org/licenses/by-nc-nd/2.1/es',
				' creativecommons.org/licenses/by-nc-nd/2.1/jp',
				
				' creativecommons.org/licenses/by-nc-sa/2.1/au',
				' creativecommons.org/licenses/by-nc-sa/2.1/ca',
				' creativecommons.org/licenses/by-nc-sa/2.1/es',
				' creativecommons.org/licenses/by-nc-sa/2.1/jp',
				
				' creativecommons.org/licenses/by-nc/2.1/au',
				' creativecommons.org/licenses/by-nc/2.1/ca',
				' creativecommons.org/licenses/by-nc/2.1/es',
				' creativecommons.org/licenses/by-nc/2.1/jp',
				
				' creativecommons.org/licenses/by-nd/2.1/au',
				' creativecommons.org/licenses/by-nd/2.1/ca',
				' creativecommons.org/licenses/by-nd/2.1/es',
				' creativecommons.org/licenses/by-nd/2.1/jp',
				
				' creativecommons.org/licenses/by-sa/2.1/au',
				' creativecommons.org/licenses/by-sa/2.1/ca',
				' creativecommons.org/licenses/by-sa/2.1/es',
				' creativecommons.org/licenses/by-sa/2.1/jp',
				
				' creativecommons.org/licenses/by/2.1/au',
				' creativecommons.org/licenses/by/2.1/ca',
				' creativecommons.org/licenses/by/2.1/es',
				' creativecommons.org/licenses/by/2.1/jp',
				
				' creativecommons.org/licenses/by-nc-nd/2.0',
				' creativecommons.org/licenses/by-nc-nd/2.0/at',
				' creativecommons.org/licenses/by-nc-nd/2.0/au',
				' creativecommons.org/licenses/by-nc-nd/2.0/be',
				' creativecommons.org/licenses/by-nc-nd/2.0/br',
				' creativecommons.org/licenses/by-nc-nd/2.0/ca',
				' creativecommons.org/licenses/by-nc-nd/2.0/cl',
				' creativecommons.org/licenses/by-nc-nd/2.0/de',
				' creativecommons.org/licenses/by-nc-nd/2.0/es',
				' creativecommons.org/licenses/by-nc-nd/2.0/fr',
				' creativecommons.org/licenses/by-nc-nd/2.0/hr',
				' creativecommons.org/licenses/by-nc-nd/2.0/it',
				' creativecommons.org/licenses/by-nc-nd/2.0/jp',
				' creativecommons.org/licenses/by-nc-nd/2.0/kr',
				' creativecommons.org/licenses/by-nc-nd/2.0/nl',
				' creativecommons.org/licenses/by-nc-nd/2.0/pl',
				' creativecommons.org/licenses/by-nc-nd/2.0/tw',
				' creativecommons.org/licenses/by-nc-nd/2.0/uk',
				' creativecommons.org/licenses/by-nc-nd/2.0/za',
				
				' creativecommons.org/licenses/by-nc-sa/2.0',
				' creativecommons.org/licenses/by-nc-sa/2.0/at',
				' creativecommons.org/licenses/by-nc-sa/2.0/au',
				' creativecommons.org/licenses/by-nc-sa/2.0/be',
				' creativecommons.org/licenses/by-nc-sa/2.0/br',
				' creativecommons.org/licenses/by-nc-sa/2.0/ca',
				' creativecommons.org/licenses/by-nc-sa/2.0/cl',
				' creativecommons.org/licenses/by-nc-sa/2.0/de',
				' creativecommons.org/licenses/by-nc-sa/2.0/es',
				' creativecommons.org/licenses/by-nc-sa/2.0/fr',
				' creativecommons.org/licenses/by-nc-sa/2.0/hr',
				' creativecommons.org/licenses/by-nc-sa/2.0/it',
				' creativecommons.org/licenses/by-nc-sa/2.0/jp',
				' creativecommons.org/licenses/by-nc-sa/2.0/kr',
				' creativecommons.org/licenses/by-nc-sa/2.0/nl',
				' creativecommons.org/licenses/by-nc-sa/2.0/pl',
				' creativecommons.org/licenses/by-nc-sa/2.0/tw',
				' creativecommons.org/licenses/by-nc-sa/2.0/uk',
				' creativecommons.org/licenses/by-nc-sa/2.0/za',
				
				' creativecommons.org/licenses/by-nc/2.0',
				' creativecommons.org/licenses/by-nc/2.0/at',
				' creativecommons.org/licenses/by-nc/2.0/au',
				' creativecommons.org/licenses/by-nc/2.0/be',
				' creativecommons.org/licenses/by-nc/2.0/br',
				' creativecommons.org/licenses/by-nc/2.0/ca',
				' creativecommons.org/licenses/by-nc/2.0/cl',
				' creativecommons.org/licenses/by-nc/2.0/de',
				' creativecommons.org/licenses/by-nc/2.0/es',
				' creativecommons.org/licenses/by-nc/2.0/fr',
				' creativecommons.org/licenses/by-nc/2.0/hr',
				' creativecommons.org/licenses/by-nc/2.0/it',
				' creativecommons.org/licenses/by-nc/2.0/jp',
				' creativecommons.org/licenses/by-nc/2.0/kr',
				' creativecommons.org/licenses/by-nc/2.0/nl',
				' creativecommons.org/licenses/by-nc/2.0/pl',
				' creativecommons.org/licenses/by-nc/2.0/tw',
				' creativecommons.org/licenses/by-nc/2.0/uk',
				' creativecommons.org/licenses/by-nc/2.0/za',
				
				' creativecommons.org/licenses/by-nd/2.0',
				' creativecommons.org/licenses/by-nd/2.0/at',
				' creativecommons.org/licenses/by-nd/2.0/au',
				' creativecommons.org/licenses/by-nd/2.0/be',
				' creativecommons.org/licenses/by-nd/2.0/br',
				' creativecommons.org/licenses/by-nd/2.0/ca',
				' creativecommons.org/licenses/by-nd/2.0/cl',
				' creativecommons.org/licenses/by-nd/2.0/de',
				' creativecommons.org/licenses/by-nd/2.0/es',
				' creativecommons.org/licenses/by-nd/2.0/fr',
				' creativecommons.org/licenses/by-nd/2.0/hr',
				' creativecommons.org/licenses/by-nd/2.0/it',
				' creativecommons.org/licenses/by-nd/2.0/jp',
				' creativecommons.org/licenses/by-nd/2.0/kr',
				' creativecommons.org/licenses/by-nd/2.0/nl',
				' creativecommons.org/licenses/by-nd/2.0/pl',
				' creativecommons.org/licenses/by-nd/2.0/tw',
				' creativecommons.org/licenses/by-nd/2.0/uk',
				' creativecommons.org/licenses/by-nd/2.0/za',
				
				' creativecommons.org/licenses/by-sa/2.0',
				' creativecommons.org/licenses/by-sa/2.0/at',
				' creativecommons.org/licenses/by-sa/2.0/au',
				' creativecommons.org/licenses/by-sa/2.0/be',
				' creativecommons.org/licenses/by-sa/2.0/br',
				' creativecommons.org/licenses/by-sa/2.0/ca',
				' creativecommons.org/licenses/by-sa/2.0/cl',
				' creativecommons.org/licenses/by-sa/2.0/de',
				' creativecommons.org/licenses/by-sa/2.0/es',
				' creativecommons.org/licenses/by-sa/2.0/fr',
				' creativecommons.org/licenses/by-sa/2.0/hr',
				' creativecommons.org/licenses/by-sa/2.0/it',
				' creativecommons.org/licenses/by-sa/2.0/jp',
				' creativecommons.org/licenses/by-sa/2.0/kr',
				' creativecommons.org/licenses/by-sa/2.0/nl',
				' creativecommons.org/licenses/by-sa/2.0/pl',
				' creativecommons.org/licenses/by-sa/2.0/tw',
				' creativecommons.org/licenses/by-sa/2.0/uk',
				' creativecommons.org/licenses/by-sa/2.0/za',
				
				' creativecommons.org/licenses/by/2.0',
				' creativecommons.org/licenses/by/2.0/at',
				' creativecommons.org/licenses/by/2.0/au',
				' creativecommons.org/licenses/by/2.0/be',
				' creativecommons.org/licenses/by/2.0/br',
				' creativecommons.org/licenses/by/2.0/ca',
				' creativecommons.org/licenses/by/2.0/cl',
				' creativecommons.org/licenses/by/2.0/de',
				' creativecommons.org/licenses/by/2.0/es',
				' creativecommons.org/licenses/by/2.0/fr',
				' creativecommons.org/licenses/by/2.0/hr',
				' creativecommons.org/licenses/by/2.0/it',
				' creativecommons.org/licenses/by/2.0/jp',
				' creativecommons.org/licenses/by/2.0/kr',
				' creativecommons.org/licenses/by/2.0/nl',
				' creativecommons.org/licenses/by/2.0/pl',
				' creativecommons.org/licenses/by/2.0/tw',
				' creativecommons.org/licenses/by/2.0/uk',
				' creativecommons.org/licenses/by/2.0/za',
				
				' creativecommons.org/licenses/nc-sa/2.0/jp',
				
				' creativecommons.org/licenses/nc/2.0/jp',
				
				' creativecommons.org/licenses/nd-nc/2.0/jp',
				
				' creativecommons.org/licenses/nd/2.0/jp',
				
				' creativecommons.org/licenses/sa/2.0/jp',
				
				' creativecommons.org/licenses/by-nc-sa/1.0',
				' creativecommons.org/licenses/by-nc-sa/1.0/fi',
				' creativecommons.org/licenses/by-nc-sa/1.0/il',
				' creativecommons.org/licenses/by-nc-sa/1.0/nl',
				
				' creativecommons.org/licenses/by-nc/1.0',
				' creativecommons.org/licenses/by-nc/1.0/fi',
				' creativecommons.org/licenses/by-nc/1.0/il',
				' creativecommons.org/licenses/by-nc/1.0/nl',
				
				' creativecommons.org/licenses/by-nd-nc/1.0',
				' creativecommons.org/licenses/by-nd-nc/1.0/fi',
				' creativecommons.org/licenses/by-nd-nc/1.0/il',
				' creativecommons.org/licenses/by-nd-nc/1.0/nl',
				
				' creativecommons.org/licenses/by-nd/1.0',
				' creativecommons.org/licenses/by-nd/1.0/fi',
				' creativecommons.org/licenses/by-nd/1.0/il',
				' creativecommons.org/licenses/by-nd/1.0/nl',
				
				' creativecommons.org/licenses/by-sa/1.0',
				' creativecommons.org/licenses/by-sa/1.0/fi',
				' creativecommons.org/licenses/by-sa/1.0/il',
				' creativecommons.org/licenses/by-sa/1.0/nl',
				
				' creativecommons.org/licenses/by/1.0',
				' creativecommons.org/licenses/by/1.0/fi',
				' creativecommons.org/licenses/by/1.0/il',
				' creativecommons.org/licenses/by/1.0/nl',
				
				' creativecommons.org/licenses/nc-sa/1.0',
				' creativecommons.org/licenses/nc-sa/1.0/fi',
				' creativecommons.org/licenses/nc-sa/1.0/nl',
				
				' creativecommons.org/licenses/nc-samplingplus/1.0',
				' creativecommons.org/licenses/nc-samplingplus/1.0/tw',
				
				' creativecommons.org/licenses/nc/1.0',
				' creativecommons.org/licenses/nc/1.0/fi',
				' creativecommons.org/licenses/nc/1.0/nl',
				
				' creativecommons.org/licenses/nd-nc/1.0',
				' creativecommons.org/licenses/nd-nc/1.0/fi',
				' creativecommons.org/licenses/nd-nc/1.0/nl',
				
				' creativecommons.org/licenses/nd/1.0',
				' creativecommons.org/licenses/nd/1.0/fi',
				' creativecommons.org/licenses/nd/1.0/nl',
				
				' creativecommons.org/licenses/sa/1.0',
				' creativecommons.org/licenses/sa/1.0/fi',
				' creativecommons.org/licenses/sa/1.0/nl',
				
				' creativecommons.org/licenses/sampling+/1.0',
				' creativecommons.org/licenses/sampling+/1.0/br',
				' creativecommons.org/licenses/sampling+/1.0/de',
				' creativecommons.org/licenses/sampling+/1.0/tw',
				
				' creativecommons.org/licenses/sampling/1.0',
				' creativecommons.org/licenses/sampling/1.0/br',
				' creativecommons.org/licenses/sampling/1.0/tw',
				
				' creativecommons.org/publicdomain/zero/1.0',
				' creativecommons.org/licenses/devnations/2.0',
				' creativecommons.org/publicdomain/zero-assert/1.0',
				' creativecommons.org/publicdomain/zero-waive/1.0',
				' creativecommons.org/publicdomain/mark/1.0',
				
				' '
			)"
		/>
	</xsl:template>
	

</xsl:stylesheet>
