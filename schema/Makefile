#TMPDIR := $(shell mktemp -d)
#trap "rm -rf $TMPDIR" EXIT

.PHONY: fetch nlm jats pmc

fetch: | jats crossref crossref441 crossrefRel nlm-stylechecker datacite doaj nlm w3 ncbi
fetch-all: | fetch pmc eutils

# Archive files

DOWNLOADS := /tmp/downloads

$(DOWNLOADS):
	mkdir -p $(DOWNLOADS)

# JATS DTD

jats: | jats/publishing/1.0 jats/publishing/1.1

# JATS 1.0

# "test" = version of the DTD with no xml:base
jats/publishing/1.0: | $(DOWNLOADS)/jats-publishing-dtd-1.0.zip $(DOWNLOADS)/jats-publishing-xsd-1.0.zip
	mkdir -p jats/publishing/1.0
	unzip $(DOWNLOADS)/jats-publishing-dtd-1.0.zip -d jats/publishing/1.0
	unzip $(DOWNLOADS)/jats-publishing-xsd-1.0.zip -d jats/publishing/1.0/xsd

$(DOWNLOADS)/jats-publishing-dtd-1.0.zip: | $(DOWNLOADS)
	wget -c -P $(DOWNLOADS) ftp://ftp.ncbi.nih.gov/pub/jats/publishing/1.0/jats-publishing-dtd-1.0.zip

$(DOWNLOADS)/jats-publishing-xsd-1.0.zip: | $(DOWNLOADS)
	wget -c -P $(DOWNLOADS) ftp://ftp.ncbi.nih.gov/pub/jats/publishing/1.0/jats-publishing-xsd-1.0.zip

# JATS 1.1
# there are 4 versions of this DTD, with MathML 2 or 3 and XHTML ± CALS tables
# need to unzip as there are subfolders
jats/publishing/1.1: | $(DOWNLOADS)/JATS-Publishing-1-1-MathML2-DTD.zip $(DOWNLOADS)/JATS-Publishing-1-1-MathML2-XSD.zip
	unzip $(DOWNLOADS)/JATS-Publishing-1-1-MathML2-DTD.zip -d $(DOWNLOADS)
	mv $(DOWNLOADS)/JATS-Publishing-1-1-MathML2-DTD/ jats/publishing/1.1

	unzip $(DOWNLOADS)/JATS-Publishing-1-1-MathML2-XSD.zip -d $(DOWNLOADS)
	mv $(DOWNLOADS)/JATS-Publishing-1-1-MathML2-XSD jats/publishing/1.1/xsd

$(DOWNLOADS)/JATS-Publishing-1-1-MathML2-DTD.zip: | $(DOWNLOADS)
	wget -c -P $(DOWNLOADS) ftp://ftp.ncbi.nih.gov/pub/jats/publishing/1.1/JATS-Publishing-1-1-MathML2-DTD.zip

$(DOWNLOADS)/JATS-Publishing-1-1-MathML2-XSD.zip: | $(DOWNLOADS)
	wget -c -P $(DOWNLOADS) ftp://ftp.ncbi.nih.gov/pub/jats/publishing/1.1/xsd/JATS-Publishing-1-1-MathML2-XSD.zip

# CrossRef Schema

crossref: | crossref/schematron.xsl
	mkdir -p crossref
	wget --recursive --level=1 --directory-prefix=crossref --no-directories --accept xsd http://doi.crossref.org/schemas/

crossref441:
		mkdir -p crossref
		wget --directory-prefix=crossref --no-directories --accept xsd http://doi.crossref.org/schemas/common4.4.1.xsd
		wget --directory-prefix=crossref --no-directories --accept xsd http://doi.crossref.org/schemas/crossref4.4.1.xsd
		wget --directory-prefix=crossref --no-directories --accept xsd http://doi.crossref.org/schemas/clinicaltrials.xsd
crossrefRel:
		mkdir -p crossref
		wget --directory-prefix=crossref --no-directories --accept xsd http://doi.crossref.org/schemas/relations.xsd

crossref/schematron.xsl: | $(DOWNLOADS)/CrossRef_Schematron_Rules
	mkdir -p crossref
	xsltproc -output crossref/schematron.xsl $(DOWNLOADS)/CrossRef_Schematron_Rules/iso_svrl.xsl $(DOWNLOADS)/CrossRef_Schematron_Rules/deposit.sch

$(DOWNLOADS)/CrossRef_Schematron_Rules.zip: | $(DOWNLOADS)
	wget -c https://support.crossref.org/hc/en-us/article_attachments/115001519883/Crossref_Schematron.zip -O $(DOWNLOADS)/CrossRef_Schematron_Rules.zip

