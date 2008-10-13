package com.computas.sublima.app.controller.admin;

import com.computas.sublima.app.service.AdminService;
import com.computas.sublima.app.service.Form2SparqlService;
import com.computas.sublima.query.SparqlDispatcher;
import com.computas.sublima.query.SparulDispatcher;
import com.computas.sublima.query.service.SearchService;
import static com.computas.sublima.query.service.SettingsService.getProperty;
import com.hp.hpl.jena.sparql.util.StringUtils;
import org.apache.cocoon.auth.ApplicationManager;
import org.apache.cocoon.auth.ApplicationUtil;
import org.apache.cocoon.auth.User;
import org.apache.cocoon.components.flow.apples.AppleRequest;
import org.apache.cocoon.components.flow.apples.AppleResponse;
import org.apache.cocoon.components.flow.apples.StatelessAppleController;
import org.apache.cocoon.environment.Request;
import org.apache.log4j.Logger;

import java.io.IOException;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Map;
import java.util.TreeMap;

/**
 * @author: mha
 * Date: 31.mar.2008
 */
public class TopicController implements StatelessAppleController {

  private SparqlDispatcher sparqlDispatcher;
  private SparulDispatcher sparulDispatcher;
  AdminService adminService = new AdminService();
  private ApplicationManager appMan;
  private ApplicationUtil appUtil = new ApplicationUtil();
  private User user;
  private String mode;
  private String submode;
  private String userPrivileges = "<empty/>";
  private boolean loggedIn = false;
  String[] completePrefixArray = {"PREFIX rdf: 		<http://www.w3.org/1999/02/22-rdf-syntax-ns#>", "PREFIX rdfs: 		<http://www.w3.org/2000/01/rdf-schema#>", "PREFIX owl: 		<http://www.w3.org/2002/07/owl#>", "PREFIX foaf: 		<http://xmlns.com/foaf/0.1/>", "PREFIX lingvoj: 	<http://www.lingvoj.org/ontology#>", "PREFIX dcmitype: 	<http://purl.org/dc/dcmitype/>", "PREFIX dct: 		<http://purl.org/dc/terms/>", "PREFIX sub: 		<http://xmlns.computas.com/sublima#>", "PREFIX wdr: 		<http://www.w3.org/2007/05/powder#>", "PREFIX sioc: 		<http://rdfs.org/sioc/ns#>", "PREFIX xsd: 		<http://www.w3.org/2001/XMLSchema#>", "PREFIX topic: 		<topic/>", "PREFIX skos:		<http://www.w3.org/2004/02/skos/core#>"};

  String completePrefixes = StringUtils.join("\n", completePrefixArray);

  private static Logger logger = Logger.getLogger(AdminController.class);

  private String getRequestXML(AppleRequest req) {
    // This is such a 1999 way of doing things. There should be a generic SAX events generator
    // or something that would serialise this data structure automatically in a one-liner,
    // but I couldn't find it. Also, the code should not be in each and every controller.
    // Arguably a TODO.
    StringBuffer params = new StringBuffer();
    String uri = req.getCocoonRequest().getRequestURI();
    int paramcount = 0;
    params.append("  <c:request xmlns:c=\"http://xmlns.computas.com/cocoon\" justbaseurl=\"" + uri + "\" ");
    if (req.getCocoonRequest().getQueryString() != null) {
      uri += "?" + req.getCocoonRequest().getQueryString();
      uri = uri.replace("&", "&amp;");
      uri = uri.replace("<", "%3C");
      uri = uri.replace(">", "%3E");
      uri = uri.replace("#", "%23");
      paramcount = req.getCocoonRequest().getParameters().size();
    }
    params.append("paramcount=\"" + paramcount + "\" ");
    params.append("requesturl=\"" + uri);
    params.append("\"/>\n");
    return params.toString();
  }

