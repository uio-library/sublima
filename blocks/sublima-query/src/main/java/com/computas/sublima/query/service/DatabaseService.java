package com.computas.sublima.query.service;


import com.hp.hpl.jena.db.IDBConnection;
import com.hp.hpl.jena.db.DBConnection;

import java.sql.SQLException;
import java.sql.Connection;
import java.sql.DriverManager;

/**
 * @author: mha
 * Date: 08.jan.2008
 */
public class DatabaseService {
   private String M_DB_URL = "jdbc:postgresql://localhost/subdata";
   private String M_DB_USER = "subuser";
   private String M_DB_PASSWD = "subpasswd";
   private String M_DB = "PostgreSQL";
   private String M_DBDRIVER_CLASS = "org.postgresql.Driver";

  public IDBConnection getConnection() {

    try {
      Class.forName(M_DBDRIVER_CLASS);
    } catch (ClassNotFoundException e) {
      // TODO Auto-generated catch block
      e.printStackTrace();
    }
    IDBConnection connection = new DBConnection(M_DB_URL, M_DB_USER, M_DB_PASSWD, M_DB);

    return connection;
  }

  public Connection getJavaSQLConnection() {
    try {
      Class.forName(M_DBDRIVER_CLASS);
    } catch (ClassNotFoundException e) {
      // TODO Auto-generated catch block
      e.printStackTrace();
    }
      Connection connection = null;
      try {
          connection = DriverManager.getConnection(M_DB_URL, M_DB_USER, M_DB_PASSWD);
      } catch (SQLException e) {
          e.printStackTrace();  //To change body of catch statement use File | Settings | File Templates.
      }

      return connection;
  }
}