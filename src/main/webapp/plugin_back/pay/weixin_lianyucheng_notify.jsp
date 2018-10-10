<%@page import="com.lymava.commons.util.HttpUtil"%>
<%@page import="java.util.Set"%>
<%@page import="java.util.Map"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%><%
	Map parameterMap = request.getParameterMap();

	
	Set<String> keySet = parameterMap.keySet();
	
	for (String string : keySet) {
		String value_tmp = HttpUtil.getParemater(parameterMap, string);
		System.out.println("client pay_success_notify_back	"+string+":"+value_tmp);
	}

	out.print(200);
%>