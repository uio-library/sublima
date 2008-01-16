package com.computas.sublima.service;

import junit.framework.Test;
import junit.framework.TestCase;
import junit.framework.TestSuite;

import java.util.Map;
import java.util.TreeMap;

/**
 * Form2SparqlService Tester.
 *
 * @author <Authors name>
 * @version 1.0
 * @since <pre>12/03/2007</pre>
 */
public class Form2SparqlServiceTest extends TestCase {
  private Map<String, String[]> testMap;
  private String expectedString;
  private String expectedPrefix;
  private String[] testString;
  private Form2SparqlService myService;
  static String DCNS = "http://purl.org/dc/elements/1.1/";

  public Form2SparqlServiceTest(String name) {
    super(name);
  }

  public void setUp() throws Exception {
    testMap = new TreeMap<String, String[]>();
    expectedString = "DESCRIBE ?resource WHERE {\n?resource dc:title \"Cirrus Personal Jet\"";
    testString = new String[1];
    testString[0] = "Cirrus Personal Jet";
    expectedPrefix = "PREFIX dc: <http://purl.org/dc/elements/1.1/>\nPREFIX foaf: <http://xmlns.com/foaf/0.1/>\n";
    myService = new Form2SparqlService(new String[]{"dc: <http://purl.org/dc/elements/1.1/>", "foaf: <http://xmlns.com/foaf/0.1/>"});
    String resultString = myService.convertForm2Sparql(testMap);
//        String resultStringN3 = myService.convertFormField2N3();

  }

  public void tearDown() throws Exception {
    testMap = null;
  }

  public static Test suite() {
    return new TestSuite(Form2SparqlServiceTest.class);
  }

  public void testLanguage() {
    myService.setLanguage("en");
    assertEquals("Expected result and actual result not equal", "en",
            myService.getLanguage());

  }

  public void testPrefixes() {

    assertEquals("Expected result and actual result not equal", expectedPrefix, myService.getPrefixString());

  }

/*  TODO, not implemented
    public void testAppendPrefixes() {
      myService.addPrefix("rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>");
        assertEquals("Expected result and actual result not equal",
              "PREFIX dc: <http://purl.org/dc/elements/1.1/> .\nPREFIX foaf: <http://xmlns.com/foaf/0.1/> .\nPREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#> .\n", myService.getPrefixString());

    }
*/

  public void testConvertFormField2N3SingleLiteral() {
    String expectS = "\n?resource dc:title \"Cirrus Personal Jet\" .";
    assertEquals("Expected result and actual result not equal", expectS,
            myService.convertFormField2N3("dc:title", testString));
  }

  public void testConvertFormField2N3DualLiteral() {
    String expectS = "\n?resource dc:subject ?var1 .\n?var1 rdfs:label \"Jet\" .";
    testString[0] = "Jet";
    assertEquals("Expected result and actual result not equal", expectS,
            myService.convertFormField2N3("dc:subject/rdfs:label", testString));
  }

  public void testConvertFormField2N3SingleLiteralLang() {
    myService.setLanguage("en");
    String expectS = "\n?resource dc:title \"Cirrus Personal Jet\"@en .";
    assertEquals("Expected result and actual result not equal", expectS,
            myService.convertFormField2N3("dc:title", testString));
  }

  public void testConvertFormField2N3DualLiteralLang() {
    myService.setLanguage("en");
    String expectS = "\n?resource dc:subject ?var1 .\n?var1 rdfs:label \"Jet\"@en .";
    testString[0] = "Jet";
    assertEquals("Expected result and actual result not equal", expectS,
            myService.convertFormField2N3("dc:subject/rdfs:label", testString));
  }

  public void testConvertFormField2N3TripleLiteral() {
    String expectS = "\n?resource ex:example ?var1 .\n?var1 foo:foobar ?var2 .\n?var2 bar:foo \"Jet\" .";
    testString[0] = "Jet";
    assertEquals("Expected result and actual result not equal", expectS,
            myService.convertFormField2N3("ex:example/foo:foobar/bar:foo", testString));
  }

  public void testConvertFormField2N3SingleURI() {
    String expectS = "\n?resource dc:publisher <http://sublima.computas.com/agent/cirrus-design> .";
    testString[0] = "http://sublima.computas.com/agent/cirrus-design";
    assertEquals("Expected result and actual result not equal", expectS,
            myService.convertFormField2N3("dc:publisher", testString));
  }

  public void testConvertFormField2N3SingleDataType() {
    String expectS = "\n?resource dct:dateAccepted \"2007-12-05T14:23:00\"^^<http://www.w3.org/2001/XMLSchema#dateTime> .";
    testString[0] = "2007-12-05T14:23:00";
    assertEquals("Expected result and actual result not equal", expectS,
            myService.convertFormField2N3("dct:dateAccepted", testString));
  }

  public void testConvertFormField2N3SingleMailTo() {
    String expectS = "\n?resource foaf:mbox <mailto:test@example.org> .";
    testString[0] = "mailto:test@example.org";
    assertEquals("Expected result and actual result not equal", expectS,
            myService.convertFormField2N3("foaf:mbox", testString));
  }

  public void testConvertFormField2N3DualURI() {
    String expectS = "\n?resource dc:publisher ?var1 .\n?var1 foaf:homepage <http://www.cirrusdesign.com/> .";
    testString[0] = "http://www.cirrusdesign.com/";
    assertEquals("Expected result and actual result not equal", expectS,
            myService.convertFormField2N3("dc:publisher/foaf:homepage", testString));
  }

