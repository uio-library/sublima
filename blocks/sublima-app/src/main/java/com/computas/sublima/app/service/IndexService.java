package com.computas.sublima.app.service;

import com.computas.sublima.query.impl.DefaultSparulDispatcher;
import com.computas.sublima.query.service.SearchService;
import com.computas.sublima.query.service.SettingsService;
import com.hp.hpl.jena.query.*;
import com.hp.hpl.jena.query.larq.LARQ;
import com.hp.hpl.jena.rdf.model.*;
import com.hp.hpl.jena.shared.DoesNotExistException;
import com.hp.hpl.jena.shared.JenaException;
import com.hp.hpl.jena.sparql.util.StringUtils;
import org.apache.log4j.Logger;
import org.postgresql.util.PSQLException;

import java.io.File;
import java.io.UnsupportedEncodingException;
import java.net.URL;
import java.util.*;

/**
 * A class to support Lucene/LARQ indexing in the web app
 * Has methods for creating and accessing indexes
 *
 * @author: mha
 * Date: 13.mar.2008
 */
public class IndexService {

  private static Logger logger = Logger.getLogger(IndexService.class);
  private DefaultSparulDispatcher sparulDispatcher = new DefaultSparulDispatcher();
  private SearchService searchService = new SearchService();

  /**
   * Method to create an index based on the internal content
   * <p/>
   * Change Note 2008-09-05 (dn): Now creating an index based on generated content adding to each
   * resource (i.e. IndexBuilderNode) rather than statements
   * (i.e. IndexBuilderString).
   * Change Note 2008-09-06 (dn): Also spilt
   * Change Note 2008-09-17 (mha): Added external indexing to sub:url if the property for external index is true
   */
  public void createIndex(String indexDirectory, String indexType, String[] searchfields, String[] prefixes) {
    try {

      // -- Read and index all literal strings.
      File indexDir = new File(indexDirectory);
      logger.info("SUBLIMA: createIndex() --> Indexing - Read and index all literal strings");
      if ("memory".equals(indexType)) {
        SettingsService.getIndexBuilderNode(null);
      } else {
        SettingsService.getIndexBuilderNode(indexDir);
      }

      boolean indexExternal = Boolean.valueOf(SettingsService.getProperty("sublima.index.external.onstartup"));

      // -- Create an index based on a generated string on each URL
      ResultSet rs = getAllExternalResourcesURLs();
      int i = 0;
      while (rs.hasNext()) {
        QuerySolution qs = rs.nextSolution();
        Resource res = qs.getResource("url");
        logger.info("SUBLIMA: createIndex() --> indexing resource #" + i + ":" + res.getURI());
        indexResourceInternal(res.getURI(), searchfields, prefixes);

        if(indexExternal) {
          indexResourceExternal(res.getURI(), searchfields, prefixes);
        }

        i++;
      }

      logger.info("SUBLIMA: createIndex() --> Indexing - Indexed all model resources from concatenated literals");
      logger.info("SUBLIMA: createIndex() --> Indexing - Closed index for writing");

      // -- Make globally available // -- Create the access index
      LARQ.setDefaultIndex(SettingsService.getIndexBuilderNode(indexDir).getIndex());
      logger.info("SUBLIMA: createIndex() --> Indexing - Index now globally available");
    }
    catch (DoesNotExistException e) {
      logger.info("SUBLIMA: createIndex() --> Indexing - NO CONTENT IN DATABASE. Please fill DB from Admin/Database and restart Tomcat.");
    }

    logger.info("SUBLIMA: createIndex() --> Indexing - Created RDF model from database");
  }


  public void setIndex(String indexDirectory) {
    File indexDir = new File(indexDirectory);
    LARQ.setDefaultIndex(SettingsService.getIndexBuilderNode(indexDir).getIndex());
  }


