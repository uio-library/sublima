package com.computas.sublima.util;

import com.computas.sublima.service.DatabaseService;
import com.hp.hpl.jena.db.IDBConnection;
import com.hp.hpl.jena.db.ModelRDB;
import com.hp.hpl.jena.shared.AlreadyExistsException;

import java.sql.SQLException;

/**
 * @author: mha
 * Date: 14.jan.2008
 */
public class TestUtils {

  public void createModel(java.lang.String url, java.lang.String lang) {
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


  public void removeModel() {
    DatabaseService dbService = new DatabaseService();
    IDBConnection connection = dbService.getConnection();

    try {
      ModelRDB model = ModelRDB.open(connection);
      model.remove();
    }
    catch(Exception e) {

    }
    finally {
      try {
        connection.close();
      } catch (SQLException e) {
        e.printStackTrace();
      }
    }
  }
}
