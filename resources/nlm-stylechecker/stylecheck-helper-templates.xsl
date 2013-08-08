<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet 
   xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
   xmlns:xlink="http://www.w3.org/1999/xlink" 
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
   xmlns:mml="http://www.w3.org/1998/Math/MathML" 
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

      <!-- Make sure have all needed values, otherwise don't output -->
      <xsl:if test="string-length($error-type) &gt; 0 and
	                string-length($description) &gt; 0">
         <xsl:element name="{$class-type}">
            <xsl:value-of select="$error-type"/>
            <xsl:text>: </xsl:text>
            <xsl:value-of select="$description"/>
         <xsl:if test="string-length($tg-target) &gt; 0">
				<xsl:call-template name="tglink">
					<xsl:with-param name="tg-target" select="$tg-target"/>
					</xsl:call-template>
				</xsl:if>
         </xsl:element>
         
         <xsl:call-template name="output-message">
            <xsl:with-param name="class" select="$class-type"/>
            <xsl:with-param name="description">
			   <xsl:value-of select="description"/>
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
					<xsl:value-of select="'http://www.pubmedcentral.nih.gov/pmcdoc/tagging-guidelines/book/'"/>
					</xsl:when>
				<xsl:when test="$stream='manuscript'">
					<xsl:value-of select="'http://www.pubmedcentral.nih.gov/pmcdoc/tagging-guidelines/manuscript/'"/>
					</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="'http://www.pubmedcentral.nih.gov/pmcdoc/tagging-guidelines/article/'"/>
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
      <xsl:param name="type" select="''"/>
      
      <xsl:variable name="descriptor">
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
            <xsl:text disable-output-escaping="yes">&#10;</xsl:text>
         </xsl:message>
      </xsl:if>
   </xsl:template>

		
			
			
   <!-- ********************************************************************* -->
   <!-- Template: text(), and 
                  NAMED check-prohibited-math-characters-outside-math-context

        Scans all text nodes for prohibited characters, outside math context
        
     -->
   <!-- ********************************************************************* -->
   <!-- ********************************************************************* -->
   <xsl:template match="text()" name="check-prohibited-math-characters-outside-math-context">

        <!-- are we in math context ?-->
   	  <xsl:if test="not(ancestor::node()[local-name() = 'math'
					    or local-name() = 'inline-formula'
					    or local-name() = 'disp-formula'
					    or local-name() = 'text-math'])">

            <!-- here you can list using "OR" a banch of contains function calls 
                to check prohibited  characters.  -->
            <xsl:if test="contains(., '&#xFE37;')">
                
                <xsl:call-template name="make-error">
                  <xsl:with-param name="error-type" select="'math character check'"/>
                  <xsl:with-param name="description">
                     <xsl:text>prohibited character is being used outside of math context in this node.</xsl:text>
                  </xsl:with-param>
                </xsl:call-template>

      	    </xsl:if>

	  </xsl:if>

      <!-- If we are in the text() node copy its content to the output, 
           otherwise we're in the attribute node, and we do not do output here, 
           because it is done in other place. -->
      <xsl:if test="(name(.)='')">
         <xsl:copy-of select="."/>
      </xsl:if>
   </xsl:template>


   <!-- ********************************************************************* -->
   <xsl:template match="@*" mode="check-prohibited-math-characters-outside-math-context">
      <xsl:call-template name="check-prohibited-math-characters-outside-math-context"/>
   </xsl:template>


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


</xsl:stylesheet>
