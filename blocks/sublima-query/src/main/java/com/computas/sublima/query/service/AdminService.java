package com.computas.sublima.query.service;

import com.computas.sublima.query.SparqlDispatcher;
import com.computas.sublima.query.SparulDispatcher;
import com.computas.sublima.query.impl.DefaultSparqlDispatcher;
import com.computas.sublima.query.impl.DefaultSparulDispatcher;
import com.hp.hpl.jena.sparql.util.StringUtils;
import org.apache.log4j.Logger;

/**
 * A class to support the administration of Sublima
 * Has methods for getting topics, statuses, languages, media types, audience etc.
 *
 * @author: mha
 * Date: 13.mar.2008
 */
//todo Use selected interface language for all labels
public class AdminService {

  private static Logger logger = Logger.getLogger(AdminService.class);
  private SparqlDispatcher sparqlDispatcher = new DefaultSparqlDispatcher();
  private SparulDispatcher sparulDispatcher = new DefaultSparulDispatcher();

  /**
   * Method to get all publishers
   *
   * @return A String RDF/XML containing all the publishers
   */
  public String getAllPublishers() {

    String queryString = StringUtils.join("\n", new String[]{
            "PREFIX dct: <http://purl.org/dc/terms/>",
            "PREFIX foaf: <http://xmlns.com/foaf/0.1/>",
            "PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>",
            "CONSTRUCT {",
            "    ?publisher a foaf:Agent ;",
            "    foaf:name ?name .",
            "}",
            "WHERE {",
            "?publisher a foaf:Agent ;",
            "foaf:name ?name .",
            "FILTER langMatches( lang(?name), \"no\" )",
            "}"});

    logger.trace("AdminService.getAllPublishers() --> SPARQL query sent to dispatcher: \n" + queryString);
    Object queryResult = sparqlDispatcher.query(queryString);

    return queryResult.toString();
  }

  /**
   * Method to get all topics
   *
   * @return A String RDF/XML containing all the topics
   */
  public String getAllTopics() {

    String queryString = StringUtils.join("\n", new String[]{
            "PREFIX skos: <http://www.w3.org/2004/02/skos/core#>",
            "PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>",
            "CONSTRUCT {",
            "    ?topic a skos:Concept ;",
            "        rdfs:label ?label .",
            "}",
            "WHERE {",
            "    ?topic a skos:Concept ;",
            "        rdfs:label ?label .",
            "FILTER langMatches( lang(?label), \"no\" )",
            "}"});

    logger.trace("AdminService.getAllTopics() --> SPARQL query sent to dispatcher: \n" + queryString);
    Object queryResult = sparqlDispatcher.query(queryString);

    return queryResult.toString();
  }

  /**
   * Method to get all statuses
   *
   * @return A String RDF/XML containing all the statuses
   */
  public String getAllStatuses() {
    String queryString = StringUtils.join("\n", new String[]{
            "PREFIX wdr: <http://www.w3.org/2007/05/powder#>",
            "PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>",
            "CONSTRUCT {",
            "    ?status a wdr:DR ;",
            "    rdfs:label ?label .",
            "}",
            "WHERE {",
            "    ?status a wdr:DR ;",
            "    rdfs:label ?label .",
            "    FILTER langMatches( lang(?label), \"no\" )",
            "}"});


    logger.trace("AdminService.getAllStatuses() --> SPARQL query sent to dispatcher: \n" + queryString);
    Object queryResult = sparqlDispatcher.query(queryString);

    return queryResult.toString();
  }

  /**
   * Method to get all languages
   *
   * @return A String RDF/XML containing all the languages
   */
  public String getAllLanguages() {
    String queryString = StringUtils.join("\n", new String[]{
            "PREFIX lingvoj: <http://www.lingvoj.org/ontology#>",
            "PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>",
            "CONSTRUCT {",
            "?language a lingvoj:Lingvo ;",
            "          rdfs:label ?label .",
            "}",
            "WHERE {",
            "?language a lingvoj:Lingvo ;",
            "          rdfs:label ?label .",
            "FILTER langMatches( lang(?label), \"no\" )",
            "}"});

    logger.trace("AdminService.getAllLanguages() --> SPARQL query sent to dispatcher: \n" + queryString);
    Object queryResult = sparqlDispatcher.query(queryString);

    return queryResult.toString();
  }

