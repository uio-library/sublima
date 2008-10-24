package com.computas.sublima.app.service;

import org.apache.log4j.Logger;

import java.util.LinkedHashSet;

/**
 * @author: mha
 * Date: 24.okt.2008
 */
public class AutocompleteCache {

  private static Logger logger = Logger.getLogger(AutocompleteCache.class);
  private static AdminService adminService = new AdminService();
  private static LinkedHashSet<String> topicSet = new LinkedHashSet<String>();
  private static LinkedHashSet<String> publisherSet = new LinkedHashSet<String>();

  public synchronized static LinkedHashSet<String> getTopicSet() {
    if(topicSet.isEmpty()) {
      topicSet = adminService.createArrayOfTopics();
    }
    return topicSet;
  }

  public synchronized static LinkedHashSet<String> getPublisherSet() {
    if(publisherSet.isEmpty()) {
      publisherSet = adminService.createArrayOfPublishers();
    }
    return publisherSet;
  }

  public static void invalidateTopicCache() {
    topicSet.clear();
  }

  public static void invalidatePublisherCache() {
    publisherSet.clear();    
  }
}
