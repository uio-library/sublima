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

/**
 * JosekiTest. This class tests the connection to the Joseki standalone servlet,
 * and checks that a SPARQL query returns the expected result.
 *
 * @author Magnus Haraldsen Amundsen
 * @version 1.0
 * @since <pre>01/03/2008</pre>
 */
public class SparqlUpdateIntegrationTest extends TestCase {

  private URL url;
  private HttpURLConnection huc;
  private static final String SPARUL_URL = "http://localhost:8180/sublima-1.0-SNAPSHOT/";
  private static final String SPARUL_ACTION = "update?query=";
  private static final String SPARQLUPDATE_QUERY = "PREFIX  dc: <http://purl.org/dc/elements/1.1/>\n" +
                                              "\n" +
                                              "CONSTRUCT \n" +
                                              "{ <http://the-jet.com/> dc:title ?var } \n" +
                                              "WHERE { <http://the-jet.com/> dc:title ?var }";

  public SparqlUpdateIntegrationTest(String name) {
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
    return new TestSuite(JosekiTest.class);
  }

  /**
   * Tests that a connection to Joseki exists
   */
  public void testConnection() throws Exception {
    url = new URL(SPARUL_URL);
    huc = (HttpURLConnection) url.openConnection();

    assertEquals("Cannot connect to " + SPARUL_URL, huc.getResponseCode(), huc.HTTP_OK);

  }
  /*
  public void testSPARQLquery() throws Exception {
    url = new URL(SPARUL_URL + SPARUL_ACTION + URLEncoder.encode(SPARQLUPDATE_QUERY, "UTF-8"));
    huc = (HttpURLConnection) url.openConnection();

    InputStream bodyInputStream = huc.getInputStream();
    BufferedReader rdr = new BufferedReader(new InputStreamReader(bodyInputStream));
    String line;
    StringBuffer sb = new StringBuffer();
    while ((line = rdr.readLine()) != null) {
      sb.append(line);
    }
    assertEquals("Expected result and actual result does not match", EXPECTED_SPARQL_RESULT, sb.toString());
  } */
}

