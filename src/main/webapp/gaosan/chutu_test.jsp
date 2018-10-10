<%@page import="com.lymava.qier.gaosan.GaosanImageUtil"%>
<%@page import="java.util.Random"%>
<%@page import="com.lymava.base.model.Pub"%>
<%@page import="com.lymava.qier.gaosan.model.GaosanResult"%>
<%@page import="com.lymava.base.model.PubConlumn"%>
<%@page import="com.lymava.commons.state.State"%>
<%@page import="com.lymava.nosql.util.PageSplit"%>
<%@page import="com.lymava.commons.util.HexM"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Iterator"%>
<%@page import="com.lymava.qier.model.UserVoucher"%>
<%@page import="com.lymava.commons.pay.PayFinalVariable"%>
<%@page import="com.lymava.commons.util.MathUtil"%>
<%@page import="com.lymava.trade.business.model.Product"%>
<%@ page import="com.lymava.qier.model.Merchant72" %>
<%@ page import="com.lymava.qier.model.Product72" %>
<%@ page import="java.util.LinkedList" %>
<%@ page import="com.lymava.nosql.mongodb.util.MongoCommand" %>
<%@ page import="com.lymava.qier.action.MerchantShowAction" %>
<%@ page import="com.lymava.qier.model.Voucher" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ include file="../header/check_openid.jsp"%>
<%@ include file="../header/header_check_login.jsp"%>
<%
	
	String openid = (String)request.getAttribute("openid");

	if(MyUtil.isEmpty(openid)){
		response.sendRedirect(MyUtil.getBasePath(request)+"gaosan/index.jsp");
		return;
	}
		  
	SerializContext serializContext_tmp = ContextUtil.getSerializContext();
	
	GaosanResult gaosanResult_find = new GaosanResult();
	gaosanResult_find.setOpenid(openid);
	
	GaosanResult gaosanResult = (GaosanResult)serializContext_tmp.get(gaosanResult_find);

	if(gaosanResult == null){
		response.sendRedirect(MyUtil.getBasePath(request)+"gaosan/index.jsp");
		return;
	}
	
	Pub pub_link = gaosanResult.getPub_link();
	
	//if(pub_link == null){
		List<Pub> pub_list = PubConlumn.getListPubs(gaosanResult.getPubConlumnId());
		if(pub_list == null || pub_list.size() <= 0){
			response.sendRedirect(MyUtil.getBasePath(request)+"gaosan/index.jsp");
			return;
		}
		
		Random random = new Random();
		int nextInt = random.nextInt(pub_list.size());
		
		pub_link = pub_list.get(nextInt);
		gaosanResult.setPub_link(pub_link);
		
		serializContext_tmp.save(gaosanResult);
	//}
	
	String basePath = application.getRealPath("/");
	
	//String image_path  = GaosanImageUtil.chutu(gaosanResult, basePath);
	//request.setAttribute("image_path", image_path);
%>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>如果重返高三</title>
    	<meta name="viewport" content="width=device-width, initial-scale=1.0">
    	<meta content="yes" name="apple-mobile-web-app-capable">
    	<meta content="telephone=no,email=no" name="format-detection">
    	<meta content="yes" name="apple-touch-fullscreen">
    	<meta http-equiv="X-UA-Compatible" content="ie=edge">
    	<meta content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0" name="viewport" /><!-- 屏蔽双击缩放 -->
    	<link rel="stylesheet" type="text/css" href="${basePath }gaosan/css/school.css"/>
	</head>
	<body>
		<div style="width: 100%;">
			<img style="width: 100%;" alt="" src="${basePath }${image_path }">	 
		</div>
	</body>
</html>
