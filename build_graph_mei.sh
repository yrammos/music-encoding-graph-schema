#!/usr/bin/env bash

set -euo pipefail

ANT_LIB="lib/saxon/saxon-he-12.7.jar"
CUSTOMIZATION_PATH="/Users/rammos/Dev/epfl/erc/music-encoding/customizations/mei-graphicanalysis.xml"
ANT_TARGET="build-rn"

ant -lib "${ANT_LIB}" \
	-Dcustomization.path="${CUSTOMIZATION_PATH}" \
	"${ANT_TARGET}"
