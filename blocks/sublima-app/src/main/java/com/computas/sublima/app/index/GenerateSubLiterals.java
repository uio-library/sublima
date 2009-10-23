package com.computas.sublima.app.index;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;

/**
 * Class to generate a N3-file containing all sub:literals to be inserted into the database
 *
 * @author: mha
 * Date: 08.des.2008
 */
public class GenerateSubLiterals {

  private GenerateUtils gu = new GenerateUtils();
  private Generate gen = new Generate();

  public GenerateSubLiterals() {
    // default constructor
  }

  private void generateSubLiterals(String graph, String[] searchableProperties, String[] prefixes, String type, boolean indexexternal) {

      ArrayList<String> uriList = gu.getListOfResourceURIs();

      try {
        String pathname = "/tmp/mediasone/index/";
        boolean createdDirectory = new File(pathname).mkdirs();
        System.out.println("Created " + pathname + " " + createdDirectory);
        String name = graph.split(" ")[0].split("/")[graph.split(" ")[0].split("/").length - 2] + "_" + graph.split(" ")[0].split("/")[graph.split(" ")[0].split("/").length - 1];
        String filename = getDate() + "_" + name + "_" + type + "_subliterals.n3";

        EndpointSaver save = new EndpointSaver(graph, 5);
        //String query = "INSERT INTO <" + gu.getBaseGraph() + "> {\n<" + gu.getBaseGraph() + "/index/" + name + "> a <" + gu.getBaseGraph() + "#IndexGraph> ;\n rdfs:label \"Index for " + name + "\" .}";
        //save.ExecQuery(query);

        File file = new File(pathname, filename);
        boolean createdFile = file.createNewFile();
        System.out.println("Created " + file.toString() + " " + createdFile);

        System.out.println("Processing...");
        long connecttime = System.currentTimeMillis();

        int i = 1;
        int j = 0;
        // Write to a file so we can insert it into Virtuoso

        // Create file
        FileWriter fstream = new FileWriter(file);
        BufferedWriter out = new BufferedWriter(fstream);

        for (String uri : uriList) {
          String line = gen.generateFreetextForSingleResource(uri, searchableProperties, prefixes, new String[]{graph}, indexexternal);

          if (line != null) {
            save.Add(line);
            out.write(line + "\n");
            j++;
          }

          i++;
        }

        save.Flush();

        long requesttime = System.currentTimeMillis() - connecttime;

        System.out.println(j + " triples written to " + filename + " in " + requesttime + " ms.");

        out.close();
      } catch (Exception e) {
        System.err.println("Error: " + e.getMessage());
      }
  }

  public String getDate() {
    Calendar cal = Calendar.getInstance();
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy_MM_dd");
    return sdf.format(cal.getTime());
  }

  public static void main(String[] args) {
    GenerateSubLiterals gs = new GenerateSubLiterals();
    String basegraph = "http://rabbit.computas.int:8180/sublima-webapp-1.0-SNAPSHOT/";
    String[] indexfields = {"dct:title", "dct:description", "dct:publisher/foaf:name", "dct:subject/skos:prefLabel", "dct:subject/skos:altLabel", "dct:subject/skos:hiddenLabel"};
    String[] prefixes = {"dct: <http://purl.org/dc/terms/>", "foaf: <http://xmlns.com/foaf/0.1/>", "sub: <http://xmlns.computas.com/sublima#>", "skos: <http://www.w3.org/2004/02/skos/core#>"};
    String type = "resources";
    boolean indexexternal = false;
    gs.generateSubLiterals(basegraph, indexfields, prefixes, type, indexexternal);

    indexfields = new String[]{"skos:prefLabel", "skos:altLabel", "skos:hiddenLabel"};
    type = "topics";
    gs.generateSubLiterals(basegraph, indexfields, prefixes, type, indexexternal);
  }
}
