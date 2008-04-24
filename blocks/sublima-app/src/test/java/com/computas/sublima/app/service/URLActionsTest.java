package com.computas.sublima.app.service;

import junit.framework.Test;
import junit.framework.TestSuite;
import junit.framework.TestCase;
import com.computas.sublima.app.service.URLActions;

/**
 *
 * @author <Authors name>
 * @since <pre>04/23/2008</pre>
 * @version 1.0
 */
public class URLActionsTest extends TestCase {

    private URLActions urlactions;

    public URLActionsTest(String name) {
        super(name);
    }

    public void setUp() throws Exception {
        urlactions = new URLActions("http://the-jet.com/");
        super.setUp();
    }

    public void tearDown() throws Exception {
        super.tearDown();
    }

    public void testGetUrl() throws Exception {
        assertEquals("Not equal", "http://the-jet.com/", urlactions.getUrl().toString());
    }

 /*   public void testGetCon() throws Exception {
        //TODO: Test goes here...
    }
*/

    public void testGetCode() throws Exception {
        assertEquals("Not equal", "200", urlactions.getCode());

    }

 /*   public void testGetHTTPmap() throws Exception {
        //TODO: Test goes here...
    }
*/
    public static Test suite() {
        return new TestSuite(URLActionsTest.class);
    }
}
