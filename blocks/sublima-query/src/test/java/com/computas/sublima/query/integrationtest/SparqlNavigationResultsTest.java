package com.computas.sublima.query.integrationtest;

import junit.framework.Test;
import junit.framework.TestCase;
import junit.framework.TestSuite;

import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;

/**
 * JosekiTest. This class tests the connection to the Joseki standalone servlet,
 * and checks that a SPARQL query returns the expected result.
 *
 * @author Magnus Haraldsen Amundsen
 * @version 1.0
 * @since <pre>01/03/2008</pre>
 */
public class SparqlNavigationResultsTest extends TestCase {

  private URL url;
  private HttpURLConnection huc;
  private static final String JOSEKI_URL = "http://localhost:8180/sublima-webapp-1.0-SNAPSHOT/";
  private static final String JOSEKI_ACTION = "sparql?query=";
  private static final String SUBJECT = "<http://sublima.computas.com/topic-instance/Jet>";
  private static final String SPARQL_CONSTRUCT_QUERY =
          "prefix rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>\n" +
                  "prefix rdfs: <http://www.w3.org/2000/01/rdf-schema#>\n" +
                  "prefix owl: <http://www.w3.org/2002/07/owl#>\n" +
                  "prefix foaf: <http://xmlns.com/foaf/0.1/>\n" +
                  "prefix lingvoj: <http://www.lingvoj.org/ontology#>\n" +
                  "prefix dcmitype: <http://purl.org/dc/dcmitype/>\n" +
                  "prefix dct: <http://purl.org/dc/terms/>\n" +
                  "prefix sub: <http://xmlns.computas.com/sublima#>\n" +
                  "prefix wdr: <http://www.w3.org/2007/05/powder#>\n" +
                  "prefix sioc: <http://rdfs.org/sioc/ns#>\n" +
                  "prefix skos: <http://www.w3.org/2004/02/skos/core#>\n" +
                  "CONSTRUCT {\n" +
                  SUBJECT + " skos:prefLabel ?label ; \n" +
                  " a skos:Concept;\n" +
                  " skos:altLabel ?synLabel ;\n" +
                  " skos:related ?relSub ;\n" +
                  " skos:broader ?btSub ;\n" +
                  " skos:narrower ?ntSub .\n" +
                  " ?relSub skos:prefLabel ?relLabel ;\n" +
                  " a skos:Concept .\n" +
                  " ?btSub skos:prefLabel ?btLabel ;\n" +
                  " a skos:Concept .\n" +
                  " ?ntSub skos:prefLabel ?ntLabel ;\n" +
                  " a skos:Concept .\n" +
                  " }\n" +
                  " WHERE {\n" +
                  SUBJECT + " rdfs:label ?label .\n" +
                  SUBJECT + " a ?class .\n" +
                  " OPTIONAL { " + SUBJECT + " <http://xmlns.computas.com/sublima#synonym> ?synLabel  . }\n" +
                  " OPTIONAL { " + SUBJECT + " ?prop ?relSub .\n" +
                  " ?relSub rdfs:label ?relLabel . }\n" +
                  " OPTIONAL { ?class rdfs:subClassOf ?btClass .\n" +
                  " ?btSub a ?btClass ;\n" +
                  " rdfs:label ?btLabel . }\n" +
                  " OPTIONAL { ?ntClass rdfs:subClassOf ?class .\n" +
                  " ?ntSub a ?ntClass .\n" +
                  " ?ntClass rdfs:label ?ntLabel . } }";

