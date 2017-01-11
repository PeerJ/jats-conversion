This repository contains:

* [XSL files](https://github.com/PeerJ/jats-conversion/tree/master/src/data/xsl) for conversion from JATS XML to various other formats.
* [A PHP class](https://github.com/PeerJ/jats-conversion/tree/master/src/PeerJ/Conversion) for using the XSL.
* [Schema files](https://github.com/PeerJ/jats-conversion/tree/master/schema) fetched from third parties, for use in conversion and validation.

# XML catalog

Add `<nextCatalog catalog="file:///path/to/jats-conversion/schema/catalog.xml"/>` to your system's catalog file (e.g. at `/etc/xml/catalog`) to avoid fetching resources from the network.

# JATS validation

Validate a JATS XML file using:
 * [JATS Article Publishing DTD](http://jats.nlm.nih.gov/publishing/tag-library/1.1d1/)
 * [PMC Style Checker](http://www.ncbi.nlm.nih.gov/pmc/tools/stylechecker/)

Convert and validate against:
 * [CrossRef Deposit Schema](http://help.crossref.org/#deposit_schema)
 * [DataCite Deposit Schema](http://schema.datacite.org/)
 * [DOAJ Deposit Schema](http://www.doaj.org/doaj?func=loadTempl&templ=uploadInfo)

* Run ```tests/validate.sh filename``` to validate a JATS XML file.
* Output: any validation errors; NLM style report; HTML article preview.

# Updating

* Run ```cd schema && make fetch``` to fetch all the resources.
