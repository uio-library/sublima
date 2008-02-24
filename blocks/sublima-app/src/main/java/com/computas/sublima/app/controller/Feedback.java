package com.computas.sublima.app.controller;

import org.apache.cocoon.components.flow.apples.AppleRequest;
import org.apache.cocoon.components.flow.apples.AppleResponse;
import org.apache.cocoon.components.flow.apples.StatelessAppleController;
import org.apache.log4j.Logger;
import com.computas.sublima.query.service.DatabaseService;
import com.hp.hpl.jena.db.IDBConnection;

import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.sql.Connection;

public class Feedback implements StatelessAppleController {

  private String mode;
  private static Logger logger = Logger.getLogger(Feedback.class);

  @SuppressWarnings("unchecked")
  public void process(AppleRequest req, AppleResponse res) throws Exception {

    this.mode = req.getSitemapParameter("mode");

    if("visTipsForm".equalsIgnoreCase("mode")) {
      res.sendPage("xhtml/tips-form", null);
	  return;  
    }

    if("sendtips".equalsIgnoreCase(mode)) {
        String navn = req.getCocoonRequest().getParameter("navn");
        String email = req.getCocoonRequest().getParameter("epost");
        String url = req.getCocoonRequest().getParameter("url");
        String beskrivelse = req.getCocoonRequest().getParameter("beskrivelse");

        DatabaseService myDbService = new DatabaseService();
        Connection connection = myDbService.getJavaSQLConnection();

        try {
            // Prepare a statement to insert a record
            String sql = "INSERT INTO feedback (type, name, email, url, description, ip) VALUES(?,?,?,?,?,?)";
            PreparedStatement pstmt = connection.prepareStatement(sql);

            pstmt.setString(1, "suggestion");
            pstmt.setString(2, navn);
            pstmt.setString(3, email);
            pstmt.setString(4, url);
            pstmt.setString(5, beskrivelse);
            pstmt.setString(6, req.getCocoonRequest().getRemoteAddr());
            // Insert the row
            pstmt.executeUpdate();

            res.sendPage("takk", null);
            return;
        }
        catch (SQLException e) {
            e.printStackTrace(); 
        }
    }

    return;
  }

}
