package com.computas.sublima.app.controller;

import com.computas.sublima.query.SparqlDispatcher;
import com.computas.sublima.query.SparulDispatcher;
import com.computas.sublima.query.service.SearchService;
import com.hp.hpl.jena.sparql.util.StringUtils;
import org.apache.cocoon.components.flow.apples.AppleRequest;
import org.apache.cocoon.components.flow.apples.AppleResponse;
import org.apache.cocoon.components.flow.apples.StatelessAppleController;
import org.apache.log4j.Logger;

import java.util.Map;
import java.util.HashMap;

/**
 * @author: mha
 * Date: 31.mar.2008
 */
public class AdminController implements StatelessAppleController {

    private SparqlDispatcher sparqlDispatcher;
    private SparulDispatcher sparulDispatcher;
    private String mode;

    private static Logger logger = Logger.getLogger(AdminController.class);

    @SuppressWarnings("unchecked")
    public void process(AppleRequest req, AppleResponse res) throws Exception {

        this.mode = req.getSitemapParameter("mode");

        // Lenkesjekk. Sender brukeren til en side som lister alle ressurser (tittel med URI som link) som har status CHECK.
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
    private void showLinkcheckResults(AppleResponse res, AppleRequest req) {
        SearchService searchService;

        String queryString = StringUtils.join("\n", new String[]{
                "PREFIX dct: <http://purl.org/dc/terms/>",
                "PREFIX sub: <http://xmlns.computas.com/sublima#>",
                "SELECT ?resource ?title",
                "WHERE {",
                "    ?resource sub:status <http://sublima.computas.com/status/CHECK> ;",
                "              dct:title ?title .",
                "}"});

        logger.trace("AdminController.showLinkcheckResults() --> SPARQL query sent to dispatcher: " + queryString);
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

