package com.computas.sublima.app.controller;

import com.computas.sublima.app.controller.admin.AdminController;
import com.computas.sublima.app.service.AdminService;
import com.computas.sublima.query.SparqlDispatcher;
import com.computas.sublima.query.SparulDispatcher;
import com.computas.sublima.query.service.DatabaseService;
import static com.computas.sublima.query.service.SettingsService.getProperty;
import com.hp.hpl.jena.sparql.util.StringUtils;
import org.apache.cocoon.components.flow.apples.AppleRequest;
import org.apache.cocoon.components.flow.apples.AppleResponse;
import org.apache.cocoon.components.flow.apples.StatelessAppleController;
import org.apache.log4j.Logger;

import java.io.UnsupportedEncodingException;
import java.security.NoSuchAlgorithmException;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

/**
 * @author: mha
 * Date: 31.mar.2008
 */
public class UserController implements StatelessAppleController {

  private SparqlDispatcher sparqlDispatcher;
  private SparulDispatcher sparulDispatcher;
  AdminService adminService = new AdminService();
  DatabaseService dbService = new DatabaseService();
  private String mode;
  private String submode;
  String[] completePrefixArray = {
          "PREFIX dct: <http://purl.org/dc/terms/>",
          "PREFIX foaf: <http://xmlns.com/foaf/0.1/>",
          "PREFIX sub: <http://xmlns.computas.com/sublima#>",
          "PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>",
          "PREFIX wdr: <http://www.w3.org/2007/05/powder#>",
          "PREFIX skos: <http://www.w3.org/2004/02/skos/core#>",
          "PREFIX lingvoj: <http://www.lingvoj.org/ontology#>",
          "PREFIX sioc: <http://rdfs.org/sioc/ns#>"};

  String completePrefixes = StringUtils.join("\n", completePrefixArray);
  String[] prefixArray = {
          "dct: <http://purl.org/dc/terms/>",
          "foaf: <http://xmlns.com/foaf/0.1/>",
          "sub: <http://xmlns.computas.com/sublima#>",
          "rdfs: <http://www.w3.org/2000/01/rdf-schema#>",
          "wdr: <http://www.w3.org/2007/05/powder#>",
          "skos: <http://www.w3.org/2004/02/skos/core#>",
          "lingvoj: <http://www.lingvoj.org/ontology#>",
          "sioc: <http://rdfs.org/sioc/ns#>"};
  String prefixes = StringUtils.join("\n", prefixArray);

  private static Logger logger = Logger.getLogger(AdminController.class);

  @SuppressWarnings("unchecked")
  public void process(AppleRequest req, AppleResponse res) throws Exception {

    this.mode = req.getSitemapParameter("mode");
    this.submode = req.getSitemapParameter("submode");

    if ("brukere".equalsIgnoreCase(mode)) {
      if ("".equalsIgnoreCase(submode)) {
        res.sendPage("xml2/brukere", null);
        return;
      } else if ("ny".equalsIgnoreCase(submode)) {
        editUser(req, res, "ny", null);
        return;
      } else if ("bruker".equalsIgnoreCase(submode)) {
        editUser(req, res, "edit", null);
        return;
      } else if ("alle".equalsIgnoreCase(submode)) {
        listUsers(req, res);
        return;
      } else {
        res.sendStatus(404);
        return;
      }
    } else if ("roller".equalsIgnoreCase(mode)) {
      if ("".equalsIgnoreCase(submode) || submode == null) {
        res.sendPage("xml2/roller", null);
        return;
      } else if ("rolle".equalsIgnoreCase(submode)) {
        editRole(req, res, null);
        return;
      }
    }
  }

