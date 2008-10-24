package com.computas.sublima.app.adhoc;


import com.hp.hpl.jena.query.*;
import com.hp.hpl.jena.query.larq.IndexBuilderNode;
import com.hp.hpl.jena.query.larq.IndexBuilderString;
import com.hp.hpl.jena.query.larq.IndexLARQ;
import com.hp.hpl.jena.query.larq.LARQ;
import com.hp.hpl.jena.rdf.model.*;
import com.hp.hpl.jena.util.FileManager;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;

public class LARQTest {


  private static Model model = null;
  IndexBuilderNode larqBuilder = null;

  String newText = "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.";


  private Model getModel(String inputfilename, String inFormat) throws FileNotFoundException, IOException {

    if (model == null) {
      // create an empty model
      model = ModelFactory.createDefaultModel();

      // use the FileManager to find the input file
      InputStream in = FileManager.get().open(inputfilename);
      if (in == null) {
        throw new FileNotFoundException("File: " + inputfilename + " not found");
      }

      // read the RDF file
      RDFReader rdr = model.getReader(inFormat);
      File f = new File(inputfilename);
      String base = f.toString(); //"file:///" + f.getCanonicalPath().replace('\\', '/');
      rdr.read(model, in, base);
      in.close();
    }
    return model;
  }


  private void executeSparql(Model model, String sparql) {

    Query query = QueryFactory.create(sparql);

    // Execute the query and obtain results
    QueryExecution qe = QueryExecutionFactory.create(query, model);
    ResultSet results = qe.execSelect();

    // Output query results
    ResultSetFormatter.out(System.out, results, query);

    // Important - free up resources used running the query
    qe.close();

  }


  public void indexModel(Model model) {

    // create index
    IndexLARQ index = buildExternalIndex(model);

    // -- Make globally available
    LARQ.setDefaultIndex(index);
  }


  private IndexLARQ buildInternalIndex(Model model) {

    // build based on strings
    IndexBuilderString larqBuilder = new IndexBuilderString();
    // -- Create an index based on existing statements
    larqBuilder.indexStatements(model.listStatements());
    // -- Finish indexing
    larqBuilder.closeWriter();
    // -- Create the access index
    IndexLARQ index = larqBuilder.getIndex();
    larqBuilder.flushWriter();
    return index;
  }


  // try to add new literals to index
  private void addAndReindex(Model model) {
    ResIterator iter = model.listSubjects();
    while (iter.hasNext()) {
      Resource res = iter.nextResource();
      larqBuilder.index(res, newText);
    }
    IndexLARQ index = larqBuilder.getIndex();
    larqBuilder.flushWriter();
    LARQ.setDefaultIndex(index);


  }


  private IndexLARQ buildExternalIndex(Model model) {
    // ---- Create a new index builder
    larqBuilder = new IndexBuilderNode("/tmp/larqtest/");

    ResIterator iter = model.listSubjects();
    while (iter.hasNext()) {
      Resource res = iter.nextResource();
      // get all literals
      NodeIterator ni = model.listObjectsOfProperty(res, null);
      StringBuilder text = new StringBuilder();
      while (ni.hasNext()) {
        RDFNode node = ni.nextNode();
        if (node.isLiteral()) {
          text.append(((Literal) node).getString() + " ");
        }
      }
      System.out.println("Adding index on " + text.toString() + " to resource " + res.toString());
      larqBuilder.index(res, text.toString());
    }
    //larqBuilder.closeWriter();
    larqBuilder.flushWriter();
    IndexLARQ index = larqBuilder.getIndex();
    return index;
  }


  public static void main(String[] args) {
    String argument = "";
    String inputfilename = null;
    String inputformat = "";
    String sparql = "";
    String usageString = "usage: LARQTest -input filename format -sparql 'search string'";

    for (int i = 0; i < args.length; i++) {
      argument = args[i];

      if (argument.equals("-input")) {
        if (i < args.length + 1) {
          inputfilename = args[i + 1];
          inputformat = args[i + 2];
        } else {
          System.err.println("-input requires a filename and format");
          System.err.println(usageString);
          return;
        }
      }

      if (argument.equals("-sparql")) {
        if (i < args.length) {
          sparql = args[i + 1];
        } else {
          System.err.println("-sparql requires a search string");
          System.err.println(usageString);
          return;
        }
      }
    }

    if ((inputfilename == null) || (sparql == null)) {
      System.err.println(usageString);
      return;
    }
    try {
      LARQTest lt = new LARQTest();
      model = lt.getModel(inputfilename, inputformat);

      // 1. Query without index, show model
      try {
        lt.executeSparql(model, sparql);
        System.out.println("Initial MODEL:");
        System.out.println(model.toString());
      } catch (Exception e) {
        e.toString();
      }
      // 2. Add index, query and show model
      lt.indexModel(model);
      lt.executeSparql(model, sparql);
      System.out.println("MODEL:");
      System.out.println(model.toString());

      // 3. Add to index, query and show model
      lt.addAndReindex(model);
      lt.executeSparql(model, sparql);
      System.out.println("MODEL:");
      System.out.println(model.toString());

    } catch (Exception e) {
      System.err.println(e.toString());
      e.printStackTrace(System.err);
    }
    return;
  }


}
    
    
    