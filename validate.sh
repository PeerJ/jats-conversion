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

export SGML_CATALOG_FILES="$DIR/resources/jats-publishing/catalog-jats-v1.xml"

echo "Validating against JATS DTD"
xmllint --loaddtd --noout --valid --catalogs "$ARTICLE"

echo "Validating for CrossRef DOI deposition"
xsltproc --catalogs --stringparam "timestamp" `date +"%s"` "$DIR/xsl/jats-to-unixref.xsl" "$ARTICLE" | xmllint --noout --schema "$DIR/resources/crossref/crossref4.3.1.xsd" -

echo "Checking PMC tagging style"
OUTPUT="output/$FILE-nlm-style-report.html"
xsltproc --catalogs "$DIR/resources/nlm-style/nlm-stylechecker.xsl" "$ARTICLE" | xsltproc -output "$OUTPUT" "$DIR/resources/nlm-style/style-reporter.xsl" -
echo "NLM Style report written to $OUTPUT"

echo "Generating HTML"
OUTPUT="output/$FILE-preview.html"
xsltproc --catalogs -output "$OUTPUT" "$DIR/xsl/jats-to-html.xsl" "$ARTICLE"
echo "HTML written to $OUTPUT"