  public void testConvertFormField2N3DoubleDual() {
    String expectS = "\n?resource dc:publisher ?var1 .\n?var1 foaf:homepage <http://www.cirrusdesign.com/> .\n?resource dc:subject ?var2 .\n?var2 rdfs:label \"Jet\" .";
    testString[0] = "http://www.cirrusdesign.com/";
    String actual = myService.convertFormField2N3("dc:publisher/foaf:homepage", testString);
    testString[0] = "Jet";
    actual = actual + myService.convertFormField2N3("dc:subject/rdfs:label", testString);

    assertEquals("Expected result and actual result not equal", expectS, actual);
  }

  public void testConvertFormField2N3DualEmpty() {
    String expectS = "\nOPTIONAL {\n?resource dc:publisher ?var1 .\n?var1 foaf:homepage ?var2 . }";
    testString[0] = "";
    assertEquals("Expected result and actual result not equal", expectS,
            myService.convertFormField2N3("dc:publisher/foaf:homepage", testString));
  }


  public void testConvertForm2SparqlSingleValueNoLang() {
    // Single value test
    testMap.put("dc:title", testString);
    String resultString = myService.convertForm2Sparql(testMap);
    assertEquals("Expected result and actual result not equal", expectedPrefix + expectedString + " .\n}", resultString);
  }

  public void testConvertForm2SparqlSingleValue() {
    // Single value test
    testMap.put("dc:title", testString);
    testMap.put("interface-language", new String[]{"en"}); // this parameter is a magic string
    String resultString = myService.convertForm2Sparql(testMap);
    assertEquals("Expected result and actual result not equal", expectedPrefix + expectedString + "@en .\n}", resultString);
  }

  public void testConvertForm2SparqlTwoValues() {
    // Single value test
    testMap.put("dc:title", testString);
    testMap.put("dc:description", new String[]{"A Very Light Jet Aircraft under construction."});
    testMap.put("interface-language", new String[]{"en"}); // this parameter is a magic string
    String resultString = myService.convertForm2Sparql(testMap);
    assertEquals("Expected result and actual result not equal", expectedPrefix + "DESCRIBE ?resource WHERE {\n?resource dc:description \"A Very Light Jet Aircraft under construction.\"@en .\n?resource dc:title \"Cirrus Personal Jet\"@en .\n}", resultString);
  }

  public void testConvertFor2SPARQLDoubleDual() {
    String expectS = "DESCRIBE ?resource ?var1 ?var2 WHERE {\n?resource dc:publisher ?var1 .\n?var1 foaf:homepage <http://www.cirrusdesign.com/> .\n?resource dc:subject ?var2 .\n?var2 rdfs:label \"Jet\" .\n}";
    testMap.put("dc:subject/rdfs:label", new String[]{"Jet"});
    testMap.put("dc:publisher/foaf:homepage", new String[]{"http://www.cirrusdesign.com/"});
    String actual = myService.convertForm2Sparql(testMap);
    assertEquals("Expected result and actual result not equal", expectedPrefix + expectS, actual);
  }

  public void testConvertFor2SPARQLDoubleEmpty() {
    String expectS = "DESCRIBE ?resource ?var2 WHERE {\nOPTIONAL {\n?resource dc:publisher ?var1 . }\n?resource dc:subject ?var2 .\n?var2 rdfs:label \"Jet\" .\n}";
    testMap.put("dc:subject/rdfs:label", new String[]{"Jet"});
    testMap.put("dc:publisher", new String[]{""});
    String actual = myService.convertForm2Sparql(testMap);
    assertEquals("Expected result and actual result not equal", expectedPrefix + expectS, actual);
  }
  public void testConvertForm2SPARULSingleValue() {
	 // Single value test
	 String expectS = "INSERT {\n<http://sublima.computas.com/agent/ife> foaf:name \"Institute for Energy Technology\"@en .\n}";
	 testMap.put("foaf:name", new String[]{"Institute for Energy Technology"});
	 testMap.put("interface-language", new String[]{"en"}); // this parameter is a magic string
	 testMap.put("the-resource", new String[]{"http://sublima.computas.com/agent/ife"}); // this parameter is a magic string
	 String resultString = myService.convertForm2Sparul(testMap);
	 assertEquals("Expected result and actual result not equal", expectedPrefix + expectS, resultString);
  }

  public void testConvertForm2SPARULTwoValues() {
		 String expectS = "INSERT {\n<http://the-jet.com/> dc:description \"Et veldig lett jetfly (VLJ) som er under utarbeidelse.\"@no .\n<http://the-jet.com/> dc:title \"Cirrus personlig jetfly\"@no .\n}";
		 testMap.put("dc:description", new String[]{"Et veldig lett jetfly (VLJ) som er under utarbeidelse."});
		 testMap.put("dc:title", new String[]{"Cirrus personlig jetfly"});
		 testMap.put("interface-language", new String[]{"no"}); // this parameter is a magic string
		 testMap.put("the-resource", new String[]{"http://the-jet.com/"}); // this parameter is a magic string
		 String resultString = myService.convertForm2Sparul(testMap);
		 assertEquals("Expected result and actual result not equal", expectedPrefix + expectS, resultString);
 }	

/*  @Test(expected=IOException.class)
  public void testIOException() {
	  testMap.put("foaf:name", new String[]{"Institute for Energy Technology"});
	  testMap.put("interface-language", new String[]{"en"}); // this parameter is a magic string
	  String resultString = myService.convertForm2Sparul(testMap);
  }
*/    
}
