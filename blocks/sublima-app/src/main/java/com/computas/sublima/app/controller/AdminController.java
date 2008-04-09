package com.computas.sublima.app.controller;

import com.computas.sublima.query.SparqlDispatcher;
import com.computas.sublima.query.SparulDispatcher;
import com.hp.hpl.jena.sparql.util.StringUtils;
import org.apache.cocoon.components.flow.apples.AppleRequest;
import org.apache.cocoon.components.flow.apples.AppleResponse;
import org.apache.cocoon.components.flow.apples.StatelessAppleController;
import org.apache.cocoon.environment.Request;
import org.apache.log4j.Logger;

import java.util.ArrayList;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Map;

/**
 * @author: mha
 * Date: 31.mar.2008
 */
public class AdminController implements StatelessAppleController {

  private SparqlDispatcher sparqlDispatcher;
  private SparulDispatcher sparulDispatcher;
  private String mode;
  private String submode;

  private static Logger logger = Logger.getLogger(AdminController.class);

  @SuppressWarnings("unchecked")
  public void process(AppleRequest req, AppleResponse res) throws Exception {

    this.mode = req.getSitemapParameter("mode");
    this.submode = req.getSitemapParameter("submode");

    if ("".equalsIgnoreCase(mode)) {
      res.sendPage("xml2/admin", null);
    }
    // Linkcheck. Send the user to a page that displays a list of all resources affected.
    else if ("lenkesjekk".equalsIgnoreCase(mode)) {
      showLinkcheckResults(res, req);
      return;
    } else if ("insertpublisher".equalsIgnoreCase(mode)) {
      insertPublisherByName(res, req);
      return;
    }
    // Publishers. Send the user to a page that displays a list of all publishers.
    else if ("utgivere".equalsIgnoreCase(mode)) {
      if ("".equalsIgnoreCase(submode) || submode == null) {
        showPublishersIndex(res, req, null);
        return;
      } else if ("updatepublisher".equalsIgnoreCase(submode)) {
        updatePublisherByURI(res, req);
        return;
      } else if ("insertpublisher".equalsIgnoreCase(submode)) {
        insertPublisherByName(res, req);
        return;
      } else {
        showPublisherByURI(res, req, null, null);
        return;
      }
    }
    // Resources.
    else if ("ressurser".equalsIgnoreCase(mode)) {
      if ("".equalsIgnoreCase(submode) || submode == null) {
        showResourcesIndex(res, req);
        return;
      } else if ("foreslaatte".equalsIgnoreCase(submode)) {
        showSuggestedResources(res, req);
        return;
      } else {
        return;
      }
    } else {
      res.sendStatus(404);
      return;
    }
  }

  /**
   * Method to insert a new publisher
   *
   * @param res - AppleResponse
   * @param req - AppleRequest
   */
  private void insertPublisherByName(AppleResponse res, AppleRequest req) {

    String messages = "";
    String publishername = req.getCocoonRequest().getParameter("new_publisher");

    if ("".equalsIgnoreCase(publishername) || publishername == null) {
      messages = "<message>\nUtgivernavn må angis\n</message>";
    } else {

      // Check if a publisher by that name already exists
      //Find the publisher URI based on name
      String findPublisherByNameQuery = StringUtils.join("\n", new String[]{
            "PREFIX dct: <http://purl.org/dc/terms/>",
            "PREFIX foaf: <http://xmlns.com/foaf/0.1/>",
            "SELECT ?publisher ?name",
            "WHERE {",
            "?publisher a foaf:Agent ;",
            "           foaf:name ?name  .",
            "FILTER regex(str(?name), \"^" + publishername + "\", \"i\" )",
            //"FILTER langMatches( lang(?name), \"*\" )",
            "}"});

      logger.trace("AdminController.insertPublisherByName() --> SPARQL query sent to dispatcher: \n" + findPublisherByNameQuery);
      Object queryResult = sparqlDispatcher.query(findPublisherByNameQuery);

      if (queryResult.toString().contains(publishername)) {
        messages = "<message>\nEn utgiver med det navnet finnes allerede registrert\n</message>";
        showPublishersIndex(res, req, messages);
        return;
      }

      String publisherURI = publishername.replaceAll(" ", "_");
      //publisherURI = publisherURI.replaceAll(".", "_");
      //publisherURI = publisherURI.replaceAll(",", "_");
      //publisherURI = publisherURI.replaceAll("/", "_");
      //publisherURI = publisherURI.replaceAll("-", "_");
      //publisherURI = publisherURI.replaceAll("'", "_");
      publisherURI = "http://sublima.computas.com/agent/" + publisherURI;


      String insertPublisherByName =
              "PREFIX dct: <http://purl.org/dc/terms/>\n" +
                      "PREFIX foaf: <http://xmlns.com/foaf/0.1/>\n" +
                      "INSERT\n" +
                      "{\n" +
                      "<" + publisherURI + "> a foaf:Agent ;\n" +
                      "foaf:name \"" + publishername + "\"@en .\n" +
                      "}";

      logger.info("updatePublisherByURI() ---> " + publisherURI + " -- SPARUL INSERT  --> " + insertPublisherByName);
      boolean success = false;
      success = sparulDispatcher.query(insertPublisherByName);
      logger.info("updatePublisherByURI() ---> " + publisherURI + " -- INSERT NEW NAME --> " + success);

      if (success) {
        messages = "<message>\nLagring av ny utgiver vellykket\n</message>";
      } else {
        messages = "<message>\nFeil ved lagring av ny utgiver\n</message>";
      }
    }

    showPublishersIndex(res, req, messages);
  }