  public void editUser(AppleRequest req, AppleResponse res, String type, String messages) {
    StringBuffer messageBuffer = new StringBuffer();
    messageBuffer.append("<c:messages xmlns:c=\"http://xmlns.computas.com/cocoon\">\n");
    messageBuffer.append(messages);
    Map<String, Object> bizData = new HashMap<String, Object>();
    bizData.put("allroles", adminService.getAllRoles());

    if (req.getCocoonRequest().getMethod().equalsIgnoreCase("GET")) {
      bizData.put("tempvalues", "<empty></empty>");

      if ("ny".equalsIgnoreCase(type)) {
        bizData.put("userdetails", "<empty></empty>");
      } else {
        bizData.put("userdetails", adminService.getUserByURI(req.getCocoonRequest().getParameter("uri")));
      }

      bizData.put("mode", "useredit");
      bizData.put("messages", "<empty></empty>");
      res.sendPage("xml2/bruker", bizData);

      // When POST try to save the user. Return error messages upon failure, and success message upon great success
    } else if (req.getCocoonRequest().getMethod().equalsIgnoreCase("POST")) {

      // 1. Mellomlagre alle verdier
      // 2. Valider alle verdier
      // 3. Forsøk å lagre

      StringBuffer tempValues = getUserTempValues(req);
      String tempPrefixes = "<c:tempvalues \n" +
              "xmlns:skos=\"http://www.w3.org/2004/02/skos/core#\"\n" +
              "xmlns:rdfs=\"http://www.w3.org/2000/01/rdf-schema#\"\n" +
              "xmlns:rdf=\"http://www.w3.org/1999/02/22-rdf-syntax-ns#\"\n" +
              "xmlns:c=\"http://xmlns.computas.com/cocoon\"\n" +
              "xmlns:sioc= \"http://rdfs.org/sioc/ns#\">\n";

      String validationMessages = validateUserRequest(req);
      if (!"".equalsIgnoreCase(validationMessages)) {
        messageBuffer.append(validationMessages + "\n");
        messageBuffer.append("</c:messages>\n");

        bizData.put("userdetails", "<empty></empty>");
        bizData.put("tempvalues", tempPrefixes + tempValues.toString() + "</c:tempvalues>");
        bizData.put("messages", messageBuffer.toString());
        bizData.put("mode", "usertemp");

        res.sendPage("xml2/bruker", bizData);

      } else {

        boolean newUser = false;

        // Generate an identifier if a uri is not given and insert the user in the USER-table
        String uri;
        if ("".equalsIgnoreCase(req.getCocoonRequest().getParameter("uri")) || req.getCocoonRequest().getParameter("uri") == null) {
          uri = req.getCocoonRequest().getParameter("rdfs:label").replace(" ", "_");
          uri = uri.replace(",", "_");
          uri = uri.replace(".", "_");
          uri = getProperty("sublima.base.url") + "user/" + uri + "_" + uri.hashCode();

          String deleteSql = "DELETE FROM users WHERE username ='" + req.getCocoonRequest().getParameter("sioc:email") + "'";

          String insertSql = "INSERT INTO users "
                  + "(username) "
                  + "VALUES "
                  + "('" + req.getCocoonRequest().getParameter("sioc:email") + "')";
          try {
            int deletedRows = dbService.doSQLUpdate(deleteSql);
            int insertedRows = dbService.doSQLUpdate(insertSql);
            newUser = true;
            // Fails if username already exists. Give feedback to the user.
          } catch (SQLException e) {
            e.printStackTrace();
            /*
            logger.trace("TopicController.editUser --> NEW USER: INSERT USERNAME FAILED\n");
            messageBuffer.append("<c:message>Brukernavnet finnes fra før</c:message>\n</c:messages>\n");

            bizData.put("userdetails", "<empty></empty>");
            bizData.put("tempvalues", tempPrefixes + tempValues.toString() + "</c:tempvalues>");
            bizData.put("messages", messageBuffer.toString());
            bizData.put("mode", "usertemp");
            res.sendPage("xml2/bruker", bizData);*/
            return;
          }


        } else {
          uri = req.getCocoonRequest().getParameter("uri");
        }

        // HER HAR MAN BRUKERNAVN I USER-TABELLEN UANSETT

        if (!newUser) {
          // If the user has changed her e-mail address (username), we must update it in the USER-table
          if (!("mailto:" + req.getCocoonRequest().getParameter("sioc:email")).equalsIgnoreCase(req.getCocoonRequest().getParameter("oldusername"))) {
            //Strip away the sioc mailto
            String insertSql;
            if ("".equalsIgnoreCase(req.getCocoonRequest().getParameter("oldusername"))) {
              insertSql = "INSERT INTO users "
                      + "(username) "
                      + "VALUES('" + req.getCocoonRequest().getParameter("sioc:email") + "')";
            } else {
              String[] username = req.getCocoonRequest().getParameter("oldusername").split(":");
              insertSql = "UPDATE users "
                      + "SET username = '" + req.getCocoonRequest().getParameter("sioc:email") + "' "
                      + "WHERE username = '" + username[1] + "'";
            }

            try {
              int insertedRows = dbService.doSQLUpdate(insertSql);
            } catch (SQLException e) {
              e.printStackTrace();
              logger.trace("TopicController.editUser --> EXISTING USER: INSERT USERINFO FAILED\n");
            }

          }
        }

        // If it's a new user and the passowrd is "passwordplaceholder" give an errormessage (can't do this in validation because of existing user/unchanged password thingie
        if (newUser && req.getCocoonRequest().getParameter("password1").equalsIgnoreCase("passwordplaceholder")) {
          messageBuffer.append("<c:message>Passordet må angis på nytt</c:message>\n</c:messages>\n");

          bizData.put("userdetails", "<empty></empty>");
          bizData.put("tempvalues", tempPrefixes + tempValues.toString() + "</c:tempvalues>");
          bizData.put("messages", messageBuffer.toString());
          bizData.put("mode", "usertemp");

          res.sendPage("xml2/bruker", bizData);
        }

        // If the given password is "passwordplaceholder", then the user hasn't changed her password and we leave it as it is
        if (!req.getCocoonRequest().getParameter("password1").equalsIgnoreCase("passwordplaceholder")) {
          // Encrypt the password and store it in a database table
          int insertedRows = 0;
          try {
            String password = adminService.generateSHA1(req.getCocoonRequest().getParameter("password1"));
            logger.trace("TopicController.editUser --> GENERATE PASSWORD SHA1 " + password + "\n");

            String insertSql = "UPDATE users "
                    + "SET password = '" + password + "' "
                    + "WHERE username = '" + req.getCocoonRequest().getParameter("sioc:email") + "'";

            logger.trace("TopicController.editUser --> INSERT USERINFO:\n" + insertSql);

            try {
              insertedRows = dbService.doSQLUpdate(insertSql);
            } catch (SQLException e) {
              e.printStackTrace();
              logger.trace("TopicController.editUser --> INSERT USERINFO FAILED\n");
            }


          } catch (NoSuchAlgorithmException e) {
            e.printStackTrace();
          } catch (UnsupportedEncodingException e) {
            e.printStackTrace();
          }

          // If insertedRows is 0, then the insert failed and we give the user a proper feedback
          if (insertedRows == 0) {
            messageBuffer.append("<c:message>En feil skjedde ved innlegging av passordet, vennligst kontroller alle felter og prøv igjen</c:message>" + "\n");
            messageBuffer.append("</c:messages>\n");
            bizData.put("userdetails", "<empty></empty>");
            bizData.put("tempvalues", tempPrefixes + tempValues.toString() + "</c:tempvalues>");
            bizData.put("messages", messageBuffer.toString());
            bizData.put("mode", "usertemp");

            res.sendPage("xml2/bruker", bizData);
            return;
          }
        }

        StringBuffer deleteString = new StringBuffer();
        StringBuffer whereString = new StringBuffer();
        deleteString.append(completePrefixes);
        deleteString.append("\nDELETE\n{\n");
        whereString.append("\nWHERE\n{\n");
        deleteString.append("<" + uri + "> a sioc:User .\n");
        deleteString.append("<" + uri + "> sioc:email ?email .\n");
        deleteString.append("<" + uri + "> rdfs:label ?name .\n");
        deleteString.append("<" + uri + "> sioc:Role ?role .\n");

        deleteString.append("}\n");
        whereString.append("<" + uri + "> a sioc:User .\n");
        whereString.append("<" + uri + "> sioc:email ?email .\n");
        whereString.append("<" + uri + "> rdfs:label ?name .\n");
        whereString.append("<" + uri + "> sioc:Role ?role .\n");
        whereString.append("}\n");


        StringBuffer insertString = new StringBuffer();
        insertString.append(completePrefixes);
        insertString.append("\nINSERT\n{\n");
        insertString.append("<" + uri + "> a sioc:User ;\n");
        insertString.append("    rdfs:label \"" + req.getCocoonRequest().getParameter("rdfs:label") + "\"@no ;\n");
        insertString.append("    sioc:email <mailto:" + req.getCocoonRequest().getParameter("sioc:email") + "> ;\n");
        insertString.append("    sioc:Role <" + req.getCocoonRequest().getParameter("sioc:role") + ">.\n");
        insertString.append("}");

        deleteString.append(whereString.toString());

        boolean deleteSuccess = sparulDispatcher.query(deleteString.toString());
        boolean insertSuccess = sparulDispatcher.query(insertString.toString());


        logger.trace("TopicController.editUser --> DELETE QUERY:\n" + deleteString.toString());
        logger.trace("TopicController.editUser --> INSERT QUERY:\n" + insertString.toString());

        logger.trace("TopicController.editUser --> DELETE QUERY RESULT: " + deleteSuccess);
        logger.trace("TopicController.editUser --> INSERT QUERY RESULT: " + insertSuccess);

        if (deleteSuccess && insertSuccess) {
          messageBuffer.append("<c:message>Bruker oppdatert!</c:message>\n");
          bizData.put("userdetails", adminService.getUserByURI(uri));
          bizData.put("tempvalues", "<empty></empty>");
          bizData.put("mode", "useredit");

        } else {
          messageBuffer.append("<c:message>Feil ved oppdatering av bruker</c:message>\n");
          bizData.put("userdetails", "<empty></empty>");
          bizData.put("tempvalues", tempPrefixes + tempValues.toString() + "</c:tempvalues>");
          bizData.put("mode", "usertemp");
        }

        messageBuffer.append("</c:messages>\n");
        bizData.put("messages", messageBuffer.toString());
        res.sendPage("xml2/bruker", bizData);
      }
    }
  }


