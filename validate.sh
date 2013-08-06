#!/bin/bash

if [ -z "$1" ]
  then
    echo "Usage: $0 {article.xml}"
    exit
fi

# http://stackoverflow.com/questions/59895/can-a-bash-script-tell-what-directory-its-stored-in
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
ARTICLE=$1
FILE=`basename "$ARTICLE" .xml`
mkdir -p 'output'

export SGML_CATALOG_FILES="$DIR/catalog.xml"
#export SGML_CATALOG_FILES=catalog.xml

echo "Validating against JATS DTD"
xmllint --loaddtd --valid  --nonet --load-trace --noout --catalogs "$ARTICLE"

echo "Validating for CrossRef DOI deposition"
xsltproc --catalogs \
	--stringparam 'timestamp' `date +"%s"` \
	--stringparam 'depositorName' 'test' \
	--stringparam 'depositorEmail' 'test@example.com' \
	"$DIR/xsl/jats-to-unixref.xsl" "$ARTICLE" \
	| xmllint --nonet --load-trace --noout --schema "$DIR/crossref/crossref4.3.1.xsd" -

echo "Generating CrossRef schematron report"
OUTPUT="output/$FILE-crossref-schematron-report.xml"
#xsltproc --catalogs --stringparam "timestamp" `date +"%s"` "$DIR/xsl/jats-to-unixref.xsl" "$ARTICLE" | xsltproc "$DIR/resources/schematron/crossref.xsl" -
xsltproc --catalogs --stringparam "timestamp" `date +"%s"` "$DIR/xsl/jats-to-unixref.xsl" "$ARTICLE" > "crossref.xml"
saxon "crossref.xml" "$DIR/crossref/schematron.xsl" > "$OUTPUT"
rm "crossref.xml"
echo "CrossRef schematron report written to $OUTPUT"

echo "Checking PMC tagging style"
OUTPUT="output/$FILE-nlm-style-report.html"
xsltproc --catalogs "$DIR/nlm-stylechecker/nlm-stylechecker.xsl" "$ARTICLE" | xsltproc -output "$OUTPUT" "$DIR/nlm-stylechecker/style-reporter.xsl" -
echo "NLM Style report written to $OUTPUT"

echo "Generating HTML"
OUTPUT="output/$FILE-preview.html"
xsltproc --catalogs -output "$OUTPUT" "$DIR/xsl/jats-to-html.xsl" "$ARTICLE"
echo "HTML written to $OUTPUT"

# TODO: run JS tests in PhantomJS
