<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="html"  indent="yes"/>
   <xsl:param name="filename"/>
   <xsl:param name="full" select="'yes'"/>
		
	<xsl:template match="ERR">
	<xsl:choose>
		<xsl:when test="$full='yes'">
		<html>
			<head>
				<title></title>
			</head>
			<body style="width:1000px;">
			<ol>
			<h2>
				<xsl:text>Style report for "</xsl:text>
            <xsl:choose>
               <xsl:when test="$filename">
                  <xsl:value-of select="$filename"/>
               </xsl:when>
               
               <xsl:otherwise>
                  <xsl:value-of select="//processing-instruction('TITLE')"/>
               </xsl:otherwise>
            </xsl:choose>
				<xsl:text>"</xsl:text>
			</h2>

		<xsl:choose>
			<xsl:when test="contains(//processing-instruction('SC-DETAILS'),'||')">
				<h4>
            	<xsl:value-of select="substring-before(//processing-instruction('SC-DETAILS'),'||')"/>
				</h4>
				<h4>
            	<xsl:value-of select="substring-after(//processing-instruction('SC-DETAILS'),'||')"/>
				</h4>
				</xsl:when>
			<xsl:otherwise>
				<h4>
            	<xsl:value-of select="//processing-instruction('SC-DETAILS')"/>
				</h4>
				</xsl:otherwise>
			</xsl:choose>
	</ol>
	<xsl:call-template name="reportmeat"/>	
			</body>
		</html>
	</xsl:when>
	<xsl:otherwise>
		<xsl:call-template name="reportmeat"/>
		</xsl:otherwise>
	</xsl:choose>
		</xsl:template>

<xsl:template name="reportmeat">
	<div class="report-details">
        <ol>
         <h3>
            <xsl:if test="//warning">
               <xsl:text>Total of warnings = </xsl:text><xsl:value-of select="count(//warning)"/><br/>
            </xsl:if>
            <xsl:text>Total of errors = </xsl:text><xsl:value-of select="count(//error)"/><br/>Unique errors are listed below.
         </h3>
                        <xsl:apply-templates select="descendant::*[self::error or self::warning]"/>
                        </ol>
<hr/>
                        <ol>
                        <pre style="white-space: pre-wrap;">
                        <xsl:apply-templates mode="copy"/>
                        </pre>
                        </ol>
	</div>
	</xsl:template>

	<xsl:template match="error|warning">
		<xsl:variable name="nodepath">
			<xsl:call-template name="nodePath"/>
			</xsl:variable>
		<xsl:variable name="preceding-nodepath">
			<xsl:for-each select="preceding::*[self::error or self::warning][1]">
				<xsl:call-template name="nodePath"/>
				</xsl:for-each>
			</xsl:variable>
		<xsl:if test="$nodepath != $preceding-nodepath and string(node()) != string(preceding::*[self::error or self::warning][1])">
		<p>
			<a><xsl:attribute name="href"><xsl:call-template name="generate-id"/></xsl:attribute><b><xsl:value-of select="substring-before(substring-after($nodepath,'/ERR'),'/error')"/>: </b></a>
         
         <!--<xsl:if test="current()[self::warning]">
            <xsl:text> [warning] </xsl:text>
         </xsl:if>  -->
			<b>
			<font>
				<xsl:attribute name="color">
					<xsl:choose>
						<xsl:when test="name()='warning'">
							<xsl:value-of select="'#FF8D00'"/>
							</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="'red'"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:attribute>
			<xsl:text>[</xsl:text>
			<xsl:value-of select="name()"/>
			<xsl:text>]</xsl:text>
			</font>
			</b>
         
			<xsl:apply-templates/>
		</p>
		</xsl:if>
		
		<xsl:if test="$nodepath = $preceding-nodepath and string(node()) != string(preceding::*[self::error or self::warning][1])">
		<p>
			<a><xsl:attribute name="href"><xsl:call-template name="generate-id"/></xsl:attribute><b><xsl:value-of select="substring-before(substring-after($nodepath,'/ERR'),'/error')"/>: </b></a>
         
      <!--   <xsl:if test="current()[self::warning]">
            <xsl:text> [warning] </xsl:text>
         </xsl:if> -->
			<b>
			<font>
				<xsl:attribute name="color">
					<xsl:choose>
						<xsl:when test="name()='warning'">
							<xsl:value-of select="'#FF8D00'"/>
							</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="'red'"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:attribute>
			<xsl:text>[</xsl:text>
			<xsl:value-of select="name()"/>
			<xsl:text>]</xsl:text>
			</font>
			</b>
         
			<xsl:apply-templates/>
		</p>
		
		</xsl:if>
		</xsl:template>

	<xsl:template match="*" mode="copy">
		<xsl:text>&lt;</xsl:text><xsl:value-of select="name()"/><xsl:apply-templates select="@*" mode="copy"/><xsl:text>&gt;</xsl:text>
		<xsl:apply-templates mode="copy"/>
		<xsl:text>&lt;/</xsl:text><xsl:value-of select="name()"/><xsl:text>&gt;</xsl:text>
		</xsl:template>
		
	<xsl:template match="processing-instruction()" mode="copy">
		<xsl:choose>
			<xsl:when test="name()='SC-DETAILS' or name()='TITLE'"/>
			<xsl:otherwise>
				<xsl:text>&lt;?</xsl:text><xsl:value-of select="name()"/><xsl:text> </xsl:text><xsl:value-of select="."/><xsl:text>?&gt;</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:template> 
		
	<xsl:template match="@*" mode="copy">
		<xsl:text> </xsl:text>
		<xsl:value-of select="name()"/>
		<xsl:text>="</xsl:text>
		<xsl:value-of select="."/>
		<xsl:text>"</xsl:text>
		</xsl:template>


	<xsl:template match="error" mode="copy">
		<a>
			<xsl:attribute name="name">
				<xsl:call-template name="generate-id"/>
			</xsl:attribute>
		</a>
		<font color="red"><b><xsl:text>[ERROR: </xsl:text><xsl:apply-templates/><xsl:text>]</xsl:text></b></font>
		</xsl:template>	
      
   <xsl:template match="warning" mode="copy">
      <a>
      	<xsl:attribute name="name">
      		<xsl:call-template name="generate-id"/>
      	</xsl:attribute>
      </a>
      <font color="#FF8D00"><b><xsl:text>[WARNING: </xsl:text><xsl:apply-templates/><xsl:text>]</xsl:text></b></font>
      </xsl:template>   

	<xsl:template name="nodePath">
		<xsl:for-each select="ancestor-or-self::*">
            <xsl:choose>
               <xsl:when test="name() = 'warning'">
                  <xsl:text>/error</xsl:text>
               </xsl:when>
               
               <xsl:otherwise>
                  <xsl:value-of select="concat('/',name())"/>               
               </xsl:otherwise>
            </xsl:choose>
		</xsl:for-each>
		</xsl:template>
		
	<xsl:template match="tlink">
		<a href="{@target}" target="_new">
			<xsl:apply-templates/>
		</a>
		</xsl:template>	
	
	<xsl:template name="generate-id">
		<!-- isolated so we can override it during testing -->
		<xsl:text>#</xsl:text>
		<xsl:value-of select="generate-id()"/>
	</xsl:template>
	
</xsl:stylesheet>
