<%@page import="com.lymava.base.util.WebConfigContent"%>
<%@page import="com.lymava.commons.util.MyUtil"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<% 	request.setAttribute("basePath", MyUtil.getBasePath(request)); 	%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="utf-8" />
        <title><%=WebConfigContent.getConfig("webtitle")%></title>
		<meta name="viewport" content="width=device-width, initial-scale=1">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta content="width=device-width, initial-scale=1" name="viewport" />
        <meta content="<%=WebConfigContent.getConfig("description")%>" name="description" />
        <meta content="<%=WebConfigContent.getConfig("author")%>" name="author" />
        <%@ include file="header_style.jsp"%>
	    <!--[if lte IE 9]>
		<script src="${basePath }merchant/assets/respond.js"></script>
		<script src="${basePath }merchant/assets/html5shiv.js"></script>
		<![endif]-->
        <%@ include file="header_js.jsp"%>
</head>