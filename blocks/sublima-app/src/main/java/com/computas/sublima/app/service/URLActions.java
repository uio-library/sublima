package com.computas.sublima.app.service;

import org.apache.commons.io.IOUtils;
import org.apache.log4j.Logger;

import java.net.*;
import java.io.IOException;
import java.util.HashMap;

import com.computas.sublima.query.service.SearchService;
import com.computas.sublima.query.impl.DefaultSparulDispatcher;

/**
 * A class to do various things with a URL or its contents
 * @author: kkj
 * Date: Apr 23, 2008
 * Time: 11:11:41 AM
 */
public class URLActions {
    private URL url;
    private HttpURLConnection con = null;
    private String ourcode = null; // This is the code we base our status on

    private static Logger logger = Logger.getLogger(URLActions.class);
    private DefaultSparulDispatcher sparulDispatcher;


    public URLActions (String u) {
        try {
            url = new URL(u);
        } catch (MalformedURLException e) {
            ourcode = "MALFORMED_URL";
        }
    }

    public URLActions (URL u) throws MalformedURLException {
        url = u;
    }

    public URL getUrl() {
        return url;
    }

    public HttpURLConnection getCon() {
        return con;
    }

    public void connect() {
        if (con == null) {
            try {
                con = (HttpURLConnection) url.openConnection();
            }
            catch (IOException e) {
                ourcode = "IOEXCEPTION";
            }
        }
    }

    private String readContent() {
      String result = null;

      try {
        connect();
        result = IOUtils.toString(con.getInputStream());
      }
      catch (MalformedURLException e) {
        ourcode = "MALFORMED_URL";
      }
      catch (IOException e) {
        ourcode = "IOEXCEPTION";
      }
      return result;
    }

    /**
     * Method to get only the HTTP Code, or String representation of exception
     *
     * @return ourcode
     */
    public String getCode() {
      if (ourcode != null) {
          logger.debug("getCode() has allready thrown exception ---> " + url.toString());
          return ourcode;
      }
      try {
        logger.info("getCode() ---> " + url.toString());
        connect();
        con.setConnectTimeout(6000);
        ourcode = String.valueOf(con.getResponseCode());
      }
      catch (MalformedURLException e) {
        ourcode = "MALFORMED_URL";
      }
      catch (ClassCastException e) {
        ourcode = "UNSUPPORTED_PROTOCOL";
      }
      catch (UnknownHostException e) {
        ourcode = "UNKNOWN_HOST";
      }
      catch (ConnectException e) {
        ourcode = "CONNECTION_TIMEOUT";
      }
      catch (SocketTimeoutException e) {
        ourcode = "CONNECTION_TIMEOUT";
      }
      catch (IOException e) {
        ourcode = "IOEXCEPTION";
      }

      return ourcode;
    }

    /**
     * A method to check a URL. Returns the HTTP code.
     * In cases where the connection gives an exception
     * the exception is catched and a String representation
     * of the exception is returned as the http code
     *
     * @return A HashMap<String, String> where each key is an HTTP-header, but in lowercase,
     *         and represented in an appropriate namespace. The returned HTTP code is in the
     *         http:status field. In case of exceptions a String
     *         representation of the exception is used.
     */
    public HashMap<String, String> getHTTPmap() {
      HashMap<String, String> result = new HashMap<String, String>();

      try {
        logger.info("getHTTPmap() ---> " + url.toString());
        connect();
        con.setConnectTimeout(6000);
        for (String key : con.getHeaderFields().keySet()) {
          if (key != null) {
            result.put("httph:" + key.toLowerCase(), con.getHeaderField(key));
          }

        }
        ourcode = String.valueOf(con.getResponseCode());
      }
      catch (MalformedURLException e) {
        ourcode = "MALFORMED_URL";
      }
      catch (ClassCastException e) {
        ourcode = "UNSUPPORTED_PROTOCOL";
      }
      catch (UnknownHostException e) {
        ourcode = "UNKNOWN_HOST";
      }
      catch (ConnectException e) {
        ourcode = "CONNECTION_TIMEOUT";
      }
      catch (SocketTimeoutException e) {
        ourcode = "CONNECTION_TIMEOUT";
      }
      catch (IOException e) {
        ourcode = "IOEXCEPTION";
      }
      result.put("http:status", ourcode);

      return result;
    }

