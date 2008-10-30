package com.computas.sublima.query.controller;

import org.apache.cocoon.components.flow.apples.StatelessAppleController;
import org.apache.cocoon.components.flow.apples.AppleResponse;
import org.apache.cocoon.components.flow.apples.AppleRequest;
import org.apache.cocoon.ProcessingException;
import org.apache.xerces.parsers.DOMParser;
import org.w3c.dom.Document;
import com.computas.sublima.query.service.SettingsService;

import java.util.HashMap;
import java.util.Map;

/**
 * This is a client for SRU that uses the Sublima SRU Server responses to
 * reconstruct a RDF/XML response.
 * User: kkj
 * Date: Oct 29, 2008
 * Time: 10:08:51 AM
 */
public class SRUClient implements StatelessAppleController {

  public void process(AppleRequest req, AppleResponse res) throws Exception {
      String endpoint = SettingsService.getProperty("sublima.sruserver.endpoint");
      if (endpoint == null) {
          throw new ProcessingException("The sublima.sruserver.endpoint has not been configured, exiting.");
      }
      String query = endpoint;
      if (req.getCocoonRequest().getQueryString() != null) {
          query = endpoint + "?" + req.getCocoonRequest().getQueryString();
      }


      String operation = req.getCocoonRequest().getParameter("operation");
      if ("explain".equalsIgnoreCase(operation) || req.getCocoonRequest().getParameters().size() == 0) {
          // We only need to retrieve the explain record, which is best done by a redirect to the server
          res.redirectTo(query);
      }

      DOMParser parser = new DOMParser();

      parser.parse(query);

      Document document = parser.getDocument();
      if (document.getElementsByTagName("diagnostics") != null) {
          // Then we have an error, redirect to the server's description of the problem
          res.redirectTo(query);
      }

      Map<String, Object> bizData = new HashMap<String, Object>();
      bizData.put("result", document);
      System.gc();
      res.sendPage("sru/sru-client", bizData);

  }
}
