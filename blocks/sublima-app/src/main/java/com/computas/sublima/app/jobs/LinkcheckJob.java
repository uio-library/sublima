package com.computas.sublima.app.jobs;

import com.computas.sublima.query.service.IndexService;

/**
 * @author: mha
 * Date: 27.mar.2008
 */
public class LinkcheckJob {

  public static void main(String[] args) {
    IndexService indexService = new IndexService();
    indexService.performLinkcheckJob();
  }
}