  /**
   * A method to validate all urls on the resources. Adds the URL to the list along with
   * the http code.
   *
   */
  public void validateURLs() {
    ResultSet resultSet;
    resultSet = getAllExternalResourcesURLs();

    // For each URL, do a HTTP GET and check the HTTP code
    int i = 1;
    while (resultSet.hasNext()) {
      String resultURL = resultSet.next().toString();
      String url = resultURL.substring(10, resultURL.length() - 3).trim();
      logger.info("SUBLIMA: validateURLs() --> Updating status for resource " + i + " " + url);
      URLActions urlAction = new URLActions(url);
      urlAction.getAndUpdateResourceStatus();
      i++;
    }
  }


  /**
   * Method to extract all URLs of the resources in the model
   *
   * @return ResultSet containing all resource URLS from the model
   */
  // todo Use SparqlDispatcher (needs to return ResultSet)
  private ResultSet getAllExternalResourcesURLs() {
    String queryString = StringUtils.join("\n", new String[]{
            "SELECT ?url",
            "WHERE {",
            "        ?url a <http://xmlns.computas.com/sublima#Resource> }"});

    Query query = QueryFactory.create(queryString);
    QueryExecution qExec = QueryExecutionFactory.create(query, SettingsService.getModel());
    ResultSet resultSet = qExec.execSelect();
    logger.info("SUBLIMA: getAllExternalResourcesURLs() --> Indexing - Fetched all resource URLs from the model");
    return resultSet;
  }

  public String getQueryForIndex(String[] fieldsToIndex, String[] prefixes) {
    Form2SparqlService form2SparqlService = new Form2SparqlService(prefixes);
    return getTheIndexQuery(fieldsToIndex, form2SparqlService);
  }

  public String getQueryForIndex(String[] fieldsToIndex, String[] prefixes, String resource) {
    Form2SparqlService form2SparqlService = new Form2SparqlService(prefixes);
    form2SparqlService.setResourceSubject(resource);
    return getTheIndexQuery(fieldsToIndex, form2SparqlService);
  }

  private String getTheIndexQuery(String[] fieldsToIndex, Form2SparqlService form2SparqlService) {
    StringBuffer queryBuffer = new StringBuffer();
    queryBuffer.append(form2SparqlService.getPrefixString());
    queryBuffer.append("SELECT");
    if (form2SparqlService.getResourceSubject().equals("?resource")) {
      queryBuffer.append(" ?resource");
    }
    for (int i = 1; i <= fieldsToIndex.length; i++) {
      queryBuffer.append(" ?object");
      queryBuffer.append(i);
    }
    queryBuffer.append(" WHERE {");
    ArrayList nullValues = new ArrayList<String>();
    for (String field : fieldsToIndex) {
      nullValues.add(null);
      queryBuffer.append("\nOPTIONAL {");
      queryBuffer.append(form2SparqlService.convertFormField2N3(field,
              (String[]) nullValues.toArray(new String[nullValues.size()]) // Don't ask me why
      ));
      queryBuffer.append("\n}");
    }
    queryBuffer.append("\n}");
    logger.info("SUBLIMA: Indexing - SPARQL query to get all literals:\n" + queryBuffer.toString());

    return queryBuffer.toString();
  }


  public String getFreetextToIndex(String[] fieldsToIndex, String[] prefixes, String resource) {
    String queryString = getQueryForIndex(fieldsToIndex, prefixes, resource);
    ResultSet resultSet = getFreetextToIndexResultSet(queryString);
    StringBuffer resultBuffer = new StringBuffer();
    Set literals = new HashSet<String>();

    while (resultSet.hasNext()) {
      QuerySolution soln = resultSet.nextSolution();
      Iterator<String> it = soln.varNames();
      while (it.hasNext()) {
        String var = it.next();
        if (soln.get(var).isLiteral()) {
          Literal l = soln.getLiteral(var);
          String literal = l.getString().replace("\\", "\\\\");
          literals.add(literal);  // This should ensure uniqueness
        } else {
          logger.warn("SUBLIMA: Indexing - variable " + var + " contained no literal. Verify that sublima.searchfields config is correct.");
        }
      }
    }
    resultBuffer.append(resource);
    resultBuffer.append(" sub:literals \"\"\"");
    resultBuffer.append(literals.toString());
    resultBuffer.append("\"\"\" .\n");

    return resultBuffer.toString();
  }


