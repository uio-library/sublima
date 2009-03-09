package com.computas.sublima.query.service;


import com.hp.hpl.jena.db.DBConnection;
import com.hp.hpl.jena.db.IDBConnection;

import java.io.BufferedOutputStream;
import java.io.FileOutputStream;
import java.sql.*;

/**
 * @author: mha
 * Date: 08.jan.2008
 */
public class DatabaseService {
  // todo Use JNDI instead of hard coded database parameters
  private String M_DB_URL = "jdbc:virtuoso://rabbit.computas.int:1111";// SettingsService.getProperty("sublima.database.url");
  private String M_DB_USER = "dba";//SettingsService.getProperty("sublima.database.username");
  private String M_DB_PASSWD = "dba";//SettingsService.getProperty("sublima.database.password");
  private String M_DB = "DB";//SettingsService.getProperty("sublima.database.databasetype");
  private String M_DBDRIVER_CLASS = "virtuoso.jdbc3.Driver";//SettingsService.getProperty("sublima.database.class");

  public IDBConnection getConnection() {

    IDBConnection connection = null;

    /*
    try {


      Context initCtx = new InitialContext();
      Context envCtx = (Context) initCtx.lookup("java:comp/env");
      DataSource ds = (DataSource)
              envCtx.lookup("jdbc/Sublima");

      connection = new DBConnection(ds.getConnection(), M_DB);
    } catch (NamingException e) {
      e.printStackTrace();
    } catch (SQLException e) {
      e.printStackTrace();
    }
    return connection;
    */

    try {
      Class.forName(M_DBDRIVER_CLASS);
    } catch (ClassNotFoundException e) {
      // TODO Auto-generated catch block
      e.printStackTrace();
    }
    connection = new DBConnection(M_DB_URL, M_DB_USER, M_DB_PASSWD, M_DB);

    return connection;


  }

  public Connection getJavaSQLConnection() {


    Connection connection = null;

    /*
    try {
      Context initCtx = new InitialContext();
      Context envCtx = (Context) initCtx.lookup("java:comp/env");
      DataSource ds = (DataSource)
              envCtx.lookup("jdbc/Sublima");
      connection = ds.getConnection();
    } catch (NamingException e) {
      e.printStackTrace();
    } catch (SQLException e) {
      e.printStackTrace();
    }
    return connection;
    */

    try

    {
      Class.forName(M_DBDRIVER_CLASS);
    }

    catch (
            ClassNotFoundException e
            )

    {
      // TODO Auto-generated catch block
      e.printStackTrace();
    }

    try

    {
      connection = DriverManager.getConnection(M_DB_URL, M_DB_USER, M_DB_PASSWD);
    }

    catch (
            SQLException e
            )

    {
      e.printStackTrace();  //To change body of catch statement use File | Settings | File Templates.
    }

    return connection;
  }

  public int doSQLUpdate(String sql) throws SQLException {
    Statement stmt;
    int rows;

    Connection connection = getJavaSQLConnection();
    stmt = connection.createStatement();
    rows = stmt.executeUpdate(sql);
    connection.commit();
    stmt.close();
    connection.close();

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

    Connection connection = getJavaSQLConnection();

    stmt = connection.createStatement();
    rs = stmt.executeQuery(sql);
    connection.close();

    return stmt;
  }

  public void writeModelToFile(String filename, String format) {

    try {
      // Create file
      //FileWriter fstream = new FileWriter(filename);
      //BufferedWriter out = new BufferedWriter(fstream);
      FileOutputStream fstream = new FileOutputStream(filename);
      BufferedOutputStream out = new BufferedOutputStream(fstream);

      SettingsService.getModel().write(out, format);
//Close the output stream
      out.close();
    } catch (Exception e) {//Catch exception if any
      System.err.println("Error : " + e.getMessage());
      e.printStackTrace(System.err);
    }
  }
}