    /**
     * Method that updates a resource based on the HTTP Code.
     * The resource can have one of three statuses: OK, CHECK or INACTIVE.
     * This list shows what HTTP Codes that gives what status.
     * <p/>
     * 2xx - OK
     * <p/>
     * 301 - Fetch new URL from HTTP Header, then CHECK
     * 302 - OK
     * 303 - OK
     * 304 - OK
     * 305 - OK
     * 306 - INACTIVE
     * 307 - OK
     * <p/>
     * 400 - INACTIVE
     * 401 - CHECK
     * 403 - INACTIVE
     * 404 - CHECK
     * 405 - INACTIVE
     * 406 - CHECK
     * 407 - CHECK
     * 408 - CHECK
     * 409 - CHECK
     * 410 - GONE
     * 411 to 417 - CHECK
     * <p/>
     * 5xx - CHECK
     * <p/>
     * MALFORMED_URL - INACTIVE
     * UNSUPPORTED_PROTOCOL - INACTIVE
     * UNKNOWN_HOST - CHECK
     * CONNECTION_TIMEOUT - CHECK
     * <p/>
     * Others - CHECK
     *
     */
    public void updateResourceStatus() {
      sparulDispatcher = new DefaultSparulDispatcher();
      String status = "";

      if (ourcode == null) {
        getCode();
      }

      try {
        if ("302".equals(ourcode) ||
                "303".equals(ourcode) ||
                "304".equals(ourcode) ||
                "305".equals(ourcode) ||
                "307".equals(ourcode) ||
                ourcode.startsWith("2")) {
          status = "<http://sublima.computas.com/status/OK>";

          // Update the external content of the resource
          //updateResourceExternalContent(url.toString());

        }
        // GONE
        else if ("410".equals(ourcode)) {
          status = "<http://sublima.computas.com/status/GONE>";
        }
        // INACTIVE
        else if ("306".equals(ourcode) ||
                "400".equals(ourcode) ||
                "403".equals(ourcode) ||
                "405".equals(ourcode) ||
                "MALFORMED_URL".equals(ourcode) ||
                "UNSUPPORTED_PROTOCOL".equals(ourcode)) {
          status = "<http://sublima.computas.com/status/INACTIVE>";
        }
        // CHECK
        else {
          status = "<http://sublima.computas.com/status/CHECK>";
        }

      }
      catch (NullPointerException e) {
        logger.info("NullPointerException -- updateResourceStatus() ---> " + url.toString() + ":" + ourcode);
        e.printStackTrace();
      }
      // OK

      String deleteString = "PREFIX sub: <http://xmlns.computas.com/sublima#>\n" +
              "DELETE\n" +
              "{ " +
              "<" + url.toString() + "> sub:status ?oldstatus " +
              "}\n" +
              "WHERE {\n" +
              "<" + url.toString() + "> sub:status ?oldstatus " +
              "}";

      logger.info("updateResourceStatus() ---> " + url.toString() + ":" + ourcode + " -- SPARUL DELETE  --> " + deleteString);

      boolean success = false;
      success = sparulDispatcher.query(deleteString);
      logger.info("updateResourceStatus() ---> " + url.toString() + ":" + ourcode + " -- DELETE OLD STATUS --> " + success);

      String updateString = "PREFIX sub: <http://xmlns.computas.com/sublima#>\n" +
              "INSERT\n" +
              "{ " +
              "<" + url.toString() + "> sub:status " + status + "\n" +
              "}";

      logger.info("updateResourceStatus() ---> " + url.toString() + ":" + ourcode + " -- SPARUL UPDATE  --> " + updateString);

      /*
      String updateString = StringUtils.join("\n", new String[]{
              "PREFIX sub: <http://xmlns.computas.com/sublima#>",
              "MODIFY",
              "DELETE { <" + url.toString() + "> sub:status ?oldstatus }",
              "INSERT { <" + url.toString() + "> sub:status " + status + " }",
              "WHERE  { <" + url.toString() + "> sub:status ?oldstatus }"});

      logger.info("updateResourceStatus() ---> " + url.toString() + ":" + ourcode + " -- SPARUL UPDATE  --> " + updateString);
      */

      success = false;

      success = sparulDispatcher.query(updateString);
      logger.info("updateResourceStatus() ---> " + url.toString() + ":" + ourcode + " -- INSERT NEW STATUS --> " + success);
    }

    public void updateResourceExternalContent() {
      sparulDispatcher = new DefaultSparulDispatcher();
      String resourceExternalContent = readContent();
      SearchService searchService = new SearchService();

      // Strip the content from all HTML tags
      resourceExternalContent = resourceExternalContent.replaceAll("\\<.*?>", "");

      String deleteString = "DELETE { ?response ?p ?o }" +
              " WHERE { <" + url + "> <http://www.w3.org/2007/ont/link#request> ?response . }";

      boolean success = false;
      success = sparulDispatcher.query(deleteString);
      logger.info("updateResourceExternalContent() ---> " + url + " -- DELETE OLD CONTENT --> " + success);

      String requesturl = "<" + url.toString().replace("resource", "latest-get") + ">";
      StringBuffer updateString = new StringBuffer();
      updateString.append("PREFIX link: <http://www.w3.org/2007/ont/link#>\n" +
              "PREFIX http: <http://www.w3.org/2007/ont/http#>\n" +
              "PREFIX httph: <http://www.w3.org/2007/ont/httph#>\n" +
              "PREFIX sub: <http://xmlns.computas.com/sublima#>\n" +
              "INSERT\n{\n<" + url + "> link:request " + requesturl + ".\n" +
              requesturl + " a http:ResponseMessage ; \n");
      HashMap<String, String> headers = getHTTPmap();
      for (String key : headers.keySet()) {
        updateString.append(requesturl + " \"" + searchService.escapeString(headers.get(key)) + "\" ;\n");
      }
      updateString.append(requesturl + " sub:stripped \"" + resourceExternalContent + "\" .\n}");
      logger.trace("updateResourceExternalContent() ---> INSERT: " + updateString.toString());

      success = false;

      success = sparulDispatcher.query(updateString.toString());
      logger.info("updateResourceExternalContent() ---> " + url + " -- INSERT NEW CONTENT --> " + success);
    }


}
