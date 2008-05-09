package com.computas.sublima.app.controller.admin;

import org.apache.cocoon.auth.ApplicationManager;
import org.apache.cocoon.auth.AuthenticationException;
import org.apache.cocoon.auth.User;
import org.apache.cocoon.auth.impl.AbstractSecurityHandler;
import org.apache.cocoon.auth.impl.StandardUser;
import org.apache.commons.lang.StringUtils;

import java.util.Map;

/**
 * @author: mha
 * Date: 08.mai.2008
 */
public class LoginController extends AbstractSecurityHandler {

  /**
   * The properties.
   */

  public User login(final Map loginContext) throws AuthenticationException {

    //todo Get the username from DB and check if it exists
    final String name = (String) loginContext.get(ApplicationManager.LOGIN_CONTEXT_USERNAME_KEY);

    if (name == null) {
      throw new AuthenticationException("Required user name property is missing for login.");
    }

    //todo Get the password for the given user from DB
    final String password = (String) loginContext.get(ApplicationManager.LOGIN_CONTEXT_PASSWORD_KEY);


    // todo Check if the given password and the DB password match
    if (!StringUtils.equals(password, "Computas")) {
      return null;
    }

    final User user = new StandardUser(name);

    //todo Set additional user attributes. Such as role etc.
    /*
    // check for additional attributes
    final String prefix = name + '.';
    final Iterator i = this.userProperties.entrySet().iterator();

    while (i.hasNext()) {
      final Map.Entry current = (Map.Entry) i.next();
      if (current.getKey().toString().startsWith(prefix)) {
        final String key = current.getKey().toString().substring(prefix.length());
        user.setAttribute(key, current.getValue());
      }
    }*/

    return user;
  }

  /**
   * @see org.apache.cocoon.auth.SecurityHandler#logout(java.util.Map, org.apache.cocoon.auth.User)
   */
  public void logout(final Map logoutContext, final User user) {
    // nothing to do here
  }


}
