package com.computas.sublima.app.controller.admin;

import com.computas.sublima.query.SparqlDispatcher;
import com.computas.sublima.query.SparulDispatcher;
import com.computas.sublima.query.service.AdminService;
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
public class TopicController implements StatelessAppleController {

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

    if ("emner".equalsIgnoreCase(mode)) {
      if ("".equalsIgnoreCase(submode) || submode == null) {
        res.sendPage("xml2/emner", null);
        return;
      } else if ("nytt".equalsIgnoreCase(submode)) {
        editTopic(res, req, "nytt", null);
        return;
      } else if ("alle".equalsIgnoreCase(submode)) {
        showTopics(res, req);
        return;
      } else if ("emne".equalsIgnoreCase(submode)) {
        editTopic(res, req, "edit", null);
        return;
      }

    } else {
      res.sendStatus(404);
      return;
    }
  }

  private void showTopics(AppleResponse res, AppleRequest req) {
    Map<String, Object> bizData = new HashMap<String, Object>();
    bizData.put("all_topics", adminService.getAllTopics());
    res.sendPage("xml2/emner_alle", bizData);
  }

  private void editTopic(AppleResponse res, AppleRequest req, String type, String messages) {
    Map<String, Object> bizData = new HashMap<String, Object>();
    if (req.getCocoonRequest().getMethod().equalsIgnoreCase("GET")) {
      bizData.put("tempvalues", "<empty></empty>");

      if ("nytt".equalsIgnoreCase(type)) {
        bizData.put("topicdetails", "<empty></empty>");
        bizData.put("alltopics", adminService.getAllTopics());
        bizData.put("mode", "topicedit");
      } else {
        bizData.put("topicdetails", adminService.getTopicByURI(req.getCocoonRequest().getParameter("uri")));
        bizData.put("alltopics", adminService.getAllTopics());
        bizData.put("mode", "topicedit");
      }

      bizData.put("messages", "<empty></empty>");
      res.sendPage("xml2/emne", bizData);

      // When POST try to save the resource. Return error messages upon failure, and success message upon great success
    } else if (req.getCocoonRequest().getMethod().equalsIgnoreCase("POST")) {

    }
  }

  /**
   * Method to validate the request upon insert of new resource.
   * Checks all parameters and gives error message if one or more required values are null
   *
   * @param req
   * @return
   */
  private String validateRequest(AppleRequest req) {
    StringBuffer validationMessages = new StringBuffer();

    if ("".equalsIgnoreCase(req.getCocoonRequest().getParameter("dct:title")) || req.getCocoonRequest().getParameter("dct:title") == null) {
      validationMessages.append("<c:message>Tittel kan ikke være blank</c:message>\n");
    }

    if ("".equalsIgnoreCase(req.getCocoonRequest().getParameter("sub:url")) || req.getCocoonRequest().getParameter("sub:url") == null) {
      validationMessages.append("<c:message>URL kan ikke være blank</c:message>\n");
    }

    if ("".equalsIgnoreCase(req.getCocoonRequest().getParameter("dct:description")) || req.getCocoonRequest().getParameter("dct:description") == null) {
      validationMessages.append("<c:message>Beskrivelsen kan ikke være blank</c:message>\n");
    }

    if (("".equalsIgnoreCase(req.getCocoonRequest().getParameter("dct:publisher")) || req.getCocoonRequest().getParameter("dct:publisher") == null) &&
            ("".equalsIgnoreCase(req.getCocoonRequest().getParameter("dct:publisher/foaf:Agent/foaf:name")) || req.getCocoonRequest().getParameter("dct:publisher/foaf:Agent/foaf:name") == null)) {
      validationMessages.append("<c:message>En utgiver må velges, eller et nytt utgivernavn angis</c:message>\n");
    }

    if (req.getCocoonRequest().getParameterValues("dct:language") == null) {
      validationMessages.append("<c:message>Minst ett språk må være valgt</c:message>\n");
    }

    if (req.getCocoonRequest().getParameterValues("dct:MediaType") == null) {
      validationMessages.append("<c:message>Minst en mediatype må være valgt</c:message>\n");
    }

    if (req.getCocoonRequest().getParameterValues("dct:audience") == null) {
      validationMessages.append("<c:message>Minst en målgruppe må være valgt</c:message>\n");
    }

    if (req.getCocoonRequest().getParameterValues("dct:subject") == null) {
      validationMessages.append("<c:message>Minst ett emne må være valgt</c:message>\n");
    }

    if (req.getCocoonRequest().getParameter("wdr:DR") == null) {
      validationMessages.append("<c:message>En status må velges</c:message>\n");
    }

    return validationMessages.toString();
  }

  private StringBuffer getTopicTempValues(AppleRequest req) {
    //Keep all selected values in case of validation error
    String temp_title = req.getCocoonRequest().getParameter("dct:title");
    String temp_uri = req.getCocoonRequest().getParameter("sub:url");
    String temp_description = req.getCocoonRequest().getParameter("dct:description");
    String temp_publisher = req.getCocoonRequest().getParameter("dct:publisher");
    String temp_added_publisher = req.getCocoonRequest().getParameter("dct:publisher/foaf:Agent/foaf:name");
    String[] temp_languages = req.getCocoonRequest().getParameterValues("dct:language");
    String[] temp_mediatypes = req.getCocoonRequest().getParameterValues("dct:MediaType");
    String[] temp_audiences = req.getCocoonRequest().getParameterValues("dct:audience");
    String[] temp_subjects = req.getCocoonRequest().getParameterValues("dct:subject");
    String temp_comment = req.getCocoonRequest().getParameter("rdfs:comment");
    String temp_status = req.getCocoonRequest().getParameter("wdr:DR");

    //Create an XML structure for the selected values, to use in the JX template
    StringBuffer xmlStructureBuffer = new StringBuffer();
    xmlStructureBuffer.append("<dct:title>" + temp_title + "</dct:title>\n");
    xmlStructureBuffer.append("<sub:url>" + temp_uri + "</sub:url>\n");
    xmlStructureBuffer.append("<dct:description>" + temp_description + "</dct:description>\n");
    xmlStructureBuffer.append("<dct:publisher>" + temp_publisher + "</dct:publisher>\n");
    xmlStructureBuffer.append("<foaf:Agent>" + temp_added_publisher + "</foaf:Agent>\n");

    if (temp_languages != null) {
      for (String s : temp_languages) {
        //xmlStructureBuffer.append("<language>" + s + "</language>\n");
        xmlStructureBuffer.append("<dct:language rdf:description=\"" + s + "\"/>\n");
      }
    }

    if (temp_mediatypes != null) {

      for (String s : temp_mediatypes) {
        xmlStructureBuffer.append("<dct:MediaType rdf:description=\"" + s + "\"/>\n");
      }

    }

    if (temp_audiences != null) {

      for (String s : temp_audiences) {
        xmlStructureBuffer.append("<dct:audience rdf:description=\"" + s + "\"/>\n");
      }

    }

    if (temp_subjects != null) {
      for (String s : temp_subjects) {
        xmlStructureBuffer.append("<dct:subject rdf:description=\"" + s + "\"/>\n");
      }
    }

    xmlStructureBuffer.append("<rdfs:comment>" + temp_comment + "</rdfs:comment>\n");
    xmlStructureBuffer.append("<wdr:DR>" + temp_status + "</wdr:DR>\n");

    return xmlStructureBuffer;
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

