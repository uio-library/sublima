package com.computas.sublima.app.controller.admin;

import com.computas.sublima.app.service.AdminService;
import com.computas.sublima.app.controller.admin.AdminController;
import com.computas.sublima.query.SparqlDispatcher;
import com.computas.sublima.query.SparulDispatcher;
import com.hp.hpl.jena.sparql.util.StringUtils;
import org.apache.cocoon.components.flow.apples.AppleRequest;
import org.apache.cocoon.components.flow.apples.AppleResponse;
import org.apache.cocoon.components.flow.apples.StatelessAppleController;
import org.apache.log4j.Logger;

import java.util.*;

/**
 * @author: mha
 * Date: 31.mar.2008
 */
public class LinkcheckController implements StatelessAppleController {

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
          "PREFIX lingvoj: <http://www.lingvoj.org/ontology#>"};

  String completePrefixes = StringUtils.join("\n", completePrefixArray);
  String[] prefixArray = {
          "dct: <http://purl.org/dc/terms/>",
          "foaf: <http://xmlns.com/foaf/0.1/>",
          "sub: <http://xmlns.computas.com/sublima#>",
          "rdfs: <http://www.w3.org/2000/01/rdf-schema#>",
          "wdr: <http://www.w3.org/2007/05/powder#>",
          "skos: <http://www.w3.org/2004/02/skos/core#>",
          "PREFIX lingvoj: <http://www.lingvoj.org/ontology#>"};
  String prefixes = StringUtils.join("\n", prefixArray);

  private static Logger logger = Logger.getLogger(AdminController.class);

  @SuppressWarnings("unchecked")
  public void process(AppleRequest req, AppleResponse res) throws Exception {

    this.mode = req.getSitemapParameter("mode");
    this.submode = req.getSitemapParameter("submode");

    if ("lenkesjekk".equalsIgnoreCase(mode)) {
      showLinkcheckResults(res, req);

      return;
    } else {
      res.sendStatus(404);
      return;
    }
  }

 
  /**
   * Method that displays a list of all resources tagged to be checked
   *
   * @param res - AppleResponse
   * @param req - AppleRequest
   */
  private void showLinkcheckResults
          (AppleResponse
                  res, AppleRequest
                  req) {

    // CHECK
    String queryStringCHECK = StringUtils.join("\n", new String[]{
            completePrefixes,
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
            completePrefixes,
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
            completePrefixes,
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

