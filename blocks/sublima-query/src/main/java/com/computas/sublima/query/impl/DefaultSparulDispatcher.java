package com.computas.sublima.query.impl;

import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.sql.SQLException;

import org.apache.cocoon.configuration.Settings;
import org.apache.commons.io.IOUtils;

import com.computas.sublima.query.SparulDispatcher;
import com.computas.sublima.query.service.DatabaseService;
import com.hp.hpl.jena.update.*;
import com.hp.hpl.jena.db.IDBConnection;
import com.hp.hpl.jena.db.ModelRDB;

/**
 * This component queries RDF triple stores using Sparul. It is threadsafe.
 */
public class DefaultSparulDispatcher implements SparulDispatcher {

	private Settings cocoonSettings;

	public Object query(String query) {
		DatabaseService myDbService = new DatabaseService();
    IDBConnection connection = myDbService.getConnection();

    /*
    String updateQuery =  "PREFIX foaf: <http://xmlns.com/foaf/0.1/> " +
                          "INSERT { <http://sublima.computas.com/agent/ife> foaf:name \"Institute for Energy Technology\"@de }";
    */

    //Create a model based on the one in the DB
    ModelRDB model = ModelRDB.open(connection);

    //Get a GraphStore and load the graph from the Model
    GraphStore graphStore = GraphStoreFactory.create();
	  graphStore.setDefaultGraph(model.getGraph());

    try {
      //Try to execute the updateQuery (SPARQL/Update)
      UpdateRequest updateRequest = UpdateFactory.create(query);
	    updateRequest.exec(graphStore);
    }
    catch (UpdateException e) {
        return false;
    }

    try {
      connection.close();
    }
    catch (SQLException e) {
      e.printStackTrace();
    }

    // Return true if update success
    return true;
  }

	public void setCocoonSettings(Settings cocoonSettings) {
		this.cocoonSettings = cocoonSettings;
	}

}
