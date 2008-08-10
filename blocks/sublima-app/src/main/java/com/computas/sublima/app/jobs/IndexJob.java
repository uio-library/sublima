package com.computas.sublima.app.jobs;

import com.computas.sublima.app.service.IndexService;

/**
 * @author: mha
 * Date: 10.aug.2008
 */
public class IndexJob {

  public static void main(String[] args) {

    IndexService indexService = new IndexService();
    indexService.updateResourceSearchfield();
    indexService.createIndex();
  }
}
