package com.computas.sublima.app.controller.admin;

import com.computas.sublima.query.SparqlDispatcher;
import com.computas.sublima.query.SparulDispatcher;
import com.computas.sublima.query.service.AdminService;
import static com.computas.sublima.query.service.SettingsService.getProperty;
import com.hp.hpl.jena.sparql.util.StringUtils;
import org.apache.cocoon.components.flow.apples.AppleRequest;
import org.apache.cocoon.components.flow.apples.AppleResponse;
import org.apache.cocoon.components.flow.apples.StatelessAppleController;
import org.apache.log4j.Logger;

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
      } else if ("roller".equalsIgnoreCase(submode)) {
        return;
      } else {
        res.sendStatus(404);
        return;
      }
    }
  }

  public void editUser(AppleRequest req, AppleResponse res, String type, String messages) {
    StringBuffer messageBuffer = new StringBuffer();
    messageBuffer.append("<c:messages xmlns:c=\"http://xmlns.computas.com/cocoon\">\n");
    messageBuffer.append(messages);
    Map<String, Object> bizData = new HashMap<String, Object>();

    if (req.getCocoonRequest().getMethod().equalsIgnoreCase("GET")) {
      bizData.put("tempvalues", "<empty></empty>");

      if ("ny".equalsIgnoreCase(type)) {
        bizData.put("userdetails", "<empty></empty>");
      } else {
        bizData.put("userdetails", adminService.getUserByURI(req.getCocoonRequest().getParameter("uri")));
      }

      bizData.put("allroles", "<empty></empty>");
      bizData.put("mode", "useredit");
      bizData.put("messages", "<empty></empty>");
      res.sendPage("xml2/bruker", bizData);

      // When POST try to save the user. Return error messages upon failure, and success message upon great success
    } else if (req.getCocoonRequest().getMethod().equalsIgnoreCase("POST")) {

      // 1. Mellomlagre alle verdier
      // 2. Valider alle verdier
      // 3. Forsøk å lagre

      StringBuffer tempValues = getTempValues(req);
      String tempPrefixes = "<c:tempvalues \n" +
              "xmlns:skos=\"http://www.w3.org/2004/02/skos/core#\"\n" +
              "xmlns:rdfs=\"http://www.w3.org/2000/01/rdf-schema#\"\n" +
              "xmlns:rdf=\"http://www.w3.org/1999/02/22-rdf-syntax-ns#\"\n" +
              "xmlns:c=\"http://xmlns.computas.com/cocoon\"\n" +
              "xmlns:sioc: \"http://rdfs.org/sioc/ns#\">\n";

      String validationMessages = validateRequest(req);
      if (!"".equalsIgnoreCase(validationMessages)) {
        messageBuffer.append(validationMessages + "\n");
        messageBuffer.append("</c:messages>\n");

        bizData.put("tempvalues", tempPrefixes + tempValues.toString() + "</c:tempvalues>");
        bizData.put("messages", messageBuffer.toString());
        bizData.put("mode", "usertemp");

        res.sendPage("xml2/bruker", bizData);

      } else {
        // Generate an identifier if a uri is not given
        String uri;
        if ("".equalsIgnoreCase(req.getCocoonRequest().getParameter("uri")) || req.getCocoonRequest().getParameter("uri") == null) {
          uri = req.getCocoonRequest().getParameter("rdfs:label").replace(" ", "_");
          uri = uri.replace(",", "_");
          uri = uri.replace(".", "_");
          uri = getProperty("sublima.base.url") + "user/" + uri + "_" + uri.hashCode();
        } else {
          uri = req.getCocoonRequest().getParameter("uri");
        }

        StringBuffer deleteString = new StringBuffer();
        StringBuffer whereString = new StringBuffer();
        deleteString.append(completePrefixes);
        deleteString.append("\nDELETE\n{\n");
        whereString.append("\nWHERE\n{\n");
        deleteString.append("<" + uri + "> a sioc:User .\n");
        deleteString.append("<" + uri + "> sioc:email ?email .\n");
        deleteString.append("<" + uri + "> rdfs:label ?name .\n");

        deleteString.append("}\n");
        whereString.append("<" + uri + "> a sioc:User .\n");
        whereString.append("<" + uri + "> sioc:email ?email .\n");
        whereString.append("<" + uri + "> rdfs:label ?name .\n");
        whereString.append("}\n");


        StringBuffer insertString = new StringBuffer();
        insertString.append(completePrefixes);
        insertString.append("\nINSERT\n{\n");
        insertString.append("<" + uri + "> a sioc:User ;\n");
        insertString.append("    rdfs:label \"" + req.getCocoonRequest().getParameter("rdfs:label") + "\"@no ;\n") ;
        insertString.append("    sioc:email <mailto:" + req.getCocoonRequest().getParameter("sioc:email") + "> .\n") ;
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

        } else {
          messageBuffer.append("<c:message>Feil ved oppdatering av bruker</c:message>\n");
          bizData.put("topicdetails", "<empty></empty>");
        }

        if (deleteSuccess && insertSuccess) {
          bizData.put("userdetails", adminService.getUserByURI(req.getCocoonRequest().getParameter("uri")));
          bizData.put("tempvalues", "<empty></empty>");
          bizData.put("allroles", "<empty></empty>");
          bizData.put("mode", "useredit");
        } else {
          bizData.put("tempvalues", tempPrefixes + tempValues.toString() + "</c:tempvalues>");
          bizData.put("allroles", "<empty></empty>");
          bizData.put("mode", "usertemp");
        }

        messageBuffer.append("</c:messages>\n");

        bizData.put("messages", messageBuffer.toString());

        res.sendPage("xml2/bruker", bizData);
      }
    }
  }

  public void listUsers(AppleRequest req, AppleResponse res) {
    Map<String, Object> bizData = new HashMap<String, Object>();
    bizData.put("allusers", adminService.getAllUsers());
    res.sendPage("xml2/brukere_alle", bizData);
  }

  private String validateRequest(AppleRequest req) {
    return "";
  }

  private StringBuffer getTempValues(AppleRequest req) {
    StringBuffer tempValues = new StringBuffer();
    

    return tempValues;
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

