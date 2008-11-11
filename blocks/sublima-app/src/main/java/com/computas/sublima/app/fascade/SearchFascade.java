package com.computas.sublima.app.fascade;

import com.computas.sublima.app.controller.SearchController;
import com.computas.sublima.query.SparqlDispatcher;
import org.apache.cocoon.auth.ApplicationManager;
import org.apache.cocoon.components.flow.apples.AppleRequest;
import org.apache.cocoon.components.flow.apples.AppleResponse;
import org.apache.cocoon.components.flow.apples.StatelessAppleController;

/**
 * @author: mha
 * Date: 11.nov.2008
 */
public class SearchFascade implements StatelessAppleController {

  private SparqlDispatcher sparqlDispatcher;
  private ApplicationManager appMan;

  public void process(AppleRequest appleRequest, AppleResponse appleResponse) throws Exception {
    SearchController tc = new SearchController();
    tc.setSparqlDispatcher(sparqlDispatcher);
    tc.setAppMan(appMan);
    tc.process(appleRequest, appleResponse);
  }

  public void setSparqlDispatcher(SparqlDispatcher sparqlDispatcher) {
    this.sparqlDispatcher = sparqlDispatcher;
  }

  public void setAppMan(ApplicationManager appMan) {
    this.appMan = appMan;
  }
}
