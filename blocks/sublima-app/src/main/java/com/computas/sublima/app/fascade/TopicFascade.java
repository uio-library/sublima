package com.computas.sublima.app.fascade;

import com.computas.sublima.query.SparqlDispatcher;
import com.computas.sublima.query.SparulDispatcher;
import com.computas.sublima.app.controller.admin.TopicController;
import org.apache.cocoon.auth.ApplicationManager;
import org.apache.cocoon.components.flow.apples.AppleRequest;
import org.apache.cocoon.components.flow.apples.AppleResponse;
import org.apache.cocoon.components.flow.apples.StatelessAppleController;

/**
 * @author: mha
 * Date: 11.nov.2008
 */
public class TopicFascade implements StatelessAppleController {

  private SparulDispatcher sparulDispatcher;
  private ApplicationManager appMan;

  public void process(AppleRequest appleRequest, AppleResponse appleResponse) throws Exception {
    TopicController tc = new TopicController();
    tc.setSparulDispatcher(sparulDispatcher);
    tc.setAppMan(appMan);
    tc.process(appleRequest, appleResponse);
  }

  public void setSparulDispatcher(SparulDispatcher sparulDispatcher) {
    this.sparulDispatcher = sparulDispatcher;
  }

  public void setAppMan (ApplicationManager appMan) {
    this.appMan = appMan;
  }
}                                       
