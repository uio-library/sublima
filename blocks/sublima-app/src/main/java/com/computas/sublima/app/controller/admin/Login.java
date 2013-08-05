package com.computas.sublima.app.controller.admin;

import com.computas.sublima.app.service.AdminService;
import com.computas.sublima.app.service.LoginService;
import com.computas.sublima.query.service.SettingsService;
import org.apache.cocoon.auth.AuthenticationException;
import org.apache.cocoon.auth.User;
import org.apache.cocoon.auth.impl.AbstractSecurityHandler;
import org.apache.cocoon.auth.impl.StandardUser;

import java.util.Map;

/**
 * @author: mha
 * Date: 08.mai.2008
 */
public class Login extends AbstractSecurityHandler { //implements StatelessAppleController {

  private LoginService loginService = new LoginService();
  private AdminService adminService = new AdminService();

  public User login(final Map loginContext) throws AuthenticationException {
    User user = null;

    final String name = (String) loginContext.get("name");//(String) loginContext.get(ApplicationManager.LOGIN_CONTEXT_USERNAME_KEY);
    final String password = (String) loginContext.get("password");//(String) loginContext.get(ApplicationManager.LOGIN_CONTEXT_PASSWORD_KEY);

    if ((name == null) || !loginService.validateUser(name, password)) {
      return null;//throw new AuthenticationException("Required user name property is missing for login.");
    }

    user = new StandardUser(name);

    // Get the user role and set it as an attribute
    if (name.equalsIgnoreCase("Administrator")) {
      String role = SettingsService.getProperty("sublima.base.url") + "role/Administrator";
      user.setAttribute("role", role);
      user.setAttribute("uri", SettingsService.getProperty("sublima.base.url") + "user/Administrator");
    } else {
      user.setAttribute("uri", SettingsService.getProperty("sublima.base.url") + "user/mailto" + name.replace("@", "").replace(".", ""));
      user.setAttribute("role", adminService.getUserRole("<mailto:" + name + ">"));
    }

    return user;
  }

  /**
   * @see org.apache.cocoon.auth.SecurityHandler#logout(java.util.Map, org.apache.cocoon.auth.User)
   */
  public void logout(final Map logoutContext, final User user) {
    // nothing to do here
  }

}