  /**
   * Method to update a publisher
   *
   * @param res - AppleResponse
   * @param req - AppleRequest
   */
  private void updatePublisherByURI(AppleResponse res, AppleRequest req) {
    String publisheruri = req.getCocoonRequest().getParameter("uri");
    String publisherNewLang = req.getCocoonRequest().getParameter("new_lang");
    String publisherNewName = req.getCocoonRequest().getParameter("new_name");
    String messages = "";

    // Delete statement
    StringBuffer deleteStringBuffer = new StringBuffer();
    deleteStringBuffer.append("PREFIX dct: <http://purl.org/dc/terms/>\n");
    deleteStringBuffer.append("PREFIX foaf: <http://xmlns.com/foaf/0.1/>\n");
    deleteStringBuffer.append("DELETE {\n");
    deleteStringBuffer.append("<" + publisheruri + "> a foaf:Agent ;\n");
    deleteStringBuffer.append("foaf:name ?oldname .\n");

    // Where statement for the delete
    StringBuffer whereStringBuffer = new StringBuffer();
    whereStringBuffer.append("WHERE {\n");
    whereStringBuffer.append("<" + publisheruri + "> a foaf:Agent ;\n");
    whereStringBuffer.append("foaf:name ?oldname .\n");
    whereStringBuffer.append("FILTER ( ");

    // Insert statement
    StringBuffer insertStringBuffer = new StringBuffer();
    insertStringBuffer.append("PREFIX dct: <http://purl.org/dc/terms/>\n");
    insertStringBuffer.append("PREFIX foaf: <http://xmlns.com/foaf/0.1/>\n");
    insertStringBuffer.append("INSERT {\n");

    // If user has added a new name for a new language
    if (!"".equalsIgnoreCase(publisherNewLang)
        && publisherNewLang != null
        && !"".equalsIgnoreCase(publisherNewName)
        && publisherNewName != null ) {

      insertStringBuffer.append("<" + publisheruri + "> a foaf:Agent ;\n");
      insertStringBuffer.append("foaf:name" + " \"" + publisherNewName + "\"" + "@" + publisherNewLang + " .\n");
    }

    Map<String, String> parameterMap = req.getCocoonRequest().getParameters();
    ArrayList filterList = new ArrayList();

    boolean emptyName = false;

    for (String s : parameterMap.keySet()) {
      if (s.contains("@")) {
        String[] partialString = s.split("@");

        //If no name is provided, return error message
        if ("".equalsIgnoreCase(parameterMap.get(s)) || parameterMap.get(s) == null) {
          emptyName = true;
        }

        filterList.add("lang(?oldname) = \"" + partialString[1] + "\"");

        insertStringBuffer.append("<" + publisheruri + "> a foaf:Agent ;\n");
        insertStringBuffer.append("foaf:name" + " \"" + parameterMap.get(s) + "\"" + "@" + partialString[1] + " .\n");
      }
    }

    if (emptyName) {
      messages = "<message>\nNavn kan ikke være blankt\n</message>";
    } else {

      for (int i = 0; i < filterList.size(); i++) {
        whereStringBuffer.append(filterList.get(i));
        if (filterList.size() - i != 1) {
          whereStringBuffer.append(" || ");
        }
      }

      deleteStringBuffer.append("}\n");
      whereStringBuffer.append(")\n}\n");
      insertStringBuffer.append("}\n");

      String deleteString = deleteStringBuffer.toString() + whereStringBuffer.toString();
      String insertString = insertStringBuffer.toString();

      logger.info("updatePublisherByURI() ---> " + publisheruri + " -- SPARUL DELETE  --> " + deleteString);

      boolean success = false;
      success = sparulDispatcher.query(deleteString);
      logger.info("updatePublisherByURI() ---> " + publisheruri + " -- DELETE OLD NAME --> " + success);

      logger.info("updatePublisherByURI() ---> " + publisheruri + " -- SPARUL INSERT  --> " + insertString);
      success = false;
      success = sparulDispatcher.query(insertString);
      logger.info("updatePublisherByURI() ---> " + publisheruri + " -- INSERT NEW NAME --> " + success);

      if (success) {
        messages = "<message>\nUtgiveren oppdatert\n</message>";
      } else {
        messages = "<message>\nFeil ved oppdatering\n</message>";
      }
    }

    showPublisherByURI(res, req, messages, publisheruri);
  }

