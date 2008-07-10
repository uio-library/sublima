package com.computas.sublima.app.listener;

import com.computas.sublima.app.service.IndexService;
import com.computas.sublima.query.service.SettingsService;
import com.computas.sublima.app.service.IndexService;

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

    if("true".equalsIgnoreCase(SettingsService.getProperty("sublima.checkurl.onstartup"))) {
      logger.info("SUBLIMA: Property sublima.checkurl.onstartup set to TRUE --> URL Check - Performing a url check");
      indexService.validateURLs();
    }

    if("true".equalsIgnoreCase(SettingsService.getProperty("sublima.index.internal.onstartup"))) {
      logger.info("SUBLIMA: Property sublima.index.internal.onstartup set to TRUE --> Indexing - Internal content");
      try {
	  indexService.createInternalResourcesMemoryIndex();
	  logger.info("SUBLIMA: Indexing - Internal content finished");
      } catch (com.hp.hpl.jena.shared.DoesNotExistException e) {
	  logger.warn("SUBLIMA: getFreetextToIndex() --> Database didn't exist. This is OK on startup, but fatal otherwise");
      }
    }
  }

  public void contextDestroyed(ServletContextEvent servletContextEvent) {

  }
}
