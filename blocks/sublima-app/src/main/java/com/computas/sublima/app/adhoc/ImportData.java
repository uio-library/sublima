package com.computas.sublima.app.adhoc;

import com.hp.hpl.jena.db.DBConnection;
import com.hp.hpl.jena.db.IDBConnection;
import com.hp.hpl.jena.db.ModelRDB;
import com.hp.hpl.jena.rdf.model.ModelMaker;
import com.hp.hpl.jena.rdf.model.ModelFactory;
import com.hp.hpl.jena.rdf.model.Model;
import com.hp.hpl.jena.shared.AlreadyExistsException;
import com.computas.sublima.query.service.DatabaseService;

import java.sql.SQLException;
import java.io.FileReader;
import java.io.BufferedReader;
import java.io.IOException;

public class ImportData {
  /**
   * Ad hoc method to import data to the Pg Data Store.
   *
   * @param url  The URL of the RDF to import
   * @param lang The serialisation language of the file
   */
  public static void load(java.lang.String url, java.lang.String lang) {

    DatabaseService myDbService = new DatabaseService();
    IDBConnection connection = myDbService.getConnection();

    try {
      ModelRDB model = ModelRDB.createModel(connection);
      model.read(url, lang);
    }
    catch (AlreadyExistsException e) {
      ModelRDB model = ModelRDB.open(connection);
      model.read(url, lang);
    }
    finally {
      try {
        connection.close();
      } catch (SQLException e) {
        e.printStackTrace(); 
      }
    }
  }

  public static void main(String[] args) {
    load(args[0], args[1]);
  }
}
