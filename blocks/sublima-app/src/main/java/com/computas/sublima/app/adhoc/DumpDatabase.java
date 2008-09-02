package com.computas.sublima.app.adhoc;


import com.hp.hpl.jena.db.IDBConnection;
import com.hp.hpl.jena.db.DBConnection;
import com.hp.hpl.jena.rdf.model.Model; 
import com.hp.hpl.jena.db.ModelRDB;
import java.io.OutputStream;
import java.io.FileOutputStream;
import java.io.BufferedOutputStream;

public class DumpDatabase {

    private String M_DB_URL = "jdbc:postgresql://localhost/subdata";
    private String M_DB_USER = "subuser";
    private String M_DB_PASSWD = "subpasswd";
    private String M_DB = "PostgreSQL";
    private String M_DBDRIVER_CLASS = "org.postgresql.Driver";
    private static Model model = null;

    
    public DumpDatabase () {
    }
    
    
    private IDBConnection getConnection() {
        try {
            Class.forName(M_DBDRIVER_CLASS);
        } catch (ClassNotFoundException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }
        IDBConnection connection = new DBConnection(M_DB_URL, M_DB_USER, M_DB_PASSWD, M_DB);
        return connection;
    }


    private Model getModel() {
        
        if (model == null) {
            model = ModelRDB.open(getConnection());
        }
        return model;
    }
    
    private void dump(OutputStream out, String lang) {
        model = getModel();
        model.write(out, lang);
    }
    
    
    public static void main(String [] args) {
        String argument = "";
        String outputfilename = null;
        String outputformat = "";
        String usageString = "usage: DumpDatabase -output filename format ";

        for (int i = 0; i < args.length; i++) {
            argument = args[i];

            if (argument.equals("-output")) {
                if (i < args.length + 1) {
                    outputfilename = args[i + 1];
                    outputformat = args[i + 2];
                } else {
                    System.err.println("-output requires a filename and format");
                    System.err.println(usageString);
                    return;
                }
            }
        }

        if (outputfilename == null) {
            System.err.println(usageString);
            return;
        }
        try {
            FileOutputStream fstream = new FileOutputStream(outputfilename);
            BufferedOutputStream out = new BufferedOutputStream(fstream);
            new DumpDatabase().dump(out, outputformat);
        } catch (Exception e) {
            System.err.println(e.toString());
            e.printStackTrace(System.err);
        }
    
    }  
    
 }   
    
    
    