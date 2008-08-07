package com.computas.sublima.query.service;

import com.hp.hpl.jena.db.ModelRDB;
import com.hp.hpl.jena.query.larq.IndexBuilderString;
import org.apache.cocoon.configuration.Settings;

import java.io.File;

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
  static IndexBuilderString larqBuilder = null;

  private SettingsService() {

  }

  public synchronized static ModelRDB getModel() {

    if (model == null) {
      model = ModelRDB.open(myDbService.getConnection());
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

  public void setCocoonSettings(Settings cocoonSettings) {
    this.cocoonSettings = cocoonSettings;
  }

  public static String getProperty(String property) {
    return cocoonSettings.getProperty(property);
  }
}