  public ArrayList<String> getFreetextToIndex(String[] fieldsToIndex, String[] prefixes, boolean indexExternalContent) {
    String queryString = getQueryForIndex(fieldsToIndex, prefixes);
    ResultSet resultSet = getFreetextToIndexResultSet(queryString);
    ArrayList<String> list = new ArrayList<String>();

    Set<String> literals = new HashSet<String>();

    String resource = null;
    int i = 0;
    while (resultSet.hasNext()) { // && i < 50) {
      QuerySolution soln = resultSet.nextSolution();
      Iterator<String> it = soln.varNames();

      while (it.hasNext()) {
        StringBuffer resultBuffer = new StringBuffer();
        String var = it.next();

        if (soln.get(var) != null) {
          if (soln.get(var).isResource()) {
            Resource r = soln.getResource(var);
            if (!r.getURI().equals(resource)) { // So, we have a new Resource and we get the external content if the checkurl.onstartup parameter is true

              // Add the old one to the output buffer
              resultBuffer.append("<" + resource);
              resultBuffer.append("> sub:literals \"\"\"empty");

              //resultBuffer.append("> sub:literals :_a .\n");

              for (String s : literals) {
                resultBuffer.append(s.trim() + ". ");
              }

              resultBuffer.append("\"\"\" .\n");
              logger.trace("SUBLIMA: getFreetextToIndex --> Added \"empty\" as sub:literal for " + resource);

              list.add(resultBuffer.toString());
              if (indexExternalContent && (resource != null)) {
                indexResourceExternalLiterals(resource, fieldsToIndex, prefixes);
                //list.add(getResourceExternalLiteralsAsTriple(resource, fieldsToIndex, prefixes));
              }

              // Reset to the new resource
              resource = r.getURI();
              literals.clear();
            }
          } else if (soln.get(var).isLiteral()) {
            Literal l = soln.getLiteral(var);
            String literal = l.getString().replace("\\", "\\\\");
            literals.add(literal);  // This should ensure uniqueness
            logger.trace("SUBLIMA: getFreetextToIndex --> Added " + literal + " to the resource's sub:literal");
          } else {
            logger.warn("SUBLIMA: Indexing - variable " + var + " contained neither the resource name or a literal. Verify that sublima.searchfields config is correct.");
          }

          if (!resultSet.hasNext()) {
            StringBuffer endResultBuffer = new StringBuffer();
            endResultBuffer.append("<" + resource);
            endResultBuffer.append("> sub:literals \"\"\"");
            //resultBuffer.append("> sub:literals :_a .\n");

            for (String s : literals) {
              endResultBuffer.append(s.trim() + ". ");
            }
            endResultBuffer.append("\"\"\" .\n");
            list.add(endResultBuffer.toString());
            logger.trace("SUBLIMA: getFreetextToIndex --> Added \"empty\" as sub:literal for " + resource);

            if (indexExternalContent && (resource != null)) {
              list.add(getResourceExternalLiteralsAsTriple(resource, fieldsToIndex, prefixes));
            }

          }
        }
        i++;
      }
    }
    //return resultBuffer.toString();
    resultSet = null;
    literals = null;

    return list;

  }

  private ResultSet getFreetextToIndexResultSet(String queryString) {
    Query query = QueryFactory.create(queryString);
    QueryExecution qExec = QueryExecutionFactory.create(query, SettingsService.getModel());
    ResultSet resultSet = qExec.execSelect();

    logger.info("SUBLIMA: getFreetextToIndexResultSet() --> Indexing - Fetched all literals that we need to index");
    return resultSet;
  }

