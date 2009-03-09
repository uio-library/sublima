package com.computas.sublima.app.index;

import com.computas.sublima.query.service.SettingsService;

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

  public void generateIndexForResources(boolean indexExternalContent) {

    EndpointSaver save = new EndpointSaver(SettingsService.getProperty("sublima.basegraph"), 250);
    save.DropPropertyForType("?s", "<http://xmlns.computas.com/sublima#literals>", "<http://xmlns.computas.com/sublima#Resource>");

    if (indexExternalContent) {
      save.DropPropertyForType("?s","<http://xmlns.computas.com/sublima#externalliterals>", "<http://xmlns.computas.com/sublima#Resource>");
    }
    ArrayList<String> uris = gu.getListOfResourceURIs();

    for (String uri : uris) {
      String freetext = generateInternalFreetextForSingleResource(uri, gu.getResourceFreetextFieldsToIndex(), gu.getPrefixes(), new String[]{SettingsService.getProperty("sublima.basegraph")}, indexExternalContent);
      save.Add(freetext);
    }

    save.Flush();

    save = null;
  }

  public void generateIndexForResource(String uri) {
    if (!uri.startsWith("<") && !uri.endsWith(">")) {
      uri = "<" + uri + ">";
    }

    EndpointSaver save = new EndpointSaver(SettingsService.getProperty("sublima.basegraph"), 250);
    save.DropPropertyForType(uri, "<http://xmlns.computas.com/sublima#literals>", "<http://xmlns.computas.com/sublima#Resource>");

    String freetext = generateInternalFreetextForSingleResource(uri, gu.getResourceFreetextFieldsToIndex(), gu.getPrefixes(), new String[]{SettingsService.getProperty("sublima.basegraph")}, false);
    save.Add(freetext);
    save.Flush();
    save = null;
  }

  public void generateIndexForTopics() {
    EndpointSaver save = new EndpointSaver(SettingsService.getProperty("sublima.basegraph"), 250);
    save.DropPropertyForType("?s", "<http://xmlns.computas.com/sublima#literals>", "<http://www.w3.org/2004/02/skos/core#Concept>");
    ArrayList<String> uris = gu.getListOfTopicURIs();

    for (String uri : uris) {
      String freetext = generateFreetextForSingleTopic(uri, gu.getResourceFreetextFieldsToIndex(), gu.getPrefixes(), new String[]{SettingsService.getProperty("sublima.basegraph")});
      save.Add(freetext);
    }

    save.Flush();
    save = null;
  }

  public void generateIndexForTopic(String uri) {
    if (!uri.startsWith("<") && !uri.endsWith(">")) {
      uri = "<" + uri + ">";
    }

    EndpointSaver save = new EndpointSaver(SettingsService.getProperty("sublima.basegraph"), 250);
    save.DropPropertyForType(uri, "<http://xmlns.computas.com/sublima#literals>", "<http://www.w3.org/2004/02/skos/core#Concept>");

    String freetext = generateFreetextForSingleTopic(uri, gu.getResourceFreetextFieldsToIndex(), gu.getPrefixes(), new String[]{SettingsService.getProperty("sublima.basegraph")});
    save.Add(freetext);
    save.Flush();
    save = null;
  }

  public String generateInternalFreetextForSingleResource(String uri, String[] freetext, String[] prefixes, String[] graphs, boolean indexExternalContent) {
    return ft.generateFreetextTripleForURI(uri, freetext, prefixes, graphs, indexExternalContent);
  }

  public String generateFreetextForSingleTopic(String uri, String[] freetext, String[] prefixes, String[] graphs) {
    return ft.generateFreetextTripleForURI(uri, freetext, prefixes, graphs, false);
  }
}
