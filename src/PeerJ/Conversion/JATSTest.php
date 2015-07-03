<?php

namespace PeerJ\Conversion;

class JATSTest extends \PHPUnit_Framework_TestCase
{
    /**
     * @var string
     */
    private $file;

    public function setUp()
    {
        $this->file = __DIR__ . '/../../../tests/example.xml';
    }

    /**
     *
     */
    public function testGenerateHTML()
    {
        $jats = new JATS();
        $input = new \DOMDocument();
        $input->load($this->file);
        $output = $jats->generateHTML($input);
        $this->assertEquals('html', $output->documentElement->nodeName);
    }

    /**
     *
     */
    public function testStyleCheck()
    {
        $jats = new JATS();
        $input = new \DOMDocument();
        $input->load($this->file);
        $errors = $jats->checkStyle($input);
        $this->assertEquals(3, count($errors));
    }
}