  /**
   * Method to get the external content as an triple for a specific resource including the internal literals
   *
   * @param resource
   * @return a String ie. "<http://theresource.net> sub:externalliterals """ This is the resource . net external content including internal content""""
   */
  public String getResourceExternalLiteralsAsTriple(String resource, String[] searchfields, String[] prefixes) {
    StringBuffer tripleString = new StringBuffer();

    tripleString.append("<" + resource + "> sub:externalliterals \"\"\"");

    // Get the internal literals and add them to the triple
    tripleString.append(getResourceInternalLiteralsAsString(resource, searchfields, prefixes) + ".\n");

    tripleString.append(getResourceExternalLiteralsAsString(resource) + ".\n");

    tripleString.append("\"\"\" .\n");

    return tripleString.toString();
  }

  /**
   * Method to get the external content as an triple for a specific resource including the internal literals
   *
   * @param resource
   * @return a String ie. "<http://theresource.net> sub:externalliterals """ This is the resource . net external content including internal content""""
   */
  public void indexResourceExternalLiterals(String resource, String[] searchfields, String[] prefixes) {
    StringBuffer tripleString = new StringBuffer();

    tripleString.append("PREFIX sub: <http://xmlns.computas.com/sublima#>\n");
    tripleString.append("PREFIX dct: <http://purl.org/dc/terms/>\n");
    tripleString.append("DELETE { <" + resource + "> sub:externalliterals ?o . }\n");
    tripleString.append("WHERE { <" + resource + "> sub:externalliterals ?o . }\n");
    tripleString.append("INSERT DATA {\n");
    tripleString.append("<" + resource + "> sub:externalliterals \"\"\"");

    // Get the internal literals and add them to the triple
    tripleString.append(getResourceInternalLiteralsAsString(resource, searchfields, prefixes) + ".\n");

    tripleString.append(getResourceExternalLiteralsAsString(resource) + ".\n");

    tripleString.append("\"\"\" .}\n");

    boolean insertSuccess = sparulDispatcher.query(tripleString.toString());
    logger.info("SUBLIMA: indexResourceExternalLiterals() --> Insert external literals for " + resource + " resulted in: " + insertSuccess);
  }

  /**
   * Method to get the external content as an triple for a specific resource including the internal literals
   *
   * @param resource
   * @return a String ie. "<http://theresource.net> sub:externalliterals """ This is the resource . net external content including internal content""""
   */
  public String getResourceExternalLiteralsAsString(String resource) {
    StringBuffer externalContent = new StringBuffer();

    URLActions urlAction = new URLActions(resource);
    String code = urlAction.getCode();

    if ("302".equals(code) ||
            "303".equals(code) ||
            "304".equals(code) ||
            "305".equals(code) ||
            "307".equals(code) ||
            code.startsWith("2")) {
      try {

        HashMap<String, String> headers = urlAction.getHTTPmap();
        String contentType = headers.get("httph:content-type");

        if (contentType != null && (contentType.startsWith("application/xhtml+xml") ||
                contentType.startsWith("text/html") ||
                contentType.startsWith("text/plain") ||
                contentType.startsWith("text/xml"))) {

          externalContent.append(urlAction.strippedContent(null).replace("\\", "\\\\"));

        }
      } catch (Exception e) {
        logger.warn("SUBLIMA: Indexing external content gave UnsupportedEncodingException for resource " + resource);
      }
    }
    return externalContent.toString();
  }