  private static final String EXPECTED_SPARQL_RESULT = "<?xml version=\"1.0\"?>" +
          "<rdf:RDF    " +
          "xmlns:dcmitype=\"http://purl.org/dc/dcmitype/\"    " +
          "xmlns:lingvoj=\"http://www.lingvoj.org/ontology#\"    " +
          "xmlns:topic=\"http://sublima.computas.com/topic/\"    " +
          "xmlns:foaf=\"http://xmlns.com/foaf/0.1/\"    " +
          "xmlns:rdfs=\"http://www.w3.org/2000/01/rdf-schema#\"    " +
          "xmlns:owl=\"http://www.w3.org/2002/07/owl#\"    " +
          "xmlns:p1=\"http://www.owl-ontologies.com/assert.owl#\"    " +
          "xmlns=\"http://sublima.computas.com/topic-instance/\"    " +
          "xmlns:dct=\"http://purl.org/dc/terms/\"    " +
          "xmlns:rdf=\"http://www.w3.org/1999/02/22-rdf-syntax-ns#\"    " +
          "xmlns:protege=\"http://protege.stanford.edu/plugins/owl/protege#\"    " +
          "xmlns:xsd=\"http://www.w3.org/2001/XMLSchema#\"    " +
          "xmlns:wdr=\"http://www.w3.org/2007/05/powder#\"    " +
          "xmlns:sioc=\"http://rdfs.org/sioc/ns#\"    " +
          "xmlns:skos=\"http://www.w3.org/2004/02/skos/core#\"    " +
          "xmlns:daml=\"http://www.daml.org/2001/03/daml+oil#\"    " +
          "xmlns:sub=\"http://xmlns.computas.com/sublima#\">  " +
          "<skos:Concept rdf:about=\"http://sublima.computas.com/topic-instance/Jet\">    " +
          "<skos:altLabel xml:lang=\"no\">Jetfly</skos:altLabel>    " +
          "<skos:prefLabel xml:lang=\"no\">Jet</skos:prefLabel>    " +
          "<skos:prefLabel xml:lang=\"en\">Jet</skos:prefLabel>    " +
          "<skos:broader>      " +
          "<skos:Concept rdf:about=\"http://sublima.computas.com/topic-instance/Airplane\">        " +
          "<skos:prefLabel xml:lang=\"no\">Fly</skos:prefLabel>      " +
          "</skos:Concept>    " +
          "</skos:broader>    " +
          "<skos:related>      " +
          "<skos:Concept rdf:about=\"http://sublima.computas.com/topic-instance/JetEngine\">        " +
          "<skos:prefLabel xml:lang=\"no\">Jetmotor</skos:prefLabel>      " +
          "</skos:Concept>    " +
          "</skos:related>  " +
          "</skos:Concept></rdf:RDF>";

  public SparqlNavigationResultsTest(String name) {
    super(name);
  }

  public void setUp() throws Exception {
    super.setUp();

  }

  public void tearDown() throws Exception {
    super.tearDown();
    huc.disconnect();
  }

  public static Test suite() {
    return new TestSuite(SparqlNavigationResultsTest.class);
  }

  /**
   * Tests that a connection to the webapp exists.
   * Uses /search since / gives a failure with Cocoon.
   * todo: Fix the URL so that / works
   */
  public void testConnection() throws Exception {
    url = new URL(JOSEKI_URL + "search");
    huc = (HttpURLConnection) url.openConnection();

    assertEquals("Cannot connect to " + JOSEKI_URL + "search", huc.getResponseCode(), huc.HTTP_OK);

  }

  public void testSPARQLquery() throws Exception {
    url = new URL(JOSEKI_URL + JOSEKI_ACTION + URLEncoder.encode(SPARQL_CONSTRUCT_QUERY, "UTF-8"));
    huc = (HttpURLConnection) url.openConnection();

    InputStream bodyInputStream = huc.getInputStream();
    BufferedReader rdr = new BufferedReader(new InputStreamReader(bodyInputStream));
    String line;
    StringBuilder sb = new StringBuilder();
    while ((line = rdr.readLine()) != null) {
      sb.append(line);
    }
    EXPECTED_SPARQL_RESULT.equalsIgnoreCase(sb.toString());
    assertEquals("Expected result and actual result does not match", EXPECTED_SPARQL_RESULT, sb.toString());
  }
}
