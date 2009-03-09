package com.computas.sublima.app.service;

import com.computas.sublima.query.service.SearchService;
import com.hp.hpl.jena.sparql.util.StringUtils;
import junit.framework.Test;
import junit.framework.TestCase;
import junit.framework.TestSuite;

import java.io.IOException;
import java.util.LinkedList;
import java.util.List;
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
  private LinkedList emptyList;
  private Form2SparqlService myService;
  static String DCNS = "http://purl.org/dc/terms/";

  public Form2SparqlServiceTest(String name) {
    super(name);
  }

  public void setUp() throws Exception {
    testMap = new TreeMap<String, String[]>();
    expectedString = "DESCRIBE ?resource ?rest WHERE {\n?resource dct:title \"\"\"Cirrus Personal Jet\"\"\"";
    testString = new String[1];
    testString[0] = "Cirrus Personal Jet";
    List emptyList = new LinkedList();
    expectedPrefix = "PREFIX dct: <http://purl.org/dc/terms/>\nPREFIX foaf: <http://xmlns.com/foaf/0.1/>\n";
    myService = new Form2SparqlService(new String[]{"dct: <http://purl.org/dc/terms/>", "foaf: <http://xmlns.com/foaf/0.1/>"});
    myService.setArchiveuri("<http://www.example.com>");
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


  public void testConvertFormField2N3SingleLiteral() {
    String expectS = "\n?resource dct:title \"\"\"Cirrus Personal Jet\"\"\" .";
    assertEquals("Expected result and actual result not equal", expectS,
            myService.convertFormField2N3("dct:title", testString));
  }

  public void testConvertFormField2N3TwoLiterals() {
    String expectS = "\n?resource dct:title \"\"\"Cirrus Personal Jet\"\"\", \"\"\"Velocity Aircraft\"\"\" .";
    assertEquals("Expected result and actual result not equal", expectS,
            myService.convertFormField2N3("dct:title", new String[]{"Cirrus Personal Jet", "Velocity Aircraft"}));
  }

  public void testConvertFormField2N3DualLiteral() {
    String expectS = "\n?resource dct:subject ?var1 .\n?var1 rdfs:label \"\"\"Jet\"\"\" .";
    testString[0] = "Jet";
    assertEquals("Expected result and actual result not equal", expectS,
            myService.convertFormField2N3("dct:subject/rdfs:label", testString));
  }

  public void testConvertFormField2N3AllSubjectLabels() {
    String expectS = "\nOPTIONAL {\n?resource dct:subject ?var1 .\n?var1 skos:prefLabel \"\"\"Jet\"\"\" . }\nOPTIONAL {\n?resource dct:subject ?var1 .\n?var1 skos:altLabel \"\"\"Jet\"\"\" . }\nOPTIONAL {\n?resource dct:subject ?var1 .\n?var1 skos:hiddenLabel \"\"\"Jet\"\"\" . }\nFILTER ( bound( ?var1 ) )\n";
    testString[0] = "Jet";
    assertEquals("Expected result and actual result not equal", expectS,
            myService.convertFormField2N3("dct:subject/all-labels", testString));
  }

/*  public void testConvertFormField2N3AllSubjectLabelsFree() {
    String expectS = "\n?var1 skos:prefLabel ?free1 .\n?free1 <bif:contains> \"\"\"'Jet*'\"\"\" .\n?resource dct:subject ?var1 .\n";
    testString[0] = "Jet";
    myService.addFreetextField("dct:subject/all-labels");
    assertEquals("Expected result and actual result not equal", expectS,
            myService.convertFormField2N3("dct:subject/all-labels", testString));
  }
*/
    
  public void testConvertFormField2N3SingleFree() {
    String expectS = "\n?resource dct:title ?free1 .\n?free1 <bif:contains> \"\"\"'Cirrus Personal Jet '\"\"\" .";
    myService.addFreetextField("dct:title");
    assertEquals("Expected result and actual result not equal", expectS,
            myService.convertFormField2N3("dct:title", testString));
  }

  public void testConvertFormField2N3DualFree() {
    String expectS = "\n?resource dct:subject ?var1 .\n?var1 rdfs:label ?free1 .\n?free1 <bif:contains> \"\"\"'Jet*'\"\"\" .";
    testString[0] = "Jet";
    myService.addFreetextField("dct:subject/rdfs:label");
    assertEquals("Expected result and actual result not equal", expectS,
            myService.convertFormField2N3("dct:subject/rdfs:label", testString));
  }

  public void testConvertFormField2N3SingleLiteralLang() {
    myService.setLanguage("en");
    String expectS = "\n?resource dct:title \"\"\"Cirrus Personal Jet\"\"\"@en .";
    assertEquals("Expected result and actual result not equal", expectS,
            myService.convertFormField2N3("dct:title", testString));
  }

  public void testConvertFormField2N3DualLiteralLang() {
    myService.setLanguage("en");
    String expectS = "\n?resource dct:subject ?var1 .\n?var1 rdfs:label \"\"\"Jet\"\"\"@en .";
    testString[0] = "Jet";
    assertEquals("Expected result and actual result not equal", expectS,
            myService.convertFormField2N3("dct:subject/rdfs:label", testString));
  }

  public void testConvertFormField2N3TripleLiteral() {
    String expectS = "\n?resource ex:example ?var1 .\n?var1 foo:foobar ?var2 .\n?var2 bar:foo \"\"\"Jet\"\"\" .";
    testString[0] = "Jet";
    assertEquals("Expected result and actual result not equal", expectS,
            myService.convertFormField2N3("ex:example/foo:foobar/bar:foo", testString));
  }

  public void testConvertFormField2N3SingleURI() {
    String expectS = "\n?resource dct:publisher <http://sublima.computas.com/agent/cirrus-design> .";
    testString[0] = "http://sublima.computas.com/agent/cirrus-design";
    assertEquals("Expected result and actual result not equal", expectS,
            myService.convertFormField2N3("dct:publisher", testString));
  }

  public void testConvertFormField2N3SingleDataType() {
    String expectS = "\n?resource dct:dateAccepted \"2007-12-05T14:23:00\"^^<http://www.w3.org/2001/XMLSchema#dateTime> .";
    testString[0] = "2007-12-05T14:23:00";
    assertEquals("Expected result and actual result not equal", expectS,
            myService.convertFormField2N3("dct:dateAccepted", testString));
  }

  public void testConvertFormField2N3SingleDateRange() {
    String expectS = "\n?resource dct:dateAccepted ?date .\nFILTER ( ?date > \"2008-08-21T00:00:00\"^^<http://www.w3.org/2001/XMLSchema#dateTime> && ?date < \"2008-08-21T23:59:59\"^^<http://www.w3.org/2001/XMLSchema#dateTime> ) .";
    testString[0] = "2008-08-21";
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
    String expectS = "\n?resource dct:publisher ?var1 .\n?var1 foaf:homepage <http://www.cirrusdesign.com/> .";
    testString[0] = "http://www.cirrusdesign.com/";
    assertEquals("Expected result and actual result not equal", expectS,
            myService.convertFormField2N3("dct:publisher/foaf:homepage", testString));
  }

  public void testConvertFormField2N3DoubleDual() {
    String expectS = "\n?resource dct:publisher ?var1 .\n?var1 foaf:homepage <http://www.cirrusdesign.com/> .\n?resource dct:subject ?var2 .\n?var2 rdfs:label \"\"\"Jet\"\"\" .";
    testString[0] = "http://www.cirrusdesign.com/";
    String actual = myService.convertFormField2N3("dct:publisher/foaf:homepage", testString);
    testString[0] = "Jet";
    actual = actual + myService.convertFormField2N3("dct:subject/rdfs:label", testString);

    assertEquals("Expected result and actual result not equal", expectS, actual);
  }

  public void testConvertFormField2N3DoubleDualOneFree() {
    String expectS = "\n?resource dct:publisher ?var1 .\n?var1 foaf:homepage <http://www.cirrusdesign.com/> .\n?resource dct:subject ?var2 .\n?var2 rdfs:label ?free1 .\n?free1 <bif:contains> \"\"\"'Jet*'\"\"\" .";
    testString[0] = "http://www.cirrusdesign.com/";
    String actual = myService.convertFormField2N3("dct:publisher/foaf:homepage", testString);
    testString[0] = "Jet";
    myService.addFreetextField("dct:subject/rdfs:label");
    actual = actual + myService.convertFormField2N3("dct:subject/rdfs:label", testString);

    assertEquals("Expected result and actual result not equal", expectS, actual);
  }

  public void testConvertFormField2N3DoubleDualBothFree() {
    String expectS = "\n?resource dct:title ?free1 .\n?free1 <bif:contains> \"\"\"'Cirrus Personal Jet '\"\"\" .\n?resource dct:subject ?var1 .\n?var1 rdfs:label ?free2 .\n?free2 <bif:contains> \"\"\"'Jet*'\"\"\" .";
    testString[0] = "Cirrus Personal Jet";
    myService.addFreetextField("dct:title");
    myService.addFreetextField("dct:subject/rdfs:label");
    String actual = myService.convertFormField2N3("dct:title", testString);
    testString[0] = "Jet";
    actual = actual + myService.convertFormField2N3("dct:subject/rdfs:label", testString);

    assertEquals("Expected result and actual result not equal", expectS, actual);
  }

  public void testConvertFormField2N3DualEmpty() {
    String expectS = "\n";
    testString[0] = "";
    assertEquals("Expected result and actual result not equal", expectS,
            myService.convertFormField2N3("dct:publisher/foaf:homepage", testString));
  }


  public void testConvertForm2SparqlSingleValueNoLang() {
    // Single value test
    testMap.put("dct:title", testString);
    String resultString = myService.convertForm2Sparql(testMap);
    assertEquals("Expected result and actual result not equal", expectedPrefix + expectedString + " .\n?resource ?p ?rest .\n}", resultString);
  }

  public void testConvertForm2SparqlSingleValueFreetext() {
    // Single value test, with simple freetext search
    testMap.put("dct:title", testString);
    SearchService searchService = new SearchService("AND");
    testMap.put("searchstring", new String[]{searchService.buildSearchString("engine", true, false)});
    String resultString = myService.convertForm2Sparql(testMap);
    assertEquals("Expected result and actual result not equal",
            StringUtils.join("\n", new String[]{
                    "PREFIX dct: <http://purl.org/dc/terms/>",
                    "PREFIX foaf: <http://xmlns.com/foaf/0.1/>",
                    "PREFIX sub: <http://xmlns.computas.com/sublima#>",
                    "DESCRIBE ?resource ?rest WHERE {",           
                    "?resource sub:literals ?lit .",
                    "?lit <bif:contains> \"\"\"'engine*'\"\"\" .",
                    "?resource dct:title \"\"\"Cirrus Personal Jet\"\"\" .",
                    "?resource ?p ?rest .\n}"}), resultString);
  }

  public void testConvertForm2SparqlCountSingleValueFreetext() {
    // Single value test, with simple freetext search
    testMap.put("dct:title", testString);
    SearchService searchService = new SearchService("AND");
    testMap.put("searchstring", new String[]{searchService.buildSearchString("engine", true, false)});
    String resultString = myService.convertForm2SparqlCount(testMap, 100);
    assertEquals("Expected result and actual result not equal",
            StringUtils.join("\n", new String[]{
                    "PREFIX dct: <http://purl.org/dc/terms/>",
                    "PREFIX foaf: <http://xmlns.com/foaf/0.1/>",
                    "PREFIX sub: <http://xmlns.computas.com/sublima#>",
                    "SELECT DISTINCT ?resource WHERE {",
                    "?resource sub:literals ?lit .",
                    "?lit <bif:contains> \"\"\"'engine*'\"\"\" .",
                    "?resource dct:title \"\"\"Cirrus Personal Jet\"\"\" .",
                    "}\nOFFSET 99 LIMIT 1"}), resultString);
  }

  public void testConvertForm2SparqlCountSingleValueFreetextWithRegeularFreetextSparql() {
    // Single value test, with simple freetext search
    testMap.put("dct:title", testString);
    SearchService searchService = new SearchService("AND");
    testMap.put("searchstring", new String[]{searchService.buildSearchString("engine", true, false)});
    String results = myService.convertForm2Sparql(testMap);
    String resultString = myService.convertForm2SparqlCount(testMap, 100);
    assertEquals("Expected result and actual result not equal",
            StringUtils.join("\n", new String[]{
                    "PREFIX dct: <http://purl.org/dc/terms/>",
                    "PREFIX foaf: <http://xmlns.com/foaf/0.1/>",

                    "PREFIX sub: <http://xmlns.computas.com/sublima#>",
                    "SELECT DISTINCT ?resource WHERE {",
                    "?resource sub:literals ?lit .",
                    "?lit <bif:contains> \"\"\"'engine*'\"\"\" .",
                    "?resource dct:title \"\"\"Cirrus Personal Jet\"\"\" .",
                    "}\nOFFSET 99 LIMIT 1"}), resultString);
  }


  public void testConvertForm2SparqlNoValueFreetextDeep() {
    // Single value test, with simple freetext search
    SearchService searchService = new SearchService("AND");
    testMap.put("searchstring", new String[]{searchService.buildSearchString("engine", true, false)});
    testMap.put("deepsearch", new String[]{"deepsearch"});

    String resultString = myService.convertForm2Sparql(testMap);
    assertEquals("Expected result and actual result not equal",
            StringUtils.join("\n", new String[]{
                    "PREFIX dct: <http://purl.org/dc/terms/>",
                    "PREFIX foaf: <http://xmlns.com/foaf/0.1/>",
                    "PREFIX sub: <http://xmlns.computas.com/sublima#>",
                    "DESCRIBE ?resource ?rest WHERE {",
                    "?resource sub:url ?lit .",
                    "?lit <bif:contains> \"\"\"'engine*'\"\"\" .",
                    "?resource ?p ?rest .\n}"}), resultString);
  }

  public void testConvertForm2SparqlNoValueFreetext() {
    // Single value test, with simple freetext search
    SearchService searchService = new SearchService("AND");
    testMap.put("searchstring", new String[]{searchService.buildSearchString("engine", true, false)});
    String resultString = myService.convertForm2Sparql(testMap);
    assertEquals("Expected result and actual result not equal",
            StringUtils.join("\n", new String[]{
                    "PREFIX dct: <http://purl.org/dc/terms/>",
                    "PREFIX foaf: <http://xmlns.com/foaf/0.1/>",
                    "PREFIX sub: <http://xmlns.computas.com/sublima#>",
                    "DESCRIBE ?resource ?rest WHERE {",
                    "?resource sub:literals ?lit .",
                    "?lit <bif:contains> \"\"\"'engine*'\"\"\" .",
                    "?resource ?p ?rest .\n}"}), resultString);
  }
    
  public void testConvertForm2SparqlNoValueFreetext2Letter() {
    // Single value test, with simple freetext search
      SearchService searchService = new SearchService("AND");
      testMap.put("searchstring", new String[]{searchService.buildSearchString("os", true, false)});
      String resultString = myService.convertForm2Sparql(testMap);
      assertEquals("Expected result and actual result not equal",
            StringUtils.join("\n", new String[]{
                    "PREFIX dct: <http://purl.org/dc/terms/>",
                    "PREFIX foaf: <http://xmlns.com/foaf/0.1/>",
                    "PREFIX sub: <http://xmlns.computas.com/sublima#>",
                    "DESCRIBE ?resource ?rest WHERE {",
                    "?resource sub:literals ?lit .",
                    "?lit <bif:contains> \"\"\"'os'\"\"\" .",
                    "?resource ?p ?rest .\n}"}), resultString);
 }

    public void testConvertForm2SparqlNoValueFreetext2WordsLetter() {
    // Single value test, with simple freetext search
      SearchService searchService = new SearchService("AND");
      testMap.put("searchstring", new String[]{searchService.buildSearchString("oslo s", true, false)});
      String resultString = myService.convertForm2Sparql(testMap);
      assertEquals("Expected result and actual result not equal",
            StringUtils.join("\n", new String[]{
                    "PREFIX dct: <http://purl.org/dc/terms/>",
                    "PREFIX foaf: <http://xmlns.com/foaf/0.1/>",
                    "PREFIX sub: <http://xmlns.computas.com/sublima#>",
                    "DESCRIBE ?resource ?rest WHERE {",
                    "?resource sub:literals ?lit .",
                    "?lit <bif:contains> \"\"\"'oslo* AND s'\"\"\" .",
                    "?resource ?p ?rest .\n}"}), resultString);
 }

    public void testConvertForm2SparqlNoValueFreetext2Words() {
    // Single value test, with simple freetext search
      SearchService searchService = new SearchService("AND");
      testMap.put("searchstring", new String[]{searchService.buildSearchString("oslo sen", true, false)});
      String resultString = myService.convertForm2Sparql(testMap);
      assertEquals("Expected result and actual result not equal",
            StringUtils.join("\n", new String[]{
                    "PREFIX dct: <http://purl.org/dc/terms/>",
                    "PREFIX foaf: <http://xmlns.com/foaf/0.1/>",
                    "PREFIX sub: <http://xmlns.computas.com/sublima#>",
                    "DESCRIBE ?resource ?rest WHERE {",
                    "?resource sub:literals ?lit .",
                    "?lit <bif:contains> \"\"\"'oslo* AND sen*'\"\"\" .",
                    "?resource ?p ?rest .\n}"}), resultString);
 }
  public void testConvertForm2SparqlFreetextDescribedBy() {
    // Single value test, with simple freetext search
    SearchService searchService = new SearchService("AND");
    testMap.put("ex:describedBy", new String[]{"http://example.org/status"});
    testMap.put("searchstring", new String[]{searchService.buildSearchString("engine", true, false)});
    String resultString = myService.convertForm2Sparql(testMap);
    assertEquals("Expected result and actual result not equal",
            StringUtils.join("\n", new String[]{
                    "PREFIX dct: <http://purl.org/dc/terms/>",
                    "PREFIX foaf: <http://xmlns.com/foaf/0.1/>",
                    "PREFIX sub: <http://xmlns.computas.com/sublima#>",
                    "DESCRIBE ?resource ?rest WHERE {",
                    "?resource sub:literals ?lit .",
                    "?lit <bif:contains> \"\"\"'engine*'\"\"\" .",
                    "?resource ex:describedBy <http://example.org/status> .",
                    "?resource ?p ?rest .\n}"}), resultString);
  }

  public void testConvertForm2SparqlFacets() {
    SearchService searchService = new SearchService("AND");
    testMap.put("wdr:describedBy", new String[]{"http://sublima.computas.com/status/godkjent_av_administrator"});
    testMap.put("dct:subject", new String[]{"http://rabbit.computas.int:8180/sublima-webapp-1.0-SNAPSHOT/topic/topic000511"});
    testMap.put("searchstring", new String[]{searchService.buildSearchString("epidemica", true, false)});
    myService.addPrefix("wdr: <http://www.w3.org/2007/05/powder#>");
    String resultString = myService.convertForm2Sparql(testMap);
    assertEquals("Expected result and actual result not equal",
            StringUtils.join("\n", new String[]{
                    "PREFIX dct: <http://purl.org/dc/terms/>",
                    "PREFIX foaf: <http://xmlns.com/foaf/0.1/>",
                    "PREFIX wdr: <http://www.w3.org/2007/05/powder#>",
                    "PREFIX sub: <http://xmlns.computas.com/sublima#>",
                    "DESCRIBE ?resource ?rest WHERE {",
                    "?resource sub:literals ?lit .",
                    "?lit <bif:contains> \"\"\"'epidemica*'\"\"\" .",
                    "?resource dct:subject <http://rabbit.computas.int:8180/sublima-webapp-1.0-SNAPSHOT/topic/topic000511> .",
                    "?resource wdr:describedBy <http://sublima.computas.com/status/godkjent_av_administrator> .",
                    "?resource ?p ?rest .",
                    "}"}), resultString);


  }


  public void testConvertForm2SparqlSingleValue() {
    // Single value test
    testMap.put("dct:title", testString);
    testMap.put("interface-language", new String[]{"en"}); // this parameter is a magic string
    String resultString = myService.convertForm2Sparql(testMap);
    assertEquals("Expected result and actual result not equal", expectedPrefix + expectedString + "@en .\n?resource ?p ?rest .\n}", resultString);
  }

  public void testConvertForm2SparqlTwoValues() {
    // Single value test
    testMap.put("dct:title", testString);
    testMap.put("dct:description", new String[]{"A Very Light Jet Aircraft under construction."});
    testMap.put("interface-language", new String[]{"en"}); // this parameter is a magic string
    String resultString = myService.convertForm2Sparql(testMap);
    assertEquals("Expected result and actual result not equal", expectedPrefix + "DESCRIBE ?resource ?rest WHERE {\n?resource dct:title \"\"\"Cirrus Personal Jet\"\"\"@en .\n?resource dct:description \"\"\"A Very Light Jet Aircraft under construction.\"\"\"@en .\n?resource ?p ?rest .\n}", resultString);
  }

  public void testConvertForm2SparqlCountTwoValues() {
    // Single value test
    testMap.put("dct:title", testString);
    testMap.put("dct:description", new String[]{"A Very Light Jet Aircraft under construction."});
    testMap.put("interface-language", new String[]{"en"}); // this parameter is a magic string
    String resultString = myService.convertForm2SparqlCount(testMap, 100);
    assertEquals("Expected result and actual result not equal", expectedPrefix + "SELECT DISTINCT ?resource WHERE {\n?resource dct:title \"\"\"Cirrus Personal Jet\"\"\"@en .\n?resource dct:description \"\"\"A Very Light Jet Aircraft under construction.\"\"\"@en .\n}\nOFFSET 99 LIMIT 1", resultString);
  }


  public void testConvertForm2SparqlTwoValuesOneFree() {
    // Single value test
    Form2SparqlService myServicefree = new Form2SparqlService(new String[]{"dct: <http://purl.org/dc/terms/>", "foaf: <http://xmlns.com/foaf/0.1/>"}, new String[]{"dct:title"});
    testMap.put("dct:title", testString);
    testMap.put("dct:description", new String[]{"A Very Light Jet Aircraft under construction."});
    testMap.put("interface-language", new String[]{"en"}); // this parameter is a magic string
    String resultString = myServicefree.convertForm2Sparql(testMap);
    assertEquals("Expected result and actual result not equal", expectedPrefix + "DESCRIBE ?resource ?rest WHERE {\n?resource dct:title ?free1 .\n?free1 <bif:contains> \"\"\"'Cirrus Personal Jet '\"\"\" .\n?resource dct:description \"\"\"A Very Light Jet Aircraft under construction.\"\"\"@en .\n?resource ?p ?rest .\n}", resultString);
  }
   /*
  public void testConvertForm2SparqlTwoValuesSubjectFree() {
    // Single value test
    String expectS = StringUtils.join("\n", new String[]{"PREFIX dct: <http://purl.org/dc/terms/>",
            "PREFIX foaf: <http://xmlns.com/foaf/0.1/>",
            "PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>",
            "PREFIX skos: <http://www.w3.org/2004/02/skos/core#>",
            "DESCRIBE ?resource ?var1 ?var2 ?rest WHERE {",
            "?var2 skos:prefLabel ?free2 .",
            "?free2 <bif:contains> \"\"\"'Dansk*'\"\"\" .",
            "?resource dct:subject ?var2 .",
            "",
            "?resource dct:audience ?var1 .",
            "?var1 rdfs:label \"\"\"Detektor\"\"\"@no .",
            "?resource ?p ?rest .",
            "}"});

    testMap.put("dct:subject/all-labels", new String[]{"Dansk"});
    testMap.put("dct:audience/rdfs:label", new String[]{"Detektor"});
    testMap.put("interface-language", new String[]{"no"}); // this parameter is a magic string
    myService.addFreetextField("dct:title"); // this parameter is a magic string
    myService.addFreetextField("dct:subject/all-labels"); // this parameter is a magic string
    myService.addPrefix("rdfs: <http://www.w3.org/2000/01/rdf-schema#>");
    String resultString = myService.convertForm2Sparql(testMap);
    assertEquals("Expected result and actual result not equal", expectS, resultString);
  }
     */
    
  public void testConvertForm2SparqlTwoValuesBothFree() {
    // Single value test
    Form2SparqlService myServicefree = new Form2SparqlService(new String[]{"dct: <http://purl.org/dc/terms/>", "foaf: <http://xmlns.com/foaf/0.1/>"}, new String[]{"dct:title"});
    testMap.put("dct:title", testString);
    testMap.put("dct:description", new String[]{"A Very Light Jet Aircraft under construction."});
    myServicefree.addFreetextField("dct:description");
    String resultString = myServicefree.convertForm2Sparql(testMap);
    assertEquals("Expected result and actual result not equal", expectedPrefix + "DESCRIBE ?resource ?rest WHERE {\n?resource dct:title ?free1 .\n?free1 <bif:contains> \"\"\"'Cirrus Personal Jet '\"\"\" .\n?resource dct:description ?free2 .\n?free2 <bif:contains> \"\"\"'A Very Light Jet Aircraft under construction. '\"\"\" .\n?resource ?p ?rest .\n}", resultString);
  }

  public void testConvertForm2SPARQLCountDoubleDual() {
    String expectS = "SELECT DISTINCT ?resource WHERE {\n?resource dct:subject ?var2 .\n?var2 rdfs:label \"\"\"Jet\"\"\" .\n?resource dct:publisher ?var1 .\n?var1 foaf:homepage <http://www.cirrusdesign.com/> .\n}\nOFFSET 99 LIMIT 1";
    testMap.put("dct:subject/rdfs:label", new String[]{"Jet"});
    testMap.put("dct:publisher/foaf:homepage", new String[]{"http://www.cirrusdesign.com/"});
    String actual = myService.convertForm2SparqlCount(testMap, 100);
    assertEquals("Expected result and actual result not equal", expectedPrefix + expectS, actual);
  }

  public void testConvertFor2SPARQLDoubleDual() {
    String expectS = "DESCRIBE ?resource ?var1 ?var2 ?rest WHERE {\n?resource dct:subject ?var2 .\n?var2 rdfs:label \"\"\"Jet\"\"\" .\n?resource dct:publisher ?var1 .\n?var1 foaf:homepage <http://www.cirrusdesign.com/> .\n?resource ?p ?rest .\n}";
    testMap.put("dct:subject/rdfs:label", new String[]{"Jet"});
    testMap.put("dct:publisher/foaf:homepage", new String[]{"http://www.cirrusdesign.com/"});
    String actual = myService.convertForm2Sparql(testMap);
    assertEquals("Expected result and actual result not equal", expectedPrefix + expectS, actual);
  }

  public void testConvertForm2SPARQLDoubleDualSELECT() {
    IndexService indexService = new IndexService();
    String expectS = "SELECT ?resource ?object1 ?object2 WHERE {\nOPTIONAL {\n?resource dct:subject ?var1 .\n?var1 rdfs:label ?object1 .\n}\nOPTIONAL {\n?resource dct:publisher ?var2 .\n?var2 foaf:homepage ?object2 .\n}\n}";
    String[] testArr = new String[]{"dct:subject/rdfs:label", "dct:publisher/foaf:homepage"};
    String actual = indexService.getQueryForIndex(testArr, new String[]{"dct: <http://purl.org/dc/terms/>", "foaf: <http://xmlns.com/foaf/0.1/>"});
    assertEquals("Expected result and actual result not equal", expectedPrefix + expectS, actual);
  }

  public void testConvertFor2SPARQLDoubleDualSELECTFixedResource() {
    IndexService indexService = new IndexService();
    String expectS = "SELECT ?object1 ?object2 WHERE {\nOPTIONAL {\n<http://the-jet.com/> dct:subject ?var1 .\n?var1 rdfs:label ?object1 .\n}\nOPTIONAL {\n<http://the-jet.com/> dct:publisher ?var2 .\n?var2 foaf:homepage ?object2 .\n}\n}";
    String[] testArr = new String[]{"dct:subject/rdfs:label", "dct:publisher/foaf:homepage"};
    String actual = indexService.getQueryForIndex(testArr, new String[]{"dct: <http://purl.org/dc/terms/>", "foaf: <http://xmlns.com/foaf/0.1/>"}, "<http://the-jet.com/>");
    assertEquals("Expected result and actual result not equal", expectedPrefix + expectS, actual);
  }

  public void testConvertFor2SPARQLDoubleEmpty() {
    String expectS = "DESCRIBE ?resource ?var1 ?rest WHERE {\n?resource dct:subject ?var1 .\n?var1 rdfs:label \"\"\"Jet\"\"\" .\n\n?resource ?p ?rest .\n}";
    testMap.put("dct:subject/rdfs:label", new String[]{"Jet"});
    testMap.put("dct:publisher", new String[]{""});
    String actual = myService.convertForm2Sparql(testMap);
    assertEquals("Expected result and actual result not equal", expectedPrefix + expectS, actual);
  }

  public void testConvertForm2SPARULSingleValue() throws IOException {
    // Single value test
    String expectS = "DELETE FROM GRAPH <http://www.example.com> { <http://sublima.computas.com/agent/ife> ?p ?o . }\nFROM <http://www.example.com> WHERE { <http://sublima.computas.com/agent/ife> ?p ?o . }\n\nINSERT DATA INTO <http://www.example.com> {\n<http://sublima.computas.com/agent/ife> foaf:name \"\"\"Institute for Energy Technology\"\"\"@en .\n}\n";
    testMap.put("foaf:name", new String[]{"Institute for Energy Technology"});
    testMap.put("interface-language", new String[]{"en"}); // this parameter is a magic string
    testMap.put("the-resource", new String[]{"http://sublima.computas.com/agent/ife"}); // this parameter is a magic string
    String resultString = myService.convertForm2Sparul(testMap);
    assertEquals("Expected result and actual result not equal", expectedPrefix + expectS, resultString);
  }

  public void testConvertForm2SPARULMoreWithLang() throws IOException {
    // Single value test
    String expectS = "DELETE FROM GRAPH <http://www.example.com> { <http://sublima.computas.com/topic/Jet> ?p ?o . }\nFROM <http://www.example.com> WHERE { <http://sublima.computas.com/topic/Jet> ?p ?o . }\n\n" +
            "INSERT DATA INTO <http://www.example.com> {\n" +
            "<http://sublima.computas.com/topic/Jet> skos:altLabel \"\"\"Jet Aircraft\"\"\"@en .\n" +
            "<http://sublima.computas.com/topic/Jet> skos:altLabel \"\"\"Jet\"\"\"@no .\n" +
            "<http://sublima.computas.com/topic/Jet> skos:altLabel \"\"\"Jet Airplane\"\"\"@en .\n" +
            "<http://sublima.computas.com/topic/Jet> skos:altLabel \"\"\"Jetflymaskin\"\"\"@no .\n" +
            "<http://sublima.computas.com/topic/Jet> skos:prefLabel \"\"\"Jet\"\"\"@en .\n" +
            "<http://sublima.computas.com/topic/Jet> skos:prefLabel \"\"\"Jetfly\"\"\"@no .\n" +
            "}\n";
    testMap.put("skos:prefLabel-1", new String[]{"Jet", "http://www.lingvoj.org/lang/en"});
    testMap.put("skos:prefLabel-2", new String[]{"Jetfly", "http://www.lingvoj.org/lang/no"});
    testMap.put("skos:altLabel-1", new String[]{"Jet Aircraft", "http://www.lingvoj.org/lang/en"});
    testMap.put("skos:altLabel-2", new String[]{"Jet", "http://www.lingvoj.org/lang/no"});
    testMap.put("skos:altLabel-3", new String[]{"Jet Airplane", "http://www.lingvoj.org/lang/en"});
    testMap.put("skos:altLabel-4", new String[]{"http://www.lingvoj.org/lang/no", "Jetflymaskin"});
    testMap.put("the-resource", new String[]{"http://sublima.computas.com/topic/Jet"}); // this parameter is a magic string
    myService.addPrefix("skos: <http://www.w3.org/2004/02/skos/core#>");
    String resultString = myService.convertForm2Sparul(testMap);
    assertEquals("Expected result and actual result not equal", expectedPrefix + "PREFIX skos: <http://www.w3.org/2004/02/skos/core#>\n"
            + expectS, resultString);
  }

  public void testConvertForm2SPARULTwoValuesWithLang() throws IOException {
    // Single value test
    String expectS = "DELETE FROM GRAPH <http://www.example.com> { <http://sublima.computas.com/topic/Jet> ?p ?o . }\nFROM <http://www.example.com> WHERE { <http://sublima.computas.com/topic/Jet> ?p ?o . }\n\n" +
            "INSERT DATA INTO <http://www.example.com> {\n<http://sublima.computas.com/topic/Jet> skos:prefLabel \"\"\"Jet\"\"\"@en ." +
            "\n<http://sublima.computas.com/topic/Jet> skos:prefLabel \"\"\"Jetfly\"\"\"@no .\n}\n";
    testMap.put("skos:prefLabel-1", new String[]{"Jet", "http://www.lingvoj.org/lang/en"});
    testMap.put("skos:prefLabel-2", new String[]{"Jetfly", "http://www.lingvoj.org/lang/no"});
    testMap.put("the-resource", new String[]{"http://sublima.computas.com/topic/Jet"}); // this parameter is a magic string
    myService.addPrefix("skos: <http://www.w3.org/2004/02/skos/core#>");
    String resultString = myService.convertForm2Sparul(testMap);
    assertEquals("Expected result and actual result not equal", expectedPrefix + "PREFIX skos: <http://www.w3.org/2004/02/skos/core#>\n"
            + expectS, resultString);
  }

  public void testConvertForm2SPARULTwoValuesOnlyLang() throws IOException {
    // Single value test
    String expectS = "DELETE FROM GRAPH <http://www.example.com> { <http://sublima.computas.com/topic/Jet> ?p ?o . }\nFROM <http://www.example.com> WHERE { <http://sublima.computas.com/topic/Jet> ?p ?o . }\n\n" +
            "INSERT DATA INTO <http://www.example.com> {\n<http://sublima.computas.com/topic/Jet> skos:prefLabel \"\"\"Jet\"\"\"@en .\n}\n";
    testMap.put("skos:prefLabel-1", new String[]{"Jet", "http://www.lingvoj.org/lang/en"});
    testMap.put("skos:prefLabel-2", new String[]{"http://www.lingvoj.org/lang/no"});
    testMap.put("the-resource", new String[]{"http://sublima.computas.com/topic/Jet"}); // this parameter is a magic string
    myService.addPrefix("skos: <http://www.w3.org/2004/02/skos/core#>");
    String resultString = myService.convertForm2Sparul(testMap);
    assertEquals("Expected result and actual result not equal", expectedPrefix + "PREFIX skos: <http://www.w3.org/2004/02/skos/core#>\n"
            + expectS, resultString);
  }


  public void testConvertForm2SPARULSingleValueMakeSubject() throws IOException {
    // Single value test
    String expectS = "DELETE FROM GRAPH <http://www.example.com> { <http://sublima.computas.com/test/pannekaker-med-blabr> ?p ?o . }\nFROM <http://www.example.com> WHERE { <http://sublima.computas.com/test/pannekaker-med-blabr> ?p ?o . }\n\nINSERT DATA INTO <http://www.example.com> {\n<http://sublima.computas.com/test/pannekaker-med-blabr> rdfs:label \"\"\"Pannekaker med blåbær\"\"\"@no .\n}\n";
    testMap.put("rdfs:label", new String[]{"Pannekaker med blåbær"});
    testMap.put("interface-language", new String[]{"no"}); // this parameter is a magic string
    testMap.put("subjecturi-prefix", new String[]{"http://sublima.computas.com/test/"}); // this parameter is a magic string
    testMap.put("title-field", new String[]{"rdfs:label"});
    String resultString = myService.convertForm2Sparul(testMap);
    assertEquals("Expected result and actual result not equal", expectedPrefix + expectS, resultString);
  }

  public void testConvertForm2SPARULSingleValueMakeSubjectWithLang() throws IOException {
    // Single value test
    String expectS = "DELETE FROM GRAPH <http://www.example.com> { <http://sublima.computas.com/test/pannekaker-med-blabr> ?p ?o . }\nFROM <http://www.example.com> WHERE { <http://sublima.computas.com/test/pannekaker-med-blabr> ?p ?o . }\n\nINSERT DATA INTO <http://www.example.com> {\n<http://sublima.computas.com/test/pannekaker-med-blabr> rdfs:label \"\"\"Pannekaker med blåbær\"\"\"@no .\n}\n";
    testMap.put("rdfs:label-1", new String[]{"http://www.lingvoj.org/lang/no", "Pannekaker med blåbær"});
    testMap.put("subjecturi-prefix", new String[]{"http://sublima.computas.com/test/"}); // this parameter is a magic string
    testMap.put("title-field", new String[]{"rdfs:label-1"});
    String resultString = myService.convertForm2Sparul(testMap);
    assertEquals("Expected result and actual result not equal", expectedPrefix + expectS, resultString);
  }

  public void testConvertForm2SPARULTwoValuesEmpty() throws IOException {
    String expectS = "DELETE FROM GRAPH <http://www.example.com> { <http://the-jet.com/> ?p ?o . }\nFROM <http://www.example.com> WHERE { <http://the-jet.com/> ?p ?o . }\n\nINSERT DATA INTO <http://www.example.com> {\n<http://the-jet.com/> dct:title \"\"\"Cirrus personlig jetfly\"\"\"@no .\n}\n";
    testMap.put("dct:description", null);
    testMap.put("dct:title", new String[]{"Cirrus personlig jetfly"});
    testMap.put("interface-language", new String[]{"no"}); // this parameter is a magic string
    testMap.put("the-resource", new String[]{"http://the-jet.com/"}); // this parameter is a magic string
    String resultString = myService.convertForm2Sparul(testMap);
    assertEquals("Expected result and actual result not equal", expectedPrefix + expectS, resultString);
  }

  public void testConvertForm2SPARULTwoValues() throws IOException {
    String expectS = "DELETE FROM GRAPH <http://www.example.com> { <http://the-jet.com/> ?p ?o . }\nFROM <http://www.example.com> WHERE { <http://the-jet.com/> ?p ?o . }\n\nINSERT DATA INTO <http://www.example.com> {\n<http://the-jet.com/> dct:description \"\"\"Et veldig lett jetfly (VLJ) som er under utarbeidelse.\"\"\"@no .\n<http://the-jet.com/> dct:title \"\"\"Cirrus personlig jetfly\"\"\"@no .\n}\n";
    testMap.put("dct:description", new String[]{"Et veldig lett jetfly (VLJ) som er under utarbeidelse."});
    testMap.put("dct:title", new String[]{"Cirrus personlig jetfly"});
    testMap.put("interface-language", new String[]{"no"}); // this parameter is a magic string
    testMap.put("the-resource", new String[]{"http://the-jet.com/"}); // this parameter is a magic string
    String resultString = myService.convertForm2Sparul(testMap);
    assertEquals("Expected result and actual result not equal", expectedPrefix + expectS, resultString);
  }

  public void testAppendPrefixes() {
    myService.addPrefix("rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>");
    assertEquals("Expected result and actual result not equal",
            "PREFIX dct: <http://purl.org/dc/terms/>\nPREFIX foaf: <http://xmlns.com/foaf/0.1/>\nPREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>\n", myService.getPrefixString());

  }

  public void testConvertForm2SPARULEmpty() {
    testMap.put("foaf:name", new String[]{"Institute for Energy Technology"});
    testMap.put("interface-language", new String[]{"en"}); // this parameter is a magic string
    try {
      String resultString = myService.convertForm2Sparul(testMap);
    } catch (IOException tmp) {
      assertTrue(true);
    }
  }


}
