package com.computas.sublima.app;

import org.apache.cocoon.configuration.Settings;
import org.apache.log4j.Logger;

import java.util.ArrayList;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * A service class with methods to support advanced and free text search
 *
 * @author mha
 * @version 1.0
 */

public class SearchService {

  private static Logger logger = Logger.getLogger(SearchService.class);

  private String defaultBooleanOperator;

  public SearchService() {
  }

  public SearchService(String booleanOperator) {
    setDefaultBooleanOperator(booleanOperator);
  }


  /**
   * Takes the search string and transform it using the default boolean operator AND/OR
   * This is done programmaticly since LARQ does not support setting another default boolean operator than OR
   *
   * @param searchstring The given search string
   * @return A transformed search string, using AND/OR based on the configuration
   */
  //todo Get the regex right, and more advanced check on search string. Ie. - + NOT
  public String buildSearchString(String searchstring) {

    //If the default is set to ORD, just return since OR is default with LARQ
    if (defaultBooleanOperator.equalsIgnoreCase("OR")) {
      return searchstring;
    }

    Pattern p = Pattern.compile("(\\w+)|(\\\"[^\\\"]+\\\")");
    Matcher m = p.matcher(searchstring);
    List<String> terms = new ArrayList<String>();
    while (m.find()) {
      terms.add(m.group());
    }
    String actual = "";
    for (String term : terms) {
      actual += ("".equals(actual) ? "" : " " + defaultBooleanOperator + " ") + term;
    }

    return actual;
  }

  public void setDefaultBooleanOperator(String defaultBooleanOperator) {
    this.defaultBooleanOperator = defaultBooleanOperator;
  }

  public String getDefaultBooleanOperator() {
    return this.defaultBooleanOperator;
  }
}
