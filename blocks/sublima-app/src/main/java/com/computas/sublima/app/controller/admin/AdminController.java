package com.computas.sublima.app.controller.admin;

import com.computas.sublima.app.adhoc.ConvertSublimaResources;
import com.computas.sublima.app.adhoc.ImportData;
import com.computas.sublima.app.service.AdminService;
import com.computas.sublima.query.SparqlDispatcher;
import com.computas.sublima.query.SparulDispatcher;
import com.computas.sublima.query.service.DatabaseService;
import com.hp.hpl.jena.sparql.util.StringUtils;
import org.apache.cocoon.components.flow.apples.AppleRequest;
import org.apache.cocoon.components.flow.apples.AppleResponse;
import org.apache.cocoon.components.flow.apples.StatelessAppleController;
import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.FileUploadException;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import org.apache.log4j.Logger;

import javax.servlet.http.HttpServletRequest;
import java.io.File;
import java.io.IOException;
import java.net.URLEncoder;
import java.net.URL;
import java.net.MalformedURLException;
import java.util.Iterator;
import java.util.List;

/**
 * @author: mha
 * Date: 31.mar.2008
 */
public class AdminController implements StatelessAppleController {

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
  ConvertSublimaResources convert = new ConvertSublimaResources();

  @SuppressWarnings("unchecked")
  public void process(AppleRequest req, AppleResponse res) throws Exception {

    this.mode = req.getSitemapParameter("mode");
    this.submode = req.getSitemapParameter("submode");

    if ("".equalsIgnoreCase(mode)) {
      res.sendPage("xml2/admin", null);
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
        exportOntology(res, req);
      }
    } else {
      res.sendStatus(404);
      return;
    }
  }

  private void exportOntology(AppleResponse res, AppleRequest req) {
    if (req.getCocoonRequest().getMethod().equalsIgnoreCase("GET")) {
      res.sendPage("xml2/upload", null);
    } else if (req.getCocoonRequest().getMethod().equalsIgnoreCase("POST")) {
      DatabaseService databaseService = new DatabaseService();


      String filename = req.getCocoonRequest().getParameter("location");
      String format = req.getCocoonRequest().getParameter("type");

      String replaceResourceWith = null;
      if (req.getCocoonRequest().getParameterValues("replacement") != null) {
        replaceResourceWith = "uri";
      }
      //databaseService.writeModelToFile(filename, format);
      try {
        convert.convert(filename, format, filename, format, replaceResourceWith);
      } catch (IOException e) {
        e.printStackTrace();  //To change body of catch statement use File | Settings | File Templates.
      }


      res.sendPage("xml2/upload", null);
    }
  }

  private void uploadForm(AppleResponse res, AppleRequest req) {
    if (req.getCocoonRequest().getMethod().equalsIgnoreCase("GET")) {
      res.sendPage("xml2/upload", null);
    } else if (req.getCocoonRequest().getMethod().equalsIgnoreCase("POST")) {
      /*
      boolean isMultipart = ServletFileUpload.isMultipartContent(req.getCocoonRequest());

      // Create a factory for disk-based file items
      DiskFileItemFactory factory = new DiskFileItemFactory();

      // Set factory constraints
      //factory.setSizeThreshold(500000000);
      //factory.setRepository(new File("/tmp/sublima/upload"));

      // Create a new file upload handler
      ServletFileUpload upload = new ServletFileUpload(factory);

      // Set overall request size constraint. Defaults to -1 --> no limit
      //upload.setSizeMax(yourMaxRequestSize);

      // Parse the request
      List items = null;
      try {
        items = upload.parseRequest(req.getCocoonRequest());
      } catch (FileUploadException e) {
        logger.trace("AdminController.uploadForm --> Error during file upload.");
      }

      // Process the uploaded items
      Iterator iter = items.iterator();
      File savedFile = null;
      while (iter.hasNext()) {
        FileItem item = (FileItem) iter.next();

        if (item.isFormField()) {
          String name = item.getFieldName();
          String value = item.getString();
        } else {
          String fieldName = item.getFieldName();
          String fileName = item.getName();
          String contentType = item.getContentType();
          boolean isInMemory = item.isInMemory();
          long sizeInBytes = item.getSize();

          // Workaround to fix bug in item.getName() that returns full path on client machine.
          File fullfile = new File(fileName);

          savedFile = new File(factory.getRepository(), fullfile.getName());
          try {
            item.write(savedFile);
          } catch (Exception e) {
            logger.trace("AdminController.uploadForm --> Error during writing file to upload directory.");
          }
        }
      }

      String type = req.getCocoonRequest().getParameter("type");

      try {
        convert.convert(savedFile.getName(), type, savedFile.getName(), type, "url");
      } catch (IOException e) {
        logger.trace("AdminController.uploadForm --> Error during convertion of resource URIs to URLs.");
      }
      */
      ImportData importData = new ImportData();
      File file = new File(req.getCocoonRequest().getParameter("location"));

      try {
        importData.load( file.toURL().toString()/*req.getCocoonRequest().getParameter("location")*/, req.getCocoonRequest().getParameter("type"));
      } catch (MalformedURLException e) {
        e.printStackTrace();  //To change body of catch statement use File | Settings | File Templates.
      }
      res.sendPage("xml2/upload", null);
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

