package com.computas.sublima.query.service;


import junit.framework.Test;
import junit.framework.TestSuite;
import junit.framework.TestCase;
import org.z3950.zing.cql.CQLParseException;

import java.io.IOException;

import com.computas.sublima.query.exceptions.UnsupportedCQLFeatureException;

/**
 * CQL2SPARQL Tester.
 *
 * @author <Authors name>
 * @since <pre>08/05/2008</pre>
 * @version 1.0
 */
public class CQL2SPARQLTest extends TestCase {
    public CQL2SPARQLTest(String name) {
        super(name);
    }

    public void setUp() throws Exception {
        super.setUp();
    }

    public void tearDown() throws Exception {
        super.tearDown();
    }

    public static Test suite() {
        return new TestSuite(CQL2SPARQLTest.class);
    }

    public void testTerm() throws CQLParseException, IOException, UnsupportedCQLFeatureException {
        CQL2SPARQL translator = new CQL2SPARQL("vondt");
        assertEquals("Query not as expected:", "vondt+", translator.Level0());
    }

     public void testIndexAndTerm() throws CQLParseException, IOException {
        CQL2SPARQL translator = new CQL2SPARQL("dc.title=vondt");
         try {
             String out = translator.Level0();
		 }	catch (UnsupportedCQLFeatureException tmp) {
			 assertTrue(true);
		 }
    }


}
