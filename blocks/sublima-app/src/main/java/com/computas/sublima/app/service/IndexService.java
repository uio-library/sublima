package com.computas.sublima.app.service;

import com.computas.sublima.query.impl.DefaultSparulDispatcher;
import com.computas.sublima.query.service.SearchService;
import com.computas.sublima.query.service.SettingsService;
import com.hp.hpl.jena.query.*;
import com.hp.hpl.jena.query.larq.LARQ;
import com.hp.hpl.jena.rdf.model.Literal;
import com.hp.hpl.jena.rdf.model.Resource;
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

    list.clear();

    logger.info("SUBLIMA: updateResourceSearchfield() --> List contains " + list.size() + " new triples to index");

  }

  /**
   * Method to create an index based on the internal content
   */
  public void createIndex(String indexDirectory, String indexType) {
    try {

      // -- Read and index all literal strings.
      File indexDir = new File(indexDirectory);
      logger.info("SUBLIMA: createInternalResourcesMemoryIndex() --> Indexing - Read and index all literal strings");
      if ("memory".equals(indexType)) {
        SettingsService.getIndexBuilderString(null);
      } else {
        SettingsService.getIndexBuilderString(indexDir);
      }

      // -- Create an index based on existing statements
      SettingsService.getIndexBuilderString(indexDir).indexStatements(SettingsService.getModel().listStatements());
      SettingsService.getModel().register(SettingsService.getIndexBuilderString(indexDir));

      logger.info("SUBLIMA: createInternalResourcesMemoryIndex() --> Indexing - Indexed all model statements");
      logger.info("SUBLIMA: createInternalResourcesMemoryIndex() --> Indexing - Closed index for writing");

      // -- Make globally available // -- Create the access index
      LARQ.setDefaultIndex(SettingsService.getIndexBuilderString(indexDir).getIndex());
      logger.info("SUBLIMA: createInternalResourcesMemoryIndex() --> Indexing - Index now globally available");
    }
    catch (DoesNotExistException e) {
      logger.info("SUBLIMA: createInternalResourcesMemoryIndex() --> Indexing - NO CONTENT IN DATABASE. Please fill DB from Admin/Database and restart Tomcat.");
    }

    logger.info("SUBLIMA: createInternalResourcesMemoryIndex() --> Indexing - Created RDF model from database");
  }


  /**
   * Method to extract all URLs of the resources in the model
   *
   * @return ResultSet containing all resource URLS from the model
   */
  // todo Use SparqlDispatcher (needs to return ResultSet)
  private ResultSet getAllExternalResourcesURLs() {
    String queryString = StringUtils.join("\n", new String[]{
            "PREFIX dct: <http://purl.org/dc/terms/>",
            "SELECT ?url",
            "WHERE {",
            "        ?url dct:title ?title }"});

    Query query = QueryFactory.create(queryString);
    QueryExecution qExec = QueryExecutionFactory.create(query, SettingsService.getModel());
    ResultSet resultSet = qExec.execSelect();
    logger.info("SUBLIMA: getAllExternalResourcesURLs() --> Indexing - Fetched all resource URLs from the model");
    return resultSet;
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
    while (resultSet.hasNext()) {
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
              resultBuffer.append("> sub:literals \"\"\"");
              for (String s : literals) {
                resultBuffer.append(s.trim() + ". ");
              }
              resultBuffer.append("\"\"\" .\n");

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
          } else {
            logger.warn("SUBLIMA: Indexing - variable " + var + " contained neither the resource name or a literal. Verify that sublima.searchfields config is correct.");
          }

          if (!resultSet.hasNext()) {
            StringBuffer endResultBuffer = new StringBuffer();
            endResultBuffer.append("<" + resource);
            endResultBuffer.append("> sub:literals \"\"\"");
            for (String s : literals) {
              endResultBuffer.append(s.trim() + ". ");
            }
            endResultBuffer.append("\"\"\" .\n");
            list.add(endResultBuffer.toString());

            if (indexExternalContent && (resource != null)) {
              list.add(getResourceExternalLiteralsAsTriple(resource, fieldsToIndex, prefixes));
            }

          }
        }
      }
    }
    //return resultBuffer.toString();
    return list;
  }

  private ResultSet getFreetextToIndexResultSet(String queryString) {
    Query query = QueryFactory.create(queryString);
    QueryExecution qExec = QueryExecutionFactory.create(query, SettingsService.getModel());
    ResultSet resultSet = qExec.execSelect();

    logger.info("SUBLIMA: getFreetextToIndex() --> Indexing - Fetched all literals that we need to index");
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
  public String getResourceInternalLiteralsAsString(String resource, String[] searchfields, String[] prefixes ) {
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

}