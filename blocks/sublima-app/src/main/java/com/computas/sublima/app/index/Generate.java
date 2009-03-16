package com.computas.sublima.app.index;

import java.util.ArrayList;

/**
 * @author: mha
 * Date: 18.feb.2009
 */
public class Generate {

  private FreetextTriples ft = new FreetextTriples();
  private GenerateUtils gu = new GenerateUtils();

  public Generate() {
    // empty constructor
  }

  public void generateIndexForResources(boolean indexExternalContent, String basegraph, String[] fieldstoindex, String[] prefixes) {
    EndpointSaver save = new EndpointSaver(basegraph, 250);
    save.DropPropertyForType("?s", "<http://xmlns.computas.com/sublima#literals>", "<http://xmlns.computas.com/sublima#Resource>");

    if (indexExternalContent) {
      save.DropPropertyForType("?s", "<http://xmlns.computas.com/sublima#externalliterals>", "<http://xmlns.computas.com/sublima#Resource>");
    }
    ArrayList<String> uris = gu.getListOfResourceURIs();

    int i = 1;
    int size = uris.size();
    for (String uri : uris) {
      String freetext = generateInternalFreetextForSingleResource(uri, fieldstoindex, prefixes, new String[]{basegraph}, indexExternalContent);
      if (freetext != null) {
        save.Add(freetext);
      }
      System.out.println("Indexing resource " + i + " of " + size);
      i++;
    }

    save.Flush();
    save = null;
    gu.updateIndexStatistics("resources");
  }

  public void generateIndexForResource(String uri, String basegraph, String[] fieldstoindex, String[] prefixes, boolean indexExternalContent) {
    if (!uri.startsWith("<") && !uri.endsWith(">")) {
      uri = "<" + uri + ">";
    }

    EndpointSaver save = new EndpointSaver(basegraph, 250);
    save.DropPropertyForType(uri, "<http://xmlns.computas.com/sublima#literals>", "<http://xmlns.computas.com/sublima#Resource>");
    String freetext = generateInternalFreetextForSingleResource(uri, fieldstoindex, prefixes, new String[]{basegraph}, indexExternalContent);

    if (freetext != null) {
      save.Add(freetext);
      save.Flush();
    }
    save = null;
  }

  public void generateIndexForTopics(String basegraph, String[] fieldstoindex, String[] prefixes) {
    EndpointSaver save = new EndpointSaver(basegraph, 250);
    save.DropPropertyForType("?s", "<http://xmlns.computas.com/sublima#literals>", "<http://www.w3.org/2004/02/skos/core#Concept>");
    ArrayList<String> uris = gu.getListOfTopicURIs();

    int i = 1;
    int size = uris.size();

    for (String uri : uris) {
      String freetext = generateFreetextForSingleTopic(uri, fieldstoindex, prefixes, new String[]{basegraph});
      if (freetext != null) {
        save.Add(freetext);
      }

      System.out.println("Indexing topic " + i + " of " + size);
      i++;
    }

    save.Flush();
    save = null;

    gu.updateIndexStatistics("topics");
  }

  public void generateIndexForTopic(String uri, String basegraph, String[] fieldstoindex, String[] prefixes) {
    if (!uri.startsWith("<") && !uri.endsWith(">")) {
      uri = "<" + uri + ">";
    }

    EndpointSaver save = new EndpointSaver(basegraph, 250);
    save.DropPropertyForType(uri, "<http://xmlns.computas.com/sublima#literals>", "<http://www.w3.org/2004/02/skos/core#Concept>");

    String freetext = generateFreetextForSingleTopic(uri, fieldstoindex, prefixes, new String[]{basegraph});
    if (freetext != null) {
      save.Add(freetext);
      save.Flush();
    }
    save = null;
  }

  public String generateInternalFreetextForSingleResource(String uri, String[] freetext, String[] prefixes, String[] graphs, boolean indexExternalContent) {
    return ft.generateFreetextTripleForURI(uri, freetext, prefixes, graphs, indexExternalContent);
  }

  public String generateFreetextForSingleTopic(String uri, String[] freetext, String[] prefixes, String[] graphs) {
    return ft.generateFreetextTripleForURI(uri, freetext, prefixes, graphs, false);
  }
}