  @SuppressWarnings("unchecked")
  public void process(AppleRequest req, AppleResponse res) throws Exception {
    this.mode = req.getSitemapParameter("mode");
    this.submode = req.getSitemapParameter("submode");
    loggedIn = appMan.isLoggedIn("Sublima");

    if (appUtil.getUser() != null) {
      user = appUtil.getUser();
      userPrivileges = adminService.getRolePrivilegesAsXML(user.getAttribute("role").toString());
    }

    if ("emner".equalsIgnoreCase(mode)) {
      if ("".equalsIgnoreCase(submode) || submode == null) {
        Map<String, Object> bizData = new HashMap<String, Object>();
        bizData.put("facets", adminService.getMostOfTheRequestXMLWithPrefix(req) + "</c:request>");
        System.gc();
        res.sendPage("xml2/emner", bizData);
      } else if ("nytt".equalsIgnoreCase(submode)) {
        editTopic(res, req, "nytt", null);
      } else if ("alle".equalsIgnoreCase(submode)) {
        showTopics(res, req);
      } else if ("emne".equalsIgnoreCase(submode)) {
        editTopic(res, req, "edit", null);
      } else if ("koble".equalsIgnoreCase(submode)) {
        mergeTopics(res, req);
      } else if ("tema".equalsIgnoreCase(submode)) {
        setThemeTopics(res, req);
      } else {
        res.sendStatus(404);
      }
    } else if ("browse".equalsIgnoreCase(mode)) {
      showTopicBrowsing(res, req);
    } else if ("relasjoner".equalsIgnoreCase(mode)) {
      if ("".equalsIgnoreCase(submode) || submode == null) {
        Map<String, Object> bizData = new HashMap<String, Object>();
        bizData.put("facets", adminService.getMostOfTheRequestXMLWithPrefix(req) + "</c:request>");
        System.gc();
        res.sendPage("xml2/relasjoner", bizData);
      } else if ("relasjon".equalsIgnoreCase(submode)) {
        editRelation(res, req, null);
      } else if ("alle".equalsIgnoreCase(submode)) {
        showRelations(res, req);
      }
    } else if ("a-z".equalsIgnoreCase(mode)) {
      getTopicsByLetter(res, req, submode);
    }
  }

  /**
   * Method to get all topics starting with the given letter(s).
   * Used in the A-Z topic browsing
   *
   * @param res
   * @param req
   * @param letter
   */
  private void getTopicsByLetter(AppleResponse res, AppleRequest req, String letter) {
    Map<String, Object> bizData = new HashMap<String, Object>();

    bizData.put("themetopics", adminService.getTopicsByLetter(letter));
    bizData.put("mode", "browse");
    bizData.put("letter", letter);
    bizData.put("loggedin", "<empty></empty>");
    bizData.put("facets", getRequestXML(req));
    System.gc();
    res.sendPage("xml/browse", bizData);
  }

  private void editRelation(AppleResponse res, AppleRequest req, Object o) {
    StringBuffer messageBuffer = new StringBuffer();
    messageBuffer.append("<c:messages xmlns:i18n=\"http://apache.org/cocoon/i18n/2.1\" xmlns:c=\"http://xmlns.computas.com/cocoon\">\n");
    Map<String, Object> bizData = new HashMap<String, Object>();
    String uri = req.getCocoonRequest().getParameter("the-resource");

    bizData.put("allanguages", adminService.getAllLanguages());
    bizData.put("userprivileges", userPrivileges);

    if ("GET".equalsIgnoreCase(req.getCocoonRequest().getMethod())) {

      bizData.put("tempvalues", "<empty></empty>");
      if ("".equalsIgnoreCase(uri) || uri == null) {
        bizData.put("relationdetails", "<empty></empty>");
      } else {
        bizData.put("relationdetails", adminService.getRelationByURI(uri));
      }

      bizData.put("mode", "topicrelated");

      bizData.put("messages", "<empty></empty>");
      bizData.put("facets", getRequestXML(req));
      System.gc();
      res.sendPage("xml2/relasjon", bizData);

    } else if ("POST".equalsIgnoreCase(req.getCocoonRequest().getMethod())) {
      Map<String, String[]> parameterMap = new TreeMap<String, String[]>(createParametersMap(req.getCocoonRequest()));
      parameterMap.remove("actionbutton");
      Form2SparqlService form2SparqlService = new Form2SparqlService(parameterMap.get("prefix"));
      parameterMap.remove("prefix"); // The prefixes are magic variables
      if (parameterMap.get("subjecturi-prefix") != null) {
        parameterMap.put("subjecturi-prefix", new String[]{getProperty("sublima.base.url") +
                parameterMap.get("subjecturi-prefix")[0]});
      }
      String sparqlQuery = null;
      try {
        sparqlQuery = form2SparqlService.convertForm2Sparul(parameterMap);
      }
      catch (IOException e) {
        messageBuffer.append("<c:message><i18n:text key=\"topic.relation.saveerror\">Feil ved lagring av ny relasjonstype</i18n:text></c:message>\n");
      }

      logger.trace("TopicController.editRelation --> QUERY:\n" + sparqlQuery);

      boolean insertSuccess = sparulDispatcher.query(sparqlQuery);

      logger.trace("TopicController.editRelation --> QUERY RESULT: " + insertSuccess);

      if (insertSuccess) {
        messageBuffer.append("<c:message><i18n:text key=\"topic.relation.saved\">Ny relasjonstype lagret</i18n:text></c:message>\n");

        bizData.put("relationdetails", adminService.getRelationByURI(form2SparqlService.getURI()));

      } else {
        messageBuffer.append("<c:message><i18n:text key=\"topic.relation.saveerror\">Feil ved lagring av ny relasjonstype</i18n:text></c:message>\n");
        bizData.put("relationdetails", "<empty></empty>");
      }


      bizData.put("mode", "topicrelated");

      if (insertSuccess) {
        bizData.put("tempvalues", "<empty></empty>");
      } else {
        bizData.put("tempvalues", "<empty></empty>");
      }

      messageBuffer.append("</c:messages>\n");

      bizData.put("messages", messageBuffer.toString());
      bizData.put("facets", getRequestXML(req));
      System.gc();
      res.sendPage("xml2/relasjon", bizData);
    }
  }

