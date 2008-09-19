package com.computas.sublima.app.jobs;

import com.computas.sublima.app.service.IndexService;

/**
 * @author: mha
 * Date: 10.aug.2008
 */
public class IndexJob {

  public static void main(String[] args) {

    String usageString = "usage: IndexJob -indexExternalContent [true|false] -searchfields dct:title;dct:description -prefixes dct:<http://purl.org/dc/terms/;foaf:<http://xmlns.com/foaf/0.1/> -indextype [file|memory] [-indexdir directory]";

    boolean indexExternal = false;
    String[] searchfields = null;

    /*
      {"dct:title",
       "dct:description",
       "dct:publisher/foaf:name",
       "dct:subject/skos:prefLabel",
       "dct:subject/skos:altLabel",
       "dct:subject/skos:hiddenLabel"};
    */

    String[] prefixes = null;

    /*
      {"dct: <http://purl.org/dc/terms/>",
       "foaf: <http://xmlns.com/foaf/0.1/>",
       "sub: <http://xmlns.computas.com/sublima#>",
       "skos: <http://www.w3.org/2004/02/skos/core#>"};
    */

    String indexDir = ""; //"/tmp/june";
    String indexType = ""; //"file";

    String argument;

    for (int i = 0; i < args.length; i++) {
      argument = args[i];

      if (argument.equalsIgnoreCase("-indexExternalContent")) {
        if (i < args.length + 1) {
          if (args[i + 1].equalsIgnoreCase("true") || args[i + 1].equalsIgnoreCase("false")) {
            indexExternal = Boolean.valueOf(args[i + 1]);
          } else {
            System.err.println("-indexExternalContent requires true or false");
            System.err.println(usageString);
            return;
          }
        }

        if (argument.equals("-searchfields")) {
          if (i < args.length + 1) {
            searchfields = args[i + 1].split(";");
          } else {
            System.err.println("-searchfields requires a semicolon separated string of searchfields");
            System.err.println(usageString);
            return;
          }
        }


        if (argument.equals("-prefixes")) {
          if (i < args.length + 1) {
            prefixes = args[i + 1].split(";");
          } else {
            System.err.println("-prefixes requires a semicolon separated string of prefixes");
            System.err.println(usageString);
            return;
          }
        }

        if (argument.equals("-indextype")) {
          if (i < args.length + 1) {
            if (args[i + 1].equalsIgnoreCase("file") || args[i + 1].equalsIgnoreCase("memory")) {
              indexType = args[i + 1];
            } else {
              System.err.println("-indextype requires file or memory");
              System.err.println(usageString);
              return;
            }
          }
        }

        if (argument.equals("-indextype")) {
          if (i < args.length + 1) {
            if (args[i + 1].equalsIgnoreCase("file") || args[i + 1].equalsIgnoreCase("memory")) {
              indexType = args[i + 1];
            } else {
              System.err.println("-indextype requires file or memory");
              System.err.println(usageString);
              return;
            }
          }
        }

        if (argument.equals("-indexdir")) {
          if (i < args.length + 1) {
            indexDir = args[i + 1];
          } else {
            System.err.println("-indextype requires file or memory");
            System.err.println(usageString);
            return;
          }
        }
      }

      if (searchfields == null || prefixes == null || indexType == null) {
        System.err.println(usageString);
        return;
      }

      if ("file".equalsIgnoreCase(indexType) && ("".equalsIgnoreCase(indexDir) || indexDir == null)) {
        System.err.println("-indexdir requires a location when indextype is set to file");
        System.err.println(usageString);
        return;
      }

      IndexService indexService = new IndexService();

      indexService.createIndex(indexDir, indexType, searchfields, prefixes);
    }
  }
}
