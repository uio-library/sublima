package com.computas.sublima.app.listener;

import com.computas.sublima.app.service.IndexService;
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
    try {
      AutocompleteCache.getPublisherSet();
      AutocompleteCache.getTopicList();  
    } catch (Exception e) {
      logger.warn("SUBLIMA: Initializing cache lists failed. Probably because of an error with the database.");  
    }
  }


  public void contextDestroyed(ServletContextEvent servletContextEvent) {

  }
}
