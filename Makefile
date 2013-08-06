#TMPDIR := $(shell mktemp -d)
#trap "rm -rf $TMPDIR" EXIT

.PHONY: fetch jats crossref crossref-schematron nlm-stylechecker datacite doaj

fetch: catalog.xml jats crossref crossref-schematron nlm-stylechecker datacite doaj

#validate:
	#./validate.sh

# XML catalog
# xmlcatalog --noout --add "nextCatalog" file://$(CURDIR)/catalog.xml "" /etc/xml/catalog

# Archive files

downloads-dir:
	mkdir -p downloads

downloads/jats-publishing-dtd-1.0.zip: | downloads-dir
	wget -c -P downloads ftp://ftp.ncbi.nih.gov/pub/jats/publishing/1.0/jats-publishing-dtd-1.0.zip

downloads/nlm-style-5.0.tar.gz: | downloads-dir
	wget -c -P downloads http://www.ncbi.nlm.nih.gov/pmc/assets/nlm-style-5.0.tar.gz

downloads/CrossRef_Schematron_Rules.zip: | downloads-dir
	wget -c -P downloads http://www.crossref.org/schematron/CrossRef_Schematron_Rules.zip

downloads/CrossRef_Schematron_Rules: | downloads/CrossRef_Schematron_Rules.zip
	unzip downloads/CrossRef_Schematron_Rules.zip -d downloads
	touch downloads/CrossRef_Schematron_Rules

# JATS DTD

jats: | jats/publishing/1.0/catalog-jats-v1.xml

# "test" = version of the DTD with no xml:base
jats/publishing/1.0/catalog-test-jats-v1.xml: | downloads/jats-publishing-dtd-1.0.zip
	mkdir -p jats/publishing/1.0
	unzip downloads/jats-publishing-dtd-1.0.zip -d jats/publishing/1.0
	touch jats/publishing/1.0/catalog-test-jats-v1.xml

# CrossRef Schema

fetch = wget -c -P $(1) $(2)

crossref:
	mkdir -p crossref
	wget -c -P crossref http://doi.crossref.org/schemas/crossref4.3.2.xsd
	wget -c -P crossref http://doi.crossref.org/schemas/common4.3.2.xsd
	wget -c -P crossref http://doi.crossref.org/schemas/crossref4.3.1.xsd
	wget -c -P crossref http://doi.crossref.org/schemas/common4.3.1.xsd
	wget -c -P crossref http://doi.crossref.org/schemas/fundref.xsd
	wget -c -P crossref http://doi.crossref.org/schemas/AccessIndicators.xsd

# DataCite schema

datacite: datacite-2.2 datacite-3

datacite-2.2:
	mkdir -p datacite/meta/kernel-2.2/include
	wget -c -P datacite/meta/kernel-2.2  http://schema.datacite.org/meta/kernel-2.2/metadata.xsd
	wget -c -P datacite/meta/kernel-2.2/include  http://schema.datacite.org/meta/kernel-2.2/include/datacite-titleType-v2.xsd
	wget -c -P datacite/meta/kernel-2.2/include  http://schema.datacite.org/meta/kernel-2.2/include/datacite-contributorType-v2.xsd
	wget -c -P datacite/meta/kernel-2.2/include  http://schema.datacite.org/meta/kernel-2.2/include/datacite-dateType-v2.xsd
	wget -c -P datacite/meta/kernel-2.2/include  http://schema.datacite.org/meta/kernel-2.2/include/datacite-resourceType-v2.xsd
	wget -c -P datacite/meta/kernel-2.2/include  http://schema.datacite.org/meta/kernel-2.2/include/datacite-relationType-v2.xsd
	wget -c -P datacite/meta/kernel-2.2/include  http://schema.datacite.org/meta/kernel-2.2/include/datacite-relatedIdentifierType-v2.xsd
	wget -c -P datacite/meta/kernel-2.2/include  http://schema.datacite.org/meta/kernel-2.2/include/datacite-descriptionType-v2.xsd

datacite-3:
	mkdir -p datacite/meta/kernel-3/include
	wget -c -P datacite/meta/kernel-3  http://schema.datacite.org/meta/kernel-3/metadata.xsd
	wget -c -P datacite/meta/kernel-3/include  http://schema.datacite.org/meta/kernel-3/include/datacite-titleType-v3.xsd
	wget -c -P datacite/meta/kernel-3/include  http://schema.datacite.org/meta/kernel-3/include/datacite-contributorType-v3.xsd
	wget -c -P datacite/meta/kernel-3/include  http://schema.datacite.org/meta/kernel-3/include/datacite-dateType-v3.xsd
	wget -c -P datacite/meta/kernel-3/include  http://schema.datacite.org/meta/kernel-3/include/datacite-resourceType-v3.xsd
	wget -c -P datacite/meta/kernel-3/include  http://schema.datacite.org/meta/kernel-3/include/datacite-relationType-v3.xsd
	wget -c -P datacite/meta/kernel-3/include  http://schema.datacite.org/meta/kernel-3/include/datacite-relatedIdentifierType-v3.xsd
	wget -c -P datacite/meta/kernel-3/include  http://schema.datacite.org/meta/kernel-3/include/datacite-descriptionType-v3.xsd

# DOAJ schema
# http://www.doaj.org/doaj?func=loadTempl&templ=uploadInfo

doaj:
	mkdir -p doaj
	wget -c -P doaj http://www.doaj.org/schemas/doajArticles.xsd

	mkdir -p doaj/appinfo/1
	wget -c -P doaj/appinfo/1  http://www.doaj.org/schemas/appinfo/1/appinfo.xsd

	mkdir -p doaj/iso_639-2b/1.0
	wget -c -P doaj/iso_639-2b/1.0 http://www.doaj.org/schemas/iso_639-2b/1.0/iso_639-2b.xsd

# NLM PMC Style Checker

nlm-stylechecker: | nlm-stylechecker/nlm-stylechecker.xsl

nlm-stylechecker/nlm-stylechecker.xsl: | downloads/nlm-style-5.0.tar.gz
	mkdir -p nlm-stylechecker
	tar xvz -C nlm-stylechecker -f downloads/nlm-style-5.0.tar.gz
	touch nlm-stylechecker/nlm-stylechecker.xsl

# CrossRef Schematron

crossref-schematron: | crossref/schematron.xsl

crossref/schematron.xsl: | downloads/CrossRef_Schematron_Rules
	mkdir -p crossref
	xsltproc -output crossref/schematron.xsl downloads/CrossRef_Schematron_Rules/iso_svrl.xsl downloads/CrossRef_Schematron_Rules/deposit.sch

