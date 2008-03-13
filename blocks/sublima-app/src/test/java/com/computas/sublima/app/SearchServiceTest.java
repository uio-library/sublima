package com.computas.sublima.app;

import junit.framework.Test;
import junit.framework.TestSuite;
import junit.framework.TestCase;
import com.computas.sublima.app.service.SearchService;

/**
 * SearchService Tester.
 *
 * @author mha
 * @since <pre>03/11/2008</pre>
 * @version 1.0
 */
public class SearchServiceTest extends TestCase {

    private SearchService myService;

    public SearchServiceTest(String name) {
        super(name);
    }

    public void setUp() throws Exception {
        myService = new SearchService("AND");
        super.setUp();
        
    }

    public void tearDown() throws Exception {
        super.tearDown();
    }

    public void testBuildSearchString() throws Exception {
      String booleanOperator = myService.getDefaultBooleanOperator();

      String test1 = "Henrik Ibsen";
      String testExpected1 = "Henrik " + booleanOperator + " Ibsen";
      assertEquals(testExpected1, myService.buildSearchString(test1));

      String test2 = "\"Henrik Ibsen\"";
      String testExpected2 = "\"Henrik Ibsen\"";
      assertEquals(testExpected2, myService.buildSearchString(test2));

      String test3 = "\"Henrik Ibsen\" forfatter";
      String testExpected3 = "\"Henrik Ibsen\" " + booleanOperator + " forfatter";
      assertEquals(testExpected3, myService.buildSearchString(test3));

      String test4 = "\"Henrik Ibsen\" \"i Skien\"";
      String testExpected4 = "\"Henrik Ibsen\" " + booleanOperator + " \"i Skien\"";
      assertEquals(testExpected4, myService.buildSearchString(test4));

      String test5 = "forfatter \"Henrik Ibsen\"";
      String testExpected5 = "forfatter " + booleanOperator + " \"Henrik Ibsen\"";
      assertEquals(testExpected5, myService.buildSearchString(test5));

      String test6 = "\"Henrik Ibsen\" bosatt \"i Skien\"";
      String testExpected6 = "\"Henrik Ibsen\" " + booleanOperator + " bosatt " + booleanOperator + " \"i Skien\"";
      assertEquals(testExpected6, myService.buildSearchString(test6));
    }

    public static Test suite() {
        return new TestSuite(SearchServiceTest.class);
    }
}
