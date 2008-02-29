package com.computas.sublima.app.listener;

import com.computas.sublima.query.service.DatabaseService;
import com.hp.hpl.jena.db.IDBConnection;
import com.hp.hpl.jena.db.ModelRDB;
import com.hp.hpl.jena.query.larq.IndexBuilderString;
import com.hp.hpl.jena.query.larq.IndexLARQ;
import com.hp.hpl.jena.query.larq.LARQ;

import javax.servlet.ServletContextListener;
import javax.servlet.ServletContextEvent;

import org.apache.log4j.Logger;

/**
 * @author: mha
 * Date: 28.feb.2008
 */
public final class ContextListener implements ServletContextListener {

  private static Logger logger = Logger.getLogger(ContextListener.class);

  public void contextInitialized(ServletContextEvent servletContextEvent) {
    DatabaseService myDbService = new DatabaseService();
    IDBConnection connection = myDbService.getConnection();
    logger.info("INDEXING ------- Created database connection " + connection.getDatabaseType());

    // -- Read and index all literal strings.
    IndexBuilderString larqBuilder = new IndexBuilderString();
    logger.info("INDEXING ------- Read and indexed all literal strings");

    //IndexBuilderSubject larqBuilder = new IndexBuilderSubject();

    //Create a model based on the one in the DB
    ModelRDB model = ModelRDB.open(connection);
    logger.info("INDEXING ------- Created RDF model from database");

    // -- Create an index based on existing statements
    larqBuilder.indexStatements(model.listStatements());
    logger.info("INDEXING ------- Indexed all model statements");
    // -- Finish indexing
    larqBuilder.closeForWriting();
    logger.info("INDEXING ------- Closed index for writing");
    // -- Create the access index
    IndexLARQ index = larqBuilder.getIndex();

    // -- Make globally available
    LARQ.setDefaultIndex(index);
    logger.info("INDEXING ------- Index now globally available");
  }

  public void contextDestroyed(ServletContextEvent servletContextEvent) {

  }
}
