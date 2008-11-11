package com.computas.sublima.app.fascade;

import com.computas.sublima.app.controller.RedirectController;
import org.apache.cocoon.components.flow.apples.AppleRequest;
import org.apache.cocoon.components.flow.apples.AppleResponse;
import org.apache.cocoon.components.flow.apples.StatelessAppleController;

/**
 * @author: mha
 * Date: 11.nov.2008
 */
public class RedirectFascade implements StatelessAppleController {

  public void process(AppleRequest appleRequest, AppleResponse appleResponse) throws Exception {
    RedirectController tc = new RedirectController();
    tc.process(appleRequest, appleResponse);
  }
}                                       
