package com.computas.sublima.app.controller.form;

import org.apache.avalon.framework.service.ServiceException;
import org.apache.avalon.framework.service.ServiceManager;
import org.apache.avalon.framework.service.Serviceable;
import org.apache.cocoon.components.flow.apples.AppleRequest;
import org.apache.cocoon.components.flow.apples.AppleResponse;
import org.apache.cocoon.components.flow.apples.StatelessAppleController;
import org.apache.cocoon.environment.Request;
import org.apache.cocoon.forms.FormContext;
import org.apache.cocoon.forms.binding.Binding;
import org.apache.cocoon.forms.formmodel.Form;

import java.net.URLEncoder;
import java.util.HashMap;
import java.util.Map;

import com.computas.sublima.query.service.AdminService;

/**
 * @author: mha
 * Date: 11.apr.2008
 */
public class ResourceFormController implements StatelessAppleController, Serviceable {
  private ServiceManager serviceManager;
  private boolean init = false;
  private Form form;
  private Binding binding;

  //todo Get locale from user settings
  //private Locale locale = Locale.US;

  public void process(AppleRequest appleRequest, AppleResponse appleResponse) throws Exception {
    if (!init) {
      form = FormHelper.createForm(serviceManager,
              "forms/resource_registration_definition.xml");
      binding = FormHelper.createBinding(serviceManager, "binding/resource_registration_binding.xml");
      init = true;

    }

    Request request = appleRequest.getCocoonRequest();
    if (request.getMethod().equals("GET")) {
      //showForm(appleResponse);
    } else if (request.getMethod().equals("POST")) {
      boolean finished = form.process(new FormContext(request /*, locale*/));
      if (!finished) {
        showForm(appleResponse);
      } else {
        String name = (String) form.getChild("name").getValue();
        appleResponse.redirectTo("http://google.com/search?q="
                + URLEncoder.encode(name, "UTF-8"));
      }
    } else {
      throw new Exception("Unexpected HTTP method: " + request.getMethod());
    }
  }

  private void showForm(AppleResponse appleResponse /*, Locale locale */) {
    AdminService adminService = new AdminService();
    Map viewData = new HashMap();
    viewData.put("CocoonFormsInstance", form);
    viewData.put("Languages", adminService.getAllAudiences());
    //viewData.put("locale", locale);
    appleResponse.sendPage("resourceform", viewData);
  }


  /**
   * private getStaticData() {
   * <p/>
   * }
   */

  public void service(ServiceManager serviceManager) throws ServiceException {
    this.serviceManager = serviceManager;
  }
}
