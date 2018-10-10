<%@page import="java.util.Iterator"%>
<%@page import="com.lymava.nosql.util.PageSplit"%>
<%@page import="com.lymava.base.model.BalanceLog"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ include file="../header/check_openid.jsp"%>
<%@ include file="../header/header_check_login.jsp"%>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="utf-8">
	    <meta name="viewport" content="width=device-width,initial-scale=1,minimum-scale=1,maximum-scale=1,user-scalable=no" />
	    <title></title>
	    <link rel="stylesheet" href="${basePath }merchant_show/css/business.css" />
	    <link rel="stylesheet" type="text/css" href="${basePath }user_center/layui-v2.2.5/layui/css/layui.css"/>
	</head>
	<%
		String picFilePath = request.getParameter("file");
		request.setAttribute("picFilePath",picFilePath);

	%>
	<body>
		 <%--<img alt="" src="logo/901820413.jpg" >--%>
		 <img src="${basePath }${picFilePath}" style="width: 100%;"/>
	</body>
</html>