  /**
   * Method to create the individual publisher page based on the publisher name.
   * The page presents the publisher and all resources from that publisher.
   *
   * @param res          - AppleResponse
   * @param req          - AppleRequest
   * @param publisherURI
   */

  private void showPublisherByURI(AppleResponse res, AppleRequest req, String messages, String publisherURI) {
    //String publisheruri = this.submode;
    if ("".equalsIgnoreCase(publisherURI) || publisherURI == null) {
      publisherURI = req.getCocoonRequest().getParameter("uri");
    }

    if ("".equals(messages) || messages == null) {
      messages = "<empty></empty>";
    }

    //Find the publisher URI based on name
    String findPublisherByURIQuery = StringUtils.join("\n", new String[]{
            "PREFIX dct: <http://purl.org/dc/terms/>",
            "DESCRIBE <" + publisherURI + "> ?resource ?subject",
            "WHERE {",
            "OPTIONAL { ?resource dct:publisher <" + publisherURI + "> .",
            "?resource dct:subject ?subject . }",
            "}"});


    logger.trace("AdminController.showPublisherByURI() --> SPARQL query sent to dispatcher: \n" + findPublisherByURIQuery);
    Object queryResult = sparqlDispatcher.query(findPublisherByURIQuery);

    Map<String, Object> bizData = new HashMap<String, Object>();
    bizData.put("messages", messages);
    bizData.put("publisherdetails", queryResult);
    res.sendPage("xml2/detaljer", bizData);
  }

  /**
   * Method to display a list of all publishers. These link to a page where each publisher can edited.
   *
   * @param res - AppleResponse
   * @param req - AppleRequest
   */
  private void showPublishersIndex(AppleResponse res, AppleRequest req, String messages) {

    if ("".equals(messages) || messages == null) {
      messages = "<empty></empty>";
    }

    String queryString = StringUtils.join("\n", new String[]{
            "PREFIX dct: <http://purl.org/dc/terms/>",
            "PREFIX foaf: <http://xmlns.com/foaf/0.1/>",
            "SELECT DISTINCT ?publisher ?name",
            "WHERE {",
            "?publisher foaf:name ?name ;",
            "           a foaf:Agent .",
            "}",
            "ORDER BY ?name"});

    logger.trace("AdminController.showPublishersIndex() --> SPARQL query sent to dispatcher: \n" + queryString);
    Object queryResult = sparqlDispatcher.query(queryString);

    Map<String, Object> bizData = new HashMap<String, Object>();
    bizData.put("messages", messages);
    bizData.put("publisherlist", queryResult);
    res.sendPage("xml2/utgivere", bizData);
  }

  /**
   * Method to displaty a list of all resources suggested by users
   *
   * @param res - AppleResponse
   * @param req - AppleRequest
   */
  private void showSuggestedResources(AppleResponse res, AppleRequest req) {
    String queryString = StringUtils.join("\n", new String[]{
            "PREFIX dct: <http://purl.org/dc/terms/>",
            "PREFIX sub: <http://xmlns.computas.com/sublima#>",
            "PREFIX wdr: <http://www.w3.org/2007/05/powder#>",
            "CONSTRUCT {",
            "    ?resource dct:title ?title ;" +
                    //"              dct:identifier ?identifier ;" +
                    "              a sub:Resource . }",
            "    WHERE {",
            "        ?resource wdr:describedBy <http://sublima.computas.com/status/til_godkjenning> ;",
            "                  dct:title ?title .",
            //"                  dct:identifier ?identifier .",
            "}"});

    logger.trace("AdminController.showSuggestedResources() --> SPARQL query sent to dispatcher: \n" + queryString);
    Object queryResult = sparqlDispatcher.query(queryString);

    Map<String, Object> bizData = new HashMap<String, Object>();
    bizData.put("suggestedresourceslist", queryResult);
    res.sendPage("xml2/foreslaatte", bizData);
  }

