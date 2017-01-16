<?php

namespace PeerJ\Conversion;

class JATS
{
    /**
     * @string
     *
     * Directory containing XSL files
     */
    protected $dir;

    /**
     * @param string $text
     *
     * @return string
     */
    public static function formatDate($text, $format = DATE_W3C)
    {
        $date = new \DateTime($text);

        return $date->format($format);
    }

    /**
     * Constructor
     *
     * Set the base directory for XSL files relative to this file
     */
    public function __construct()
    {
        $this->dir = __DIR__ . '/../../data/xsl/';
    }

    /**
     * Convert to HTML
     *
     * @param \DOMDocument $input  XML document to be converted
     * @param array        $params { 'static-root', 'search-root', 'download-prefix', 'publication-type', 'public-reviews', 'self-uri'}
     *
     * @return \DOMDocument
     */
    public function generateHTML(\DOMDocument $input, $params = array())
    {
        return $this->convert('jats-to-html', $input, $params);
    }

    /**
     * Generate JATS XML for a correction article
     *
     * @param \DOMDocument $input
     * @param array        $params
     *
     * @return \DOMDocument
     */
    public function generateCorrection(\DOMDocument $input, $params = array())
    {
        $output = $this->convert('jats-to-correction', $input, $params);
        $this->validateWithDTD($output);

        return $output;
    }

    /**
     * Generate JATS XML for a retraction article
     *
     * @param \DOMDocument $input
     * @param array        $params
     *
     * @return \DOMDocument
     */
    public function generateRetraction(\DOMDocument $input, $params = array())
    {
        $output = $this->convert('jats-to-retraction', $input, $params);
        $this->validateWithDTD($output);

        return $output;
    }

    /**
     * Convert to CrossRef deposit XML
     *
     * @param \DOMDocument $input  XML document to be converted
     * @param array        $params { 'depositorName', 'depositorEmail' }
     * @param bool         $validate
     *
     * @return \DOMDocument
     */
    public function generateCrossRef(\DOMDocument $input, $params = array(), $validate = true)
    {
        $params['timestamp'] = date('YmdHis');

        $output = $this->convert('jats-to-unixref', $input, $params);

        if ($validate) {
            $schema = 'http://www.crossref.org/schema/deposit/crossref4.3.6.xsd';
            $this->validateWithSchema($output, $schema);
        }

        return $output;
    }

    /**
     * Convert to minimal CrossRef deposit XML
     *
     * @param \DOMDocument $input  XML document to be converted
     * @param array        $params { 'depositorName', 'depositorEmail' }
     * @param bool         $validate
     *
     * @return \DOMDocument
     */
    public function generateMinimalCrossRef(\DOMDocument $input, $params = array(), $validate = true)
    {
        $params['timestamp'] = date('YmdHis');

        $output = $this->convert('jats-to-unixref-minimal', $input, $params);

        if ($validate) {
            $schema = 'http://www.crossref.org/schema/deposit/crossref4.3.6.xsd';
            $this->validateWithSchema($output, $schema);
        }

        return $output;
    }

    /**
     * Convert to DataCite deposit XML
     *
     * @param \DOMDocument $input  XML document to be converted
     * @param array        $params { 'itemVersion' }
     *
     * @return \DOMDocument
     */
    public function generateDataCite(\DOMDocument $input, $params = array())
    {
        $output = $this->convert('jats-to-datacite', $input, $params);
        $schema = 'http://schema.datacite.org/meta/kernel-3/metadata.xsd';
        $this->validateWithSchema($output, $schema);

        return $output;
    }

    /**
     * Convert to DOAJ deposit XML
     *
     * @param \DOMDocument $input XML document to be converted
     *
     * @return \DOMDocument
     */
    public function generateDOAJ(\DOMDocument $input)
    {
        $output = $this->convert('jats-to-doaj', $input);
        $schema = 'http://www.doaj.org/schemas/doajArticles.xsd';
        $this->validateWithSchema($output, $schema);

        return $output;
    }

    /**
     * Convert metadata to RDF/XML
     *
     * @param \DOMDocument $input  XML document to be converted
     * @param array        $params { 'homepage' }
     *
     * @return \DOMDocument
     */
    public function generateRDF(\DOMDocument $input, $params = array())
    {
        return $this->convert('jats-to-rdf', $input, $params);
    }

