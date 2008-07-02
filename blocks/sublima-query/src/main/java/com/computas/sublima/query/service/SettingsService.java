package com.computas.sublima.query.service;

import com.hp.hpl.jena.db.IDBConnection;
import com.hp.hpl.jena.db.ModelRDB;
import com.hp.hpl.jena.query.larq.IndexBuilderString;
import com.hp.hpl.jena.query.larq.IndexLARQ;
import com.hp.hpl.jena.query.larq.LARQ;
import org.apache.cocoon.configuration.Settings;

/**
 * A class that handles the Cocoon settings. Provides getters and setters to access the settings
 *
 * @author: mha
 * Date: 13.mar.2008
 */
public class SettingsService {
  private static Settings cocoonSettings;
  private static ModelRDB model = null;
  static DatabaseService myDbService = new DatabaseService();
  //IDBConnection connection = myDbService.getConnection();
  static IndexBuilderString larqBuilder = new IndexBuilderString();

  private SettingsService() {

  }

  public synchronized static ModelRDB getModel() {

    if (model == null) {

      model = ModelRDB.open(myDbService.getConnection());
      //model.register(larqBuilder);
      //larqBuilder.indexStatements(model.listStatements());
      //IndexLARQ index = larqBuilder.getIndex();
      //LARQ.setDefaultIndex(index);
    }
    return model;
  }

  public void setCocoonSettings(Settings cocoonSettings) {
    this.cocoonSettings = cocoonSettings;
  }

  public static String getProperty(String property) {
    return cocoonSettings.getProperty(property);
  }
}
