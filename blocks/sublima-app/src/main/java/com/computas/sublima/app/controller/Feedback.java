package com.computas.sublima.app.controller;

import org.apache.cocoon.components.flow.apples.AppleRequest;
import org.apache.cocoon.components.flow.apples.AppleResponse;
import org.apache.cocoon.components.flow.apples.StatelessAppleController;
import org.apache.log4j.Logger;

public class Feedback implements StatelessAppleController {

  private String mode;
  private static Logger logger = Logger.getLogger(Feedback.class);

  @SuppressWarnings("unchecked")
  public void process(AppleRequest req, AppleResponse res) throws Exception {

    this.mode = req.getSitemapParameter("mode");

    if("visTipsForm".equalsIgnoreCase("mode")) {
      res.sendPage("xhtml/tips-form", null);
			return;  
    }

    if("sendInnTips".equalsIgnoreCase("mode")) {
      
    }

    return;
  }

}
