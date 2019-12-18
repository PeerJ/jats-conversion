#!/bin/bash

if [ -z "$1" ]
then
  echo "Usage: $0 {article.xml}"
  exit
fi

ARTICLE=$1
FILE=`basename "$ARTICLE" .xml`
#TRACE='--load-trace'
TRACE=''

# http://stackoverflow.com/questions/59895/can-a-bash-script-tell-what-directory-its-stored-in
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
XSL="$DIR/../src/data/xsl"
XSLT="$XSL/jats-to-unixref-posted-content-preprint.xsl"
RESOURCES="$DIR/../schema"

OUTPUT_DIR=$(mktemp -d -t validate-XXX)

export SGML_CATALOG_FILES="$RESOURCES/catalog.xml"
# some user have reported issues when only setting SGML_CATALOG_FILES so also set XML_CATALOG_FILES:
export XML_CATALOG_FILES="$RESOURCES/catalog.xml"
#export SGML_CATALOG_FILES=catalog.xml

echo "Validating against JATS DTD"
xmllint --loaddtd --valid --nonet $TRACE --noout --catalogs "$ARTICLE"

echo "Validating against JATS XSD"
# TODO: detect version or add option
xmllint --nonet $TRACE --noout --catalogs --schema 'http://jats.nlm.nih.gov/publishing/1.1/xsd/JATS-journalpublishing1.xsd' "$ARTICLE"

DEPOSITION="$OUTPUT_DIR/$FILE-CrossRef-DOI-deposition.xml"
echo "Creating CrossRef DOI deposition - $DEPOSITION via $XSLT"
xsltproc --catalogs \
  --nodtdattr \
  --stringparam 'timestamp' `date +"%s"` \
  --stringparam 'depositorName' 'test' \
  --stringparam 'depositorEmail' 'test@example.com' \
  --stringparam 'doi' '10.1234/abcdf.preprint.1234v2' \
  --stringparam 'isPreprintOf' '10.1234/abcdf.review.4567'\
  --stringparam 'previousVersionDoi' '10.1234/abcdf.preprint.1234v1'\
  --stringparam 'nextVersionDoi' '10.1234/abcdf.preprint.1234v3' \
  "$XSLT" "$ARTICLE" > "$DEPOSITION"
#  --stringparam 'useThisUrl' 'http://example.com/preprints/1234' \

echo "Validating CrossRef DOI deposition - $DEPOSITION"
xmllint --nonet $TRACE --noout --schema "$RESOURCES/crossref/crossref4.4.2.xsd" "$DEPOSITION"

echo "Generating CrossRef schematron report"
OUTPUT="$OUTPUT_DIR/$FILE-crossref-schematron-report.xml"
# cat "$DEPOSITION" | xsltproc "$RESOURCES/crossref/schematron.xsl" -
# note this saxon8.jar is downloaded by the schema folder makefile, and copied here
java -jar saxon8.jar "$DEPOSITION" "$RESOURCES/crossref/schematron.xsl" > "$OUTPUT"
echo "CrossRef schematron report written to $OUTPUT"

echo "Checking PMC tagging style"
OUTPUT="$OUTPUT_DIR/$FILE-nlm-style-report.html"
xsltproc --catalogs "$RESOURCES/nlm-stylechecker/nlm-stylechecker.xsl" "$ARTICLE" | xsltproc -output "$OUTPUT" "$RESOURCES/nlm-stylechecker/style-reporter.xsl" -
echo "NLM Style report written to $OUTPUT"

echo "Generating HTML"
OUTPUT="$OUTPUT_DIR/$FILE-preview.html"
xsltproc --catalogs -output "$OUTPUT" "$XSL/jats-to-html.xsl" "$ARTICLE"
echo "HTML written to $OUTPUT"

# cp "$DEPOSITION" .
# cp -r "$OUTPUT_DIR" .

# TODO: run JS tests in PhantomJS