  private void showTopicBrowsing
          (AppleResponse
                  res, AppleRequest
                  req) {

    Map<String, Object> bizData = new HashMap<String, Object>();
    String themeTopics = adminService.getThemeTopics();
    if (!themeTopics.contains("sub:theme")) {
      bizData.put("themetopics", "<empty></empty>");
    } else {
      bizData.put("themetopics", themeTopics);
    }

    bizData.put("mode", "browse");
    bizData.put("loggedin", loggedIn);
    bizData.put("letter", "");
    bizData.put("facets", getRequestXML(req));
    System.gc();
    res.sendPage("xml/browse", bizData);
  }

  private void mergeTopics
          (AppleResponse
                  res, AppleRequest
                  req) {
    StringBuffer messageBuffer = new StringBuffer();
    messageBuffer.append("<c:messages xmlns:i18n=\"http://apache.org/cocoon/i18n/2.1\" xmlns:c=\"http://xmlns.computas.com/cocoon\">\n");
    Map<String, Object> bizData = new HashMap<String, Object>();

    if ("GET".equalsIgnoreCase(req.getCocoonRequest().getMethod())) {
      bizData.put("messages", "<empty></empty>");
    } else if ("POST".equalsIgnoreCase(req.getCocoonRequest().getMethod())) {

      // Create new URI for new topic.
      // Declare the new topic to be a union of the older
      // Mark the old as inactive.


      SearchService searchService = new SearchService();

      String uri = searchService.sanitizeStringForURI(req.getCocoonRequest().getParameter("skos:prefLabel"));
      uri = getProperty("sublima.base.url") + "topic/" + uri;

      String insertNewTopicString = completePrefixes + "\nINSERT\n{\n" + "<" + uri + "> a skos:Concept ;\n"
              + " skos:prefLabel \"" + req.getCocoonRequest().getParameter("skos:prefLabel") + "\"@no ;\n"
              + " wdr:describedBy <http://sublima.computas.com/status/godkjent_av_administrator> .\n"
              /*           + " owl:unionOf <" + StringUtils.join(">, <", req.getCocoonRequest().getParameterValues("skos:Concept")) + "> .\n"  */
              + "}";

      logger.trace("TopicController.mergeTopics --> INSERT NEW TOPIC QUERY:\n" + insertNewTopicString);
      boolean updateSuccess;
      updateSuccess = sparulDispatcher.query(insertNewTopicString);

      for (String oldurl : req.getCocoonRequest().getParameterValues("skos:Concept")) {
        String sparulQuery = "MODIFY\nDELETE { ?s ?p <" + oldurl + "> }\nINSERT { ?s ?p <" + uri + "> }\nWHERE { ?s ?p <" + oldurl + "> }\n";
        logger.trace("Changing " + oldurl + " to " + uri + " in objects.");
        updateSuccess = sparulDispatcher.query(sparulQuery);
        logger.debug("Object edit status: " + updateSuccess);
        sparulQuery = "PREFIX wdr: <http://www.w3.org/2007/05/powder#>\nPREFIX status: <http://sublima.computas.com/status/>\n" + "" +
                "MODIFY\nDELETE { <" + oldurl + "> wdr:describedBy ?status . }\nINSERT { <" + oldurl + "> wdr:describedBy status:inaktiv . }\nWHERE { <" + oldurl + "> wdr:describedBy ?status . }\n";
        logger.trace("Setting " + oldurl + " topics inactive.");
        updateSuccess = sparulDispatcher.query(sparulQuery);
        logger.debug("Topic inactive status: " + updateSuccess);


      }

      if (updateSuccess) {
        messageBuffer.append("<c:message><i18n:text key=\"topic.merged.ok\">Emnene er slått sammen</i18n:text></c:message>\n");
      } else {
        messageBuffer.append("<c:message><i18n:text key=\"topic.merged.failed\">En feil oppsto ved sammenslåing</i18n:text></c:message>\n");
      }

      messageBuffer.append("</c:messages>\n");

      bizData.put("messages", messageBuffer.toString());

    }
    bizData.put("tempvalues", "<empty></empty>");
    bizData.put("alltopics", adminService.getAllTopics());
    bizData.put("mode", "topicjoin");
    bizData.put("userprivileges", userPrivileges);
    bizData.put("facets", getRequestXML(req));
    System.gc();
    res.sendPage("xml2/koble", bizData);

  }

