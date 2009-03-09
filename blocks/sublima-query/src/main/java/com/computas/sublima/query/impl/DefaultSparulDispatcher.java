package com.computas.sublima.query.impl;

import com.computas.sublima.query.SparulDispatcher;
import com.computas.sublima.query.service.SettingsService;
import com.computas.sublima.query.service.CachingService;
import com.hp.hpl.jena.query.larq.ARQLuceneException;
import com.hp.hpl.jena.query.larq.LARQ;
import com.hp.hpl.jena.sparql.ARQNotImplemented;
import com.hp.hpl.jena.update.*;
import org.apache.cocoon.configuration.Settings;
import org.apache.log4j.Logger;
import org.apache.commons.httpclient.methods.PostMethod;
import org.apache.commons.httpclient.HttpClient;
import org.apache.commons.httpclient.Credentials;
import org.apache.commons.httpclient.UsernamePasswordCredentials;
import org.apache.commons.httpclient.auth.AuthPolicy;
import org.apache.commons.httpclient.auth.AuthScope;
import net.spy.memcached.MemcachedClient;

import java.net.URL;
import java.util.List;
import java.util.ArrayList;
import java.io.BufferedReader;
import java.io.InputStreamReader;

/**
 * This component queries RDF triple stores using Sparul. It is threadsafe.
 */
public class DefaultSparulDispatcher implements SparulDispatcher {

  private static Logger logger = Logger.getLogger(DefaultSparulDispatcher.class);

    /**
     * Connects and authenticates with the SPARUL endpoint and sends the SPARUL with HTTP POST.
     *
     * @param query SPARQL/Update
     * @return success true/false
     */
    public boolean query(String query) {

      boolean success = false;
      PostMethod postMethod = null;

      //todo Put this in JNDI or what?
      final String username = SettingsService.getProperty("virtuoso.digest.username");
      final String password = SettingsService.getProperty("virtuoso.digest.password");
      final String realm = SettingsService.getProperty("virtuoso.digest.realm");

      String url = SettingsService.getProperty("sublima.sparul.endpoint");
      logger.info("SPARQLdispatcher executing.\n" + query + "\n");

      try {

        URL u = new URL(url);

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

        int result = httpClient.executeMethod(postMethod);

        if (result != 200) {
          logger.error("SPARULDispatcher: Error when trying to SPARUL.\n Query:\n" + query + "\n" + result + postMethod.getStatusText());
          System.out.println(postMethod.getResponseBodyAsString());
        } else { // Read the server response and return false if the response contains the word "error". Kinda shaky, but but... ;)
          success = true;
          BufferedReader input = new BufferedReader(new InputStreamReader(postMethod.getResponseBodyAsStream()));
          String str;
          while (null != ((str = input.readLine()))) {
            if (str.contains("error")) {
              success = false;
            }
          }
          input.close();
          CachingService cache = new CachingService();
          MemcachedClient memcached = cache.connect();
          cache.modelChanged(memcached);
          cache.close(memcached);
        }

      } catch (Exception e) {
        logger.error("SPARULDispatcher: Error when trying to SPARUL.\n Query:\n" + query + "\n" + postMethod.getStatusText());
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
