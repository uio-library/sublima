package com.computas.sublima.app.service;

import org.apache.log4j.Logger;

import java.util.LinkedHashSet;
import java.util.ArrayList;

/**
 * @author: mha
 * Date: 24.okt.2008
 */
public class AutocompleteCache {

  private static Logger logger = Logger.getLogger(AutocompleteCache.class);
  private static AdminService adminService = new AdminService();
  private static ArrayList<String[]> topicList = new ArrayList<String[]>();
  private static LinkedHashSet<String> publisherSet = new LinkedHashSet<String>();

  public synchronized static ArrayList<String[]> getTopicList() {
    if(topicList.isEmpty()) {
      topicList = adminService.createArrayOfTopics();
    }
    return topicList;
  }

  public synchronized static LinkedHashSet<String> getPublisherSet() {
    if(publisherSet.isEmpty()) {
      publisherSet = adminService.createArrayOfPublishers();
    }
    return publisherSet;
  }

  public static void invalidateTopicCache() {
    topicList.clear();
  }

  public static void invalidatePublisherCache() {
    publisherSet.clear();    
  }
}
