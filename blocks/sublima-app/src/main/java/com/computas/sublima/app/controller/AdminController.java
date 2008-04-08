package com.computas.sublima.app.controller;

import com.computas.sublima.app.service.Form2SparqlService;
import com.computas.sublima.query.SparqlDispatcher;
import com.computas.sublima.query.SparulDispatcher;
import com.computas.sublima.query.RDFObject;
import com.hp.hpl.jena.sparql.util.StringUtils;
import org.apache.cocoon.components.flow.apples.AppleRequest;
import org.apache.cocoon.components.flow.apples.AppleResponse;
import org.apache.cocoon.components.flow.apples.StatelessAppleController;
import org.apache.cocoon.environment.Request;
import org.apache.log4j.Logger;

import java.util.Enumeration;
import java.util.HashMap;
import java.util.Map;
import java.util.TreeMap;
import java.io.IOException;

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
    }
    // Publishers. Send the user to a page that displays a list of all publishers.
    else if ("utgivere".equalsIgnoreCase(mode)) {
      if ("".equalsIgnoreCase(submode) || submode == null) {
        showPublishersIndex(res, req);
        return;
      } else if ("updatepublisher".equalsIgnoreCase(submode)) {
        updatePublisherByURI(res, req);
        return;
      } else {
        showPublisherByURI(res, req, null);
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
   * Method to update a publisher
   *
   * @param res - AppleResponse
   * @param req - AppleRequest
   */
  private void updatePublisherByURI(AppleResponse res, AppleRequest req) {
    String publisheruri = req.getCocoonRequest().getParameter("the-resource");
    String publishername = ""; //= req.getCocoonRequest().getParameter("publisher").trim();
    String messages;

    /*
    Map<String, String[]> parameterMap = new TreeMap<String, String[]>(createParametersMap(req.getCocoonRequest()));

    // Insert the needed PREFIX
    parameterMap.put("prefix", new String[]{"foaf: <http://xmlns.com/foaf/0.1/>"});

    Form2SparqlService form2SparqlService = new Form2SparqlService(parameterMap.get("prefix"));
    parameterMap.remove("prefix"); // The prefixes are magic variables
    try {
      String sparqlQuery = form2SparqlService.convertForm2Sparul(parameterMap);
    } catch (IOException e) {
      e.printStackTrace();
    }
    */

    String deleteString = "PREFIX dct: <http://purl.org/dc/terms/>\n" +
            "PREFIX foaf: <http://xmlns.com/foaf/0.1/>\n" +
            "DELETE\n" +
            "{ " +
            "<" + publisheruri + "> foaf:name ?oldname@no " +
            "}\n" +
            "WHERE {\n" +
            "<" + publisheruri + "> foaf:name ?oldname@no " +
            "}";

    logger.info("updatePublisherByURI() ---> " + publisheruri + " -- SPARUL DELETE  --> " + deleteString);

    boolean success = false;
    success = sparulDispatcher.query(deleteString);
    logger.info("updatePublisherByURI() ---> " + publisheruri + " -- DELETE OLD NAME --> " + success);

    String updateString = "PREFIX dct: <http://purl.org/dc/terms/>\n" +
            "PREFIX foaf: <http://xmlns.com/foaf/0.1/>\n" +
            "INSERT\n" +
            "{ " +
            "<" + publisheruri + "> foaf:name " + publishername + "@no\n" +
            "}";

    logger.info("updatePublisherByURI() ---> " + publisheruri + ":" + publishername + " -- SPARUL UPDATE  --> " + updateString);

    success = false;

    success = sparulDispatcher.query(updateString);
    logger.info("updatePublisherByURI() ---> " + publisheruri + ":" + publishername + " -- INSERT NEW NAME --> " + success);

    if (success) {
      messages = "<c:message>Utgiveren oppdatert</c:message>";
    } else {
      messages = "<c:message>Feil ved oppdatering</c:message>";
    }

    showPublisherByURI(res, req, messages);
  }

  /**
   * Method to create the individual publisher page based on the publisher name.
   * The page presents the publisher and all resources from that publisher.
   *
   * @param res - AppleResponse
   * @param req - AppleRequest
   */

  private void showPublisherByURI(AppleResponse res, AppleRequest req, String messages) {
    //String publisheruri = this.submode;
    String publisheruri = req.getCocoonRequest().getParameter("uri");
    if (messages == null) {
      messages = "<empty></empty>";
    }

    //Find the publisher URI based on name
    String findPublisherByURIQuery = StringUtils.join("\n", new String[]{
            "PREFIX dct: <http://purl.org/dc/terms/>",
            "DESCRIBE ?resource <" + publisheruri + "> ?subject",
            "WHERE {",
            "?resource dct:publisher <" + publisheruri + "> .",
            "?resource dct:subject ?subject .",
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
  private void showPublishersIndex(AppleResponse res, AppleRequest req) {
    String queryString = StringUtils.join("\n", new String[]{
            "PREFIX dct: <http://purl.org/dc/terms/>",
            "PREFIX foaf: <http://xmlns.com/foaf/0.1/>",
            "SELECT DISTINCT ?publisher ?name",
            "WHERE {",
            "?resource dct:publisher ?publisher .",
            "?publisher foaf:name ?name .",
            "}",
            "ORDER BY ?name"});

    logger.trace("AdminController.showPublishersIndex() --> SPARQL query sent to dispatcher: \n" + queryString);
    Object queryResult = sparqlDispatcher.query(queryString);

    Map<String, Object> bizData = new HashMap<String, Object>();
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