  public void editRole(AppleRequest req, AppleResponse res, String messages) {
    StringBuffer messageBuffer = new StringBuffer();
    messageBuffer.append("<c:messages xmlns:c=\"http://xmlns.computas.com/cocoon\">\n");
    messageBuffer.append(messages);
    Map<String, Object> bizData = new HashMap<String, Object>();
    bizData.put("allroles", adminService.getAllRoles());
    //bizData.put("allanguages", adminService.getAllLanguages());

    if (req.getCocoonRequest().getMethod().equalsIgnoreCase("GET")) {
      bizData.put("tempvalues", "<empty></empty>");

      if ("".equalsIgnoreCase(req.getCocoonRequest().getParameter("uri")) || req.getCocoonRequest().getParameter("uri") == null) {
        bizData.put("roledetails", "<empty></empty>");
      } else {
        bizData.put("roledetails", adminService.getRoleByURI(req.getCocoonRequest().getParameter("uri")));
      }

      bizData.put("mode", "roleedit");
      bizData.put("messages", "<empty></empty>");
      res.sendPage("xml2/rolle", bizData);

      // When POST try to save the user. Return error messages upon failure, and success message upon great success
    } else if (req.getCocoonRequest().getMethod().equalsIgnoreCase("POST")) {

      // 1. Mellomlagre alle verdier
      // 2. Valider alle verdier
      // 3. Forsøk å lagre

      StringBuffer tempValues = getRoleTempValues(req);
      String tempPrefixes = "<c:tempvalues \n" +
              "xmlns:skos=\"http://www.w3.org/2004/02/skos/core#\"\n" +
              "xmlns:rdfs=\"http://www.w3.org/2000/01/rdf-schema#\"\n" +
              "xmlns:rdf=\"http://www.w3.org/1999/02/22-rdf-syntax-ns#\"\n" +
              "xmlns:c=\"http://xmlns.computas.com/cocoon\"\n" +
              "xmlns:sioc= \"http://rdfs.org/sioc/ns#\">\n";

      String validationMessages = validateRoleRequest(req);
      if (!"".equalsIgnoreCase(validationMessages)) {
        messageBuffer.append(validationMessages + "\n");
        messageBuffer.append("</c:messages>\n");

        bizData.put("roledetails", "<empty></empty>");
        bizData.put("tempvalues", tempPrefixes + tempValues.toString() + "</c:tempvalues>");
        bizData.put("messages", messageBuffer.toString());
        bizData.put("mode", "roletemp");

        res.sendPage("xml2/rolle", bizData);

      } else {

        // Generate an identifier if a uri is not given and insert the user in the USER-table
        String uri;
        if ("".equalsIgnoreCase(req.getCocoonRequest().getParameter("uri")) || req.getCocoonRequest().getParameter("uri") == null) {
          uri = req.getCocoonRequest().getParameter("rdfs:label").replace(" ", "_");
          uri = uri.replace(",", "_");
          uri = uri.replace(".", "_");
          uri = getProperty("sublima.base.url") + "role/" + uri + "_" + uri.hashCode();
        } else {
          uri = req.getCocoonRequest().getParameter("uri");
        }

        StringBuffer deleteString = new StringBuffer();
        StringBuffer whereString = new StringBuffer();
        deleteString.append(completePrefixes);
        deleteString.append("\nDELETE\n{\n");
        whereString.append("\nWHERE\n{\n");
        deleteString.append("<" + uri + "> a sioc:Role .\n");
        deleteString.append("<" + uri + "> rdfs:label ?name .\n");

        deleteString.append("}\n");
        whereString.append("<" + uri + "> a sioc:Role .\n");
        whereString.append("<" + uri + "> rdfs:label ?name .\n");
        whereString.append("}\n");


        StringBuffer insertString = new StringBuffer();
        insertString.append(completePrefixes);
        insertString.append("\nINSERT\n{\n");
        insertString.append("<" + uri + "> a sioc:Role ;\n");
        insertString.append("    rdfs:label \"" + req.getCocoonRequest().getParameter("rdfs:label") + "\"@no ;\n");
        insertString.append("}");

        deleteString.append(whereString.toString());

        boolean deleteSuccess = sparulDispatcher.query(deleteString.toString());
        boolean insertSuccess = sparulDispatcher.query(insertString.toString());


        logger.trace("TopicController.editRole --> DELETE QUERY:\n" + deleteString.toString());
        logger.trace("TopicController.editRole --> INSERT QUERY:\n" + insertString.toString());

        logger.trace("TopicController.editRole --> DELETE QUERY RESULT: " + deleteSuccess);
        logger.trace("TopicController.editRole --> INSERT QUERY RESULT: " + insertSuccess);

        if (deleteSuccess && insertSuccess) {
          messageBuffer.append("<c:message>Rolle oppdatert!</c:message>\n");
          bizData.put("roledetails", adminService.getRoleByURI(uri));
          bizData.put("tempvalues", "<empty></empty>");
          bizData.put("mode", "roleedit");

        } else {
          messageBuffer.append("<c:message>Feil ved oppdatering av rolle</c:message>\n");
          bizData.put("topicdetails", "<empty></empty>");
          bizData.put("tempvalues", tempPrefixes + tempValues.toString() + "</c:tempvalues>");
          bizData.put("mode", "roletemp");
        }

        messageBuffer.append("</c:messages>\n");

        bizData.put("messages", messageBuffer.toString());

        res.sendPage("xml2/rolle", bizData);
      }
    }
  }

