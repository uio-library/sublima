package com.computas.sublima.query.service;


import com.hp.hpl.jena.db.DBConnection;
import com.hp.hpl.jena.db.IDBConnection;

import java.io.BufferedWriter;
import java.io.FileWriter;
import java.sql.*;

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

  public int doSQLUpdate(String sql) throws SQLException {
    Statement stmt;
    int rows;
    Connection con = getJavaSQLConnection();

    stmt = con.createStatement();
    rows = stmt.executeUpdate(sql);
    con.commit();
    stmt.close();
    con.close();

    return rows;
  }

  /**
   * Method do do a SQL query. Returns a Statement instead of a ResultSet since a ResultSet is closed whenever the Statement is closed.
   * Use Statement.getResultSet() to get the actual ResultSet.
   *
   * @param sql
   * @return Statement
   * @throws SQLException
   */
  public Statement doSQLQuery(String sql) throws SQLException {
    Statement stmt;
    ResultSet rs;
    Connection con = getJavaSQLConnection();

    stmt = con.createStatement();
    rs = stmt.executeQuery(sql);
    con.close();

    return stmt;
  }

  public void writeModelToFile(String filename, String format) {

    try {
      // Create file
      FileWriter fstream = new FileWriter(filename);
      BufferedWriter out = new BufferedWriter(fstream);
      SettingsService.getModel().write(out, format);     
      //Close the output stream
      out.close();
    } catch (Exception e) {//Catch exception if any
      System.err.println("Error: " + e.getMessage());
    }
  }
  
}