  /**
   * Method to get the internal content as a string for a specific resource
   *
   * @param resource
   * @return a String
   */
  public String getResourceInternalLiteralsAsString(String resource, String[] searchfields, String[] prefixes) {
    StringBuffer returnString = new StringBuffer();

    if (resource != null || "".equalsIgnoreCase(resource)) {

      if (!resource.startsWith("<")) {
        resource = "<" + resource + ">";
      }

      String queryString = getQueryForIndex(searchfields, prefixes, resource);
      ResultSet resultSet = getFreetextToIndexResultSet(queryString);

      while (resultSet.hasNext()) {
        QuerySolution soln = resultSet.nextSolution();
        Iterator<String> it = soln.varNames();
        while (it.hasNext()) {
          String var = it.next();
          if (soln.get(var) != null) {
            if (soln.get(var).isLiteral()) {
              Literal l = soln.getLiteral(var);
              String literal = l.getString().replace("\\", "\\\\");
              returnString.append(literal + ". ");
              logger.trace("SUBLIMA: getResourceInternalLiteralsAsString --> Added " + literal + " to " + resource + "'s indexed text");
            } else {
              logger.warn("SUBLIMA: Indexing - variable " + var + " contained no literal. Verify that sublima.searchfields config is correct.");
            }
          }
        }
      }
    }

    return returnString.toString();

  }

  /**
   * Method to get the internal content as a string for a specific resource
   *
   * @param resource
   * @return a String
   */
  public String getResourceInternalLiteralsAsTriple(String resource, String[] searchfields, String[] prefixes) {
    StringBuffer tripleString = new StringBuffer();

    tripleString.append("<" + resource + "> sub:literals \"\"\"");
    tripleString.append(getResourceInternalLiteralsAsString(resource, searchfields, prefixes));
    tripleString.append("\"\"\" .");

    return tripleString.toString();

  }

  /**
   * Utility method to do both the internal and external indexing of a resource with one method call
   * @param resourceString
   * @param searchfields
   * @param prefixes
   */
  public void indexResource(String resourceString, String[] searchfields, String[] prefixes) {
    indexResourceInternal(resourceString, searchfields, prefixes);
    indexResourceExternal(resourceString, searchfields, prefixes);
  }