  private void setThemeTopics
          (AppleResponse
                  res, AppleRequest
                  req) {
    StringBuffer messageBuffer = new StringBuffer();
    messageBuffer.append("<c:messages xmlns:i18n=\"http://apache.org/cocoon/i18n/2.1\" xmlns:c=\"http://xmlns.computas.com/cocoon\">\n");
    Map<String, Object> bizData = new HashMap<String, Object>();

    if ("GET".equalsIgnoreCase(req.getCocoonRequest().getMethod())) {
      bizData.put("themetopics", adminService.getThemeTopics());
      bizData.put("tempvalues", "<empty></empty>");
      bizData.put("alltopics", adminService.getAllTopics());
      bizData.put("mode", "theme");

      bizData.put("userprivileges", userPrivileges);
      bizData.put("messages", "<empty></empty>");
      bizData.put("facets", getRequestXML(req));
      System.gc();
      res.sendPage("xml2/tema", bizData);

    } else if ("POST".equalsIgnoreCase(req.getCocoonRequest().getMethod())) {
      Map<String, String[]> requestMap = createParametersMap(req.getCocoonRequest());
      requestMap.remove("actionbutton");
      requestMap.remove("locale");

      StringBuffer deleteString = new StringBuffer();
      StringBuffer whereString = new StringBuffer();
      StringBuffer insertString = new StringBuffer();

      deleteString.append(completePrefixes);
      deleteString.append("\nDELETE\n{\n");
      whereString.append("\nWHERE\n{\n");
      deleteString.append("?topic sub:theme ?theme .\n");
      deleteString.append("}\n");
      whereString.append("?topic sub:theme ?theme.\n");
      whereString.append("}\n");

      insertString.append(completePrefixes);
      insertString.append("\nINSERT\n{\n");

      for (String s : requestMap.keySet()) {
        for (String t : requestMap.get(s)) {
          insertString.append("<" + t + "> sub:theme \"true\"^^xsd:boolean .\n");
        }
      }

      insertString.append("}\n");

      deleteString.append(whereString.toString());

      logger.trace("TopicController.setThemeTopics --> DELETE QUERY:\n" + deleteString.toString());
      logger.trace("TopicController.setThemeTopics --> INSERT QUERY:\n" + insertString.toString());

      boolean deleteSuccess = sparulDispatcher.query(deleteString.toString());
      boolean insertSuccess = sparulDispatcher.query(insertString.toString());

      logger.trace("TopicController.setThemeTopics --> DELETE QUERY RESULT: " + deleteSuccess);
      logger.trace("TopicController.setThemeTopics --> INSERT QUERY RESULT: " + insertSuccess);

      if (deleteSuccess && insertSuccess) {
        messageBuffer.append("<c:message><i18n:text key=\"topic.theme.ok\">Emnene satt som temaemner</i18n:text></c:message>\n");

      } else {
        messageBuffer.append("<c:message><i18n:text key=\"topic.theme.error\">Feil ved merking av temaemner</i18n:text></c:message>\n");
        bizData.put("themetopics", "<empty></empty>");
      }

      if (deleteSuccess && insertSuccess) {
        bizData.put("themetopics", adminService.getThemeTopics());
        bizData.put("tempvalues", "<empty></empty>");
        bizData.put("mode", "theme");
        bizData.put("alltopics", adminService.getAllTopics());
      } else {
        bizData.put("themetopics", adminService.getThemeTopics());
        bizData.put("tempvalues", "<empty></empty>");
        bizData.put("mode", "theme");
        bizData.put("alltopics", adminService.getAllTopics());
      }

      bizData.put("userprivileges", userPrivileges);
      messageBuffer.append("</c:messages>\n");

      bizData.put("messages", messageBuffer.toString());
      bizData.put("facets", getRequestXML(req));
      System.gc();
      res.sendPage("xml2/tema", bizData);
    }
  }

