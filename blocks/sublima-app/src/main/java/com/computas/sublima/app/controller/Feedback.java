package com.computas.sublima.app.controller;

import com.computas.sublima.query.SparqlDispatcher;
import com.computas.sublima.query.SparulDispatcher;
import com.computas.sublima.query.service.IndexService;
import com.hp.hpl.jena.sparql.util.StringUtils;
import org.apache.cocoon.components.flow.apples.AppleRequest;
import org.apache.cocoon.components.flow.apples.AppleResponse;
import org.apache.cocoon.components.flow.apples.StatelessAppleController;
import org.apache.log4j.Logger;

public class Feedback implements StatelessAppleController {

  private static Logger logger = Logger.getLogger(Feedback.class);
  private String mode;
  private SparulDispatcher sparulDispatcher;
  boolean success = false;

  //todo Check how to send error messages with Cocoon (like Struts 2's s:actionmessage)
  @SuppressWarnings("unchecked")
  public void process(AppleRequest req, AppleResponse res) throws Exception {

    this.mode = req.getSitemapParameter("mode");

    if ("visTipsForm".equalsIgnoreCase("mode")) {
      res.sendPage("xhtml/tips", null);
      return;
    }

    if ("sendtips".equalsIgnoreCase(mode)) {
      String url = req.getCocoonRequest().getParameter("url");
      String tittel = req.getCocoonRequest().getParameter("tittel");
      String beskrivelse = req.getCocoonRequest().getParameter("beskrivelse");
      String[] stikkord = req.getCocoonRequest().getParameter("stikkord").split(","); 

      // Do a URL check so that we know we have a valid URL
      IndexService indexService = new IndexService();
      int status = indexService.getHTTPcodeForUrl(url);

      //todo We have to get the interface-language @no from somewhere
      if (status == 200) {
        String partialUpdateString =
                "PREFIX dct: <http://purl.org/dc/terms/>\n" +
                "PREFIX wdr: <http://www.w3.org/2007/05/powder#>\n" +
                "PREFIX sub: <http://xmlns.computas.com/sublima#>\n" +
                "INSERT\n" +
                "{\n" +
                "<" + url + ">" + " dct:title " + "\"" + tittel + "\"@no ; \n" +
                "dct:description " + "\"" + beskrivelse + "\"@no ; \n" +
                "wdr:describedBy <http://sublima.computas.com/status/til_godkjenning> ;\n";
        
        StringBuffer partialUpdateStringBuffer = new StringBuffer();

        partialUpdateStringBuffer.append(partialUpdateString);
        //for each keyword, add a sub:keyword
        for(String s : stikkord) {
          partialUpdateStringBuffer.append("sub:keyword \"" + s + "\"@no ;\n");
        }
        partialUpdateStringBuffer.append("}");

        success = sparulDispatcher.query(partialUpdateStringBuffer.toString());

        if (success) {
          res.sendPage("takk", null);
          return;
        } else {
          res.sendPage("xhtml/tips", null);
          return;
        }

      } else {
        res.sendPage("xhtml/tips", null);
        return;
      }
    }

    return;
  }

  public void setSparulDispatcher(SparulDispatcher sparulDispatcher) {
    this.sparulDispatcher = sparulDispatcher;
  }

}
