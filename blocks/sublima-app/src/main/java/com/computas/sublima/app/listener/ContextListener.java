package com.computas.sublima.app.listener;

import com.computas.sublima.query.service.DatabaseService;
import com.hp.hpl.jena.db.IDBConnection;
import com.hp.hpl.jena.db.ModelRDB;
import com.hp.hpl.jena.query.larq.IndexBuilderString;
import com.hp.hpl.jena.query.larq.IndexLARQ;
import com.hp.hpl.jena.query.larq.LARQ;

import javax.servlet.ServletContextListener;
import javax.servlet.ServletContextEvent;

/**
 * @author: mha
 * Date: 28.feb.2008
 */
public final class ContextListener implements ServletContextListener {

  public void contextInitialized(ServletContextEvent servletContextEvent) {
    DatabaseService myDbService = new DatabaseService();
    IDBConnection connection = myDbService.getConnection();

    // -- Read and index all literal strings.
    IndexBuilderString larqBuilder = new IndexBuilderString();

    //IndexBuilderSubject larqBuilder = new IndexBuilderSubject();

    //Create a model based on the one in the DB
    ModelRDB model = ModelRDB.open(connection);

    // -- Create an index based on existing statements
    larqBuilder.indexStatements(model.listStatements());
    // -- Finish indexing
    larqBuilder.closeForWriting();
    // -- Create the access index
    IndexLARQ index = larqBuilder.getIndex();
    System.out.println("LARQ ----------- CREATE INDEX");

    // -- Make globally available
    LARQ.setDefaultIndex(index);
  }

  public void contextDestroyed(ServletContextEvent servletContextEvent) {

  }
}
