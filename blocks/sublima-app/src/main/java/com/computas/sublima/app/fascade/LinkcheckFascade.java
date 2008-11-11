package com.computas.sublima.app.fascade;

import com.computas.sublima.app.controller.admin.LinkcheckController;
import com.computas.sublima.query.SparqlDispatcher;
import org.apache.cocoon.components.flow.apples.AppleRequest;
import org.apache.cocoon.components.flow.apples.AppleResponse;
import org.apache.cocoon.components.flow.apples.StatelessAppleController;

/**
 * @author: mha
 * Date: 11.nov.2008
 */
public class LinkcheckFascade implements StatelessAppleController {

  private SparqlDispatcher sparqlDispatcher;

  public void process(AppleRequest appleRequest, AppleResponse appleResponse) throws Exception {
    LinkcheckController tc = new LinkcheckController();
    tc.setSparqlDispatcher(sparqlDispatcher);
    tc.process(appleRequest, appleResponse);
  }

  public void setSparqlDispatcher(SparqlDispatcher sparqlDispatcher) {
    this.sparqlDispatcher = sparqlDispatcher;
  }
}
