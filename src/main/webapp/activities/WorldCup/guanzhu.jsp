<%@page import="java.util.HashMap"%>
<%@page import="java.util.Map"%>
<%@page import="com.mongodb.BasicDBObject"%>
<%@page import="com.mongodb.BasicDBList"%>
<%@page import="com.lymava.qier.activities.model.WorldCupForecast"%>
<%@page import="java.util.Iterator"%>
<%@page import="com.lymava.nosql.util.PageSplit"%>
<%@page import="com.lymava.base.model.BalanceLog"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ include file="../../header/check_openid.jsp"%>
<%@ include file="../../header/header_check_login.jsp"%>
<!DOCTYPE html>
<html style="font-size: 18px;">
<head> 
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width,initial-scale=1,maximum-scale=1,minimum-scale=1,user-scalable=no">
<meta name="format-detection" content="telephone=no">
<meta http-equiv="X-UA-Compatible" content="ie=edge">
<title>2018世界杯冠军之路</title>
<style>
* {
	margin: 0;
	padding: 0;
}
</style>
</head>
<body>
	<div id="main">
		 <img alt="" src="${basePath }activities/WorldCup/images/erweima.jpg" style="width: 100%;">
	</div>
</body>
</html>