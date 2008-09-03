package com.computas.sublima.app.adhoc;


import com.hp.hpl.jena.db.IDBConnection;
import com.hp.hpl.jena.db.DBConnection;
import com.hp.hpl.jena.rdf.model.Model; 
import com.hp.hpl.jena.db.ModelRDB;
import com.hp.hpl.jena.rdf.model.ModelFactory;
import com.hp.hpl.jena.rdf.model.RDFReader; 
import com.hp.hpl.jena.util.FileManager;
import com.hp.hpl.jena.query.ResultSetFormatter;
import com.hp.hpl.jena.query.ResultSet;
import com.hp.hpl.jena.query.QueryExecutionFactory;
import com.hp.hpl.jena.query.QueryFactory;
import com.hp.hpl.jena.query.QueryExecution;
import com.hp.hpl.jena.query.Query;

import com.hp.hpl.jena.rdf.model.ResIterator; 
import com.hp.hpl.jena.rdf.model.Resource;
import com.hp.hpl.jena.rdf.model.RDFNode;
import com.hp.hpl.jena.rdf.model.NodeIterator;
import com.hp.hpl.jena.rdf.model.Literal;


import com.hp.hpl.jena.query.larq.LARQ;
import com.hp.hpl.jena.query.larq.IndexBuilderString;
import com.hp.hpl.jena.query.larq.IndexBuilderNode;
import com.hp.hpl.jena.query.larq.IndexLARQ;

import java.io.OutputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.FileOutputStream;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.InputStream;

public class LARQTest {


    private static Model model = null;

   
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
        LARQ.setDefaultIndex(index) ;
    }
    
    
    private IndexLARQ buildInternalIndex(Model model) {
        
        // build based on strings
        IndexBuilderString larqBuilder = new IndexBuilderString() ;
        // -- Create an index based on existing statements
        larqBuilder.indexStatements(model.listStatements()) ;
        // -- Finish indexing
        larqBuilder.closeWriter() ;
        // -- Create the access index  
        IndexLARQ index = larqBuilder.getIndex() ;
        return index;
    }



    
    private IndexLARQ buildExternalIndex(Model model) {
        // ---- Create index builder
        IndexBuilderNode larqBuilder = new IndexBuilderNode() ;
        
        ResIterator iter = model.listSubjects();        
        while (iter.hasNext()) {
            Resource res = iter.nextResource();
            // get all literals
            NodeIterator ni = model.listObjectsOfProperty(res, null);
            StringBuffer text = new StringBuffer();
            while (ni.hasNext()) {
                RDFNode node = ni.nextNode();
                if (node.isLiteral()) {
                    text.append(((Literal) node).getString() + " ");
                }
            }
            System.out.println("Adding index on " + text.toString() + " to resource " + res.toString());
            larqBuilder.index(res, text.toString()) ;    
        }
        larqBuilder.closeWriter(); 
        IndexLARQ index = larqBuilder.getIndex() ;
        return index;
    }
    
    
    
    public static void main(String [] args) {
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
            lt.indexModel(model);
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
    
    
    