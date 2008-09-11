package com.computas.sublima.app.ajax;

import com.computas.sublima.app.service.AdminService;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import javax.servlet.ServletConfig;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.HashMap;

/**
 * @author: mha
 * Date: 16.jul.2008
 */
public class Autocomplete extends HttpServlet {

  private ServletContext context;
  private AdminService adminService = new AdminService();

  public void init(ServletConfig config) throws ServletException {
    this.context = config.getServletContext();
  }

  public void doGet(HttpServletRequest request, HttpServletResponse response)
          throws IOException, ServletException {

    String language = request.getParameter("locale");
    String action = request.getParameter("action");
    String partialname = request.getParameter("q");
    if (partialname != null) partialname = partialname.trim().toLowerCase();
    StringBuffer buffer = new StringBuffer();

    String result = "";
    if ("topic".equals(action)) {
      result = adminService.getTopicByPartialNameAsJSON(partialname, language);
    } else if ("publisher".equals(action)) {
      result = adminService.getPublisherByPartialNameAsJSON(partialname, language);
    }

    if (!"".equals(result)) {

      try {
        JSONObject json = new JSONObject(result);
        json = json.getJSONObject("results");
        JSONArray jsonArray = json.getJSONArray("bindings");

        for (int i = 0; i < jsonArray.length(); i++) {
          JSONObject obj2 = (JSONObject) jsonArray.get(i);
          obj2 = (JSONObject) obj2.get("label");
          buffer.append(obj2.get("value") + "|" + obj2.get("value") + "\n");
        }

      } catch (JSONException e) {
        e.printStackTrace();
      }
      if (!"".equals(buffer.toString())) {
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write(buffer.toString());
      } else {
        //nothing to show
        response.setStatus(HttpServletResponse.SC_NO_CONTENT);
      }
    }
  }
}


