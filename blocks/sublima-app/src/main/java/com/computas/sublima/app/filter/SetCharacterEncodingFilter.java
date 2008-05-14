package com.computas.sublima.app.filter;


import java.io.*;
import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;

public class SetCharacterEncodingFilter implements Filter
{
 private String encoding;

 public void init(FilterConfig config) throws ServletException
 {
  encoding = config.getInitParameter("requestEncoding");

  if( encoding==null ) encoding="UTF-8";
 }

 public void doFilter(ServletRequest request, ServletResponse response, FilterChain next)
 throws IOException, ServletException
 {
  request.setCharacterEncoding(encoding);
  next.doFilter(request, response);
 }

 public void destroy(){}
}