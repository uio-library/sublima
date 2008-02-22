package com.computas.sublima.app.controller;

import org.apache.cocoon.components.flow.apples.AppleRequest;
import org.apache.cocoon.components.flow.apples.AppleResponse;
import org.apache.cocoon.components.flow.apples.StatelessAppleController;
import org.apache.log4j.Logger;

public class Index implements StatelessAppleController {

  @SuppressWarnings("unchecked")
  public void process(AppleRequest req, AppleResponse res) throws Exception {

    res.sendPage("index/empty-page", null);
		return;

  }

}