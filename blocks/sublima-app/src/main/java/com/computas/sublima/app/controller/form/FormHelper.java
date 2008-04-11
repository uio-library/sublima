package com.computas.sublima.app.controller.form;

import org.apache.cocoon.forms.formmodel.Form;
import org.apache.cocoon.forms.FormManager;
import org.apache.cocoon.forms.binding.Binding;
import org.apache.cocoon.forms.binding.BindingManager;
import org.apache.avalon.framework.service.ServiceManager;

/**
 * @author: mha
 * Date: 11.apr.2008
 */
public class FormHelper {
    public static Form createForm(ServiceManager serviceManager,
                                  String formDefinitionFileName) throws Exception {
        FormManager formManager = null;
        try {
            formManager = (FormManager)serviceManager.lookup(FormManager.ROLE);
            return formManager.createForm(formDefinitionFileName);
        } finally {
            if (formManager != null)
                serviceManager.release(formManager);
        }
    }

    public static Binding createBinding(ServiceManager serviceManager,
                              String bindingDefinitionFileName) throws Exception {
        BindingManager bindingManager = null;
        try {
            bindingManager = (BindingManager)serviceManager.lookup(BindingManager.ROLE);
            return bindingManager.createBinding(bindingDefinitionFileName);
        } finally {
            if (bindingManager != null)
                serviceManager.release(bindingManager);
        }
    }
}
