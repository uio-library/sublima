ackage com.computas.sublima.app.controller;

import org.apache.avalon.framework.parameters.Parameters;
import org.apache.cocoon.acting.AbstractAction;
import java.util.Map;
import java.util.HashMap;
import org.apache.cocoon.environment.ObjectModelHelper;
import org.apache.cocoon.environment.Redirector;
import org.apache.cocoon.environment.Request;
import org.apache.cocoon.environment.SourceResolver;
import org.xml.sax.EntityResolver;

public class HelloWorldAction extends AbstractAction {
  Request request = ObjectModelHelper.getRequest(objectModel);

  public Map act (Redirector redirector, 
                  SourceResolver resolver, 
                  Map objectModel, 
                  String source, 
                  Parameters params) {
    Map sitemapParams = new HashMap();
    sitemapParams.put("world", "hello");

  Request request = ObjectModelHelper.getRequest(objectModel);

    request.setAttribute("hello", "world");

    return sitemapParams;
  }
    
  private String globalLanguage () { 
      
  }

}