  /**
   * Method to get all media types
   *
   * @return A String RDF/XML containing all the media types
   */
  public String getAllMediaTypes() {

    String queryString = StringUtils.join("\n", new String[]{
            "PREFIX dct: <http://purl.org/dc/terms/>",
            "PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>",
            "CONSTRUCT {",
            "    ?mediatype a dct:MediaType ;",
            "             rdfs:label ?label .",
            "}",
            "WHERE {",
            "    ?mediatype a dct:MediaType ;",
            "             rdfs:label ?label .",
            "    FILTER langMatches( lang(?label), \"no\" )",
            "}"});

    logger.trace("AdminService.getAllMediaTypes() --> SPARQL query sent to dispatcher: \n" + queryString);
    Object queryResult = sparqlDispatcher.query(queryString);

    return queryResult.toString();
  }

  /**
   * Method to get all audiences
   *
   * @return A String RDF/XML containing all the audiences
   */
  public String getAllAudiences() {

    String queryString = StringUtils.join("\n", new String[]{
            "PREFIX dct: <http://purl.org/dc/terms/>",
            "PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>",
            "CONSTRUCT {",
            "    ?audience a dct:AgentClass ;",
            "             rdfs:label ?label .",
            "}",
            "WHERE {",
            "    ?audience a dct:AgentClass ;",
            "             rdfs:label ?label .",
            "    FILTER langMatches( lang(?label), \"no\" )",
            "}"});

    logger.trace("AdminService.getAllAudiences() --> SPARQL query sent to dispatcher: \n" + queryString);
    Object queryResult = sparqlDispatcher.query(queryString);

    return queryResult.toString();
  }

  /**
   * Method to get a resource by its URI
   *
   * @return A String RDF/XML containing the resource
   */
  public Object getResourceByURI(String uri) {

    // if not < > is provided
    if (!uri.startsWith("<") && !uri.endsWith(">")) {
      uri = "<" + uri + ">";
    }

    String queryString = StringUtils.join("\n", new String[]{
            "PREFIX dct: <http://purl.org/dc/terms/>",
            "PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>",
            "DESCRIBE ?resource " + uri + " ?publisher ?subjects",
            "WHERE {",
            "        ?resource dct:language ?lang;",
            "				 dct:publisher ?publisher ;",
            "                dct:subject " + uri + ", ?subjects .}"});

    logger.trace("AdminService.getAllAudiences() --> SPARQL query sent to dispatcher: \n" + queryString);
    Object queryResult = sparqlDispatcher.query(queryString);

    return queryResult.toString();
  }

  public String insertPublisher(String publishername) {
    String publisherURI = publishername.replaceAll(" ", "_");
    //publisherURI = publisherURI.replaceAll(".", "_");
    //publisherURI = publisherURI.replaceAll(",", "_");
    //publisherURI = publisherURI.replaceAll("/", "_");
    //publisherURI = publisherURI.replaceAll("-", "_");
    //publisherURI = publisherURI.replaceAll("'", "_");
    publisherURI = "http://sublima.computas.com/agent/" + publisherURI;


    String insertPublisherByName =
            "PREFIX dct: <http://purl.org/dc/terms/>\n" +
                    "PREFIX foaf: <http://xmlns.com/foaf/0.1/>\n" +
                    "INSERT\n" +
                    "{\n" +
                    "<" + publisherURI + "> a foaf:Agent ;\n" +
                    "foaf:name \"" + publishername + "\"@en .\n" +
                    "}";

    logger.info("updatePublisherByURI() ---> " + publisherURI + " -- SPARUL INSERT  --> " + insertPublisherByName);
    boolean success = false;
    success = sparulDispatcher.query(insertPublisherByName);
    logger.info("updatePublisherByURI() ---> " + publisherURI + " -- INSERT NEW NAME --> " + success);
    if (success) {
      return publisherURI;
    }
    else {
      return "";
    }
  }
}
