# JATS validator

Check an XML file against the [JATS Article Publishing 1.0 DTD](http://jats.nlm.nih.gov/publishing/tag-library/1.0/), [CrossRef Deposit Schema](http://help.crossref.org/#deposit_schema), [PMC Style Checker](http://www.ncbi.nlm.nih.gov/pmc/tools/stylechecker/).

## Usage

* Run ```./setup.sh``` once to fetch all the resources.
* Run ```./validate.sh filename``` to validate a JATS XML file.
* Output: any validation errors; NLM style report; HTML article preview.

## TODO

* JS rules for validating the HTML
* Microdata extraction tests
