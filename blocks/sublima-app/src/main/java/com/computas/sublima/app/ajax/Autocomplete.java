package com.computas.sublima.app.ajax;

import com.computas.sublima.app.service.AdminService;

import javax.servlet.ServletConfig;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;

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

    String action = request.getParameter("action");
    String partialname = request.getParameter("q");
    String language = request.getParameter("language");
    if (partialname != null) partialname = partialname.trim().toLowerCase();

    ArrayList<String> results = new ArrayList<String>();

    if ("topic".equals(action)) {
      results = adminService.getTopicsByPartialName(partialname, language);
    } else if ("topicvalue".equals(action)) {
      results = adminService.getTopicsByPartialName(partialname, language);
    } else if ("publisher".equals(action)) {
      results = adminService.getPublishersByPartialName(partialname);    
    }

    if (!results.isEmpty()) {

      StringBuilder res = new StringBuilder();

      for(String s : results) {
        res.append(s + "\n");
      }
      results.clear();
      
      response.setCharacterEncoding("UTF-8");
      response.getWriter().write(res.toString());
    } else {
      //nothing to show
      response.setStatus(HttpServletResponse.SC_NO_CONTENT);
    }
  }
}



