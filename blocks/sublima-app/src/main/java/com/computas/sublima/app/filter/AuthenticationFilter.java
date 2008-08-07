package com.computas.sublima.app.filter;

import java.io.IOException;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletResponse;

public class AuthenticationFilter implements Filter {
	
	public static final String REQUEST_ATTR_ROLE = AuthenticationFilter.class.getName() + "/role";

	public void destroy() {
	}

	public void doFilter(ServletRequest request, ServletResponse response,
			FilterChain chain) throws IOException, ServletException {
		String role = request.getParameter("role");
		if("admin".equals(role))  {
			HttpServletResponse httpResponse = (HttpServletResponse) response;
			httpResponse.sendError(HttpServletResponse.SC_UNAUTHORIZED, "Please authenticate");
			httpResponse.setHeader("WWW-Authenticate", "Basic realm=\"My Private Data\"");
		}
		
		chain.doFilter(request, response);

	}

	public void init(FilterConfig filterConfig) throws ServletException {
	}

}
