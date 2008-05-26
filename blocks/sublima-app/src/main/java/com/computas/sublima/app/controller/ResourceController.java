package com.computas.sublima.app.controller;

import com.computas.sublima.query.SparqlDispatcher;
import com.computas.sublima.query.SparulDispatcher;
import com.computas.sublima.app.service.AdminService;
import com.computas.sublima.app.controller.admin.AdminController;
import static com.computas.sublima.query.service.SettingsService.getProperty;
import com.hp.hpl.jena.sparql.util.StringUtils;
import org.apache.cocoon.components.flow.apples.AppleRequest;
import org.apache.cocoon.components.flow.apples.AppleResponse;
import org.apache.cocoon.components.flow.apples.StatelessAppleController;
import org.apache.cocoon.environment.Request;
import org.apache.log4j.Logger;

import java.util.Enumeration;
import java.util.HashMap;
import java.util.Map;
import java.util.TreeMap;

/**
 * @author: mha
 * Date: 31.mar.2008
 */
public class ResourceController implements StatelessAppleController {

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

    if ("ressurser".equalsIgnoreCase(mode)) {
      if ("".equalsIgnoreCase(submode) || submode == null) {
        showResourcesIndex(res, req);
        return;
      } else if ("foreslaatte".equalsIgnoreCase(submode)) {
        showSuggestedResources(res, req);
        return;
      } else if ("ny".equalsIgnoreCase(submode)) {
        editResource(res, req, "ny", null);
        return;
      } else if ("edit".equalsIgnoreCase(submode)) {
        editResource(res, req, "edit", null);
        return;
      } else {
        return;
      }
    } else {
      res.sendStatus(404);
      return;
    }
  }

  /**
   * Method to add new resources and edit existing ones
   * Sparql queries for all topics, statuses, languages, media types and audience
   * is done and the results forwarded to the JX Template and XSLT.
   * <p/>
   * A query for the resource is done when the action is "edit". In case of "new" a blank
   * form is presented.
   *
   * @param res      - AppleResponse
   * @param req      - AppleRequest
   * @param type     - String "new" or "edit"
   * @param messages
   */
  private void editResource(AppleResponse res, AppleRequest req, String type, String messages) {

    boolean validated = true;
    boolean deleteSuccess = false;
    boolean insertSuccess = false;

    String dctPublisher;
    String dctIdentifier;
    String dateAccepted;
    String committer;

    // Get all list values
    String allTopics = adminService.getAllTopics();
    String allLanguages = adminService.getAllLanguages();
    String allMediatypes = adminService.getAllMediaTypes();
    String allAudiences = adminService.getAllAudiences();
    String allStatuses = adminService.getAllStatuses();
    String allPublishers = adminService.getAllPublishers();

    StringBuffer messageBuffer = new StringBuffer();
    messageBuffer.append("<c:messages xmlns:c=\"http://xmlns.computas.com/cocoon\">\n");
    messageBuffer.append(messages);

    Map<String, Object> bizData = new HashMap<String, Object>();
    bizData.put("topics", allTopics);
    bizData.put("languages", allLanguages);
    bizData.put("mediatypes", allMediatypes);
    bizData.put("audience", allAudiences);
    bizData.put("status", allStatuses);
    bizData.put("publishers", allPublishers);

    // When GET present a blank form with listvalues or prefilled with resource
    if (req.getCocoonRequest().getMethod().equalsIgnoreCase("GET")) {
      bizData.put("tempvalues", "<empty></empty>");

      if ("ny".equalsIgnoreCase(type)) {
        bizData.put("resource", "<empty></empty>");
        bizData.put("mode", "edit");
      } else {
        bizData.put("resource", adminService.getResourceByURI(req.getCocoonRequest().getParameter("uri")));
        bizData.put("mode", "edit");
      }

      bizData.put("messages", "<empty></empty>");
      res.sendPage("xml2/ressurs", bizData);

      // When POST try to save the resource. Return error messages upon failure, and success message upon great success
    } else if (req.getCocoonRequest().getMethod().equalsIgnoreCase("POST")) {

      StringBuffer tempValues = getTempValues(req);
      String tempPrefixes = "<c:tempvalues \n" +
              "xmlns:topic=\"" + getProperty("sublima.base.url") + "topic/\"\n" +
              "xmlns:skos=\"http://www.w3.org/2004/02/skos/core#\"\n" +
              "xmlns:wdr=\"http://www.w3.org/2007/05/powder#\"\n" +
              "xmlns:lingvoj=\"http://www.lingvoj.org/ontology#\"\n" +
              "xmlns:sioc=\"http://rdfs.org/sioc/ns#\"\n" +
              "xmlns:rdf=\"http://www.w3.org/1999/02/22-rdf-syntax-ns#\"\n" +
              "xmlns:foaf=\"http://xmlns.com/foaf/0.1/\"\n" +
              "xmlns:owl=\"http://www.w3.org/2002/07/owl#\"\n" +
              "xmlns:dct=\"http://purl.org/dc/terms/\"\n" +
              "xmlns:xsd=\"http://www.w3.org/2001/XMLSchema#\"\n" +
              "xmlns:dcmitype=\"http://purl.org/dc/dcmitype/\"\n" +
              "xmlns:rdfs=\"http://www.w3.org/2000/01/rdf-schema#\"\n" +
              "xmlns:c=\"http://xmlns.computas.com/cocoon\"\n" +
              "xmlns:sub=\"http://xmlns.computas.com/sublima#\">\n";

      // Check if all required fields are filled out, if not return error messages
      String validationMessages = validateRequest(req);
      if (!"".equalsIgnoreCase(validationMessages)) {
        messageBuffer.append(validationMessages + "\n");
        messageBuffer.append("</c:messages>\n");

        bizData.put("resource", "<empty></empty>");
        bizData.put("tempvalues", tempPrefixes + tempValues.toString() + "</c:tempvalues>");
        bizData.put("messages", messageBuffer.toString());
        bizData.put("mode", "temp");

        res.sendPage("xml2/ressurs", bizData);

      } else {
        Map<String, String[]> parameterMap = new TreeMap<String, String[]>(createParametersMap(req.getCocoonRequest()));

        // If the user names a new publisher we persist this and use the new publisher URI in our INSERT later
        if ("".equalsIgnoreCase(req.getCocoonRequest().getParameter("dct:publisher")) && (req.getCocoonRequest().getParameter("dct:publisher/foaf:Agent/foaf:name") != null || "".equalsIgnoreCase(req.getCocoonRequest().getParameter("dct:publisher/foaf:Agent/foaf:name")))) {
          dctPublisher = adminService.insertPublisher(req.getCocoonRequest().getParameter("dct:publisher/foaf:Agent/foaf:name"));
          if ("".equalsIgnoreCase(dctPublisher)) {
            messageBuffer.append("<c:message>Feil ved tillegging av ny utgiver</c:message>\n");
            validated = false;

            /* //todo OO this
           bizData.put("resource", "<empty></empty>");
           res.sendPage("xml2/ressurs", bizData);*/
          } else {
            messageBuffer.append("<c:message>" + req.getCocoonRequest().getParameter("dct:publisher/foaf:Agent/foaf:name") + "  lagt til som ny utgiver</c:message>\n");
            // Remove empty publisher reference and add a new with the publisher uri
            //parameterMap.remove("dct:publisher");
            //parameterMap.remove("dct:publisher/foaf:Agent/foaf:name");
            //parameterMap.put("dct:publisher", new String[]{dctPublisher});
          }
        } else {
          dctPublisher = req.getCocoonRequest().getParameter("dct:publisher");
        }

        //parameterMap.put("interface-language", new String[]{"no"});
        //parameterMap.put("the-resource", new String[]{req.getCocoonRequest().getParameter("sub:url")});

        // Generate a dct:identifier if it's a new resource
        if ("".equalsIgnoreCase(req.getCocoonRequest().getParameter("dct:identifier")) || req.getCocoonRequest().getParameter("dct:identifier") == null) {
          dctIdentifier = req.getCocoonRequest().getParameter("dct:title").replace(" ", "_");
          dctIdentifier = dctIdentifier.replace(",", "_");
          dctIdentifier = dctIdentifier.replace(".", "_");
          dctIdentifier = getProperty("sublima.base.url") + "resource/" + dctIdentifier + "_" + dctIdentifier.hashCode();
        } else {
          dctIdentifier = req.getCocoonRequest().getParameter("dct:identifier");
        }

        //parameterMap.put("dct:identifier", new String[]{dctIdentifier});
        //parameterMap.put("prefix", prefixArray);

        //todo Fix med autorisasjon
        dateAccepted = "2008-18-09T13:39:38";
        committer = getProperty("sublima.base.url") + "user/det_usr00057";

        //parameterMap.put("dct:dateAccepted", new String[]{"2008-18-09T13:39:38"});
        //parameterMap.put("sub:committer", new String[]{"http://sublima.computas.com/user/det_usr00057"});

        //Form2SparqlService form2SparqlService = new Form2SparqlService(parameterMap.get("prefix"));
        //parameterMap.remove("prefix"); // The prefixes are magic variables

        // If no validation failures at this point
        if (validated) {
          String uri = req.getCocoonRequest().getParameter("sub:url");
          int i = 0;

          StringBuffer deleteString = new StringBuffer();
          StringBuffer whereString = new StringBuffer();
          deleteString.append(completePrefixes);
          deleteString.append("\nDELETE\n{\n");
          whereString.append("\nWHERE\n{\n");
          deleteString.append("<" + uri + "> a sub:Resource .\n");
          whereString.append("<" + uri + "> a sub:Resource .\n");

          StringBuffer insertString = new StringBuffer();
          insertString.append(completePrefixes);
          insertString.append("\nINSERT\n{\n");
          insertString.append("<" + uri + "> a sub:Resource .\n");
          insertString.append("<" + uri + "> sub:url \"" + uri + "\" .\n");

          // Check all input parameters and "DELETE" those who have a value
          if (req.getCocoonRequest().getParameter("dct:title") != null) {
            i += 1;
            deleteString.append("<" + uri + "> dct:title ?var" + i + " .\n");
            whereString.append("<" + uri + "> dct:title ?var" + i + " .\n");
            insertString.append("<" + uri + "> dct:title \"" + req.getCocoonRequest().getParameter("dct:title") + "\"@no .\n");
          }

          if (req.getCocoonRequest().getParameter("dct:description") != null || " ".equalsIgnoreCase(req.getCocoonRequest().getParameter("dct:description"))) {
            i += 1;
            deleteString.append("<" + uri + "> dct:description ?var" + i + " .\n");
            whereString.append("<" + uri + "> dct:description ?var" + i + " .\n");
            insertString.append("<" + uri + "> dct:description \"\"\"" + req.getCocoonRequest().getParameter("dct:description") + "\"\"\"@no .\n");
          }

          if (req.getCocoonRequest().getParameter("dct:publisher/foaf:Agent/@rdf:about") != null) {
            i += 1;
            deleteString.append("<" + uri + "> dct:publisher ?var" + i + " .\n");
            whereString.append("<" + uri + "> dct:publisher ?var" + i + " .\n");
          }

          insertString.append("<" + uri + "> dct:publisher <" + dctPublisher + "> .\n");

          if (req.getCocoonRequest().getParameterValues("dct:language") != null) {
            i += 1;
            deleteString.append("<" + uri + "> dct:language ?var" + i + " .\n");
            whereString.append("<" + uri + "> dct:language ?var" + i + " .\n");

            for (String s : req.getCocoonRequest().getParameterValues("dct:language")) {
              insertString.append("<" + uri + "> dct:language <" + s + "> .\n");
            }
          }

          if (req.getCocoonRequest().getParameterValues("dct:format") != null) {
            i += 1;
            deleteString.append("<" + uri + "> dct:format ?var" + i + " .\n");
            whereString.append("<" + uri + "> dct:format ?var" + i + " .\n");

            for (String s : req.getCocoonRequest().getParameterValues("dct:format")) {
              insertString.append("<" + uri + "> dct:format <" + s + "> .\n");
            }
          }

          if (req.getCocoonRequest().getParameterValues("dct:audience") != null) {
            i += 1;
            deleteString.append("<" + uri + "> dct:audience ?var" + i + " .\n");
            whereString.append("<" + uri + "> dct:audience ?var" + i + " .\n");

            for (String s : req.getCocoonRequest().getParameterValues("dct:audience")) {
              insertString.append("<" + uri + "> dct:audience <" + s + "> .\n");
            }
          }

          if (req.getCocoonRequest().getParameterValues("dct:subject") != null) {
            i += 1;
            deleteString.append("<" + uri + "> dct:subject ?var" + i + " .\n");
            whereString.append("<" + uri + "> dct:subject ?var" + i + " .\n");

            for (String s : req.getCocoonRequest().getParameterValues("dct:subject")) {
              insertString.append("<" + uri + "> dct:subject <" + s + "> .\n");
            }
          }

          if (req.getCocoonRequest().getParameter("rdfs:comment") != null) {
            i += 1;
            deleteString.append("<" + uri + "> rdfs:comment ?var" + i + " .\n");
            whereString.append("<" + uri + "> rdfs:comment ?var" + i + " .\n");
            insertString.append("<" + uri + "> rdfs:comment \"\"\"" + (req.getCocoonRequest().getParameter("rdfs:comment")) + "\"\"\"@no .\n");
          }

          if (req.getCocoonRequest().getParameter("wdr:describedBy") != null) {
            i += 1;
            deleteString.append("<" + uri + "> wdr:describedBy ?var" + i + " .\n");
            whereString.append("<" + uri + "> wdr:describedBy ?var" + i + " .\n");
            insertString.append("<" + uri + "> wdr:describedBy <" + (req.getCocoonRequest().getParameter("wdr:describedBy")) + "> .\n");
          }

          i += 1;
          deleteString.append("<" + uri + "> dct:publisher ?var" + i + " .\n");
          whereString.append("<" + uri + "> dct:publisher ?var" + i + " .\n");
          i += 1;
          deleteString.append("<" + uri + "> dct:identifier ?var" + i + " .\n");
          whereString.append("<" + uri + "> dct:identifier ?var" + i + " .\n");
          i += 1;
          deleteString.append("<" + uri + "> dct:dateAccepted ?var" + i + " .\n");
          whereString.append("<" + uri + "> dct:dateAccepted ?var" + i + " .\n");
          i += 1;
          deleteString.append("<" + uri + "> sub:committer ?var" + i + " .\n");
          whereString.append("<" + uri + "> sub:committer ?var" + i + " .\n");


          insertString.append("<" + uri + "> dct:identifier <" + dctIdentifier + "> .\n");
          insertString.append("<" + uri + "> dct:dateAccepted \"" + dateAccepted + "\" .\n");
          insertString.append("<" + uri + "> sub:committer <" + committer + "> .\n");

          deleteString.append("}\n");
          whereString.append("}\n");
          insertString.append("}\n");

          deleteString.append(whereString.toString());

          deleteSuccess = sparulDispatcher.query(deleteString.toString());
          insertSuccess = sparulDispatcher.query(insertString.toString());

          // String sparqlQuery = form2SparqlService.convertForm2Sparul(parameterMap);
          logger.trace("AdminController.editResource --> DELETE QUERY:\n" + deleteString.toString());
          logger.trace("AdminController.editResource --> INSERT QUERY:\n" + insertString.toString());
          //validated = sparulDispatcher.query(sparqlQuery);
          logger.trace("AdminController.editResource --> DELETE QUERY RESULT: " + deleteSuccess);
          logger.trace("AdminController.editResource --> INSERT QUERY RESULT: " + insertSuccess);

          if (deleteSuccess && insertSuccess) {
            messageBuffer.append("<c:message>Ny ressurs lagt til!</c:message>\n");

          } else {
            messageBuffer.append("<c:message>Feil ved lagring av ny ressurs</c:message>\n");
            bizData.put("resource", "<empty></empty>");
          }
        }

        if (deleteSuccess && insertSuccess) {
          bizData.put("resource", adminService.getResourceByURI(req.getCocoonRequest().getParameter("sub:url")));
          bizData.put("tempvalues", "<empty></empty>");
          bizData.put("mode", "edit");
        } else {
          bizData.put("resource", "<empty></empty>");
          bizData.put("tempvalues", tempPrefixes + tempValues.toString() + "</c:tempvalues>");
          bizData.put("mode", "temp");
        }

        messageBuffer.append("</c:messages>\n");

        bizData.put("messages", messageBuffer.toString());

        res.sendPage("xml2/ressurs", bizData);
      }


    }
  }

  /**
   * Method to validate the request upon insert of new resource.
   * Checks all parameters and gives error message if one or more required values are null
   * Also chekcs for duplicates, and gives an error message when the resource URI is already registered.
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
    } else {
      String resource = (String) adminService.getResourceByURI(req.getCocoonRequest().getParameter("sub:url"));
      if (resource.contains(req.getCocoonRequest().getParameter("sub:url"))) {
        validationMessages.append("<c:message>En ressurs med denne URI finnes fra før</c:message>\n");  
      }

      if (!adminService.validateURL(req.getCocoonRequest().getParameter("sub:url"))) {
        validationMessages.append("<c:message>Denne ressursens URI gir en statuskode som tilsier at den ikke er OK. Vennligst sjekk ressursens nettside og prøv igjen.</c:message>\n");

      }
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

    if (req.getCocoonRequest().getParameterValues("dct:format") == null) {
      validationMessages.append("<c:message>Minst en mediatype må være valgt</c:message>\n");
    }

    /* Commented out due to the lack of dct:audience in SMIL test data
    if (req.getCocoonRequest().getParameterValues("dct:audience") == null) {
      validationMessages.append("<c:message>Minst en målgruppe må være valgt</c:message>\n");
    }*/

    if (req.getCocoonRequest().getParameterValues("dct:subject") == null) {
      validationMessages.append("<c:message>Minst ett emne må være valgt</c:message>\n");
    }

    if (req.getCocoonRequest().getParameter("wdr:describedBy") == null) {
      validationMessages.append("<c:message>En status må velges</c:message>\n");
    }

    return validationMessages.toString();
  }

  private StringBuffer getTempValues(AppleRequest req) {
    //Keep all selected values in case of validation error
    String temp_title = req.getCocoonRequest().getParameter("dct:title");
    String temp_uri = req.getCocoonRequest().getParameter("sub:url");
    String temp_description = req.getCocoonRequest().getParameter("dct:description");
    String temp_publisher = req.getCocoonRequest().getParameter("dct:publisher");
    String temp_added_publisher = req.getCocoonRequest().getParameter("dct:publisher/foaf:Agent/foaf:name");
    String[] temp_languages = req.getCocoonRequest().getParameterValues("dct:language");
    String[] temp_mediatypes = req.getCocoonRequest().getParameterValues("dct:format");
    String[] temp_audiences = req.getCocoonRequest().getParameterValues("dct:audience");
    String[] temp_subjects = req.getCocoonRequest().getParameterValues("dct:subject");
    String temp_comment = req.getCocoonRequest().getParameter("rdfs:comment");
    String temp_status = req.getCocoonRequest().getParameter("wdr:describedBy");

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
        xmlStructureBuffer.append("<dct:format rdf:description=\"" + s + "\"/>\n");
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
    xmlStructureBuffer.append("<wdr:describedBy>" + temp_status + "</wdr:describedBy>\n");

    return xmlStructureBuffer;
  }

  /**
   * Method to displaty a list of all resources suggested by users
   *
   * @param res - AppleResponse
   * @param req - AppleRequest
   */
  private void showSuggestedResources
          (AppleResponse
                  res, AppleRequest
                  req) {
    String queryString = StringUtils.join("\n", new String[]{
            completePrefixes,
            "CONSTRUCT {",
            "    ?resource dct:title ?title ;" +
                    //"              dct:identifier ?identifier ;" +
                    "              a sub:Resource . }",
            "    WHERE {",
            "        ?resource wdr:describedBy <http://sublima.computas.com/status/til_godkjenning> ;",
            "                  dct:title ?title .",
            //"                  dct:identifier ?identifier .",
            "}"});

    logger.trace("AdminController.showSuggestedResources() --> SPARQL query sent to dispatcher: \n" + queryString);
    Object queryResult = sparqlDispatcher.query(queryString);

    Map<String, Object> bizData = new HashMap<String, Object>();

    if ("".equalsIgnoreCase((String) queryResult) || queryResult == null) {
      bizData.put("suggestedresourceslist", "<empty></empty>");
    } else {
      bizData.put("suggestedresourceslist", queryResult);
    }
    res.sendPage("xml2/foreslaatte", bizData);
  }

  /**
   * Method to display the initial page for administrating resources
   *
   * @param res - AppleResponse
   * @param req - AppleRequest
   */
  private void showResourcesIndex
          (AppleResponse
                  res, AppleRequest
                  req) {
    res.sendPage("xml2/ressurser", null);
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

  //todo Move to a Service-class
  private Map<String, String[]> createParametersMap
          (Request
                  request) {
    Map<String, String[]> result = new HashMap<String, String[]>();
    Enumeration parameterNames = request.getParameterNames();
    while (parameterNames.hasMoreElements()) {
      String paramName = (String) parameterNames.nextElement();
      result.put(paramName, request.getParameterValues(paramName));
    }
    return result;
  }
}

