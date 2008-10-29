package com.computas.sublima.query.controller;

import org.apache.cocoon.components.flow.apples.StatelessAppleController;
import org.apache.cocoon.components.flow.apples.AppleResponse;
import org.apache.cocoon.components.flow.apples.AppleRequest;
import org.apache.log4j.Logger;
import com.computas.sublima.query.service.SettingsService;

/**
 * This is a client for SRU that uses the Sublima SRU Server responses to
 * reconstruct a RDF/XML response.
 * User: kkj
 * Date: Oct 29, 2008
 * Time: 10:08:51 AM
 */
public class SRUClient implements StatelessAppleController

    {

//  private SparqlDispatcher sparqlDispatcher;
  static Logger logger = Logger.getLogger(SRUServer.class);

  public void process(AppleRequest req, AppleResponse res) throws Exception {
    String endpoint = SettingsService.getProperty("sublima.sruserver.endpoint");
    if (endpoint == null) {
        throw new Exception("The sublima.sruserver.endpoint has not been configured, exiting.")
    }
    String operation = req.getCocoonRequest().getParameter("operation");
    if ("explain".equalsIgnoreCase(operation) || req.getCocoonRequest().getParameters().size() == 0) {
        // We only need to retrieve the explain record, which is best done by a redirect to the server
        res.redirectTo(endpoint);
    }
  }
}
