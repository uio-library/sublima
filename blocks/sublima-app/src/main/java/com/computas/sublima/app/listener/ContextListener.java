package com.computas.sublima.app.listener;

import com.computas.sublima.app.service.IndexService;
import com.computas.sublima.app.service.AdminService;
import com.computas.sublima.app.service.AutocompleteCache;
import com.computas.sublima.query.service.SettingsService;
import org.apache.log4j.Logger;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;

/**
 * @author: mha
 * Date: 28.feb.2008
 */
public final class ContextListener implements ServletContextListener {
  private static Logger logger = Logger.getLogger(ContextListener.class);

  public void contextInitialized(ServletContextEvent servletContextEvent) {
    IndexService indexService = new IndexService();
    AdminService adminService = new AdminService();
    AutocompleteCache.getPublisherSet();

    if ("true".equalsIgnoreCase(SettingsService.getProperty("sublima.checkurl.onstartup"))) {
      logger.info("SUBLIMA: Property sublima.checkurl.onstartup set to TRUE --> URL Check - Performing a url check");
      indexService.validateURLs();
    }

    if ("true".equalsIgnoreCase(SettingsService.getProperty("sublima.index.internal.onstartup"))) {
      logger.info("SUBLIMA: Property sublima.index.internal.onstartup set to TRUE --> Indexing - Internal content");
      try {
        boolean indexExternal = Boolean.valueOf(SettingsService.getProperty("sublima.index.external.onstartup"));
        indexService.createIndex(SettingsService.getProperty("sublima.index.directory"), SettingsService.getProperty("sublima.index.type"), SettingsService.getProperty("sublima.resource.searchfields").split(";"), SettingsService.getProperty("sublima.topic.searchfields").split(";"),  SettingsService.getProperty("sublima.prefixes").split(";"), indexExternal);
        logger.info("SUBLIMA: Indexing - Internal content finished");
      } catch (com.hp.hpl.jena.shared.DoesNotExistException e) {
        logger.warn("SUBLIMA: getFreetextToIndex() --> Database didn't exist. This iads OK on startup, but fatal otherwise");
      }
    }
    // What happens if this is not set? We need to check if we can read from an existing index
    // and bind it to the model...
    else {
      indexService.setIndex(SettingsService.getProperty("sublima.index.directory"));
    }


  }


  public void contextDestroyed(ServletContextEvent servletContextEvent) {

  }
}
