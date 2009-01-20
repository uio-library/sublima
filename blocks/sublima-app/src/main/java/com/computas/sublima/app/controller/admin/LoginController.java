package com.computas.sublima.app.controller.admin;

import com.computas.sublima.app.service.AdminService;
import com.computas.sublima.query.service.DatabaseService;
import org.apache.cocoon.components.flow.apples.AppleRequest;
import org.apache.cocoon.components.flow.apples.AppleResponse;
import org.apache.cocoon.components.flow.apples.StatelessAppleController;

import java.io.UnsupportedEncodingException;
import java.security.NoSuchAlgorithmException;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.HashMap;
import java.util.Map;

/**
 * @author: mha
 * Date: 08.mai.2008
 */
public class LoginController implements StatelessAppleController {

  DatabaseService dbService = new DatabaseService();
  AdminService adminService = new AdminService();

  public void process(AppleRequest appleRequest, AppleResponse appleResponse) throws Exception {

    if ("showform".equalsIgnoreCase(appleRequest.getSitemapParameter("mode"))) {
      Map<String, Object> bizData = new HashMap<String, Object>();
      StringBuilder messageBuffer = new StringBuilder();
      messageBuffer.append("<c:messages xmlns:c=\"http://xmlns.computas.com/cocoon\" xmlns:i18n=\"http://apache.org/cocoon/i18n/2.1\">\n");
      messageBuffer.append("</c:messages>\n");
      bizData.put("messages", messageBuffer.toString());
      bizData.put("facets", adminService.getMostOfTheRequestXMLWithPrefix(appleRequest) + "</c:request>");
      appleResponse.sendPage("xml/login", bizData);
    } else {
      boolean continueLogin = true;

      String name = appleRequest.getCocoonRequest().getParameter("username");
      String password = appleRequest.getCocoonRequest().getParameter("password");

      /*
      if ("Computas".equalsIgnoreCase(name) && "Computas".equalsIgnoreCase(password)) {
        // do nothing
      } else {*/

      if (name == null) {
        continueLogin = false;
      } else {
        String sql = "SELECT * FROM users WHERE username = '" + name + "'";
        Statement statement = null;

        try {

          ResultSet rs;

          Connection connection = dbService.getJavaSQLConnection();

          statement = connection.createStatement();
          rs = statement.executeQuery(sql);

          if (!rs.next()) { //empty
            continueLogin = false;
          }

          if (!adminService.generateSHA1(password).equals(rs.getString("password"))) {
            continueLogin = false;
          }

          statement.close();
          connection.close();         


        } catch (SQLException e) {
          e.printStackTrace();
          continueLogin = false;
        } catch (NoSuchAlgorithmException e) {
          e.printStackTrace();
          continueLogin = false;
        } catch (UnsupportedEncodingException e) {
          e.printStackTrace();
          continueLogin = false;
        }
      }
      //}

      if (!continueLogin) {
        Map<String, Object> bizData = new HashMap<String, Object>();
        StringBuilder messageBuffer = new StringBuilder();
        messageBuffer.append("<c:messages xmlns:c=\"http://xmlns.computas.com/cocoon\" xmlns:i18n=\"http://apache.org/cocoon/i18n/2.1\">\n");
        messageBuffer.append("<c:message><i18n:text key=\"admin.login.failed\" xmlns:i18n=\"http://apache.org/cocoon/i18n/2.1\"/></c:message>");
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