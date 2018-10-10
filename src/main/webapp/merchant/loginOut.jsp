 <%@page import="com.lymava.base.util.FinalVariable"%>
<%@page import="com.lymava.commons.util.MyUtil"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%><%
	String basePath_ = MyUtil.getBasePath(request);
	request.setAttribute("basePath",basePath_);
	request.getSession().removeAttribute(FinalVariable.SESSION_FRONT_USER);
	request.getSession().removeAttribute(FinalVariable.SESSION_FRONT_FULL_USER);
	request.getSession().setMaxInactiveInterval(-1);
%><html>
 <head>
 </head>  
 <body style="background-color:#D3E0F2" onload="document.forms['loginOutForm'].submit()" >
 <form action="${basePath }merchant/login.jsp" name="loginOutForm" id="loginOutForm">
 </form>
 </body>  