  public void listUsers(AppleRequest req, AppleResponse res) {
    Map<String, Object> bizData = new HashMap<String, Object>();
    bizData.put("allusers", adminService.getAllUsers());
    res.sendPage("xml2/brukere_alle", bizData);
  }

  private String validateUserRequest(AppleRequest req) {
    StringBuffer validationMessages = new StringBuffer();

    if ("".equalsIgnoreCase(req.getCocoonRequest().getParameter("sioc:email")) || req.getCocoonRequest().getParameter("sioc:email") == null) {
      validationMessages.append("<c:message>E-post (brukernavn) kan ikke være blank</c:message>\n");
    }

    if ("".equalsIgnoreCase(req.getCocoonRequest().getParameter("rdfs:label")) || req.getCocoonRequest().getParameter("rdfs:label") == null) {
      validationMessages.append("<c:message>Navn kan ikke være blank</c:message>\n");
    }

    if ("".equalsIgnoreCase(req.getCocoonRequest().getParameter("password1")) ||
            req.getCocoonRequest().getParameter("password1") == null ||
            "".equalsIgnoreCase(req.getCocoonRequest().getParameter("password2")) ||
            req.getCocoonRequest().getParameter("password2") == null) {
      validationMessages.append("<c:message>Passordfeltene kan ikke være blanke, og må være like</c:message>\n");
    }

    if (!req.getCocoonRequest().getParameter("password1").equals(req.getCocoonRequest().getParameter("password2"))) {
      validationMessages.append("<c:message>Passordfeltene må være like</c:message>\n");
    }

    if ("".equalsIgnoreCase(req.getCocoonRequest().getParameter("sioc:role")) || req.getCocoonRequest().getParameter("sioc:role") == null) {
      validationMessages.append("<c:message>En rolle må være valgt</c:message>\n");
    }

    return validationMessages.toString();
  }

