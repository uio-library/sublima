package com.computas.sublima.app.controller;

import org.apache.cocoon.components.flow.apples.StatelessAppleController;
import org.apache.cocoon.components.flow.apples.AppleRequest;
import org.apache.cocoon.components.flow.apples.AppleResponse;
import static com.computas.sublima.query.service.SettingsService.getProperty;


/**
 * This will just redirect using a 303 to a DESCRIBE of the URI
 * User: kkj
 * Date: Oct 17, 2008
 * Time: 2:11:13 PM
 */
public class RedirectController implements StatelessAppleController {

     public void process(AppleRequest req, AppleResponse res) throws Exception {
         String uri = getProperty("sublima.base.url") + "sparql?query=" +
                 "DESCRIBE <" + req.getCocoonRequest().getRequestURI() + ">";
         
     }

}