    /**
     * Convert metadata to RIS
     *
     * @param \DOMDocument $input XML document to be converted
     *
     * @return string
     */
    public function generateRIS(\DOMDocument $input)
    {
        return $this->convert('jats-to-ris', $input, array(), true);
    }

    /**
     * Convert metadata to BibTeX
     *
     * @param \DOMDocument $input XML document to be converted
     *
     * @return string
     */
    public function generateBibTeX(\DOMDocument $input)
    {
        return $this->convert('jats-to-bibtex', $input, array(), true);
    }

    /**
     * Convert HTML to JATS
     *
     * @param \DOMDocument $input
     *
     * @return \DOMDocument
     */
    public function fromHTML(\DOMDocument $input)
    {
        return $this->convert('html-to-jats', $input);
    }

    /**
     * @param string       $file   XSL stylesheet file for the conversion
     * @param \DOMDocument $input  XML document to be converted
     * @param array        $params parameters to be passed to the stylesheet
     * @param bool         $string whether to return the output as a string (default is DOMDocument)
     *
     * @return \DOMDocument
     */
    public function convert($file, \DOMDocument $input, $params = array(), $string = false)
    {
        $path = $this->dir . $file . '.xsl';

        $stylesheet = new \DOMDocument();
        $stylesheet->load($path);

        $processor = new \XSLTProcessor();
        $processor->registerPHPFunctions([
            'rawurlencode',
            'PeerJ\Conversion\JATS::formatDate'
        ]);
        $processor->importStyleSheet($stylesheet);
        $processor->setParameter(null, $params);

        if ($string) {
            return $processor->transformToXML($input);
        }

        $doc = $processor->transformToDoc($input);
        $doc->formatOutput = true;

        return $doc;
    }

    /**
     * @param \DOMDocument $doc     XML document to be validated
     * @param string       $doctype doctype to be checked against
     *
     * @throws \Exception
     */
    public function validateDoctype(\DOMDocument $doc, $doctype)
    {
        if ($doc->doctype->publicId !== $doctype) {
            throw new \Exception('Incorrect doctype: ' . $doc->doctype->publicId);
        }
    }

    /**
     * @param \DOMDocument $doc XML document to be validated
     *
     * @throws \Exception
     */
    public function validateWithDTD(\DOMDocument $doc)
    {
        libxml_use_internal_errors(true);

        if (!$doc->validate()) {
            throw new \Exception('Invalid XML: ' . json_encode(libxml_get_errors()));
        }

        libxml_use_internal_errors(false);
    }

    /**
     * Generally not validating with schema currently, as it loads remote files and needs newer libxml
     *
     * @param \DOMDocument $doc    XML document to be validated
     * @param string       $schema Schema URL
     *
     * @throws \Exception
     */
    protected function validateWithSchema(\DOMDocument $doc, $schema)
    {
        libxml_use_internal_errors(true);

        if (!$doc->schemaValidate($schema)) {
            $errors = libxml_get_errors();

            throw new \Exception('Invalid XML: ' . json_encode($errors));
        }

        libxml_use_internal_errors(false);
    }

    /**
     * @param \DOMDocument $input
     *
     * @return array
     */
    public function checkStyle(\DOMDocument $input)
    {
        $xsl = '../../../schema/nlm-stylechecker/nlm-stylechecker';
        $output = $this->convert($xsl, $input);

        if ($output->documentElement->nodeName === 'ERR') {
            return $this->buildStyleCheckErrors($output);
        }

        return array();
    }

    /**
     * @param \DOMDocument $output
     *
     * @return array
     */
    protected function buildStyleCheckErrors(\DOMDocument $output)
    {
        // save and reload, to get line numbers
        $file = tempnam(sys_get_temp_dir(), 'stylecheck-');
        $output->save($file);
        $doc = new \DOMDocument;
        $doc->load($file);
        $xpath = new \DOMXPath($doc);

        $errors = array();

        /** @var \DOMNode|\DOMElement $node */
        foreach ($xpath->query('//error') as $node) {
            $errors[] = array(
                'line' => $node->getLineNo(),
                'message' => $node->textContent,
            );
        }

        unlink($file);

        return $errors;
    }
}
