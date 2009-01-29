
import com.hp.hpl.jena.query.larq.ARQLuceneException;
import com.hp.hpl.jena.query.larq.LARQ;
import com.hp.hpl.jena.sparql.ARQNotImplemented;
import com.hp.hpl.jena.update.*;
import com.hp.hpl.jena.rdf.model.*;
import com.hp.hpl.jena.graph.*;

import java.io.*; 
import java.net.*;
import java.util.*;

import org.apache.log4j.Logger;

/**
 * This component queries RDF triple stores using Sparul. It is threadsafe.
 */
public class Sparul {

    private static Logger logger = Logger.getLogger(Sparul.class);


    public static void main(String[] args) {
        
        String modelfilename = ""; //"test.ttl";
        String modelformat =  ""; //"Turtle";
        String queryfilename = "";
        String argument;
        String query;
    
        String usageString = "usage: Sparul -filemodel filename format -query filename";



        for (int i = 0; i < args.length; i++) {
            argument = args[i];

            if (argument.equals("-filemodel")) {
                if (i < args.length) {
                    modelfilename = args[i + 1];
                    modelformat = args[i + 2];
                } else {
                    System.err.println("-filemodel requires a filename and format");
                    System.err.println(usageString);
                    return;
                }
            }

            if (argument.equals("-query")) {
                if (i < args.length + 1) {
                    queryfilename = args[i + 1];
                   
                } else {
                    System.err.println("-query requires a filename ");
                    System.err.println(usageString);
                    return;
                }
            }
        }

        if ("".equals(queryfilename) || "".equals(modelfilename) || "".equals(modelformat)) {
            System.out.println(usageString);
            return;
        }

        try {
            query = readFileAsString( queryfilename);
        } catch(Exception e) {
            System.out.println("what? " + e); 
            return; 
        }

        Model data = ModelFactory.createDefaultModel();
        try {
            data.read(new FileInputStream(modelfilename), null, modelformat);
        } catch(Exception e) {
            System.out.println("what? " + e); 
            return; 
        }
         data = execute(data, query);
        data.write(System.out, modelformat);
    }


    public static Model execute(Model model, String query)  {

    //Get a GraphStore and load the graph from the Model
    GraphStore graphStore = GraphStoreFactory.create();
    graphStore.setDefaultGraph(model.getGraph());

    try {
      //Try to execute the updateQuery (SPARQL/Update)
      UpdateRequest updateRequest = UpdateFactory.create(query);
      updateRequest.exec(graphStore);
      //LARQ.setDefaultIndex(SettingsService.getIndexBuilderNode(null).getIndex());
    } catch (ARQNotImplemented e) {
      logger.warn("DefaultSparulDispatcher.query --> ARQNotImplemented exception. Returning TRUE and flagging reindexing.");
      UpdateRequest updateRequest = UpdateFactory.create(query);

      updateRequest.exec(graphStore);
      //LARQ.setDefaultIndex(SettingsService.getIndexBuilderNode(null).getIndex());
      return model;
    } catch (UpdateException e) {
      logger.warn("DefaultSparulDispatcher.query --> UpdateException. Returning FALSE");
      e.printStackTrace();
      return null;
    } catch (ARQLuceneException e) {
      logger.warn("DefaultSparulDispatcher.query --> ARQLuceneException. Returning FALSE");
      e.printStackTrace();
      return null;
    }catch (Exception e) {
      logger.warn("DefaultSparulDispatcher.query --> Exception. Returning FALSE");
      e.printStackTrace();
      return null;
    }
    // Return true if update success
  
    return model;
  }
  
  private static String readFileAsString(String filePath) throws java.io.IOException{
        StringBuffer fileData = new StringBuffer(1000);
        BufferedReader reader = new BufferedReader(
                new FileReader(filePath));
        char[] buf = new char[1024];
        int numRead=0;
        while((numRead=reader.read(buf)) != -1){
            String readData = String.valueOf(buf, 0, numRead);
            fileData.append(readData);
            buf = new char[1024];
        }
        reader.close();
        return fileData.toString();
    }

  
  
  
}