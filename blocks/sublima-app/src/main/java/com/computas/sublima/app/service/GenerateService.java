package com.computas.sublima.app.service;

import com.computas.sublima.query.impl.DefaultSparulDispatcher;
import com.computas.sublima.query.service.SettingsService;
import com.computas.sublima.app.index.Generate;

/**
 * @author: mha
 * Date: 18.feb.2009
 */
public class GenerateService {

  private Generate gen = new Generate();
  private DefaultSparulDispatcher sparul = new DefaultSparulDispatcher();
  private String[] freetext;
  private String[] prefixes;

  public GenerateService() {
    this.freetext = SettingsService.getProperty("sublima.resource.searchfields").split(";");
    this.prefixes = SettingsService.getProperty("sublima.prefixes").split(";");
  }

  public boolean generateAllForSingle(String uri, String archive) {
    String[] archivearray = archive.split("/");
    String archiveprefix = archivearray[archivearray.length - 1];

    return insertTriples(uri, generateFreetextForSingle(uri, archive), SettingsService.getProperty("sublima.basegraph") + "/index/" + archiveprefix);
  }

  public String generateFreetextForSingle(String uri, String archive) {
    return gen.generateFreetextForSingleResource(uri, freetext, prefixes, new String[] {archive}, false);

  }

  public boolean insertTriples(String uri, String triples, String archive) {
    StringBuilder query = new StringBuilder();

    if (triples != null && !triples.isEmpty()) {

      query.append("DELETE FROM GRAPH <").append(archive).append(">\n{<").append(uri).append("> ?p ?o . } WHERE {<").append(uri).append("> ?p ?o . }");
      query.append("INSERT DATA INTO <").append(archive).append(">\n {");
      query.append(triples);
      query.append("}\n");

      return sparul.query(query.toString());
    } else {
      return true;
    }
  }

}
