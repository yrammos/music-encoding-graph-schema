<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<sch:schema xmlns:rng="http://relaxng.org/ns/structure/1.0"
            xmlns:sch="http://purl.oclc.org/dsdl/schematron"
            queryBinding="xslt2">
   <sch:ns xmlns="http://relaxng.org/ns/structure/1.0"
           xmlns:tei="http://www.tei-c.org/ns/1.0"
           xmlns:teix="http://www.tei-c.org/ns/Examples"
           xmlns:xlink="http://www.w3.org/1999/xlink"
           prefix="tei"
           uri="http://www.tei-c.org/ns/1.0"/>
   <sch:ns xmlns="http://www.tei-c.org/ns/1.0"
           xmlns:tei="http://www.tei-c.org/ns/1.0"
           xmlns:teix="http://www.tei-c.org/ns/Examples"
           xmlns:xi="http://www.w3.org/2001/XInclude"
           xmlns:xlink="http://www.w3.org/1999/xlink"
           prefix="mei"
           uri="http://www.music-encoding.org/ns/mei"/>
   <sch:ns xmlns="http://www.tei-c.org/ns/1.0"
           xmlns:tei="http://www.tei-c.org/ns/1.0"
           xmlns:teix="http://www.tei-c.org/ns/Examples"
           xmlns:xi="http://www.w3.org/2001/XInclude"
           xmlns:xlink="http://www.w3.org/1999/xlink"
           prefix="xlink"
           uri="http://www.w3.org/1999/xlink"/>
   <pattern xmlns="http://purl.oclc.org/dsdl/schematron"
            xmlns:tei="http://www.tei-c.org/ns/1.0"
            xmlns:teix="http://www.tei-c.org/ns/Examples"
            xmlns:xlink="http://www.w3.org/1999/xlink"
            id="mei-graphicanalysis-att.notationType-notationsubtype-When_notationsubtype-constraint-rule-5">
      <sch:rule xmlns="http://www.tei-c.org/ns/1.0"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                context="mei:*[@notationsubtype]">
         <sch:assert test="@notationtype">An element with a notationsubtype attribute must have
                a notationtype attribute.</sch:assert>
      </sch:rule>
   </pattern>
   <pattern xmlns="http://purl.oclc.org/dsdl/schematron"
            xmlns:tei="http://www.tei-c.org/ns/1.0"
            xmlns:teix="http://www.tei-c.org/ns/Examples"
            xmlns:xlink="http://www.w3.org/1999/xlink"
            id="mei-graphicanalysis-att.beamRend-place-check_beam_place-constraint-rule-6">
      <sch:rule xmlns="http://www.tei-c.org/ns/1.0"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                context="mei:beam[@place eq 'mixed' and not(descendant::mei:*[local-name() eq 'note' or local-name() eq 'chord'][@staff != ./@staff] or descendant::mei:*[local-name() eq 'note' or local-name() eq 'chord'][@staff != ancestor::mei:staff/@n])]">
         <sch:assert test="count(descendant::mei:*[local-name() eq 'note' or local-name() eq 'chord'][@stem.dir]) = count(descendant::mei:*[local-name() eq 'note' or local-name() eq 'chord'])"
                     role="warning">Stem directions should be specified for all notes and chords under the
                beam.</sch:assert>
         <sch:assert test="count(distinct-values(descendant::mei:*[local-name() eq 'note' or local-name() eq 'chord']/@stem.dir)) != 1">Opposing stem directions are required for a beam with @place="mixed".</sch:assert>
      </sch:rule>
      <sch:rule xmlns="http://www.tei-c.org/ns/1.0"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                context="mei:beam[@place eq 'mixed' and (descendant::mei:*[local-name() eq 'note' or local-name() eq 'chord'][@staff != ./@staff] or descendant::mei:*[local-name() eq 'note' or local-name() eq 'chord'][@staff != ancestor::mei:staff/@n]) and count(descendant::mei:*[local-name() eq 'note' or local-name() eq 'chord']/@stem.dir) = count(descendant::mei:*[local-name() eq 'note' or local-name() eq 'chord'])]">
         <sch:assert test="count(distinct-values(descendant::mei:*[local-name() eq 'note' or local-name() eq 'chord']/@stem.dir)) != 1">Opposing stem directions are required for a beam with @place="mixed".</sch:assert>
      </sch:rule>
   </pattern>
   <pattern xmlns="http://purl.oclc.org/dsdl/schematron"
            xmlns:tei="http://www.tei-c.org/ns/1.0"
            xmlns:teix="http://www.tei-c.org/ns/Examples"
            xmlns:xlink="http://www.w3.org/1999/xlink"
            id="mei-graphicanalysis-attacca-attacca_start-type_attributes_required-constraint-rule-8">
      <sch:rule xmlns="http://www.tei-c.org/ns/1.0"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                context="mei:attacca[not(ancestor::mei:syllable)]">
         <sch:assert test="@startid or @tstamp or @tstamp.ges or @tstamp.real">Must have one of the
            attributes: startid, tstamp, tstamp.ges or tstamp.real.</sch:assert>
      </sch:rule>
   </pattern>
   <pattern xmlns="http://purl.oclc.org/dsdl/schematron"
            xmlns:tei="http://www.tei-c.org/ns/1.0"
            xmlns:teix="http://www.tei-c.org/ns/Examples"
            xmlns:xlink="http://www.w3.org/1999/xlink"
            id="mei-graphicanalysis-beam-When_not_copyof_beam_content-constraint-rule-9">
      <sch:rule xmlns="http://www.tei-c.org/ns/1.0"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                context="mei:beam[not(@copyof or @sameas)]">
         <sch:assert test="count(descendant::*[local-name()='note' or local-name()='rest' or               local-name()='chord' or local-name()='space']) &gt; 1">A beam that contains neither a copyof nor sameas attribute must have at least 2 note, rest, chord, or space
            descendants.</sch:assert>
      </sch:rule>
   </pattern>
   <pattern xmlns="http://purl.oclc.org/dsdl/schematron"
            xmlns:tei="http://www.tei-c.org/ns/1.0"
            xmlns:teix="http://www.tei-c.org/ns/Examples"
            xmlns:xlink="http://www.w3.org/1999/xlink"
            id="mei-graphicanalysis-beamSpan-beamspan_start-_and_end-type_attributes_required-constraint-rule-10">
      <sch:rule xmlns="http://www.tei-c.org/ns/1.0"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                context="mei:beamSpan">
         <sch:assert test="@startid or @tstamp or @tstamp.ges or @tstamp.real">Must have one of the
            attributes: startid, tstamp, tstamp.ges or tstamp.real.</sch:assert>
         <sch:assert test="@dur or @dur.ges or @endid or @tstamp2">Must have one of the attributes:
            dur, dur.ges, endid, or tstamp2.</sch:assert>
      </sch:rule>
   </pattern>
   <pattern xmlns="http://purl.oclc.org/dsdl/schematron"
            xmlns:tei="http://www.tei-c.org/ns/1.0"
            xmlns:teix="http://www.tei-c.org/ns/Examples"
            xmlns:xlink="http://www.w3.org/1999/xlink"
            id="mei-graphicanalysis-bend-bend_start-_and_end-type_attributes_required-constraint-rule-11">
      <sch:rule xmlns="http://www.tei-c.org/ns/1.0"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                context="mei:bend">
         <sch:assert test="@startid or @tstamp or @tstamp.ges or @tstamp.real">Must have one of the
            attributes: startid, tstamp, tstamp.ges or tstamp.real.</sch:assert>
         <sch:assert test="@dur or @dur.ges or @endid or @tstamp2">Must have one of the attributes:
            dur, dur.ges, endid, or tstamp2.</sch:assert>
      </sch:rule>
   </pattern>
   <pattern xmlns="http://purl.oclc.org/dsdl/schematron"
            xmlns:tei="http://www.tei-c.org/ns/1.0"
            xmlns:teix="http://www.tei-c.org/ns/Examples"
            xmlns:xlink="http://www.w3.org/1999/xlink"
            id="mei-graphicanalysis-bracketSpan-bracketSpan_start-_and_end-type_attributes_required-constraint-rule-12">
      <sch:rule xmlns="http://www.tei-c.org/ns/1.0"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                context="mei:bracketSpan">
         <sch:assert test="@startid or @tstamp or @tstamp.ges or @tstamp.real">Must have one of the
            attributes: startid, tstamp, tstamp.ges or tstamp.real.</sch:assert>
         <sch:assert test="@dur or @dur.ges or @endid or @tstamp2">Must have one of the attributes:
            dur, dur.ges, endid, or tstamp2.</sch:assert>
      </sch:rule>
   </pattern>
   <pattern xmlns="http://purl.oclc.org/dsdl/schematron"
            xmlns:tei="http://www.tei-c.org/ns/1.0"
            xmlns:teix="http://www.tei-c.org/ns/Examples"
            xmlns:xlink="http://www.w3.org/1999/xlink"
            id="mei-graphicanalysis-breath-breath_start-type_attributes_required-constraint-rule-13">
      <sch:rule xmlns="http://www.tei-c.org/ns/1.0"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                context="mei:breath">
         <sch:assert test="@startid or @tstamp or @tstamp.ges or @tstamp.real">Must have one of the
            attributes: startid, tstamp, tstamp.ges or tstamp.real.</sch:assert>
      </sch:rule>
   </pattern>
   <pattern xmlns="http://purl.oclc.org/dsdl/schematron"
            xmlns:tei="http://www.tei-c.org/ns/1.0"
            xmlns:teix="http://www.tei-c.org/ns/Examples"
            xmlns:xlink="http://www.w3.org/1999/xlink"
            id="mei-graphicanalysis-fermata-fermata_start-type_attributes_required-constraint-rule-14">
      <sch:rule xmlns="http://www.tei-c.org/ns/1.0"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                context="mei:fermata">
         <sch:assert test="@startid or @tstamp or @tstamp.ges or @tstamp.real">Must have one of the
            attributes: startid, tstamp, tstamp.ges or tstamp.real.</sch:assert>
      </sch:rule>
   </pattern>
   <pattern xmlns="http://purl.oclc.org/dsdl/schematron"
            xmlns:tei="http://www.tei-c.org/ns/1.0"
            xmlns:teix="http://www.tei-c.org/ns/Examples"
            xmlns:xlink="http://www.w3.org/1999/xlink"
            id="mei-graphicanalysis-gliss-gliss_start-_and_end-type_attributes_required-constraint-rule-15">
      <sch:rule xmlns="http://www.tei-c.org/ns/1.0"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                context="mei:gliss">
         <sch:assert test="@startid or @tstamp or @tstamp.ges or @tstamp.real">Must have one of the
            attributes: startid, tstamp, tstamp.ges or tstamp.real.</sch:assert>
         <sch:assert test="@dur or @dur.ges or @endid or @tstamp2">Must have one of the attributes:
            dur, dur.ges, endid, or tstamp2.</sch:assert>
      </sch:rule>
   </pattern>
   <pattern xmlns="http://purl.oclc.org/dsdl/schematron"
            xmlns:tei="http://www.tei-c.org/ns/1.0"
            xmlns:teix="http://www.tei-c.org/ns/Examples"
            xmlns:xlink="http://www.w3.org/1999/xlink"
            id="mei-graphicanalysis-graceGrp-When_not_copyof_graceGrp_content-constraint-rule-16">
      <sch:rule xmlns="http://www.tei-c.org/ns/1.0"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                context="mei:graceGrp[not(@copyof)]">
         <sch:assert test="count(descendant::*[local-name()='note' or local-name()='rest' or               local-name()='chord' or local-name()='space']) &gt; 0">A graceGrp without a copyof attribute must have at least 1 note, rest, chord, or space
            descendants.</sch:assert>
      </sch:rule>
   </pattern>
   <pattern xmlns="http://purl.oclc.org/dsdl/schematron"
            xmlns:tei="http://www.tei-c.org/ns/1.0"
            xmlns:teix="http://www.tei-c.org/ns/Examples"
            xmlns:xlink="http://www.w3.org/1999/xlink"
            id="mei-graphicanalysis-graceGrp-When_graced-constraint-rule-17">
      <sch:rule xmlns="http://www.tei-c.org/ns/1.0"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                context="mei:graceGrp[@grace]">
         <sch:assert test="not(descendant::mei:*[@grace])">The grace attribute is not allowed on
            descendants of a graceGrp with a grace attribute.</sch:assert>
      </sch:rule>
   </pattern>
   <pattern xmlns="http://purl.oclc.org/dsdl/schematron"
            xmlns:tei="http://www.tei-c.org/ns/1.0"
            xmlns:teix="http://www.tei-c.org/ns/Examples"
            xmlns:xlink="http://www.w3.org/1999/xlink"
            id="mei-graphicanalysis-hairpin-hairpin_start-_and_end-type_attributes_required-constraint-rule-18">
      <sch:rule xmlns="http://www.tei-c.org/ns/1.0"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                context="mei:hairpin">
         <sch:assert test="@startid or @tstamp or @tstamp.ges or @tstamp.real">Must have one of the
            attributes: startid, tstamp, tstamp.ges or tstamp.real.</sch:assert>
         <sch:assert test="@dur or @dur.ges or @endid or @tstamp2">Must have one of the attributes:
            dur, dur.ges, endid, or tstamp2.</sch:assert>
      </sch:rule>
   </pattern>
   <pattern xmlns="http://purl.oclc.org/dsdl/schematron"
            xmlns:tei="http://www.tei-c.org/ns/1.0"
            xmlns:teix="http://www.tei-c.org/ns/Examples"
            xmlns:xlink="http://www.w3.org/1999/xlink"
            id="mei-graphicanalysis-harpPedal-harpPedal_start-type_attributes_required-constraint-rule-19">
      <sch:rule xmlns="http://www.tei-c.org/ns/1.0"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                context="mei:harpPedal">
         <sch:assert test="@startid or @tstamp or @tstamp.ges or @tstamp.real">Must have one of the
            attributes: startid, tstamp, tstamp.ges or tstamp.real.</sch:assert>
      </sch:rule>
   </pattern>
   <pattern xmlns="http://purl.oclc.org/dsdl/schematron"
            xmlns:tei="http://www.tei-c.org/ns/1.0"
            xmlns:teix="http://www.tei-c.org/ns/Examples"
            xmlns:xlink="http://www.w3.org/1999/xlink"
            id="mei-graphicanalysis-lv-lv_start-_and_end-type_attributes_required-constraint-rule-20">
      <sch:rule xmlns="http://www.tei-c.org/ns/1.0"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                context="mei:lv">
         <sch:assert test="@startid or @tstamp or @tstamp.ges or @tstamp.real">Must have one of the
            attributes: startid, tstamp, tstamp.ges or tstamp.real.</sch:assert>
      </sch:rule>
   </pattern>
   <pattern xmlns="http://purl.oclc.org/dsdl/schematron"
            xmlns:tei="http://www.tei-c.org/ns/1.0"
            xmlns:teix="http://www.tei-c.org/ns/Examples"
            xmlns:xlink="http://www.w3.org/1999/xlink"
            id="mei-graphicanalysis-lv-lv_containing_curve-constraint-rule-21">
      <sch:rule xmlns="http://www.tei-c.org/ns/1.0"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                context="mei:lv[mei:curve[@bezier or @bulge or @curvedir or @lform or @lwidth or @ho or @startho or @endho or @to or @startto or @endto or @vo or @startvo or              @endvo or @x or @y or @x2 or @y2]]">
         <sch:assert test="not(@bezier or @bulge or @curvedir or @lform or @lwidth or @ho or @startho or @endho or @to or @startto or @endto or @vo or @startvo or @endvo or @x or @y or @x2 or @y2)"
                     role="warning">The visual attributes of the lv element (@bezier, @bulge, @curvedir,
            @lform, @lwidth, @ho, @startho, @endho, @to, @startto, @endto, @vo, @startvo, @endvo,
            @x, @y, @x2, and @y2) will be overridden by visual attributes of the contained curve
            elements.</sch:assert>
      </sch:rule>
   </pattern>
   <pattern xmlns="http://purl.oclc.org/dsdl/schematron"
            xmlns:tei="http://www.tei-c.org/ns/1.0"
            xmlns:teix="http://www.tei-c.org/ns/Examples"
            xmlns:xlink="http://www.w3.org/1999/xlink"
            id="mei-graphicanalysis-octave-octave_start-_and_end-type_attributes_required-constraint-rule-22">
      <sch:rule xmlns="http://www.tei-c.org/ns/1.0"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                context="mei:octave">
         <sch:assert test="@startid or @tstamp or @tstamp.ges or @tstamp.real">Must have one of the
            attributes: startid, tstamp, tstamp.ges or tstamp.real.</sch:assert>
         <sch:assert test="@dur or @dur.ges or @endid or @tstamp2">Must have one of the attributes:
            dur, dur.ges, endid, or tstamp2.</sch:assert>
      </sch:rule>
   </pattern>
   <sch:pattern xmlns="http://www.tei-c.org/ns/1.0"
                xmlns:tei="http://www.tei-c.org/ns/1.0"
                xmlns:teix="http://www.tei-c.org/ns/Examples"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                xmlns:xlink="http://www.w3.org/1999/xlink">
      <sch:rule context="mei:measure/mei:ossia">
         <sch:assert test="count(mei:*) = count(mei:staff)+count(mei:oStaff)">In a measure, ossia
              may only contain staff and oStaff elements.</sch:assert>
      </sch:rule>
      <sch:rule context="mei:staff/mei:ossia">
         <sch:assert test="count(mei:*) = count(mei:layer)+count(mei:oLayer)">In a staff, ossia
              may only contain layer and oLayer elements.</sch:assert>
      </sch:rule>
   </sch:pattern>
   <pattern xmlns="http://purl.oclc.org/dsdl/schematron"
            xmlns:tei="http://www.tei-c.org/ns/1.0"
            xmlns:teix="http://www.tei-c.org/ns/Examples"
            xmlns:xlink="http://www.w3.org/1999/xlink"
            id="mei-graphicanalysis-pedal-pedal_start-type_attributes_required-constraint-rule-25">
      <sch:rule xmlns="http://www.tei-c.org/ns/1.0"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                context="mei:pedal">
         <sch:assert test="@startid or @tstamp or @tstamp.ges or @tstamp.real">Must have one of the
            attributes: startid, tstamp, tstamp.ges or tstamp.real.</sch:assert>
      </sch:rule>
   </pattern>
   <pattern xmlns="http://purl.oclc.org/dsdl/schematron"
            xmlns:tei="http://www.tei-c.org/ns/1.0"
            xmlns:teix="http://www.tei-c.org/ns/Examples"
            xmlns:xlink="http://www.w3.org/1999/xlink"
            id="mei-graphicanalysis-repeatMark-repeatMark_start-type_attributes_required-constraint-rule-26">
      <sch:rule xmlns="http://www.tei-c.org/ns/1.0"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                context="mei:repeatMark">
         <sch:assert test="@startid or @tstamp or @tstamp.ges or @tstamp.real">Must have one of the
            attributes: startid, tstamp, tstamp.ges or tstamp.real.</sch:assert>
      </sch:rule>
   </pattern>
   <pattern xmlns="http://purl.oclc.org/dsdl/schematron"
            xmlns:tei="http://www.tei-c.org/ns/1.0"
            xmlns:teix="http://www.tei-c.org/ns/Examples"
            xmlns:xlink="http://www.w3.org/1999/xlink"
            id="mei-graphicanalysis-repeatMark-repeatMark_with_glyph_has_to_be_empty-constraint-rule-27">
      <sch:rule xmlns="http://www.tei-c.org/ns/1.0"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                context="mei:repeatMark[@glyph.num or @glyph.name]">
         <sch:assert test="not(element()) and not(text())">When @glyph.name or @glyph.num is present, repeatMark must not have content.</sch:assert>
      </sch:rule>
   </pattern>
   <pattern xmlns="http://purl.oclc.org/dsdl/schematron"
            xmlns:tei="http://www.tei-c.org/ns/1.0"
            xmlns:teix="http://www.tei-c.org/ns/Examples"
            xmlns:xlink="http://www.w3.org/1999/xlink"
            id="mei-graphicanalysis-slur-slur_start-_and_end-type_attributes_required-constraint-rule-28">
      <sch:rule xmlns="http://www.tei-c.org/ns/1.0"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                context="mei:slur">
         <sch:assert test="@startid or @tstamp or @tstamp.ges or @tstamp.real">Must have one of the
            attributes: startid, tstamp, tstamp.ges or tstamp.real.</sch:assert>
         <sch:assert test="@dur or @dur.ges or @endid or @tstamp2">Must have one of the attributes:
            dur, dur.ges, endid, or tstamp2.</sch:assert>
      </sch:rule>
   </pattern>
   <pattern xmlns="http://purl.oclc.org/dsdl/schematron"
            xmlns:tei="http://www.tei-c.org/ns/1.0"
            xmlns:teix="http://www.tei-c.org/ns/Examples"
            xmlns:xlink="http://www.w3.org/1999/xlink"
            id="mei-graphicanalysis-slur-slur_containing_curve-constraint-rule-29">
      <sch:rule xmlns="http://www.tei-c.org/ns/1.0"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                context="mei:slur[mei:curve[@bezier or @bulge or @curvedir or @lform or @lwidth or @ho or @startho or @endho or @to or @startto or @endto or @vo or @startvo or @endvo or @x or @y or @x2 or @y2]]">
         <sch:assert test="not(@bezier or @bulge or @curvedir or @lform or @lwidth or @ho or @startho or @endho or @to or @startto or @endto or @vo or @startvo or @endvo or @x or @y or @x2 or @y2)"
                     role="warning">The visual attributes of the slur (@bezier, @bulge, @curvedir, @lform,
            @lwidth, @ho, @startho, @endho, @to, @startto, @endto, @vo, @startvo, @endvo, @x, @y,
            @x2, and @y2) will be overridden by visual attributes of the contained curve
            elements.</sch:assert>
      </sch:rule>
   </pattern>
   <pattern xmlns="http://purl.oclc.org/dsdl/schematron"
            xmlns:tei="http://www.tei-c.org/ns/1.0"
            xmlns:teix="http://www.tei-c.org/ns/Examples"
            xmlns:xlink="http://www.w3.org/1999/xlink"
            id="mei-graphicanalysis-tie-tie_start-_and_end-type_attributes_required-constraint-rule-30">
      <sch:rule xmlns="http://www.tei-c.org/ns/1.0"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                context="mei:tie">
         <sch:assert test="@startid or @tstamp or @tstamp.ges or @tstamp.real">Must have one of the
            attributes: startid, tstamp, tstamp.ges or tstamp.real.</sch:assert>
         <sch:assert test="@dur or @dur.ges or @endid or @tstamp2">Must have one of the attributes:
            dur, dur.ges, endid, or tstamp2.</sch:assert>
      </sch:rule>
   </pattern>
   <pattern xmlns="http://purl.oclc.org/dsdl/schematron"
            xmlns:tei="http://www.tei-c.org/ns/1.0"
            xmlns:teix="http://www.tei-c.org/ns/Examples"
            xmlns:xlink="http://www.w3.org/1999/xlink"
            id="mei-graphicanalysis-tie-tie_containing_curve-constraint-rule-31">
      <sch:rule xmlns="http://www.tei-c.org/ns/1.0"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                context="mei:tie[mei:curve[@bezier or @bulge or @curvedir or @lform or @lwidth or @ho or @startho or @endho or @to or @startto or @endto or @vo or @startvo or @endvo or @x or @y or @x2 or @y2]]">
         <sch:assert test="not(@bezier or @bulge or @curvedir or @lform or @lwidth or @ho or @startho or @endho or @to or @startto or @endto or @vo or @startvo or @endvo or @x or @y or @x2 or @y2)"
                     role="warning">The visual attributes of the tie (@bezier, @bulge, @curvedir, @lform,
            @lwidth, @ho, @startho, @endho, @to, @startto, @endto, @vo, @startvo, @endvo, @x, @y,
            @x2, and @y2) will be overridden by visual attributes of the contained curve
            elements.</sch:assert>
      </sch:rule>
   </pattern>
   <pattern xmlns="http://purl.oclc.org/dsdl/schematron"
            xmlns:tei="http://www.tei-c.org/ns/1.0"
            xmlns:teix="http://www.tei-c.org/ns/Examples"
            xmlns:xlink="http://www.w3.org/1999/xlink"
            id="mei-graphicanalysis-tupletSpan-tupletSpan_start-_and_end-type_attributes_required-constraint-rule-32">
      <sch:rule xmlns="http://www.tei-c.org/ns/1.0"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                context="mei:tupletSpan">
         <sch:assert test="@startid or @tstamp or @tstamp.ges or @tstamp.real">Must have one of the
            attributes: startid, tstamp, tstamp.ges or tstamp.real.</sch:assert>
         <sch:assert test="@dur or @dur.ges or @endid or @tstamp2">Must have one of the attributes:
            dur, dur.ges, endid, or tstamp2.</sch:assert>
      </sch:rule>
   </pattern>
   <pattern xmlns="http://purl.oclc.org/dsdl/schematron"
            xmlns:tei="http://www.tei-c.org/ns/1.0"
            xmlns:teix="http://www.tei-c.org/ns/Examples"
            xmlns:xlink="http://www.w3.org/1999/xlink"
            id="mei-graphicanalysis-mordent-mordent_start-type_attributes_required-constraint-rule-33">
      <sch:rule xmlns="http://www.tei-c.org/ns/1.0"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                context="mei:mordent">
         <sch:assert test="@startid or @tstamp or @tstamp.ges or @tstamp.real">Must have one of the
            attributes: startid, tstamp, tstamp.ges or tstamp.real.</sch:assert>
      </sch:rule>
   </pattern>
   <pattern xmlns="http://purl.oclc.org/dsdl/schematron"
            xmlns:tei="http://www.tei-c.org/ns/1.0"
            xmlns:teix="http://www.tei-c.org/ns/Examples"
            xmlns:xlink="http://www.w3.org/1999/xlink"
            id="mei-graphicanalysis-trill-trill_start-type_attributes_required-constraint-rule-34">
      <sch:rule xmlns="http://www.tei-c.org/ns/1.0"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                context="mei:trill">
         <sch:assert test="@startid or @tstamp or @tstamp.ges or @tstamp.real">Must have one of the
            attributes: startid, tstamp, tstamp.ges or tstamp.real.</sch:assert>
      </sch:rule>
   </pattern>
   <pattern xmlns="http://purl.oclc.org/dsdl/schematron"
            xmlns:tei="http://www.tei-c.org/ns/1.0"
            xmlns:teix="http://www.tei-c.org/ns/Examples"
            xmlns:xlink="http://www.w3.org/1999/xlink"
            id="mei-graphicanalysis-turn-turn_start-type_attributes_required-constraint-rule-35">
      <sch:rule xmlns="http://www.tei-c.org/ns/1.0"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                context="mei:turn">
         <sch:assert test="@startid or @tstamp or @tstamp.ges or @tstamp.real">Must have one of the
            attributes: startid, tstamp, tstamp.ges or tstamp.real.</sch:assert>
      </sch:rule>
   </pattern>
   <pattern xmlns="http://purl.oclc.org/dsdl/schematron"
            xmlns:tei="http://www.tei-c.org/ns/1.0"
            xmlns:teix="http://www.tei-c.org/ns/Examples"
            xmlns:xlink="http://www.w3.org/1999/xlink"
            id="mei-graphicanalysis-sp-sp_start-type_attributes_required-constraint-rule-36">
      <sch:rule xmlns="http://www.tei-c.org/ns/1.0"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                context="mei:sp[ancestor::mei:layer or ancestor::mei:measure or ancestor::mei:staff][not(ancestor::mei:sp)]">
         <sch:assert test="@startid or @tstamp or @tstamp.ges or @tstamp.real">Must have one of the
            attributes: startid, tstamp, tstamp.ges or tstamp.real.</sch:assert>
      </sch:rule>
   </pattern>
   <pattern xmlns="http://purl.oclc.org/dsdl/schematron"
            xmlns:tei="http://www.tei-c.org/ns/1.0"
            xmlns:teix="http://www.tei-c.org/ns/Examples"
            xmlns:xlink="http://www.w3.org/1999/xlink"
            id="mei-graphicanalysis-sp-sp_start-type_attributes_forbidden-constraint-rule-37">
      <sch:rule xmlns="http://www.tei-c.org/ns/1.0"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                context="mei:sp[not(ancestor::mei:layer or ancestor::mei:measure or ancestor::mei:staff)]">
         <sch:assert test="not(@startid or @endid or @tstamp or @tstamp2 or @tstamp.ges or @tstamp.real or                @startho or @endho or @to or @startto or @endto or @staff or @layer or @place or @plist)">Must not have any of the attributes: startid, endid, tstamp, tstamp2, tstamp.ges,
            tstamp.real, startho, endho, to, startto, endto, staff, layer, place, or
            plist.</sch:assert>
      </sch:rule>
   </pattern>
   <pattern xmlns="http://purl.oclc.org/dsdl/schematron"
            xmlns:tei="http://www.tei-c.org/ns/1.0"
            xmlns:teix="http://www.tei-c.org/ns/Examples"
            xmlns:xlink="http://www.w3.org/1999/xlink"
            id="mei-graphicanalysis-stageDir-stageDir_start-type_attributes_required-constraint-rule-38">
      <sch:rule xmlns="http://www.tei-c.org/ns/1.0"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                context="mei:stageDir[ancestor::mei:layer or ancestor::mei:measure or ancestor::mei:staff][not(ancestor::mei:sp)]">
         <sch:assert test="@startid or @tstamp or @tstamp.ges or @tstamp.real">Must have one of the
            attributes: startid, tstamp, tstamp.ges or tstamp.real.</sch:assert>
      </sch:rule>
   </pattern>
   <pattern xmlns="http://purl.oclc.org/dsdl/schematron"
            xmlns:tei="http://www.tei-c.org/ns/1.0"
            xmlns:teix="http://www.tei-c.org/ns/Examples"
            xmlns:xlink="http://www.w3.org/1999/xlink"
            id="mei-graphicanalysis-stageDir-stageDir_start-type_attributes_forbidden-constraint-rule-39">
      <sch:rule xmlns="http://www.tei-c.org/ns/1.0"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                context="mei:stageDir[not(ancestor::mei:layer or ancestor::mei:measure or ancestor::mei:staff) or ancestor::mei:sp]">
         <sch:assert test="not(@startid or @endid or @tstamp or @tstamp2 or @tstamp.ges or @tstamp.real or @startho or @endho or @to or                @startto or @endto or @staff or @layer or @place or @plist)">Must not have any of the attributes: startid, endid, tstamp, tstamp2, tstamp.ges,
            tstamp.real, startho, endho, to, startto, endto, staff, layer, place, or
            plist.</sch:assert>
      </sch:rule>
   </pattern>
   <pattern xmlns="http://purl.oclc.org/dsdl/schematron"
            xmlns:tei="http://www.tei-c.org/ns/1.0"
            xmlns:teix="http://www.tei-c.org/ns/Examples"
            xmlns:xlink="http://www.w3.org/1999/xlink"
            id="mei-graphicanalysis-cpMark-cpMark_start-_and_end-type_attributes_required-constraint-rule-40">
      <sch:rule xmlns="http://www.tei-c.org/ns/1.0"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                context="mei:cpMark">
         <sch:assert test="@startid or @tstamp or @tstamp.ges or @tstamp.real">Must have one of the
            attributes: startid, tstamp, tstamp.ges or tstamp.real</sch:assert>
         <sch:assert test="@dur or @dur.ges or @endid or @tstamp2">Must have one of the attributes:
            dur, dur.ges, endid, or tstamp2</sch:assert>
      </sch:rule>
   </pattern>
   <pattern xmlns="http://purl.oclc.org/dsdl/schematron"
            xmlns:tei="http://www.tei-c.org/ns/1.0"
            xmlns:teix="http://www.tei-c.org/ns/Examples"
            xmlns:xlink="http://www.w3.org/1999/xlink"
            id="mei-graphicanalysis-handShift-new-check_newTarget-constraint-rule-41">
      <sch:rule xmlns="http://www.tei-c.org/ns/1.0"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                context="@new">
         <sch:assert role="warning" test="not(normalize-space(.) eq '')">@new attribute should
                have content.</sch:assert>
         <sch:assert role="warning"
                     test="every $i in tokenize(., '\s+') satisfies substring($i,2)=//mei:hand/@xml:id">The value in @new should correspond to the @xml:id attribute of a hand
                element.</sch:assert>
      </sch:rule>
   </pattern>
   <pattern xmlns="http://purl.oclc.org/dsdl/schematron"
            xmlns:tei="http://www.tei-c.org/ns/1.0"
            xmlns:teix="http://www.tei-c.org/ns/Examples"
            xmlns:xlink="http://www.w3.org/1999/xlink"
            id="mei-graphicanalysis-handShift-old-check_oldTarget-constraint-rule-42">
      <sch:rule xmlns="http://www.tei-c.org/ns/1.0"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                context="@old">
         <sch:assert role="warning" test="not(normalize-space(.) eq '')">@old attribute should
                have content.</sch:assert>
         <sch:assert role="warning"
                     test="every $i in tokenize(., '\s+') satisfies substring($i,2)=//mei:hand/@xml:id">The value in @old should correspond to the @xml:id attribute of a hand
                element.</sch:assert>
      </sch:rule>
   </pattern>
   <pattern xmlns="http://purl.oclc.org/dsdl/schematron"
            xmlns:tei="http://www.tei-c.org/ns/1.0"
            xmlns:teix="http://www.tei-c.org/ns/Examples"
            xmlns:xlink="http://www.w3.org/1999/xlink"
            id="mei-graphicanalysis-metaMark-metaMark_start-type_attributes_required-constraint-rule-43">
      <sch:rule xmlns="http://www.tei-c.org/ns/1.0"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                context="mei:metaMark">
         <sch:assert test="@startid or @tstamp or @tstamp.ges or @tstamp.real">Must have one of the
            attributes: startid, tstamp, tstamp.ges or tstamp.real</sch:assert>
      </sch:rule>
   </pattern>
   <pattern xmlns="http://purl.oclc.org/dsdl/schematron"
            xmlns:tei="http://www.tei-c.org/ns/1.0"
            xmlns:teix="http://www.tei-c.org/ns/Examples"
            xmlns:xlink="http://www.w3.org/1999/xlink"
            id="mei-graphicanalysis-att.extSym.names-glyph.name-check_glyph.name-constraint-rule-44">
      <sch:rule xmlns="http://www.tei-c.org/ns/1.0"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                context="@glyph.name">
         <sch:assert role="warning" test="not(normalize-space(.) eq '')">@glyph.name attribute
                should have content.</sch:assert>
      </sch:rule>
   </pattern>
   <pattern xmlns="http://purl.oclc.org/dsdl/schematron"
            xmlns:tei="http://www.tei-c.org/ns/1.0"
            xmlns:teix="http://www.tei-c.org/ns/Examples"
            xmlns:xlink="http://www.w3.org/1999/xlink"
            id="mei-graphicanalysis-att.extSym.names-glyph.num-check_glyph.num-constraint-rule-45">
      <sch:rule xmlns="http://www.tei-c.org/ns/1.0"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                context="mei:*[@glyph.num and (lower-case(@glyph.auth) eq 'smufl' or @glyph.uri eq 'http://www.smufl.org/')]">
         <sch:assert role="warning"
                     test="matches(normalize-space(@glyph.num), '^(#x|U\+)E([0-9AB][0-9A-F][0-9A-F]|C[0-9A][0-9A-F]|CB[0-9A-F])$')">SMuFL version 1.18 uses the range U+E000 - U+ECBF.</sch:assert>
      </sch:rule>
   </pattern>
   <pattern xmlns="http://purl.oclc.org/dsdl/schematron"
            xmlns:tei="http://www.tei-c.org/ns/1.0"
            xmlns:teix="http://www.tei-c.org/ns/Examples"
            xmlns:xlink="http://www.w3.org/1999/xlink"
            id="mei-graphicanalysis-att.facsimile-facs-check_facsTarget-constraint-rule-46">
      <sch:rule xmlns="http://www.tei-c.org/ns/1.0"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                context="@facs">
         <sch:assert role="warning" test="not(normalize-space(.) eq '')">@facs attribute should
                have content.</sch:assert>
         <sch:assert role="warning"
                     test="every $i in tokenize(., '\s+') satisfies substring($i,2)=//mei:*[local-name() eq 'surface' or local-name() eq 'zone']/@xml:id">Each value in @facs should correspond to the @xml:id attribute of a surface or zone
                element.</sch:assert>
      </sch:rule>
   </pattern>
   <pattern xmlns="http://purl.oclc.org/dsdl/schematron"
            xmlns:tei="http://www.tei-c.org/ns/1.0"
            xmlns:teix="http://www.tei-c.org/ns/Examples"
            xmlns:xlink="http://www.w3.org/1999/xlink"
            id="mei-graphicanalysis-graphic-graphic_attributes-constraint-rule-47">
      <sch:rule xmlns="http://www.tei-c.org/ns/1.0"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                context="mei:zone/mei:graphic">
         <sch:assert role="warning" test="count(mei:*) = 0">Graphic child of zone should not have
            children.</sch:assert>
      </sch:rule>
      <sch:rule xmlns="http://www.tei-c.org/ns/1.0"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                context="mei:symbolDef/mei:graphic">
         <sch:assert role="warning" test="@startid or (@ulx and @uly)">Graphic should have either a
            startid attribute or ulx and uly attributes.</sch:assert>
      </sch:rule>
      <sch:rule xmlns="http://www.tei-c.org/ns/1.0"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                context="mei:graphic[not(ancestor::mei:symbolDef or ancestor::mei:zone)]">
         <sch:assert role="warning" test="not(@ulx or @uly)">Graphic should not have @ulx or @uly
            attributes.</sch:assert>
         <sch:assert role="warning" test="not(@ho or @vo)">Graphic should not have @ho or @vo
            attributes.</sch:assert>
      </sch:rule>
   </pattern>
   <pattern xmlns="http://purl.oclc.org/dsdl/schematron"
            xmlns:tei="http://www.tei-c.org/ns/1.0"
            xmlns:teix="http://www.tei-c.org/ns/Examples"
            xmlns:xlink="http://www.w3.org/1999/xlink"
            id="mei-graphicanalysis-fing-fing_start-type_attributes_required-constraint-rule-50">
      <sch:rule xmlns="http://www.tei-c.org/ns/1.0"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                context="mei:fing[not(ancestor::mei:fingGrp)]">
         <sch:assert test="@startid or @tstamp or @tstamp.ges or @tstamp.real">Must have one of the
            attributes: startid, tstamp, tstamp.ges or tstamp.real.</sch:assert>
      </sch:rule>
   </pattern>
   <pattern xmlns="http://purl.oclc.org/dsdl/schematron"
            xmlns:tei="http://www.tei-c.org/ns/1.0"
            xmlns:teix="http://www.tei-c.org/ns/Examples"
            xmlns:xlink="http://www.w3.org/1999/xlink"
            id="mei-graphicanalysis-fing-stack_exclusion-constraint-rule-51">
      <sch:rule xmlns="http://www.tei-c.org/ns/1.0"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                context="mei:fing">
         <sch:assert test="not(descendant::mei:stack)">The stack element is not allowed as a
            descendant of fing.</sch:assert>
      </sch:rule>
   </pattern>
   <pattern xmlns="http://purl.oclc.org/dsdl/schematron"
            xmlns:tei="http://www.tei-c.org/ns/1.0"
            xmlns:teix="http://www.tei-c.org/ns/Examples"
            xmlns:xlink="http://www.w3.org/1999/xlink"
            id="mei-graphicanalysis-fingGrp-require_fingeringLike_children-constraint-rule-52">
      <sch:rule xmlns="http://www.tei-c.org/ns/1.0"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                context="mei:fingGrp">
         <sch:assert test="count(mei:fing) + count(mei:fingGrp) &gt; 1">At least 2 fing or fingGrp
            elements are required.</sch:assert>
      </sch:rule>
   </pattern>
   <sch:pattern xmlns="http://www.tei-c.org/ns/1.0"
                xmlns:tei="http://www.tei-c.org/ns/1.0"
                xmlns:teix="http://www.tei-c.org/ns/Examples"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                xmlns:xlink="http://www.w3.org/1999/xlink">
      <sch:rule context="mei:fingGrp[not(ancestor::mei:fingGrp)][@tstamp or @startid]">
         <sch:assert test="not(child::mei:*[@tstamp or @startid])">When @tstamp or @startid is
              present on fingGrp, its child elements cannot have a @tstamp or @startid
              attribute.</sch:assert>
      </sch:rule>
      <sch:rule context="mei:fingGrp[not(ancestor::mei:fingGrp)][not(@tstamp or @startid)]">
         <sch:assert test="count(descendant::mei:*[@tstamp or @startid]) = count(child::mei:*[local-name()='fing' or local-name()='fingGrp'])">When @tstamp or @startid is not present on fingGrp, each of its child elements must
              have a @tstamp or @startid attribute.</sch:assert>
      </sch:rule>
   </sch:pattern>
   <pattern xmlns="http://purl.oclc.org/dsdl/schematron"
            xmlns:tei="http://www.tei-c.org/ns/1.0"
            xmlns:teix="http://www.tei-c.org/ns/Examples"
            xmlns:xlink="http://www.w3.org/1999/xlink"
            id="mei-graphicanalysis-manifestation-check_singleton-constraint-rule-55">
      <sch:rule xmlns="http://www.tei-c.org/ns/1.0"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                context="mei:manifestation[@singleton eq 'true']">
         <sch:assert test="not(mei:itemList)">Item children are not permitted when @singleton
            equals "true".</sch:assert>
      </sch:rule>
   </pattern>
   <pattern xmlns="http://purl.oclc.org/dsdl/schematron"
            xmlns:tei="http://www.tei-c.org/ns/1.0"
            xmlns:teix="http://www.tei-c.org/ns/Examples"
            xmlns:xlink="http://www.w3.org/1999/xlink"
            id="mei-graphicanalysis-manifestation-check_singleton_availability-constraint-rule-56">
      <sch:rule xmlns="http://www.tei-c.org/ns/1.0"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                context="mei:manifestation[@singleton eq 'false'] | mei:manifestation[not(@singleton)]">
         <sch:assert test="not(mei:availability)">Availability is only permitted when @singleton equals "true".</sch:assert>
      </sch:rule>
   </pattern>
   <pattern xmlns="http://purl.oclc.org/dsdl/schematron"
            xmlns:tei="http://www.tei-c.org/ns/1.0"
            xmlns:teix="http://www.tei-c.org/ns/Examples"
            xmlns:xlink="http://www.w3.org/1999/xlink"
            id="mei-graphicanalysis-att.geneticState-check_changeState.targets-constraint-rule-57">
      <sch:rule xmlns="http://www.tei-c.org/ns/1.0"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                context="@state">
         <sch:assert role="warning" test="not(normalize-space(.) eq '')">@state attribute should
            have content.</sch:assert>
         <sch:assert role="warning"
                     test="every $i in tokenize(., '\s+') satisfies substring($i,2)=//mei:genState/@xml:id">The value in @state should correspond to the @xml:id attribute of a genState (genetic state)
            element.</sch:assert>
      </sch:rule>
   </pattern>
   <pattern xmlns="http://purl.oclc.org/dsdl/schematron"
            xmlns:tei="http://www.tei-c.org/ns/1.0"
            xmlns:teix="http://www.tei-c.org/ns/Examples"
            xmlns:xlink="http://www.w3.org/1999/xlink"
            id="mei-graphicanalysis-att.accidental.ges-accid.ges-check_accid_duplication-constraint-rule-58">
      <sch:rule xmlns="http://www.tei-c.org/ns/1.0"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                context="@accid.ges">
         <sch:assert role="warning" test="not(. eq ../@accid)">The value of @accid.ges should
                not duplicate the value of @accid.</sch:assert>
      </sch:rule>
   </pattern>
   <pattern xmlns="http://purl.oclc.org/dsdl/schematron"
            xmlns:tei="http://www.tei-c.org/ns/1.0"
            xmlns:teix="http://www.tei-c.org/ns/Examples"
            xmlns:xlink="http://www.w3.org/1999/xlink"
            id="mei-graphicanalysis-att.note.ges-extremis_disallows_gestural_pitch-constraint-rule-59">
      <sch:rule xmlns="http://www.tei-c.org/ns/1.0"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                context="mei:note[@extremis]">
         <sch:assert test="not(@pname.ges) and not(@oct.ges)">When the @extremis attribute is used,
            the @pname.ges and @oct.ges attributes are not allowed.</sch:assert>
      </sch:rule>
   </pattern>
   <pattern xmlns="http://purl.oclc.org/dsdl/schematron"
            xmlns:tei="http://www.tei-c.org/ns/1.0"
            xmlns:teix="http://www.tei-c.org/ns/Examples"
            xmlns:xlink="http://www.w3.org/1999/xlink"
            id="mei-graphicanalysis-graph-graph_undirected_not_supported-constraint-rule-60">
      <sch:rule xmlns="http://www.tei-c.org/ns/1.0"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                context="mei:graph[@type='undirected']">
         <sch:assert role="warning" test="false()">Undirected graphs are not yet supported.</sch:assert>
      </sch:rule>
   </pattern>
   <pattern xmlns="http://purl.oclc.org/dsdl/schematron"
            xmlns:tei="http://www.tei-c.org/ns/1.0"
            xmlns:teix="http://www.tei-c.org/ns/Examples"
            xmlns:xlink="http://www.w3.org/1999/xlink"
            id="mei-graphicanalysis-node-node_relation_label-constraint-rule-61">
      <sch:rule xmlns="http://www.tei-c.org/ns/1.0"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                context="mei:node[@type='relation' or @type='metarelation']">
         <sch:assert test="mei:label/@type">A label within a relation or metarelation node must have a @type attribute.</sch:assert>
         <sch:assert test="not(mei:label/*)">A label within a relation or metarelation node must be empty.</sch:assert>
      </sch:rule>
   </pattern>
   <pattern xmlns="http://purl.oclc.org/dsdl/schematron"
            xmlns:tei="http://www.tei-c.org/ns/1.0"
            xmlns:teix="http://www.tei-c.org/ns/Examples"
            xmlns:xlink="http://www.w3.org/1999/xlink"
            id="mei-graphicanalysis-node-node_relation_label_single_token-constraint-rule-62">
      <sch:rule xmlns="http://www.tei-c.org/ns/1.0"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                context="mei:node[@type='relation' or @type='metarelation']">
         <sch:assert test="not(contains(normalize-space(mei:label/@type), ' '))">Within a graph, the @type attribute of a label must be a single token.</sch:assert>
      </sch:rule>
   </pattern>
   <pattern xmlns="http://purl.oclc.org/dsdl/schematron"
            xmlns:tei="http://www.tei-c.org/ns/1.0"
            xmlns:teix="http://www.tei-c.org/ns/Examples"
            xmlns:xlink="http://www.w3.org/1999/xlink"
            id="mei-graphicanalysis-node-node_note_label-constraint-rule-63">
      <sch:rule xmlns="http://www.tei-c.org/ns/1.0"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                context="mei:node[not(@type) or @type='note']">
         <sch:assert test="not(mei:label/@type)">A label within a note node must not have a @type attribute.</sch:assert>
         <sch:assert test="mei:label/mei:note[@corresp]">A label within a note node must contain a note element with a @corresp attribute.</sch:assert>
      </sch:rule>
   </pattern>
   <pattern xmlns="http://purl.oclc.org/dsdl/schematron"
            xmlns:tei="http://www.tei-c.org/ns/1.0"
            xmlns:teix="http://www.tei-c.org/ns/Examples"
            xmlns:xlink="http://www.w3.org/1999/xlink"
            id="mei-graphicanalysis-node-node_note_corresp_only-constraint-rule-64">
      <sch:rule xmlns="http://www.tei-c.org/ns/1.0"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                context="mei:node[not(@type) or @type='note']">
         <sch:assert test="mei:label/mei:note/@corresp">A note inside a label inside a graph must have a @corresp attribute.</sch:assert>
         <sch:assert test="not(mei:label/mei:note/@*[name() != 'corresp'])">A note inside a label inside a graph must have no attributes other than @corresp.</sch:assert>
      </sch:rule>
   </pattern>
   <pattern xmlns="http://purl.oclc.org/dsdl/schematron"
            xmlns:tei="http://www.tei-c.org/ns/1.0"
            xmlns:teix="http://www.tei-c.org/ns/Examples"
            xmlns:xlink="http://www.w3.org/1999/xlink"
            id="mei-graphicanalysis-node-node_note_corresp_target-constraint-rule-65">
      <sch:rule xmlns="http://www.tei-c.org/ns/1.0"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                context="mei:node[not(@type) or @type='note'][mei:label/mei:note/@corresp]">
         <sch:let name="id" value="substring-after(mei:label/mei:note/@corresp, '#')"/>
         <sch:assert test="//mei:score//mei:note[@xml:id = $id]">The @corresp attribute must reference a note element within a score.</sch:assert>
      </sch:rule>
   </pattern>
   <pattern xmlns="http://purl.oclc.org/dsdl/schematron"
            xmlns:tei="http://www.tei-c.org/ns/1.0"
            xmlns:teix="http://www.tei-c.org/ns/Examples"
            xmlns:xlink="http://www.w3.org/1999/xlink"
            id="mei-graphicanalysis-node-node_in_arc-constraint-rule-66">
      <sch:rule xmlns="http://www.tei-c.org/ns/1.0"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                context="mei:node">
         <sch:let name="graph" value="ancestor::mei:graph"/>
         <sch:let name="ref" value="concat('#', @xml:id)"/>
         <sch:assert test="$graph/mei:arc[@from = $ref or @to = $ref]">Node must appear in at least one arc within the same graph.</sch:assert>
      </sch:rule>
   </pattern>
   <pattern xmlns="http://purl.oclc.org/dsdl/schematron"
            xmlns:tei="http://www.tei-c.org/ns/1.0"
            xmlns:teix="http://www.tei-c.org/ns/Examples"
            xmlns:xlink="http://www.w3.org/1999/xlink"
            id="mei-graphicanalysis-arc-arc_targets_exist-constraint-rule-67">
      <sch:rule xmlns="http://www.tei-c.org/ns/1.0"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                context="mei:arc">
         <sch:let name="graph" value="ancestor::mei:graph"/>
         <sch:let name="fromId" value="substring-after(@from, '#')"/>
         <sch:let name="toId" value="substring-after(@to, '#')"/>
         <sch:assert test="$graph/mei:node[@xml:id = $fromId]">@from must reference an existing node in this graph.</sch:assert>
         <sch:assert test="$graph/mei:node[@xml:id = $toId]">@to must reference an existing node in this graph.</sch:assert>
      </sch:rule>
   </pattern>
   <pattern xmlns="http://purl.oclc.org/dsdl/schematron"
            xmlns:tei="http://www.tei-c.org/ns/1.0"
            xmlns:teix="http://www.tei-c.org/ns/Examples"
            xmlns:xlink="http://www.w3.org/1999/xlink"
            id="mei-graphicanalysis-arc-arc_from_type-constraint-rule-68">
      <sch:rule xmlns="http://www.tei-c.org/ns/1.0"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                context="mei:arc">
         <sch:let name="graph" value="ancestor::mei:graph"/>
         <sch:let name="fromId" value="substring-after(@from, '#')"/>
         <sch:assert test="$graph/mei:node[@xml:id = $fromId]/@type = ('relation', 'metarelation')">@from must reference a relation or metarelation node.</sch:assert>
      </sch:rule>
   </pattern>
   <pattern xmlns="http://purl.oclc.org/dsdl/schematron"
            xmlns:tei="http://www.tei-c.org/ns/1.0"
            xmlns:teix="http://www.tei-c.org/ns/Examples"
            xmlns:xlink="http://www.w3.org/1999/xlink"
            id="mei-graphicanalysis-arc-arc_to_type-constraint-rule-69">
      <sch:rule xmlns="http://www.tei-c.org/ns/1.0"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                context="mei:arc">
         <sch:let name="graph" value="ancestor::mei:graph"/>
         <sch:let name="fromId" value="substring-after(@from, '#')"/>
         <sch:let name="toId" value="substring-after(@to, '#')"/>
         <sch:let name="fromType" value="$graph/mei:node[@xml:id = $fromId]/@type"/>
         <sch:assert test="if ($fromType = 'relation') then $graph/mei:node[@xml:id = $toId and (not(@type) or @type = 'note')] else true()">An arc from a relation node must target a note node.</sch:assert>
         <sch:assert test="if ($fromType = 'metarelation') then $graph/mei:node[@xml:id = $toId and @type = ('relation', 'metarelation')] else true()">An arc from a metarelation node must target a relation or metarelation node.</sch:assert>
      </sch:rule>
   </pattern>
   <pattern xmlns="http://purl.oclc.org/dsdl/schematron"
            xmlns:tei="http://www.tei-c.org/ns/1.0"
            xmlns:teix="http://www.tei-c.org/ns/Examples"
            xmlns:xlink="http://www.w3.org/1999/xlink"
            id="mei-graphicanalysis-att.harm.log-chordref-check_chordrefTarget-constraint-rule-70">
      <sch:rule xmlns="http://www.tei-c.org/ns/1.0"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                context="@chordref">
         <sch:assert role="warning" test="not(normalize-space(.) eq '')">@chordref attribute
                should have content.</sch:assert>
         <sch:assert role="warning"
                     test="every $i in tokenize(., '\s+') satisfies substring($i,2)=//mei:chordDef/@xml:id">The value in @chordref should correspond to the @xml:id attribute of a chordDef
                element.</sch:assert>
      </sch:rule>
   </pattern>
   <pattern xmlns="http://purl.oclc.org/dsdl/schematron"
            xmlns:tei="http://www.tei-c.org/ns/1.0"
            xmlns:teix="http://www.tei-c.org/ns/Examples"
            xmlns:xlink="http://www.w3.org/1999/xlink"
            id="mei-graphicanalysis-harm-harm_start-type_attributes_required-constraint-rule-71">
      <sch:rule xmlns="http://www.tei-c.org/ns/1.0"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                context="mei:harm">
         <sch:assert test="@startid or @tstamp or @tstamp.ges or @tstamp.real">Must have one of the
            attributes: startid, tstamp, tstamp.ges or tstamp.real.</sch:assert>
      </sch:rule>
   </pattern>
   <pattern xmlns="http://purl.oclc.org/dsdl/schematron"
            xmlns:tei="http://www.tei-c.org/ns/1.0"
            xmlns:teix="http://www.tei-c.org/ns/Examples"
            xmlns:xlink="http://www.w3.org/1999/xlink"
            id="mei-graphicanalysis-attUsage-context_attribute_requires_content-constraint-rule-72">
      <sch:rule xmlns="http://www.tei-c.org/ns/1.0"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                context="@context">
         <sch:assert role="warning" test="not(normalize-space(.) eq '')">@context attribute should
            contain an XPath expression.</sch:assert>
      </sch:rule>
   </pattern>
   <pattern xmlns="http://purl.oclc.org/dsdl/schematron"
            xmlns:tei="http://www.tei-c.org/ns/1.0"
            xmlns:teix="http://www.tei-c.org/ns/Examples"
            xmlns:xlink="http://www.w3.org/1999/xlink"
            id="mei-graphicanalysis-category-category_id-constraint-rule-73">
      <sch:rule xmlns="http://www.tei-c.org/ns/1.0"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                context="mei:category">
         <sch:assert test="@xml:id" role="warning">To be addressable, the category element must
            have an xml:id attribute.</sch:assert>
      </sch:rule>
   </pattern>
   <pattern xmlns="http://purl.oclc.org/dsdl/schematron"
            xmlns:tei="http://www.tei-c.org/ns/1.0"
            xmlns:teix="http://www.tei-c.org/ns/Examples"
            xmlns:xlink="http://www.w3.org/1999/xlink"
            id="mei-graphicanalysis-change-check_change-constraint-rule-74">
      <sch:rule xmlns="http://www.tei-c.org/ns/1.0"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                context="mei:change">
         <sch:assert test="@isodate or mei:date">The date of the change must be recorded in an
            isodate attribute or date element.</sch:assert>
         <sch:assert test="@resp or mei:respStmt[mei:name or mei:corpName or mei:persName]"
                     role="warning">It is recommended that the agent responsible for the change be recorded
            in a resp attribute or in a name, corpName, or persName element in the respStmt
            element.</sch:assert>
      </sch:rule>
   </pattern>
   <pattern xmlns="http://purl.oclc.org/dsdl/schematron"
            xmlns:tei="http://www.tei-c.org/ns/1.0"
            xmlns:teix="http://www.tei-c.org/ns/Examples"
            xmlns:xlink="http://www.w3.org/1999/xlink"
            id="mei-graphicanalysis-componentList-checkComponentList-constraint-rule-75">
      <sch:rule xmlns="http://www.tei-c.org/ns/1.0"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                context="mei:componentList">
         <sch:assert test="every $i in ./child::mei:*[not(local-name()='head')] satisfies             $i/local-name() eq ./parent::mei:*/local-name()">Only child elements of the same name as the parent of the componentList are
            allowed.</sch:assert>
      </sch:rule>
   </pattern>
   <pattern xmlns="http://purl.oclc.org/dsdl/schematron"
            xmlns:tei="http://www.tei-c.org/ns/1.0"
            xmlns:teix="http://www.tei-c.org/ns/Examples"
            xmlns:xlink="http://www.w3.org/1999/xlink"
            id="mei-graphicanalysis-componentList-checkComponents-constraint-rule-76">
      <sch:rule xmlns="http://www.tei-c.org/ns/1.0"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                context="mei:componentList[mei:*[@comptype]]">
         <sch:assert role="warning"
                     test="count(mei:*[@comptype]) = count(mei:*[local-name() ne 'head'])">When any child
            element has a comptype attribute, it is recommended that comptype appear on all child
            elements.</sch:assert>
      </sch:rule>
   </pattern>
   <pattern xmlns="http://purl.oclc.org/dsdl/schematron"
            xmlns:tei="http://www.tei-c.org/ns/1.0"
            xmlns:teix="http://www.tei-c.org/ns/Examples"
            xmlns:xlink="http://www.w3.org/1999/xlink"
            id="mei-graphicanalysis-contents-checkContentsLabels-constraint-rule-77">
      <sch:rule xmlns="http://www.tei-c.org/ns/1.0"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                context="mei:contents[mei:label]">
         <sch:assert role="warning" test="count(mei:label) = count(mei:contentItem)">When labels
            are used, usually each content item has one.</sch:assert>
      </sch:rule>
   </pattern>
   <pattern xmlns="http://purl.oclc.org/dsdl/schematron"
            xmlns:tei="http://www.tei-c.org/ns/1.0"
            xmlns:teix="http://www.tei-c.org/ns/Examples"
            xmlns:xlink="http://www.w3.org/1999/xlink"
            id="mei-graphicanalysis-handList-checkHandListLabels-constraint-rule-78">
      <sch:rule xmlns="http://www.tei-c.org/ns/1.0"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                context="mei:handList[mei:label]">
         <sch:assert role="warning" test="count(mei:label) = count(mei:hand)">When labels are used,
            usually each hand has one.</sch:assert>
      </sch:rule>
   </pattern>
   <pattern xmlns="http://purl.oclc.org/dsdl/schematron"
            xmlns:tei="http://www.tei-c.org/ns/1.0"
            xmlns:teix="http://www.tei-c.org/ns/Examples"
            xmlns:xlink="http://www.w3.org/1999/xlink"
            id="mei-graphicanalysis-history-history_restriction-constraint-rule-79">
      <sch:rule xmlns="http://www.tei-c.org/ns/1.0"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                context="mei:history[parent::mei:work or parent::mei:expression or parent::mei:manifestation[not(@singleton='true')]]">
         <sch:assert test="not(mei:acquisition or mei:provenance or mei:exhibHist or mei:treatHist or mei:treatSched)">The elements acquisition, provenance, exhibHist, treatHist and treatSched are not permitted at the work or expression level and are only permitted at the manifestation level, if the manifestation is a manifestation singleton.</sch:assert>
      </sch:rule>
   </pattern>
   <pattern xmlns="http://purl.oclc.org/dsdl/schematron"
            xmlns:tei="http://www.tei-c.org/ns/1.0"
            xmlns:teix="http://www.tei-c.org/ns/Examples"
            xmlns:xlink="http://www.w3.org/1999/xlink"
            id="mei-graphicanalysis-incipCode-Check_incipCode_form_mimetype-constraint-rule-80">
      <sch:rule xmlns="http://www.tei-c.org/ns/1.0"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                context="mei:incipCode">
         <sch:assert test="@form or @mimetype">incipCode must have a form or mimetype
            attribute.</sch:assert>
      </sch:rule>
   </pattern>
   <pattern xmlns="http://purl.oclc.org/dsdl/schematron"
            xmlns:tei="http://www.tei-c.org/ns/1.0"
            xmlns:teix="http://www.tei-c.org/ns/Examples"
            xmlns:xlink="http://www.w3.org/1999/xlink"
            id="mei-graphicanalysis-meiHead-check_meiHead_type-constraint-rule-81">
      <sch:rule xmlns="http://www.tei-c.org/ns/1.0"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                context="mei:meiHead[@type eq 'music']">
         <sch:assert test="ancestor::mei:mei">The meiHead type attribute can have the value 'music'
            only when the document element is "mei".</sch:assert>
      </sch:rule>
      <sch:rule xmlns="http://www.tei-c.org/ns/1.0"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                context="mei:meiHead[@type eq 'corpus']">
         <sch:assert test="ancestor::mei:meiCorpus">The meiHead type attribute can have the value
            'corpus' only when the document element is "meiCorpus".</sch:assert>
      </sch:rule>
      <sch:rule xmlns="http://www.tei-c.org/ns/1.0"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                context="mei:meiHead[@type eq 'independent']">
         <sch:assert test="not(ancestor::mei:*)">The meiHead type attribute can have the value
            'independent' only when the document element is "meiHead".</sch:assert>
      </sch:rule>
   </pattern>
   <pattern xmlns="http://purl.oclc.org/dsdl/schematron"
            xmlns:tei="http://www.tei-c.org/ns/1.0"
            xmlns:teix="http://www.tei-c.org/ns/Examples"
            xmlns:xlink="http://www.w3.org/1999/xlink"
            id="mei-graphicanalysis-patch-check_attached_position-constraint-rule-84">
      <sch:rule xmlns="http://www.tei-c.org/ns/1.0"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                context="mei:patch">
         <sch:assert test="(parent::mei:folium and @attached.to = ('recto','verso')) or              (parent::mei:bifolium and @attached.to = ('outer.recto','inner.verso','inner.recto','outer.verso'))">The allowed positions of a patch depend on its parent element.</sch:assert>
         <sch:assert test="count(child::node()) gt 0">A patch element must contain either a folium
            or a bifolium element.</sch:assert>
      </sch:rule>
   </pattern>
   <pattern xmlns="http://purl.oclc.org/dsdl/schematron"
            xmlns:tei="http://www.tei-c.org/ns/1.0"
            xmlns:teix="http://www.tei-c.org/ns/Examples"
            xmlns:xlink="http://www.w3.org/1999/xlink"
            id="mei-graphicanalysis-source-check_source_target-constraint-rule-85">
      <sch:rule xmlns="http://www.tei-c.org/ns/1.0"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                context="mei:source/@target">
         <sch:assert role="warning" test="not(normalize-space(.) eq '')">@target attribute should
            have content.</sch:assert>
         <sch:assert role="warning"
                     test="every $i in tokenize(., '\s+') satisfies substring($i,2)=//mei:*[local-name()              eq 'source' or local-name() eq 'manifestation']/@xml:id or matches($i, '^([a-z]+://|\.{1,2}/)')">Each value in @target should correspond to the @xml:id attribute of a source or
            manifestation element or be an external URI.</sch:assert>
      </sch:rule>
   </pattern>
   <pattern xmlns="http://purl.oclc.org/dsdl/schematron"
            xmlns:tei="http://www.tei-c.org/ns/1.0"
            xmlns:teix="http://www.tei-c.org/ns/Examples"
            xmlns:xlink="http://www.w3.org/1999/xlink"
            id="mei-graphicanalysis-tagUsage-context_attribute_requires_content-constraint-rule-86">
      <sch:rule xmlns="http://www.tei-c.org/ns/1.0"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                context="@context">
         <sch:assert role="warning" test="not(normalize-space(.) eq '')">@context attribute should
            contain an XPath expression.</sch:assert>
      </sch:rule>
   </pattern>
   <pattern xmlns="http://purl.oclc.org/dsdl/schematron"
            xmlns:tei="http://www.tei-c.org/ns/1.0"
            xmlns:teix="http://www.tei-c.org/ns/Examples"
            xmlns:xlink="http://www.w3.org/1999/xlink"
            id="mei-graphicanalysis-termList-checkTermListLabels-constraint-rule-87">
      <sch:rule xmlns="http://www.tei-c.org/ns/1.0"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                context="mei:termList[mei:label]">
         <sch:assert role="warning" test="count(mei:label) = count(mei:term)">When labels are used,
            usually each term has one.</sch:assert>
      </sch:rule>
   </pattern>
   <pattern xmlns="http://purl.oclc.org/dsdl/schematron"
            xmlns:tei="http://www.tei-c.org/ns/1.0"
            xmlns:teix="http://www.tei-c.org/ns/Examples"
            xmlns:xlink="http://www.w3.org/1999/xlink"
            id="mei-graphicanalysis-att.duration.quality-check_duplex_quality-constraint-rule-88">
      <sch:rule xmlns="http://www.tei-c.org/ns/1.0"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                context="(mei:note|mei:space)[@dur.quality='duplex']">
         <sch:assert test="@dur='longa'">
            Duplex quality can only be used with longas (in Ars antiqua).
          </sch:assert>
      </sch:rule>
   </pattern>
   <pattern xmlns="http://purl.oclc.org/dsdl/schematron"
            xmlns:tei="http://www.tei-c.org/ns/1.0"
            xmlns:teix="http://www.tei-c.org/ns/Examples"
            xmlns:xlink="http://www.w3.org/1999/xlink"
            id="mei-graphicanalysis-att.duration.quality-check_maiorminor_quality-constraint-rule-89">
      <sch:rule xmlns="http://www.tei-c.org/ns/1.0"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                context="(mei:note|mei:space)[@dur.quality='maior' or @dur.quality='minor']">
         <sch:assert test="@dur='semibrevis'">
            Maior / minor quality can only be used with semibreves (in Ars antiqua).
          </sch:assert>
      </sch:rule>
   </pattern>
   <pattern xmlns="http://purl.oclc.org/dsdl/schematron"
            xmlns:tei="http://www.tei-c.org/ns/1.0"
            xmlns:teix="http://www.tei-c.org/ns/Examples"
            xmlns:xlink="http://www.w3.org/1999/xlink"
            id="mei-graphicanalysis-att.mensural.shared-mensuration_conflicting_attributes-constraint-rule-90">
      <sch:rule xmlns="http://www.tei-c.org/ns/1.0"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                context="mei:mensur[@divisio]">
         <sch:assert test="not(@tempus) and not(@prolatio)">
            When the @divisio attribute is used, the @tempus and @prolatio attributes are not allowed.
          </sch:assert>
      </sch:rule>
   </pattern>
   <pattern xmlns="http://purl.oclc.org/dsdl/schematron"
            xmlns:tei="http://www.tei-c.org/ns/1.0"
            xmlns:teix="http://www.tei-c.org/ns/Examples"
            xmlns:xlink="http://www.w3.org/1999/xlink"
            id="mei-graphicanalysis-plica-Check_plica-constraint-rule-91">
      <sch:rule xmlns="http://www.tei-c.org/ns/1.0"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                context="mei:plica">
         <sch:assert test="count(../mei:plica) &lt;= 1">Only one plica is allowed.</sch:assert>
      </sch:rule>
   </pattern>
   <pattern xmlns="http://purl.oclc.org/dsdl/schematron"
            xmlns:tei="http://www.tei-c.org/ns/1.0"
            xmlns:teix="http://www.tei-c.org/ns/Examples"
            xmlns:xlink="http://www.w3.org/1999/xlink"
            id="mei-graphicanalysis-stem-Check_stem-constraint-rule-92">
      <sch:rule xmlns="http://www.tei-c.org/ns/1.0"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                context="mei:stem">
         <sch:assert test="not(ancestor::mei:note/@*[starts-with(local-name(),'stem.')])">A note with nested stem elements must not have @stem.* attributes.</sch:assert>
      </sch:rule>
   </pattern>
   <pattern xmlns="http://purl.oclc.org/dsdl/schematron"
            xmlns:tei="http://www.tei-c.org/ns/1.0"
            xmlns:teix="http://www.tei-c.org/ns/Examples"
            xmlns:xlink="http://www.w3.org/1999/xlink"
            id="mei-graphicanalysis-att.instrumentIdent-instr-check_instrTarget-constraint-rule-93">
      <sch:rule xmlns="http://www.tei-c.org/ns/1.0"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                context="@instr">
         <sch:assert role="warning" test="not(normalize-space(.) eq '')">@instr attribute
                should have content.</sch:assert>
         <sch:assert role="warning"
                     test="every $i in tokenize(., '\s+') satisfies substring($i,2)=//mei:instrDef/@xml:id">The value in @instr should correspond to the @xml:id attribute of an instrDef
                element.</sch:assert>
      </sch:rule>
   </pattern>
   <pattern xmlns="http://purl.oclc.org/dsdl/schematron"
            xmlns:tei="http://www.tei-c.org/ns/1.0"
            xmlns:teix="http://www.tei-c.org/ns/Examples"
            xmlns:xlink="http://www.w3.org/1999/xlink"
            id="mei-graphicanalysis-att.midiInstrument-One_of_instrname_or_instrnum-constraint-rule-94">
      <sch:rule xmlns="http://www.tei-c.org/ns/1.0"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                context="mei:*[@midi.instrname]">
         <sch:assert test="not(@midi.instrnum)">Only one of @midi.instrname and @midi.instrnum
            allowed.</sch:assert>
      </sch:rule>
   </pattern>
   <pattern xmlns="http://purl.oclc.org/dsdl/schematron"
            xmlns:tei="http://www.tei-c.org/ns/1.0"
            xmlns:teix="http://www.tei-c.org/ns/Examples"
            xmlns:xlink="http://www.w3.org/1999/xlink"
            id="mei-graphicanalysis-att.midiInstrument-One_of_patchname_or_patchnum-constraint-rule-95">
      <sch:rule xmlns="http://www.tei-c.org/ns/1.0"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                context="mei:*[@midi.patchname]">
         <sch:assert test="not(@midi.patchnum)">Only one of @midi.patchname and @midi.patchnum
            allowed.</sch:assert>
      </sch:rule>
   </pattern>
   <pattern xmlns="http://purl.oclc.org/dsdl/schematron"
            xmlns:tei="http://www.tei-c.org/ns/1.0"
            xmlns:teix="http://www.tei-c.org/ns/Examples"
            xmlns:xlink="http://www.w3.org/1999/xlink"
            id="mei-graphicanalysis-att.componentType-comptype-checkComponentType-constraint-rule-96">
      <sch:rule xmlns="http://www.tei-c.org/ns/1.0"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                context="mei:*[@comptype]">
         <sch:let name="elementName" value="local-name()"/>
         <sch:assert test="ancestor::mei:componentList">The comptype attribute may occur on
                <sch:value-of select="$elementName"/> only when it is a descendant of a
                componentList.</sch:assert>
      </sch:rule>
   </pattern>
   <pattern xmlns="http://purl.oclc.org/dsdl/schematron"
            xmlns:tei="http://www.tei-c.org/ns/1.0"
            xmlns:teix="http://www.tei-c.org/ns/Examples"
            xmlns:xlink="http://www.w3.org/1999/xlink"
            id="mei-graphicanalysis-catchwords-check_catchwords_inline-constraint-rule-97">
      <sch:rule xmlns="http://www.tei-c.org/ns/1.0"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                context="mei:catchwords">
         <sch:assert test="ancestor::mei:physDesc">The catchwords element may only appear as a
            descendant of the physDesc element.</sch:assert>
      </sch:rule>
   </pattern>
   <pattern xmlns="http://purl.oclc.org/dsdl/schematron"
            xmlns:tei="http://www.tei-c.org/ns/1.0"
            xmlns:teix="http://www.tei-c.org/ns/Examples"
            xmlns:xlink="http://www.w3.org/1999/xlink"
            id="mei-graphicanalysis-locusGrp-check_locusGrp_inline-constraint-rule-98">
      <sch:rule xmlns="http://www.tei-c.org/ns/1.0"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                context="mei:locusGrp">
         <sch:assert test="ancestor::mei:physDesc or parent::mei:contentItem or              ancestor::mei:source[ancestor::mei:componentList[ancestor::mei:sourceDesc or              ancestor::mei:sourceList or ancestor::mei:workList]]">The locusGrp element may only appear as a descendant of a physDesc element, a
            contentItem element, or a source element that is a component of another source or
            work.</sch:assert>
      </sch:rule>
   </pattern>
   <pattern xmlns="http://purl.oclc.org/dsdl/schematron"
            xmlns:tei="http://www.tei-c.org/ns/1.0"
            xmlns:teix="http://www.tei-c.org/ns/Examples"
            xmlns:xlink="http://www.w3.org/1999/xlink"
            id="mei-graphicanalysis-secFolio-check_secFolio_inline-constraint-rule-99">
      <sch:rule xmlns="http://www.tei-c.org/ns/1.0"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                context="mei:secFolio">
         <sch:assert test="ancestor::mei:physDesc">The secFolio element may only appear as a
            descendant of the physDesc element.</sch:assert>
      </sch:rule>
   </pattern>
   <pattern xmlns="http://purl.oclc.org/dsdl/schematron"
            xmlns:tei="http://www.tei-c.org/ns/1.0"
            xmlns:teix="http://www.tei-c.org/ns/Examples"
            xmlns:xlink="http://www.w3.org/1999/xlink"
            id="mei-graphicanalysis-signatures-check_signatures_inline-constraint-rule-100">
      <sch:rule xmlns="http://www.tei-c.org/ns/1.0"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                context="mei:signatures">
         <sch:assert test="ancestor::mei:physDesc">The signatures element may only appear as a
            descendant of the physDesc element.</sch:assert>
      </sch:rule>
   </pattern>
   <pattern xmlns="http://purl.oclc.org/dsdl/schematron"
            xmlns:tei="http://www.tei-c.org/ns/1.0"
            xmlns:teix="http://www.tei-c.org/ns/Examples"
            xmlns:xlink="http://www.w3.org/1999/xlink"
            id="mei-graphicanalysis-att.alignment-check_whenTarget-constraint-rule-101">
      <sch:rule xmlns="http://www.tei-c.org/ns/1.0"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                context="@when">
         <sch:assert role="warning" test="not(normalize-space(.) eq '')">@when attribute should
            have content.</sch:assert>
         <sch:assert role="warning"
                     test="every $i in tokenize(., '\s+') satisfies substring($i,2)=//mei:when/@xml:id">A
            value in @when should correspond to the @xml:id attribute of a when
            element.</sch:assert>
      </sch:rule>
   </pattern>
   <pattern xmlns="http://purl.oclc.org/dsdl/schematron"
            xmlns:tei="http://www.tei-c.org/ns/1.0"
            xmlns:teix="http://www.tei-c.org/ns/Examples"
            xmlns:xlink="http://www.w3.org/1999/xlink"
            id="mei-graphicanalysis-avFile-avFile_child_of_clip-constraint-rule-102">
      <sch:rule xmlns="http://www.tei-c.org/ns/1.0"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                context="mei:clip/mei:avFile">
         <sch:assert test="count(mei:*) = 0">An avFile child of clip cannot have
            children.</sch:assert>
      </sch:rule>
   </pattern>
   <pattern xmlns="http://purl.oclc.org/dsdl/schematron"
            xmlns:tei="http://www.tei-c.org/ns/1.0"
            xmlns:teix="http://www.tei-c.org/ns/Examples"
            xmlns:xlink="http://www.w3.org/1999/xlink"
            id="mei-graphicanalysis-clip-betype_required_when_begin_or_end-constraint-rule-103">
      <sch:rule xmlns="http://www.tei-c.org/ns/1.0"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                context="mei:clip[@begin or @end]">
         <sch:assert role="warning" test="@betype or ancestor::mei:*[@betype]">When @begin or @end
            is used, @betype should appear on clip or one of its ancestors.</sch:assert>
      </sch:rule>
   </pattern>
   <pattern xmlns="http://purl.oclc.org/dsdl/schematron"
            xmlns:tei="http://www.tei-c.org/ns/1.0"
            xmlns:teix="http://www.tei-c.org/ns/Examples"
            xmlns:xlink="http://www.w3.org/1999/xlink"
            id="mei-graphicanalysis-recording-betype_required_when_begin_or_end-constraint-rule-104">
      <sch:rule xmlns="http://www.tei-c.org/ns/1.0"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                context="mei:recording[@begin or @end]">
         <sch:assert role="warning" test="@betype">When @begin or @end is used, @betype should be
            present.</sch:assert>
      </sch:rule>
   </pattern>
   <pattern xmlns="http://purl.oclc.org/dsdl/schematron"
            xmlns:tei="http://www.tei-c.org/ns/1.0"
            xmlns:teix="http://www.tei-c.org/ns/Examples"
            xmlns:xlink="http://www.w3.org/1999/xlink"
            id="mei-graphicanalysis-when-check_when_interval-constraint-rule-105">
      <sch:rule xmlns="http://www.tei-c.org/ns/1.0"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                context="mei:when[@interval]">
         <sch:assert test="@since">@since must be present when @interval is used.</sch:assert>
         <sch:assert role="warning"
                     test="every $i in tokenize(@since, '\s+') satisfies substring($i,2)=//mei:when/@xml:id">The value in @since should correspond to the @xml:id attribute of a when
            element.</sch:assert>
      </sch:rule>
      <sch:rule xmlns="http://www.tei-c.org/ns/1.0"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                context="mei:when[matches(@interval, '^[0-9]+$')]">
         <sch:assert test="not(@inttype eq 'time')">When @interval contains an integer value,
            @inttype cannot be 'time'.</sch:assert>
      </sch:rule>
      <sch:rule xmlns="http://www.tei-c.org/ns/1.0"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                context="mei:when[matches(@interval, ':')]">
         <sch:assert test="@inttype eq 'time'">When @interval contains a time value, @inttype must
            be 'time'.</sch:assert>
      </sch:rule>
   </pattern>
   <pattern xmlns="http://purl.oclc.org/dsdl/schematron"
            xmlns:tei="http://www.tei-c.org/ns/1.0"
            xmlns:teix="http://www.tei-c.org/ns/Examples"
            xmlns:xlink="http://www.w3.org/1999/xlink"
            id="mei-graphicanalysis-when-check_when_absolute-constraint-rule-108">
      <sch:rule xmlns="http://www.tei-c.org/ns/1.0"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                context="mei:when[@absolute]">
         <sch:assert role="warning" test="@abstype or ancestor::mei:*[@betype]">When @absolute is
            present, @abstype should be present or @betype should be present on an
            ancestor.</sch:assert>
      </sch:rule>
   </pattern>
   <pattern xmlns="http://purl.oclc.org/dsdl/schematron"
            xmlns:tei="http://www.tei-c.org/ns/1.0"
            xmlns:teix="http://www.tei-c.org/ns/Examples"
            xmlns:xlink="http://www.w3.org/1999/xlink"
            id="mei-graphicanalysis-when-since-check_sinceTarget-constraint-rule-109">
      <sch:rule xmlns="http://www.tei-c.org/ns/1.0"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                context="@since">
         <sch:assert role="warning" test="not(normalize-space(.) eq '')">@since attribute
                should have content.</sch:assert>
         <sch:assert role="warning"
                     test="every $i in tokenize(., '\s+') satisfies substring($i,2)=//mei:when/@xml:id">The value in @since should correspond to the @xml:id attribute of a when
                element.</sch:assert>
      </sch:rule>
   </pattern>
   <pattern xmlns="http://purl.oclc.org/dsdl/schematron"
            xmlns:tei="http://www.tei-c.org/ns/1.0"
            xmlns:teix="http://www.tei-c.org/ns/Examples"
            xmlns:xlink="http://www.w3.org/1999/xlink"
            id="mei-graphicanalysis-att.attacca.log-target-check_attaccaTarget-constraint-rule-110">
      <sch:rule xmlns="http://www.tei-c.org/ns/1.0"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                context="mei:attacca/@target">
         <sch:assert role="warning" test="not(normalize-space(.) eq '')">@target attribute
                should have content.</sch:assert>
         <sch:assert role="warning"
                     test="every $i in tokenize(., '\s+') satisfies substring($i,2)=//mei:*[local-name() eq 'section' or local-name() eq 'mdiv']/@xml:id">The value in @target should correspond to the @xml:id attribute of a section or
                mdiv element.</sch:assert>
      </sch:rule>
   </pattern>
   <pattern xmlns="http://purl.oclc.org/dsdl/schematron"
            xmlns:tei="http://www.tei-c.org/ns/1.0"
            xmlns:teix="http://www.tei-c.org/ns/Examples"
            xmlns:xlink="http://www.w3.org/1999/xlink"
            id="mei-graphicanalysis-att.augmentDots-dots-dots_attribute_requires_dur-constraint-rule-111">
      <sch:rule xmlns="http://www.tei-c.org/ns/1.0"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                context="mei:*[@dots]">
         <sch:assert test="@dur">An element with a dots attribute must also have a dur
                attribute.</sch:assert>
      </sch:rule>
   </pattern>
   <pattern xmlns="http://purl.oclc.org/dsdl/schematron"
            xmlns:tei="http://www.tei-c.org/ns/1.0"
            xmlns:teix="http://www.tei-c.org/ns/Examples"
            xmlns:xlink="http://www.w3.org/1999/xlink"
            id="mei-graphicanalysis-att.barring-bar.method-check_barmethod-constraint-rule-112">
      <sch:rule xmlns="http://www.tei-c.org/ns/1.0"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                context="@bar.method[parent::*[matches(local-name(), '(staffDef|measure)')]]">
         <sch:assert test="not(. eq 'mensur')">"mensur" not allowed in this
                context.</sch:assert>
      </sch:rule>
   </pattern>
   <pattern xmlns="http://purl.oclc.org/dsdl/schematron"
            xmlns:tei="http://www.tei-c.org/ns/1.0"
            xmlns:teix="http://www.tei-c.org/ns/Examples"
            xmlns:xlink="http://www.w3.org/1999/xlink"
            id="mei-graphicanalysis-att.classed-class-check_classURI-constraint-rule-113">
      <sch:rule xmlns="http://www.tei-c.org/ns/1.0"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                context="@class">
         <sch:assert test="every $i in tokenize(., '\s+') satisfies substring($i,2)=//mei:category/@xml:id or matches($i, '^([a-z]+://|\.{1,2}/)')">The value in @class must either correspond to the @xml:id attribute of a category
                element or be an external URL.</sch:assert>
      </sch:rule>
   </pattern>
   <pattern xmlns="http://purl.oclc.org/dsdl/schematron"
            xmlns:tei="http://www.tei-c.org/ns/1.0"
            xmlns:teix="http://www.tei-c.org/ns/Examples"
            xmlns:xlink="http://www.w3.org/1999/xlink"
            id="mei-graphicanalysis-att.cleffing.log-clef_shape_requires_clef_line-constraint-rule-114">
      <sch:rule xmlns="http://www.tei-c.org/ns/1.0"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                context="mei:*[matches(@clef.shape, '[FCG]')]">
         <sch:assert test="@clef.line">An 'F', 'C', or 'G' clef requires that its position be
            specified.</sch:assert>
      </sch:rule>
      <sch:rule xmlns="http://www.tei-c.org/ns/1.0"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                context="mei:*[matches(@clef.shape, '(TAB|perc)')]">
         <sch:assert test="@lines">A TAB or percussion clef requires that the number of lines be
            specified.</sch:assert>
      </sch:rule>
   </pattern>
   <pattern xmlns="http://purl.oclc.org/dsdl/schematron"
            xmlns:tei="http://www.tei-c.org/ns/1.0"
            xmlns:teix="http://www.tei-c.org/ns/Examples"
            xmlns:xlink="http://www.w3.org/1999/xlink"
            id="mei-graphicanalysis-att.clefShape-shape_requires_line-constraint-rule-116">
      <sch:rule xmlns="http://www.tei-c.org/ns/1.0"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                context="mei:clef[matches(@shape, '[FCG]')]">
         <sch:assert test="@line">When @shape is present, @line must also be
            specified.</sch:assert>
      </sch:rule>
   </pattern>
   <pattern xmlns="http://purl.oclc.org/dsdl/schematron"
            xmlns:tei="http://www.tei-c.org/ns/1.0"
            xmlns:teix="http://www.tei-c.org/ns/Examples"
            xmlns:xlink="http://www.w3.org/1999/xlink"
            id="mei-graphicanalysis-att.custos.log-target-check_custosTarget-constraint-rule-117">
      <sch:rule xmlns="http://www.tei-c.org/ns/1.0"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                context="mei:custos/@target">
         <sch:assert role="warning" test="not(normalize-space(.) eq '')">@target attribute
                should have content.</sch:assert>
         <sch:assert role="warning"
                     test="every $i in tokenize(., '\s+') satisfies substring($i,2)=//mei:note/@xml:id">The value in @target should correspond to the @xml:id attribute of a note
                element.</sch:assert>
      </sch:rule>
   </pattern>
   <pattern xmlns="http://purl.oclc.org/dsdl/schematron"
            xmlns:tei="http://www.tei-c.org/ns/1.0"
            xmlns:teix="http://www.tei-c.org/ns/Examples"
            xmlns:xlink="http://www.w3.org/1999/xlink"
            id="mei-graphicanalysis-att.dataPointing-data-check_dataTarget-constraint-rule-118">
      <sch:rule xmlns="http://www.tei-c.org/ns/1.0"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                context="@data">
         <sch:assert role="warning" test="not(normalize-space(.) eq '')">@data attribute should
                have content.</sch:assert>
         <sch:assert role="warning"
                     test="every $i in tokenize(., '\s+') satisfies substring($i,2)=//mei:*[ancestor::mei:music]/@xml:id">The value in @data should correspond to the @xml:id attribute of a descendant of
                the music element.</sch:assert>
      </sch:rule>
   </pattern>
   <pattern xmlns="http://purl.oclc.org/dsdl/schematron"
            xmlns:tei="http://www.tei-c.org/ns/1.0"
            xmlns:teix="http://www.tei-c.org/ns/Examples"
            xmlns:xlink="http://www.w3.org/1999/xlink"
            id="mei-graphicanalysis-att.metadataPointing-decls-check_declsTarget-constraint-rule-119">
      <sch:rule xmlns="http://www.tei-c.org/ns/1.0"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                context="@decls">
         <sch:assert role="warning" test="not(normalize-space(.) eq '')">@decls attribute
                should have content.</sch:assert>
         <sch:assert role="warning"
                     test="every $i in tokenize(., '\s+') satisfies substring($i,2)=//mei:*[ancestor::mei:meiHead]/@xml:id">Each value in @decls should correspond to the @xml:id attribute of an element
                within the metadata header.</sch:assert>
         <sch:assert test="every $i in tokenize(., '\s+') satisfies not(substring($i,2)=//mei:term/@xml:id)">No value in @decls should correspond to the @xml:id attribute of a classification
                term. Use @class for this purpose.</sch:assert>
      </sch:rule>
   </pattern>
   <pattern xmlns="http://purl.oclc.org/dsdl/schematron"
            xmlns:tei="http://www.tei-c.org/ns/1.0"
            xmlns:teix="http://www.tei-c.org/ns/Examples"
            xmlns:xlink="http://www.w3.org/1999/xlink"
            id="mei-graphicanalysis-att.extent-extent-check_extent-constraint-rule-120">
      <sch:rule xmlns="http://www.tei-c.org/ns/1.0"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                context="@extent[matches(normalize-space(.), '^\d+(\.\d+)?$')]">
         <sch:assert role="warning" test="../@unit">The @unit attribute is
                recommended.</sch:assert>
      </sch:rule>
      <sch:rule xmlns="http://www.tei-c.org/ns/1.0"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                context="@extent[matches(., '\d+(\.\d+)?\s')]">
         <sch:assert role="warning" test="../@unit">Separation into value (@extent) and unit
                (@unit) is recommended.</sch:assert>
      </sch:rule>
   </pattern>
   <pattern xmlns="http://purl.oclc.org/dsdl/schematron"
            xmlns:tei="http://www.tei-c.org/ns/1.0"
            xmlns:teix="http://www.tei-c.org/ns/Examples"
            xmlns:xlink="http://www.w3.org/1999/xlink"
            id="mei-graphicanalysis-att.handIdent-hand-check_handTarget-constraint-rule-122">
      <sch:rule xmlns="http://www.tei-c.org/ns/1.0"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                context="@hand">
         <sch:assert role="warning" test="not(normalize-space(.) eq '')">@hand attribute should
                have content.</sch:assert>
         <sch:assert role="warning"
                     test="every $i in tokenize(., '\s+') satisfies substring($i,2)=//mei:hand/@xml:id">Each value in @hand should correspond to the @xml:id attribute of a hand
                element.</sch:assert>
      </sch:rule>
   </pattern>
   <pattern xmlns="http://purl.oclc.org/dsdl/schematron"
            xmlns:tei="http://www.tei-c.org/ns/1.0"
            xmlns:teix="http://www.tei-c.org/ns/Examples"
            xmlns:xlink="http://www.w3.org/1999/xlink"
            id="mei-graphicanalysis-att.joined-join-check_joinTarget-constraint-rule-123">
      <sch:rule xmlns="http://www.tei-c.org/ns/1.0"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                context="@join">
         <sch:assert role="warning" test="not(normalize-space(.) eq '')">@join attribute should
                have content.</sch:assert>
         <sch:assert role="warning"
                     test="every $i in tokenize(., '\s+') satisfies substring($i,2)=//mei:*/@xml:id">Each
                value in @join should correspond to the @xml:id attribute of an
                element.</sch:assert>
      </sch:rule>
   </pattern>
   <pattern xmlns="http://purl.oclc.org/dsdl/schematron"
            xmlns:tei="http://www.tei-c.org/ns/1.0"
            xmlns:teix="http://www.tei-c.org/ns/Examples"
            xmlns:xlink="http://www.w3.org/1999/xlink"
            id="mei-graphicanalysis-att.layer.log-def-check_defTarget_layer-constraint-rule-124">
      <sch:rule xmlns="http://www.tei-c.org/ns/1.0"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                context="mei:layer/@def">
         <sch:assert role="warning" test="not(normalize-space(.) eq '')">@def attribute should
                have content.</sch:assert>
         <sch:assert role="warning"
                     test="every $i in tokenize(., '\s+') satisfies substring($i,2)=//mei:layerDef/@xml:id">The value in @def should correspond to the @xml:id attribute of a layerDef
                element.</sch:assert>
      </sch:rule>
   </pattern>
   <pattern xmlns="http://purl.oclc.org/dsdl/schematron"
            xmlns:tei="http://www.tei-c.org/ns/1.0"
            xmlns:teix="http://www.tei-c.org/ns/Examples"
            xmlns:xlink="http://www.w3.org/1999/xlink"
            id="mei-graphicanalysis-att.lineRend.base-lsegs-check_lsegs-constraint-rule-125">
      <sch:rule xmlns="http://www.tei-c.org/ns/1.0"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                context="@lsegs">
         <sch:assert test="matches(../@lform, '(dashed|dotted|wavy)')">@lform attribute
                matching "dashed", "dotted", or "wavy" required.</sch:assert>
      </sch:rule>
   </pattern>
   <pattern xmlns="http://purl.oclc.org/dsdl/schematron"
            xmlns:tei="http://www.tei-c.org/ns/1.0"
            xmlns:teix="http://www.tei-c.org/ns/Examples"
            xmlns:xlink="http://www.w3.org/1999/xlink"
            id="mei-graphicanalysis-att.linking-copyof-When_copyof_element_empty-constraint-rule-126">
      <sch:rule xmlns="http://www.tei-c.org/ns/1.0"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                context="mei:*[@copyof]">
         <sch:assert test="count(child::*[not(comment() or processing-instruction())]) = 0">An
                element with a copyof attribute can only have comment or processing instruction
                descendents.</sch:assert>
      </sch:rule>
   </pattern>
   <pattern xmlns="http://purl.oclc.org/dsdl/schematron"
            xmlns:tei="http://www.tei-c.org/ns/1.0"
            xmlns:teix="http://www.tei-c.org/ns/Examples"
            xmlns:xlink="http://www.w3.org/1999/xlink"
            id="mei-graphicanalysis-att.linking-copyof-check_copyofTarget-constraint-rule-127">
      <sch:rule xmlns="http://www.tei-c.org/ns/1.0"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                context="@copyof">
         <sch:assert role="warning" test="not(normalize-space(.) eq '')">@copyof attribute
                should have content.</sch:assert>
         <sch:assert role="warning"
                     test="every $i in tokenize(., '\s+') satisfies substring($i,2)=//mei:*/@xml:id">The
                value in @copyof should correspond to the @xml:id attribute of an
                element.</sch:assert>
      </sch:rule>
   </pattern>
   <pattern xmlns="http://purl.oclc.org/dsdl/schematron"
            xmlns:tei="http://www.tei-c.org/ns/1.0"
            xmlns:teix="http://www.tei-c.org/ns/Examples"
            xmlns:xlink="http://www.w3.org/1999/xlink"
            id="mei-graphicanalysis-att.linking-corresp-check_correspTarget-constraint-rule-128">
      <sch:rule xmlns="http://www.tei-c.org/ns/1.0"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                context="@corresp">
         <sch:assert role="warning" test="not(normalize-space(.) eq '')">@corresp attribute
                should have content.</sch:assert>
         <sch:assert role="warning"
                     test="every $i in tokenize(., '\s+') satisfies substring($i,2)=//mei:*/@xml:id">Each
                value in @corresp should correspond to the @xml:id attribute of an
                element.</sch:assert>
      </sch:rule>
   </pattern>
   <pattern xmlns="http://purl.oclc.org/dsdl/schematron"
            xmlns:tei="http://www.tei-c.org/ns/1.0"
            xmlns:teix="http://www.tei-c.org/ns/Examples"
            xmlns:xlink="http://www.w3.org/1999/xlink"
            id="mei-graphicanalysis-att.linking-follows-check_followsTarget-constraint-rule-129">
      <sch:rule xmlns="http://www.tei-c.org/ns/1.0"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                context="@follows">
         <sch:assert role="warning" test="not(normalize-space(.) eq '')">@follows attribute
                should have content.</sch:assert>
         <sch:assert role="warning"
                     test="every $i in tokenize(., '\s+') satisfies substring($i,2)=//mei:*/@xml:id">Each
                value in @follows must correspond to the @xml:id attribute of an
                element.</sch:assert>
      </sch:rule>
   </pattern>
   <pattern xmlns="http://purl.oclc.org/dsdl/schematron"
            xmlns:tei="http://www.tei-c.org/ns/1.0"
            xmlns:teix="http://www.tei-c.org/ns/Examples"
            xmlns:xlink="http://www.w3.org/1999/xlink"
            id="mei-graphicanalysis-att.linking-next-check_nextTarget-constraint-rule-130">
      <sch:rule xmlns="http://www.tei-c.org/ns/1.0"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                context="@next">
         <sch:assert role="warning" test="not(normalize-space(.) eq '')">@next attribute should
                have content.</sch:assert>
         <sch:assert role="warning"
                     test="every $i in tokenize(., '\s+') satisfies substring($i,2)=//mei:*/@xml:id">Each
                value in @next should correspond to the @xml:id attribute of an
                element.</sch:assert>
      </sch:rule>
   </pattern>
   <pattern xmlns="http://purl.oclc.org/dsdl/schematron"
            xmlns:tei="http://www.tei-c.org/ns/1.0"
            xmlns:teix="http://www.tei-c.org/ns/Examples"
            xmlns:xlink="http://www.w3.org/1999/xlink"
            id="mei-graphicanalysis-att.linking-precedes-check_precedesTarget-constraint-rule-131">
      <sch:rule xmlns="http://www.tei-c.org/ns/1.0"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                context="@precedes">
         <sch:assert role="warning" test="not(normalize-space(.) eq '')">@precedes attribute
                should have content.</sch:assert>
         <sch:assert role="warning"
                     test="every $i in tokenize(., '\s+') satisfies substring($i,2)=//mei:*/@xml:id">Each
                value in @precedes must correspond to the @xml:id attribute of an
                element.</sch:assert>
      </sch:rule>
   </pattern>
   <pattern xmlns="http://purl.oclc.org/dsdl/schematron"
            xmlns:tei="http://www.tei-c.org/ns/1.0"
            xmlns:teix="http://www.tei-c.org/ns/Examples"
            xmlns:xlink="http://www.w3.org/1999/xlink"
            id="mei-graphicanalysis-att.linking-prev-check_prevTarget-constraint-rule-132">
      <sch:rule xmlns="http://www.tei-c.org/ns/1.0"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                context="@prev">
         <sch:assert role="warning" test="not(normalize-space(.) eq '')">@prev attribute should
                have content.</sch:assert>
         <sch:assert role="warning"
                     test="every $i in tokenize(., '\s+') satisfies substring($i,2)=//mei:*/@xml:id">Each
                value in @prev should correspond to the @xml:id attribute of an
                element.</sch:assert>
      </sch:rule>
   </pattern>
   <pattern xmlns="http://purl.oclc.org/dsdl/schematron"
            xmlns:tei="http://www.tei-c.org/ns/1.0"
            xmlns:teix="http://www.tei-c.org/ns/Examples"
            xmlns:xlink="http://www.w3.org/1999/xlink"
            id="mei-graphicanalysis-att.linking-sameas-check_sameasTarget-constraint-rule-133">
      <sch:rule xmlns="http://www.tei-c.org/ns/1.0"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                context="@sameas">
         <sch:assert role="warning" test="not(normalize-space(.) eq '')">@sameas attribute
                should have content.</sch:assert>
         <sch:assert role="warning"
                     test="every $i in tokenize(., '\s+') satisfies substring($i,2)=//mei:*/@xml:id">Each
                value in @sameas should correspond to the @xml:id attribute of an
                element.</sch:assert>
      </sch:rule>
   </pattern>
   <pattern xmlns="http://purl.oclc.org/dsdl/schematron"
            xmlns:tei="http://www.tei-c.org/ns/1.0"
            xmlns:teix="http://www.tei-c.org/ns/Examples"
            xmlns:xlink="http://www.w3.org/1999/xlink"
            id="mei-graphicanalysis-att.linking-synch-check_synchTarget-constraint-rule-134">
      <sch:rule xmlns="http://www.tei-c.org/ns/1.0"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                context="@synch">
         <sch:assert role="warning" test="not(normalize-space(.) eq '')">@synch attribute
                should have content.</sch:assert>
         <sch:assert role="warning"
                     test="every $i in tokenize(., '\s+') satisfies substring($i,2)=//mei:*/@xml:id">Each
                value in @synch should correspond to the @xml:id attribute of an
                element.</sch:assert>
      </sch:rule>
   </pattern>
   <pattern xmlns="http://purl.oclc.org/dsdl/schematron"
            xmlns:tei="http://www.tei-c.org/ns/1.0"
            xmlns:teix="http://www.tei-c.org/ns/Examples"
            xmlns:xlink="http://www.w3.org/1999/xlink"
            id="mei-graphicanalysis-att.meiVersion-meiVersion.onlyRoot-constraint-rule-135">
      <sch:rule xmlns="http://www.tei-c.org/ns/1.0"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                context="/mei:*//*">
         <sch:report test="@meiversion">The @meiversion attribute is not allowed on elements that are not the document root element.</sch:report>
      </sch:rule>
   </pattern>
   <pattern xmlns="http://purl.oclc.org/dsdl/schematron"
            xmlns:tei="http://www.tei-c.org/ns/1.0"
            xmlns:teix="http://www.tei-c.org/ns/Examples"
            xmlns:xlink="http://www.w3.org/1999/xlink"
            id="mei-graphicanalysis-att.name-nymref-check_nymrefTarget-constraint-rule-136">
      <sch:rule xmlns="http://www.tei-c.org/ns/1.0"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                context="@nymref">
         <sch:assert role="warning" test="not(normalize-space(.) eq '')">@nymref attribute
                should have content.</sch:assert>
         <sch:assert role="warning"
                     test="every $i in tokenize(., '\s+') satisfies substring($i,2)=//mei:*/@xml:id">The
                value in @nymref should correspond to the @xml:id attribute of an
                element.</sch:assert>
      </sch:rule>
   </pattern>
   <pattern xmlns="http://purl.oclc.org/dsdl/schematron"
            xmlns:tei="http://www.tei-c.org/ns/1.0"
            xmlns:teix="http://www.tei-c.org/ns/Examples"
            xmlns:xlink="http://www.w3.org/1999/xlink"
            id="mei-graphicanalysis-att.noteHeads-head.altsym-check_head.altsymTarget-constraint-rule-137">
      <sch:rule xmlns="http://www.tei-c.org/ns/1.0"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                context="@head.altsym">
         <sch:assert role="warning" test="not(normalize-space(.) eq '')">@head.altsym attribute
                should have content.</sch:assert>
         <sch:assert role="warning"
                     test="every $i in tokenize(., '\s+') satisfies substring($i,2)=//mei:symbolDef/@xml:id">The value in @head.altsym should correspond to the @xml:id attribute of a symbolDef
                element.</sch:assert>
      </sch:rule>
   </pattern>
   <pattern xmlns="http://purl.oclc.org/dsdl/schematron"
            xmlns:tei="http://www.tei-c.org/ns/1.0"
            xmlns:teix="http://www.tei-c.org/ns/Examples"
            xmlns:xlink="http://www.w3.org/1999/xlink"
            id="mei-graphicanalysis-att.noteHeads-head.auth-check_head.auth-constraint-rule-138">
      <sch:rule xmlns="http://www.tei-c.org/ns/1.0"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                context="mei:*[lower-case(@head.auth) eq 'smufl']">
         <sch:assert test="matches(@head.shape, '^#x') or matches(@head.shape, '^U+')">When
                @head.auth matches 'smufl', @head.shape must contain a numeric glyph reference in
                hexadecimal notation, like "#xE000" or "U+E000".</sch:assert>
      </sch:rule>
   </pattern>
   <pattern xmlns="http://purl.oclc.org/dsdl/schematron"
            xmlns:tei="http://www.tei-c.org/ns/1.0"
            xmlns:teix="http://www.tei-c.org/ns/Examples"
            xmlns:xlink="http://www.w3.org/1999/xlink"
            id="mei-graphicanalysis-att.noteHeads-head.shape-check_headshape_num-constraint-rule-139">
      <sch:rule xmlns="http://www.tei-c.org/ns/1.0"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                context="mei:*[(matches(@head.shape, '#x') or matches(@head.shape, 'U+')) and (lower-case(@head.auth) eq 'smufl')]">
         <sch:assert role="warning"
                     test="matches(normalize-space(@head.shape), '^(#x|U\+)E([0-9AB][0-9A-F][0-9A-F]|C[0-9A][0-9A-F]|CB[0-9A-F])$')">SMuFL version 1.18 uses the range U+E000 - U+ECBF.</sch:assert>
      </sch:rule>
   </pattern>
   <pattern xmlns="http://purl.oclc.org/dsdl/schematron"
            xmlns:tei="http://www.tei-c.org/ns/1.0"
            xmlns:teix="http://www.tei-c.org/ns/Examples"
            xmlns:xlink="http://www.w3.org/1999/xlink"
            id="mei-graphicanalysis-att.origin.timestamp.log-origin.tstamp2-origin.tstamp2_requires_origin.tstamp-constraint-rule-140">
      <sch:rule xmlns="http://www.tei-c.org/ns/1.0"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                context="mei:*[@origin.tstamp2]">
         <sch:assert test="@origin.tstamp">When @origin.tstamp2 is used @origin.tstamp must
                also be present.</sch:assert>
      </sch:rule>
   </pattern>
   <pattern xmlns="http://purl.oclc.org/dsdl/schematron"
            xmlns:tei="http://www.tei-c.org/ns/1.0"
            xmlns:teix="http://www.tei-c.org/ns/Examples"
            xmlns:xlink="http://www.w3.org/1999/xlink"
            id="mei-graphicanalysis-att.partIdent-part-check_part_attr_all-constraint-rule-141">
      <sch:rule xmlns="http://www.tei-c.org/ns/1.0"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                context="@part[some $i in tokenize(., '\s+') satisfies (matches($i, '^%all$'))]">
         <sch:assert test="count(tokenize(., '\s+')) = 1">'%all' cannot be mixed with other
                values.</sch:assert>
      </sch:rule>
   </pattern>
   <pattern xmlns="http://purl.oclc.org/dsdl/schematron"
            xmlns:tei="http://www.tei-c.org/ns/1.0"
            xmlns:teix="http://www.tei-c.org/ns/Examples"
            xmlns:xlink="http://www.w3.org/1999/xlink"
            id="mei-graphicanalysis-att.partIdent-partstaff-check_partstaff_attr_all-constraint-rule-142">
      <sch:rule xmlns="http://www.tei-c.org/ns/1.0"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                context="@partstaff[some $i in tokenize(., '\s+') satisfies (matches($i, '^%all$'))]">
         <sch:assert test="count(tokenize(., '\s+')) = 1">'%all' cannot be mixed with other
                values.</sch:assert>
      </sch:rule>
   </pattern>
   <pattern xmlns="http://purl.oclc.org/dsdl/schematron"
            xmlns:tei="http://www.tei-c.org/ns/1.0"
            xmlns:teix="http://www.tei-c.org/ns/Examples"
            xmlns:xlink="http://www.w3.org/1999/xlink"
            id="mei-graphicanalysis-att.plist-plist-check_plistTarget-constraint-rule-143">
      <sch:rule xmlns="http://www.tei-c.org/ns/1.0"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                context="@plist">
         <sch:assert role="warning" test="not(normalize-space(.) eq '')">@plist attribute
                should have content.</sch:assert>
         <sch:assert role="warning"
                     test="every $i in tokenize(., '\s+') satisfies substring($i,2)=//mei:*/@xml:id">Each
                value in @plist should correspond to the @xml:id attribute of an
                element.</sch:assert>
      </sch:rule>
   </pattern>
   <pattern xmlns="http://purl.oclc.org/dsdl/schematron"
            xmlns:tei="http://www.tei-c.org/ns/1.0"
            xmlns:teix="http://www.tei-c.org/ns/Examples"
            xmlns:xlink="http://www.w3.org/1999/xlink"
            id="mei-graphicanalysis-att.ranging-confidence-check_confidence-constraint-rule-144">
      <sch:rule xmlns="http://www.tei-c.org/ns/1.0"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                context="mei:*[@confidence]">
         <sch:assert test="@min and @max">The attributes @min and @max are required when
                @confidence is present.</sch:assert>
      </sch:rule>
   </pattern>
   <pattern xmlns="http://purl.oclc.org/dsdl/schematron"
            xmlns:tei="http://www.tei-c.org/ns/1.0"
            xmlns:teix="http://www.tei-c.org/ns/Examples"
            xmlns:xlink="http://www.w3.org/1999/xlink"
            id="mei-graphicanalysis-att.responsibility-resp-check_respTarget-constraint-rule-145">
      <sch:rule xmlns="http://www.tei-c.org/ns/1.0"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                context="@resp">
         <sch:assert role="warning" test="not(normalize-space(.) eq '')">@resp attribute should
                have content.</sch:assert>
         <sch:assert role="warning"
                     test="every $i in tokenize(., '\s+') satisfies substring($i,2)=//mei:*[ancestor::mei:meiHead]/@xml:id">The value in @resp should correspond to the @xml:id attribute of an element within
                the metadata header.</sch:assert>
      </sch:rule>
   </pattern>
   <pattern xmlns="http://purl.oclc.org/dsdl/schematron"
            xmlns:tei="http://www.tei-c.org/ns/1.0"
            xmlns:teix="http://www.tei-c.org/ns/Examples"
            xmlns:xlink="http://www.w3.org/1999/xlink"
            id="mei-graphicanalysis-att.source-source-check_sourceTarget-constraint-rule-146">
      <sch:rule xmlns="http://www.tei-c.org/ns/1.0"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                context="@source">
         <sch:assert role="warning" test="not(normalize-space(.) eq '')">@source attribute
                should have content.</sch:assert>
         <sch:assert role="warning"
                     test="every $i in tokenize(., '\s+') satisfies substring($i,2)=//mei:*[local-name() eq 'source' or local-name() eq 'manifestation']/@xml:id">Each value in @source should correspond to the @xml:id attribute of a source or
                manifestation element.</sch:assert>
      </sch:rule>
   </pattern>
   <pattern xmlns="http://purl.oclc.org/dsdl/schematron"
            xmlns:tei="http://www.tei-c.org/ns/1.0"
            xmlns:teix="http://www.tei-c.org/ns/Examples"
            xmlns:xlink="http://www.w3.org/1999/xlink"
            id="mei-graphicanalysis-att.staff.log-def-check_defTarget_staff-constraint-rule-147">
      <sch:rule xmlns="http://www.tei-c.org/ns/1.0"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                context="mei:staff/@def">
         <sch:assert role="warning" test="not(normalize-space(.) eq '')">@def attribute should
                have content.</sch:assert>
         <sch:assert role="warning"
                     test="every $i in tokenize(., '\s+') satisfies substring($i,2)=//mei:staffDef/@xml:id">The value in @def should correspond to the @xml:id attribute of a staffDef
                element.</sch:assert>
      </sch:rule>
   </pattern>
   <pattern xmlns="http://purl.oclc.org/dsdl/schematron"
            xmlns:tei="http://www.tei-c.org/ns/1.0"
            xmlns:teix="http://www.tei-c.org/ns/Examples"
            xmlns:xlink="http://www.w3.org/1999/xlink"
            id="mei-graphicanalysis-att.startEndId-endid-check_endidTarget-constraint-rule-148">
      <sch:rule xmlns="http://www.tei-c.org/ns/1.0"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                context="@endid">
         <sch:assert role="warning" test="not(normalize-space(.) eq '')">@endid attribute
                should have content.</sch:assert>
         <sch:assert role="warning"
                     test="every $i in tokenize(., '\s+') satisfies substring($i,2)=//mei:*/@xml:id">The
                value in @endid should correspond to the @xml:id attribute of an
                element.</sch:assert>
      </sch:rule>
   </pattern>
   <pattern xmlns="http://purl.oclc.org/dsdl/schematron"
            xmlns:tei="http://www.tei-c.org/ns/1.0"
            xmlns:teix="http://www.tei-c.org/ns/Examples"
            xmlns:xlink="http://www.w3.org/1999/xlink"
            id="mei-graphicanalysis-att.startId-startid-check_startidTarget-constraint-rule-149">
      <sch:rule xmlns="http://www.tei-c.org/ns/1.0"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                context="@startid">
         <sch:assert role="warning" test="not(normalize-space(.) eq '')">@startid attribute
                should have content.</sch:assert>
         <sch:assert role="warning"
                     test="every $i in tokenize(., '\s+') satisfies substring($i,2)=//mei:*/@xml:id">The
                value in @startid should correspond to the @xml:id attribute of an
                element.</sch:assert>
      </sch:rule>
   </pattern>
   <pattern xmlns="http://purl.oclc.org/dsdl/schematron"
            xmlns:tei="http://www.tei-c.org/ns/1.0"
            xmlns:teix="http://www.tei-c.org/ns/Examples"
            xmlns:xlink="http://www.w3.org/1999/xlink"
            id="mei-graphicanalysis-att.stems-stem.sameas-check_stem.sameasTarget-constraint-rule-150">
      <sch:rule xmlns="http://www.tei-c.org/ns/1.0"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                context="@stem.sameas">
         <sch:let name="layer.n" value="self::node()/ancestor::mei:layer/@n"/>
         <sch:let name="ref.id" value="substring(.,2)"/>
         <sch:assert role="warning" test="not(normalize-space(.) eq '')">@stem.sameas attribute
                should have content.</sch:assert>
         <sch:assert role="warning"
                     test="substring(.,2)=//mei:note[not(ancestor::mei:layer/@n=$layer.n)]/@xml:id">
                The value in @stem.sameas should correspond to the @xml:id attribute of the linked note
                element of a different layer.</sch:assert>
         <sch:assert role="warning" test="../@dur=//mei:note[@xml:id=$ref.id]/@dur">
                The linked notes by @stem.sameas should have the same @dur values.
              </sch:assert>
      </sch:rule>
   </pattern>
   <pattern xmlns="http://purl.oclc.org/dsdl/schematron"
            xmlns:tei="http://www.tei-c.org/ns/1.0"
            xmlns:teix="http://www.tei-c.org/ns/Examples"
            xmlns:xlink="http://www.w3.org/1999/xlink"
            id="mei-graphicanalysis-annot-Check_annot_data-constraint-rule-151">
      <sch:rule xmlns="http://www.tei-c.org/ns/1.0"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                context="mei:annot[@data]">
         <sch:assert test="ancestor::mei:notesStmt">The @data attribute may only occur on an
            annotation within the notesStmt element.</sch:assert>
      </sch:rule>
   </pattern>
   <pattern xmlns="http://purl.oclc.org/dsdl/schematron"
            xmlns:tei="http://www.tei-c.org/ns/1.0"
            xmlns:teix="http://www.tei-c.org/ns/Examples"
            xmlns:xlink="http://www.w3.org/1999/xlink"
            id="mei-graphicanalysis-biblList-checkBiblLabels-constraint-rule-152">
      <sch:rule xmlns="http://www.tei-c.org/ns/1.0"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                context="mei:biblList[mei:label]">
         <sch:assert role="warning" test="count(mei:label) = count(mei:bibl)">When labels are used,
            usually each bibliographic item has one.</sch:assert>
      </sch:rule>
   </pattern>
   <pattern xmlns="http://purl.oclc.org/dsdl/schematron"
            xmlns:tei="http://www.tei-c.org/ns/1.0"
            xmlns:teix="http://www.tei-c.org/ns/Examples"
            xmlns:xlink="http://www.w3.org/1999/xlink"
            id="mei-graphicanalysis-caesura-caesura_start-type_attributes_required-constraint-rule-153">
      <sch:rule xmlns="http://www.tei-c.org/ns/1.0"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                context="mei:caesura">
         <sch:assert test="@startid or @tstamp or @tstamp.ges or @tstamp.real">Must have one of the
            attributes: startid, tstamp, tstamp.ges or tstamp.real.</sch:assert>
      </sch:rule>
   </pattern>
   <pattern xmlns="http://purl.oclc.org/dsdl/schematron"
            xmlns:tei="http://www.tei-c.org/ns/1.0"
            xmlns:teix="http://www.tei-c.org/ns/Examples"
            xmlns:xlink="http://www.w3.org/1999/xlink"
            id="mei-graphicanalysis-cb-n-check_cb-constraint-rule-154">
      <sch:rule xmlns="http://www.tei-c.org/ns/1.0"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                context="mei:cb">
         <sch:let name="totalColumns" value="preceding::mei:colLayout[1]/@cols"/>
         <sch:assert test="preceding::mei:colLayout">Column beginning must be preceded by a
                colLayout element.</sch:assert>
         <sch:assert test="@n &lt;= $totalColumns">The value of @n should be less than or equal
                to the value of @cols (<sch:value-of select="$totalColumns"/>) of the preceding
                colLayout element.</sch:assert>
      </sch:rule>
   </pattern>
   <pattern xmlns="http://purl.oclc.org/dsdl/schematron"
            xmlns:tei="http://www.tei-c.org/ns/1.0"
            xmlns:teix="http://www.tei-c.org/ns/Examples"
            xmlns:xlink="http://www.w3.org/1999/xlink"
            id="mei-graphicanalysis-clef-Clef_position_lines-constraint-rule-155">
      <sch:rule xmlns="http://www.tei-c.org/ns/1.0"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                context="mei:clef[matches(@shape, '[FCG]')][ancestor::mei:staffDef[@lines]]">
         <sch:let name="thisstaff" value="ancestor::mei:staffDef/@n"/>
         <sch:assert test="number(@line) &lt;= number(ancestor::mei:staffDef[@n=$thisstaff and @lines][1]/@lines)">The clef position must be less than or equal to the number of lines of an ancestor
            staff.</sch:assert>
      </sch:rule>
   </pattern>
   <pattern xmlns="http://purl.oclc.org/dsdl/schematron"
            xmlns:tei="http://www.tei-c.org/ns/1.0"
            xmlns:teix="http://www.tei-c.org/ns/Examples"
            xmlns:xlink="http://www.w3.org/1999/xlink"
            id="mei-graphicanalysis-clef-Clef_position_nolines-constraint-rule-156">
      <sch:rule xmlns="http://www.tei-c.org/ns/1.0"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                context="mei:clef[ancestor::mei:staffDef[not(@lines)]]">
         <sch:let name="thisstaff" value="ancestor::mei:staffDef/@n"/>
         <sch:assert test="number(@line) &lt;= number(preceding::mei:staffDef[@n=$thisstaff and @lines][1]/@lines)">The clef position must be less than or equal to the number of lines of a preceding
            staff.</sch:assert>
      </sch:rule>
   </pattern>
   <pattern xmlns="http://purl.oclc.org/dsdl/schematron"
            xmlns:tei="http://www.tei-c.org/ns/1.0"
            xmlns:teix="http://www.tei-c.org/ns/Examples"
            xmlns:xlink="http://www.w3.org/1999/xlink"
            id="mei-graphicanalysis-dimensions-check_dimensions-constraint-rule-157">
      <sch:rule xmlns="http://www.tei-c.org/ns/1.0"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                context="mei:physDesc/mei:dimensions">
         <sch:assert test="not(count(mei:depth) &gt; 1)">The depth element may only appear
            once.</sch:assert>
         <sch:assert test="not(count(mei:height) &gt; 1)">The height element may only appear
            once.</sch:assert>
         <sch:assert test="not(count(mei:width) &gt; 1)">The width element may only appear
            once.</sch:assert>
      </sch:rule>
   </pattern>
   <pattern xmlns="http://purl.oclc.org/dsdl/schematron"
            xmlns:tei="http://www.tei-c.org/ns/1.0"
            xmlns:teix="http://www.tei-c.org/ns/Examples"
            xmlns:xlink="http://www.w3.org/1999/xlink"
            id="mei-graphicanalysis-dir-dir_start-type_attributes_required-constraint-rule-158">
      <sch:rule xmlns="http://www.tei-c.org/ns/1.0"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                context="mei:dir[not(ancestor::mei:syllable)]">
         <sch:assert test="@startid or @tstamp or @tstamp.ges or @tstamp.real">Must have one of the
            attributes: startid, tstamp, tstamp.ges or tstamp.real.</sch:assert>
      </sch:rule>
   </pattern>
   <pattern xmlns="http://purl.oclc.org/dsdl/schematron"
            xmlns:tei="http://www.tei-c.org/ns/1.0"
            xmlns:teix="http://www.tei-c.org/ns/Examples"
            xmlns:xlink="http://www.w3.org/1999/xlink"
            id="mei-graphicanalysis-dynam-dynam_start-type_attributes_required-constraint-rule-159">
      <sch:rule xmlns="http://www.tei-c.org/ns/1.0"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                context="mei:dynam">
         <sch:assert test="@startid or @tstamp or @tstamp.ges or @tstamp.real"> Must have one of
            the attributes: startid, tstamp, tstamp.ges or tstamp.real.</sch:assert>
      </sch:rule>
   </pattern>
   <pattern xmlns="http://purl.oclc.org/dsdl/schematron"
            xmlns:tei="http://www.tei-c.org/ns/1.0"
            xmlns:teix="http://www.tei-c.org/ns/Examples"
            xmlns:xlink="http://www.w3.org/1999/xlink"
            id="mei-graphicanalysis-dynam-dynam_end-type_attributes-constraint-rule-160">
      <sch:rule xmlns="http://www.tei-c.org/ns/1.0"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                context="mei:dynam[@val2]">
         <sch:assert test="@dur or @dur.ges or @endid or @tstamp2">When @val2 is present, either
            @dur, @dur.ges, @endid, or @tstamp2 must also be present.</sch:assert>
      </sch:rule>
   </pattern>
   <pattern xmlns="http://purl.oclc.org/dsdl/schematron"
            xmlns:tei="http://www.tei-c.org/ns/1.0"
            xmlns:teix="http://www.tei-c.org/ns/Examples"
            xmlns:xlink="http://www.w3.org/1999/xlink"
            id="mei-graphicanalysis-grpSym-check_grpSym_attributes_scoreDef-constraint-rule-161">
      <sch:rule xmlns="http://www.tei-c.org/ns/1.0"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                context="mei:grpSym[parent::mei:scoreDef]">
         <sch:assert test="@startid and @endid and @level">In scoreDef, grpSym must have startid,
            endid, and level attributes.</sch:assert>
      </sch:rule>
   </pattern>
   <pattern xmlns="http://purl.oclc.org/dsdl/schematron"
            xmlns:tei="http://www.tei-c.org/ns/1.0"
            xmlns:teix="http://www.tei-c.org/ns/Examples"
            xmlns:xlink="http://www.w3.org/1999/xlink"
            id="mei-graphicanalysis-grpSym-check_grpSym_attributes_staffDef-constraint-rule-162">
      <sch:rule xmlns="http://www.tei-c.org/ns/1.0"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                context="mei:grpSym[parent::mei:staffGrp]">
         <sch:assert test="not(@startid or @endid or @level)">In staffGrp, grpSym must not have
            startid, endid, or level attributes.</sch:assert>
      </sch:rule>
   </pattern>
   <pattern xmlns="http://purl.oclc.org/dsdl/schematron"
            xmlns:tei="http://www.tei-c.org/ns/1.0"
            xmlns:teix="http://www.tei-c.org/ns/Examples"
            xmlns:xlink="http://www.w3.org/1999/xlink"
            id="mei-graphicanalysis-keyAccid-Check_keyAccidPlacement-constraint-rule-163">
      <sch:rule xmlns="http://www.tei-c.org/ns/1.0"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                context="mei:keyAccid">
         <sch:assert test="(@x and @y) or @pname or @loc">One of the following is required: @x and
            @y attribute pair, @pname attribute, or @loc attribute. </sch:assert>
      </sch:rule>
   </pattern>
   <pattern xmlns="http://purl.oclc.org/dsdl/schematron"
            xmlns:tei="http://www.tei-c.org/ns/1.0"
            xmlns:teix="http://www.tei-c.org/ns/Examples"
            xmlns:xlink="http://www.w3.org/1999/xlink"
            id="mei-graphicanalysis-keySig-check_keyAccid_oct-constraint-rule-164">
      <sch:rule xmlns="http://www.tei-c.org/ns/1.0"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                context="mei:keySig[mei:keyAccid[@oct]]">
         <sch:assert test="count(mei:keyAccid[@oct]) = count(mei:keyAccid)">If the @oct attribute
            appears on any keyAccid element, it must be provided on all keyAccid
            elements.</sch:assert>
      </sch:rule>
   </pattern>
   <pattern xmlns="http://purl.oclc.org/dsdl/schematron"
            xmlns:tei="http://www.tei-c.org/ns/1.0"
            xmlns:teix="http://www.tei-c.org/ns/Examples"
            xmlns:xlink="http://www.w3.org/1999/xlink"
            id="mei-graphicanalysis-keySig-check_keySig_editorial-constraint-rule-165">
      <sch:rule xmlns="http://www.tei-c.org/ns/1.0"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                context="mei:keySig/mei:*[local-name() eq 'add' or local-name() eq 'corr'             or local-name() eq 'damage' or local-name() eq 'del' or local-name() eq 'orig' or              local-name() eq 'reg' or local-name() eq 'restore' or local-name() eq 'sic' or              local-name() eq 'supplied' or local-name() eq 'unclear']">
         <sch:assert test="count(mei:keyAccid) = count(mei:*)">Only keyAccid elements are allowed
            here.</sch:assert>
      </sch:rule>
   </pattern>
   <pattern xmlns="http://purl.oclc.org/dsdl/schematron"
            xmlns:tei="http://www.tei-c.org/ns/1.0"
            xmlns:teix="http://www.tei-c.org/ns/Examples"
            xmlns:xlink="http://www.w3.org/1999/xlink"
            id="mei-graphicanalysis-label-label_note_only_in_graph-constraint-rule-166">
      <sch:rule xmlns="http://www.tei-c.org/ns/1.0"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                context="mei:label[mei:note][not(ancestor::mei:graph)]">
         <sch:assert test="false()">A note element is not permitted inside a label element outside a graph.</sch:assert>
      </sch:rule>
   </pattern>
   <pattern xmlns="http://purl.oclc.org/dsdl/schematron"
            xmlns:tei="http://www.tei-c.org/ns/1.0"
            xmlns:teix="http://www.tei-c.org/ns/Examples"
            xmlns:xlink="http://www.w3.org/1999/xlink"
            id="mei-graphicanalysis-mei-Check_staff-constraint-rule-167">
      <sch:rule xmlns="http://www.tei-c.org/ns/1.0"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                context="mei:*[@staff]">
         <sch:assert test="every $i in tokenize(normalize-space(@staff), '\s+') satisfies $i=//mei:staffDef/@n">The values in @staff must correspond to @n attribute of a staffDef
            element.</sch:assert>
      </sch:rule>
   </pattern>
   <pattern xmlns="http://purl.oclc.org/dsdl/schematron"
            xmlns:tei="http://www.tei-c.org/ns/1.0"
            xmlns:teix="http://www.tei-c.org/ns/Examples"
            xmlns:xlink="http://www.w3.org/1999/xlink"
            id="mei-graphicanalysis-name-nameParts-constraint-rule-168">
      <sch:rule xmlns="http://www.tei-c.org/ns/1.0"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                context="mei:name">
         <sch:assert role="warning" test="not(mei:geogName or mei:persName or mei:corpName)">Recommended practice is to use name elements to capture sub-parts of a generic
            name.</sch:assert>
      </sch:rule>
   </pattern>
   <pattern xmlns="http://purl.oclc.org/dsdl/schematron"
            xmlns:tei="http://www.tei-c.org/ns/1.0"
            xmlns:teix="http://www.tei-c.org/ns/Examples"
            xmlns:xlink="http://www.w3.org/1999/xlink"
            id="mei-graphicanalysis-ornam-ornam_start-type_attributes_required-constraint-rule-169">
      <sch:rule xmlns="http://www.tei-c.org/ns/1.0"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                context="mei:ornam">
         <sch:assert test="@startid or @tstamp or @tstamp.ges or @tstamp.real">Must have one of the
            attributes: startid, tstamp, tstamp.ges or tstamp.real.</sch:assert>
      </sch:rule>
   </pattern>
   <pattern xmlns="http://purl.oclc.org/dsdl/schematron"
            xmlns:tei="http://www.tei-c.org/ns/1.0"
            xmlns:teix="http://www.tei-c.org/ns/Examples"
            xmlns:xlink="http://www.w3.org/1999/xlink"
            id="mei-graphicanalysis-phrase-phrase_start-_and_end-type_attributes_required-constraint-rule-170">
      <sch:rule xmlns="http://www.tei-c.org/ns/1.0"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                context="mei:phrase">
         <sch:assert test="@startid or @tstamp or @tstamp.ges or @tstamp.real">Must have one of the
            attributes: startid, tstamp, tstamp.ges or tstamp.real.</sch:assert>
         <sch:assert test="@dur or @dur.ges or @endid or @tstamp2">Must have one of the attributes:
            dur, dur.ges, endid, or tstamp2.</sch:assert>
      </sch:rule>
   </pattern>
   <pattern xmlns="http://purl.oclc.org/dsdl/schematron"
            xmlns:tei="http://www.tei-c.org/ns/1.0"
            xmlns:teix="http://www.tei-c.org/ns/Examples"
            xmlns:xlink="http://www.w3.org/1999/xlink"
            id="mei-graphicanalysis-phrase-phrase_containing_curve-constraint-rule-171">
      <sch:rule xmlns="http://www.tei-c.org/ns/1.0"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                context="mei:phrase[mei:curve[@bezier or @bulge or @curvedir or @lform or @lwidth or @ho or              @startho or @endho or @to or @startto or @endto or @vo or @startvo or @endvo or @x or @y or @x2 or @y2]]">
         <sch:assert test="not(@bezier or @bulge or @curvedir or @lform or @lwidth or @ho or @startho or @endho or                @to or @startto or @endto or @vo or @startvo or @endvo or @x or @y or @x2 or @y2)"
                     role="warning">The visual attributes of the phrase (@bezier, @bulge, @curvedir, @lform,
            @lwidth, @ho, @startho, @endho, @to, @startto, @endto, @vo, @startvo, @endvo, @x, @y,
            @x2, and @y2) will be overridden by visual attributes of the contained curve
            elements.</sch:assert>
      </sch:rule>
   </pattern>
   <pattern xmlns="http://purl.oclc.org/dsdl/schematron"
            xmlns:tei="http://www.tei-c.org/ns/1.0"
            xmlns:teix="http://www.tei-c.org/ns/Examples"
            xmlns:xlink="http://www.w3.org/1999/xlink"
            id="mei-graphicanalysis-relation-FRBR_relation-constraint-rule-172">
      <sch:rule xmlns="http://www.tei-c.org/ns/1.0"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                context="mei:relationList/mei:relation[parent::mei:work or parent::mei:expression or           parent::mei:source or parent::mei:item]">
         <sch:assert test="matches(@rel, 'hasAbridgement') or             matches(@rel, 'hasAbridgement') or             matches(@rel, 'isAbridgementOf') or             matches(@rel, 'hasAdaptation') or             matches(@rel, 'isAdaptationOf') or             matches(@rel, 'hasAlternate') or             matches(@rel, 'isAlternateOf') or             matches(@rel, 'hasArrangement') or             matches(@rel, 'isArrangementOf') or             matches(@rel, 'hasComplement') or             matches(@rel, 'isComplementOf') or             matches(@rel, 'hasEmbodiment') or             matches(@rel, 'isEmbodimentOf') or             matches(@rel, 'hasExemplar') or             matches(@rel, 'isExemplarOf') or             matches(@rel, 'hasImitation') or             matches(@rel, 'isImitationOf') or             matches(@rel, 'hasPart') or             matches(@rel, 'isPartOf') or             matches(@rel, 'hasRealization') or             matches(@rel, 'isRealizationOf') or             matches(@rel, 'hasReconfiguration') or             matches(@rel, 'isReconfigurationOf') or             matches(@rel, 'hasReproduction') or             matches(@rel, 'isReproductionOf') or             matches(@rel, 'hasRevision') or             matches(@rel, 'isRevisionOf') or             matches(@rel, 'hasSuccessor') or             matches(@rel, 'isSuccessorOf') or             matches(@rel, 'hasSummarization') or             matches(@rel, 'isSummarizationOf') or             matches(@rel, 'hasSupplement') or             matches(@rel, 'isSupplementOf') or             matches(@rel, 'hasTransformation') or             matches(@rel, 'isTransformationOf') or             matches(@rel, 'hasTranslation') or             matches(@rel, 'isTranslationOf')">Within work, expression, source, or item, the value of the rel attribute must match one
            of the following: hasAbridgement, isAbridgementOf, hasAdaptation, isAdaptationOf,
            hasAlternate, isAlternateOf, hasArrangement, isArrangementOf, hasComplement,
            isComplementOf, hasEmbodiment, isEmbodimentOf, hasExemplar, isExemplarOf, hasImitation,
            isImitationOf, hasPart, isPartOf, hasRealization, isRealizationOf, hasReconfiguration,
            isReconfigurationOf, hasReproduction, isReproductionOf, hasRevision, isRevisionOf,
            hasSuccessor, isSuccessorOf, hasSummarization, isSummarizationOf, hasSupplement,
            isSupplementOf, hasTransformation, isTransformationOf, hasTranslation,
            isTranslationOf</sch:assert>
         <sch:assert test="@target">Within work, expression, source or item, the target attribute
            must be present.</sch:assert>
      </sch:rule>
   </pattern>
   <pattern xmlns="http://purl.oclc.org/dsdl/schematron"
            xmlns:tei="http://www.tei-c.org/ns/1.0"
            xmlns:teix="http://www.tei-c.org/ns/Examples"
            xmlns:xlink="http://www.w3.org/1999/xlink"
            id="mei-graphicanalysis-respStmt-check_respStmt-constraint-rule-173">
      <sch:rule xmlns="http://www.tei-c.org/ns/1.0"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                context="mei:respStmt[not(ancestor::mei:change) and not(ancestor::mei:work)]">
         <sch:assert test="(mei:resp and (mei:name or mei:corpName or mei:persName)) or             count(mei:*[@role]) = count(mei:*) and count(mei:*) &gt; 0"
                     role="warning">At least one element pair (a resp element and a name-like element) is
            recommended. Alternatively, each name-like element may have a @role
            attribute.</sch:assert>
      </sch:rule>
      <sch:rule xmlns="http://www.tei-c.org/ns/1.0"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                context="mei:respStmt[ancestor::mei:work]">
         <sch:report test="count(mei:*[@role]) &lt; count(mei:*) or count(mei:*) = 0"
                     role="warning">Name-like elements with a @role are recommended here.</sch:report>
         <sch:report test="mei:resp" role="warning">Name-like elements with a @role are recommended here (instead of resp).</sch:report>
      </sch:rule>
   </pattern>
   <pattern xmlns="http://purl.oclc.org/dsdl/schematron"
            xmlns:tei="http://www.tei-c.org/ns/1.0"
            xmlns:teix="http://www.tei-c.org/ns/Examples"
            xmlns:xlink="http://www.w3.org/1999/xlink"
            id="mei-graphicanalysis-section-Check_sectionexpansion-constraint-rule-175">
      <sch:rule xmlns="http://www.tei-c.org/ns/1.0"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                context="mei:section[mei:expansion]">
         <sch:assert test="descendant::mei:section|descendant::mei:ending|descendant::mei:rdg">A
            section containing an expansion element must have descendant section, ending, or rdg
            elements.</sch:assert>
      </sch:rule>
   </pattern>
   <pattern xmlns="http://purl.oclc.org/dsdl/schematron"
            xmlns:tei="http://www.tei-c.org/ns/1.0"
            xmlns:teix="http://www.tei-c.org/ns/Examples"
            xmlns:xlink="http://www.w3.org/1999/xlink"
            id="mei-graphicanalysis-staff-checkStaff_n-constraint-rule-176">
      <sch:rule xmlns="http://www.tei-c.org/ns/1.0"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                context="mei:staff[@n]">
         <sch:let name="thisstaff" value="@n"/>
         <sch:assert test="preceding::mei:staffDef[@n=$thisstaff] or preceding::mei:staff[@n=$thisstaff]/mei:staffDef or mei:staffDef">There must be a preceding staffDef with a matching value of @n, a preceding staff with
            a matching @n value containing a staffDef, or a staffDef child element.</sch:assert>
      </sch:rule>
   </pattern>
   <pattern xmlns="http://purl.oclc.org/dsdl/schematron"
            xmlns:tei="http://www.tei-c.org/ns/1.0"
            xmlns:teix="http://www.tei-c.org/ns/Examples"
            xmlns:xlink="http://www.w3.org/1999/xlink"
            id="mei-graphicanalysis-staffDef-Check_staffDefn-constraint-rule-177">
      <sch:rule xmlns="http://www.tei-c.org/ns/1.0"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                context="mei:staffDef[not(ancestor::mei:staff)]">
         <sch:let name="thisstaff" value="@n"/>
         <sch:assert test="@n">StaffDef must have an n attribute.</sch:assert>
         <sch:assert test="@lines or preceding::mei:staffDef[@n=$thisstaff and @lines]"> Either
            @lines must be present or a preceding staffDef with the same value for @n and @lines
            must exist.</sch:assert>
         <sch:assert test="count(mei:clef) + count(mei:clefGrp) &lt; 2">Only one clef or clefGrp is
            permitted.</sch:assert>
      </sch:rule>
   </pattern>
   <pattern xmlns="http://purl.oclc.org/dsdl/schematron"
            xmlns:tei="http://www.tei-c.org/ns/1.0"
            xmlns:teix="http://www.tei-c.org/ns/Examples"
            xmlns:xlink="http://www.w3.org/1999/xlink"
            id="mei-graphicanalysis-staffDef-Check_ancestor_staff-constraint-rule-178">
      <sch:rule xmlns="http://www.tei-c.org/ns/1.0"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                context="mei:staffDef[ancestor::mei:staff and @n]">
         <sch:let name="thisstaff" value="@n"/>
         <sch:assert test="ancestor::mei:staff/@n eq $thisstaff">@n must have the same value as the
            current staff.</sch:assert>
      </sch:rule>
   </pattern>
   <pattern xmlns="http://purl.oclc.org/dsdl/schematron"
            xmlns:tei="http://www.tei-c.org/ns/1.0"
            xmlns:teix="http://www.tei-c.org/ns/Examples"
            xmlns:xlink="http://www.w3.org/1999/xlink"
            id="mei-graphicanalysis-staffDef-Check_ancestor_staff_lines-constraint-rule-179">
      <sch:rule xmlns="http://www.tei-c.org/ns/1.0"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                context="mei:staffDef[ancestor::mei:staff and not(@n)]">
         <sch:let name="thisstaff" value="ancestor::mei:staff/@n"/>
         <sch:assert test="@lines or preceding::mei:staffDef[@n=$thisstaff and @lines]"> Either
            @lines must be present or a preceding staffDef with matching @n value and @lines must
            exist.</sch:assert>
      </sch:rule>
   </pattern>
   <pattern xmlns="http://purl.oclc.org/dsdl/schematron"
            xmlns:tei="http://www.tei-c.org/ns/1.0"
            xmlns:teix="http://www.tei-c.org/ns/Examples"
            xmlns:xlink="http://www.w3.org/1999/xlink"
            id="mei-graphicanalysis-staffDef-Check_clef_position_staffDef-constraint-rule-180">
      <sch:rule xmlns="http://www.tei-c.org/ns/1.0"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                context="mei:staffDef[@clef.line and @lines]">
         <sch:assert test="number(@clef.line) &lt;= number(@lines)">The clef position must be less
            than or equal to the number of lines on the staff.</sch:assert>
      </sch:rule>
   </pattern>
   <pattern xmlns="http://purl.oclc.org/dsdl/schematron"
            xmlns:tei="http://www.tei-c.org/ns/1.0"
            xmlns:teix="http://www.tei-c.org/ns/Examples"
            xmlns:xlink="http://www.w3.org/1999/xlink"
            id="mei-graphicanalysis-staffDef-Check_clef_position_staffDef_nolines-constraint-rule-181">
      <sch:rule xmlns="http://www.tei-c.org/ns/1.0"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                context="mei:staffDef[@clef.line and not(@lines)]">
         <sch:let name="thisstaff" value="@n"/>
         <sch:let name="stafflines"
                  value="preceding::mei:staffDef[@n=$thisstaff and @lines][1]/@lines"/>
         <sch:assert test="number(@clef.line) &lt;= number($stafflines)">The clef position must be
            less than or equal to the number of lines on the staff.</sch:assert>
      </sch:rule>
   </pattern>
   <pattern xmlns="http://purl.oclc.org/dsdl/schematron"
            xmlns:tei="http://www.tei-c.org/ns/1.0"
            xmlns:teix="http://www.tei-c.org/ns/Examples"
            xmlns:xlink="http://www.w3.org/1999/xlink"
            id="mei-graphicanalysis-staffDef-Check_tab_strings_lines-constraint-rule-182">
      <sch:rule xmlns="http://www.tei-c.org/ns/1.0"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                context="mei:staffDef[@tab.strings and @lines]">
         <sch:let name="countTokens"
                  value="count(tokenize(normalize-space(@tab.strings), '\s'))"/>
         <sch:assert test="$countTokens = @lines">The tab.strings attribute must have the same
            number of values as there are staff lines.</sch:assert>
      </sch:rule>
   </pattern>
   <pattern xmlns="http://purl.oclc.org/dsdl/schematron"
            xmlns:tei="http://www.tei-c.org/ns/1.0"
            xmlns:teix="http://www.tei-c.org/ns/Examples"
            xmlns:xlink="http://www.w3.org/1999/xlink"
            id="mei-graphicanalysis-staffDef-Check_tab_strings_nolines-constraint-rule-183">
      <sch:rule xmlns="http://www.tei-c.org/ns/1.0"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                context="mei:staffDef[@tab.strings and not(@lines)]">
         <sch:let name="countTokens"
                  value="count(tokenize(normalize-space(@tab.strings), '\s'))"/>
         <sch:let name="thisstaff" value="@n"/>
         <sch:assert test="$countTokens = preceding::mei:staffDef[@n=$thisstaff and @lines][1]/@lines">The
            tab.strings attribute must have the same number of values as there are staff
            lines.</sch:assert>
      </sch:rule>
   </pattern>
   <sch:pattern xmlns="http://www.tei-c.org/ns/1.0"
                xmlns:tei="http://www.tei-c.org/ns/1.0"
                xmlns:teix="http://www.tei-c.org/ns/Examples"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                xmlns:xlink="http://www.w3.org/1999/xlink">
      <sch:rule context="mei:staffDef[@lines.color and @lines]">
         <sch:let name="countTokens"
                  value="count(tokenize(normalize-space(@lines.color), '\s'))"/>
         <sch:assert test="$countTokens = 1 or $countTokens = @lines">The lines.color attribute
              must have either 1) a single value or 2) the same number of values as there are staff
              lines.</sch:assert>
      </sch:rule>
      <sch:rule context="mei:staffDef[@lines.color and not(@lines)]">
         <sch:let name="countTokens"
                  value="count(tokenize(normalize-space(@lines.color), '\s'))"/>
         <sch:let name="thisstaff" value="@n"/>
         <sch:assert test="$countTokens = 1 or $countTokens = preceding::mei:staffDef[@n=$thisstaff and @lines][1]/@lines">The lines.color attribute must have either 1) a single value or 2) the same number of
              values as there are staff lines.</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern xmlns="http://www.tei-c.org/ns/1.0"
                xmlns:tei="http://www.tei-c.org/ns/1.0"
                xmlns:teix="http://www.tei-c.org/ns/Examples"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                xmlns:xlink="http://www.w3.org/1999/xlink">
      <sch:rule context="mei:staffDef[@ppq][ancestor::mei:scoreDef[@ppq]]">
         <sch:let name="staffPPQ" value="@ppq"/>
         <sch:let name="scorePPQ" value="ancestor::mei:scoreDef[@ppq][1]/@ppq"/>
         <sch:assert test="($scorePPQ mod $staffPPQ) = 0">The value of ppq must be a factor of
              the value of ppq on an ancestor scoreDef.</sch:assert>
      </sch:rule>
   </sch:pattern>
   <sch:pattern xmlns="http://www.tei-c.org/ns/1.0"
                xmlns:tei="http://www.tei-c.org/ns/1.0"
                xmlns:teix="http://www.tei-c.org/ns/Examples"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                xmlns:xlink="http://www.w3.org/1999/xlink">
      <sch:rule context="mei:staffDef[@ppq][preceding::mei:scoreDef[@ppq]]">
         <sch:let name="staffPPQ" value="@ppq"/>
         <sch:let name="scorePPQ" value="preceding::mei:scoreDef[@ppq][1]/@ppq"/>
         <sch:assert test="($scorePPQ mod $staffPPQ) = 0">The value of ppq must be a factor of
              the value of ppq on a preceding scoreDef.</sch:assert>
      </sch:rule>
   </sch:pattern>
   <pattern xmlns="http://purl.oclc.org/dsdl/schematron"
            xmlns:tei="http://www.tei-c.org/ns/1.0"
            xmlns:teix="http://www.tei-c.org/ns/Examples"
            xmlns:xlink="http://www.w3.org/1999/xlink"
            id="mei-graphicanalysis-staffGrp-Check_staffGrp_unique_staff_n_values-constraint-rule-188">
      <sch:rule xmlns="http://www.tei-c.org/ns/1.0"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                context="mei:staffGrp">
         <sch:let name="countstaves" value="count(descendant::mei:staffDef)"/>
         <sch:let name="countuniqstaves"
                  value="count(distinct-values(descendant::mei:staffDef/@n))"/>
         <sch:assert test="$countstaves eq $countuniqstaves">Each staffDef must have a unique value
            for the n attribute.</sch:assert>
      </sch:rule>
   </pattern>
   <pattern xmlns="http://purl.oclc.org/dsdl/schematron"
            xmlns:tei="http://www.tei-c.org/ns/1.0"
            xmlns:teix="http://www.tei-c.org/ns/Examples"
            xmlns:xlink="http://www.w3.org/1999/xlink"
            id="mei-graphicanalysis-symbol-symbolDef_symbol_attributes_required-constraint-rule-189">
      <sch:rule xmlns="http://www.tei-c.org/ns/1.0"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                context="mei:symbol[ancestor::mei:symbolDef]">
         <sch:assert test="@startid or (@x and @y)">In the symbolDef context, symbol must have
            either a startid attribute or x and y attributes.</sch:assert>
         <sch:assert test="@altsym or @glyph.name or @glyph.num">In the symbolDef context, symbol
            must have one of the following attributes: altsym, glyph.name, or
            glyph.num.</sch:assert>
      </sch:rule>
   </pattern>
   <pattern xmlns="http://purl.oclc.org/dsdl/schematron"
            xmlns:tei="http://www.tei-c.org/ns/1.0"
            xmlns:teix="http://www.tei-c.org/ns/Examples"
            xmlns:xlink="http://www.w3.org/1999/xlink"
            id="mei-graphicanalysis-tempo-tempo_in_header_disallow_most_attrs-constraint-rule-190">
      <sch:rule xmlns="http://www.tei-c.org/ns/1.0"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                context="mei:tempo[not(ancestor::mei:score or ancestor::mei:part)]">
         <sch:assert test="not(@*[name() != 'analog' and name() != 'class' and name() != 'label' and name() != 'mm' and name() != 'mm.dots' and name() != 'translit' and name() != 'type' and name() != 'mm.unit' and name() != 'n' and name() != 'xml:base' and name() != 'xml:id' and name() != 'xml:lang'])">Only analog, class, label, mm, mm.dots, mm.unit, n, translit, type, xml:base, xml:id,
            and xml:lang attributes are allowed when tempo is not a descendant of a score or
            part.</sch:assert>
      </sch:rule>
   </pattern>
   <pattern xmlns="http://purl.oclc.org/dsdl/schematron"
            xmlns:tei="http://www.tei-c.org/ns/1.0"
            xmlns:teix="http://www.tei-c.org/ns/Examples"
            xmlns:xlink="http://www.w3.org/1999/xlink"
            id="mei-graphicanalysis-tempo-tempo_start-type_attributes_required-constraint-rule-191">
      <sch:rule xmlns="http://www.tei-c.org/ns/1.0"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                context="mei:tempo[not(ancestor::mei:syllable) and not(ancestor::mei:work) and not(ancestor::mei:expression) and not(count(ancestor::mei:*) = 0)]">
         <sch:assert test="@startid or @tstamp or @tstamp.ges or @tstamp.real">Must have one of the
            attributes: startid, tstamp, tstamp.ges or tstamp.real.</sch:assert>
      </sch:rule>
   </pattern>
   <pattern xmlns="http://purl.oclc.org/dsdl/schematron"
            xmlns:tei="http://www.tei-c.org/ns/1.0"
            xmlns:teix="http://www.tei-c.org/ns/Examples"
            xmlns:xlink="http://www.w3.org/1999/xlink"
            id="mei-graphicanalysis-term-Check_term_dataTarget-constraint-rule-192">
      <sch:rule xmlns="http://www.tei-c.org/ns/1.0"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                context="mei:term[@data]">
         <sch:assert test="ancestor::mei:classification">The @data attribute may only occur on a
            term which is a descendant of a classification element.</sch:assert>
      </sch:rule>
   </pattern>
   <pattern xmlns="http://purl.oclc.org/dsdl/schematron"
            xmlns:tei="http://www.tei-c.org/ns/1.0"
            xmlns:teix="http://www.tei-c.org/ns/Examples"
            xmlns:xlink="http://www.w3.org/1999/xlink"
            id="mei-graphicanalysis-tabGrp-check_tabGrp_in_beam-constraint-rule-193">
      <sch:rule xmlns="http://www.tei-c.org/ns/1.0"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                context="mei:tabGrp[ancestor::mei:beam]">
         <sch:assert test="count(mei:tabDurSym) = 1" role="warning">A tabGrp inside of a beam must contain one tabDurSym.</sch:assert>
      </sch:rule>
   </pattern>
   <pattern xmlns="http://purl.oclc.org/dsdl/schematron"
            xmlns:tei="http://www.tei-c.org/ns/1.0"
            xmlns:teix="http://www.tei-c.org/ns/Examples"
            xmlns:xlink="http://www.w3.org/1999/xlink"
            id="mei-graphicanalysis-list-list_type_constraint-constraint-rule-194">
      <sch:rule xmlns="http://www.tei-c.org/ns/1.0"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                context="mei:list[contains(@type,'gloss')]">
         <sch:assert test="count(mei:label) = count(mei:li)">In a list of type "gloss" all items
            must be immediately preceded by a label.</sch:assert>
      </sch:rule>
   </pattern>
   <pattern xmlns="http://purl.oclc.org/dsdl/schematron"
            xmlns:tei="http://www.tei-c.org/ns/1.0"
            xmlns:teix="http://www.tei-c.org/ns/Examples"
            xmlns:xlink="http://www.w3.org/1999/xlink"
            id="mei-graphicanalysis-att.altSym-altsym-check_altsymTarget-constraint-rule-195">
      <sch:rule xmlns="http://www.tei-c.org/ns/1.0"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                context="@altsym">
         <sch:assert role="warning" test="not(normalize-space(.) eq '')">@altsym attribute
                should have content.</sch:assert>
         <sch:assert role="warning"
                     test="every $i in tokenize(., '\s+') satisfies substring($i,2)=//mei:symbolDef/@xml:id">The value in @altsym should correspond to the @xml:id attribute of a symbolDef
                element.</sch:assert>
         <sch:assert test="not(substring(., 2) eq ancestor::mei:symbolDef/@xml:id)">The value
                in @altsym must not correspond to the @xml:id attribute of a symbolDef
                ancestor.</sch:assert>
      </sch:rule>
   </pattern>
   <pattern xmlns="http://purl.oclc.org/dsdl/schematron"
            xmlns:tei="http://www.tei-c.org/ns/1.0"
            xmlns:teix="http://www.tei-c.org/ns/Examples"
            xmlns:xlink="http://www.w3.org/1999/xlink"
            id="mei-graphicanalysis-curve-symbolDef_curve_attributes_required-constraint-rule-196">
      <sch:rule xmlns="http://www.tei-c.org/ns/1.0"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                context="mei:curve[ancestor::mei:symbolDef]">
         <sch:assert test="@startid or (@x and @y)">In the symbolDef context, curve must have
            either a startid attribute or x and y attributes.</sch:assert>
         <sch:assert test="@endid or (@x2 and @y2)">In the symbolDef context, curve must have
            either an endid attribute or both x2 and y2 attributes.</sch:assert>
         <sch:assert test="@bezier or @bulge">In the symbolDef context, curve must have either a
            bezier or bulge attribute.</sch:assert>
      </sch:rule>
   </pattern>
   <pattern xmlns="http://purl.oclc.org/dsdl/schematron"
            xmlns:tei="http://www.tei-c.org/ns/1.0"
            xmlns:teix="http://www.tei-c.org/ns/Examples"
            xmlns:xlink="http://www.w3.org/1999/xlink"
            id="mei-graphicanalysis-line-line_start-_and_end-type_attributes_required-constraint-rule-197">
      <sch:rule xmlns="http://www.tei-c.org/ns/1.0"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                context="mei:line[ancestor::mei:symbolDef]">
         <sch:assert test="@startid or (@x and @y)">When used in the symbolDef context, must have
            either a startid attribute or x and y attributes.</sch:assert>
         <sch:assert test="@endid or (@x2 and @y2)">When used in the symbolDef context, must have
            either an endid attribute or both x2 and y2 attributes.</sch:assert>
      </sch:rule>
      <sch:rule xmlns="http://www.tei-c.org/ns/1.0"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                context="mei:line[not(ancestor::mei:symbolDef)]">
         <sch:assert test="@startid or @tstamp or @tstamp.ges or @tstamp.real or (@x and @y)">When
            used in the score context, must have a startid, tstamp, tstamp.ges or tstamp.real
            attribute or both x and y attributes.</sch:assert>
         <sch:assert test="@dur or @dur.ges or @endid or @tstamp2 or (@x2 and @y2)">When used in
            the score context, must have an endid, dur, dur.ges, or tstamp2 attribute or both x2 and
            y2 attributes.</sch:assert>
      </sch:rule>
   </pattern>
   <pattern xmlns="http://purl.oclc.org/dsdl/schematron"
            xmlns:tei="http://www.tei-c.org/ns/1.0"
            xmlns:teix="http://www.tei-c.org/ns/Examples"
            xmlns:xlink="http://www.w3.org/1999/xlink"
            id="mei-graphicanalysis-att.fTrem.vis-beams.float-check_beams.floating-constraint-rule-199">
      <sch:rule xmlns="http://www.tei-c.org/ns/1.0"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                context="mei:fTrem[@beams and @beams.float]">
         <sch:assert test="@beams.float &lt;= @beams">The number of floating beams must be less
                than or equal to the total number of beams.</sch:assert>
      </sch:rule>
   </pattern>
   <sch:diagnostics/>
</sch:schema>
