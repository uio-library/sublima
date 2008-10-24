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
public class SparqlResultsTest extends TestCase {

  private URL url;
  private HttpURLConnection huc;
  private static final String JOSEKI_URL = "http://localhost:8180/sublima-webapp-1.0-SNAPSHOT/";
  private static final String JOSEKI_ACTION = "sparql?query=";
  private static final String SPARQL_QUERY = "PREFIX  dct: <http://purl.org/dc/terms/>\n" +
          "\n" +
          "CONSTRUCT \n" +
          "{ <http://the-jet.com/> dct:title ?var } \n" +
          "WHERE { <http://the-jet.com/> dct:title ?var }";

  private static final String EXPECTED_SPARQL_RESULT = "<?xml version=\"1.0\"?>" +
          "<rdf:RDF    xmlns:lingvoj=\"http://www.lingvoj.org/ontology#\"    " +
          "xmlns:dcmitype=\"http://purl.org/dc/dcmitype/\"    " +
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
          "xmlns:daml=\"http://www.daml.org/2001/03/daml+oil#\"    " +
          "xmlns:sub=\"http://xmlns.computas.com/sublima#\">  " +
          "<rdf:Description rdf:about=\"http://the-jet.com/\">    " +
          "<dct:title xml:lang=\"en\">Cirrus Personal Jet</dct:title>  " +
          "</rdf:Description></rdf:RDF>";

  public SparqlResultsTest(String name) {
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
    return new TestSuite(SparqlResultsTest.class);
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
    url = new URL(JOSEKI_URL + JOSEKI_ACTION + URLEncoder.encode(SPARQL_QUERY, "UTF-8"));
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
