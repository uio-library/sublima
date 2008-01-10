package com.computas.sublima.servlet;

import com.hp.hpl.jena.update.*;
import com.hp.hpl.jena.db.IDBConnection;
import com.hp.hpl.jena.db.DBConnection;
import com.hp.hpl.jena.db.ModelRDB;
import com.computas.sublima.service.DatabaseService;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.ServletException;
import java.io.IOException;
import java.sql.SQLException;

/**
 * @author: mha
 * Date: 08.jan.2008
 */
public class SparqlUpdateServlet extends HttpServlet {

  public void doGet(HttpServletRequest request,
                    HttpServletResponse response)
          throws ServletException, IOException {
    doPost(request, response);
  }

  public void doPost(HttpServletRequest request,
                     HttpServletResponse response)
          throws ServletException, IOException {

    DatabaseService myDbService = new DatabaseService();
    IDBConnection connection = myDbService.getConnection();

    //The SPARQL/Update from the Form2SparqlUpdateServlet
    String updateQuery = request.getParameter("query");

    //Create a model based on the one in the DB
    ModelRDB model = ModelRDB.open(connection);

    //Get a GraphStore and load the graph from the Model
    GraphStore graphStore = GraphStoreFactory.create();
	  graphStore.setDefaultGraph(model.getGraph());

    try {
      //Try to execute the updateQuery (SPARQL/Update)
      UpdateRequest updateRequest = UpdateFactory.create(updateQuery);
	    updateRequest.exec(graphStore);
    }
    catch (UpdateException e) {
        System.out.println("error in update" + e.toString());
    }

    try {
      connection.close();
    }
    catch (SQLException e) {
      e.printStackTrace();
    }
  }
}
