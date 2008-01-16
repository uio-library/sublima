package com.computas.sublima.integrationtests;

import junit.framework.Test;
import junit.framework.TestSuite;
import junit.framework.TestCase;

import java.net.URL;
import java.net.URLEncoder;
import java.net.HttpURLConnection;
import java.io.InputStream;
import java.io.BufferedReader;
import java.io.InputStreamReader;

import com.computas.sublima.util.TestUtils;

/**
 * SparqlUpdateIntegrationTest. This class tests the connection to the Joseki standalone servlet,
 * and checks that a SPARQL query returns the expected result.
 *
 * @author Magnus Haraldsen Amundsen
 * @version 1.0
 * @since <pre>01/03/2008</pre>
 */
public class SparqlUpdateIntegrationTest extends TestCase {

  private TestUtils myUtils;
  private URL url;
  private HttpURLConnection huc;
  private HttpURLConnection hUpdate;
  private HttpURLConnection hQuery;
  private static final String JOSEKI_URL = "http://localhost:8180/sublima-1.0-SNAPSHOT/";
  private static final String JOSEKI_ACTION = "sparql?query=";
  private static final String SPARUL_URL = "http://localhost:8180/sublima-1.0-SNAPSHOT/";
  private static final String SPARUL_ACTION = "update?query=";
  private static final String SPARQLUPDATE_QUERY = "PREFIX foaf: <http://xmlns.com/foaf/0.1/> " +
                                                   "INSERT { <http://sublima.computas.com/agent/ife> foaf:name \"Institut for der Energitekniken\"@de }";

  private static final String SPARQL_QUERY = "PREFIX dc: <http://purl.org/dc/elements/1.1/>\n" +
                                             "PREFIX foaf: <http://xmlns.com/foaf/0.1/>\n" +
                                             "SELECT ?resource\n" +
                                             "WHERE { \n" +
                                             "?resource dc:publisher ?publisher .\n" +
                                             "?publisher foaf:name \"Institut for der Energitekniken\"@de .\n" +
                                             "}";

  private static final String EXPECTED_SPARQL_RESULT =  "<?xml version=\"1.0\"?>" +
                                                        "<rdf:RDF    " +
                                                        "xmlns:lingvoj=\"http://www.lingvoj.org/ontology#\"    " +
                                                        "xmlns:dcmitype=\"http://purl.org/dc/dcmitype/\"    " +
                                                        "xmlns:foaf=\"http://xmlns.com/foaf/0.1/\"    " +
                                                        "xmlns:rdfs=\"http://www.w3.org/2000/01/rdf-schema#\"    " +
                                                        "xmlns:owl=\"http://www.w3.org/2002/07/owl#\"    " +
                                                        "xmlns:ls=\"http://sublima.computas.no/ns/x#\"    " +
                                                        "xmlns:p1=\"http://www.owl-ontologies.com/assert.owl#\"    " +
                                                        "xmlns=\"http://sublima.computas.com/topic/\"    " +
                                                        "xmlns:dct=\"http://purl.org/dc/terms/\"    " +
                                                        "xmlns:rdf=\"http://www.w3.org/1999/02/22-rdf-syntax-ns#\"    " +
                                                        "xmlns:protege=\"http://protege.stanford.edu/plugins/owl/protege#\"    " +
                                                        "xmlns:xsd=\"http://www.w3.org/2001/XMLSchema#\"    " +
                                                        "xmlns:wdr=\"http://www.w3.org/2007/05/powder#\"    " +
                                                        "xmlns:sioc=\"http://rdfs.org/sioc/ns#\"    " +
                                                        "xmlns:dc=\"http://purl.org/dc/elements/1.1/\">  " +
                                                        "<rdf:Description rdf:about=\"http://the-jet.com/\">    " +
                                                        "<dc:title xml:lang=\"en\">Cirrus Personal Jet</dc:title>  " +
                                                        "</rdf:Description></rdf:RDF>";

  public SparqlUpdateIntegrationTest(String name) {
    super(name);
  }

  public void setUp() throws Exception {
    super.setUp();
    myUtils = new TestUtils();
  }

  public void tearDown() throws Exception {
    super.tearDown();
    //huc.disconnect();
  }

  public static Test suite() {
    return new TestSuite(SparqlUpdateIntegrationTest.class);
  }

  /**
   * Tests that a connection to webapp exists
   */
  public void testConnectionToWebapp() throws Exception {
    url = new URL(SPARUL_URL);
    huc = (HttpURLConnection) url.openConnection();


    assertEquals("Cannot connect to " + SPARUL_URL, huc.getResponseCode(), huc.HTTP_OK);
    huc.disconnect();
  }
  /**
   *  PSEUDO:
   *  1. Nullstill DB
   *  2. Kjør inn testdata
   *  3. Kjør update/insert
   *  4. Kjør spørring og sjekk at det har blitt oppdatert
   */
  public void testSPARQLUpdateQuery() throws Exception {
    myUtils.removeModel();
    myUtils.createModel("file:src/main/resources/rdf-data/environment-ontology.n3", "N3");
    myUtils.createModel("file:src/main/resources/rdf-data/information-model.n3", "N3");
    myUtils.createModel("file:src/main/resources/rdf-data/test-data.n3", "N3");

    url = new URL(SPARUL_URL + SPARUL_ACTION + URLEncoder.encode(SPARQLUPDATE_QUERY, "UTF-8"));
    hUpdate = (HttpURLConnection) url.openConnection();
    hUpdate.getResponseCode();
   // hUpdate.getInputStream();

    url = new URL(JOSEKI_URL + JOSEKI_ACTION + URLEncoder.encode(SPARQL_QUERY, "UTF-8"));
    hQuery = (HttpURLConnection) url.openConnection();

    InputStream bodyInputStream = hQuery.getInputStream();
    BufferedReader rdr = new BufferedReader(new InputStreamReader(bodyInputStream));
    String line;
    StringBuffer sb = new StringBuffer();
    while ((line = rdr.readLine()) != null) {
      sb.append(line);
    }
    assertEquals("Expected result and actual result does not match", EXPECTED_SPARQL_RESULT, sb.toString());
  }
}

