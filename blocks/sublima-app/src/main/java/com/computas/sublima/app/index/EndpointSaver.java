package com.computas.sublima.app.index;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.URL;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.logging.Level;

import org.apache.commons.httpclient.Credentials;
import org.apache.commons.httpclient.HttpClient;
import org.apache.commons.httpclient.UsernamePasswordCredentials;
import org.apache.commons.httpclient.auth.AuthPolicy;
import org.apache.commons.httpclient.auth.AuthScope;
import org.apache.commons.httpclient.methods.PostMethod;

/*
  Copied FRGs code from the Inference-module
 */
public class EndpointSaver {

  public static final java.util.logging.Logger logger = java.util.logging.Logger.getLogger(EndpointSaver.class.getName());

  private String sparulEndpoint;
  private String graph;
  private String username;
  private String password;
  private String realm;
  private int bufferSize;

  private List<String> triples;

  public EndpointSaver(String sparulEndpoint, String graph, String username, String password, String realm, int bufferSize) {
    this.sparulEndpoint = sparulEndpoint;

    if (!graph.startsWith("<") && !graph.endsWith(">")) {
      this.graph = "<" + graph + ">";
    } else {
      this.graph = graph;
    }

    this.username = username;
    this.password = password;
    this.realm = realm;
    this.bufferSize = bufferSize;
    triples = new ArrayList<String>();
  }

  public String getGraph() {
    return graph;
  }

  public boolean DropGraph() {
    return ExecQuery("CLEAR GRAPH " + graph);
  }

  public boolean Flush() {
    if (triples.size()==0)
      return true;

    StringBuffer queryBuffer = new StringBuffer();
    queryBuffer.append("INSERT INTO ");
    queryBuffer.append(graph);
    queryBuffer.append(" {\n");
    for (String triple : triples) {
      queryBuffer.append(triple);
      if (!triple.endsWith("\n")) {
        queryBuffer.append("\n");
      }
    }
    triples.clear();
    queryBuffer.append("}\n");
    return ExecQuery(queryBuffer.toString());
  }

  public boolean Add(String triple) {
    triples.add(triple);
    return triples.size() < bufferSize || Flush();
  }

  public boolean ExecQuery(String query) {
    boolean success = true;
    PostMethod postMethod = null;
    try {
      URL u = new URL(sparulEndpoint);

      HttpClient httpClient = new HttpClient();
      List<String> authPrefs = new ArrayList<String>(1);
      authPrefs.add(AuthPolicy.DIGEST);
      httpClient.getParams().setParameter(AuthPolicy.AUTH_SCHEME_PRIORITY, authPrefs);

      Credentials credentials = new UsernamePasswordCredentials(username, password);

      AuthScope authScope = new AuthScope(u.getHost(), u.getPort(), realm);
      httpClient.getState().setCredentials(authScope, credentials);

      postMethod = new PostMethod(u.toExternalForm());
      postMethod.setDoAuthentication(true);
      postMethod.addParameter("query", query);

      if (logger.isLoggable(Level.INFO))
        logger.info(query);

      org.apache.log4j.Logger rootLogger = org.apache.log4j.Logger.getRootLogger();
      org.apache.log4j.Level oldLevel = rootLogger.getLevel();
      rootLogger.setLevel(org.apache.log4j.Level.WARN);
      int result = httpClient.executeMethod(postMethod);
      rootLogger.setLevel(oldLevel);

      if (result != 200) {
        logger.severe("Error when trying to SPARUL.\nQuery:\n" + query + "\n" + result + postMethod.getStatusText());
        success = false;
      } else { // Read the server response and return false if the response contains the word "error". Kinda shaky, but but... ;)
        BufferedReader input = new BufferedReader(new InputStreamReader(postMethod.getResponseBodyAsStream()));
        String str;
        while (null != ((str = input.readLine()))) {
          if (str.contains("error")) {
            success = false;
          }
        }
        input.close();
      }
    }
    catch (Exception e) {
      success = false;
      logger.severe("Exception when trying to SPARUL.\nQuery:\n" + query + "\n" + postMethod.getStatusText());
      e.printStackTrace();
    }
    finally {
      if (postMethod != null) {
        postMethod.releaseConnection();
      }
    }
    return success;
  }
}