  /**
   * Method to display the initial page for administrating resources
   *
   * @param res - AppleResponse
   * @param req - AppleRequest
   */
  private void showResourcesIndex(AppleResponse res, AppleRequest req) {
    res.sendPage("xml2/ressurser", null);
  }

  /**
   * Method that displays a list of all resources tagged to be checked
   *
   * @param res - AppleResponse
   * @param req - AppleRequest
   */
  private void showLinkcheckResults(AppleResponse res, AppleRequest req) {

    // CHECK
    String queryStringCHECK = StringUtils.join("\n", new String[]{
            "PREFIX dct: <http://purl.org/dc/terms/>",
            "PREFIX sub: <http://xmlns.computas.com/sublima#>",
            "CONSTRUCT {",
            "    ?resource dct:title ?title ;" +
                    "              dct:identifier ?identifier ;" +
                    "              a sub:Resource . }",
            "    WHERE {",
            "        ?resource sub:status <http://sublima.computas.com/status/CHECK> ;",
            "                  dct:title ?title ;",
            "                  dct:identifier ?identifier .",
            "}"});

    logger.trace("AdminController.showLinkcheckResults() --> SPARQL query sent to dispatcher: \n" + queryStringCHECK);
    Object queryResultCHECK = sparqlDispatcher.query(queryStringCHECK);

    // INACTIVE
    String queryStringINACTIVE = StringUtils.join("\n", new String[]{
            "PREFIX dct: <http://purl.org/dc/terms/>",
            "PREFIX sub: <http://xmlns.computas.com/sublima#>",
            "CONSTRUCT {",
            "    ?resource dct:title ?title ;" +
                    "              dct:identifier ?identifier ;" +
                    "              a sub:Resource . }",
            "    WHERE {",
            "        ?resource sub:status <http://sublima.computas.com/status/INACTIVE> ;",
            "                  dct:title ?title ;",
            "                  dct:identifier ?identifier .",
            "}"});

    logger.trace("AdminController.showLinkcheckResults() --> SPARQL query sent to dispatcher: \n" + queryStringINACTIVE);
    Object queryResultINACTIVE = sparqlDispatcher.query(queryStringINACTIVE);

    // GONE
    String queryStringGONE = StringUtils.join("\n", new String[]{
            "PREFIX dct: <http://purl.org/dc/terms/>",
            "PREFIX sub: <http://xmlns.computas.com/sublima#>",
            "CONSTRUCT {",
            "    ?resource dct:title ?title ;" +
                    "              dct:identifier ?identifier ;" +
                    "              a sub:Resource . }",
            "    WHERE {",
            "        ?resource sub:status <http://sublima.computas.com/status/GONE> ;",
            "                  dct:title ?title ;",
            "                  dct:identifier ?identifier .",
            "}"});

    logger.trace("AdminController.showLinkcheckResults() --> SPARQL query sent to dispatcher: \n" + queryStringGONE);
    Object queryResultGONE = sparqlDispatcher.query(queryStringGONE);

    Map<String, Object> bizData = new HashMap<String, Object>();
    bizData.put("lenkesjekklist_check", queryResultCHECK);
    bizData.put("lenkesjekklist_inactive", queryResultINACTIVE);
    bizData.put("lenkesjekklist_gone", queryResultGONE);
    res.sendPage("xml2/lenkesjekk", bizData);

  }

  public void setSparqlDispatcher(SparqlDispatcher sparqlDispatcher) {
    this.sparqlDispatcher = sparqlDispatcher;
  }

  public void setSparulDispatcher(SparulDispatcher sparulDispatcher) {
    this.sparulDispatcher = sparulDispatcher;
  }

  //todo Move to a Service-class
  private Map<String, String[]> createParametersMap(Request request) {
    Map<String, String[]> result = new HashMap<String, String[]>();
    Enumeration parameterNames = request.getParameterNames();
    while (parameterNames.hasMoreElements()) {
      String paramName = (String) parameterNames.nextElement();
      result.put(paramName, request.getParameterValues(paramName));
    }
    return result;
  }
}

