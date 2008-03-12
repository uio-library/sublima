package com.computas.sublima.query.impl;

import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;

import org.apache.cocoon.configuration.Settings;
import org.apache.commons.io.IOUtils;

import com.computas.sublima.query.SparqlDispatcher;

/**
 * This component queries RDF triple stores using Sparql. It is threadsafe.
 */
public class DefaultSparqlDispatcher implements SparqlDispatcher {

	private Settings cocoonSettings;

	public Object query(String query) {
		String result = null;
		try {
			String url = cocoonSettings
					.getProperty("sublima.joseki.endpoint");

			// query = "DESCRIBE <http://the-jet.com/>";
			
			
			
			URL u = new URL(url + "?query=" + URLEncoder.encode(query, "UTF-8"));

			HttpURLConnection con = (HttpURLConnection) u.openConnection();

			result = IOUtils.toString(con.getInputStream());
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}

	public void setCocoonSettings(Settings cocoonSettings) {
		this.cocoonSettings = cocoonSettings;
	}

}
