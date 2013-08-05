package com.computas.sublima.app.controller.admin;

import com.computas.sublima.app.service.AdminService;
import com.computas.sublima.app.service.LanguageService;
import com.computas.sublima.app.service.LoginService;

import org.apache.cocoon.auth.AuthenticationException;
import org.apache.cocoon.components.flow.apples.AppleRequest;
import org.apache.cocoon.components.flow.apples.AppleResponse;
import org.apache.cocoon.components.flow.apples.StatelessAppleController;

import java.util.HashMap;
import java.util.Map;

/**
 * @author: mha
 * Date: 08.mai.2008
 */
public class LoginController implements StatelessAppleController {

  private LoginService loginService = new LoginService();
  private AdminService adminService = new AdminService();

  public void process(AppleRequest appleRequest, AppleResponse appleResponse) {

    LanguageService langServ = new LanguageService();
    String language = langServ.checkLanguage(appleRequest, appleResponse);

    if ("showform".equalsIgnoreCase(appleRequest.getSitemapParameter("mode"))) {
      Map<String, Object> bizData = new HashMap<String, Object>();
      StringBuilder messageBuffer = new StringBuilder();
      messageBuffer.append("<c:messages xmlns:c=\"http://xmlns.computas.com/cocoon\" xmlns:i18n=\"http://apache.org/cocoon/i18n/2.1\">\n");
      messageBuffer.append("</c:messages>\n");
      bizData.put("messages", messageBuffer.toString());
      bizData.put("facets", adminService.getMostOfTheRequestXMLWithPrefix(appleRequest) + "</c:request>");
      appleResponse.sendPage("xml/login", bizData);
    } else {

      String name = appleRequest.getCocoonRequest().getParameter("username");
      String password = appleRequest.getCocoonRequest().getParameter("password");
      boolean validUser = false;
      String validationMessage = null;
      
      try {
	  validUser = loginService.validateUser(name, password);
      } catch (AuthenticationException e) {
	  validationMessage = e.getMessage();
      }
      
      if (!validUser) {
        Map<String, Object> bizData = new HashMap<String, Object>();
        StringBuilder messageBuffer = new StringBuilder();
        messageBuffer.append("<c:messages xmlns:c=\"http://xmlns.computas.com/cocoon\" xmlns:i18n=\"http://apache.org/cocoon/i18n/2.1\">\n");
        messageBuffer.append("<c:message><i18n:text key=\"admin.login.failed\" xmlns:i18n=\"http://apache.org/cocoon/i18n/2.1\"/></c:message>");
        
        if (validationMessage != null) {
            messageBuffer.append("<c:message>" + validationMessage + "</c:message>");
        }
        
        messageBuffer.append("</c:messages>\n");
        bizData.put("messages", messageBuffer.toString());
        bizData.put("facets", adminService.getMostOfTheRequestXMLWithPrefix(appleRequest) + "</c:request>");
        appleResponse.sendPage("xml/login", bizData);

      } else {
        appleResponse.sendPage("do-login", null);
      }
    }
  }
}