<%@page import="java.util.Enumeration"%>
<%@page import="com.lymava.commons.util.MathUtil"%>
<%@page import="com.lymava.trade.business.model.Product"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
	Enumeration<String> getHeaderNames = request.getHeaderNames();

	while(getHeaderNames.hasMoreElements()){
		
		String nextElement_name = getHeaderNames.nextElement();
		
		Enumeration<String> getHeaders =  request.getHeaders(nextElement_name);
		
		out.println(nextElement_name+":");
		
		while(getHeaders.hasMoreElements()){
			String nextElement_value = getHeaders.nextElement();
			out.println(nextElement_value+" ");
		}
		out.println("<br/>\n");
	}
%>