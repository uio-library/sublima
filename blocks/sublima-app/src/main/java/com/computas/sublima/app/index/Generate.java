package com.computas.sublima.app.index;

/**
 * @author: mha
 * Date: 18.feb.2009
 */
public class Generate {

  private FreetextTriples ft = new FreetextTriples();

  public Generate() {
    // empty constructor
  }

  public String generateFreetextForSingleResource(String uri, String[] freetext, String[] prefixes, String[] graphs) {
    return ft.generateFreetextTripleForURI(uri, freetext, prefixes, graphs);
  }
}
