<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<xsl:stylesheet xmlns:iso="http://purl.oclc.org/dsdl/schematron"
                xmlns:mei="http://www.music-encoding.org/ns/mei"
                xmlns:saxon="http://saxon.sf.net/"
                xmlns:schold="http://www.ascc.net/xml/schematron"
                xmlns:tei="http://www.tei-c.org/ns/1.0"
                xmlns:xhtml="http://www.w3.org/1999/xhtml"
                xmlns:xlink="http://www.w3.org/1999/xlink"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:xsd="http://www.w3.org/2001/XMLSchema"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="2.0"><!--Implementers: please note that overriding process-prolog or process-root is 
    the preferred method for meta-stylesheets to use where possible. -->
   <xsl:param name="archiveDirParameter"/>
   <xsl:param name="archiveNameParameter"/>
   <xsl:param name="fileNameParameter"/>
   <xsl:param name="fileDirParameter"/>
   <xsl:variable name="document-uri">
      <xsl:value-of select="document-uri(/)"/>
   </xsl:variable>
   <!--PHASES-->

   <!--PROLOG-->
   <xsl:output xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
               method="xml"
               omit-xml-declaration="no"
               standalone="yes"
               indent="yes"/>
   <!--XSD TYPES FOR XSLT2-->

   <!--KEYS AND FUNCTIONS-->

   <!--DEFAULT RULES-->

   <!--MODE: SCHEMATRON-SELECT-FULL-PATH-->
   <!--This mode can be used to generate an ugly though full XPath for locators-->
   <xsl:template match="*" mode="schematron-select-full-path">
      <xsl:apply-templates select="." mode="schematron-get-full-path"/>
   </xsl:template>
   <!--MODE: SCHEMATRON-FULL-PATH-->
   <!--This mode can be used to generate an ugly though full XPath for locators-->
   <xsl:template match="*" mode="schematron-get-full-path">
      <xsl:apply-templates select="parent::*" mode="schematron-get-full-path"/>
      <xsl:text>/</xsl:text>
      <xsl:choose>
         <xsl:when test="namespace-uri()=''">
            <xsl:value-of select="name()"/>
         </xsl:when>
         <xsl:otherwise>
            <xsl:text>*:</xsl:text>
            <xsl:value-of select="local-name()"/>
            <xsl:text>[namespace-uri()='</xsl:text>
            <xsl:value-of select="namespace-uri()"/>
            <xsl:text>']</xsl:text>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:variable name="preceding"
                    select="count(preceding-sibling::*[local-name()=local-name(current())                                   and namespace-uri() = namespace-uri(current())])"/>
      <xsl:text>[</xsl:text>
      <xsl:value-of select="1+ $preceding"/>
      <xsl:text>]</xsl:text>
   </xsl:template>
   <xsl:template match="@*" mode="schematron-get-full-path">
      <xsl:apply-templates select="parent::*" mode="schematron-get-full-path"/>
      <xsl:text>/</xsl:text>
      <xsl:choose>
         <xsl:when test="namespace-uri()=''">@<xsl:value-of select="name()"/>
         </xsl:when>
         <xsl:otherwise>
            <xsl:text>@*[local-name()='</xsl:text>
            <xsl:value-of select="local-name()"/>
            <xsl:text>' and namespace-uri()='</xsl:text>
            <xsl:value-of select="namespace-uri()"/>
            <xsl:text>']</xsl:text>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <!--MODE: SCHEMATRON-FULL-PATH-2-->
   <!--This mode can be used to generate prefixed XPath for humans-->
   <xsl:template match="node() | @*" mode="schematron-get-full-path-2">
      <xsl:for-each select="ancestor-or-self::*">
         <xsl:text>/</xsl:text>
         <xsl:value-of select="name(.)"/>
         <xsl:if test="preceding-sibling::*[name(.)=name(current())]">
            <xsl:text>[</xsl:text>
            <xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1"/>
            <xsl:text>]</xsl:text>
         </xsl:if>
      </xsl:for-each>
      <xsl:if test="not(self::*)">
         <xsl:text/>/@<xsl:value-of select="name(.)"/>
      </xsl:if>
   </xsl:template>
   <!--MODE: SCHEMATRON-FULL-PATH-3-->
   <!--This mode can be used to generate prefixed XPath for humans 
	(Top-level element has index)-->
   <xsl:template match="node() | @*" mode="schematron-get-full-path-3">
      <xsl:for-each select="ancestor-or-self::*">
         <xsl:text>/</xsl:text>
         <xsl:value-of select="name(.)"/>
         <xsl:if test="parent::*">
            <xsl:text>[</xsl:text>
            <xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1"/>
            <xsl:text>]</xsl:text>
         </xsl:if>
      </xsl:for-each>
      <xsl:if test="not(self::*)">
         <xsl:text/>/@<xsl:value-of select="name(.)"/>
      </xsl:if>
   </xsl:template>
   <!--MODE: GENERATE-ID-FROM-PATH -->
   <xsl:template match="/" mode="generate-id-from-path"/>
   <xsl:template match="text()" mode="generate-id-from-path">
      <xsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
      <xsl:value-of select="concat('.text-', 1+count(preceding-sibling::text()), '-')"/>
   </xsl:template>
   <xsl:template match="comment()" mode="generate-id-from-path">
      <xsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
      <xsl:value-of select="concat('.comment-', 1+count(preceding-sibling::comment()), '-')"/>
   </xsl:template>
   <xsl:template match="processing-instruction()" mode="generate-id-from-path">
      <xsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
      <xsl:value-of select="concat('.processing-instruction-', 1+count(preceding-sibling::processing-instruction()), '-')"/>
   </xsl:template>
   <xsl:template match="@*" mode="generate-id-from-path">
      <xsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
      <xsl:value-of select="concat('.@', name())"/>
   </xsl:template>
   <xsl:template match="*" mode="generate-id-from-path" priority="-0.5">
      <xsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
      <xsl:text>.</xsl:text>
      <xsl:value-of select="concat('.',name(),'-',1+count(preceding-sibling::*[name()=name(current())]),'-')"/>
   </xsl:template>
   <!--MODE: GENERATE-ID-2 -->
   <xsl:template match="/" mode="generate-id-2">U</xsl:template>
   <xsl:template match="*" mode="generate-id-2" priority="2">
      <xsl:text>U</xsl:text>
      <xsl:number level="multiple" count="*"/>
   </xsl:template>
   <xsl:template match="node()" mode="generate-id-2">
      <xsl:text>U.</xsl:text>
      <xsl:number level="multiple" count="*"/>
      <xsl:text>n</xsl:text>
      <xsl:number count="node()"/>
   </xsl:template>
   <xsl:template match="@*" mode="generate-id-2">
      <xsl:text>U.</xsl:text>
      <xsl:number level="multiple" count="*"/>
      <xsl:text>_</xsl:text>
      <xsl:value-of select="string-length(local-name(.))"/>
      <xsl:text>_</xsl:text>
      <xsl:value-of select="translate(name(),':','.')"/>
   </xsl:template>
   <!--Strip characters-->
   <xsl:template match="text()" priority="-1"/>
   <!--SCHEMA SETUP-->
   <xsl:template match="/">
      <svrl:schematron-output xmlns:svrl="http://purl.oclc.org/dsdl/svrl" title="" schemaVersion="">
         <xsl:comment>
            <xsl:value-of select="$archiveDirParameter"/>   
		 <xsl:value-of select="$archiveNameParameter"/>  
		 <xsl:value-of select="$fileNameParameter"/>  
		 <xsl:value-of select="$fileDirParameter"/>
         </xsl:comment>
         <svrl:ns-prefix-in-attribute-values uri="http://www.tei-c.org/ns/1.0" prefix="tei"/>
         <svrl:ns-prefix-in-attribute-values uri="http://www.music-encoding.org/ns/mei" prefix="mei"/>
         <svrl:ns-prefix-in-attribute-values uri="http://www.w3.org/1999/xlink" prefix="xlink"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">mei-graphicanalysis-att.notationType-notationsubtype-When_notationsubtype-constraint-rule-5</xsl:attribute>
            <xsl:attribute name="name">mei-graphicanalysis-att.notationType-notationsubtype-When_notationsubtype-constraint-rule-5</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M3"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">mei-graphicanalysis-att.beamRend-place-check_beam_place-constraint-rule-6</xsl:attribute>
            <xsl:attribute name="name">mei-graphicanalysis-att.beamRend-place-check_beam_place-constraint-rule-6</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M4"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">mei-graphicanalysis-attacca-attacca_start-type_attributes_required-constraint-rule-8</xsl:attribute>
            <xsl:attribute name="name">mei-graphicanalysis-attacca-attacca_start-type_attributes_required-constraint-rule-8</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M5"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">mei-graphicanalysis-beam-When_not_copyof_beam_content-constraint-rule-9</xsl:attribute>
            <xsl:attribute name="name">mei-graphicanalysis-beam-When_not_copyof_beam_content-constraint-rule-9</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M6"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">mei-graphicanalysis-beamSpan-beamspan_start-_and_end-type_attributes_required-constraint-rule-10</xsl:attribute>
            <xsl:attribute name="name">mei-graphicanalysis-beamSpan-beamspan_start-_and_end-type_attributes_required-constraint-rule-10</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M7"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">mei-graphicanalysis-bend-bend_start-_and_end-type_attributes_required-constraint-rule-11</xsl:attribute>
            <xsl:attribute name="name">mei-graphicanalysis-bend-bend_start-_and_end-type_attributes_required-constraint-rule-11</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M8"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">mei-graphicanalysis-bracketSpan-bracketSpan_start-_and_end-type_attributes_required-constraint-rule-12</xsl:attribute>
            <xsl:attribute name="name">mei-graphicanalysis-bracketSpan-bracketSpan_start-_and_end-type_attributes_required-constraint-rule-12</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M9"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">mei-graphicanalysis-breath-breath_start-type_attributes_required-constraint-rule-13</xsl:attribute>
            <xsl:attribute name="name">mei-graphicanalysis-breath-breath_start-type_attributes_required-constraint-rule-13</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M10"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">mei-graphicanalysis-fermata-fermata_start-type_attributes_required-constraint-rule-14</xsl:attribute>
            <xsl:attribute name="name">mei-graphicanalysis-fermata-fermata_start-type_attributes_required-constraint-rule-14</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M11"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">mei-graphicanalysis-gliss-gliss_start-_and_end-type_attributes_required-constraint-rule-15</xsl:attribute>
            <xsl:attribute name="name">mei-graphicanalysis-gliss-gliss_start-_and_end-type_attributes_required-constraint-rule-15</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M12"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">mei-graphicanalysis-graceGrp-When_not_copyof_graceGrp_content-constraint-rule-16</xsl:attribute>
            <xsl:attribute name="name">mei-graphicanalysis-graceGrp-When_not_copyof_graceGrp_content-constraint-rule-16</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M13"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">mei-graphicanalysis-graceGrp-When_graced-constraint-rule-17</xsl:attribute>
            <xsl:attribute name="name">mei-graphicanalysis-graceGrp-When_graced-constraint-rule-17</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M14"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">mei-graphicanalysis-hairpin-hairpin_start-_and_end-type_attributes_required-constraint-rule-18</xsl:attribute>
            <xsl:attribute name="name">mei-graphicanalysis-hairpin-hairpin_start-_and_end-type_attributes_required-constraint-rule-18</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M15"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">mei-graphicanalysis-harpPedal-harpPedal_start-type_attributes_required-constraint-rule-19</xsl:attribute>
            <xsl:attribute name="name">mei-graphicanalysis-harpPedal-harpPedal_start-type_attributes_required-constraint-rule-19</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M16"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">mei-graphicanalysis-lv-lv_start-_and_end-type_attributes_required-constraint-rule-20</xsl:attribute>
            <xsl:attribute name="name">mei-graphicanalysis-lv-lv_start-_and_end-type_attributes_required-constraint-rule-20</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M17"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">mei-graphicanalysis-lv-lv_containing_curve-constraint-rule-21</xsl:attribute>
            <xsl:attribute name="name">mei-graphicanalysis-lv-lv_containing_curve-constraint-rule-21</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M18"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">mei-graphicanalysis-octave-octave_start-_and_end-type_attributes_required-constraint-rule-22</xsl:attribute>
            <xsl:attribute name="name">mei-graphicanalysis-octave-octave_start-_and_end-type_attributes_required-constraint-rule-22</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M19"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M20"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">mei-graphicanalysis-pedal-pedal_start-type_attributes_required-constraint-rule-25</xsl:attribute>
            <xsl:attribute name="name">mei-graphicanalysis-pedal-pedal_start-type_attributes_required-constraint-rule-25</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M21"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">mei-graphicanalysis-repeatMark-repeatMark_start-type_attributes_required-constraint-rule-26</xsl:attribute>
            <xsl:attribute name="name">mei-graphicanalysis-repeatMark-repeatMark_start-type_attributes_required-constraint-rule-26</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M22"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">mei-graphicanalysis-repeatMark-repeatMark_with_glyph_has_to_be_empty-constraint-rule-27</xsl:attribute>
            <xsl:attribute name="name">mei-graphicanalysis-repeatMark-repeatMark_with_glyph_has_to_be_empty-constraint-rule-27</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M23"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">mei-graphicanalysis-slur-slur_start-_and_end-type_attributes_required-constraint-rule-28</xsl:attribute>
            <xsl:attribute name="name">mei-graphicanalysis-slur-slur_start-_and_end-type_attributes_required-constraint-rule-28</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M24"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">mei-graphicanalysis-slur-slur_containing_curve-constraint-rule-29</xsl:attribute>
            <xsl:attribute name="name">mei-graphicanalysis-slur-slur_containing_curve-constraint-rule-29</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M25"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">mei-graphicanalysis-tie-tie_start-_and_end-type_attributes_required-constraint-rule-30</xsl:attribute>
            <xsl:attribute name="name">mei-graphicanalysis-tie-tie_start-_and_end-type_attributes_required-constraint-rule-30</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M26"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">mei-graphicanalysis-tie-tie_containing_curve-constraint-rule-31</xsl:attribute>
            <xsl:attribute name="name">mei-graphicanalysis-tie-tie_containing_curve-constraint-rule-31</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M27"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">mei-graphicanalysis-tupletSpan-tupletSpan_start-_and_end-type_attributes_required-constraint-rule-32</xsl:attribute>
            <xsl:attribute name="name">mei-graphicanalysis-tupletSpan-tupletSpan_start-_and_end-type_attributes_required-constraint-rule-32</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M28"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">mei-graphicanalysis-mordent-mordent_start-type_attributes_required-constraint-rule-33</xsl:attribute>
            <xsl:attribute name="name">mei-graphicanalysis-mordent-mordent_start-type_attributes_required-constraint-rule-33</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M29"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">mei-graphicanalysis-trill-trill_start-type_attributes_required-constraint-rule-34</xsl:attribute>
            <xsl:attribute name="name">mei-graphicanalysis-trill-trill_start-type_attributes_required-constraint-rule-34</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M30"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">mei-graphicanalysis-turn-turn_start-type_attributes_required-constraint-rule-35</xsl:attribute>
            <xsl:attribute name="name">mei-graphicanalysis-turn-turn_start-type_attributes_required-constraint-rule-35</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M31"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">mei-graphicanalysis-sp-sp_start-type_attributes_required-constraint-rule-36</xsl:attribute>
            <xsl:attribute name="name">mei-graphicanalysis-sp-sp_start-type_attributes_required-constraint-rule-36</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M32"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">mei-graphicanalysis-sp-sp_start-type_attributes_forbidden-constraint-rule-37</xsl:attribute>
            <xsl:attribute name="name">mei-graphicanalysis-sp-sp_start-type_attributes_forbidden-constraint-rule-37</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M33"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">mei-graphicanalysis-stageDir-stageDir_start-type_attributes_required-constraint-rule-38</xsl:attribute>
            <xsl:attribute name="name">mei-graphicanalysis-stageDir-stageDir_start-type_attributes_required-constraint-rule-38</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M34"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">mei-graphicanalysis-stageDir-stageDir_start-type_attributes_forbidden-constraint-rule-39</xsl:attribute>
            <xsl:attribute name="name">mei-graphicanalysis-stageDir-stageDir_start-type_attributes_forbidden-constraint-rule-39</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M35"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">mei-graphicanalysis-cpMark-cpMark_start-_and_end-type_attributes_required-constraint-rule-40</xsl:attribute>
            <xsl:attribute name="name">mei-graphicanalysis-cpMark-cpMark_start-_and_end-type_attributes_required-constraint-rule-40</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M36"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">mei-graphicanalysis-handShift-new-check_newTarget-constraint-rule-41</xsl:attribute>
            <xsl:attribute name="name">mei-graphicanalysis-handShift-new-check_newTarget-constraint-rule-41</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M37"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">mei-graphicanalysis-handShift-old-check_oldTarget-constraint-rule-42</xsl:attribute>
            <xsl:attribute name="name">mei-graphicanalysis-handShift-old-check_oldTarget-constraint-rule-42</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M38"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">mei-graphicanalysis-metaMark-metaMark_start-type_attributes_required-constraint-rule-43</xsl:attribute>
            <xsl:attribute name="name">mei-graphicanalysis-metaMark-metaMark_start-type_attributes_required-constraint-rule-43</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M39"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">mei-graphicanalysis-att.extSym.names-glyph.name-check_glyph.name-constraint-rule-44</xsl:attribute>
            <xsl:attribute name="name">mei-graphicanalysis-att.extSym.names-glyph.name-check_glyph.name-constraint-rule-44</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M40"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">mei-graphicanalysis-att.extSym.names-glyph.num-check_glyph.num-constraint-rule-45</xsl:attribute>
            <xsl:attribute name="name">mei-graphicanalysis-att.extSym.names-glyph.num-check_glyph.num-constraint-rule-45</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M41"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">mei-graphicanalysis-att.facsimile-facs-check_facsTarget-constraint-rule-46</xsl:attribute>
            <xsl:attribute name="name">mei-graphicanalysis-att.facsimile-facs-check_facsTarget-constraint-rule-46</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M42"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">mei-graphicanalysis-graphic-graphic_attributes-constraint-rule-47</xsl:attribute>
            <xsl:attribute name="name">mei-graphicanalysis-graphic-graphic_attributes-constraint-rule-47</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M43"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">mei-graphicanalysis-fing-fing_start-type_attributes_required-constraint-rule-50</xsl:attribute>
            <xsl:attribute name="name">mei-graphicanalysis-fing-fing_start-type_attributes_required-constraint-rule-50</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M44"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">mei-graphicanalysis-fing-stack_exclusion-constraint-rule-51</xsl:attribute>
            <xsl:attribute name="name">mei-graphicanalysis-fing-stack_exclusion-constraint-rule-51</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M45"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">mei-graphicanalysis-fingGrp-require_fingeringLike_children-constraint-rule-52</xsl:attribute>
            <xsl:attribute name="name">mei-graphicanalysis-fingGrp-require_fingeringLike_children-constraint-rule-52</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M46"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M47"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">mei-graphicanalysis-manifestation-check_singleton-constraint-rule-55</xsl:attribute>
            <xsl:attribute name="name">mei-graphicanalysis-manifestation-check_singleton-constraint-rule-55</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M48"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">mei-graphicanalysis-manifestation-check_singleton_availability-constraint-rule-56</xsl:attribute>
            <xsl:attribute name="name">mei-graphicanalysis-manifestation-check_singleton_availability-constraint-rule-56</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M49"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">mei-graphicanalysis-att.geneticState-check_changeState.targets-constraint-rule-57</xsl:attribute>
            <xsl:attribute name="name">mei-graphicanalysis-att.geneticState-check_changeState.targets-constraint-rule-57</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M50"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">mei-graphicanalysis-att.accidental.ges-accid.ges-check_accid_duplication-constraint-rule-58</xsl:attribute>
            <xsl:attribute name="name">mei-graphicanalysis-att.accidental.ges-accid.ges-check_accid_duplication-constraint-rule-58</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M51"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">mei-graphicanalysis-att.note.ges-extremis_disallows_gestural_pitch-constraint-rule-59</xsl:attribute>
            <xsl:attribute name="name">mei-graphicanalysis-att.note.ges-extremis_disallows_gestural_pitch-constraint-rule-59</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M52"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">mei-graphicanalysis-graph-graph_undirected_not_supported-constraint-rule-60</xsl:attribute>
            <xsl:attribute name="name">mei-graphicanalysis-graph-graph_undirected_not_supported-constraint-rule-60</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M53"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">mei-graphicanalysis-node-node_relation_label-constraint-rule-61</xsl:attribute>
            <xsl:attribute name="name">mei-graphicanalysis-node-node_relation_label-constraint-rule-61</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M54"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">mei-graphicanalysis-node-node_relation_label_single_token-constraint-rule-62</xsl:attribute>
            <xsl:attribute name="name">mei-graphicanalysis-node-node_relation_label_single_token-constraint-rule-62</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M55"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">mei-graphicanalysis-node-node_note_label-constraint-rule-63</xsl:attribute>
            <xsl:attribute name="name">mei-graphicanalysis-node-node_note_label-constraint-rule-63</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M56"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">mei-graphicanalysis-node-node_note_corresp_only-constraint-rule-64</xsl:attribute>
            <xsl:attribute name="name">mei-graphicanalysis-node-node_note_corresp_only-constraint-rule-64</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M57"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">mei-graphicanalysis-node-node_note_corresp_target-constraint-rule-65</xsl:attribute>
            <xsl:attribute name="name">mei-graphicanalysis-node-node_note_corresp_target-constraint-rule-65</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M58"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">mei-graphicanalysis-node-node_in_arc-constraint-rule-66</xsl:attribute>
            <xsl:attribute name="name">mei-graphicanalysis-node-node_in_arc-constraint-rule-66</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M59"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">mei-graphicanalysis-arc-arc_targets_exist-constraint-rule-67</xsl:attribute>
            <xsl:attribute name="name">mei-graphicanalysis-arc-arc_targets_exist-constraint-rule-67</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M60"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">mei-graphicanalysis-arc-arc_from_type-constraint-rule-68</xsl:attribute>
            <xsl:attribute name="name">mei-graphicanalysis-arc-arc_from_type-constraint-rule-68</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M61"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">mei-graphicanalysis-arc-arc_to_type-constraint-rule-69</xsl:attribute>
            <xsl:attribute name="name">mei-graphicanalysis-arc-arc_to_type-constraint-rule-69</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M62"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">mei-graphicanalysis-att.harm.log-chordref-check_chordrefTarget-constraint-rule-70</xsl:attribute>
            <xsl:attribute name="name">mei-graphicanalysis-att.harm.log-chordref-check_chordrefTarget-constraint-rule-70</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M63"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">mei-graphicanalysis-harm-harm_start-type_attributes_required-constraint-rule-71</xsl:attribute>
            <xsl:attribute name="name">mei-graphicanalysis-harm-harm_start-type_attributes_required-constraint-rule-71</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M64"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">mei-graphicanalysis-attUsage-context_attribute_requires_content-constraint-rule-72</xsl:attribute>
            <xsl:attribute name="name">mei-graphicanalysis-attUsage-context_attribute_requires_content-constraint-rule-72</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M65"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">mei-graphicanalysis-category-category_id-constraint-rule-73</xsl:attribute>
            <xsl:attribute name="name">mei-graphicanalysis-category-category_id-constraint-rule-73</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M66"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">mei-graphicanalysis-change-check_change-constraint-rule-74</xsl:attribute>
            <xsl:attribute name="name">mei-graphicanalysis-change-check_change-constraint-rule-74</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M67"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">mei-graphicanalysis-componentList-checkComponentList-constraint-rule-75</xsl:attribute>
            <xsl:attribute name="name">mei-graphicanalysis-componentList-checkComponentList-constraint-rule-75</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M68"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">mei-graphicanalysis-componentList-checkComponents-constraint-rule-76</xsl:attribute>
            <xsl:attribute name="name">mei-graphicanalysis-componentList-checkComponents-constraint-rule-76</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M69"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">mei-graphicanalysis-contents-checkContentsLabels-constraint-rule-77</xsl:attribute>
            <xsl:attribute name="name">mei-graphicanalysis-contents-checkContentsLabels-constraint-rule-77</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M70"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">mei-graphicanalysis-handList-checkHandListLabels-constraint-rule-78</xsl:attribute>
            <xsl:attribute name="name">mei-graphicanalysis-handList-checkHandListLabels-constraint-rule-78</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M71"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">mei-graphicanalysis-history-history_restriction-constraint-rule-79</xsl:attribute>
            <xsl:attribute name="name">mei-graphicanalysis-history-history_restriction-constraint-rule-79</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M72"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">mei-graphicanalysis-incipCode-Check_incipCode_form_mimetype-constraint-rule-80</xsl:attribute>
            <xsl:attribute name="name">mei-graphicanalysis-incipCode-Check_incipCode_form_mimetype-constraint-rule-80</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M73"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">mei-graphicanalysis-meiHead-check_meiHead_type-constraint-rule-81</xsl:attribute>
            <xsl:attribute name="name">mei-graphicanalysis-meiHead-check_meiHead_type-constraint-rule-81</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M74"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">mei-graphicanalysis-patch-check_attached_position-constraint-rule-84</xsl:attribute>
            <xsl:attribute name="name">mei-graphicanalysis-patch-check_attached_position-constraint-rule-84</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M75"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">mei-graphicanalysis-source-check_source_target-constraint-rule-85</xsl:attribute>
            <xsl:attribute name="name">mei-graphicanalysis-source-check_source_target-constraint-rule-85</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M76"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">mei-graphicanalysis-tagUsage-context_attribute_requires_content-constraint-rule-86</xsl:attribute>
            <xsl:attribute name="name">mei-graphicanalysis-tagUsage-context_attribute_requires_content-constraint-rule-86</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M77"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">mei-graphicanalysis-termList-checkTermListLabels-constraint-rule-87</xsl:attribute>
            <xsl:attribute name="name">mei-graphicanalysis-termList-checkTermListLabels-constraint-rule-87</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M78"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">mei-graphicanalysis-att.duration.quality-check_duplex_quality-constraint-rule-88</xsl:attribute>
            <xsl:attribute name="name">mei-graphicanalysis-att.duration.quality-check_duplex_quality-constraint-rule-88</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M79"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">mei-graphicanalysis-att.duration.quality-check_maiorminor_quality-constraint-rule-89</xsl:attribute>
            <xsl:attribute name="name">mei-graphicanalysis-att.duration.quality-check_maiorminor_quality-constraint-rule-89</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M80"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">mei-graphicanalysis-att.mensural.shared-mensuration_conflicting_attributes-constraint-rule-90</xsl:attribute>
            <xsl:attribute name="name">mei-graphicanalysis-att.mensural.shared-mensuration_conflicting_attributes-constraint-rule-90</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M81"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">mei-graphicanalysis-plica-Check_plica-constraint-rule-91</xsl:attribute>
            <xsl:attribute name="name">mei-graphicanalysis-plica-Check_plica-constraint-rule-91</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M82"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">mei-graphicanalysis-stem-Check_stem-constraint-rule-92</xsl:attribute>
            <xsl:attribute name="name">mei-graphicanalysis-stem-Check_stem-constraint-rule-92</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M83"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">mei-graphicanalysis-att.instrumentIdent-instr-check_instrTarget-constraint-rule-93</xsl:attribute>
            <xsl:attribute name="name">mei-graphicanalysis-att.instrumentIdent-instr-check_instrTarget-constraint-rule-93</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M84"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">mei-graphicanalysis-att.midiInstrument-One_of_instrname_or_instrnum-constraint-rule-94</xsl:attribute>
            <xsl:attribute name="name">mei-graphicanalysis-att.midiInstrument-One_of_instrname_or_instrnum-constraint-rule-94</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M85"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">mei-graphicanalysis-att.midiInstrument-One_of_patchname_or_patchnum-constraint-rule-95</xsl:attribute>
            <xsl:attribute name="name">mei-graphicanalysis-att.midiInstrument-One_of_patchname_or_patchnum-constraint-rule-95</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M86"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">mei-graphicanalysis-att.componentType-comptype-checkComponentType-constraint-rule-96</xsl:attribute>
            <xsl:attribute name="name">mei-graphicanalysis-att.componentType-comptype-checkComponentType-constraint-rule-96</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M87"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">mei-graphicanalysis-catchwords-check_catchwords_inline-constraint-rule-97</xsl:attribute>
            <xsl:attribute name="name">mei-graphicanalysis-catchwords-check_catchwords_inline-constraint-rule-97</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M88"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">mei-graphicanalysis-locusGrp-check_locusGrp_inline-constraint-rule-98</xsl:attribute>
            <xsl:attribute name="name">mei-graphicanalysis-locusGrp-check_locusGrp_inline-constraint-rule-98</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M89"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">mei-graphicanalysis-secFolio-check_secFolio_inline-constraint-rule-99</xsl:attribute>
            <xsl:attribute name="name">mei-graphicanalysis-secFolio-check_secFolio_inline-constraint-rule-99</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M90"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">mei-graphicanalysis-signatures-check_signatures_inline-constraint-rule-100</xsl:attribute>
            <xsl:attribute name="name">mei-graphicanalysis-signatures-check_signatures_inline-constraint-rule-100</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M91"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">mei-graphicanalysis-att.alignment-check_whenTarget-constraint-rule-101</xsl:attribute>
            <xsl:attribute name="name">mei-graphicanalysis-att.alignment-check_whenTarget-constraint-rule-101</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M92"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">mei-graphicanalysis-avFile-avFile_child_of_clip-constraint-rule-102</xsl:attribute>
            <xsl:attribute name="name">mei-graphicanalysis-avFile-avFile_child_of_clip-constraint-rule-102</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M93"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">mei-graphicanalysis-clip-betype_required_when_begin_or_end-constraint-rule-103</xsl:attribute>
            <xsl:attribute name="name">mei-graphicanalysis-clip-betype_required_when_begin_or_end-constraint-rule-103</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M94"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">mei-graphicanalysis-recording-betype_required_when_begin_or_end-constraint-rule-104</xsl:attribute>
            <xsl:attribute name="name">mei-graphicanalysis-recording-betype_required_when_begin_or_end-constraint-rule-104</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M95"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">mei-graphicanalysis-when-check_when_interval-constraint-rule-105</xsl:attribute>
            <xsl:attribute name="name">mei-graphicanalysis-when-check_when_interval-constraint-rule-105</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M96"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">mei-graphicanalysis-when-check_when_absolute-constraint-rule-108</xsl:attribute>
            <xsl:attribute name="name">mei-graphicanalysis-when-check_when_absolute-constraint-rule-108</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M97"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">mei-graphicanalysis-when-since-check_sinceTarget-constraint-rule-109</xsl:attribute>
            <xsl:attribute name="name">mei-graphicanalysis-when-since-check_sinceTarget-constraint-rule-109</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M98"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">mei-graphicanalysis-att.attacca.log-target-check_attaccaTarget-constraint-rule-110</xsl:attribute>
            <xsl:attribute name="name">mei-graphicanalysis-att.attacca.log-target-check_attaccaTarget-constraint-rule-110</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M99"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">mei-graphicanalysis-att.augmentDots-dots-dots_attribute_requires_dur-constraint-rule-111</xsl:attribute>
            <xsl:attribute name="name">mei-graphicanalysis-att.augmentDots-dots-dots_attribute_requires_dur-constraint-rule-111</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M100"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">mei-graphicanalysis-att.barring-bar.method-check_barmethod-constraint-rule-112</xsl:attribute>
            <xsl:attribute name="name">mei-graphicanalysis-att.barring-bar.method-check_barmethod-constraint-rule-112</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M101"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">mei-graphicanalysis-att.classed-class-check_classURI-constraint-rule-113</xsl:attribute>
            <xsl:attribute name="name">mei-graphicanalysis-att.classed-class-check_classURI-constraint-rule-113</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M102"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">mei-graphicanalysis-att.cleffing.log-clef_shape_requires_clef_line-constraint-rule-114</xsl:attribute>
            <xsl:attribute name="name">mei-graphicanalysis-att.cleffing.log-clef_shape_requires_clef_line-constraint-rule-114</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M103"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">mei-graphicanalysis-att.clefShape-shape_requires_line-constraint-rule-116</xsl:attribute>
            <xsl:attribute name="name">mei-graphicanalysis-att.clefShape-shape_requires_line-constraint-rule-116</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M104"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">mei-graphicanalysis-att.custos.log-target-check_custosTarget-constraint-rule-117</xsl:attribute>
            <xsl:attribute name="name">mei-graphicanalysis-att.custos.log-target-check_custosTarget-constraint-rule-117</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M105"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">mei-graphicanalysis-att.dataPointing-data-check_dataTarget-constraint-rule-118</xsl:attribute>
            <xsl:attribute name="name">mei-graphicanalysis-att.dataPointing-data-check_dataTarget-constraint-rule-118</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M106"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">mei-graphicanalysis-att.metadataPointing-decls-check_declsTarget-constraint-rule-119</xsl:attribute>
            <xsl:attribute name="name">mei-graphicanalysis-att.metadataPointing-decls-check_declsTarget-constraint-rule-119</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M107"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">mei-graphicanalysis-att.extent-extent-check_extent-constraint-rule-120</xsl:attribute>
            <xsl:attribute name="name">mei-graphicanalysis-att.extent-extent-check_extent-constraint-rule-120</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M108"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">mei-graphicanalysis-att.handIdent-hand-check_handTarget-constraint-rule-122</xsl:attribute>
            <xsl:attribute name="name">mei-graphicanalysis-att.handIdent-hand-check_handTarget-constraint-rule-122</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M109"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">mei-graphicanalysis-att.joined-join-check_joinTarget-constraint-rule-123</xsl:attribute>
            <xsl:attribute name="name">mei-graphicanalysis-att.joined-join-check_joinTarget-constraint-rule-123</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M110"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">mei-graphicanalysis-att.layer.log-def-check_defTarget_layer-constraint-rule-124</xsl:attribute>
            <xsl:attribute name="name">mei-graphicanalysis-att.layer.log-def-check_defTarget_layer-constraint-rule-124</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M111"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">mei-graphicanalysis-att.lineRend.base-lsegs-check_lsegs-constraint-rule-125</xsl:attribute>
            <xsl:attribute name="name">mei-graphicanalysis-att.lineRend.base-lsegs-check_lsegs-constraint-rule-125</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M112"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">mei-graphicanalysis-att.linking-copyof-When_copyof_element_empty-constraint-rule-126</xsl:attribute>
            <xsl:attribute name="name">mei-graphicanalysis-att.linking-copyof-When_copyof_element_empty-constraint-rule-126</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M113"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">mei-graphicanalysis-att.linking-copyof-check_copyofTarget-constraint-rule-127</xsl:attribute>
            <xsl:attribute name="name">mei-graphicanalysis-att.linking-copyof-check_copyofTarget-constraint-rule-127</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M114"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">mei-graphicanalysis-att.linking-corresp-check_correspTarget-constraint-rule-128</xsl:attribute>
            <xsl:attribute name="name">mei-graphicanalysis-att.linking-corresp-check_correspTarget-constraint-rule-128</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M115"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">mei-graphicanalysis-att.linking-follows-check_followsTarget-constraint-rule-129</xsl:attribute>
            <xsl:attribute name="name">mei-graphicanalysis-att.linking-follows-check_followsTarget-constraint-rule-129</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M116"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">mei-graphicanalysis-att.linking-next-check_nextTarget-constraint-rule-130</xsl:attribute>
            <xsl:attribute name="name">mei-graphicanalysis-att.linking-next-check_nextTarget-constraint-rule-130</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M117"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">mei-graphicanalysis-att.linking-precedes-check_precedesTarget-constraint-rule-131</xsl:attribute>
            <xsl:attribute name="name">mei-graphicanalysis-att.linking-precedes-check_precedesTarget-constraint-rule-131</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M118"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">mei-graphicanalysis-att.linking-prev-check_prevTarget-constraint-rule-132</xsl:attribute>
            <xsl:attribute name="name">mei-graphicanalysis-att.linking-prev-check_prevTarget-constraint-rule-132</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M119"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">mei-graphicanalysis-att.linking-sameas-check_sameasTarget-constraint-rule-133</xsl:attribute>
            <xsl:attribute name="name">mei-graphicanalysis-att.linking-sameas-check_sameasTarget-constraint-rule-133</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M120"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">mei-graphicanalysis-att.linking-synch-check_synchTarget-constraint-rule-134</xsl:attribute>
            <xsl:attribute name="name">mei-graphicanalysis-att.linking-synch-check_synchTarget-constraint-rule-134</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M121"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">mei-graphicanalysis-att.meiVersion-meiVersion.onlyRoot-constraint-rule-135</xsl:attribute>
            <xsl:attribute name="name">mei-graphicanalysis-att.meiVersion-meiVersion.onlyRoot-constraint-rule-135</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M122"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">mei-graphicanalysis-att.name-nymref-check_nymrefTarget-constraint-rule-136</xsl:attribute>
            <xsl:attribute name="name">mei-graphicanalysis-att.name-nymref-check_nymrefTarget-constraint-rule-136</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M123"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">mei-graphicanalysis-att.noteHeads-head.altsym-check_head.altsymTarget-constraint-rule-137</xsl:attribute>
            <xsl:attribute name="name">mei-graphicanalysis-att.noteHeads-head.altsym-check_head.altsymTarget-constraint-rule-137</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M124"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">mei-graphicanalysis-att.noteHeads-head.auth-check_head.auth-constraint-rule-138</xsl:attribute>
            <xsl:attribute name="name">mei-graphicanalysis-att.noteHeads-head.auth-check_head.auth-constraint-rule-138</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M125"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">mei-graphicanalysis-att.noteHeads-head.shape-check_headshape_num-constraint-rule-139</xsl:attribute>
            <xsl:attribute name="name">mei-graphicanalysis-att.noteHeads-head.shape-check_headshape_num-constraint-rule-139</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M126"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">mei-graphicanalysis-att.origin.timestamp.log-origin.tstamp2-origin.tstamp2_requires_origin.tstamp-constraint-rule-140</xsl:attribute>
            <xsl:attribute name="name">mei-graphicanalysis-att.origin.timestamp.log-origin.tstamp2-origin.tstamp2_requires_origin.tstamp-constraint-rule-140</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M127"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">mei-graphicanalysis-att.partIdent-part-check_part_attr_all-constraint-rule-141</xsl:attribute>
            <xsl:attribute name="name">mei-graphicanalysis-att.partIdent-part-check_part_attr_all-constraint-rule-141</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M128"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">mei-graphicanalysis-att.partIdent-partstaff-check_partstaff_attr_all-constraint-rule-142</xsl:attribute>
            <xsl:attribute name="name">mei-graphicanalysis-att.partIdent-partstaff-check_partstaff_attr_all-constraint-rule-142</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M129"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">mei-graphicanalysis-att.plist-plist-check_plistTarget-constraint-rule-143</xsl:attribute>
            <xsl:attribute name="name">mei-graphicanalysis-att.plist-plist-check_plistTarget-constraint-rule-143</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M130"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">mei-graphicanalysis-att.ranging-confidence-check_confidence-constraint-rule-144</xsl:attribute>
            <xsl:attribute name="name">mei-graphicanalysis-att.ranging-confidence-check_confidence-constraint-rule-144</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M131"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">mei-graphicanalysis-att.responsibility-resp-check_respTarget-constraint-rule-145</xsl:attribute>
            <xsl:attribute name="name">mei-graphicanalysis-att.responsibility-resp-check_respTarget-constraint-rule-145</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M132"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">mei-graphicanalysis-att.source-source-check_sourceTarget-constraint-rule-146</xsl:attribute>
            <xsl:attribute name="name">mei-graphicanalysis-att.source-source-check_sourceTarget-constraint-rule-146</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M133"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">mei-graphicanalysis-att.staff.log-def-check_defTarget_staff-constraint-rule-147</xsl:attribute>
            <xsl:attribute name="name">mei-graphicanalysis-att.staff.log-def-check_defTarget_staff-constraint-rule-147</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M134"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">mei-graphicanalysis-att.startEndId-endid-check_endidTarget-constraint-rule-148</xsl:attribute>
            <xsl:attribute name="name">mei-graphicanalysis-att.startEndId-endid-check_endidTarget-constraint-rule-148</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M135"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">mei-graphicanalysis-att.startId-startid-check_startidTarget-constraint-rule-149</xsl:attribute>
            <xsl:attribute name="name">mei-graphicanalysis-att.startId-startid-check_startidTarget-constraint-rule-149</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M136"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">mei-graphicanalysis-att.stems-stem.sameas-check_stem.sameasTarget-constraint-rule-150</xsl:attribute>
            <xsl:attribute name="name">mei-graphicanalysis-att.stems-stem.sameas-check_stem.sameasTarget-constraint-rule-150</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M137"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">mei-graphicanalysis-annot-Check_annot_data-constraint-rule-151</xsl:attribute>
            <xsl:attribute name="name">mei-graphicanalysis-annot-Check_annot_data-constraint-rule-151</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M138"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">mei-graphicanalysis-biblList-checkBiblLabels-constraint-rule-152</xsl:attribute>
            <xsl:attribute name="name">mei-graphicanalysis-biblList-checkBiblLabels-constraint-rule-152</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M139"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">mei-graphicanalysis-caesura-caesura_start-type_attributes_required-constraint-rule-153</xsl:attribute>
            <xsl:attribute name="name">mei-graphicanalysis-caesura-caesura_start-type_attributes_required-constraint-rule-153</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M140"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">mei-graphicanalysis-cb-n-check_cb-constraint-rule-154</xsl:attribute>
            <xsl:attribute name="name">mei-graphicanalysis-cb-n-check_cb-constraint-rule-154</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M141"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">mei-graphicanalysis-clef-Clef_position_lines-constraint-rule-155</xsl:attribute>
            <xsl:attribute name="name">mei-graphicanalysis-clef-Clef_position_lines-constraint-rule-155</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M142"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">mei-graphicanalysis-clef-Clef_position_nolines-constraint-rule-156</xsl:attribute>
            <xsl:attribute name="name">mei-graphicanalysis-clef-Clef_position_nolines-constraint-rule-156</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M143"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">mei-graphicanalysis-dimensions-check_dimensions-constraint-rule-157</xsl:attribute>
            <xsl:attribute name="name">mei-graphicanalysis-dimensions-check_dimensions-constraint-rule-157</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M144"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">mei-graphicanalysis-dir-dir_start-type_attributes_required-constraint-rule-158</xsl:attribute>
            <xsl:attribute name="name">mei-graphicanalysis-dir-dir_start-type_attributes_required-constraint-rule-158</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M145"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">mei-graphicanalysis-dynam-dynam_start-type_attributes_required-constraint-rule-159</xsl:attribute>
            <xsl:attribute name="name">mei-graphicanalysis-dynam-dynam_start-type_attributes_required-constraint-rule-159</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M146"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">mei-graphicanalysis-dynam-dynam_end-type_attributes-constraint-rule-160</xsl:attribute>
            <xsl:attribute name="name">mei-graphicanalysis-dynam-dynam_end-type_attributes-constraint-rule-160</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M147"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">mei-graphicanalysis-grpSym-check_grpSym_attributes_scoreDef-constraint-rule-161</xsl:attribute>
            <xsl:attribute name="name">mei-graphicanalysis-grpSym-check_grpSym_attributes_scoreDef-constraint-rule-161</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M148"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">mei-graphicanalysis-grpSym-check_grpSym_attributes_staffDef-constraint-rule-162</xsl:attribute>
            <xsl:attribute name="name">mei-graphicanalysis-grpSym-check_grpSym_attributes_staffDef-constraint-rule-162</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M149"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">mei-graphicanalysis-keyAccid-Check_keyAccidPlacement-constraint-rule-163</xsl:attribute>
            <xsl:attribute name="name">mei-graphicanalysis-keyAccid-Check_keyAccidPlacement-constraint-rule-163</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M150"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">mei-graphicanalysis-keySig-check_keyAccid_oct-constraint-rule-164</xsl:attribute>
            <xsl:attribute name="name">mei-graphicanalysis-keySig-check_keyAccid_oct-constraint-rule-164</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M151"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">mei-graphicanalysis-keySig-check_keySig_editorial-constraint-rule-165</xsl:attribute>
            <xsl:attribute name="name">mei-graphicanalysis-keySig-check_keySig_editorial-constraint-rule-165</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M152"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">mei-graphicanalysis-label-label_note_only_in_graph-constraint-rule-166</xsl:attribute>
            <xsl:attribute name="name">mei-graphicanalysis-label-label_note_only_in_graph-constraint-rule-166</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M153"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">mei-graphicanalysis-mei-Check_staff-constraint-rule-167</xsl:attribute>
            <xsl:attribute name="name">mei-graphicanalysis-mei-Check_staff-constraint-rule-167</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M154"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">mei-graphicanalysis-name-nameParts-constraint-rule-168</xsl:attribute>
            <xsl:attribute name="name">mei-graphicanalysis-name-nameParts-constraint-rule-168</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M155"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">mei-graphicanalysis-ornam-ornam_start-type_attributes_required-constraint-rule-169</xsl:attribute>
            <xsl:attribute name="name">mei-graphicanalysis-ornam-ornam_start-type_attributes_required-constraint-rule-169</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M156"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">mei-graphicanalysis-phrase-phrase_start-_and_end-type_attributes_required-constraint-rule-170</xsl:attribute>
            <xsl:attribute name="name">mei-graphicanalysis-phrase-phrase_start-_and_end-type_attributes_required-constraint-rule-170</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M157"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">mei-graphicanalysis-phrase-phrase_containing_curve-constraint-rule-171</xsl:attribute>
            <xsl:attribute name="name">mei-graphicanalysis-phrase-phrase_containing_curve-constraint-rule-171</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M158"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">mei-graphicanalysis-relation-FRBR_relation-constraint-rule-172</xsl:attribute>
            <xsl:attribute name="name">mei-graphicanalysis-relation-FRBR_relation-constraint-rule-172</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M159"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">mei-graphicanalysis-respStmt-check_respStmt-constraint-rule-173</xsl:attribute>
            <xsl:attribute name="name">mei-graphicanalysis-respStmt-check_respStmt-constraint-rule-173</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M160"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">mei-graphicanalysis-section-Check_sectionexpansion-constraint-rule-175</xsl:attribute>
            <xsl:attribute name="name">mei-graphicanalysis-section-Check_sectionexpansion-constraint-rule-175</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M161"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">mei-graphicanalysis-staff-checkStaff_n-constraint-rule-176</xsl:attribute>
            <xsl:attribute name="name">mei-graphicanalysis-staff-checkStaff_n-constraint-rule-176</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M162"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">mei-graphicanalysis-staffDef-Check_staffDefn-constraint-rule-177</xsl:attribute>
            <xsl:attribute name="name">mei-graphicanalysis-staffDef-Check_staffDefn-constraint-rule-177</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M163"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">mei-graphicanalysis-staffDef-Check_ancestor_staff-constraint-rule-178</xsl:attribute>
            <xsl:attribute name="name">mei-graphicanalysis-staffDef-Check_ancestor_staff-constraint-rule-178</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M164"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">mei-graphicanalysis-staffDef-Check_ancestor_staff_lines-constraint-rule-179</xsl:attribute>
            <xsl:attribute name="name">mei-graphicanalysis-staffDef-Check_ancestor_staff_lines-constraint-rule-179</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M165"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">mei-graphicanalysis-staffDef-Check_clef_position_staffDef-constraint-rule-180</xsl:attribute>
            <xsl:attribute name="name">mei-graphicanalysis-staffDef-Check_clef_position_staffDef-constraint-rule-180</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M166"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">mei-graphicanalysis-staffDef-Check_clef_position_staffDef_nolines-constraint-rule-181</xsl:attribute>
            <xsl:attribute name="name">mei-graphicanalysis-staffDef-Check_clef_position_staffDef_nolines-constraint-rule-181</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M167"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">mei-graphicanalysis-staffDef-Check_tab_strings_lines-constraint-rule-182</xsl:attribute>
            <xsl:attribute name="name">mei-graphicanalysis-staffDef-Check_tab_strings_lines-constraint-rule-182</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M168"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">mei-graphicanalysis-staffDef-Check_tab_strings_nolines-constraint-rule-183</xsl:attribute>
            <xsl:attribute name="name">mei-graphicanalysis-staffDef-Check_tab_strings_nolines-constraint-rule-183</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M169"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M170"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M171"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M172"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">mei-graphicanalysis-staffGrp-Check_staffGrp_unique_staff_n_values-constraint-rule-188</xsl:attribute>
            <xsl:attribute name="name">mei-graphicanalysis-staffGrp-Check_staffGrp_unique_staff_n_values-constraint-rule-188</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M173"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">mei-graphicanalysis-symbol-symbolDef_symbol_attributes_required-constraint-rule-189</xsl:attribute>
            <xsl:attribute name="name">mei-graphicanalysis-symbol-symbolDef_symbol_attributes_required-constraint-rule-189</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M174"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">mei-graphicanalysis-tempo-tempo_in_header_disallow_most_attrs-constraint-rule-190</xsl:attribute>
            <xsl:attribute name="name">mei-graphicanalysis-tempo-tempo_in_header_disallow_most_attrs-constraint-rule-190</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M175"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">mei-graphicanalysis-tempo-tempo_start-type_attributes_required-constraint-rule-191</xsl:attribute>
            <xsl:attribute name="name">mei-graphicanalysis-tempo-tempo_start-type_attributes_required-constraint-rule-191</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M176"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">mei-graphicanalysis-term-Check_term_dataTarget-constraint-rule-192</xsl:attribute>
            <xsl:attribute name="name">mei-graphicanalysis-term-Check_term_dataTarget-constraint-rule-192</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M177"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">mei-graphicanalysis-tabGrp-check_tabGrp_in_beam-constraint-rule-193</xsl:attribute>
            <xsl:attribute name="name">mei-graphicanalysis-tabGrp-check_tabGrp_in_beam-constraint-rule-193</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M178"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">mei-graphicanalysis-list-list_type_constraint-constraint-rule-194</xsl:attribute>
            <xsl:attribute name="name">mei-graphicanalysis-list-list_type_constraint-constraint-rule-194</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M179"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">mei-graphicanalysis-att.altSym-altsym-check_altsymTarget-constraint-rule-195</xsl:attribute>
            <xsl:attribute name="name">mei-graphicanalysis-att.altSym-altsym-check_altsymTarget-constraint-rule-195</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M180"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">mei-graphicanalysis-curve-symbolDef_curve_attributes_required-constraint-rule-196</xsl:attribute>
            <xsl:attribute name="name">mei-graphicanalysis-curve-symbolDef_curve_attributes_required-constraint-rule-196</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M181"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">mei-graphicanalysis-line-line_start-_and_end-type_attributes_required-constraint-rule-197</xsl:attribute>
            <xsl:attribute name="name">mei-graphicanalysis-line-line_start-_and_end-type_attributes_required-constraint-rule-197</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M182"/>
         <svrl:active-pattern>
            <xsl:attribute name="document">
               <xsl:value-of select="document-uri(/)"/>
            </xsl:attribute>
            <xsl:attribute name="id">mei-graphicanalysis-att.fTrem.vis-beams.float-check_beams.floating-constraint-rule-199</xsl:attribute>
            <xsl:attribute name="name">mei-graphicanalysis-att.fTrem.vis-beams.float-check_beams.floating-constraint-rule-199</xsl:attribute>
            <xsl:apply-templates/>
         </svrl:active-pattern>
         <xsl:apply-templates select="/" mode="M183"/>
      </svrl:schematron-output>
   </xsl:template>
   <!--SCHEMATRON PATTERNS-->

   <!--PATTERN mei-graphicanalysis-att.notationType-notationsubtype-When_notationsubtype-constraint-rule-5-->

   <!--RULE -->
   <xsl:template match="mei:*[@notationsubtype]" priority="1000" mode="M3">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="mei:*[@notationsubtype]"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="@notationtype"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="@notationtype">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>An element with a notationsubtype attribute must have
                a notationtype attribute.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M3"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M3"/>
   <xsl:template match="@*|node()" priority="-2" mode="M3">
      <xsl:apply-templates select="*" mode="M3"/>
   </xsl:template>
   <!--PATTERN mei-graphicanalysis-att.beamRend-place-check_beam_place-constraint-rule-6-->

   <!--RULE -->
   <xsl:template match="mei:beam[@place eq 'mixed' and not(descendant::mei:*[local-name() eq 'note' or local-name() eq 'chord'][@staff != ./@staff] or descendant::mei:*[local-name() eq 'note' or local-name() eq 'chord'][@staff != ancestor::mei:staff/@n])]"
                 priority="1001"
                 mode="M4">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="mei:beam[@place eq 'mixed' and not(descendant::mei:*[local-name() eq 'note' or local-name() eq 'chord'][@staff != ./@staff] or descendant::mei:*[local-name() eq 'note' or local-name() eq 'chord'][@staff != ancestor::mei:staff/@n])]"/>
      <!--ASSERT warning-->
      <xsl:choose>
         <xsl:when test="count(descendant::mei:*[local-name() eq 'note' or local-name() eq 'chord'][@stem.dir]) = count(descendant::mei:*[local-name() eq 'note' or local-name() eq 'chord'])"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="count(descendant::mei:*[local-name() eq 'note' or local-name() eq 'chord'][@stem.dir]) = count(descendant::mei:*[local-name() eq 'note' or local-name() eq 'chord'])">
               <xsl:attribute name="role">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Stem directions should be specified for all notes and chords under the
                beam.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(distinct-values(descendant::mei:*[local-name() eq 'note' or local-name() eq 'chord']/@stem.dir)) != 1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="count(distinct-values(descendant::mei:*[local-name() eq 'note' or local-name() eq 'chord']/@stem.dir)) != 1">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Opposing stem directions are required for a beam with @place="mixed".</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M4"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="mei:beam[@place eq 'mixed' and (descendant::mei:*[local-name() eq 'note' or local-name() eq 'chord'][@staff != ./@staff] or descendant::mei:*[local-name() eq 'note' or local-name() eq 'chord'][@staff != ancestor::mei:staff/@n]) and count(descendant::mei:*[local-name() eq 'note' or local-name() eq 'chord']/@stem.dir) = count(descendant::mei:*[local-name() eq 'note' or local-name() eq 'chord'])]"
                 priority="1000"
                 mode="M4">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="mei:beam[@place eq 'mixed' and (descendant::mei:*[local-name() eq 'note' or local-name() eq 'chord'][@staff != ./@staff] or descendant::mei:*[local-name() eq 'note' or local-name() eq 'chord'][@staff != ancestor::mei:staff/@n]) and count(descendant::mei:*[local-name() eq 'note' or local-name() eq 'chord']/@stem.dir) = count(descendant::mei:*[local-name() eq 'note' or local-name() eq 'chord'])]"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(distinct-values(descendant::mei:*[local-name() eq 'note' or local-name() eq 'chord']/@stem.dir)) != 1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="count(distinct-values(descendant::mei:*[local-name() eq 'note' or local-name() eq 'chord']/@stem.dir)) != 1">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Opposing stem directions are required for a beam with @place="mixed".</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M4"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M4"/>
   <xsl:template match="@*|node()" priority="-2" mode="M4">
      <xsl:apply-templates select="*" mode="M4"/>
   </xsl:template>
   <!--PATTERN mei-graphicanalysis-attacca-attacca_start-type_attributes_required-constraint-rule-8-->

   <!--RULE -->
   <xsl:template match="mei:attacca[not(ancestor::mei:syllable)]"
                 priority="1000"
                 mode="M5">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="mei:attacca[not(ancestor::mei:syllable)]"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="@startid or @tstamp or @tstamp.ges or @tstamp.real"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="@startid or @tstamp or @tstamp.ges or @tstamp.real">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Must have one of the
            attributes: startid, tstamp, tstamp.ges or tstamp.real.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M5"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M5"/>
   <xsl:template match="@*|node()" priority="-2" mode="M5">
      <xsl:apply-templates select="*" mode="M5"/>
   </xsl:template>
   <!--PATTERN mei-graphicanalysis-beam-When_not_copyof_beam_content-constraint-rule-9-->

   <!--RULE -->
   <xsl:template match="mei:beam[not(@copyof or @sameas)]" priority="1000" mode="M6">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="mei:beam[not(@copyof or @sameas)]"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(descendant::*[local-name()='note' or local-name()='rest' or               local-name()='chord' or local-name()='space']) &gt; 1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="count(descendant::*[local-name()='note' or local-name()='rest' or local-name()='chord' or local-name()='space']) &gt; 1">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>A beam that contains neither a copyof nor sameas attribute must have at least 2 note, rest, chord, or space
            descendants.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M6"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M6"/>
   <xsl:template match="@*|node()" priority="-2" mode="M6">
      <xsl:apply-templates select="*" mode="M6"/>
   </xsl:template>
   <!--PATTERN mei-graphicanalysis-beamSpan-beamspan_start-_and_end-type_attributes_required-constraint-rule-10-->

   <!--RULE -->
   <xsl:template match="mei:beamSpan" priority="1000" mode="M7">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="mei:beamSpan"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="@startid or @tstamp or @tstamp.ges or @tstamp.real"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="@startid or @tstamp or @tstamp.ges or @tstamp.real">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Must have one of the
            attributes: startid, tstamp, tstamp.ges or tstamp.real.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="@dur or @dur.ges or @endid or @tstamp2"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="@dur or @dur.ges or @endid or @tstamp2">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Must have one of the attributes:
            dur, dur.ges, endid, or tstamp2.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M7"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M7"/>
   <xsl:template match="@*|node()" priority="-2" mode="M7">
      <xsl:apply-templates select="*" mode="M7"/>
   </xsl:template>
   <!--PATTERN mei-graphicanalysis-bend-bend_start-_and_end-type_attributes_required-constraint-rule-11-->

   <!--RULE -->
   <xsl:template match="mei:bend" priority="1000" mode="M8">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="mei:bend"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="@startid or @tstamp or @tstamp.ges or @tstamp.real"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="@startid or @tstamp or @tstamp.ges or @tstamp.real">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Must have one of the
            attributes: startid, tstamp, tstamp.ges or tstamp.real.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="@dur or @dur.ges or @endid or @tstamp2"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="@dur or @dur.ges or @endid or @tstamp2">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Must have one of the attributes:
            dur, dur.ges, endid, or tstamp2.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M8"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M8"/>
   <xsl:template match="@*|node()" priority="-2" mode="M8">
      <xsl:apply-templates select="*" mode="M8"/>
   </xsl:template>
   <!--PATTERN mei-graphicanalysis-bracketSpan-bracketSpan_start-_and_end-type_attributes_required-constraint-rule-12-->

   <!--RULE -->
   <xsl:template match="mei:bracketSpan" priority="1000" mode="M9">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="mei:bracketSpan"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="@startid or @tstamp or @tstamp.ges or @tstamp.real"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="@startid or @tstamp or @tstamp.ges or @tstamp.real">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Must have one of the
            attributes: startid, tstamp, tstamp.ges or tstamp.real.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="@dur or @dur.ges or @endid or @tstamp2"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="@dur or @dur.ges or @endid or @tstamp2">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Must have one of the attributes:
            dur, dur.ges, endid, or tstamp2.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M9"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M9"/>
   <xsl:template match="@*|node()" priority="-2" mode="M9">
      <xsl:apply-templates select="*" mode="M9"/>
   </xsl:template>
   <!--PATTERN mei-graphicanalysis-breath-breath_start-type_attributes_required-constraint-rule-13-->

   <!--RULE -->
   <xsl:template match="mei:breath" priority="1000" mode="M10">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="mei:breath"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="@startid or @tstamp or @tstamp.ges or @tstamp.real"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="@startid or @tstamp or @tstamp.ges or @tstamp.real">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Must have one of the
            attributes: startid, tstamp, tstamp.ges or tstamp.real.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M10"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M10"/>
   <xsl:template match="@*|node()" priority="-2" mode="M10">
      <xsl:apply-templates select="*" mode="M10"/>
   </xsl:template>
   <!--PATTERN mei-graphicanalysis-fermata-fermata_start-type_attributes_required-constraint-rule-14-->

   <!--RULE -->
   <xsl:template match="mei:fermata" priority="1000" mode="M11">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="mei:fermata"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="@startid or @tstamp or @tstamp.ges or @tstamp.real"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="@startid or @tstamp or @tstamp.ges or @tstamp.real">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Must have one of the
            attributes: startid, tstamp, tstamp.ges or tstamp.real.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M11"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M11"/>
   <xsl:template match="@*|node()" priority="-2" mode="M11">
      <xsl:apply-templates select="*" mode="M11"/>
   </xsl:template>
   <!--PATTERN mei-graphicanalysis-gliss-gliss_start-_and_end-type_attributes_required-constraint-rule-15-->

   <!--RULE -->
   <xsl:template match="mei:gliss" priority="1000" mode="M12">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="mei:gliss"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="@startid or @tstamp or @tstamp.ges or @tstamp.real"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="@startid or @tstamp or @tstamp.ges or @tstamp.real">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Must have one of the
            attributes: startid, tstamp, tstamp.ges or tstamp.real.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="@dur or @dur.ges or @endid or @tstamp2"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="@dur or @dur.ges or @endid or @tstamp2">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Must have one of the attributes:
            dur, dur.ges, endid, or tstamp2.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M12"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M12"/>
   <xsl:template match="@*|node()" priority="-2" mode="M12">
      <xsl:apply-templates select="*" mode="M12"/>
   </xsl:template>
   <!--PATTERN mei-graphicanalysis-graceGrp-When_not_copyof_graceGrp_content-constraint-rule-16-->

   <!--RULE -->
   <xsl:template match="mei:graceGrp[not(@copyof)]" priority="1000" mode="M13">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="mei:graceGrp[not(@copyof)]"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(descendant::*[local-name()='note' or local-name()='rest' or               local-name()='chord' or local-name()='space']) &gt; 0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="count(descendant::*[local-name()='note' or local-name()='rest' or local-name()='chord' or local-name()='space']) &gt; 0">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>A graceGrp without a copyof attribute must have at least 1 note, rest, chord, or space
            descendants.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M13"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M13"/>
   <xsl:template match="@*|node()" priority="-2" mode="M13">
      <xsl:apply-templates select="*" mode="M13"/>
   </xsl:template>
   <!--PATTERN mei-graphicanalysis-graceGrp-When_graced-constraint-rule-17-->

   <!--RULE -->
   <xsl:template match="mei:graceGrp[@grace]" priority="1000" mode="M14">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="mei:graceGrp[@grace]"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(descendant::mei:*[@grace])"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not(descendant::mei:*[@grace])">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>The grace attribute is not allowed on
            descendants of a graceGrp with a grace attribute.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M14"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M14"/>
   <xsl:template match="@*|node()" priority="-2" mode="M14">
      <xsl:apply-templates select="*" mode="M14"/>
   </xsl:template>
   <!--PATTERN mei-graphicanalysis-hairpin-hairpin_start-_and_end-type_attributes_required-constraint-rule-18-->

   <!--RULE -->
   <xsl:template match="mei:hairpin" priority="1000" mode="M15">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="mei:hairpin"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="@startid or @tstamp or @tstamp.ges or @tstamp.real"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="@startid or @tstamp or @tstamp.ges or @tstamp.real">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Must have one of the
            attributes: startid, tstamp, tstamp.ges or tstamp.real.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="@dur or @dur.ges or @endid or @tstamp2"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="@dur or @dur.ges or @endid or @tstamp2">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Must have one of the attributes:
            dur, dur.ges, endid, or tstamp2.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M15"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M15"/>
   <xsl:template match="@*|node()" priority="-2" mode="M15">
      <xsl:apply-templates select="*" mode="M15"/>
   </xsl:template>
   <!--PATTERN mei-graphicanalysis-harpPedal-harpPedal_start-type_attributes_required-constraint-rule-19-->

   <!--RULE -->
   <xsl:template match="mei:harpPedal" priority="1000" mode="M16">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="mei:harpPedal"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="@startid or @tstamp or @tstamp.ges or @tstamp.real"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="@startid or @tstamp or @tstamp.ges or @tstamp.real">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Must have one of the
            attributes: startid, tstamp, tstamp.ges or tstamp.real.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M16"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M16"/>
   <xsl:template match="@*|node()" priority="-2" mode="M16">
      <xsl:apply-templates select="*" mode="M16"/>
   </xsl:template>
   <!--PATTERN mei-graphicanalysis-lv-lv_start-_and_end-type_attributes_required-constraint-rule-20-->

   <!--RULE -->
   <xsl:template match="mei:lv" priority="1000" mode="M17">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="mei:lv"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="@startid or @tstamp or @tstamp.ges or @tstamp.real"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="@startid or @tstamp or @tstamp.ges or @tstamp.real">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Must have one of the
            attributes: startid, tstamp, tstamp.ges or tstamp.real.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M17"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M17"/>
   <xsl:template match="@*|node()" priority="-2" mode="M17">
      <xsl:apply-templates select="*" mode="M17"/>
   </xsl:template>
   <!--PATTERN mei-graphicanalysis-lv-lv_containing_curve-constraint-rule-21-->

   <!--RULE -->
   <xsl:template match="mei:lv[mei:curve[@bezier or @bulge or @curvedir or @lform or @lwidth or @ho or @startho or @endho or @to or @startto or @endto or @vo or @startvo or              @endvo or @x or @y or @x2 or @y2]]"
                 priority="1000"
                 mode="M18">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="mei:lv[mei:curve[@bezier or @bulge or @curvedir or @lform or @lwidth or @ho or @startho or @endho or @to or @startto or @endto or @vo or @startvo or              @endvo or @x or @y or @x2 or @y2]]"/>
      <!--ASSERT warning-->
      <xsl:choose>
         <xsl:when test="not(@bezier or @bulge or @curvedir or @lform or @lwidth or @ho or @startho or @endho or @to or @startto or @endto or @vo or @startvo or @endvo or @x or @y or @x2 or @y2)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not(@bezier or @bulge or @curvedir or @lform or @lwidth or @ho or @startho or @endho or @to or @startto or @endto or @vo or @startvo or @endvo or @x or @y or @x2 or @y2)">
               <xsl:attribute name="role">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>The visual attributes of the lv element (@bezier, @bulge, @curvedir,
            @lform, @lwidth, @ho, @startho, @endho, @to, @startto, @endto, @vo, @startvo, @endvo,
            @x, @y, @x2, and @y2) will be overridden by visual attributes of the contained curve
            elements.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M18"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M18"/>
   <xsl:template match="@*|node()" priority="-2" mode="M18">
      <xsl:apply-templates select="*" mode="M18"/>
   </xsl:template>
   <!--PATTERN mei-graphicanalysis-octave-octave_start-_and_end-type_attributes_required-constraint-rule-22-->

   <!--RULE -->
   <xsl:template match="mei:octave" priority="1000" mode="M19">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="mei:octave"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="@startid or @tstamp or @tstamp.ges or @tstamp.real"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="@startid or @tstamp or @tstamp.ges or @tstamp.real">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Must have one of the
            attributes: startid, tstamp, tstamp.ges or tstamp.real.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="@dur or @dur.ges or @endid or @tstamp2"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="@dur or @dur.ges or @endid or @tstamp2">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Must have one of the attributes:
            dur, dur.ges, endid, or tstamp2.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M19"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M19"/>
   <xsl:template match="@*|node()" priority="-2" mode="M19">
      <xsl:apply-templates select="*" mode="M19"/>
   </xsl:template>
   <!--PATTERN -->

   <!--RULE -->
   <xsl:template match="mei:measure/mei:ossia" priority="1001" mode="M20">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="mei:measure/mei:ossia"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(mei:*) = count(mei:staff)+count(mei:oStaff)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="count(mei:*) = count(mei:staff)+count(mei:oStaff)">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>In a measure, ossia
              may only contain staff and oStaff elements.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M20"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="mei:staff/mei:ossia" priority="1000" mode="M20">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="mei:staff/mei:ossia"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(mei:*) = count(mei:layer)+count(mei:oLayer)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="count(mei:*) = count(mei:layer)+count(mei:oLayer)">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>In a staff, ossia
              may only contain layer and oLayer elements.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M20"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M20"/>
   <xsl:template match="@*|node()" priority="-2" mode="M20">
      <xsl:apply-templates select="*" mode="M20"/>
   </xsl:template>
   <!--PATTERN mei-graphicanalysis-pedal-pedal_start-type_attributes_required-constraint-rule-25-->

   <!--RULE -->
   <xsl:template match="mei:pedal" priority="1000" mode="M21">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="mei:pedal"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="@startid or @tstamp or @tstamp.ges or @tstamp.real"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="@startid or @tstamp or @tstamp.ges or @tstamp.real">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Must have one of the
            attributes: startid, tstamp, tstamp.ges or tstamp.real.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M21"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M21"/>
   <xsl:template match="@*|node()" priority="-2" mode="M21">
      <xsl:apply-templates select="*" mode="M21"/>
   </xsl:template>
   <!--PATTERN mei-graphicanalysis-repeatMark-repeatMark_start-type_attributes_required-constraint-rule-26-->

   <!--RULE -->
   <xsl:template match="mei:repeatMark" priority="1000" mode="M22">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="mei:repeatMark"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="@startid or @tstamp or @tstamp.ges or @tstamp.real"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="@startid or @tstamp or @tstamp.ges or @tstamp.real">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Must have one of the
            attributes: startid, tstamp, tstamp.ges or tstamp.real.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M22"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M22"/>
   <xsl:template match="@*|node()" priority="-2" mode="M22">
      <xsl:apply-templates select="*" mode="M22"/>
   </xsl:template>
   <!--PATTERN mei-graphicanalysis-repeatMark-repeatMark_with_glyph_has_to_be_empty-constraint-rule-27-->

   <!--RULE -->
   <xsl:template match="mei:repeatMark[@glyph.num or @glyph.name]"
                 priority="1000"
                 mode="M23">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="mei:repeatMark[@glyph.num or @glyph.name]"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(element()) and not(text())"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not(element()) and not(text())">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>When @glyph.name or @glyph.num is present, repeatMark must not have content.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M23"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M23"/>
   <xsl:template match="@*|node()" priority="-2" mode="M23">
      <xsl:apply-templates select="*" mode="M23"/>
   </xsl:template>
   <!--PATTERN mei-graphicanalysis-slur-slur_start-_and_end-type_attributes_required-constraint-rule-28-->

   <!--RULE -->
   <xsl:template match="mei:slur" priority="1000" mode="M24">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="mei:slur"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="@startid or @tstamp or @tstamp.ges or @tstamp.real"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="@startid or @tstamp or @tstamp.ges or @tstamp.real">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Must have one of the
            attributes: startid, tstamp, tstamp.ges or tstamp.real.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="@dur or @dur.ges or @endid or @tstamp2"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="@dur or @dur.ges or @endid or @tstamp2">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Must have one of the attributes:
            dur, dur.ges, endid, or tstamp2.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M24"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M24"/>
   <xsl:template match="@*|node()" priority="-2" mode="M24">
      <xsl:apply-templates select="*" mode="M24"/>
   </xsl:template>
   <!--PATTERN mei-graphicanalysis-slur-slur_containing_curve-constraint-rule-29-->

   <!--RULE -->
   <xsl:template match="mei:slur[mei:curve[@bezier or @bulge or @curvedir or @lform or @lwidth or @ho or @startho or @endho or @to or @startto or @endto or @vo or @startvo or @endvo or @x or @y or @x2 or @y2]]"
                 priority="1000"
                 mode="M25">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="mei:slur[mei:curve[@bezier or @bulge or @curvedir or @lform or @lwidth or @ho or @startho or @endho or @to or @startto or @endto or @vo or @startvo or @endvo or @x or @y or @x2 or @y2]]"/>
      <!--ASSERT warning-->
      <xsl:choose>
         <xsl:when test="not(@bezier or @bulge or @curvedir or @lform or @lwidth or @ho or @startho or @endho or @to or @startto or @endto or @vo or @startvo or @endvo or @x or @y or @x2 or @y2)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not(@bezier or @bulge or @curvedir or @lform or @lwidth or @ho or @startho or @endho or @to or @startto or @endto or @vo or @startvo or @endvo or @x or @y or @x2 or @y2)">
               <xsl:attribute name="role">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>The visual attributes of the slur (@bezier, @bulge, @curvedir, @lform,
            @lwidth, @ho, @startho, @endho, @to, @startto, @endto, @vo, @startvo, @endvo, @x, @y,
            @x2, and @y2) will be overridden by visual attributes of the contained curve
            elements.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M25"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M25"/>
   <xsl:template match="@*|node()" priority="-2" mode="M25">
      <xsl:apply-templates select="*" mode="M25"/>
   </xsl:template>
   <!--PATTERN mei-graphicanalysis-tie-tie_start-_and_end-type_attributes_required-constraint-rule-30-->

   <!--RULE -->
   <xsl:template match="mei:tie" priority="1000" mode="M26">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="mei:tie"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="@startid or @tstamp or @tstamp.ges or @tstamp.real"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="@startid or @tstamp or @tstamp.ges or @tstamp.real">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Must have one of the
            attributes: startid, tstamp, tstamp.ges or tstamp.real.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="@dur or @dur.ges or @endid or @tstamp2"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="@dur or @dur.ges or @endid or @tstamp2">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Must have one of the attributes:
            dur, dur.ges, endid, or tstamp2.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M26"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M26"/>
   <xsl:template match="@*|node()" priority="-2" mode="M26">
      <xsl:apply-templates select="*" mode="M26"/>
   </xsl:template>
   <!--PATTERN mei-graphicanalysis-tie-tie_containing_curve-constraint-rule-31-->

   <!--RULE -->
   <xsl:template match="mei:tie[mei:curve[@bezier or @bulge or @curvedir or @lform or @lwidth or @ho or @startho or @endho or @to or @startto or @endto or @vo or @startvo or @endvo or @x or @y or @x2 or @y2]]"
                 priority="1000"
                 mode="M27">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="mei:tie[mei:curve[@bezier or @bulge or @curvedir or @lform or @lwidth or @ho or @startho or @endho or @to or @startto or @endto or @vo or @startvo or @endvo or @x or @y or @x2 or @y2]]"/>
      <!--ASSERT warning-->
      <xsl:choose>
         <xsl:when test="not(@bezier or @bulge or @curvedir or @lform or @lwidth or @ho or @startho or @endho or @to or @startto or @endto or @vo or @startvo or @endvo or @x or @y or @x2 or @y2)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not(@bezier or @bulge or @curvedir or @lform or @lwidth or @ho or @startho or @endho or @to or @startto or @endto or @vo or @startvo or @endvo or @x or @y or @x2 or @y2)">
               <xsl:attribute name="role">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>The visual attributes of the tie (@bezier, @bulge, @curvedir, @lform,
            @lwidth, @ho, @startho, @endho, @to, @startto, @endto, @vo, @startvo, @endvo, @x, @y,
            @x2, and @y2) will be overridden by visual attributes of the contained curve
            elements.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M27"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M27"/>
   <xsl:template match="@*|node()" priority="-2" mode="M27">
      <xsl:apply-templates select="*" mode="M27"/>
   </xsl:template>
   <!--PATTERN mei-graphicanalysis-tupletSpan-tupletSpan_start-_and_end-type_attributes_required-constraint-rule-32-->

   <!--RULE -->
   <xsl:template match="mei:tupletSpan" priority="1000" mode="M28">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="mei:tupletSpan"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="@startid or @tstamp or @tstamp.ges or @tstamp.real"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="@startid or @tstamp or @tstamp.ges or @tstamp.real">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Must have one of the
            attributes: startid, tstamp, tstamp.ges or tstamp.real.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="@dur or @dur.ges or @endid or @tstamp2"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="@dur or @dur.ges or @endid or @tstamp2">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Must have one of the attributes:
            dur, dur.ges, endid, or tstamp2.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M28"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M28"/>
   <xsl:template match="@*|node()" priority="-2" mode="M28">
      <xsl:apply-templates select="*" mode="M28"/>
   </xsl:template>
   <!--PATTERN mei-graphicanalysis-mordent-mordent_start-type_attributes_required-constraint-rule-33-->

   <!--RULE -->
   <xsl:template match="mei:mordent" priority="1000" mode="M29">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="mei:mordent"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="@startid or @tstamp or @tstamp.ges or @tstamp.real"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="@startid or @tstamp or @tstamp.ges or @tstamp.real">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Must have one of the
            attributes: startid, tstamp, tstamp.ges or tstamp.real.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M29"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M29"/>
   <xsl:template match="@*|node()" priority="-2" mode="M29">
      <xsl:apply-templates select="*" mode="M29"/>
   </xsl:template>
   <!--PATTERN mei-graphicanalysis-trill-trill_start-type_attributes_required-constraint-rule-34-->

   <!--RULE -->
   <xsl:template match="mei:trill" priority="1000" mode="M30">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="mei:trill"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="@startid or @tstamp or @tstamp.ges or @tstamp.real"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="@startid or @tstamp or @tstamp.ges or @tstamp.real">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Must have one of the
            attributes: startid, tstamp, tstamp.ges or tstamp.real.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M30"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M30"/>
   <xsl:template match="@*|node()" priority="-2" mode="M30">
      <xsl:apply-templates select="*" mode="M30"/>
   </xsl:template>
   <!--PATTERN mei-graphicanalysis-turn-turn_start-type_attributes_required-constraint-rule-35-->

   <!--RULE -->
   <xsl:template match="mei:turn" priority="1000" mode="M31">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="mei:turn"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="@startid or @tstamp or @tstamp.ges or @tstamp.real"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="@startid or @tstamp or @tstamp.ges or @tstamp.real">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Must have one of the
            attributes: startid, tstamp, tstamp.ges or tstamp.real.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M31"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M31"/>
   <xsl:template match="@*|node()" priority="-2" mode="M31">
      <xsl:apply-templates select="*" mode="M31"/>
   </xsl:template>
   <!--PATTERN mei-graphicanalysis-sp-sp_start-type_attributes_required-constraint-rule-36-->

   <!--RULE -->
   <xsl:template match="mei:sp[ancestor::mei:layer or ancestor::mei:measure or ancestor::mei:staff][not(ancestor::mei:sp)]"
                 priority="1000"
                 mode="M32">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="mei:sp[ancestor::mei:layer or ancestor::mei:measure or ancestor::mei:staff][not(ancestor::mei:sp)]"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="@startid or @tstamp or @tstamp.ges or @tstamp.real"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="@startid or @tstamp or @tstamp.ges or @tstamp.real">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Must have one of the
            attributes: startid, tstamp, tstamp.ges or tstamp.real.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M32"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M32"/>
   <xsl:template match="@*|node()" priority="-2" mode="M32">
      <xsl:apply-templates select="*" mode="M32"/>
   </xsl:template>
   <!--PATTERN mei-graphicanalysis-sp-sp_start-type_attributes_forbidden-constraint-rule-37-->

   <!--RULE -->
   <xsl:template match="mei:sp[not(ancestor::mei:layer or ancestor::mei:measure or ancestor::mei:staff)]"
                 priority="1000"
                 mode="M33">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="mei:sp[not(ancestor::mei:layer or ancestor::mei:measure or ancestor::mei:staff)]"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(@startid or @endid or @tstamp or @tstamp2 or @tstamp.ges or @tstamp.real or                @startho or @endho or @to or @startto or @endto or @staff or @layer or @place or @plist)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not(@startid or @endid or @tstamp or @tstamp2 or @tstamp.ges or @tstamp.real or @startho or @endho or @to or @startto or @endto or @staff or @layer or @place or @plist)">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Must not have any of the attributes: startid, endid, tstamp, tstamp2, tstamp.ges,
            tstamp.real, startho, endho, to, startto, endto, staff, layer, place, or
            plist.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M33"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M33"/>
   <xsl:template match="@*|node()" priority="-2" mode="M33">
      <xsl:apply-templates select="*" mode="M33"/>
   </xsl:template>
   <!--PATTERN mei-graphicanalysis-stageDir-stageDir_start-type_attributes_required-constraint-rule-38-->

   <!--RULE -->
   <xsl:template match="mei:stageDir[ancestor::mei:layer or ancestor::mei:measure or ancestor::mei:staff][not(ancestor::mei:sp)]"
                 priority="1000"
                 mode="M34">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="mei:stageDir[ancestor::mei:layer or ancestor::mei:measure or ancestor::mei:staff][not(ancestor::mei:sp)]"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="@startid or @tstamp or @tstamp.ges or @tstamp.real"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="@startid or @tstamp or @tstamp.ges or @tstamp.real">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Must have one of the
            attributes: startid, tstamp, tstamp.ges or tstamp.real.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M34"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M34"/>
   <xsl:template match="@*|node()" priority="-2" mode="M34">
      <xsl:apply-templates select="*" mode="M34"/>
   </xsl:template>
   <!--PATTERN mei-graphicanalysis-stageDir-stageDir_start-type_attributes_forbidden-constraint-rule-39-->

   <!--RULE -->
   <xsl:template match="mei:stageDir[not(ancestor::mei:layer or ancestor::mei:measure or ancestor::mei:staff) or ancestor::mei:sp]"
                 priority="1000"
                 mode="M35">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="mei:stageDir[not(ancestor::mei:layer or ancestor::mei:measure or ancestor::mei:staff) or ancestor::mei:sp]"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(@startid or @endid or @tstamp or @tstamp2 or @tstamp.ges or @tstamp.real or @startho or @endho or @to or                @startto or @endto or @staff or @layer or @place or @plist)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not(@startid or @endid or @tstamp or @tstamp2 or @tstamp.ges or @tstamp.real or @startho or @endho or @to or @startto or @endto or @staff or @layer or @place or @plist)">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Must not have any of the attributes: startid, endid, tstamp, tstamp2, tstamp.ges,
            tstamp.real, startho, endho, to, startto, endto, staff, layer, place, or
            plist.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M35"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M35"/>
   <xsl:template match="@*|node()" priority="-2" mode="M35">
      <xsl:apply-templates select="*" mode="M35"/>
   </xsl:template>
   <!--PATTERN mei-graphicanalysis-cpMark-cpMark_start-_and_end-type_attributes_required-constraint-rule-40-->

   <!--RULE -->
   <xsl:template match="mei:cpMark" priority="1000" mode="M36">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="mei:cpMark"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="@startid or @tstamp or @tstamp.ges or @tstamp.real"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="@startid or @tstamp or @tstamp.ges or @tstamp.real">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Must have one of the
            attributes: startid, tstamp, tstamp.ges or tstamp.real</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="@dur or @dur.ges or @endid or @tstamp2"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="@dur or @dur.ges or @endid or @tstamp2">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Must have one of the attributes:
            dur, dur.ges, endid, or tstamp2</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M36"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M36"/>
   <xsl:template match="@*|node()" priority="-2" mode="M36">
      <xsl:apply-templates select="*" mode="M36"/>
   </xsl:template>
   <!--PATTERN mei-graphicanalysis-handShift-new-check_newTarget-constraint-rule-41-->

   <!--RULE -->
   <xsl:template match="@new" priority="1000" mode="M37">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="@new"/>
      <!--ASSERT warning-->
      <xsl:choose>
         <xsl:when test="not(normalize-space(.) eq '')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not(normalize-space(.) eq '')">
               <xsl:attribute name="role">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>@new attribute should
                have content.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT warning-->
      <xsl:choose>
         <xsl:when test="every $i in tokenize(., '\s+') satisfies substring($i,2)=//mei:hand/@xml:id"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="every $i in tokenize(., '\s+') satisfies substring($i,2)=//mei:hand/@xml:id">
               <xsl:attribute name="role">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>The value in @new should correspond to the @xml:id attribute of a hand
                element.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M37"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M37"/>
   <xsl:template match="@*|node()" priority="-2" mode="M37">
      <xsl:apply-templates select="*" mode="M37"/>
   </xsl:template>
   <!--PATTERN mei-graphicanalysis-handShift-old-check_oldTarget-constraint-rule-42-->

   <!--RULE -->
   <xsl:template match="@old" priority="1000" mode="M38">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="@old"/>
      <!--ASSERT warning-->
      <xsl:choose>
         <xsl:when test="not(normalize-space(.) eq '')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not(normalize-space(.) eq '')">
               <xsl:attribute name="role">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>@old attribute should
                have content.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT warning-->
      <xsl:choose>
         <xsl:when test="every $i in tokenize(., '\s+') satisfies substring($i,2)=//mei:hand/@xml:id"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="every $i in tokenize(., '\s+') satisfies substring($i,2)=//mei:hand/@xml:id">
               <xsl:attribute name="role">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>The value in @old should correspond to the @xml:id attribute of a hand
                element.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M38"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M38"/>
   <xsl:template match="@*|node()" priority="-2" mode="M38">
      <xsl:apply-templates select="*" mode="M38"/>
   </xsl:template>
   <!--PATTERN mei-graphicanalysis-metaMark-metaMark_start-type_attributes_required-constraint-rule-43-->

   <!--RULE -->
   <xsl:template match="mei:metaMark" priority="1000" mode="M39">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="mei:metaMark"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="@startid or @tstamp or @tstamp.ges or @tstamp.real"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="@startid or @tstamp or @tstamp.ges or @tstamp.real">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Must have one of the
            attributes: startid, tstamp, tstamp.ges or tstamp.real</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M39"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M39"/>
   <xsl:template match="@*|node()" priority="-2" mode="M39">
      <xsl:apply-templates select="*" mode="M39"/>
   </xsl:template>
   <!--PATTERN mei-graphicanalysis-att.extSym.names-glyph.name-check_glyph.name-constraint-rule-44-->

   <!--RULE -->
   <xsl:template match="@glyph.name" priority="1000" mode="M40">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="@glyph.name"/>
      <!--ASSERT warning-->
      <xsl:choose>
         <xsl:when test="not(normalize-space(.) eq '')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not(normalize-space(.) eq '')">
               <xsl:attribute name="role">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>@glyph.name attribute
                should have content.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M40"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M40"/>
   <xsl:template match="@*|node()" priority="-2" mode="M40">
      <xsl:apply-templates select="*" mode="M40"/>
   </xsl:template>
   <!--PATTERN mei-graphicanalysis-att.extSym.names-glyph.num-check_glyph.num-constraint-rule-45-->

   <!--RULE -->
   <xsl:template match="mei:*[@glyph.num and (lower-case(@glyph.auth) eq 'smufl' or @glyph.uri eq 'http://www.smufl.org/')]"
                 priority="1000"
                 mode="M41">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="mei:*[@glyph.num and (lower-case(@glyph.auth) eq 'smufl' or @glyph.uri eq 'http://www.smufl.org/')]"/>
      <!--ASSERT warning-->
      <xsl:choose>
         <xsl:when test="matches(normalize-space(@glyph.num), '^(#x|U\+)E([0-9AB][0-9A-F][0-9A-F]|C[0-9A][0-9A-F]|CB[0-9A-F])$')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="matches(normalize-space(@glyph.num), '^(#x|U\+)E([0-9AB][0-9A-F][0-9A-F]|C[0-9A][0-9A-F]|CB[0-9A-F])$')">
               <xsl:attribute name="role">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>SMuFL version 1.18 uses the range U+E000 - U+ECBF.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M41"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M41"/>
   <xsl:template match="@*|node()" priority="-2" mode="M41">
      <xsl:apply-templates select="*" mode="M41"/>
   </xsl:template>
   <!--PATTERN mei-graphicanalysis-att.facsimile-facs-check_facsTarget-constraint-rule-46-->

   <!--RULE -->
   <xsl:template match="@facs" priority="1000" mode="M42">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="@facs"/>
      <!--ASSERT warning-->
      <xsl:choose>
         <xsl:when test="not(normalize-space(.) eq '')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not(normalize-space(.) eq '')">
               <xsl:attribute name="role">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>@facs attribute should
                have content.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT warning-->
      <xsl:choose>
         <xsl:when test="every $i in tokenize(., '\s+') satisfies substring($i,2)=//mei:*[local-name() eq 'surface' or local-name() eq 'zone']/@xml:id"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="every $i in tokenize(., '\s+') satisfies substring($i,2)=//mei:*[local-name() eq 'surface' or local-name() eq 'zone']/@xml:id">
               <xsl:attribute name="role">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Each value in @facs should correspond to the @xml:id attribute of a surface or zone
                element.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M42"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M42"/>
   <xsl:template match="@*|node()" priority="-2" mode="M42">
      <xsl:apply-templates select="*" mode="M42"/>
   </xsl:template>
   <!--PATTERN mei-graphicanalysis-graphic-graphic_attributes-constraint-rule-47-->

   <!--RULE -->
   <xsl:template match="mei:zone/mei:graphic" priority="1002" mode="M43">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="mei:zone/mei:graphic"/>
      <!--ASSERT warning-->
      <xsl:choose>
         <xsl:when test="count(mei:*) = 0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="count(mei:*) = 0">
               <xsl:attribute name="role">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Graphic child of zone should not have
            children.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M43"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="mei:symbolDef/mei:graphic" priority="1001" mode="M43">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="mei:symbolDef/mei:graphic"/>
      <!--ASSERT warning-->
      <xsl:choose>
         <xsl:when test="@startid or (@ulx and @uly)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="@startid or (@ulx and @uly)">
               <xsl:attribute name="role">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Graphic should have either a
            startid attribute or ulx and uly attributes.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M43"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="mei:graphic[not(ancestor::mei:symbolDef or ancestor::mei:zone)]"
                 priority="1000"
                 mode="M43">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="mei:graphic[not(ancestor::mei:symbolDef or ancestor::mei:zone)]"/>
      <!--ASSERT warning-->
      <xsl:choose>
         <xsl:when test="not(@ulx or @uly)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(@ulx or @uly)">
               <xsl:attribute name="role">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Graphic should not have @ulx or @uly
            attributes.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT warning-->
      <xsl:choose>
         <xsl:when test="not(@ho or @vo)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(@ho or @vo)">
               <xsl:attribute name="role">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Graphic should not have @ho or @vo
            attributes.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M43"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M43"/>
   <xsl:template match="@*|node()" priority="-2" mode="M43">
      <xsl:apply-templates select="*" mode="M43"/>
   </xsl:template>
   <!--PATTERN mei-graphicanalysis-fing-fing_start-type_attributes_required-constraint-rule-50-->

   <!--RULE -->
   <xsl:template match="mei:fing[not(ancestor::mei:fingGrp)]"
                 priority="1000"
                 mode="M44">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="mei:fing[not(ancestor::mei:fingGrp)]"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="@startid or @tstamp or @tstamp.ges or @tstamp.real"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="@startid or @tstamp or @tstamp.ges or @tstamp.real">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Must have one of the
            attributes: startid, tstamp, tstamp.ges or tstamp.real.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M44"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M44"/>
   <xsl:template match="@*|node()" priority="-2" mode="M44">
      <xsl:apply-templates select="*" mode="M44"/>
   </xsl:template>
   <!--PATTERN mei-graphicanalysis-fing-stack_exclusion-constraint-rule-51-->

   <!--RULE -->
   <xsl:template match="mei:fing" priority="1000" mode="M45">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="mei:fing"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(descendant::mei:stack)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not(descendant::mei:stack)">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>The stack element is not allowed as a
            descendant of fing.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M45"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M45"/>
   <xsl:template match="@*|node()" priority="-2" mode="M45">
      <xsl:apply-templates select="*" mode="M45"/>
   </xsl:template>
   <!--PATTERN mei-graphicanalysis-fingGrp-require_fingeringLike_children-constraint-rule-52-->

   <!--RULE -->
   <xsl:template match="mei:fingGrp" priority="1000" mode="M46">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="mei:fingGrp"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(mei:fing) + count(mei:fingGrp) &gt; 1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="count(mei:fing) + count(mei:fingGrp) &gt; 1">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>At least 2 fing or fingGrp
            elements are required.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M46"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M46"/>
   <xsl:template match="@*|node()" priority="-2" mode="M46">
      <xsl:apply-templates select="*" mode="M46"/>
   </xsl:template>
   <!--PATTERN -->

   <!--RULE -->
   <xsl:template match="mei:fingGrp[not(ancestor::mei:fingGrp)][@tstamp or @startid]"
                 priority="1001"
                 mode="M47">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="mei:fingGrp[not(ancestor::mei:fingGrp)][@tstamp or @startid]"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(child::mei:*[@tstamp or @startid])"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not(child::mei:*[@tstamp or @startid])">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>When @tstamp or @startid is
              present on fingGrp, its child elements cannot have a @tstamp or @startid
              attribute.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M47"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="mei:fingGrp[not(ancestor::mei:fingGrp)][not(@tstamp or @startid)]"
                 priority="1000"
                 mode="M47">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="mei:fingGrp[not(ancestor::mei:fingGrp)][not(@tstamp or @startid)]"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(descendant::mei:*[@tstamp or @startid]) = count(child::mei:*[local-name()='fing' or local-name()='fingGrp'])"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="count(descendant::mei:*[@tstamp or @startid]) = count(child::mei:*[local-name()='fing' or local-name()='fingGrp'])">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>When @tstamp or @startid is not present on fingGrp, each of its child elements must
              have a @tstamp or @startid attribute.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M47"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M47"/>
   <xsl:template match="@*|node()" priority="-2" mode="M47">
      <xsl:apply-templates select="*" mode="M47"/>
   </xsl:template>
   <!--PATTERN mei-graphicanalysis-manifestation-check_singleton-constraint-rule-55-->

   <!--RULE -->
   <xsl:template match="mei:manifestation[@singleton eq 'true']"
                 priority="1000"
                 mode="M48">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="mei:manifestation[@singleton eq 'true']"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(mei:itemList)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(mei:itemList)">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Item children are not permitted when @singleton
            equals "true".</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M48"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M48"/>
   <xsl:template match="@*|node()" priority="-2" mode="M48">
      <xsl:apply-templates select="*" mode="M48"/>
   </xsl:template>
   <!--PATTERN mei-graphicanalysis-manifestation-check_singleton_availability-constraint-rule-56-->

   <!--RULE -->
   <xsl:template match="mei:manifestation[@singleton eq 'false'] | mei:manifestation[not(@singleton)]"
                 priority="1000"
                 mode="M49">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="mei:manifestation[@singleton eq 'false'] | mei:manifestation[not(@singleton)]"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(mei:availability)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(mei:availability)">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Availability is only permitted when @singleton equals "true".</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M49"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M49"/>
   <xsl:template match="@*|node()" priority="-2" mode="M49">
      <xsl:apply-templates select="*" mode="M49"/>
   </xsl:template>
   <!--PATTERN mei-graphicanalysis-att.geneticState-check_changeState.targets-constraint-rule-57-->

   <!--RULE -->
   <xsl:template match="@state" priority="1000" mode="M50">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="@state"/>
      <!--ASSERT warning-->
      <xsl:choose>
         <xsl:when test="not(normalize-space(.) eq '')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not(normalize-space(.) eq '')">
               <xsl:attribute name="role">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>@state attribute should
            have content.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT warning-->
      <xsl:choose>
         <xsl:when test="every $i in tokenize(., '\s+') satisfies substring($i,2)=//mei:genState/@xml:id"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="every $i in tokenize(., '\s+') satisfies substring($i,2)=//mei:genState/@xml:id">
               <xsl:attribute name="role">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>The value in @state should correspond to the @xml:id attribute of a genState (genetic state)
            element.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M50"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M50"/>
   <xsl:template match="@*|node()" priority="-2" mode="M50">
      <xsl:apply-templates select="*" mode="M50"/>
   </xsl:template>
   <!--PATTERN mei-graphicanalysis-att.accidental.ges-accid.ges-check_accid_duplication-constraint-rule-58-->

   <!--RULE -->
   <xsl:template match="@accid.ges" priority="1000" mode="M51">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="@accid.ges"/>
      <!--ASSERT warning-->
      <xsl:choose>
         <xsl:when test="not(. eq ../@accid)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(. eq ../@accid)">
               <xsl:attribute name="role">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>The value of @accid.ges should
                not duplicate the value of @accid.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M51"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M51"/>
   <xsl:template match="@*|node()" priority="-2" mode="M51">
      <xsl:apply-templates select="*" mode="M51"/>
   </xsl:template>
   <!--PATTERN mei-graphicanalysis-att.note.ges-extremis_disallows_gestural_pitch-constraint-rule-59-->

   <!--RULE -->
   <xsl:template match="mei:note[@extremis]" priority="1000" mode="M52">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="mei:note[@extremis]"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(@pname.ges) and not(@oct.ges)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not(@pname.ges) and not(@oct.ges)">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>When the @extremis attribute is used,
            the @pname.ges and @oct.ges attributes are not allowed.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M52"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M52"/>
   <xsl:template match="@*|node()" priority="-2" mode="M52">
      <xsl:apply-templates select="*" mode="M52"/>
   </xsl:template>
   <!--PATTERN mei-graphicanalysis-graph-graph_undirected_not_supported-constraint-rule-60-->

   <!--RULE -->
   <xsl:template match="mei:graph[@type='undirected']" priority="1000" mode="M53">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="mei:graph[@type='undirected']"/>
      <!--ASSERT warning-->
      <xsl:choose>
         <xsl:when test="false()"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="false()">
               <xsl:attribute name="role">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Undirected graphs are not yet supported.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M53"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M53"/>
   <xsl:template match="@*|node()" priority="-2" mode="M53">
      <xsl:apply-templates select="*" mode="M53"/>
   </xsl:template>
   <!--PATTERN mei-graphicanalysis-node-node_relation_label-constraint-rule-61-->

   <!--RULE -->
   <xsl:template match="mei:node[@type='relation' or @type='metarelation']"
                 priority="1000"
                 mode="M54">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="mei:node[@type='relation' or @type='metarelation']"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="mei:label/@type"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="mei:label/@type">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>A label within a relation or metarelation node must have a @type attribute.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(mei:label/*)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(mei:label/*)">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>A label within a relation or metarelation node must be empty.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M54"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M54"/>
   <xsl:template match="@*|node()" priority="-2" mode="M54">
      <xsl:apply-templates select="*" mode="M54"/>
   </xsl:template>
   <!--PATTERN mei-graphicanalysis-node-node_relation_label_single_token-constraint-rule-62-->

   <!--RULE -->
   <xsl:template match="mei:node[@type='relation' or @type='metarelation']"
                 priority="1000"
                 mode="M55">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="mei:node[@type='relation' or @type='metarelation']"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(contains(normalize-space(mei:label/@type), ' '))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not(contains(normalize-space(mei:label/@type), ' '))">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Within a graph, the @type attribute of a label must be a single token.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M55"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M55"/>
   <xsl:template match="@*|node()" priority="-2" mode="M55">
      <xsl:apply-templates select="*" mode="M55"/>
   </xsl:template>
   <!--PATTERN mei-graphicanalysis-node-node_note_label-constraint-rule-63-->

   <!--RULE -->
   <xsl:template match="mei:node[not(@type) or @type='note']"
                 priority="1000"
                 mode="M56">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="mei:node[not(@type) or @type='note']"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(mei:label/@type)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(mei:label/@type)">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>A label within a note node must not have a @type attribute.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="mei:label/mei:note[@corresp]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="mei:label/mei:note[@corresp]">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>A label within a note node must contain a note element with a @corresp attribute.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M56"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M56"/>
   <xsl:template match="@*|node()" priority="-2" mode="M56">
      <xsl:apply-templates select="*" mode="M56"/>
   </xsl:template>
   <!--PATTERN mei-graphicanalysis-node-node_note_corresp_only-constraint-rule-64-->

   <!--RULE -->
   <xsl:template match="mei:node[not(@type) or @type='note']"
                 priority="1000"
                 mode="M57">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="mei:node[not(@type) or @type='note']"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="mei:label/mei:note/@corresp"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="mei:label/mei:note/@corresp">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>A note inside a label inside a graph must have a @corresp attribute.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(mei:label/mei:note/@*[name() != 'corresp'])"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not(mei:label/mei:note/@*[name() != 'corresp'])">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>A note inside a label inside a graph must have no attributes other than @corresp.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M57"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M57"/>
   <xsl:template match="@*|node()" priority="-2" mode="M57">
      <xsl:apply-templates select="*" mode="M57"/>
   </xsl:template>
   <!--PATTERN mei-graphicanalysis-node-node_note_corresp_target-constraint-rule-65-->

   <!--RULE -->
   <xsl:template match="mei:node[not(@type) or @type='note'][mei:label/mei:note/@corresp]"
                 priority="1000"
                 mode="M58">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="mei:node[not(@type) or @type='note'][mei:label/mei:note/@corresp]"/>
      <xsl:variable name="id" select="substring-after(mei:label/mei:note/@corresp, '#')"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="//mei:score//mei:note[@xml:id = $id]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="//mei:score//mei:note[@xml:id = $id]">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>The @corresp attribute must reference a note element within a score.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M58"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M58"/>
   <xsl:template match="@*|node()" priority="-2" mode="M58">
      <xsl:apply-templates select="*" mode="M58"/>
   </xsl:template>
   <!--PATTERN mei-graphicanalysis-node-node_in_arc-constraint-rule-66-->

   <!--RULE -->
   <xsl:template match="mei:node" priority="1000" mode="M59">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="mei:node"/>
      <xsl:variable name="graph" select="ancestor::mei:graph"/>
      <xsl:variable name="ref" select="concat('#', @xml:id)"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="$graph/mei:arc[@from = $ref or @to = $ref]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="$graph/mei:arc[@from = $ref or @to = $ref]">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Node must appear in at least one arc within the same graph.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M59"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M59"/>
   <xsl:template match="@*|node()" priority="-2" mode="M59">
      <xsl:apply-templates select="*" mode="M59"/>
   </xsl:template>
   <!--PATTERN mei-graphicanalysis-arc-arc_targets_exist-constraint-rule-67-->

   <!--RULE -->
   <xsl:template match="mei:arc" priority="1000" mode="M60">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="mei:arc"/>
      <xsl:variable name="graph" select="ancestor::mei:graph"/>
      <xsl:variable name="fromId" select="substring-after(@from, '#')"/>
      <xsl:variable name="toId" select="substring-after(@to, '#')"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="$graph/mei:node[@xml:id = $fromId]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="$graph/mei:node[@xml:id = $fromId]">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>@from must reference an existing node in this graph.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="$graph/mei:node[@xml:id = $toId]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="$graph/mei:node[@xml:id = $toId]">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>@to must reference an existing node in this graph.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M60"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M60"/>
   <xsl:template match="@*|node()" priority="-2" mode="M60">
      <xsl:apply-templates select="*" mode="M60"/>
   </xsl:template>
   <!--PATTERN mei-graphicanalysis-arc-arc_from_type-constraint-rule-68-->

   <!--RULE -->
   <xsl:template match="mei:arc" priority="1000" mode="M61">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="mei:arc"/>
      <xsl:variable name="graph" select="ancestor::mei:graph"/>
      <xsl:variable name="fromId" select="substring-after(@from, '#')"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="$graph/mei:node[@xml:id = $fromId]/@type = ('relation', 'metarelation')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="$graph/mei:node[@xml:id = $fromId]/@type = ('relation', 'metarelation')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>@from must reference a relation or metarelation node.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M61"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M61"/>
   <xsl:template match="@*|node()" priority="-2" mode="M61">
      <xsl:apply-templates select="*" mode="M61"/>
   </xsl:template>
   <!--PATTERN mei-graphicanalysis-arc-arc_to_type-constraint-rule-69-->

   <!--RULE -->
   <xsl:template match="mei:arc" priority="1000" mode="M62">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="mei:arc"/>
      <xsl:variable name="graph" select="ancestor::mei:graph"/>
      <xsl:variable name="fromId" select="substring-after(@from, '#')"/>
      <xsl:variable name="toId" select="substring-after(@to, '#')"/>
      <xsl:variable name="fromType" select="$graph/mei:node[@xml:id = $fromId]/@type"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="if ($fromType = 'relation') then $graph/mei:node[@xml:id = $toId and (not(@type) or @type = 'note')] else true()"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="if ($fromType = 'relation') then $graph/mei:node[@xml:id = $toId and (not(@type) or @type = 'note')] else true()">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>An arc from a relation node must target a note node.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="if ($fromType = 'metarelation') then $graph/mei:node[@xml:id = $toId and @type = ('relation', 'metarelation')] else true()"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="if ($fromType = 'metarelation') then $graph/mei:node[@xml:id = $toId and @type = ('relation', 'metarelation')] else true()">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>An arc from a metarelation node must target a relation or metarelation node.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M62"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M62"/>
   <xsl:template match="@*|node()" priority="-2" mode="M62">
      <xsl:apply-templates select="*" mode="M62"/>
   </xsl:template>
   <!--PATTERN mei-graphicanalysis-att.harm.log-chordref-check_chordrefTarget-constraint-rule-70-->

   <!--RULE -->
   <xsl:template match="@chordref" priority="1000" mode="M63">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="@chordref"/>
      <!--ASSERT warning-->
      <xsl:choose>
         <xsl:when test="not(normalize-space(.) eq '')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not(normalize-space(.) eq '')">
               <xsl:attribute name="role">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>@chordref attribute
                should have content.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT warning-->
      <xsl:choose>
         <xsl:when test="every $i in tokenize(., '\s+') satisfies substring($i,2)=//mei:chordDef/@xml:id"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="every $i in tokenize(., '\s+') satisfies substring($i,2)=//mei:chordDef/@xml:id">
               <xsl:attribute name="role">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>The value in @chordref should correspond to the @xml:id attribute of a chordDef
                element.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M63"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M63"/>
   <xsl:template match="@*|node()" priority="-2" mode="M63">
      <xsl:apply-templates select="*" mode="M63"/>
   </xsl:template>
   <!--PATTERN mei-graphicanalysis-harm-harm_start-type_attributes_required-constraint-rule-71-->

   <!--RULE -->
   <xsl:template match="mei:harm" priority="1000" mode="M64">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="mei:harm"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="@startid or @tstamp or @tstamp.ges or @tstamp.real"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="@startid or @tstamp or @tstamp.ges or @tstamp.real">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Must have one of the
            attributes: startid, tstamp, tstamp.ges or tstamp.real.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M64"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M64"/>
   <xsl:template match="@*|node()" priority="-2" mode="M64">
      <xsl:apply-templates select="*" mode="M64"/>
   </xsl:template>
   <!--PATTERN mei-graphicanalysis-attUsage-context_attribute_requires_content-constraint-rule-72-->

   <!--RULE -->
   <xsl:template match="@context" priority="1000" mode="M65">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="@context"/>
      <!--ASSERT warning-->
      <xsl:choose>
         <xsl:when test="not(normalize-space(.) eq '')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not(normalize-space(.) eq '')">
               <xsl:attribute name="role">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>@context attribute should
            contain an XPath expression.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M65"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M65"/>
   <xsl:template match="@*|node()" priority="-2" mode="M65">
      <xsl:apply-templates select="*" mode="M65"/>
   </xsl:template>
   <!--PATTERN mei-graphicanalysis-category-category_id-constraint-rule-73-->

   <!--RULE -->
   <xsl:template match="mei:category" priority="1000" mode="M66">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="mei:category"/>
      <!--ASSERT warning-->
      <xsl:choose>
         <xsl:when test="@xml:id"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="@xml:id">
               <xsl:attribute name="role">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>To be addressable, the category element must
            have an xml:id attribute.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M66"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M66"/>
   <xsl:template match="@*|node()" priority="-2" mode="M66">
      <xsl:apply-templates select="*" mode="M66"/>
   </xsl:template>
   <!--PATTERN mei-graphicanalysis-change-check_change-constraint-rule-74-->

   <!--RULE -->
   <xsl:template match="mei:change" priority="1000" mode="M67">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="mei:change"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="@isodate or mei:date"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="@isodate or mei:date">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>The date of the change must be recorded in an
            isodate attribute or date element.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT warning-->
      <xsl:choose>
         <xsl:when test="@resp or mei:respStmt[mei:name or mei:corpName or mei:persName]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="@resp or mei:respStmt[mei:name or mei:corpName or mei:persName]">
               <xsl:attribute name="role">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>It is recommended that the agent responsible for the change be recorded
            in a resp attribute or in a name, corpName, or persName element in the respStmt
            element.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M67"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M67"/>
   <xsl:template match="@*|node()" priority="-2" mode="M67">
      <xsl:apply-templates select="*" mode="M67"/>
   </xsl:template>
   <!--PATTERN mei-graphicanalysis-componentList-checkComponentList-constraint-rule-75-->

   <!--RULE -->
   <xsl:template match="mei:componentList" priority="1000" mode="M68">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="mei:componentList"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="every $i in ./child::mei:*[not(local-name()='head')] satisfies             $i/local-name() eq ./parent::mei:*/local-name()"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="every $i in ./child::mei:*[not(local-name()='head')] satisfies $i/local-name() eq ./parent::mei:*/local-name()">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Only child elements of the same name as the parent of the componentList are
            allowed.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M68"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M68"/>
   <xsl:template match="@*|node()" priority="-2" mode="M68">
      <xsl:apply-templates select="*" mode="M68"/>
   </xsl:template>
   <!--PATTERN mei-graphicanalysis-componentList-checkComponents-constraint-rule-76-->

   <!--RULE -->
   <xsl:template match="mei:componentList[mei:*[@comptype]]"
                 priority="1000"
                 mode="M69">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="mei:componentList[mei:*[@comptype]]"/>
      <!--ASSERT warning-->
      <xsl:choose>
         <xsl:when test="count(mei:*[@comptype]) = count(mei:*[local-name() ne 'head'])"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="count(mei:*[@comptype]) = count(mei:*[local-name() ne 'head'])">
               <xsl:attribute name="role">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>When any child
            element has a comptype attribute, it is recommended that comptype appear on all child
            elements.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M69"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M69"/>
   <xsl:template match="@*|node()" priority="-2" mode="M69">
      <xsl:apply-templates select="*" mode="M69"/>
   </xsl:template>
   <!--PATTERN mei-graphicanalysis-contents-checkContentsLabels-constraint-rule-77-->

   <!--RULE -->
   <xsl:template match="mei:contents[mei:label]" priority="1000" mode="M70">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="mei:contents[mei:label]"/>
      <!--ASSERT warning-->
      <xsl:choose>
         <xsl:when test="count(mei:label) = count(mei:contentItem)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="count(mei:label) = count(mei:contentItem)">
               <xsl:attribute name="role">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>When labels
            are used, usually each content item has one.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M70"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M70"/>
   <xsl:template match="@*|node()" priority="-2" mode="M70">
      <xsl:apply-templates select="*" mode="M70"/>
   </xsl:template>
   <!--PATTERN mei-graphicanalysis-handList-checkHandListLabels-constraint-rule-78-->

   <!--RULE -->
   <xsl:template match="mei:handList[mei:label]" priority="1000" mode="M71">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="mei:handList[mei:label]"/>
      <!--ASSERT warning-->
      <xsl:choose>
         <xsl:when test="count(mei:label) = count(mei:hand)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="count(mei:label) = count(mei:hand)">
               <xsl:attribute name="role">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>When labels are used,
            usually each hand has one.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M71"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M71"/>
   <xsl:template match="@*|node()" priority="-2" mode="M71">
      <xsl:apply-templates select="*" mode="M71"/>
   </xsl:template>
   <!--PATTERN mei-graphicanalysis-history-history_restriction-constraint-rule-79-->

   <!--RULE -->
   <xsl:template match="mei:history[parent::mei:work or parent::mei:expression or parent::mei:manifestation[not(@singleton='true')]]"
                 priority="1000"
                 mode="M72">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="mei:history[parent::mei:work or parent::mei:expression or parent::mei:manifestation[not(@singleton='true')]]"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(mei:acquisition or mei:provenance or mei:exhibHist or mei:treatHist or mei:treatSched)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not(mei:acquisition or mei:provenance or mei:exhibHist or mei:treatHist or mei:treatSched)">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>The elements acquisition, provenance, exhibHist, treatHist and treatSched are not permitted at the work or expression level and are only permitted at the manifestation level, if the manifestation is a manifestation singleton.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M72"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M72"/>
   <xsl:template match="@*|node()" priority="-2" mode="M72">
      <xsl:apply-templates select="*" mode="M72"/>
   </xsl:template>
   <!--PATTERN mei-graphicanalysis-incipCode-Check_incipCode_form_mimetype-constraint-rule-80-->

   <!--RULE -->
   <xsl:template match="mei:incipCode" priority="1000" mode="M73">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="mei:incipCode"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="@form or @mimetype"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="@form or @mimetype">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>incipCode must have a form or mimetype
            attribute.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M73"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M73"/>
   <xsl:template match="@*|node()" priority="-2" mode="M73">
      <xsl:apply-templates select="*" mode="M73"/>
   </xsl:template>
   <!--PATTERN mei-graphicanalysis-meiHead-check_meiHead_type-constraint-rule-81-->

   <!--RULE -->
   <xsl:template match="mei:meiHead[@type eq 'music']" priority="1002" mode="M74">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="mei:meiHead[@type eq 'music']"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="ancestor::mei:mei"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ancestor::mei:mei">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>The meiHead type attribute can have the value 'music'
            only when the document element is "mei".</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M74"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="mei:meiHead[@type eq 'corpus']" priority="1001" mode="M74">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="mei:meiHead[@type eq 'corpus']"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="ancestor::mei:meiCorpus"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ancestor::mei:meiCorpus">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>The meiHead type attribute can have the value
            'corpus' only when the document element is "meiCorpus".</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M74"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="mei:meiHead[@type eq 'independent']"
                 priority="1000"
                 mode="M74">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="mei:meiHead[@type eq 'independent']"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(ancestor::mei:*)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(ancestor::mei:*)">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>The meiHead type attribute can have the value
            'independent' only when the document element is "meiHead".</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M74"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M74"/>
   <xsl:template match="@*|node()" priority="-2" mode="M74">
      <xsl:apply-templates select="*" mode="M74"/>
   </xsl:template>
   <!--PATTERN mei-graphicanalysis-patch-check_attached_position-constraint-rule-84-->

   <!--RULE -->
   <xsl:template match="mei:patch" priority="1000" mode="M75">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="mei:patch"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="(parent::mei:folium and @attached.to = ('recto','verso')) or              (parent::mei:bifolium and @attached.to = ('outer.recto','inner.verso','inner.recto','outer.verso'))"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="(parent::mei:folium and @attached.to = ('recto','verso')) or (parent::mei:bifolium and @attached.to = ('outer.recto','inner.verso','inner.recto','outer.verso'))">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>The allowed positions of a patch depend on its parent element.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(child::node()) gt 0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="count(child::node()) gt 0">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>A patch element must contain either a folium
            or a bifolium element.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M75"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M75"/>
   <xsl:template match="@*|node()" priority="-2" mode="M75">
      <xsl:apply-templates select="*" mode="M75"/>
   </xsl:template>
   <!--PATTERN mei-graphicanalysis-source-check_source_target-constraint-rule-85-->

   <!--RULE -->
   <xsl:template match="mei:source/@target" priority="1000" mode="M76">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="mei:source/@target"/>
      <!--ASSERT warning-->
      <xsl:choose>
         <xsl:when test="not(normalize-space(.) eq '')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not(normalize-space(.) eq '')">
               <xsl:attribute name="role">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>@target attribute should
            have content.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT warning-->
      <xsl:choose>
         <xsl:when test="every $i in tokenize(., '\s+') satisfies substring($i,2)=//mei:*[local-name()              eq 'source' or local-name() eq 'manifestation']/@xml:id or matches($i, '^([a-z]+://|\.{1,2}/)')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="every $i in tokenize(., '\s+') satisfies substring($i,2)=//mei:*[local-name() eq 'source' or local-name() eq 'manifestation']/@xml:id or matches($i, '^([a-z]+://|\.{1,2}/)')">
               <xsl:attribute name="role">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Each value in @target should correspond to the @xml:id attribute of a source or
            manifestation element or be an external URI.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M76"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M76"/>
   <xsl:template match="@*|node()" priority="-2" mode="M76">
      <xsl:apply-templates select="*" mode="M76"/>
   </xsl:template>
   <!--PATTERN mei-graphicanalysis-tagUsage-context_attribute_requires_content-constraint-rule-86-->

   <!--RULE -->
   <xsl:template match="@context" priority="1000" mode="M77">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="@context"/>
      <!--ASSERT warning-->
      <xsl:choose>
         <xsl:when test="not(normalize-space(.) eq '')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not(normalize-space(.) eq '')">
               <xsl:attribute name="role">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>@context attribute should
            contain an XPath expression.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M77"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M77"/>
   <xsl:template match="@*|node()" priority="-2" mode="M77">
      <xsl:apply-templates select="*" mode="M77"/>
   </xsl:template>
   <!--PATTERN mei-graphicanalysis-termList-checkTermListLabels-constraint-rule-87-->

   <!--RULE -->
   <xsl:template match="mei:termList[mei:label]" priority="1000" mode="M78">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="mei:termList[mei:label]"/>
      <!--ASSERT warning-->
      <xsl:choose>
         <xsl:when test="count(mei:label) = count(mei:term)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="count(mei:label) = count(mei:term)">
               <xsl:attribute name="role">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>When labels are used,
            usually each term has one.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M78"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M78"/>
   <xsl:template match="@*|node()" priority="-2" mode="M78">
      <xsl:apply-templates select="*" mode="M78"/>
   </xsl:template>
   <!--PATTERN mei-graphicanalysis-att.duration.quality-check_duplex_quality-constraint-rule-88-->

   <!--RULE -->
   <xsl:template match="(mei:note|mei:space)[@dur.quality='duplex']"
                 priority="1000"
                 mode="M79">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="(mei:note|mei:space)[@dur.quality='duplex']"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="@dur='longa'"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="@dur='longa'">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            Duplex quality can only be used with longas (in Ars antiqua).
          </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M79"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M79"/>
   <xsl:template match="@*|node()" priority="-2" mode="M79">
      <xsl:apply-templates select="*" mode="M79"/>
   </xsl:template>
   <!--PATTERN mei-graphicanalysis-att.duration.quality-check_maiorminor_quality-constraint-rule-89-->

   <!--RULE -->
   <xsl:template match="(mei:note|mei:space)[@dur.quality='maior' or @dur.quality='minor']"
                 priority="1000"
                 mode="M80">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="(mei:note|mei:space)[@dur.quality='maior' or @dur.quality='minor']"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="@dur='semibrevis'"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="@dur='semibrevis'">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            Maior / minor quality can only be used with semibreves (in Ars antiqua).
          </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M80"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M80"/>
   <xsl:template match="@*|node()" priority="-2" mode="M80">
      <xsl:apply-templates select="*" mode="M80"/>
   </xsl:template>
   <!--PATTERN mei-graphicanalysis-att.mensural.shared-mensuration_conflicting_attributes-constraint-rule-90-->

   <!--RULE -->
   <xsl:template match="mei:mensur[@divisio]" priority="1000" mode="M81">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="mei:mensur[@divisio]"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(@tempus) and not(@prolatio)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not(@tempus) and not(@prolatio)">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
            When the @divisio attribute is used, the @tempus and @prolatio attributes are not allowed.
          </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M81"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M81"/>
   <xsl:template match="@*|node()" priority="-2" mode="M81">
      <xsl:apply-templates select="*" mode="M81"/>
   </xsl:template>
   <!--PATTERN mei-graphicanalysis-plica-Check_plica-constraint-rule-91-->

   <!--RULE -->
   <xsl:template match="mei:plica" priority="1000" mode="M82">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="mei:plica"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(../mei:plica) &lt;= 1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="count(../mei:plica) &lt;= 1">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Only one plica is allowed.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M82"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M82"/>
   <xsl:template match="@*|node()" priority="-2" mode="M82">
      <xsl:apply-templates select="*" mode="M82"/>
   </xsl:template>
   <!--PATTERN mei-graphicanalysis-stem-Check_stem-constraint-rule-92-->

   <!--RULE -->
   <xsl:template match="mei:stem" priority="1000" mode="M83">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="mei:stem"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(ancestor::mei:note/@*[starts-with(local-name(),'stem.')])"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not(ancestor::mei:note/@*[starts-with(local-name(),'stem.')])">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>A note with nested stem elements must not have @stem.* attributes.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M83"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M83"/>
   <xsl:template match="@*|node()" priority="-2" mode="M83">
      <xsl:apply-templates select="*" mode="M83"/>
   </xsl:template>
   <!--PATTERN mei-graphicanalysis-att.instrumentIdent-instr-check_instrTarget-constraint-rule-93-->

   <!--RULE -->
   <xsl:template match="@instr" priority="1000" mode="M84">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="@instr"/>
      <!--ASSERT warning-->
      <xsl:choose>
         <xsl:when test="not(normalize-space(.) eq '')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not(normalize-space(.) eq '')">
               <xsl:attribute name="role">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>@instr attribute
                should have content.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT warning-->
      <xsl:choose>
         <xsl:when test="every $i in tokenize(., '\s+') satisfies substring($i,2)=//mei:instrDef/@xml:id"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="every $i in tokenize(., '\s+') satisfies substring($i,2)=//mei:instrDef/@xml:id">
               <xsl:attribute name="role">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>The value in @instr should correspond to the @xml:id attribute of an instrDef
                element.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M84"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M84"/>
   <xsl:template match="@*|node()" priority="-2" mode="M84">
      <xsl:apply-templates select="*" mode="M84"/>
   </xsl:template>
   <!--PATTERN mei-graphicanalysis-att.midiInstrument-One_of_instrname_or_instrnum-constraint-rule-94-->

   <!--RULE -->
   <xsl:template match="mei:*[@midi.instrname]" priority="1000" mode="M85">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="mei:*[@midi.instrname]"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(@midi.instrnum)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(@midi.instrnum)">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Only one of @midi.instrname and @midi.instrnum
            allowed.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M85"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M85"/>
   <xsl:template match="@*|node()" priority="-2" mode="M85">
      <xsl:apply-templates select="*" mode="M85"/>
   </xsl:template>
   <!--PATTERN mei-graphicanalysis-att.midiInstrument-One_of_patchname_or_patchnum-constraint-rule-95-->

   <!--RULE -->
   <xsl:template match="mei:*[@midi.patchname]" priority="1000" mode="M86">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="mei:*[@midi.patchname]"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(@midi.patchnum)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(@midi.patchnum)">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Only one of @midi.patchname and @midi.patchnum
            allowed.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M86"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M86"/>
   <xsl:template match="@*|node()" priority="-2" mode="M86">
      <xsl:apply-templates select="*" mode="M86"/>
   </xsl:template>
   <!--PATTERN mei-graphicanalysis-att.componentType-comptype-checkComponentType-constraint-rule-96-->

   <!--RULE -->
   <xsl:template match="mei:*[@comptype]" priority="1000" mode="M87">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="mei:*[@comptype]"/>
      <xsl:variable name="elementName" select="local-name()"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="ancestor::mei:componentList"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="ancestor::mei:componentList">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>The comptype attribute may occur on
                <xsl:text/>
                  <xsl:value-of select="$elementName"/>
                  <xsl:text/> only when it is a descendant of a
                componentList.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M87"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M87"/>
   <xsl:template match="@*|node()" priority="-2" mode="M87">
      <xsl:apply-templates select="*" mode="M87"/>
   </xsl:template>
   <!--PATTERN mei-graphicanalysis-catchwords-check_catchwords_inline-constraint-rule-97-->

   <!--RULE -->
   <xsl:template match="mei:catchwords" priority="1000" mode="M88">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="mei:catchwords"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="ancestor::mei:physDesc"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ancestor::mei:physDesc">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>The catchwords element may only appear as a
            descendant of the physDesc element.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M88"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M88"/>
   <xsl:template match="@*|node()" priority="-2" mode="M88">
      <xsl:apply-templates select="*" mode="M88"/>
   </xsl:template>
   <!--PATTERN mei-graphicanalysis-locusGrp-check_locusGrp_inline-constraint-rule-98-->

   <!--RULE -->
   <xsl:template match="mei:locusGrp" priority="1000" mode="M89">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="mei:locusGrp"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="ancestor::mei:physDesc or parent::mei:contentItem or              ancestor::mei:source[ancestor::mei:componentList[ancestor::mei:sourceDesc or              ancestor::mei:sourceList or ancestor::mei:workList]]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="ancestor::mei:physDesc or parent::mei:contentItem or ancestor::mei:source[ancestor::mei:componentList[ancestor::mei:sourceDesc or ancestor::mei:sourceList or ancestor::mei:workList]]">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>The locusGrp element may only appear as a descendant of a physDesc element, a
            contentItem element, or a source element that is a component of another source or
            work.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M89"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M89"/>
   <xsl:template match="@*|node()" priority="-2" mode="M89">
      <xsl:apply-templates select="*" mode="M89"/>
   </xsl:template>
   <!--PATTERN mei-graphicanalysis-secFolio-check_secFolio_inline-constraint-rule-99-->

   <!--RULE -->
   <xsl:template match="mei:secFolio" priority="1000" mode="M90">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="mei:secFolio"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="ancestor::mei:physDesc"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ancestor::mei:physDesc">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>The secFolio element may only appear as a
            descendant of the physDesc element.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M90"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M90"/>
   <xsl:template match="@*|node()" priority="-2" mode="M90">
      <xsl:apply-templates select="*" mode="M90"/>
   </xsl:template>
   <!--PATTERN mei-graphicanalysis-signatures-check_signatures_inline-constraint-rule-100-->

   <!--RULE -->
   <xsl:template match="mei:signatures" priority="1000" mode="M91">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="mei:signatures"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="ancestor::mei:physDesc"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ancestor::mei:physDesc">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>The signatures element may only appear as a
            descendant of the physDesc element.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M91"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M91"/>
   <xsl:template match="@*|node()" priority="-2" mode="M91">
      <xsl:apply-templates select="*" mode="M91"/>
   </xsl:template>
   <!--PATTERN mei-graphicanalysis-att.alignment-check_whenTarget-constraint-rule-101-->

   <!--RULE -->
   <xsl:template match="@when" priority="1000" mode="M92">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="@when"/>
      <!--ASSERT warning-->
      <xsl:choose>
         <xsl:when test="not(normalize-space(.) eq '')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not(normalize-space(.) eq '')">
               <xsl:attribute name="role">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>@when attribute should
            have content.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT warning-->
      <xsl:choose>
         <xsl:when test="every $i in tokenize(., '\s+') satisfies substring($i,2)=//mei:when/@xml:id"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="every $i in tokenize(., '\s+') satisfies substring($i,2)=//mei:when/@xml:id">
               <xsl:attribute name="role">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>A
            value in @when should correspond to the @xml:id attribute of a when
            element.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M92"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M92"/>
   <xsl:template match="@*|node()" priority="-2" mode="M92">
      <xsl:apply-templates select="*" mode="M92"/>
   </xsl:template>
   <!--PATTERN mei-graphicanalysis-avFile-avFile_child_of_clip-constraint-rule-102-->

   <!--RULE -->
   <xsl:template match="mei:clip/mei:avFile" priority="1000" mode="M93">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="mei:clip/mei:avFile"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(mei:*) = 0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="count(mei:*) = 0">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>An avFile child of clip cannot have
            children.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M93"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M93"/>
   <xsl:template match="@*|node()" priority="-2" mode="M93">
      <xsl:apply-templates select="*" mode="M93"/>
   </xsl:template>
   <!--PATTERN mei-graphicanalysis-clip-betype_required_when_begin_or_end-constraint-rule-103-->

   <!--RULE -->
   <xsl:template match="mei:clip[@begin or @end]" priority="1000" mode="M94">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="mei:clip[@begin or @end]"/>
      <!--ASSERT warning-->
      <xsl:choose>
         <xsl:when test="@betype or ancestor::mei:*[@betype]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="@betype or ancestor::mei:*[@betype]">
               <xsl:attribute name="role">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>When @begin or @end
            is used, @betype should appear on clip or one of its ancestors.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M94"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M94"/>
   <xsl:template match="@*|node()" priority="-2" mode="M94">
      <xsl:apply-templates select="*" mode="M94"/>
   </xsl:template>
   <!--PATTERN mei-graphicanalysis-recording-betype_required_when_begin_or_end-constraint-rule-104-->

   <!--RULE -->
   <xsl:template match="mei:recording[@begin or @end]" priority="1000" mode="M95">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="mei:recording[@begin or @end]"/>
      <!--ASSERT warning-->
      <xsl:choose>
         <xsl:when test="@betype"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="@betype">
               <xsl:attribute name="role">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>When @begin or @end is used, @betype should be
            present.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M95"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M95"/>
   <xsl:template match="@*|node()" priority="-2" mode="M95">
      <xsl:apply-templates select="*" mode="M95"/>
   </xsl:template>
   <!--PATTERN mei-graphicanalysis-when-check_when_interval-constraint-rule-105-->

   <!--RULE -->
   <xsl:template match="mei:when[@interval]" priority="1002" mode="M96">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="mei:when[@interval]"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="@since"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="@since">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>@since must be present when @interval is used.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT warning-->
      <xsl:choose>
         <xsl:when test="every $i in tokenize(@since, '\s+') satisfies substring($i,2)=//mei:when/@xml:id"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="every $i in tokenize(@since, '\s+') satisfies substring($i,2)=//mei:when/@xml:id">
               <xsl:attribute name="role">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>The value in @since should correspond to the @xml:id attribute of a when
            element.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M96"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="mei:when[matches(@interval, '^[0-9]+$')]"
                 priority="1001"
                 mode="M96">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="mei:when[matches(@interval, '^[0-9]+$')]"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(@inttype eq 'time')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(@inttype eq 'time')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>When @interval contains an integer value,
            @inttype cannot be 'time'.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M96"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="mei:when[matches(@interval, ':')]"
                 priority="1000"
                 mode="M96">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="mei:when[matches(@interval, ':')]"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="@inttype eq 'time'"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="@inttype eq 'time'">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>When @interval contains a time value, @inttype must
            be 'time'.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M96"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M96"/>
   <xsl:template match="@*|node()" priority="-2" mode="M96">
      <xsl:apply-templates select="*" mode="M96"/>
   </xsl:template>
   <!--PATTERN mei-graphicanalysis-when-check_when_absolute-constraint-rule-108-->

   <!--RULE -->
   <xsl:template match="mei:when[@absolute]" priority="1000" mode="M97">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="mei:when[@absolute]"/>
      <!--ASSERT warning-->
      <xsl:choose>
         <xsl:when test="@abstype or ancestor::mei:*[@betype]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="@abstype or ancestor::mei:*[@betype]">
               <xsl:attribute name="role">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>When @absolute is
            present, @abstype should be present or @betype should be present on an
            ancestor.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M97"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M97"/>
   <xsl:template match="@*|node()" priority="-2" mode="M97">
      <xsl:apply-templates select="*" mode="M97"/>
   </xsl:template>
   <!--PATTERN mei-graphicanalysis-when-since-check_sinceTarget-constraint-rule-109-->

   <!--RULE -->
   <xsl:template match="@since" priority="1000" mode="M98">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="@since"/>
      <!--ASSERT warning-->
      <xsl:choose>
         <xsl:when test="not(normalize-space(.) eq '')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not(normalize-space(.) eq '')">
               <xsl:attribute name="role">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>@since attribute
                should have content.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT warning-->
      <xsl:choose>
         <xsl:when test="every $i in tokenize(., '\s+') satisfies substring($i,2)=//mei:when/@xml:id"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="every $i in tokenize(., '\s+') satisfies substring($i,2)=//mei:when/@xml:id">
               <xsl:attribute name="role">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>The value in @since should correspond to the @xml:id attribute of a when
                element.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M98"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M98"/>
   <xsl:template match="@*|node()" priority="-2" mode="M98">
      <xsl:apply-templates select="*" mode="M98"/>
   </xsl:template>
   <!--PATTERN mei-graphicanalysis-att.attacca.log-target-check_attaccaTarget-constraint-rule-110-->

   <!--RULE -->
   <xsl:template match="mei:attacca/@target" priority="1000" mode="M99">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="mei:attacca/@target"/>
      <!--ASSERT warning-->
      <xsl:choose>
         <xsl:when test="not(normalize-space(.) eq '')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not(normalize-space(.) eq '')">
               <xsl:attribute name="role">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>@target attribute
                should have content.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT warning-->
      <xsl:choose>
         <xsl:when test="every $i in tokenize(., '\s+') satisfies substring($i,2)=//mei:*[local-name() eq 'section' or local-name() eq 'mdiv']/@xml:id"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="every $i in tokenize(., '\s+') satisfies substring($i,2)=//mei:*[local-name() eq 'section' or local-name() eq 'mdiv']/@xml:id">
               <xsl:attribute name="role">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>The value in @target should correspond to the @xml:id attribute of a section or
                mdiv element.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M99"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M99"/>
   <xsl:template match="@*|node()" priority="-2" mode="M99">
      <xsl:apply-templates select="*" mode="M99"/>
   </xsl:template>
   <!--PATTERN mei-graphicanalysis-att.augmentDots-dots-dots_attribute_requires_dur-constraint-rule-111-->

   <!--RULE -->
   <xsl:template match="mei:*[@dots]" priority="1000" mode="M100">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="mei:*[@dots]"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="@dur"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="@dur">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>An element with a dots attribute must also have a dur
                attribute.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M100"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M100"/>
   <xsl:template match="@*|node()" priority="-2" mode="M100">
      <xsl:apply-templates select="*" mode="M100"/>
   </xsl:template>
   <!--PATTERN mei-graphicanalysis-att.barring-bar.method-check_barmethod-constraint-rule-112-->

   <!--RULE -->
   <xsl:template match="@bar.method[parent::*[matches(local-name(), '(staffDef|measure)')]]"
                 priority="1000"
                 mode="M101">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="@bar.method[parent::*[matches(local-name(), '(staffDef|measure)')]]"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(. eq 'mensur')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(. eq 'mensur')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>"mensur" not allowed in this
                context.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M101"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M101"/>
   <xsl:template match="@*|node()" priority="-2" mode="M101">
      <xsl:apply-templates select="*" mode="M101"/>
   </xsl:template>
   <!--PATTERN mei-graphicanalysis-att.classed-class-check_classURI-constraint-rule-113-->

   <!--RULE -->
   <xsl:template match="@class" priority="1000" mode="M102">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="@class"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="every $i in tokenize(., '\s+') satisfies substring($i,2)=//mei:category/@xml:id or matches($i, '^([a-z]+://|\.{1,2}/)')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="every $i in tokenize(., '\s+') satisfies substring($i,2)=//mei:category/@xml:id or matches($i, '^([a-z]+://|\.{1,2}/)')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>The value in @class must either correspond to the @xml:id attribute of a category
                element or be an external URL.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M102"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M102"/>
   <xsl:template match="@*|node()" priority="-2" mode="M102">
      <xsl:apply-templates select="*" mode="M102"/>
   </xsl:template>
   <!--PATTERN mei-graphicanalysis-att.cleffing.log-clef_shape_requires_clef_line-constraint-rule-114-->

   <!--RULE -->
   <xsl:template match="mei:*[matches(@clef.shape, '[FCG]')]"
                 priority="1001"
                 mode="M103">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="mei:*[matches(@clef.shape, '[FCG]')]"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="@clef.line"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="@clef.line">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>An 'F', 'C', or 'G' clef requires that its position be
            specified.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M103"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="mei:*[matches(@clef.shape, '(TAB|perc)')]"
                 priority="1000"
                 mode="M103">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="mei:*[matches(@clef.shape, '(TAB|perc)')]"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="@lines"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="@lines">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>A TAB or percussion clef requires that the number of lines be
            specified.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M103"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M103"/>
   <xsl:template match="@*|node()" priority="-2" mode="M103">
      <xsl:apply-templates select="*" mode="M103"/>
   </xsl:template>
   <!--PATTERN mei-graphicanalysis-att.clefShape-shape_requires_line-constraint-rule-116-->

   <!--RULE -->
   <xsl:template match="mei:clef[matches(@shape, '[FCG]')]"
                 priority="1000"
                 mode="M104">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="mei:clef[matches(@shape, '[FCG]')]"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="@line"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="@line">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>When @shape is present, @line must also be
            specified.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M104"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M104"/>
   <xsl:template match="@*|node()" priority="-2" mode="M104">
      <xsl:apply-templates select="*" mode="M104"/>
   </xsl:template>
   <!--PATTERN mei-graphicanalysis-att.custos.log-target-check_custosTarget-constraint-rule-117-->

   <!--RULE -->
   <xsl:template match="mei:custos/@target" priority="1000" mode="M105">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="mei:custos/@target"/>
      <!--ASSERT warning-->
      <xsl:choose>
         <xsl:when test="not(normalize-space(.) eq '')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not(normalize-space(.) eq '')">
               <xsl:attribute name="role">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>@target attribute
                should have content.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT warning-->
      <xsl:choose>
         <xsl:when test="every $i in tokenize(., '\s+') satisfies substring($i,2)=//mei:note/@xml:id"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="every $i in tokenize(., '\s+') satisfies substring($i,2)=//mei:note/@xml:id">
               <xsl:attribute name="role">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>The value in @target should correspond to the @xml:id attribute of a note
                element.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M105"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M105"/>
   <xsl:template match="@*|node()" priority="-2" mode="M105">
      <xsl:apply-templates select="*" mode="M105"/>
   </xsl:template>
   <!--PATTERN mei-graphicanalysis-att.dataPointing-data-check_dataTarget-constraint-rule-118-->

   <!--RULE -->
   <xsl:template match="@data" priority="1000" mode="M106">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="@data"/>
      <!--ASSERT warning-->
      <xsl:choose>
         <xsl:when test="not(normalize-space(.) eq '')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not(normalize-space(.) eq '')">
               <xsl:attribute name="role">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>@data attribute should
                have content.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT warning-->
      <xsl:choose>
         <xsl:when test="every $i in tokenize(., '\s+') satisfies substring($i,2)=//mei:*[ancestor::mei:music]/@xml:id"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="every $i in tokenize(., '\s+') satisfies substring($i,2)=//mei:*[ancestor::mei:music]/@xml:id">
               <xsl:attribute name="role">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>The value in @data should correspond to the @xml:id attribute of a descendant of
                the music element.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M106"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M106"/>
   <xsl:template match="@*|node()" priority="-2" mode="M106">
      <xsl:apply-templates select="*" mode="M106"/>
   </xsl:template>
   <!--PATTERN mei-graphicanalysis-att.metadataPointing-decls-check_declsTarget-constraint-rule-119-->

   <!--RULE -->
   <xsl:template match="@decls" priority="1000" mode="M107">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="@decls"/>
      <!--ASSERT warning-->
      <xsl:choose>
         <xsl:when test="not(normalize-space(.) eq '')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not(normalize-space(.) eq '')">
               <xsl:attribute name="role">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>@decls attribute
                should have content.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT warning-->
      <xsl:choose>
         <xsl:when test="every $i in tokenize(., '\s+') satisfies substring($i,2)=//mei:*[ancestor::mei:meiHead]/@xml:id"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="every $i in tokenize(., '\s+') satisfies substring($i,2)=//mei:*[ancestor::mei:meiHead]/@xml:id">
               <xsl:attribute name="role">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Each value in @decls should correspond to the @xml:id attribute of an element
                within the metadata header.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="every $i in tokenize(., '\s+') satisfies not(substring($i,2)=//mei:term/@xml:id)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="every $i in tokenize(., '\s+') satisfies not(substring($i,2)=//mei:term/@xml:id)">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>No value in @decls should correspond to the @xml:id attribute of a classification
                term. Use @class for this purpose.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M107"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M107"/>
   <xsl:template match="@*|node()" priority="-2" mode="M107">
      <xsl:apply-templates select="*" mode="M107"/>
   </xsl:template>
   <!--PATTERN mei-graphicanalysis-att.extent-extent-check_extent-constraint-rule-120-->

   <!--RULE -->
   <xsl:template match="@extent[matches(normalize-space(.), '^\d+(\.\d+)?$')]"
                 priority="1001"
                 mode="M108">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="@extent[matches(normalize-space(.), '^\d+(\.\d+)?$')]"/>
      <!--ASSERT warning-->
      <xsl:choose>
         <xsl:when test="../@unit"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="../@unit">
               <xsl:attribute name="role">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>The @unit attribute is
                recommended.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M108"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="@extent[matches(., '\d+(\.\d+)?\s')]"
                 priority="1000"
                 mode="M108">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="@extent[matches(., '\d+(\.\d+)?\s')]"/>
      <!--ASSERT warning-->
      <xsl:choose>
         <xsl:when test="../@unit"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="../@unit">
               <xsl:attribute name="role">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Separation into value (@extent) and unit
                (@unit) is recommended.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M108"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M108"/>
   <xsl:template match="@*|node()" priority="-2" mode="M108">
      <xsl:apply-templates select="*" mode="M108"/>
   </xsl:template>
   <!--PATTERN mei-graphicanalysis-att.handIdent-hand-check_handTarget-constraint-rule-122-->

   <!--RULE -->
   <xsl:template match="@hand" priority="1000" mode="M109">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="@hand"/>
      <!--ASSERT warning-->
      <xsl:choose>
         <xsl:when test="not(normalize-space(.) eq '')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not(normalize-space(.) eq '')">
               <xsl:attribute name="role">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>@hand attribute should
                have content.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT warning-->
      <xsl:choose>
         <xsl:when test="every $i in tokenize(., '\s+') satisfies substring($i,2)=//mei:hand/@xml:id"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="every $i in tokenize(., '\s+') satisfies substring($i,2)=//mei:hand/@xml:id">
               <xsl:attribute name="role">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Each value in @hand should correspond to the @xml:id attribute of a hand
                element.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M109"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M109"/>
   <xsl:template match="@*|node()" priority="-2" mode="M109">
      <xsl:apply-templates select="*" mode="M109"/>
   </xsl:template>
   <!--PATTERN mei-graphicanalysis-att.joined-join-check_joinTarget-constraint-rule-123-->

   <!--RULE -->
   <xsl:template match="@join" priority="1000" mode="M110">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="@join"/>
      <!--ASSERT warning-->
      <xsl:choose>
         <xsl:when test="not(normalize-space(.) eq '')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not(normalize-space(.) eq '')">
               <xsl:attribute name="role">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>@join attribute should
                have content.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT warning-->
      <xsl:choose>
         <xsl:when test="every $i in tokenize(., '\s+') satisfies substring($i,2)=//mei:*/@xml:id"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="every $i in tokenize(., '\s+') satisfies substring($i,2)=//mei:*/@xml:id">
               <xsl:attribute name="role">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Each
                value in @join should correspond to the @xml:id attribute of an
                element.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M110"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M110"/>
   <xsl:template match="@*|node()" priority="-2" mode="M110">
      <xsl:apply-templates select="*" mode="M110"/>
   </xsl:template>
   <!--PATTERN mei-graphicanalysis-att.layer.log-def-check_defTarget_layer-constraint-rule-124-->

   <!--RULE -->
   <xsl:template match="mei:layer/@def" priority="1000" mode="M111">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="mei:layer/@def"/>
      <!--ASSERT warning-->
      <xsl:choose>
         <xsl:when test="not(normalize-space(.) eq '')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not(normalize-space(.) eq '')">
               <xsl:attribute name="role">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>@def attribute should
                have content.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT warning-->
      <xsl:choose>
         <xsl:when test="every $i in tokenize(., '\s+') satisfies substring($i,2)=//mei:layerDef/@xml:id"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="every $i in tokenize(., '\s+') satisfies substring($i,2)=//mei:layerDef/@xml:id">
               <xsl:attribute name="role">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>The value in @def should correspond to the @xml:id attribute of a layerDef
                element.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M111"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M111"/>
   <xsl:template match="@*|node()" priority="-2" mode="M111">
      <xsl:apply-templates select="*" mode="M111"/>
   </xsl:template>
   <!--PATTERN mei-graphicanalysis-att.lineRend.base-lsegs-check_lsegs-constraint-rule-125-->

   <!--RULE -->
   <xsl:template match="@lsegs" priority="1000" mode="M112">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="@lsegs"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="matches(../@lform, '(dashed|dotted|wavy)')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="matches(../@lform, '(dashed|dotted|wavy)')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>@lform attribute
                matching "dashed", "dotted", or "wavy" required.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M112"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M112"/>
   <xsl:template match="@*|node()" priority="-2" mode="M112">
      <xsl:apply-templates select="*" mode="M112"/>
   </xsl:template>
   <!--PATTERN mei-graphicanalysis-att.linking-copyof-When_copyof_element_empty-constraint-rule-126-->

   <!--RULE -->
   <xsl:template match="mei:*[@copyof]" priority="1000" mode="M113">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="mei:*[@copyof]"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(child::*[not(comment() or processing-instruction())]) = 0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="count(child::*[not(comment() or processing-instruction())]) = 0">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>An
                element with a copyof attribute can only have comment or processing instruction
                descendents.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M113"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M113"/>
   <xsl:template match="@*|node()" priority="-2" mode="M113">
      <xsl:apply-templates select="*" mode="M113"/>
   </xsl:template>
   <!--PATTERN mei-graphicanalysis-att.linking-copyof-check_copyofTarget-constraint-rule-127-->

   <!--RULE -->
   <xsl:template match="@copyof" priority="1000" mode="M114">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="@copyof"/>
      <!--ASSERT warning-->
      <xsl:choose>
         <xsl:when test="not(normalize-space(.) eq '')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not(normalize-space(.) eq '')">
               <xsl:attribute name="role">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>@copyof attribute
                should have content.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT warning-->
      <xsl:choose>
         <xsl:when test="every $i in tokenize(., '\s+') satisfies substring($i,2)=//mei:*/@xml:id"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="every $i in tokenize(., '\s+') satisfies substring($i,2)=//mei:*/@xml:id">
               <xsl:attribute name="role">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>The
                value in @copyof should correspond to the @xml:id attribute of an
                element.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M114"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M114"/>
   <xsl:template match="@*|node()" priority="-2" mode="M114">
      <xsl:apply-templates select="*" mode="M114"/>
   </xsl:template>
   <!--PATTERN mei-graphicanalysis-att.linking-corresp-check_correspTarget-constraint-rule-128-->

   <!--RULE -->
   <xsl:template match="@corresp" priority="1000" mode="M115">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="@corresp"/>
      <!--ASSERT warning-->
      <xsl:choose>
         <xsl:when test="not(normalize-space(.) eq '')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not(normalize-space(.) eq '')">
               <xsl:attribute name="role">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>@corresp attribute
                should have content.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT warning-->
      <xsl:choose>
         <xsl:when test="every $i in tokenize(., '\s+') satisfies substring($i,2)=//mei:*/@xml:id"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="every $i in tokenize(., '\s+') satisfies substring($i,2)=//mei:*/@xml:id">
               <xsl:attribute name="role">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Each
                value in @corresp should correspond to the @xml:id attribute of an
                element.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M115"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M115"/>
   <xsl:template match="@*|node()" priority="-2" mode="M115">
      <xsl:apply-templates select="*" mode="M115"/>
   </xsl:template>
   <!--PATTERN mei-graphicanalysis-att.linking-follows-check_followsTarget-constraint-rule-129-->

   <!--RULE -->
   <xsl:template match="@follows" priority="1000" mode="M116">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="@follows"/>
      <!--ASSERT warning-->
      <xsl:choose>
         <xsl:when test="not(normalize-space(.) eq '')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not(normalize-space(.) eq '')">
               <xsl:attribute name="role">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>@follows attribute
                should have content.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT warning-->
      <xsl:choose>
         <xsl:when test="every $i in tokenize(., '\s+') satisfies substring($i,2)=//mei:*/@xml:id"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="every $i in tokenize(., '\s+') satisfies substring($i,2)=//mei:*/@xml:id">
               <xsl:attribute name="role">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Each
                value in @follows must correspond to the @xml:id attribute of an
                element.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M116"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M116"/>
   <xsl:template match="@*|node()" priority="-2" mode="M116">
      <xsl:apply-templates select="*" mode="M116"/>
   </xsl:template>
   <!--PATTERN mei-graphicanalysis-att.linking-next-check_nextTarget-constraint-rule-130-->

   <!--RULE -->
   <xsl:template match="@next" priority="1000" mode="M117">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="@next"/>
      <!--ASSERT warning-->
      <xsl:choose>
         <xsl:when test="not(normalize-space(.) eq '')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not(normalize-space(.) eq '')">
               <xsl:attribute name="role">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>@next attribute should
                have content.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT warning-->
      <xsl:choose>
         <xsl:when test="every $i in tokenize(., '\s+') satisfies substring($i,2)=//mei:*/@xml:id"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="every $i in tokenize(., '\s+') satisfies substring($i,2)=//mei:*/@xml:id">
               <xsl:attribute name="role">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Each
                value in @next should correspond to the @xml:id attribute of an
                element.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M117"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M117"/>
   <xsl:template match="@*|node()" priority="-2" mode="M117">
      <xsl:apply-templates select="*" mode="M117"/>
   </xsl:template>
   <!--PATTERN mei-graphicanalysis-att.linking-precedes-check_precedesTarget-constraint-rule-131-->

   <!--RULE -->
   <xsl:template match="@precedes" priority="1000" mode="M118">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="@precedes"/>
      <!--ASSERT warning-->
      <xsl:choose>
         <xsl:when test="not(normalize-space(.) eq '')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not(normalize-space(.) eq '')">
               <xsl:attribute name="role">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>@precedes attribute
                should have content.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT warning-->
      <xsl:choose>
         <xsl:when test="every $i in tokenize(., '\s+') satisfies substring($i,2)=//mei:*/@xml:id"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="every $i in tokenize(., '\s+') satisfies substring($i,2)=//mei:*/@xml:id">
               <xsl:attribute name="role">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Each
                value in @precedes must correspond to the @xml:id attribute of an
                element.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M118"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M118"/>
   <xsl:template match="@*|node()" priority="-2" mode="M118">
      <xsl:apply-templates select="*" mode="M118"/>
   </xsl:template>
   <!--PATTERN mei-graphicanalysis-att.linking-prev-check_prevTarget-constraint-rule-132-->

   <!--RULE -->
   <xsl:template match="@prev" priority="1000" mode="M119">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="@prev"/>
      <!--ASSERT warning-->
      <xsl:choose>
         <xsl:when test="not(normalize-space(.) eq '')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not(normalize-space(.) eq '')">
               <xsl:attribute name="role">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>@prev attribute should
                have content.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT warning-->
      <xsl:choose>
         <xsl:when test="every $i in tokenize(., '\s+') satisfies substring($i,2)=//mei:*/@xml:id"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="every $i in tokenize(., '\s+') satisfies substring($i,2)=//mei:*/@xml:id">
               <xsl:attribute name="role">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Each
                value in @prev should correspond to the @xml:id attribute of an
                element.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M119"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M119"/>
   <xsl:template match="@*|node()" priority="-2" mode="M119">
      <xsl:apply-templates select="*" mode="M119"/>
   </xsl:template>
   <!--PATTERN mei-graphicanalysis-att.linking-sameas-check_sameasTarget-constraint-rule-133-->

   <!--RULE -->
   <xsl:template match="@sameas" priority="1000" mode="M120">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="@sameas"/>
      <!--ASSERT warning-->
      <xsl:choose>
         <xsl:when test="not(normalize-space(.) eq '')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not(normalize-space(.) eq '')">
               <xsl:attribute name="role">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>@sameas attribute
                should have content.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT warning-->
      <xsl:choose>
         <xsl:when test="every $i in tokenize(., '\s+') satisfies substring($i,2)=//mei:*/@xml:id"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="every $i in tokenize(., '\s+') satisfies substring($i,2)=//mei:*/@xml:id">
               <xsl:attribute name="role">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Each
                value in @sameas should correspond to the @xml:id attribute of an
                element.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M120"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M120"/>
   <xsl:template match="@*|node()" priority="-2" mode="M120">
      <xsl:apply-templates select="*" mode="M120"/>
   </xsl:template>
   <!--PATTERN mei-graphicanalysis-att.linking-synch-check_synchTarget-constraint-rule-134-->

   <!--RULE -->
   <xsl:template match="@synch" priority="1000" mode="M121">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="@synch"/>
      <!--ASSERT warning-->
      <xsl:choose>
         <xsl:when test="not(normalize-space(.) eq '')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not(normalize-space(.) eq '')">
               <xsl:attribute name="role">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>@synch attribute
                should have content.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT warning-->
      <xsl:choose>
         <xsl:when test="every $i in tokenize(., '\s+') satisfies substring($i,2)=//mei:*/@xml:id"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="every $i in tokenize(., '\s+') satisfies substring($i,2)=//mei:*/@xml:id">
               <xsl:attribute name="role">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Each
                value in @synch should correspond to the @xml:id attribute of an
                element.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M121"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M121"/>
   <xsl:template match="@*|node()" priority="-2" mode="M121">
      <xsl:apply-templates select="*" mode="M121"/>
   </xsl:template>
   <!--PATTERN mei-graphicanalysis-att.meiVersion-meiVersion.onlyRoot-constraint-rule-135-->

   <!--RULE -->
   <xsl:template match="/mei:*//*" priority="1000" mode="M122">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/mei:*//*"/>
      <!--REPORT -->
      <xsl:if test="@meiversion">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="@meiversion">
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>The @meiversion attribute is not allowed on elements that are not the document root element.</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M122"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M122"/>
   <xsl:template match="@*|node()" priority="-2" mode="M122">
      <xsl:apply-templates select="*" mode="M122"/>
   </xsl:template>
   <!--PATTERN mei-graphicanalysis-att.name-nymref-check_nymrefTarget-constraint-rule-136-->

   <!--RULE -->
   <xsl:template match="@nymref" priority="1000" mode="M123">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="@nymref"/>
      <!--ASSERT warning-->
      <xsl:choose>
         <xsl:when test="not(normalize-space(.) eq '')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not(normalize-space(.) eq '')">
               <xsl:attribute name="role">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>@nymref attribute
                should have content.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT warning-->
      <xsl:choose>
         <xsl:when test="every $i in tokenize(., '\s+') satisfies substring($i,2)=//mei:*/@xml:id"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="every $i in tokenize(., '\s+') satisfies substring($i,2)=//mei:*/@xml:id">
               <xsl:attribute name="role">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>The
                value in @nymref should correspond to the @xml:id attribute of an
                element.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M123"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M123"/>
   <xsl:template match="@*|node()" priority="-2" mode="M123">
      <xsl:apply-templates select="*" mode="M123"/>
   </xsl:template>
   <!--PATTERN mei-graphicanalysis-att.noteHeads-head.altsym-check_head.altsymTarget-constraint-rule-137-->

   <!--RULE -->
   <xsl:template match="@head.altsym" priority="1000" mode="M124">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="@head.altsym"/>
      <!--ASSERT warning-->
      <xsl:choose>
         <xsl:when test="not(normalize-space(.) eq '')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not(normalize-space(.) eq '')">
               <xsl:attribute name="role">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>@head.altsym attribute
                should have content.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT warning-->
      <xsl:choose>
         <xsl:when test="every $i in tokenize(., '\s+') satisfies substring($i,2)=//mei:symbolDef/@xml:id"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="every $i in tokenize(., '\s+') satisfies substring($i,2)=//mei:symbolDef/@xml:id">
               <xsl:attribute name="role">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>The value in @head.altsym should correspond to the @xml:id attribute of a symbolDef
                element.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M124"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M124"/>
   <xsl:template match="@*|node()" priority="-2" mode="M124">
      <xsl:apply-templates select="*" mode="M124"/>
   </xsl:template>
   <!--PATTERN mei-graphicanalysis-att.noteHeads-head.auth-check_head.auth-constraint-rule-138-->

   <!--RULE -->
   <xsl:template match="mei:*[lower-case(@head.auth) eq 'smufl']"
                 priority="1000"
                 mode="M125">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="mei:*[lower-case(@head.auth) eq 'smufl']"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="matches(@head.shape, '^#x') or matches(@head.shape, '^U+')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="matches(@head.shape, '^#x') or matches(@head.shape, '^U+')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>When
                @head.auth matches 'smufl', @head.shape must contain a numeric glyph reference in
                hexadecimal notation, like "#xE000" or "U+E000".</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M125"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M125"/>
   <xsl:template match="@*|node()" priority="-2" mode="M125">
      <xsl:apply-templates select="*" mode="M125"/>
   </xsl:template>
   <!--PATTERN mei-graphicanalysis-att.noteHeads-head.shape-check_headshape_num-constraint-rule-139-->

   <!--RULE -->
   <xsl:template match="mei:*[(matches(@head.shape, '#x') or matches(@head.shape, 'U+')) and (lower-case(@head.auth) eq 'smufl')]"
                 priority="1000"
                 mode="M126">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="mei:*[(matches(@head.shape, '#x') or matches(@head.shape, 'U+')) and (lower-case(@head.auth) eq 'smufl')]"/>
      <!--ASSERT warning-->
      <xsl:choose>
         <xsl:when test="matches(normalize-space(@head.shape), '^(#x|U\+)E([0-9AB][0-9A-F][0-9A-F]|C[0-9A][0-9A-F]|CB[0-9A-F])$')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="matches(normalize-space(@head.shape), '^(#x|U\+)E([0-9AB][0-9A-F][0-9A-F]|C[0-9A][0-9A-F]|CB[0-9A-F])$')">
               <xsl:attribute name="role">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>SMuFL version 1.18 uses the range U+E000 - U+ECBF.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M126"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M126"/>
   <xsl:template match="@*|node()" priority="-2" mode="M126">
      <xsl:apply-templates select="*" mode="M126"/>
   </xsl:template>
   <!--PATTERN mei-graphicanalysis-att.origin.timestamp.log-origin.tstamp2-origin.tstamp2_requires_origin.tstamp-constraint-rule-140-->

   <!--RULE -->
   <xsl:template match="mei:*[@origin.tstamp2]" priority="1000" mode="M127">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="mei:*[@origin.tstamp2]"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="@origin.tstamp"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="@origin.tstamp">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>When @origin.tstamp2 is used @origin.tstamp must
                also be present.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M127"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M127"/>
   <xsl:template match="@*|node()" priority="-2" mode="M127">
      <xsl:apply-templates select="*" mode="M127"/>
   </xsl:template>
   <!--PATTERN mei-graphicanalysis-att.partIdent-part-check_part_attr_all-constraint-rule-141-->

   <!--RULE -->
   <xsl:template match="@part[some $i in tokenize(., '\s+') satisfies (matches($i, '^%all$'))]"
                 priority="1000"
                 mode="M128">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="@part[some $i in tokenize(., '\s+') satisfies (matches($i, '^%all$'))]"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(tokenize(., '\s+')) = 1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="count(tokenize(., '\s+')) = 1">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>'%all' cannot be mixed with other
                values.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M128"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M128"/>
   <xsl:template match="@*|node()" priority="-2" mode="M128">
      <xsl:apply-templates select="*" mode="M128"/>
   </xsl:template>
   <!--PATTERN mei-graphicanalysis-att.partIdent-partstaff-check_partstaff_attr_all-constraint-rule-142-->

   <!--RULE -->
   <xsl:template match="@partstaff[some $i in tokenize(., '\s+') satisfies (matches($i, '^%all$'))]"
                 priority="1000"
                 mode="M129">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="@partstaff[some $i in tokenize(., '\s+') satisfies (matches($i, '^%all$'))]"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(tokenize(., '\s+')) = 1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="count(tokenize(., '\s+')) = 1">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>'%all' cannot be mixed with other
                values.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M129"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M129"/>
   <xsl:template match="@*|node()" priority="-2" mode="M129">
      <xsl:apply-templates select="*" mode="M129"/>
   </xsl:template>
   <!--PATTERN mei-graphicanalysis-att.plist-plist-check_plistTarget-constraint-rule-143-->

   <!--RULE -->
   <xsl:template match="@plist" priority="1000" mode="M130">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="@plist"/>
      <!--ASSERT warning-->
      <xsl:choose>
         <xsl:when test="not(normalize-space(.) eq '')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not(normalize-space(.) eq '')">
               <xsl:attribute name="role">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>@plist attribute
                should have content.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT warning-->
      <xsl:choose>
         <xsl:when test="every $i in tokenize(., '\s+') satisfies substring($i,2)=//mei:*/@xml:id"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="every $i in tokenize(., '\s+') satisfies substring($i,2)=//mei:*/@xml:id">
               <xsl:attribute name="role">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Each
                value in @plist should correspond to the @xml:id attribute of an
                element.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M130"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M130"/>
   <xsl:template match="@*|node()" priority="-2" mode="M130">
      <xsl:apply-templates select="*" mode="M130"/>
   </xsl:template>
   <!--PATTERN mei-graphicanalysis-att.ranging-confidence-check_confidence-constraint-rule-144-->

   <!--RULE -->
   <xsl:template match="mei:*[@confidence]" priority="1000" mode="M131">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="mei:*[@confidence]"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="@min and @max"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="@min and @max">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>The attributes @min and @max are required when
                @confidence is present.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M131"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M131"/>
   <xsl:template match="@*|node()" priority="-2" mode="M131">
      <xsl:apply-templates select="*" mode="M131"/>
   </xsl:template>
   <!--PATTERN mei-graphicanalysis-att.responsibility-resp-check_respTarget-constraint-rule-145-->

   <!--RULE -->
   <xsl:template match="@resp" priority="1000" mode="M132">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="@resp"/>
      <!--ASSERT warning-->
      <xsl:choose>
         <xsl:when test="not(normalize-space(.) eq '')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not(normalize-space(.) eq '')">
               <xsl:attribute name="role">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>@resp attribute should
                have content.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT warning-->
      <xsl:choose>
         <xsl:when test="every $i in tokenize(., '\s+') satisfies substring($i,2)=//mei:*[ancestor::mei:meiHead]/@xml:id"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="every $i in tokenize(., '\s+') satisfies substring($i,2)=//mei:*[ancestor::mei:meiHead]/@xml:id">
               <xsl:attribute name="role">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>The value in @resp should correspond to the @xml:id attribute of an element within
                the metadata header.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M132"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M132"/>
   <xsl:template match="@*|node()" priority="-2" mode="M132">
      <xsl:apply-templates select="*" mode="M132"/>
   </xsl:template>
   <!--PATTERN mei-graphicanalysis-att.source-source-check_sourceTarget-constraint-rule-146-->

   <!--RULE -->
   <xsl:template match="@source" priority="1000" mode="M133">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="@source"/>
      <!--ASSERT warning-->
      <xsl:choose>
         <xsl:when test="not(normalize-space(.) eq '')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not(normalize-space(.) eq '')">
               <xsl:attribute name="role">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>@source attribute
                should have content.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT warning-->
      <xsl:choose>
         <xsl:when test="every $i in tokenize(., '\s+') satisfies substring($i,2)=//mei:*[local-name() eq 'source' or local-name() eq 'manifestation']/@xml:id"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="every $i in tokenize(., '\s+') satisfies substring($i,2)=//mei:*[local-name() eq 'source' or local-name() eq 'manifestation']/@xml:id">
               <xsl:attribute name="role">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Each value in @source should correspond to the @xml:id attribute of a source or
                manifestation element.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M133"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M133"/>
   <xsl:template match="@*|node()" priority="-2" mode="M133">
      <xsl:apply-templates select="*" mode="M133"/>
   </xsl:template>
   <!--PATTERN mei-graphicanalysis-att.staff.log-def-check_defTarget_staff-constraint-rule-147-->

   <!--RULE -->
   <xsl:template match="mei:staff/@def" priority="1000" mode="M134">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="mei:staff/@def"/>
      <!--ASSERT warning-->
      <xsl:choose>
         <xsl:when test="not(normalize-space(.) eq '')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not(normalize-space(.) eq '')">
               <xsl:attribute name="role">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>@def attribute should
                have content.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT warning-->
      <xsl:choose>
         <xsl:when test="every $i in tokenize(., '\s+') satisfies substring($i,2)=//mei:staffDef/@xml:id"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="every $i in tokenize(., '\s+') satisfies substring($i,2)=//mei:staffDef/@xml:id">
               <xsl:attribute name="role">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>The value in @def should correspond to the @xml:id attribute of a staffDef
                element.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M134"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M134"/>
   <xsl:template match="@*|node()" priority="-2" mode="M134">
      <xsl:apply-templates select="*" mode="M134"/>
   </xsl:template>
   <!--PATTERN mei-graphicanalysis-att.startEndId-endid-check_endidTarget-constraint-rule-148-->

   <!--RULE -->
   <xsl:template match="@endid" priority="1000" mode="M135">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="@endid"/>
      <!--ASSERT warning-->
      <xsl:choose>
         <xsl:when test="not(normalize-space(.) eq '')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not(normalize-space(.) eq '')">
               <xsl:attribute name="role">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>@endid attribute
                should have content.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT warning-->
      <xsl:choose>
         <xsl:when test="every $i in tokenize(., '\s+') satisfies substring($i,2)=//mei:*/@xml:id"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="every $i in tokenize(., '\s+') satisfies substring($i,2)=//mei:*/@xml:id">
               <xsl:attribute name="role">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>The
                value in @endid should correspond to the @xml:id attribute of an
                element.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M135"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M135"/>
   <xsl:template match="@*|node()" priority="-2" mode="M135">
      <xsl:apply-templates select="*" mode="M135"/>
   </xsl:template>
   <!--PATTERN mei-graphicanalysis-att.startId-startid-check_startidTarget-constraint-rule-149-->

   <!--RULE -->
   <xsl:template match="@startid" priority="1000" mode="M136">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="@startid"/>
      <!--ASSERT warning-->
      <xsl:choose>
         <xsl:when test="not(normalize-space(.) eq '')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not(normalize-space(.) eq '')">
               <xsl:attribute name="role">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>@startid attribute
                should have content.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT warning-->
      <xsl:choose>
         <xsl:when test="every $i in tokenize(., '\s+') satisfies substring($i,2)=//mei:*/@xml:id"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="every $i in tokenize(., '\s+') satisfies substring($i,2)=//mei:*/@xml:id">
               <xsl:attribute name="role">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>The
                value in @startid should correspond to the @xml:id attribute of an
                element.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M136"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M136"/>
   <xsl:template match="@*|node()" priority="-2" mode="M136">
      <xsl:apply-templates select="*" mode="M136"/>
   </xsl:template>
   <!--PATTERN mei-graphicanalysis-att.stems-stem.sameas-check_stem.sameasTarget-constraint-rule-150-->

   <!--RULE -->
   <xsl:template match="@stem.sameas" priority="1000" mode="M137">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="@stem.sameas"/>
      <xsl:variable name="layer.n" select="self::node()/ancestor::mei:layer/@n"/>
      <xsl:variable name="ref.id" select="substring(.,2)"/>
      <!--ASSERT warning-->
      <xsl:choose>
         <xsl:when test="not(normalize-space(.) eq '')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not(normalize-space(.) eq '')">
               <xsl:attribute name="role">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>@stem.sameas attribute
                should have content.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT warning-->
      <xsl:choose>
         <xsl:when test="substring(.,2)=//mei:note[not(ancestor::mei:layer/@n=$layer.n)]/@xml:id"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="substring(.,2)=//mei:note[not(ancestor::mei:layer/@n=$layer.n)]/@xml:id">
               <xsl:attribute name="role">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
                The value in @stem.sameas should correspond to the @xml:id attribute of the linked note
                element of a different layer.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT warning-->
      <xsl:choose>
         <xsl:when test="../@dur=//mei:note[@xml:id=$ref.id]/@dur"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="../@dur=//mei:note[@xml:id=$ref.id]/@dur">
               <xsl:attribute name="role">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>
                The linked notes by @stem.sameas should have the same @dur values.
              </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M137"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M137"/>
   <xsl:template match="@*|node()" priority="-2" mode="M137">
      <xsl:apply-templates select="*" mode="M137"/>
   </xsl:template>
   <!--PATTERN mei-graphicanalysis-annot-Check_annot_data-constraint-rule-151-->

   <!--RULE -->
   <xsl:template match="mei:annot[@data]" priority="1000" mode="M138">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="mei:annot[@data]"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="ancestor::mei:notesStmt"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ancestor::mei:notesStmt">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>The @data attribute may only occur on an
            annotation within the notesStmt element.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M138"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M138"/>
   <xsl:template match="@*|node()" priority="-2" mode="M138">
      <xsl:apply-templates select="*" mode="M138"/>
   </xsl:template>
   <!--PATTERN mei-graphicanalysis-biblList-checkBiblLabels-constraint-rule-152-->

   <!--RULE -->
   <xsl:template match="mei:biblList[mei:label]" priority="1000" mode="M139">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="mei:biblList[mei:label]"/>
      <!--ASSERT warning-->
      <xsl:choose>
         <xsl:when test="count(mei:label) = count(mei:bibl)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="count(mei:label) = count(mei:bibl)">
               <xsl:attribute name="role">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>When labels are used,
            usually each bibliographic item has one.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M139"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M139"/>
   <xsl:template match="@*|node()" priority="-2" mode="M139">
      <xsl:apply-templates select="*" mode="M139"/>
   </xsl:template>
   <!--PATTERN mei-graphicanalysis-caesura-caesura_start-type_attributes_required-constraint-rule-153-->

   <!--RULE -->
   <xsl:template match="mei:caesura" priority="1000" mode="M140">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="mei:caesura"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="@startid or @tstamp or @tstamp.ges or @tstamp.real"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="@startid or @tstamp or @tstamp.ges or @tstamp.real">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Must have one of the
            attributes: startid, tstamp, tstamp.ges or tstamp.real.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M140"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M140"/>
   <xsl:template match="@*|node()" priority="-2" mode="M140">
      <xsl:apply-templates select="*" mode="M140"/>
   </xsl:template>
   <!--PATTERN mei-graphicanalysis-cb-n-check_cb-constraint-rule-154-->

   <!--RULE -->
   <xsl:template match="mei:cb" priority="1000" mode="M141">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="mei:cb"/>
      <xsl:variable name="totalColumns" select="preceding::mei:colLayout[1]/@cols"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="preceding::mei:colLayout"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="preceding::mei:colLayout">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Column beginning must be preceded by a
                colLayout element.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="@n &lt;= $totalColumns"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="@n &lt;= $totalColumns">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>The value of @n should be less than or equal
                to the value of @cols (<xsl:text/>
                  <xsl:value-of select="$totalColumns"/>
                  <xsl:text/>) of the preceding
                colLayout element.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M141"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M141"/>
   <xsl:template match="@*|node()" priority="-2" mode="M141">
      <xsl:apply-templates select="*" mode="M141"/>
   </xsl:template>
   <!--PATTERN mei-graphicanalysis-clef-Clef_position_lines-constraint-rule-155-->

   <!--RULE -->
   <xsl:template match="mei:clef[matches(@shape, '[FCG]')][ancestor::mei:staffDef[@lines]]"
                 priority="1000"
                 mode="M142">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="mei:clef[matches(@shape, '[FCG]')][ancestor::mei:staffDef[@lines]]"/>
      <xsl:variable name="thisstaff" select="ancestor::mei:staffDef/@n"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="number(@line) &lt;= number(ancestor::mei:staffDef[@n=$thisstaff and @lines][1]/@lines)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="number(@line) &lt;= number(ancestor::mei:staffDef[@n=$thisstaff and @lines][1]/@lines)">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>The clef position must be less than or equal to the number of lines of an ancestor
            staff.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M142"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M142"/>
   <xsl:template match="@*|node()" priority="-2" mode="M142">
      <xsl:apply-templates select="*" mode="M142"/>
   </xsl:template>
   <!--PATTERN mei-graphicanalysis-clef-Clef_position_nolines-constraint-rule-156-->

   <!--RULE -->
   <xsl:template match="mei:clef[ancestor::mei:staffDef[not(@lines)]]"
                 priority="1000"
                 mode="M143">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="mei:clef[ancestor::mei:staffDef[not(@lines)]]"/>
      <xsl:variable name="thisstaff" select="ancestor::mei:staffDef/@n"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="number(@line) &lt;= number(preceding::mei:staffDef[@n=$thisstaff and @lines][1]/@lines)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="number(@line) &lt;= number(preceding::mei:staffDef[@n=$thisstaff and @lines][1]/@lines)">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>The clef position must be less than or equal to the number of lines of a preceding
            staff.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M143"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M143"/>
   <xsl:template match="@*|node()" priority="-2" mode="M143">
      <xsl:apply-templates select="*" mode="M143"/>
   </xsl:template>
   <!--PATTERN mei-graphicanalysis-dimensions-check_dimensions-constraint-rule-157-->

   <!--RULE -->
   <xsl:template match="mei:physDesc/mei:dimensions" priority="1000" mode="M144">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="mei:physDesc/mei:dimensions"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(count(mei:depth) &gt; 1)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not(count(mei:depth) &gt; 1)">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>The depth element may only appear
            once.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(count(mei:height) &gt; 1)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not(count(mei:height) &gt; 1)">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>The height element may only appear
            once.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(count(mei:width) &gt; 1)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not(count(mei:width) &gt; 1)">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>The width element may only appear
            once.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M144"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M144"/>
   <xsl:template match="@*|node()" priority="-2" mode="M144">
      <xsl:apply-templates select="*" mode="M144"/>
   </xsl:template>
   <!--PATTERN mei-graphicanalysis-dir-dir_start-type_attributes_required-constraint-rule-158-->

   <!--RULE -->
   <xsl:template match="mei:dir[not(ancestor::mei:syllable)]"
                 priority="1000"
                 mode="M145">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="mei:dir[not(ancestor::mei:syllable)]"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="@startid or @tstamp or @tstamp.ges or @tstamp.real"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="@startid or @tstamp or @tstamp.ges or @tstamp.real">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Must have one of the
            attributes: startid, tstamp, tstamp.ges or tstamp.real.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M145"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M145"/>
   <xsl:template match="@*|node()" priority="-2" mode="M145">
      <xsl:apply-templates select="*" mode="M145"/>
   </xsl:template>
   <!--PATTERN mei-graphicanalysis-dynam-dynam_start-type_attributes_required-constraint-rule-159-->

   <!--RULE -->
   <xsl:template match="mei:dynam" priority="1000" mode="M146">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="mei:dynam"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="@startid or @tstamp or @tstamp.ges or @tstamp.real"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="@startid or @tstamp or @tstamp.ges or @tstamp.real">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> Must have one of
            the attributes: startid, tstamp, tstamp.ges or tstamp.real.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M146"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M146"/>
   <xsl:template match="@*|node()" priority="-2" mode="M146">
      <xsl:apply-templates select="*" mode="M146"/>
   </xsl:template>
   <!--PATTERN mei-graphicanalysis-dynam-dynam_end-type_attributes-constraint-rule-160-->

   <!--RULE -->
   <xsl:template match="mei:dynam[@val2]" priority="1000" mode="M147">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="mei:dynam[@val2]"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="@dur or @dur.ges or @endid or @tstamp2"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="@dur or @dur.ges or @endid or @tstamp2">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>When @val2 is present, either
            @dur, @dur.ges, @endid, or @tstamp2 must also be present.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M147"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M147"/>
   <xsl:template match="@*|node()" priority="-2" mode="M147">
      <xsl:apply-templates select="*" mode="M147"/>
   </xsl:template>
   <!--PATTERN mei-graphicanalysis-grpSym-check_grpSym_attributes_scoreDef-constraint-rule-161-->

   <!--RULE -->
   <xsl:template match="mei:grpSym[parent::mei:scoreDef]"
                 priority="1000"
                 mode="M148">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="mei:grpSym[parent::mei:scoreDef]"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="@startid and @endid and @level"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="@startid and @endid and @level">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>In scoreDef, grpSym must have startid,
            endid, and level attributes.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M148"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M148"/>
   <xsl:template match="@*|node()" priority="-2" mode="M148">
      <xsl:apply-templates select="*" mode="M148"/>
   </xsl:template>
   <!--PATTERN mei-graphicanalysis-grpSym-check_grpSym_attributes_staffDef-constraint-rule-162-->

   <!--RULE -->
   <xsl:template match="mei:grpSym[parent::mei:staffGrp]"
                 priority="1000"
                 mode="M149">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="mei:grpSym[parent::mei:staffGrp]"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(@startid or @endid or @level)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not(@startid or @endid or @level)">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>In staffGrp, grpSym must not have
            startid, endid, or level attributes.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M149"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M149"/>
   <xsl:template match="@*|node()" priority="-2" mode="M149">
      <xsl:apply-templates select="*" mode="M149"/>
   </xsl:template>
   <!--PATTERN mei-graphicanalysis-keyAccid-Check_keyAccidPlacement-constraint-rule-163-->

   <!--RULE -->
   <xsl:template match="mei:keyAccid" priority="1000" mode="M150">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="mei:keyAccid"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="(@x and @y) or @pname or @loc"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="(@x and @y) or @pname or @loc">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>One of the following is required: @x and
            @y attribute pair, @pname attribute, or @loc attribute. </svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M150"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M150"/>
   <xsl:template match="@*|node()" priority="-2" mode="M150">
      <xsl:apply-templates select="*" mode="M150"/>
   </xsl:template>
   <!--PATTERN mei-graphicanalysis-keySig-check_keyAccid_oct-constraint-rule-164-->

   <!--RULE -->
   <xsl:template match="mei:keySig[mei:keyAccid[@oct]]" priority="1000" mode="M151">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="mei:keySig[mei:keyAccid[@oct]]"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(mei:keyAccid[@oct]) = count(mei:keyAccid)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="count(mei:keyAccid[@oct]) = count(mei:keyAccid)">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>If the @oct attribute
            appears on any keyAccid element, it must be provided on all keyAccid
            elements.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M151"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M151"/>
   <xsl:template match="@*|node()" priority="-2" mode="M151">
      <xsl:apply-templates select="*" mode="M151"/>
   </xsl:template>
   <!--PATTERN mei-graphicanalysis-keySig-check_keySig_editorial-constraint-rule-165-->

   <!--RULE -->
   <xsl:template match="mei:keySig/mei:*[local-name() eq 'add' or local-name() eq 'corr'             or local-name() eq 'damage' or local-name() eq 'del' or local-name() eq 'orig' or              local-name() eq 'reg' or local-name() eq 'restore' or local-name() eq 'sic' or              local-name() eq 'supplied' or local-name() eq 'unclear']"
                 priority="1000"
                 mode="M152">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="mei:keySig/mei:*[local-name() eq 'add' or local-name() eq 'corr'             or local-name() eq 'damage' or local-name() eq 'del' or local-name() eq 'orig' or              local-name() eq 'reg' or local-name() eq 'restore' or local-name() eq 'sic' or              local-name() eq 'supplied' or local-name() eq 'unclear']"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(mei:keyAccid) = count(mei:*)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="count(mei:keyAccid) = count(mei:*)">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Only keyAccid elements are allowed
            here.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M152"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M152"/>
   <xsl:template match="@*|node()" priority="-2" mode="M152">
      <xsl:apply-templates select="*" mode="M152"/>
   </xsl:template>
   <!--PATTERN mei-graphicanalysis-label-label_note_only_in_graph-constraint-rule-166-->

   <!--RULE -->
   <xsl:template match="mei:label[mei:note][not(ancestor::mei:graph)]"
                 priority="1000"
                 mode="M153">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="mei:label[mei:note][not(ancestor::mei:graph)]"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="false()"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="false()">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>A note element is not permitted inside a label element outside a graph.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M153"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M153"/>
   <xsl:template match="@*|node()" priority="-2" mode="M153">
      <xsl:apply-templates select="*" mode="M153"/>
   </xsl:template>
   <!--PATTERN mei-graphicanalysis-mei-Check_staff-constraint-rule-167-->

   <!--RULE -->
   <xsl:template match="mei:*[@staff]" priority="1000" mode="M154">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="mei:*[@staff]"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="every $i in tokenize(normalize-space(@staff), '\s+') satisfies $i=//mei:staffDef/@n"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="every $i in tokenize(normalize-space(@staff), '\s+') satisfies $i=//mei:staffDef/@n">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>The values in @staff must correspond to @n attribute of a staffDef
            element.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M154"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M154"/>
   <xsl:template match="@*|node()" priority="-2" mode="M154">
      <xsl:apply-templates select="*" mode="M154"/>
   </xsl:template>
   <!--PATTERN mei-graphicanalysis-name-nameParts-constraint-rule-168-->

   <!--RULE -->
   <xsl:template match="mei:name" priority="1000" mode="M155">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="mei:name"/>
      <!--ASSERT warning-->
      <xsl:choose>
         <xsl:when test="not(mei:geogName or mei:persName or mei:corpName)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not(mei:geogName or mei:persName or mei:corpName)">
               <xsl:attribute name="role">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Recommended practice is to use name elements to capture sub-parts of a generic
            name.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M155"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M155"/>
   <xsl:template match="@*|node()" priority="-2" mode="M155">
      <xsl:apply-templates select="*" mode="M155"/>
   </xsl:template>
   <!--PATTERN mei-graphicanalysis-ornam-ornam_start-type_attributes_required-constraint-rule-169-->

   <!--RULE -->
   <xsl:template match="mei:ornam" priority="1000" mode="M156">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="mei:ornam"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="@startid or @tstamp or @tstamp.ges or @tstamp.real"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="@startid or @tstamp or @tstamp.ges or @tstamp.real">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Must have one of the
            attributes: startid, tstamp, tstamp.ges or tstamp.real.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M156"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M156"/>
   <xsl:template match="@*|node()" priority="-2" mode="M156">
      <xsl:apply-templates select="*" mode="M156"/>
   </xsl:template>
   <!--PATTERN mei-graphicanalysis-phrase-phrase_start-_and_end-type_attributes_required-constraint-rule-170-->

   <!--RULE -->
   <xsl:template match="mei:phrase" priority="1000" mode="M157">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="mei:phrase"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="@startid or @tstamp or @tstamp.ges or @tstamp.real"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="@startid or @tstamp or @tstamp.ges or @tstamp.real">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Must have one of the
            attributes: startid, tstamp, tstamp.ges or tstamp.real.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="@dur or @dur.ges or @endid or @tstamp2"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="@dur or @dur.ges or @endid or @tstamp2">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Must have one of the attributes:
            dur, dur.ges, endid, or tstamp2.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M157"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M157"/>
   <xsl:template match="@*|node()" priority="-2" mode="M157">
      <xsl:apply-templates select="*" mode="M157"/>
   </xsl:template>
   <!--PATTERN mei-graphicanalysis-phrase-phrase_containing_curve-constraint-rule-171-->

   <!--RULE -->
   <xsl:template match="mei:phrase[mei:curve[@bezier or @bulge or @curvedir or @lform or @lwidth or @ho or              @startho or @endho or @to or @startto or @endto or @vo or @startvo or @endvo or @x or @y or @x2 or @y2]]"
                 priority="1000"
                 mode="M158">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="mei:phrase[mei:curve[@bezier or @bulge or @curvedir or @lform or @lwidth or @ho or              @startho or @endho or @to or @startto or @endto or @vo or @startvo or @endvo or @x or @y or @x2 or @y2]]"/>
      <!--ASSERT warning-->
      <xsl:choose>
         <xsl:when test="not(@bezier or @bulge or @curvedir or @lform or @lwidth or @ho or @startho or @endho or                @to or @startto or @endto or @vo or @startvo or @endvo or @x or @y or @x2 or @y2)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not(@bezier or @bulge or @curvedir or @lform or @lwidth or @ho or @startho or @endho or @to or @startto or @endto or @vo or @startvo or @endvo or @x or @y or @x2 or @y2)">
               <xsl:attribute name="role">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>The visual attributes of the phrase (@bezier, @bulge, @curvedir, @lform,
            @lwidth, @ho, @startho, @endho, @to, @startto, @endto, @vo, @startvo, @endvo, @x, @y,
            @x2, and @y2) will be overridden by visual attributes of the contained curve
            elements.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M158"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M158"/>
   <xsl:template match="@*|node()" priority="-2" mode="M158">
      <xsl:apply-templates select="*" mode="M158"/>
   </xsl:template>
   <!--PATTERN mei-graphicanalysis-relation-FRBR_relation-constraint-rule-172-->

   <!--RULE -->
   <xsl:template match="mei:relationList/mei:relation[parent::mei:work or parent::mei:expression or           parent::mei:source or parent::mei:item]"
                 priority="1000"
                 mode="M159">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="mei:relationList/mei:relation[parent::mei:work or parent::mei:expression or           parent::mei:source or parent::mei:item]"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="matches(@rel, 'hasAbridgement') or             matches(@rel, 'hasAbridgement') or             matches(@rel, 'isAbridgementOf') or             matches(@rel, 'hasAdaptation') or             matches(@rel, 'isAdaptationOf') or             matches(@rel, 'hasAlternate') or             matches(@rel, 'isAlternateOf') or             matches(@rel, 'hasArrangement') or             matches(@rel, 'isArrangementOf') or             matches(@rel, 'hasComplement') or             matches(@rel, 'isComplementOf') or             matches(@rel, 'hasEmbodiment') or             matches(@rel, 'isEmbodimentOf') or             matches(@rel, 'hasExemplar') or             matches(@rel, 'isExemplarOf') or             matches(@rel, 'hasImitation') or             matches(@rel, 'isImitationOf') or             matches(@rel, 'hasPart') or             matches(@rel, 'isPartOf') or             matches(@rel, 'hasRealization') or             matches(@rel, 'isRealizationOf') or             matches(@rel, 'hasReconfiguration') or             matches(@rel, 'isReconfigurationOf') or             matches(@rel, 'hasReproduction') or             matches(@rel, 'isReproductionOf') or             matches(@rel, 'hasRevision') or             matches(@rel, 'isRevisionOf') or             matches(@rel, 'hasSuccessor') or             matches(@rel, 'isSuccessorOf') or             matches(@rel, 'hasSummarization') or             matches(@rel, 'isSummarizationOf') or             matches(@rel, 'hasSupplement') or             matches(@rel, 'isSupplementOf') or             matches(@rel, 'hasTransformation') or             matches(@rel, 'isTransformationOf') or             matches(@rel, 'hasTranslation') or             matches(@rel, 'isTranslationOf')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="matches(@rel, 'hasAbridgement') or matches(@rel, 'hasAbridgement') or matches(@rel, 'isAbridgementOf') or matches(@rel, 'hasAdaptation') or matches(@rel, 'isAdaptationOf') or matches(@rel, 'hasAlternate') or matches(@rel, 'isAlternateOf') or matches(@rel, 'hasArrangement') or matches(@rel, 'isArrangementOf') or matches(@rel, 'hasComplement') or matches(@rel, 'isComplementOf') or matches(@rel, 'hasEmbodiment') or matches(@rel, 'isEmbodimentOf') or matches(@rel, 'hasExemplar') or matches(@rel, 'isExemplarOf') or matches(@rel, 'hasImitation') or matches(@rel, 'isImitationOf') or matches(@rel, 'hasPart') or matches(@rel, 'isPartOf') or matches(@rel, 'hasRealization') or matches(@rel, 'isRealizationOf') or matches(@rel, 'hasReconfiguration') or matches(@rel, 'isReconfigurationOf') or matches(@rel, 'hasReproduction') or matches(@rel, 'isReproductionOf') or matches(@rel, 'hasRevision') or matches(@rel, 'isRevisionOf') or matches(@rel, 'hasSuccessor') or matches(@rel, 'isSuccessorOf') or matches(@rel, 'hasSummarization') or matches(@rel, 'isSummarizationOf') or matches(@rel, 'hasSupplement') or matches(@rel, 'isSupplementOf') or matches(@rel, 'hasTransformation') or matches(@rel, 'isTransformationOf') or matches(@rel, 'hasTranslation') or matches(@rel, 'isTranslationOf')">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Within work, expression, source, or item, the value of the rel attribute must match one
            of the following: hasAbridgement, isAbridgementOf, hasAdaptation, isAdaptationOf,
            hasAlternate, isAlternateOf, hasArrangement, isArrangementOf, hasComplement,
            isComplementOf, hasEmbodiment, isEmbodimentOf, hasExemplar, isExemplarOf, hasImitation,
            isImitationOf, hasPart, isPartOf, hasRealization, isRealizationOf, hasReconfiguration,
            isReconfigurationOf, hasReproduction, isReproductionOf, hasRevision, isRevisionOf,
            hasSuccessor, isSuccessorOf, hasSummarization, isSummarizationOf, hasSupplement,
            isSupplementOf, hasTransformation, isTransformationOf, hasTranslation,
            isTranslationOf</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="@target"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="@target">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Within work, expression, source or item, the target attribute
            must be present.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M159"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M159"/>
   <xsl:template match="@*|node()" priority="-2" mode="M159">
      <xsl:apply-templates select="*" mode="M159"/>
   </xsl:template>
   <!--PATTERN mei-graphicanalysis-respStmt-check_respStmt-constraint-rule-173-->

   <!--RULE -->
   <xsl:template match="mei:respStmt[not(ancestor::mei:change) and not(ancestor::mei:work)]"
                 priority="1001"
                 mode="M160">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="mei:respStmt[not(ancestor::mei:change) and not(ancestor::mei:work)]"/>
      <!--ASSERT warning-->
      <xsl:choose>
         <xsl:when test="(mei:resp and (mei:name or mei:corpName or mei:persName)) or             count(mei:*[@role]) = count(mei:*) and count(mei:*) &gt; 0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="(mei:resp and (mei:name or mei:corpName or mei:persName)) or count(mei:*[@role]) = count(mei:*) and count(mei:*) &gt; 0">
               <xsl:attribute name="role">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>At least one element pair (a resp element and a name-like element) is
            recommended. Alternatively, each name-like element may have a @role
            attribute.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M160"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="mei:respStmt[ancestor::mei:work]"
                 priority="1000"
                 mode="M160">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="mei:respStmt[ancestor::mei:work]"/>
      <!--REPORT warning-->
      <xsl:if test="count(mei:*[@role]) &lt; count(mei:*) or count(mei:*) = 0">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                 test="count(mei:*[@role]) &lt; count(mei:*) or count(mei:*) = 0">
            <xsl:attribute name="role">warning</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Name-like elements with a @role are recommended here.</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <!--REPORT warning-->
      <xsl:if test="mei:resp">
         <svrl:successful-report xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="mei:resp">
            <xsl:attribute name="role">warning</xsl:attribute>
            <xsl:attribute name="location">
               <xsl:apply-templates select="." mode="schematron-select-full-path"/>
            </xsl:attribute>
            <svrl:text>Name-like elements with a @role are recommended here (instead of resp).</svrl:text>
         </svrl:successful-report>
      </xsl:if>
      <xsl:apply-templates select="*" mode="M160"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M160"/>
   <xsl:template match="@*|node()" priority="-2" mode="M160">
      <xsl:apply-templates select="*" mode="M160"/>
   </xsl:template>
   <!--PATTERN mei-graphicanalysis-section-Check_sectionexpansion-constraint-rule-175-->

   <!--RULE -->
   <xsl:template match="mei:section[mei:expansion]" priority="1000" mode="M161">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="mei:section[mei:expansion]"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="descendant::mei:section|descendant::mei:ending|descendant::mei:rdg"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="descendant::mei:section|descendant::mei:ending|descendant::mei:rdg">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>A
            section containing an expansion element must have descendant section, ending, or rdg
            elements.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M161"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M161"/>
   <xsl:template match="@*|node()" priority="-2" mode="M161">
      <xsl:apply-templates select="*" mode="M161"/>
   </xsl:template>
   <!--PATTERN mei-graphicanalysis-staff-checkStaff_n-constraint-rule-176-->

   <!--RULE -->
   <xsl:template match="mei:staff[@n]" priority="1000" mode="M162">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="mei:staff[@n]"/>
      <xsl:variable name="thisstaff" select="@n"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="preceding::mei:staffDef[@n=$thisstaff] or preceding::mei:staff[@n=$thisstaff]/mei:staffDef or mei:staffDef"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="preceding::mei:staffDef[@n=$thisstaff] or preceding::mei:staff[@n=$thisstaff]/mei:staffDef or mei:staffDef">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>There must be a preceding staffDef with a matching value of @n, a preceding staff with
            a matching @n value containing a staffDef, or a staffDef child element.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M162"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M162"/>
   <xsl:template match="@*|node()" priority="-2" mode="M162">
      <xsl:apply-templates select="*" mode="M162"/>
   </xsl:template>
   <!--PATTERN mei-graphicanalysis-staffDef-Check_staffDefn-constraint-rule-177-->

   <!--RULE -->
   <xsl:template match="mei:staffDef[not(ancestor::mei:staff)]"
                 priority="1000"
                 mode="M163">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="mei:staffDef[not(ancestor::mei:staff)]"/>
      <xsl:variable name="thisstaff" select="@n"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="@n"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="@n">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>StaffDef must have an n attribute.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="@lines or preceding::mei:staffDef[@n=$thisstaff and @lines]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="@lines or preceding::mei:staffDef[@n=$thisstaff and @lines]">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> Either
            @lines must be present or a preceding staffDef with the same value for @n and @lines
            must exist.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(mei:clef) + count(mei:clefGrp) &lt; 2"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="count(mei:clef) + count(mei:clefGrp) &lt; 2">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Only one clef or clefGrp is
            permitted.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M163"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M163"/>
   <xsl:template match="@*|node()" priority="-2" mode="M163">
      <xsl:apply-templates select="*" mode="M163"/>
   </xsl:template>
   <!--PATTERN mei-graphicanalysis-staffDef-Check_ancestor_staff-constraint-rule-178-->

   <!--RULE -->
   <xsl:template match="mei:staffDef[ancestor::mei:staff and @n]"
                 priority="1000"
                 mode="M164">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="mei:staffDef[ancestor::mei:staff and @n]"/>
      <xsl:variable name="thisstaff" select="@n"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="ancestor::mei:staff/@n eq $thisstaff"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="ancestor::mei:staff/@n eq $thisstaff">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>@n must have the same value as the
            current staff.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M164"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M164"/>
   <xsl:template match="@*|node()" priority="-2" mode="M164">
      <xsl:apply-templates select="*" mode="M164"/>
   </xsl:template>
   <!--PATTERN mei-graphicanalysis-staffDef-Check_ancestor_staff_lines-constraint-rule-179-->

   <!--RULE -->
   <xsl:template match="mei:staffDef[ancestor::mei:staff and not(@n)]"
                 priority="1000"
                 mode="M165">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="mei:staffDef[ancestor::mei:staff and not(@n)]"/>
      <xsl:variable name="thisstaff" select="ancestor::mei:staff/@n"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="@lines or preceding::mei:staffDef[@n=$thisstaff and @lines]"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="@lines or preceding::mei:staffDef[@n=$thisstaff and @lines]">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text> Either
            @lines must be present or a preceding staffDef with matching @n value and @lines must
            exist.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M165"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M165"/>
   <xsl:template match="@*|node()" priority="-2" mode="M165">
      <xsl:apply-templates select="*" mode="M165"/>
   </xsl:template>
   <!--PATTERN mei-graphicanalysis-staffDef-Check_clef_position_staffDef-constraint-rule-180-->

   <!--RULE -->
   <xsl:template match="mei:staffDef[@clef.line and @lines]"
                 priority="1000"
                 mode="M166">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="mei:staffDef[@clef.line and @lines]"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="number(@clef.line) &lt;= number(@lines)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="number(@clef.line) &lt;= number(@lines)">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>The clef position must be less
            than or equal to the number of lines on the staff.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M166"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M166"/>
   <xsl:template match="@*|node()" priority="-2" mode="M166">
      <xsl:apply-templates select="*" mode="M166"/>
   </xsl:template>
   <!--PATTERN mei-graphicanalysis-staffDef-Check_clef_position_staffDef_nolines-constraint-rule-181-->

   <!--RULE -->
   <xsl:template match="mei:staffDef[@clef.line and not(@lines)]"
                 priority="1000"
                 mode="M167">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="mei:staffDef[@clef.line and not(@lines)]"/>
      <xsl:variable name="thisstaff" select="@n"/>
      <xsl:variable name="stafflines"
                    select="preceding::mei:staffDef[@n=$thisstaff and @lines][1]/@lines"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="number(@clef.line) &lt;= number($stafflines)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="number(@clef.line) &lt;= number($stafflines)">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>The clef position must be
            less than or equal to the number of lines on the staff.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M167"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M167"/>
   <xsl:template match="@*|node()" priority="-2" mode="M167">
      <xsl:apply-templates select="*" mode="M167"/>
   </xsl:template>
   <!--PATTERN mei-graphicanalysis-staffDef-Check_tab_strings_lines-constraint-rule-182-->

   <!--RULE -->
   <xsl:template match="mei:staffDef[@tab.strings and @lines]"
                 priority="1000"
                 mode="M168">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="mei:staffDef[@tab.strings and @lines]"/>
      <xsl:variable name="countTokens"
                    select="count(tokenize(normalize-space(@tab.strings), '\s'))"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="$countTokens = @lines"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="$countTokens = @lines">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>The tab.strings attribute must have the same
            number of values as there are staff lines.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M168"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M168"/>
   <xsl:template match="@*|node()" priority="-2" mode="M168">
      <xsl:apply-templates select="*" mode="M168"/>
   </xsl:template>
   <!--PATTERN mei-graphicanalysis-staffDef-Check_tab_strings_nolines-constraint-rule-183-->

   <!--RULE -->
   <xsl:template match="mei:staffDef[@tab.strings and not(@lines)]"
                 priority="1000"
                 mode="M169">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="mei:staffDef[@tab.strings and not(@lines)]"/>
      <xsl:variable name="countTokens"
                    select="count(tokenize(normalize-space(@tab.strings), '\s'))"/>
      <xsl:variable name="thisstaff" select="@n"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="$countTokens = preceding::mei:staffDef[@n=$thisstaff and @lines][1]/@lines"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="$countTokens = preceding::mei:staffDef[@n=$thisstaff and @lines][1]/@lines">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>The
            tab.strings attribute must have the same number of values as there are staff
            lines.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M169"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M169"/>
   <xsl:template match="@*|node()" priority="-2" mode="M169">
      <xsl:apply-templates select="*" mode="M169"/>
   </xsl:template>
   <!--PATTERN -->

   <!--RULE -->
   <xsl:template match="mei:staffDef[@lines.color and @lines]"
                 priority="1001"
                 mode="M170">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="mei:staffDef[@lines.color and @lines]"/>
      <xsl:variable name="countTokens"
                    select="count(tokenize(normalize-space(@lines.color), '\s'))"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="$countTokens = 1 or $countTokens = @lines"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="$countTokens = 1 or $countTokens = @lines">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>The lines.color attribute
              must have either 1) a single value or 2) the same number of values as there are staff
              lines.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M170"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="mei:staffDef[@lines.color and not(@lines)]"
                 priority="1000"
                 mode="M170">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="mei:staffDef[@lines.color and not(@lines)]"/>
      <xsl:variable name="countTokens"
                    select="count(tokenize(normalize-space(@lines.color), '\s'))"/>
      <xsl:variable name="thisstaff" select="@n"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="$countTokens = 1 or $countTokens = preceding::mei:staffDef[@n=$thisstaff and @lines][1]/@lines"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="$countTokens = 1 or $countTokens = preceding::mei:staffDef[@n=$thisstaff and @lines][1]/@lines">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>The lines.color attribute must have either 1) a single value or 2) the same number of
              values as there are staff lines.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M170"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M170"/>
   <xsl:template match="@*|node()" priority="-2" mode="M170">
      <xsl:apply-templates select="*" mode="M170"/>
   </xsl:template>
   <!--PATTERN -->

   <!--RULE -->
   <xsl:template match="mei:staffDef[@ppq][ancestor::mei:scoreDef[@ppq]]"
                 priority="1000"
                 mode="M171">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="mei:staffDef[@ppq][ancestor::mei:scoreDef[@ppq]]"/>
      <xsl:variable name="staffPPQ" select="@ppq"/>
      <xsl:variable name="scorePPQ" select="ancestor::mei:scoreDef[@ppq][1]/@ppq"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="($scorePPQ mod $staffPPQ) = 0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="($scorePPQ mod $staffPPQ) = 0">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>The value of ppq must be a factor of
              the value of ppq on an ancestor scoreDef.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M171"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M171"/>
   <xsl:template match="@*|node()" priority="-2" mode="M171">
      <xsl:apply-templates select="*" mode="M171"/>
   </xsl:template>
   <!--PATTERN -->

   <!--RULE -->
   <xsl:template match="mei:staffDef[@ppq][preceding::mei:scoreDef[@ppq]]"
                 priority="1000"
                 mode="M172">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="mei:staffDef[@ppq][preceding::mei:scoreDef[@ppq]]"/>
      <xsl:variable name="staffPPQ" select="@ppq"/>
      <xsl:variable name="scorePPQ" select="preceding::mei:scoreDef[@ppq][1]/@ppq"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="($scorePPQ mod $staffPPQ) = 0"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="($scorePPQ mod $staffPPQ) = 0">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>The value of ppq must be a factor of
              the value of ppq on a preceding scoreDef.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M172"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M172"/>
   <xsl:template match="@*|node()" priority="-2" mode="M172">
      <xsl:apply-templates select="*" mode="M172"/>
   </xsl:template>
   <!--PATTERN mei-graphicanalysis-staffGrp-Check_staffGrp_unique_staff_n_values-constraint-rule-188-->

   <!--RULE -->
   <xsl:template match="mei:staffGrp" priority="1000" mode="M173">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="mei:staffGrp"/>
      <xsl:variable name="countstaves" select="count(descendant::mei:staffDef)"/>
      <xsl:variable name="countuniqstaves"
                    select="count(distinct-values(descendant::mei:staffDef/@n))"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="$countstaves eq $countuniqstaves"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="$countstaves eq $countuniqstaves">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Each staffDef must have a unique value
            for the n attribute.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M173"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M173"/>
   <xsl:template match="@*|node()" priority="-2" mode="M173">
      <xsl:apply-templates select="*" mode="M173"/>
   </xsl:template>
   <!--PATTERN mei-graphicanalysis-symbol-symbolDef_symbol_attributes_required-constraint-rule-189-->

   <!--RULE -->
   <xsl:template match="mei:symbol[ancestor::mei:symbolDef]"
                 priority="1000"
                 mode="M174">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="mei:symbol[ancestor::mei:symbolDef]"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="@startid or (@x and @y)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="@startid or (@x and @y)">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>In the symbolDef context, symbol must have
            either a startid attribute or x and y attributes.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="@altsym or @glyph.name or @glyph.num"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="@altsym or @glyph.name or @glyph.num">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>In the symbolDef context, symbol
            must have one of the following attributes: altsym, glyph.name, or
            glyph.num.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M174"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M174"/>
   <xsl:template match="@*|node()" priority="-2" mode="M174">
      <xsl:apply-templates select="*" mode="M174"/>
   </xsl:template>
   <!--PATTERN mei-graphicanalysis-tempo-tempo_in_header_disallow_most_attrs-constraint-rule-190-->

   <!--RULE -->
   <xsl:template match="mei:tempo[not(ancestor::mei:score or ancestor::mei:part)]"
                 priority="1000"
                 mode="M175">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="mei:tempo[not(ancestor::mei:score or ancestor::mei:part)]"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(@*[name() != 'analog' and name() != 'class' and name() != 'label' and name() != 'mm' and name() != 'mm.dots' and name() != 'translit' and name() != 'type' and name() != 'mm.unit' and name() != 'n' and name() != 'xml:base' and name() != 'xml:id' and name() != 'xml:lang'])"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not(@*[name() != 'analog' and name() != 'class' and name() != 'label' and name() != 'mm' and name() != 'mm.dots' and name() != 'translit' and name() != 'type' and name() != 'mm.unit' and name() != 'n' and name() != 'xml:base' and name() != 'xml:id' and name() != 'xml:lang'])">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Only analog, class, label, mm, mm.dots, mm.unit, n, translit, type, xml:base, xml:id,
            and xml:lang attributes are allowed when tempo is not a descendant of a score or
            part.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M175"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M175"/>
   <xsl:template match="@*|node()" priority="-2" mode="M175">
      <xsl:apply-templates select="*" mode="M175"/>
   </xsl:template>
   <!--PATTERN mei-graphicanalysis-tempo-tempo_start-type_attributes_required-constraint-rule-191-->

   <!--RULE -->
   <xsl:template match="mei:tempo[not(ancestor::mei:syllable) and not(ancestor::mei:work) and not(ancestor::mei:expression) and not(count(ancestor::mei:*) = 0)]"
                 priority="1000"
                 mode="M176">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="mei:tempo[not(ancestor::mei:syllable) and not(ancestor::mei:work) and not(ancestor::mei:expression) and not(count(ancestor::mei:*) = 0)]"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="@startid or @tstamp or @tstamp.ges or @tstamp.real"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="@startid or @tstamp or @tstamp.ges or @tstamp.real">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>Must have one of the
            attributes: startid, tstamp, tstamp.ges or tstamp.real.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M176"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M176"/>
   <xsl:template match="@*|node()" priority="-2" mode="M176">
      <xsl:apply-templates select="*" mode="M176"/>
   </xsl:template>
   <!--PATTERN mei-graphicanalysis-term-Check_term_dataTarget-constraint-rule-192-->

   <!--RULE -->
   <xsl:template match="mei:term[@data]" priority="1000" mode="M177">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="mei:term[@data]"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="ancestor::mei:classification"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="ancestor::mei:classification">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>The @data attribute may only occur on a
            term which is a descendant of a classification element.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M177"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M177"/>
   <xsl:template match="@*|node()" priority="-2" mode="M177">
      <xsl:apply-templates select="*" mode="M177"/>
   </xsl:template>
   <!--PATTERN mei-graphicanalysis-tabGrp-check_tabGrp_in_beam-constraint-rule-193-->

   <!--RULE -->
   <xsl:template match="mei:tabGrp[ancestor::mei:beam]" priority="1000" mode="M178">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="mei:tabGrp[ancestor::mei:beam]"/>
      <!--ASSERT warning-->
      <xsl:choose>
         <xsl:when test="count(mei:tabDurSym) = 1"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="count(mei:tabDurSym) = 1">
               <xsl:attribute name="role">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>A tabGrp inside of a beam must contain one tabDurSym.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M178"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M178"/>
   <xsl:template match="@*|node()" priority="-2" mode="M178">
      <xsl:apply-templates select="*" mode="M178"/>
   </xsl:template>
   <!--PATTERN mei-graphicanalysis-list-list_type_constraint-constraint-rule-194-->

   <!--RULE -->
   <xsl:template match="mei:list[contains(@type,'gloss')]"
                 priority="1000"
                 mode="M179">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="mei:list[contains(@type,'gloss')]"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(mei:label) = count(mei:li)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="count(mei:label) = count(mei:li)">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>In a list of type "gloss" all items
            must be immediately preceded by a label.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M179"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M179"/>
   <xsl:template match="@*|node()" priority="-2" mode="M179">
      <xsl:apply-templates select="*" mode="M179"/>
   </xsl:template>
   <!--PATTERN mei-graphicanalysis-att.altSym-altsym-check_altsymTarget-constraint-rule-195-->

   <!--RULE -->
   <xsl:template match="@altsym" priority="1000" mode="M180">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="@altsym"/>
      <!--ASSERT warning-->
      <xsl:choose>
         <xsl:when test="not(normalize-space(.) eq '')"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not(normalize-space(.) eq '')">
               <xsl:attribute name="role">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>@altsym attribute
                should have content.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT warning-->
      <xsl:choose>
         <xsl:when test="every $i in tokenize(., '\s+') satisfies substring($i,2)=//mei:symbolDef/@xml:id"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="every $i in tokenize(., '\s+') satisfies substring($i,2)=//mei:symbolDef/@xml:id">
               <xsl:attribute name="role">warning</xsl:attribute>
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>The value in @altsym should correspond to the @xml:id attribute of a symbolDef
                element.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(substring(., 2) eq ancestor::mei:symbolDef/@xml:id)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="not(substring(., 2) eq ancestor::mei:symbolDef/@xml:id)">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>The value
                in @altsym must not correspond to the @xml:id attribute of a symbolDef
                ancestor.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M180"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M180"/>
   <xsl:template match="@*|node()" priority="-2" mode="M180">
      <xsl:apply-templates select="*" mode="M180"/>
   </xsl:template>
   <!--PATTERN mei-graphicanalysis-curve-symbolDef_curve_attributes_required-constraint-rule-196-->

   <!--RULE -->
   <xsl:template match="mei:curve[ancestor::mei:symbolDef]"
                 priority="1000"
                 mode="M181">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="mei:curve[ancestor::mei:symbolDef]"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="@startid or (@x and @y)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="@startid or (@x and @y)">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>In the symbolDef context, curve must have
            either a startid attribute or x and y attributes.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="@endid or (@x2 and @y2)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="@endid or (@x2 and @y2)">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>In the symbolDef context, curve must have
            either an endid attribute or both x2 and y2 attributes.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="@bezier or @bulge"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="@bezier or @bulge">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>In the symbolDef context, curve must have either a
            bezier or bulge attribute.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M181"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M181"/>
   <xsl:template match="@*|node()" priority="-2" mode="M181">
      <xsl:apply-templates select="*" mode="M181"/>
   </xsl:template>
   <!--PATTERN mei-graphicanalysis-line-line_start-_and_end-type_attributes_required-constraint-rule-197-->

   <!--RULE -->
   <xsl:template match="mei:line[ancestor::mei:symbolDef]"
                 priority="1001"
                 mode="M182">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="mei:line[ancestor::mei:symbolDef]"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="@startid or (@x and @y)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="@startid or (@x and @y)">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>When used in the symbolDef context, must have
            either a startid attribute or x and y attributes.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="@endid or (@x2 and @y2)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="@endid or (@x2 and @y2)">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>When used in the symbolDef context, must have
            either an endid attribute or both x2 and y2 attributes.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M182"/>
   </xsl:template>
   <!--RULE -->
   <xsl:template match="mei:line[not(ancestor::mei:symbolDef)]"
                 priority="1000"
                 mode="M182">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="mei:line[not(ancestor::mei:symbolDef)]"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="@startid or @tstamp or @tstamp.ges or @tstamp.real or (@x and @y)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="@startid or @tstamp or @tstamp.ges or @tstamp.real or (@x and @y)">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>When
            used in the score context, must have a startid, tstamp, tstamp.ges or tstamp.real
            attribute or both x and y attributes.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="@dur or @dur.ges or @endid or @tstamp2 or (@x2 and @y2)"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                                test="@dur or @dur.ges or @endid or @tstamp2 or (@x2 and @y2)">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>When used in
            the score context, must have an endid, dur, dur.ges, or tstamp2 attribute or both x2 and
            y2 attributes.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M182"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M182"/>
   <xsl:template match="@*|node()" priority="-2" mode="M182">
      <xsl:apply-templates select="*" mode="M182"/>
   </xsl:template>
   <!--PATTERN mei-graphicanalysis-att.fTrem.vis-beams.float-check_beams.floating-constraint-rule-199-->

   <!--RULE -->
   <xsl:template match="mei:fTrem[@beams and @beams.float]"
                 priority="1000"
                 mode="M183">
      <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                       context="mei:fTrem[@beams and @beams.float]"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="@beams.float &lt;= @beams"/>
         <xsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="@beams.float &lt;= @beams">
               <xsl:attribute name="location">
                  <xsl:apply-templates select="." mode="schematron-select-full-path"/>
               </xsl:attribute>
               <svrl:text>The number of floating beams must be less
                than or equal to the total number of beams.</svrl:text>
            </svrl:failed-assert>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M183"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M183"/>
   <xsl:template match="@*|node()" priority="-2" mode="M183">
      <xsl:apply-templates select="*" mode="M183"/>
   </xsl:template>
</xsl:stylesheet>
