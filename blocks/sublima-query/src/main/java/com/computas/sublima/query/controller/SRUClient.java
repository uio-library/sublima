package com.computas.sublima.query.controller;

/* import org.apache.cocoon.components.flow.apples.StatelessAppleController;
import org.apache.cocoon.components.flow.apples.AppleResponse;
import org.apache.cocoon.components.flow.apples.AppleRequest;
import org.apache.cocoon.ProcessingException;                  */
import org.apache.log4j.Logger;
import org.apache.xerces.parsers.DOMParser;
import org.apache.cocoon.ProcessingException;
import org.apache.xml.serialize.XMLSerializer;
import org.apache.xml.serialize.OutputFormat;
import org.w3c.dom.Document;
import com.computas.sublima.query.service.SettingsService;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.ServletException;
import java.util.HashMap;
import java.util.Map;
import java.io.IOException;
import java.io.PrintWriter;
import java.io.StringWriter;

/**
 * This is a client for SRU that uses the Sublima SRU Server responses to
 * reconstruct a RDF/XML response.
 * User: kkj
 * Date: Oct 29, 2008
 * Time: 10:08:51 AM
 */
public class SRUClient extends HttpServlet {

//  private SparqlDispatcher sparqlDispatcher;
//  static Logger logger = Logger.getLogger(SRUClient.class);

  public void doGet(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
      String endpoint = "http://rabbit.computas.int:8180/sublima-webapp-1.0-SNAPSHOT/sruserver"; // SettingsService.getProperty("sublima.sruserver.endpoint");
     /* if (endpoint == null) {
          throw new ProcessingException("The sublima.sruserver.endpoint has not been configured, exiting.");
      }  */
      String query = endpoint;
      if (req.getQueryString() != null) {
          query = endpoint + "?" + req.getQueryString();
      }


      String operation = req.getParameter("operation");
      if ("explain".equalsIgnoreCase(operation) || req.getQueryString() == null) {
          // We only need to retrieve the explain record, which is best done by a redirect to the server
          res.sendRedirect(query);
          res.flushBuffer();
          return;
      }

      DOMParser parser = new DOMParser();

     try {
          parser.parse(query);
     } catch (Exception e) {
          res.sendError(502, "SRUClient received an invalid response from the server.");
          e.printStackTrace();
         return;
      }
                                   
      Document document = parser.getDocument();
/*      if (document.getElementsByTagName("diagnostics") != null) {
          // Then we have an error, redirect to the server's description of the problem
          res.sendRedirect(query);
          return;
      }
  */
      

      OutputFormat format    = new OutputFormat(document);
      StringWriter stringOut = new StringWriter();
      XMLSerializer serial   = new XMLSerializer(stringOut, format);
      serial.serialize(document);
      res.setContentType("text/xml");
      PrintWriter out = res.getWriter();
      out.println(stringOut.toString());

      out.close();
  }
}
