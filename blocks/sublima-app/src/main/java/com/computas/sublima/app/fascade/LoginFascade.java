package com.computas.sublima.app.fascade;

import com.computas.sublima.app.controller.admin.LoginController;
import org.apache.cocoon.components.flow.apples.AppleRequest;
import org.apache.cocoon.components.flow.apples.AppleResponse;
import org.apache.cocoon.components.flow.apples.StatelessAppleController;

/**
 * @author: mha
 * Date: 11.nov.2008
 */
public class LoginFascade implements StatelessAppleController {

  public void process(AppleRequest appleRequest, AppleResponse appleResponse) throws Exception {
    LoginController tc = new LoginController();
    tc.process(appleRequest, appleResponse);
  }
}
