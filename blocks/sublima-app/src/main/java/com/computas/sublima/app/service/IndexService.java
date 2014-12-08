package com.computas.sublima.app.service;

import com.computas.sublima.query.service.SettingsService;
import com.computas.sublima.app.index.Generate;
import com.computas.sublima.app.index.GenerateUtils;
import org.apache.log4j.Logger;

import java.util.*;

/**
 * A class to support Lucene/LARQ indexing in the web app
 * Has methods for creating and accessing indexes
 *
 * @author: mha
 * Date: 13.mar.2008
 */
public class IndexService {

  private Generate gen = new Generate();
  private GenerateUtils gu = new GenerateUtils();
  private AdminService adminService = new AdminService();
  private static Logger logger = Logger.getLogger(IndexService.class);

  public void createIndex() {
    createResourceIndex();
    createTopicIndex();
  }

  public void createResourceIndex() {
    gen.generateIndexForResources(Boolean.valueOf(SettingsService.getProperty("sublima.index.external")), SettingsService.getProperty("sublima.basegraph"), gu.getResourceFreetextFieldsToIndex(), gu.getPrefixes());
  }

  public void createTopicIndex() {
    gen.generateIndexForTopics(SettingsService.getProperty("sublima.basegraph"), gu.getTopicFieldsToIndex(), gu.getPrefixes());
  }

  public boolean indexResource(String uri) {
    gen.generateIndexForResource(uri, SettingsService.getProperty("sublima.basegraph"), gu.getResourceFreetextFieldsToIndex(), gu.getPrefixes(), Boolean.valueOf(SettingsService.getProperty("sublima.index.external")));
    return true;
  }

  public boolean indexTopic(String uri) {
    gen.generateIndexForTopic(uri, SettingsService.getProperty("sublima.basegraph"), gu.getTopicFieldsToIndex(), gu.getPrefixes());
    return true;    
  }



  /**
   * A method to validate all urls on the resources. Adds the URL to the list along with
   * the http code.
   */

  public void validateURLs() {
    HashSet<String> urls = adminService.getAllExternalResourcesURLs();

    // For each URL, do a HTTP GET and check the HTTP code
    int i = 1;
    for (String url : urls) {
      logger.info("SUBLIMA: validateURLs() --> Updating status for resource " + i + " of " + urls.size() + " : " + url);
      URLActions urlAction = new URLActions(url);
      urlAction.getAndUpdateResourceStatus();
      i++;
    }
  }


    public void indexListOfResources(LinkedHashSet<String> listOfResourcesForTopic) {
        for (String uri : listOfResourcesForTopic) {
            indexResource(uri);
        }
    }
}