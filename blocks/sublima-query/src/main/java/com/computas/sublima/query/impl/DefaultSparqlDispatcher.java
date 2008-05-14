package com.computas.sublima.query.impl;

import com.computas.sublima.query.SparqlDispatcher;
import com.computas.sublima.query.service.SettingsService;
import org.apache.commons.io.IOUtils;

import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;


/**
 * This component queries RDF triple stores using Sparql. It is threadsafe.
 */
public class DefaultSparqlDispatcher implements SparqlDispatcher {

    /**
     * This method takes all SPARQL requests and identifies the corrent receiver.
     *
     * @param query
     * @return Object - based on what method it forwards to. Must be cased in cases
     *         where the returning object is not derived from java.lang.Object
     */
    public Object query(String query) {

        String result = null;
        HttpURLConnection con = null;
        try {
            String url = SettingsService.getProperty("sublima.joseki.endpoint");

            URL u = new URL(url + "?query=" + URLEncoder.encode(query, "UTF-8"));

            con = (HttpURLConnection) u.openConnection();
            result = IOUtils.toString(con.getInputStream());
        } catch (Exception e) {
            con.disconnect();
            e.printStackTrace();
        }
        con.disconnect();
        return result;
    }


}
