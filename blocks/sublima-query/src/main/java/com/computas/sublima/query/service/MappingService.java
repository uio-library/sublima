package com.computas.sublima.query.service;

import org.apache.log4j.Logger;

import java.io.UnsupportedEncodingException;

/**
 * @author: mha
 * Date: 03.feb.2009
 */
public class MappingService {

  private static Logger logger = Logger.getLogger(MappingService.class);

  /**
   * This method takes a String and replaces all characters based on a mapping table in the properties file
   *
   * @param text
   * @return
   */

  public String charactermapping(String text) {


    try {
      // Property-files in Java is not UTF-8 so...
      String property = new String(SettingsService.getProperty("sublima.search.mapping").getBytes("ISO-8859-1"), "UTF-8");
      String[] mappings = property.split("--");

      for (String mapping : mappings) {
        String[] map = mapping.split("->");
        String char1 = map[0].equals("__") ? " " : map[0] ;
        String char2 = map[1].equals("__") ? " " : map[1] ;
        text = text.replace(char1, char2);
      }
    } catch (UnsupportedEncodingException e) {
      logger.error("Experienced an exception when trying to read the mappings from sublima-query.properties");

    }

    return text;
  }
}