  private void showTopics
          (AppleResponse
                  res, AppleRequest
                  req) {
    Map<String, Object> bizData = new HashMap<String, Object>();

    if (req.getCocoonRequest().getParameter("wdr:describedBy") != null && !"".equals(req.getCocoonRequest().getParameter("wdr:describedBy"))) {
      bizData.put("all_topics", adminService.getAllTopicsByStatus(req.getCocoonRequest().getParameter("wdr:describedBy")));
    } else {
      bizData.put("all_topics", adminService.getAllTopicsWithPrefAndAltLabel());
    }

    bizData.put("facets", getRequestXML(req));
    bizData.put("statuses", adminService.getDistinctAndUsedLabels("<http://www.w3.org/2007/05/powder#DR>",
            "<http://www.w3.org/2007/05/powder#describedBy>"));
    System.gc();
    res.sendPage("xml2/emner_alle", bizData);
  }

  private void editTopic
          (AppleResponse
                  res, AppleRequest
                  req, String
                  type, String
                  messages) {

    boolean insertSuccess = false;
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

    StringBuffer tempValues = new StringBuffer();
    String uri = "";

    StringBuffer messageBuffer = new StringBuffer();
    messageBuffer.append("<c:messages xmlns:i18n=\"http://apache.org/cocoon/i18n/2.1\" xmlns:c=\"http://xmlns.computas.com/cocoon\">\n");
    messageBuffer.append(messages);
    Map<String, Object> bizData = new HashMap<String, Object>();
    bizData.put("allanguages", adminService.getAllLanguages());

    if (req.getCocoonRequest().getMethod().equalsIgnoreCase("GET")) {
      bizData.put("tempvalues", "<empty></empty>");

      if ("nytt".equalsIgnoreCase(type)) {
        bizData.put("topicdetails", "<empty></empty>");
        bizData.put("topicresources", "<empty></empty>");
        bizData.put("tempvalues", "<empty></empty>");
        bizData.put("alltopics", adminService.getAllTopics());
        bizData.put("status", adminService.getAllStatuses());
        bizData.put("mode", "topicedit");
        bizData.put("relationtypes", adminService.getAllRelationTypes());
      } else {
        bizData.put("topicdetails", adminService.getTopicByURI(req.getCocoonRequest().getParameter("uri")));
        bizData.put("topicresources", adminService.getTopicResourcesByURI(req.getCocoonRequest().getParameter("uri")));
        bizData.put("alltopics", adminService.getAllTopics());
        bizData.put("status", adminService.getAllStatuses());
        bizData.put("tempvalues", "<empty></empty>");
        bizData.put("mode", "topicedit");
        bizData.put("relationtypes", adminService.getAllRelationTypes());
      }
      bizData.put("userprivileges", userPrivileges);
      bizData.put("messages", "<empty></empty>");
      bizData.put("facets", getRequestXML(req));
      System.gc();
      res.sendPage("xml2/emne", bizData);

      // When POST try to save the resource. Return error messages upon failure, and success message upon great success
    } else if (req.getCocoonRequest().getMethod().equalsIgnoreCase("POST")) {

      if (req.getCocoonRequest().getParameter("actionbuttondelete") != null) {

        if (req.getCocoonRequest().getParameter("warningSingleResource") == null) {

          String deleteString = "DELETE {\n" +
                  "<" + req.getCocoonRequest().getParameter("the-resource") + "> ?a ?o.\n" +
                  "} WHERE {\n" +
                  "<" + req.getCocoonRequest().getParameter("the-resource") + "> ?a ?o. }";

          boolean deleteTopicSuccess = sparulDispatcher.query(deleteString);

          logger.trace("ResourceController.editResource --> DELETE TOPIC QUERY:\n" + deleteString);
          logger.trace("ResourceController.editResource --> DELETE TOPIC QUERY RESULT: " + deleteTopicSuccess);


          if (deleteTopicSuccess) {
            messageBuffer.append("<c:message><i18n:text key=\"topic.deleted.ok\">Emne slettet!</i18n:text></c:message>\n");
          } else {
            messageBuffer.append("<c:message><i18n:text key=\"topic.deleted.error\">Feil ved sletting av emne</i18n:text></c:message>\n");
          }
        } else {
          messageBuffer.append("<c:message><i18n:text key=\"validation.topic.resourceempty\">En eller flere ressurser vil bli stående uten tilknyttet emne dersom du sletter dette emnet. Vennligst kontroller disse ressursene fra listen nederst, og tildel de nye emner eller slett de.</i18n:text></c:message>\n");
        }

      } else {

        Map<String, String[]> parameterMap = new TreeMap<String, String[]>(createParametersMap(req.getCocoonRequest()));
        // 1. Mellomlagre alle verdier
        // 2. Valider alle verdier
        // 3. Forsk  lagre

        tempValues = getTempValues(req);


        Form2SparqlService form2SparqlService = new Form2SparqlService(parameterMap.get("prefix"));
        parameterMap.remove("prefix"); // The prefixes are magic variables
        parameterMap.remove("actionbutton"); // The name of the submit button
        parameterMap.remove("warningSingleResource");
        if (parameterMap.get("subjecturi-prefix") != null) {
          parameterMap.put("subjecturi-prefix", new String[]{getProperty("sublima.base.url") +
                  parameterMap.get("subjecturi-prefix")[0]});
        }

        String sparqlQuery = null;
        try {
          sparqlQuery = form2SparqlService.convertForm2Sparul(parameterMap);
        }
        catch (IOException e) {
          messageBuffer.append("<c:message><i18n:text key=\"topic.save.error\">Feil ved lagring av emne</i18n:text></c:message>\n");
        }

        uri = form2SparqlService.getURI();
        // Check if a topic with the same uri already exists
        if ((req.getCocoonRequest().getParameter("the-resource") == null) && adminService.getTopicByURI(uri).contains("skos:Concept ")) {
          messageBuffer.append("<c:message><i18n:text key=\"topic.exists\">Et emne med denne tittelen og URI finnes allerede</i18n:text></c:message>\n");
        } else {
          logger.trace("TopicController.editTopic --> SPARUL QUERY:\n" + sparqlQuery);
          insertSuccess = sparulDispatcher.query(sparqlQuery);

          logger.debug("TopicController.editTopic --> SPARUL QUERY RESULT: " + insertSuccess);

          if (insertSuccess) {
            if (req.getCocoonRequest().getParameter("the-resource") == null) {
              messageBuffer.append("<c:message><i18n:text key=\"topic.save.ok\">Nytt emne lagt til</i18n:text></c:message>\n");
            } else {
              messageBuffer.append("<c:message><i18n:text key=\"topic.updated\">Emne oppdatert</i18n:text></c:message>\n");
            }


          } else {
            messageBuffer.append("<c:message><i18n:text key=\"topic.save.error\">Feil ved lagring av emne</i18n:text></c:message>\n");
            bizData.put("topicdetails", "<empty></empty>");
          }
        }
      }

      if (insertSuccess) {
        bizData.put("topicdetails", adminService.getTopicByURI(uri));
        bizData.put("topicresources", adminService.getTopicResourcesByURI(uri));
        bizData.put("tempvalues", "<empty></empty>");
        bizData.put("mode", "topicedit");
      } else {
        bizData.put("topicdetails", adminService.getTopicByURI(req.getCocoonRequest().getParameter("the-resource")));
        bizData.put("topicresources", adminService.getTopicResourcesByURI(req.getCocoonRequest().getParameter("the-resource")));
        bizData.put("tempvalues", tempPrefixes + tempValues.toString() + "</c:tempvalues>");
        bizData.put("mode", "topictemp");
      }

      bizData.put("status", adminService.getAllStatuses());
      bizData.put("alltopics", adminService.getAllTopics());
      bizData.put("relationtypes", adminService.getAllRelationTypes());
      bizData.put("userprivileges", userPrivileges);
      messageBuffer.append("</c:messages>\n");
      bizData.put("facets", getRequestXML(req));

      bizData.put("messages", messageBuffer.toString());
      System.gc();
      res.sendPage("xml2/emne", bizData);
    }
  }