  private String validateRoleRequest(AppleRequest req) {
    StringBuffer validationMessages = new StringBuffer();

    if ("".equalsIgnoreCase(req.getCocoonRequest().getParameter("rdfs:label")) || req.getCocoonRequest().getParameter("rdfs:label") == null) {
      validationMessages.append("<c:message>Navn kan ikke være blank</c:message>\n");
    }

    return validationMessages.toString();
  }

  private StringBuffer getUserTempValues(AppleRequest req) {
    StringBuffer tempValues = new StringBuffer();

    String uri = req.getCocoonRequest().getParameter("uri");
    String temp_email = req.getCocoonRequest().getParameter("sioc:email");
    String temp_name = req.getCocoonRequest().getParameter("rdfs:label");
    String temp_oldusername = req.getCocoonRequest().getParameter("oldusername");
    String temp_role = req.getCocoonRequest().getParameter("sioc:role");

    //Create an XML structure for the selected values, to use in the JX template
    tempValues.append("<rdf:about>" + uri + "</rdf:about>\n");
    tempValues.append("<sioc:email>" + temp_email + "</sioc:email>\n");
    tempValues.append("<rdfs:label>" + temp_name + "</rdfs:label>\n");
    tempValues.append("<c:oldusername>" + temp_oldusername + "</c:oldusername>");
    tempValues.append("<sioc:role>" + temp_role + "</sioc:role>");

    return tempValues;
  }

  private StringBuffer getRoleTempValues(AppleRequest req) {
    return null;
  }

  public void setSparqlDispatcher
          (SparqlDispatcher
                  sparqlDispatcher) {
    this.sparqlDispatcher = sparqlDispatcher;
  }

  public void setSparulDispatcher
          (SparulDispatcher
                  sparulDispatcher) {
    this.sparulDispatcher = sparulDispatcher;
  }
}

