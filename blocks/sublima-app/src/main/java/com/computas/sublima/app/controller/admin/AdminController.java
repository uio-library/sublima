package com.computas.sublima.app.controller.admin;

import com.computas.sublima.app.adhoc.ConvertSublimaResources;
import com.computas.sublima.app.adhoc.ImportData;
import com.computas.sublima.app.service.AdminService;
import com.computas.sublima.query.SparqlDispatcher;
import com.computas.sublima.query.SparulDispatcher;
import com.computas.sublima.query.service.DatabaseService;
import com.computas.sublima.query.service.SettingsService;
import com.hp.hpl.jena.rdf.model.Model;
import com.hp.hpl.jena.rdf.model.ModelFactory;
import com.hp.hpl.jena.sparql.util.StringUtils;
import org.apache.cocoon.components.flow.apples.AppleRequest;
import org.apache.cocoon.components.flow.apples.AppleResponse;
import org.apache.cocoon.components.flow.apples.StatelessAppleController;
import org.apache.log4j.Logger;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.IOException;
import java.net.MalformedURLException;
import java.net.URLEncoder;
import java.util.HashMap;
import java.util.Map;

/**
 * @author: mha
 * Date: 31.mar.2008
 */
public class AdminController implements StatelessAppleController {

  private SparqlDispatcher sparqlDispatcher;
  private SparulDispatcher sparulDispatcher;
  AdminService adminService = new AdminService();
  String[] completePrefixArray = {
          "PREFIX dct: <http://purl.org/dc/terms/>",
          "PREFIX foaf: <http://xmlns.com/foaf/0.1/>",
          "PREFIX sub: <http://xmlns.computas.com/sublima#>",
          "PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>",
          "PREFIX wdr: <http://www.w3.org/2007/05/powder#>",
          "PREFIX skos: <http://www.w3.org/2004/02/skos/core#>",
          "PREFIX lingvoj: <http://www.lingvoj.org/ontology#>"};

  String completePrefixes = StringUtils.join("\n", completePrefixArray);
 
  private static Logger logger = Logger.getLogger(AdminController.class);
  ConvertSublimaResources convert = new ConvertSublimaResources();

  @SuppressWarnings("unchecked")
  public void process(AppleRequest req, AppleResponse res) throws Exception {

    String mode = req.getSitemapParameter("mode");
    String submode = req.getSitemapParameter("submode");

    if ("".equalsIgnoreCase(mode)) {
      Map<String, Object> bizData = new HashMap<String, Object>();
      bizData.put("facets", adminService.getMostOfTheRequestXMLWithPrefix(req) + "</c:request>");
      res.sendPage("xml2/admin", bizData);
    } else if ("testsparql".equalsIgnoreCase(mode)) {
      if ("".equalsIgnoreCase(submode)) {
        res.sendPage("xhtml/testsparql", null);
      } else {
        String query = req.getCocoonRequest().getParameter("query");
        res.redirectTo(req.getCocoonRequest().getContextPath() + "/sparql?query=" + URLEncoder.encode(query, "UTF-8"));
      }
    } else if ("database".equalsIgnoreCase(mode)) {
      if ("".equalsIgnoreCase(submode)) {
        uploadForm(res, req);
      } else if ("upload".equalsIgnoreCase(submode)) {
        uploadForm(res, req);
      } else if ("export".equalsIgnoreCase(submode)) {
        exportOntologyToXML(res, req);
      }
    } else {
      res.sendStatus(404);
    }
  }

  private void exportOntologyToXML(AppleResponse res, AppleRequest req) throws Exception {
    Map<String, Object> bizData = new HashMap<String, Object>();

    String type = req.getCocoonRequest().getParameter("type");

    Model model = ModelFactory.createDefaultModel();
    model.add(SettingsService.getModel());
    model.setNsPrefixes(SettingsService.getModel().getNsPrefixMap());

    ByteArrayOutputStream out = new ByteArrayOutputStream();
    model.write(out, type);
    bizData.put("ontology", out.toString());

    model.close();

    res.sendPage("nostyle/export", bizData);
  }

  private void uploadForm(AppleResponse res, AppleRequest req) {
    Map<String, Object> bizData = new HashMap<String, Object>();
      bizData.put("facets", adminService.getMostOfTheRequestXMLWithPrefix(req) + "</c:request>");

    if (req.getCocoonRequest().getMethod().equalsIgnoreCase("GET")) {
      res.sendPage("xml2/upload", bizData);
    } else if (req.getCocoonRequest().getMethod().equalsIgnoreCase("POST")) {

      if (req.getCocoonRequest().getParameter("location") != null) {
        String type = req.getCocoonRequest().getParameter("type");
        File file = new File(req.getCocoonRequest().getParameter("location"));

        try {
          ConvertSublimaResources.applyRules(file.toURL().toString(), type, file.getCanonicalPath(), type);
          ImportData.load(file.toURL().toString(), type);
        } catch (Exception e) {
          logger.trace("AdminController.uploadForm --> Error during loading of resource");
          e.printStackTrace();
        }
      }

      res.sendPage("xml2/upload", bizData);
    }
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

