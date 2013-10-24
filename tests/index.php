<?php

require __DIR__ . '/../src/PeerJ/Conversion/JATS.php';
$jats = new \PeerJ\Conversion\JATS;

// load the XML
$document = new DOMDocument;
$document->load(__DIR__ . '/example.xml', LIBXML_DTDLOAD | LIBXML_DTDVALID | LIBXML_NONET | LIBXML_NOENT);

// convert to HTML
$document = $jats->generateHTML($document);

// find the head element
$xpath = new DOMXPath($document);
$head = $xpath->query('head')->item(0);

// inject script elements
$scripts = array(
    'js/vendor/jquery/jquery.js',
    'js/vendor/jquery/jquery-ui.js',
    'js/vendor/polyfill/a.js',
    'js/vendor/polyfill/microdata.js',
    'js/vendor/qunit/qunit.js',
    'js/tests.js',
);

foreach ($scripts as $script) {
    $node = $document->createElement('script');
    $node->setAttribute('src', $script);
    $head->appendChild($node);
}

// inject CSS
$styles = array(
    'css/layout.css',
    'css/vendor/qunit/qunit.css',
);

foreach ($styles as $style) {
    $node = $document->createElement('link');
    $node->setAttribute('rel', 'stylesheet');
    $node->setAttribute('href', $style);
    $head->appendChild($node);
}

header('Content-Type: text/html');
print '<!doctype html>';
print $document->saveHTML($document->documentElement);
