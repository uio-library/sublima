package com.computas.sublima.app.listener;

import com.computas.sublima.query.service.IndexService;
import com.computas.sublima.query.service.SettingsService;

import javax.servlet.ServletContextListener;
import javax.servlet.ServletContextEvent;

import org.apache.log4j.Logger;

import java.io.ByteArrayOutputStream;

/**
 * @author: mha
 * Date: 28.feb.2008
 */
public final class ContextListener implements ServletContextListener {
  private static Logger logger = Logger.getLogger(ContextListener.class);

  public void contextInitialized(ServletContextEvent servletContextEvent) {
    IndexService indexService = new IndexService();
    indexService.createInternalResourcesMemoryIndex();

    if("true".equalsIgnoreCase(SettingsService.getProperty("sublima.checkurl.onstartup"))) {
      logger.info("SUBLIMA: Property sublima.checkurl.onstartup set to TRUE --> URL Check - Performing a url check");
      indexService.validateURLs();
    }

    if("true".equalsIgnoreCase(SettingsService.getProperty("sublima.index.external.onstartup"))) {
      logger.info("SUBLIMA: Property sublima.index.externalOnStartup set to TRUE --> Indexing - External content");
      indexService.createExternalResourcesMemoryIndex();
    }
  }

  public void contextDestroyed(ServletContextEvent servletContextEvent) {

  }
}