$(DOWNLOADS)/CrossRef_Schematron_Rules: | $(DOWNLOADS)/CrossRef_Schematron_Rules.zip
	unzip $(DOWNLOADS)/CrossRef_Schematron_Rules.zip -d $(DOWNLOADS)
	touch $(DOWNLOADS)/CrossRef_Schematron_Rules

# DataCite schema

datacite: | datacite/meta/kernel-2.2 datacite/meta/kernel-3

datacite/meta/kernel-2.2:
	mkdir -p datacite/meta/kernel-2.2/include
	wget -c -P datacite/meta/kernel-2.2  http://schema.datacite.org/meta/kernel-2.2/metadata.xsd
	wget -c -P datacite/meta/kernel-2.2/include  http://schema.datacite.org/meta/kernel-2.2/include/datacite-titleType-v2.xsd
	wget -c -P datacite/meta/kernel-2.2/include  http://schema.datacite.org/meta/kernel-2.2/include/datacite-contributorType-v2.xsd
	wget -c -P datacite/meta/kernel-2.2/include  http://schema.datacite.org/meta/kernel-2.2/include/datacite-dateType-v2.xsd
	wget -c -P datacite/meta/kernel-2.2/include  http://schema.datacite.org/meta/kernel-2.2/include/datacite-resourceType-v2.xsd
	wget -c -P datacite/meta/kernel-2.2/include  http://schema.datacite.org/meta/kernel-2.2/include/datacite-relationType-v2.xsd
	wget -c -P datacite/meta/kernel-2.2/include  http://schema.datacite.org/meta/kernel-2.2/include/datacite-relatedIdentifierType-v2.xsd
	wget -c -P datacite/meta/kernel-2.2/include  http://schema.datacite.org/meta/kernel-2.2/include/datacite-descriptionType-v2.xsd

datacite/meta/kernel-3: w3
	mkdir -p datacite/meta/kernel-3/include
	wget -c -P datacite/meta/kernel-3  http://schema.datacite.org/meta/kernel-3/metadata.xsd
	wget -c -P datacite/meta/kernel-3/include  http://schema.datacite.org/meta/kernel-3/include/datacite-titleType-v3.xsd
	wget -c -P datacite/meta/kernel-3/include  http://schema.datacite.org/meta/kernel-3/include/datacite-contributorType-v3.1.xsd
	wget -c -P datacite/meta/kernel-3/include  http://schema.datacite.org/meta/kernel-3/include/datacite-dateType-v3.xsd
	wget -c -P datacite/meta/kernel-3/include  http://schema.datacite.org/meta/kernel-3/include/datacite-resourceType-v3.xsd
	wget -c -P datacite/meta/kernel-3/include  http://schema.datacite.org/meta/kernel-3/include/datacite-relationType-v3.1.xsd
	wget -c -P datacite/meta/kernel-3/include  http://schema.datacite.org/meta/kernel-3/include/datacite-relatedIdentifierType-v3.1.xsd
	wget -c -P datacite/meta/kernel-3/include  http://schema.datacite.org/meta/kernel-3/include/datacite-descriptionType-v3.xsd

# W3 DTDs and Schema

w3: | w3/2009/01/xml.xsd w3/1999/xlink.xsd w3/Math/DTD/mathml3 w3/Math/XMLSchema/mathml3

w3/2001/xml.xsd:
	mkdir -p w3/2001
	wget -c -P w3/2001 http://www.w3.org/2001/xml.xsd

w3/2009/01/xml.xsd:
	mkdir -p w3/2009/01
	wget -c -P w3/2009/01 http://www.w3.org/2009/01/xml.xsd

w3/1999/xlink.xsd:
	mkdir -p w3/1999
	wget -c -P w3/1999 http://www.w3.org/1999/xlink.xsd

w3/Math/DTD/mathml3: | $(DOWNLOADS)/mathml3-dtd.zip
	mkdir -p w3/Math/DTD
	unzip $(DOWNLOADS)/mathml3-dtd.zip -d w3/Math/DTD

$(DOWNLOADS)/mathml3-dtd.zip: | $(DOWNLOADS)
	wget -c -P $(DOWNLOADS) http://www.w3.org/Math/DTD/mathml3-dtd.zip

w3/Math/XMLSchema/mathml3: | $(DOWNLOADS)/mathml3-xsd.zip
	mkdir -p w3/Math/XMLSchema
	unzip $(DOWNLOADS)/mathml3-xsd.zip -d w3/Math/XMLSchema

