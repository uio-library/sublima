package com.computas.sublima.query.service;

import com.hp.hpl.jena.db.ModelRDB;
import com.hp.hpl.jena.db.IDBConnection;
import com.hp.hpl.jena.query.larq.IndexBuilderNode;
import com.hp.hpl.jena.query.larq.IndexBuilderString;
import org.apache.cocoon.configuration.Settings;
import org.apache.log4j.Logger;
import org.apache.lucene.analysis.standard.StandardAnalyzer;
import org.apache.lucene.index.IndexWriter;

import java.io.File;
import java.sql.SQLException;

/**
 * A class that handles the Cocoon settings. Provides getters and setters to access the settings
 *
 * @author: mha
 * Date: 13.mar.2008
 * <p/>
 * Change Note 05-09-2008 (dn): Added facilities for Node-based index
 */
public class SettingsService {
  private static Settings cocoonSettings;
  private static ModelRDB model = null;
  static DatabaseService myDbService = new DatabaseService();
  static IndexBuilderString larqBuilder = null;
  static IndexBuilderNode indexBuilderNode = null;

  private static Logger logger = Logger.getLogger(SettingsService.class);

  private SettingsService() {

  }

  public synchronized static ModelRDB getModel() {

    if (model == null) {
      IDBConnection connection = myDbService.getConnection();
      model = ModelRDB.open(connection);
      try {
        connection.close();
      } catch (SQLException e) {
        logger.error("Exception closing IDBConnection from SettingsService.java:getModel()");
      }
    }
    return model;
  }

  public synchronized static IndexBuilderString getIndexBuilderString(File dir) {

    if (larqBuilder == null) {

      if (dir == null) {
        larqBuilder = new IndexBuilderString();
      } else {
        larqBuilder = new IndexBuilderString(dir);
      }
    }
    return larqBuilder;
  }


  /**
   * The method returns the index builder
   * If the writer does not exist it looks for an existing index in
   * the given directory. If an index is not there, a new is created.
   *
   * @param dir
   * @returns a IndexBuilderNode
   */
  public synchronized static IndexBuilderNode getIndexBuilderNode(File dir) {

    if (indexBuilderNode == null) {

      if (dir == null) {
        indexBuilderNode = new IndexBuilderNode();
      } else {

        // check if exist, if not or corrupt - create a new
        try {
          //todo Might fail here if it is a write.lock()
          IndexWriter iw = new IndexWriter(dir, new StandardAnalyzer());
          indexBuilderNode = new IndexBuilderNode(iw);
        } catch (org.apache.lucene.index.CorruptIndexException cie) {
          logger.warn("SUBLIMA: getIndexBuilderNode() --> Indexing - Failed to retrieve index, creating a new (empty in-memory index)");
          indexBuilderNode = new IndexBuilderNode();
        } catch (org.apache.lucene.store.LockObtainFailedException lofe) {
          logger.warn("SUBLIMA: getIndexBuilderNode() --> Indexing - Failed to obtain lock for index, creating a new (empty in-memory index)");
          lofe.printStackTrace();
          indexBuilderNode = new IndexBuilderNode();
        } catch (java.io.IOException ie) {
          logger.warn("SUBLIMA: getIndexBuilderNode() --> Indexing - Failed to access index, creating a new (empty in-memory index)");
          ie.printStackTrace();
          indexBuilderNode = new IndexBuilderNode();
        }
      }
    }
    return indexBuilderNode;
  }


  public void setCocoonSettings(Settings cocoonSettings) {
      SettingsService.cocoonSettings = cocoonSettings;
  }

  public static String getProperty(String property) {
      if (cocoonSettings != null){
	  return cocoonSettings.getProperty(property);
      } else {
	  logger.warn("SUBLIMA: getProperty() --> cocoonSettings is null, should only happen during unit testing");
	  return "";
      }
  }
}