  /**
   * Method to reindex a given resource based on alternative 2; adding the internal content to dct:identifier
   *
   * @param resourceString
   * @param searchfields
   * @param prefixes
   * @return void
   *         <p/>
   *         added 2008-09-05 (dn)
   */
  public void indexResourceInternal(String resourceString, String[] searchfields, String[] prefixes) {
    Resource r = SettingsService.getModel().getResource(resourceString);

    String s = getResourceInternalLiteralsAsString(resourceString, searchfields, prefixes);

    Property pIdentifier = SettingsService.getModel().createProperty("http://purl.org/dc/terms/identifier");

    // dct:identifier used for internal content
    NodeIterator nIdentifier = SettingsService.getModel().listObjectsOfProperty(r, pIdentifier);
    while (nIdentifier.hasNext()) {
      RDFNode node = nIdentifier.nextNode();
      if (node.isResource()) {
        SettingsService.getIndexBuilderNode(null).index(node, s);
      }
    }

    Property propTitle = SettingsService.getModel().createProperty("http://purl.org/dc/terms/title");
    Property propDescription = SettingsService.getModel().createProperty("http://purl.org/dc/terms/description");
    Property propPublisher = SettingsService.getModel().createProperty("http://purl.org/dc/terms/publisher");
    Property propFname = SettingsService.getModel().createProperty("http://xmlns.com/foaf/0.1/name");
    Property propSubject = SettingsService.getModel().createProperty("http://purl.org/dc/terms/subject");
    Property propPrefLabel = SettingsService.getModel().createProperty("http://www.w3.org/2004/02/skos/core#prefLabel");
    Property propAltLabel = SettingsService.getModel().createProperty("http://www.w3.org/2004/02/skos/core#altLabel");
    Property propHiddenLabel = SettingsService.getModel().createProperty("http://www.w3.org/2004/02/skos/core#hiddenLabel");

    // Title
    NodeIterator nTitle = SettingsService.getModel().listObjectsOfProperty(r, propTitle);
    while (nTitle.hasNext()) {
      RDFNode node = nTitle.nextNode();
      if (node.isLiteral()) {
        SettingsService.getIndexBuilderNode(null).index(node, ((Literal) node).getString());
      }
    }

    // Description
    NodeIterator nDescription = SettingsService.getModel().listObjectsOfProperty(r, propDescription);
    while (nDescription.hasNext()) {
      RDFNode node = nDescription.nextNode();
      if (node.isLiteral()) {
        SettingsService.getIndexBuilderNode(null).index(node, ((Literal) node).getString());
      }
    }

    // Publisher / Name
    NodeIterator nPublisher = SettingsService.getModel().listObjectsOfProperty(r, propPublisher);
    while (nPublisher.hasNext()) {
      RDFNode node = nPublisher.nextNode();
      if (node.isResource()) {
        NodeIterator nFnamel = SettingsService.getModel().listObjectsOfProperty(((Resource) node), propFname);
        while (nFnamel.hasNext()) {
          RDFNode rdfNode = nFnamel.nextNode();
          if (rdfNode.isLiteral()) {
            SettingsService.getIndexBuilderNode(null).index(rdfNode, ((Literal) rdfNode).getString());
          }
        }
      }
    }

    // Subject / PrefLabel | AltLabel | HiddenLabel
    NodeIterator nSubject = SettingsService.getModel().listObjectsOfProperty(r, propSubject);
    while (nSubject.hasNext()) {
      RDFNode node = nSubject.nextNode();
      if (node.isResource()) {
        NodeIterator nPrefLabel = SettingsService.getModel().listObjectsOfProperty(((Resource) node), propPrefLabel);
        NodeIterator nAltLabel = SettingsService.getModel().listObjectsOfProperty(((Resource) node), propAltLabel);
        NodeIterator nHiddenLabel = SettingsService.getModel().listObjectsOfProperty(((Resource) node), propHiddenLabel);
        while (nPrefLabel.hasNext()) { // prefLabel
          RDFNode rdfNode = nPrefLabel.nextNode();
          if (rdfNode.isLiteral()) {
            SettingsService.getIndexBuilderNode(null).index(rdfNode, ((Literal) rdfNode).getString());
          }
        }
        while (nAltLabel.hasNext()) { // altLabel
          RDFNode rdfNode = nAltLabel.nextNode();
          if (rdfNode.isLiteral()) {
            SettingsService.getIndexBuilderNode(null).index(rdfNode, ((Literal) rdfNode).getString());
          }
        }
        while (nHiddenLabel.hasNext()) { // hiddenLabel
          RDFNode rdfNode = nHiddenLabel.nextNode();
          if (rdfNode.isLiteral()) {
            SettingsService.getIndexBuilderNode(null).index(rdfNode, ((Literal) rdfNode).getString());
          }
        }
      }
    }

    SettingsService.getIndexBuilderNode(null).flushWriter();
  }

  /**
   * Method to reindex a given resource based on alternative 2; adding the external content to sub:url
   *
   * @param resourceString
   * @param searchfields
   * @param prefixes
   * @return void
   *         <p/>
   *         added 2008-09-05 (dn)
   */
  public void indexResourceExternal(String resourceString, String[] searchfields, String[] prefixes) {
    Resource r = SettingsService.getModel().getResource(resourceString);

    String internalContent = getResourceInternalLiteralsAsString(resourceString, searchfields, prefixes);
    String externalContent = getResourceExternalLiteralsAsString(resourceString);

    Property pUrl = SettingsService.getModel().createProperty("http://xmlns.computas.com/sublima#url");

    // sub:url used for external content (including internal content)
    NodeIterator nUrl = SettingsService.getModel().listObjectsOfProperty(r, pUrl);
    while (nUrl.hasNext()) {
      RDFNode node = nUrl.nextNode();
      if (node.isResource()) {
        SettingsService.getIndexBuilderNode(null).index(node, internalContent + ". " + externalContent);
      }
    }

    SettingsService.getIndexBuilderNode(null).flushWriter();
  }
}