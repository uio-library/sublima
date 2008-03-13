package com.computas.sublima.query.service;

import org.apache.cocoon.configuration.Settings;

/**
 * A class that handles the Cocoon settings. Provides getters and setters to access the settings
 *
 * @author: mha
 * Date: 13.mar.2008
 */
public class SettingsService {
  private static Settings cocoonSettings;

  public void setCocoonSettings(Settings cocoonSettings) {
    this.cocoonSettings = cocoonSettings;
  }

  public static String getProperty(String property) {
    return cocoonSettings.getProperty(property);
  }
}
