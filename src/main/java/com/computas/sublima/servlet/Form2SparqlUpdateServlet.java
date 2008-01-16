package com.computas.sublima.servlet;

import com.computas.sublima.service.Form2SparqlService;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.util.Map;
import java.util.TreeMap;

/**
 * @author: mha
 * @version: 1.0
 * @version: Date: 08.jan.2008
 */
public class Form2SparqlUpdateServlet extends HttpServlet {

  public void doGet(HttpServletRequest request,
                    HttpServletResponse response)
          throws ServletException, IOException {
    doPost(request, response);
  }

  public void doPost(HttpServletRequest request,
                     HttpServletResponse response)
          throws ServletException, IOException {

    //Get all parameteres from the HTML form as Map
    Map<String, String[]> parameterMap = new TreeMap<String, String[]>(request.getParameterMap());

    // Check for magic prefixes
    if (parameterMap.get("prefix") != null) {
      //Calls the Form2SPARQLUpdate service with the parameterMap which returns a SPARQL/Update as String
      Form2SparqlService form2SparqlService = new Form2SparqlService(parameterMap.get("prefix"));
      parameterMap.remove("prefix"); // The prefixes are magic variables
      String sparqlUpdate = form2SparqlService.convertForm2Sparul(parameterMap);

      PrintWriter out = response.getWriter();
      try {
        //TODO We've gotta do a GET to our fancy fine SparqlUpdateServlet
        URL u = new URL("http://localhost:8180/sublima-1.0-SNAPSHOT/update?query="
                + URLEncoder.encode(sparqlUpdate, "UTF-8")); // TODO: Should have a config somewhere
        HttpURLConnection huc = (HttpURLConnection) u.openConnection();

        int code = huc.getResponseCode();
        if (code >= huc.HTTP_INTERNAL_ERROR) { // The upstream server borked, blame it
          response.sendError(huc.HTTP_BAD_GATEWAY, "The SPARQL/Update Endpoint encountered an internal error.");
        }
        if (code == huc.HTTP_BAD_REQUEST) { // There was a bad request sent upwards, we're probably to blame
          response.sendError(huc.HTTP_INTERNAL_ERROR, "The Servlet produced an erroneous SPARQL/Update query.");
        }
        // TODO: A test here to attempt to detect parameters that clearly will lead to malformed queries.
        if (code == huc.HTTP_UNAUTHORIZED) {
          response.sendError(huc.HTTP_UNAUTHORIZED, "You were not authorized to access the SPARQL/Update Endpoint.");
        }
        if (code > huc.HTTP_UNAUTHORIZED && code < huc.HTTP_INTERNAL_ERROR) { // The Endpoint returned a client error, and we're the client
          response.sendError(huc.HTTP_INTERNAL_ERROR, "The Servlet was misconfigured when dealing with the SPARQL/Update endpoint");
        }

        if (code >= huc.HTTP_OK && code < huc.HTTP_MULT_CHOICE) {

          //TODO Great success! Let the user now!
          out.println("Insert of new resource successfull!");
          out.println("<a href=\"index.html\">Go back to search</a>");
          out.close();
        }

        huc.disconnect();
      }
      catch (IOException e) {
        out.println(e.getMessage());
      }
    } else {
      response.sendError(400, "prefix field missing.");
    }
  }
}
