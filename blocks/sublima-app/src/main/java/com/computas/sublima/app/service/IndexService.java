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
   * Method to update all resources with the concat of searchfields and external content
   *
   * @deprecated
   */

  public void updateResourceSearchfield(boolean indexExternalContent, String[] searchfields, String[] prefixes) {

    ArrayList<String> list = getFreetextToIndex(searchfields, prefixes, indexExternalContent);

    int steps = 500;
    int partsOfArray = steps;
    int j = 0;

    StringBuffer deleteString = new StringBuffer();
    deleteString.append("PREFIX sub: <http://xmlns.computas.com/sublima#>\n");
    deleteString.append("PREFIX dct: <http://purl.org/dc/terms/>\n");
    deleteString.append("DELETE { ?s sub:literals ?o . ");
    /*
    if (indexExternalContent) {
      deleteString.append("\n?s sub:externalliterals ?o. \n");
    }
    */

    deleteString.append("}\n");
    deleteString.append("WHERE { ?s sub:literals ?o .");

    /*
    if (indexExternalContent) {
      deleteString.append("\n?s sub:externalliterals ?o. \n");
    }
    */

    deleteString.append("}\n");

    boolean deleteSuccess = sparulDispatcher.query(deleteString.toString());
    logger.info("SUBLIMA: updateResourceSearchfield() --> Delete literals: " + deleteSuccess);

    for (int i = 0; i <= list.size(); i++) {
      StringBuffer insertString = new StringBuffer();
      insertString.append("PREFIX sub: <http://xmlns.computas.com/sublima#>\n");
      insertString.append("PREFIX dct: <http://purl.org/dc/terms/>\n");
      insertString.append("INSERT DATA {\n");

      while ((j < partsOfArray) && (j < list.size())) {
        insertString.append(list.get(j).toString() + "\n");
        j++;
      }

      insertString.append("}\n");

      boolean insertSuccess = sparulDispatcher.query(insertString.toString());
      logger.info("SUBLIMA: updateResourceSearchfield() --> Insert literal from index " + i + " to index " + partsOfArray + ": " + insertSuccess);

      j = partsOfArray;
      i = partsOfArray;

      if (partsOfArray > list.size() || (partsOfArray + steps) > list.size()) {
        partsOfArray = list.size();
      } else {
        partsOfArray += steps;
      }
    }

    logger.info("SUBLIMA: updateResourceSearchfield() --> List contains " + list.size() + " new triples to index");
    list = null;

  }


  /**
   * Method to create an index based on the internal content
   * <p/>
   * Change Note 2008-09-05 (dn): Now creating an index based on generated content adding to each
   * resource (i.e. IndexBuilderNode) rather than statements
   * (i.e. IndexBuilderString).
   * Change Note 2008-09-06 (dn): Also spilt
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

      // -- Create an index based on existing statements
      // SettingsService.getIndexBuilderString(indexDir).indexStatements(SettingsService.getModel().listStatements());

      // -- Create an index based on a generated string on each URL
      ResultSet rs = getAllExternalResourcesURLs();
      int i = 0;
      while (rs.hasNext()) {
        rs.getRowNumber();
        QuerySolution qs = rs.nextSolution();
        Resource res = qs.getResource("url");
        logger.info("SUBLIMA: createIndex() --> indexing resource #" + i + ":" + res.getURI());
        indexResourceAlt2(res.getURI(), searchfields, prefixes);
        i++;
      }

      //SettingsService.getModel();
      //SettingsService.getModel().register(SettingsService.getIndexBuilderString(indexDir)); // not relevant. TBD manually 


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
   * @return A map containing the URL and its HTTP Code. In case of exceptions a String
   *         representation of the exception is used.
   */
  public void validateURLs() {
    ResultSet resultSet;
    resultSet = getAllExternalResourcesURLs();
    HashMap<String, HashMap<String, String>> urlCodeMap = new HashMap<String, HashMap<String, String>>();

    // For each URL, do a HTTP GET and check the HTTP code
    URL u = null;
    HashMap<String, String> result;

    while (resultSet.hasNext()) {
      String resultURL = resultSet.next().toString();
      String url = resultURL.substring(10, resultURL.length() - 3).trim();

      URLActions urlAction = new URLActions(url);
      try {
        urlAction.updateResourceStatus();
      } catch (UnsupportedEncodingException e) {
        e.printStackTrace();
      }
      catch (PSQLException e) {
        logger.warn("SUBLIMA: validateURLs() --> Indexing - Could not index " + url
                + " due to database malfunction, probably caused by invalid characters in resource.");
        e.printStackTrace();
      }
      catch (JenaException e) {
        logger.warn("SUBLIMA: validateURLs() --> Indexing - Could not index " + url
                + " due to backend storage malfunction, probably caused by invalid characters in resource.");
        e.printStackTrace();
      }
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
    StringBuffer tripleString = new StringBuffer();

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

          tripleString.append(urlAction.strippedContent(null).replace("\\", "\\\\"));

        }
      } catch (UnsupportedEncodingException e) {
        logger.warn("SUBLIMA: Indexing external content gave UnsupportedEncodingException for resource " + resource);
      }
    }
    return tripleString.toString();
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
              logger.trace("SUBLIMA: getResourceInternalLiteralsAsString --> Added " + literal + " to " + resource + "'s sub:literal");
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
   * Method to reindex a given resource based on alternative 1; adding the internal content directly to the resource (the external content goes in a separate index)
   *
   * @param resourceString
   * @param searchfields
   * @param prefixes
   * @return void
   *         <p/>
   *         added 2008-09-05 (dn)
   */
  public void indexResourceAlt1(String resourceString, String[] searchfields, String[] prefixes) {
    Resource r = SettingsService.getModel().getResource(resourceString);

    String s = getResourceInternalLiteralsAsString(resourceString, searchfields, prefixes);

    SettingsService.getIndexBuilderNode(null).index(r, s);

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
   * Method to reindex a given resource based on alternative 2; adding the internal content to dct:identifier and the combined internal and external content to sub:url
   *
   * @param resourceString
   * @param searchfields
   * @param prefixes
   * @return void
   *         <p/>
   *         added 2008-09-05 (dn)
   */
  public void indexResourceAlt2(String resourceString, String[] searchfields, String[] prefixes) {
    Resource r = SettingsService.getModel().getResource(resourceString);

    String s = getResourceInternalLiteralsAsString(resourceString, searchfields, prefixes);

    Property pUrl = SettingsService.getModel().createProperty("http://xmlns.computas.com/sublima#url");
    Property pIdentifier = SettingsService.getModel().createProperty("http://purl.org/dc/terms/identifier");

    // dct:identifier used for internal content
    NodeIterator nIdentifier = SettingsService.getModel().listObjectsOfProperty(r, pIdentifier);
    while (nIdentifier.hasNext()) {
      RDFNode node = nIdentifier.nextNode();
      if (node.isResource()) {
        SettingsService.getIndexBuilderNode(null).index(node, s);
      }
    }

    /*
    // sub:url used for external content (including internal content)
    NodeIterator nUrl = SettingsService.getModel().listObjectsOfProperty(r, pUrl);
    while (nUrl.hasNext()) {
      RDFNode node = nUrl.nextNode();
      if (node.isResource()) {
        SettingsService.getIndexBuilderNode(null).index(node, ((Literal) node).getString());
      }
    }*/


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



}