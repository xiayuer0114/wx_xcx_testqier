<%@page import="com.lymava.qier.activities.model.NazhongRen"%>
<%@page import="java.util.Iterator"%>
<%@page import="com.lymava.nosql.util.PageSplit"%>
<%@page import="com.lymava.base.model.BalanceLog"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ include file="../../header/check_openid.jsp"%>
<%@ include file="../../header/header_check_login.jsp"%>
<%

	String dianying = request.getParameter("dianying");
	String xiyouji = request.getParameter("xiyouji");
	String nizuipa = request.getParameter("nizuipa");

	NazhongRen nazhongRen = new NazhongRen();
	
	nazhongRen.setId(new ObjectId().toString());
	nazhongRen.setOpenid(openid_header);
	nazhongRen.setDianying(dianying);
	nazhongRen.setXiyouji(xiyouji);
	nazhongRen.setNizuipa(nizuipa);
	
	serializContext.save(nazhongRen);
%>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>测测你是哪粽人</title>
	    <meta name="viewport" content="width=device-width, initial-scale=1.0">
	    <meta content="yes" name="apple-mobile-web-app-capable">
	    <meta content="telephone=no,email=no" name="format-detection">
	    <meta content="yes" name="apple-touch-fullscreen">
	    <meta http-equiv="X-UA-Compatible" content="ie=edge">
	    <meta content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0" name="viewport" /><!-- 屏蔽双击缩放 -->
		<script type="text/javascript" >var basePath = '${basePath}';</script>
		<link rel="stylesheet" type="text/css" href="${basePath }activities/duanwu/css/duanwu.css"/>
		
		<script type="text/javascript" >var basePath = '${basePath}';</script>
		 
	</head>  
	<body> 
		<div style="margin: 0;padding: 0;" class="layui-container">
			 <img alt="" src="${basePath }activities/duanwu/img/guanzhu_res.jpg" style="width: 100%;">
		</div> 
	</body>
</html>
