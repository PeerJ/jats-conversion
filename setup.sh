#!/bin/bash

# http://stackoverflow.com/questions/59895/can-a-bash-script-tell-what-directory-its-stored-in
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo "Creating "resources" directories"
JATS_DIR="$DIR/resources/jats-publishing"
mkdir -p $JATS_DIR

PMC_DIR="$DIR/resources/nlm-style"
mkdir -p $PMC_DIR

CROSSREF_DIR="$DIR/resources/crossref"
mkdir -p $CROSSREF_DIR

SCHEMATRON_DIR="$DIR/resources/schematron"
mkdir -p $SCHEMATRON_DIR

echo "Fetching JATS DTD"
ZIP="jats-publishing-dtd-1.0.zip"
curl "ftp://ftp.ncbi.nih.gov/pub/jats/publishing/1.0/$ZIP" --output "/tmp/$ZIP"; unzip "/tmp/$ZIP" -d "$JATS_DIR"
mv "$JATS_DIR/catalog-test-jats-v1.xml" "$JATS_DIR/catalog-jats-v1.xml" # version of the DTD with no xml:base

echo "Fetching NLM PMC Style Checker"
curl "http://www.ncbi.nlm.nih.gov/pmc/assets/nlm-style-5.0.tar.gz" | tar xvz -C "$PMC_DIR"

echo "Fetching CrossRef DTD"
FILES=( "crossref4.3.1.xsd" "common4.3.1.xsd" "fundref.xsd" )
for FILE in ${FILES[@]}
do
	curl "http://www.crossref.org/schema/deposit/$FILE" --output "$CROSSREF_DIR/$FILE"
done

echo "Fetching CrossRef Schematron"
ZIP="CrossRef_Schematron_Rules.zip"
curl "http://www.crossref.org/schematron/$ZIP" --output "/tmp/$ZIP"; unzip "/tmp/$ZIP" -d "$SCHEMATRON_DIR"
xsltproc -output "$SCHEMATRON_DIR/crossref.xsl" "$SCHEMATRON_DIR/CrossRef_Schematron_Rules/iso_svrl.xsl" "$SCHEMATRON_DIR/CrossRef_Schematron_Rules/deposit.sch"
rm -r "$SCHEMATRON_DIR/CrossRef_Schematron_Rules"

echo "Ready."
