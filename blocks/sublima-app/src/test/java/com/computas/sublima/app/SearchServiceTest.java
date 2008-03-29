package com.computas.sublima.app;

import junit.framework.Test;
import junit.framework.TestSuite;
import junit.framework.TestCase;
import com.computas.sublima.app.service.SearchService;

/**
 * SearchService Tester.
 *
 * @author mha
 * @version 1.0
 * @since <pre>03/11/2008</pre>
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
        String testExpected1 = "Henrik* " + booleanOperator + " Ibsen*";
        assertEquals(testExpected1, myService.buildSearchString(test1));

        String test2 = "\"Henrik Ibsen\"";
        String testExpected2 = "\"Henrik Ibsen\"";
        assertEquals(testExpected2, myService.buildSearchString(test2));

        String test3 = "\"Henrik Ibsen\" forfatter";
        String testExpected3 = "\"Henrik Ibsen\" " + booleanOperator + " forfatter*";
        assertEquals(testExpected3, myService.buildSearchString(test3));

        String test4 = "\"Henrik Ibsen\" \"i Skien\"";
        String testExpected4 = "\"Henrik Ibsen\" " + booleanOperator + " \"i Skien\"";
        assertEquals(testExpected4, myService.buildSearchString(test4));

        String test5 = "forfatter \"Henrik Ibsen\"";
        String testExpected5 = "forfatter* " + booleanOperator + " \"Henrik Ibsen\"";
        assertEquals(testExpected5, myService.buildSearchString(test5));

        String test6 = "\"Henrik Ibsen\" bosatt \"i Skien\"";
        String testExpected6 = "\"Henrik Ibsen\" " + booleanOperator + " bosatt* " + booleanOperator + " \"i Skien\"";
        assertEquals(testExpected6, myService.buildSearchString(test6));

        myService.setDefaultBooleanOperator("OR");
        booleanOperator = myService.getDefaultBooleanOperator();

        String test7 = "Henrik Ibsen";
        String testExpected7 = "Henrik* " + booleanOperator + " Ibsen*";
        assertEquals(testExpected7, myService.buildSearchString(test7));

        String test8 = "\"Henrik Ibsen\"";
        String testExpected8 = "\"Henrik Ibsen\"";
        assertEquals(testExpected8, myService.buildSearchString(test8));

        String test9 = "\"Henrik Ibsen\" forfatter";
        String testExpected9 = "\"Henrik Ibsen\" " + booleanOperator + " forfatter*";
        assertEquals(testExpected9, myService.buildSearchString(test9));

        String test10 = "\"Henrik Ibsen\" \"i Skien\"";
        String testExpected10 = "\"Henrik Ibsen\" " + booleanOperator + " \"i Skien\"";
        assertEquals(testExpected10, myService.buildSearchString(test10));

        String test11 = "forfatter \"Henrik Ibsen\"";
        String testExpected11 = "forfatter* " + booleanOperator + " \"Henrik Ibsen\"";
        assertEquals(testExpected11, myService.buildSearchString(test11));

        String test12 = "\"Henrik Ibsen\" bosatt \"i Skien\"";
        String testExpected12 = "\"Henrik Ibsen\" " + booleanOperator + " bosatt* " + booleanOperator + " \"i Skien\"";
        assertEquals(testExpected12, myService.buildSearchString(test12));

    }

    public static Test suite() {
        return new TestSuite(SearchServiceTest.class);
    }
}
