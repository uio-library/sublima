package com.computas.sublima.app.jobs;

import com.computas.sublima.app.service.IndexService;

/**
 * @author: mha
 * Date: 10.aug.2008
 */
public class IndexJob {

  public static void main(String[] args) {

    IndexService indexService = new IndexService();

    boolean indexOnStartup = true;
    String[] searchfields = {"dct:title",
                             "dct:description",
                             "dct:publisher/foaf:name",
                             "dct:subject/skos:prefLabel",
                             "dct:subject/skos:altLabel",
                             "dct:subject/skos:hiddenLabel"};

    String[] prefixes = {"dct: <http://purl.org/dc/terms/>",
                         "foaf: <http://xmlns.com/foaf/0.1/>",
                         "sub: <http://xmlns.computas.com/sublima#>",
                         "skos: <http://www.w3.org/2004/02/skos/core#>"};

    String indexDir = "/tmp/june";
    String indexType = "file";

    indexService.updateResourceSearchfield(indexOnStartup, searchfields, prefixes );
    indexService.createIndex(indexDir, indexType);
  }
}
