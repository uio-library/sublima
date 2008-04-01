package com.computas.sublima.app.controller;

import com.computas.sublima.query.SparqlDispatcher;
import com.computas.sublima.query.SparulDispatcher;
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

    // Lenkesjekk. Sender brukeren til en side som lister alle ressurser (tittel med URI som link) som har status CHECK.
    if ("lenkesjekk".equalsIgnoreCase(mode)) {
      showLinkcheckResults(res, req);
      return;
    }
    if ("ressurser".equalsIgnoreCase(mode)) {
      if ("".equalsIgnoreCase(submode)) {
        showResourcesIndex(res, req);
      } else if ("foreslaatte".equalsIgnoreCase(submode)) {
        showSuggestedResources(res, req);
      }

      return;
    } else {
      res.sendStatus(404);
      return;
    }
  }

  /**
   * Method to displaty a list of all resources suggested by users
   *
   * @param res
   * @param req
   */
  private void showSuggestedResources(AppleResponse res, AppleRequest req) {
    String queryString = StringUtils.join("\n", new String[]{
            "PREFIX dct: <http://purl.org/dc/terms/>",
            "PREFIX sub: <http://xmlns.computas.com/sublima#>",
            "PREFIX wdr: <http://www.w3.org/2007/05/powder#>",
            "CONSTRUCT {",
            "    ?resource dct:title ?title ;" +
                    "              dct:identifier ?identifier ;" +
                    "              a sub:Resource . }",
            "    WHERE {",
            "        ?resource wdr:describedBy <http://sublima.computas.com/status/til_godkjenning> ;",
            "                  dct:title ?title ;",
            "                  dct:identifier ?identifier .",
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
   * @param res
   * @param req
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
    String queryString = StringUtils.join("\n", new String[]{
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

    logger.trace("AdminController.showLinkcheckResults() --> SPARQL query sent to dispatcher: \n" + queryString);
    Object queryResult = sparqlDispatcher.query(queryString);

    Map<String, Object> bizData = new HashMap<String, Object>();
    bizData.put("lenkesjekklist", queryResult);
    res.sendPage("xml2/lenkesjekk", bizData);

  }

  public void setSparqlDispatcher(SparqlDispatcher sparqlDispatcher) {
    this.sparqlDispatcher = sparqlDispatcher;
  }

  public void setSparulDispatcher(SparulDispatcher sparulDispatcher) {
    this.sparulDispatcher = sparulDispatcher;
  }
}