  private StringBuffer getTempValues
          (AppleRequest
                  req) {
    //Keep all selected values in case of validation error
    String temp_title = req.getCocoonRequest().getParameter("dct:subject/skos:Concept/skos:prefLabel");
    String[] temp_broader = req.getCocoonRequest().getParameterValues("dct:subject/skos:Concept/skos:broader/rdf:resource");
    String temp_status = req.getCocoonRequest().getParameter("wdr:describedBy");
    String temp_description = req.getCocoonRequest().getParameter("dct:subject/skos:Concept/skos:definition");
    String temp_note = req.getCocoonRequest().getParameter("dct:subject/skos:Concept/skos:note");
    String temp_synonyms = req.getCocoonRequest().getParameter("dct:subject/skos:Concept/skos:altLabel");

    //Create an XML structure for the selected values, to use in the JX template
    StringBuffer xmlStructureBuffer = new StringBuffer();
    xmlStructureBuffer.append("<skos:prefLabel>" + temp_title + "</skos:prefLabel>\n");

    if (temp_broader != null) {
      for (String s : temp_broader) {
        //xmlStructureBuffer.append("<language>" + s + "</language>\n");
        xmlStructureBuffer.append("<skos:broader rdf:resource=\"" + s + "\"/>\n");
      }
    }

    xmlStructureBuffer.append("<wdr:describedBy rdf:resource=\"" + temp_status + "\"/>\n");
    xmlStructureBuffer.append("<skos:description>" + temp_description + "</skos:description>\n");
    xmlStructureBuffer.append("<skos:note>" + temp_note + "</skos:note>\n");
    xmlStructureBuffer.append("<skos:altLabel>" + temp_synonyms + "</skos:altLabel>\n");


    return xmlStructureBuffer;
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

    if ("".equalsIgnoreCase(req.getCocoonRequest().getParameter("dct:subject/skos:Concept/skos:prefLabel")) || req.getCocoonRequest().getParameter("dct:subject/skos:Concept/skos:prefLabel") == null) {
      validationMessages.append("<c:message><i18n:text key=\"topic.validation.titleblank\">Emnets tittel kan ikke være blank</i18n:text></c:message>\n");
    }

    if ("".equalsIgnoreCase(req.getCocoonRequest().getParameter("wdr:describedBy")) || req.getCocoonRequest().getParameter("wdr:describedBy") == null) {
      validationMessages.append("<c:message><i18n:text key=\"validation.statuschoice\">En status må velges</i18n:text></c:message>\n");
    } else if (!userPrivileges.contains(req.getCocoonRequest().getParameter("wdr:describedBy"))) {
      validationMessages.append("<c:message><i18n:text key=\"topic.validation.rolestatus\">Rollen du har tillater ikke å lagre et emne med den valgte statusen.</i18n:text></c:message>\n");
    }

    return validationMessages.toString();
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

  public void setAppMan
          (ApplicationManager
                  appMan) {
    this.appMan = appMan;
  }

  private void showRelations(AppleResponse res, AppleRequest req) {
    Map<String, Object> bizData = new HashMap<String, Object>();
    bizData.put("all_relations", adminService.getAllRelationTypes());
    bizData.put("facets", getRequestXML(req));
    System.gc();
    res.sendPage("xml2/relasjoner_alle", bizData);
  }
}

