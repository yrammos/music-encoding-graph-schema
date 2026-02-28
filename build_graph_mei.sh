#!/usr/bin/env bash

set -euo pipefail

ANT_LIB="lib/saxon/saxon-he-12.9.jar"
CUSTOMIZATION_PATH="/Users/rammos/Dev/epfl/erc/music-encoding/customizations/mei-graphicanalysis.xml"
ANT_TARGET="build-rng"
RNG="dist/schemata/mei-graphicanalysis.rng"
SCH="dist/schemata/mei-graphicanalysis.sch"
EXTRACT_XSL="utils/schematron/ExtractSchFromRNG-2.xsl"

echo "Extracting RNG from ODD..."
ant -lib "${ANT_LIB}" \
	-Dcustomization.path="${CUSTOMIZATION_PATH}" \
	"${ANT_TARGET}"
echo "RNG written to ${RNG}."

echo "Extracting Schematron from compiled RNG..."
java -jar "${ANT_LIB}" \
	-s:"${RNG}" \
	-xsl:"${EXTRACT_XSL}" \
	-o:"${SCH}"
echo "Schematron written to ${SCH}."

echo "Pre-compiling Schematron to XSLT for diagnostics in certain editors (e.g. nvim)..."
COMPILED_XSL="dist/schemata/mei-graphicanalysis-compiled.xsl"
STEP1=$(mktemp /tmp/mei-sch-step1.XXXXXX.sch)
STEP2=$(mktemp /tmp/mei-sch-step2.XXXXXX.sch)
java -jar "${ANT_LIB}" -s:"${SCH}"    -xsl:utils/schematron/iso_dsdl_include.xsl    -o:"${STEP1}"
java -jar "${ANT_LIB}" -s:"${STEP1}" -xsl:utils/schematron/iso_abstract_expand.xsl  -o:"${STEP2}"
java -jar "${ANT_LIB}" -s:"${STEP2}" -xsl:utils/schematron/iso_svrl_for_xslt2.xsl  allow-foreign=true -o:"${COMPILED_XSL}"
rm -f "${STEP1}" "${STEP2}"
echo "Compiled Schematron XSLT written to ${COMPILED_XSL}."

