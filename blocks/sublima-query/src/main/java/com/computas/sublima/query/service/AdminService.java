package com.computas.sublima.query.service;

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
public class AdminService {

  private static Logger logger = Logger.getLogger(AdminService.class);
  private DefaultSparqlDispatcher sparqlDispatcher;
  private DefaultSparulDispatcher sparulDispatcher;

  /**
   * Method to get all topics
   *
   * @return A String RDF/XML containing all the topics
   */
  public String getAllTopics() {

    String queryString = StringUtils.join("\n", new String[]{
            "PREFIX skos: <http://www.w3.org/2004/02/skos/>",
            "DESCRIBE ?topic",
            "WHERE {",
            "    ?topic a skos:Concept .",
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
            "DESCRIBE ?status",
            "WHERE {",
            "    ?status a wdr:describedBy .",
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
            "DESCRIBE ?language",
            "WHERE {",
            "    ?language a <http://www.lingvoj.org/ontology#Lingvo> .",
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
            "PREFIX skos: <http://www.w3.org/2004/02/skos/>",
            "DESCRIBE ?mediatype",
            "WHERE {",
            "    ?mediatype a <http://purl.org/dc/dcmitype/> .",
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
            "DESCRIBE ?audience",
            "WHERE {",
            "    ?mediatype a dct:AgentClass .",
            "}"});

    logger.trace("AdminService.getAllAudiences() --> SPARQL query sent to dispatcher: \n" + queryString);
    Object queryResult = sparqlDispatcher.query(queryString);

    return queryResult.toString();
  }
}
