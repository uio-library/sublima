package com.computas.sublima.app.service;

import java.net.URL;
import java.net.MalformedURLException;
import java.net.HttpURLConnection;

/**
 * A class to do various things with a URL or its contents
 * @author: kkj
 * Date: Apr 23, 2008
 * Time: 11:11:41 AM
 */
public class URLActions {
    private URL url;
    private HttpURLConnection con;
    private String ourcode = null; // This is the code we base our status on

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

    public String getCode() {
        return ourcode;
    }

    public void setCode(String ourcode) {
        this.ourcode = ourcode;
    }

    public HttpURLConnection getCon() {
        return con;
    }

    public void setCon(HttpURLConnection con) {
        this.con = con;
    }

    

}
