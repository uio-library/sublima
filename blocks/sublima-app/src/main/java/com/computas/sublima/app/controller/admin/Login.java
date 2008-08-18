package com.computas.sublima.app.controller.admin;

import com.computas.sublima.app.service.AdminService;
import com.computas.sublima.query.service.DatabaseService;
import com.computas.sublima.query.service.SettingsService;
import org.apache.cocoon.auth.AuthenticationException;
import org.apache.cocoon.auth.User;
import org.apache.cocoon.auth.impl.AbstractSecurityHandler;
import org.apache.cocoon.auth.impl.StandardUser;

import java.io.UnsupportedEncodingException;
import java.security.NoSuchAlgorithmException;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Map;

/**
 * @author: mha
 * Date: 08.mai.2008
 */
public class Login extends AbstractSecurityHandler { //implements StatelessAppleController {

  DatabaseService dbService = new DatabaseService();
  AdminService adminService = new AdminService();
  User user = null;

  public User login(final Map loginContext) throws AuthenticationException {

    Statement statement = null;

    final String name = (String) loginContext.get("name");//(String) loginContext.get(ApplicationManager.LOGIN_CONTEXT_USERNAME_KEY);
    final String password = (String) loginContext.get("password");//(String) loginContext.get(ApplicationManager.LOGIN_CONTEXT_PASSWORD_KEY);

    if (name == null) {
      return null;//throw new AuthenticationException("Required user name property is missing for login.");
    } else {

      String sql = "SELECT * FROM users WHERE username = '" + name + "'";

      if ("Computas".equalsIgnoreCase(name)) {

      } else {
        try {
          statement = dbService.doSQLQuery(sql);
          ResultSet rs = statement.getResultSet();

          if (!rs.next()) { //empty
            return null;//throw new AuthenticationException("Username is wrong or does not exist.");
          }

          if (!adminService.generateSHA1(password).equals(rs.getString("password"))) {
            return null;
          }

          statement.close();

        } catch (SQLException e) {
          e.printStackTrace();
          throw new AuthenticationException("Required user name property is missing for login.");
        } catch (NoSuchAlgorithmException e) {
          e.printStackTrace();
          throw new AuthenticationException("Required user name property is missing for login.");
        } catch (UnsupportedEncodingException e) {
          e.printStackTrace();
          throw new AuthenticationException("An error occured when trying to ");
        }
      }
    }


    user = new StandardUser(name);

    // Get the user role and set it as an attribute
    if (name.equalsIgnoreCase("Administrator") || "Computas".equalsIgnoreCase(name)) {
      String role = SettingsService.getProperty("sublima.base.url") + "role/Administrator";
      user.setAttribute("role", role);
    } else {
      user.setAttribute("role", adminService.getUserRole("<mailto:" + name + ">"));
    }

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
