package com.computas.sublima.app.fascade;

import com.computas.sublima.app.controller.admin.PublisherController;
import com.computas.sublima.query.SparulDispatcher;
import com.computas.sublima.query.SparqlDispatcher;
import org.apache.cocoon.components.flow.apples.AppleRequest;
import org.apache.cocoon.components.flow.apples.AppleResponse;
import org.apache.cocoon.components.flow.apples.StatelessAppleController;

/**
 * @author: mha
 * Date: 11.nov.2008
 */
public class PublisherFascade implements StatelessAppleController {

  private SparulDispatcher sparulDispatcher;
  private SparqlDispatcher sparqlDispatcher;

  public void process(AppleRequest appleRequest, AppleResponse appleResponse) throws Exception {
    PublisherController tc = new PublisherController();
    tc.setSparulDispatcher(sparulDispatcher);
    tc.setSparqlDispatcher(sparqlDispatcher);
    tc.process(appleRequest, appleResponse);
  }

  public void setSparulDispatcher(SparulDispatcher sparulDispatcher) {
    this.sparulDispatcher = sparulDispatcher;
  }

  public void setSparqlDispatcher(SparqlDispatcher sparqlDispatcher) {
    this.sparqlDispatcher = sparqlDispatcher;
  }
}                                       