$(DOWNLOADS)/mathml3-xsd.zip: | $(DOWNLOADS)
	wget -c -P $(DOWNLOADS) http://www.w3.org/Math/XMLSchema/mathml3-xsd.zip

# DOAJ schema
# http://www.doaj.org/doaj?func=loadTempl&templ=uploadInfo

doaj:
	mkdir -p doaj
	wget -c -P doaj https://doaj.org/static/doaj/doajArticles.xsd

	#mkdir -p doaj/appinfo/1
	#wget -c -P doaj/appinfo/1  http://www.doaj.org/schemas/appinfo/1/appinfo.xsd

	mkdir -p doaj/iso_639-2b/1.0
	wget -c -P doaj/iso_639-2b/1.0 http://www.doaj.org/static/doaj/iso_639-2b.xsd

# NLM PMC Style Checker

nlm-stylechecker: | $(DOWNLOADS)/nlm-style-5.12.tar.gz
	mkdir -p nlm-stylechecker
	tar xvz -C nlm-stylechecker -f $(DOWNLOADS)/nlm-style-5.12.tar.gz

$(DOWNLOADS)/nlm-style-5.12.tar.gz: | $(DOWNLOADS)
	wget -c -P $(DOWNLOADS) http://www.ncbi.nlm.nih.gov/pmc/assets/nlm-style-5.12.tar.gz

# NLM DTDs
# http://www.ncbi.nlm.nih.gov/data_specs/dtd/

# NLM Journal Publishing DTD

nlm: | nlm/publishing/3.0

nlm/publishing/3.0: | $(DOWNLOADS)/journal-publishing-dtd-3.0.zip
	mkdir -p nlm/publishing
	unzip $(DOWNLOADS)/journal-publishing-dtd-3.0.zip -d nlm/publishing
	mv nlm/publishing/publishing nlm/publishing/3.0
# TODO: remove xml:base from catalog

$(DOWNLOADS)/journal-publishing-dtd-3.0.zip: | $(DOWNLOADS)
	wget -c -P $(DOWNLOADS) ftp://ftp.ncbi.nih.gov/pub/archive_dtd/publishing/3.0/journal-publishing-dtd-3.0.zip

# PMC DTDs

pmc: | nlm/ncbi/pmc/articleset

nlm/ncbi/pmc/articleset:
	mkdir -p nlm/ncbi/pmc/articleset
	wget -c -P nlm/ncbi/pmc/articleset http://dtd.nlm.nih.gov/ncbi/pmc/articleset/nlm-articleset-2.0.dtd

# eUtils DTDs
# http://eutils.ncbi.nlm.nih.gov/corehtml/query/DTD/index.shtml

eutils:
	mkdir -p eutils/corehtml/query/DTD
	# wget --continue --recursive --level=1 --directory-prefix=eutils/corehtml/query/DTD --no-directories --accept xsd http://eutils.ncbi.nlm.nih.gov/corehtml/query/DTD/
	wget -c -P eutils/corehtml/query/DTD http://eutils.ncbi.nlm.nih.gov/corehtml/query/DTD/pubmed_100101.dtd
	wget -c -P eutils/corehtml/query/DTD http://eutils.ncbi.nlm.nih.gov/corehtml/query/DTD/nlmmedlinecitationset_100101.dtd
	wget -c -P eutils/corehtml/query/DTD http://eutils.ncbi.nlm.nih.gov/corehtml/query/DTD/eLink_020511.dtd
	wget -c -P eutils/corehtml/query/DTD http://eutils.ncbi.nlm.nih.gov/corehtml/query/DTD/eInfo_020511.dtd
	wget -c -P eutils/corehtml/query/DTD http://eutils.ncbi.nlm.nih.gov/corehtml/query/DTD/ePost_020511.dtd
	wget -c -P eutils/corehtml/query/DTD http://eutils.ncbi.nlm.nih.gov/corehtml/query/DTD/eSearch_020511.dtd
	wget -c -P eutils/corehtml/query/DTD http://eutils.ncbi.nlm.nih.gov/corehtml/query/DTD/eSummary_041029.dtd
	wget -c -P eutils/corehtml/query/DTD http://eutils.ncbi.nlm.nih.gov/corehtml/query/DTD/egquery.dtd
	wget -c -P eutils/corehtml/query/DTD http://eutils.ncbi.nlm.nih.gov/corehtml/query/DTD/eSpell.dtd

# NCBI DTDs

ncbi:
	mkdir -p ncbi/entrez/query/static
	wget -c -P ncbi/entrez/query/static http://www.ncbi.nlm.nih.gov:80/entrez/query/static/PubMed.dtd
	# TODO: catalog to map ISO entity public IDs to local entity files
