#TMPDIR := $(shell mktemp -d)
#trap "rm -rf $TMPDIR" EXIT

.PHONY: fetch jats crossref pmc-style-checker crossref-schematron datacite

fetch: jats crossref crossref-schematron nlm-stylechecker datacite

#validate:
	#./validate.sh

# Archive files

downloads:
	mkdir -p downloads

downloads/jats-publishing-dtd-1.0.zip: downloads
	wget --continue --directory-prefix=downloads ftp://ftp.ncbi.nih.gov/pub/jats/publishing/1.0/jats-publishing-dtd-1.0.zip

downloads/nlm-style-5.0.tar.gz: downloads
	wget --continue --directory-prefix=downloads http://www.ncbi.nlm.nih.gov/pmc/assets/nlm-style-5.0.tar.gz

downloads/CrossRef_Schematron_Rules.zip: downloads
	wget --continue --directory-prefix=downloads http://www.crossref.org/schematron/CrossRef_Schematron_Rules.zip

downloads/CrossRef_Schematron_Rules: downloads/CrossRef_Schematron_Rules.zip
	unzip downloads/CrossRef_Schematron_Rules.zip -d downloads
	touch downloads/CrossRef_Schematron_Rules

# JATS DTD

jats: jats/publishing/1.0/catalog-jats-v1.xml

jats/publishing/1.0/catalog-jats-v1.xml: downloads/jats-publishing-dtd-1.0.zip
	mkdir -p jats/publishing/1.0
	unzip downloads/jats-publishing-dtd-1.0.zip -d jats/publishing/1.0
	# version of the DTD with no xml:base
	cp jats/publishing/1.0/catalog-test-jats-v1.xml jats/publishing/1.0/catalog-jats-v1.xml
	touch jats/publishing/1.0/catalog-jats-v1.xml

# CrossRef Schema

crossref: crossref-4.3.2 crossref-4.3.1 crossref/fundref.xsd crossref/AccessIndicators.xsd

crossref-4.3.2:
	wget --continue --directory-prefix=crossref http://doi.crossref.org/schemas/crossref4.3.2.xsd
	wget --continue --directory-prefix=crossref http://doi.crossref.org/schemas/common4.3.2.xsd

crossref-4.3.1:
	wget --continue --directory-prefix=crossref http://doi.crossref.org/schemas/crossref4.3.1.xsd
	wget --continue --directory-prefix=crossref http://doi.crossref.org/schemas/common4.3.1.xsd

crossref/fundref.xsd:
	wget --continue --directory-prefix=crossref http://doi.crossref.org/schemas/fundref.xsd

crossref/AccessIndicators.xsd:
	wget --continue --directory-prefix=crossref http://doi.crossref.org/schemas/AccessIndicators.xsd

# DataCite schema

datacite: datacite-2.2 datacite-3.0

datacite-2.2:
	mkdir -p datacite/2.2/include
	wget --continue --directory-prefix=datacite/2.2  http://schema.datacite.org/meta/kernel-2.2/metadata.xsd
	wget --continue --directory-prefix=datacite/2.2/include  http://schema.datacite.org/meta/kernel-2.2/include/datacite-titleType-v2.xsd
	wget --continue --directory-prefix=datacite/2.2/include  http://schema.datacite.org/meta/kernel-2.2/include/datacite-contributorType-v2.xsd
	wget --continue --directory-prefix=datacite/2.2/include  http://schema.datacite.org/meta/kernel-2.2/include/datacite-dateType-v2.xsd
	wget --continue --directory-prefix=datacite/2.2/include  http://schema.datacite.org/meta/kernel-2.2/include/datacite-resourceType-v2.xsd
	wget --continue --directory-prefix=datacite/2.2/include  http://schema.datacite.org/meta/kernel-2.2/include/datacite-relationType-v2.xsd
	wget --continue --directory-prefix=datacite/2.2/include  http://schema.datacite.org/meta/kernel-2.2/include/datacite-relatedIdentifierType-v2.xsd
	wget --continue --directory-prefix=datacite/2.2/include  http://schema.datacite.org/meta/kernel-2.2/include/datacite-descriptionType-v2.xsd

datacite-3.0:
	mkdir -p datacite/3.0/include
	wget --continue --directory-prefix=datacite/3.0  http://schema.datacite.org/meta/kernel-3/metadata.xsd
	wget --continue --directory-prefix=datacite/3.0/include  http://schema.datacite.org/meta/kernel-3/include/datacite-titleType-v3.xsd
	wget --continue --directory-prefix=datacite/3.0/include  http://schema.datacite.org/meta/kernel-3/include/datacite-contributorType-v3.xsd
	wget --continue --directory-prefix=datacite/3.0/include  http://schema.datacite.org/meta/kernel-3/include/datacite-dateType-v3.xsd
	wget --continue --directory-prefix=datacite/3.0/include  http://schema.datacite.org/meta/kernel-3/include/datacite-resourceType-v3.xsd
	wget --continue --directory-prefix=datacite/3.0/include  http://schema.datacite.org/meta/kernel-3/include/datacite-relationType-v3.xsd
	wget --continue --directory-prefix=datacite/3.0/include  http://schema.datacite.org/meta/kernel-3/include/datacite-relatedIdentifierType-v3.xsd
	wget --continue --directory-prefix=datacite/3.0/include  http://schema.datacite.org/meta/kernel-3/include/datacite-descriptionType-v3.xsd

# NLM PMC Style Checker

nlm-stylechecker: nlm-stylechecker/nlm-stylechecker.xsl

nlm-stylechecker/nlm-stylechecker.xsl: downloads/nlm-style-5.0.tar.gz
	mkdir nlm-stylechecker
	tar xvz -C nlm-stylechecker -f downloads/nlm-style-5.0.tar.gz
	touch nlm-stylechecker/nlm-stylechecker.xsl

# CrossRef Schematron

crossref-schematron: crossref/schematron.xsl

crossref/schematron.xsl: downloads/CrossRef_Schematron_Rules
	xsltproc -output crossref/schematron.xsl downloads/CrossRef_Schematron_Rules/iso_svrl.xsl downloads/CrossRef_Schematron_Rules/deposit.sch

