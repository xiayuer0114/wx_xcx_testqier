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
	String leixing = request.getParameter("leixing");
	String real_name = request.getParameter("real_name");
	
	String openid_gaosan = (String)request.getAttribute("openid");
	if(openid_gaosan == null){
		openid_gaosan = (String)session.getAttribute("openid");
	}
		 
	PubConlumn gaosan_pubConlumn = null;
	
	if(MyUtil.isValid(leixing)){
		gaosan_pubConlumn = PubConlumn.getFinalPubConlumn(leixing);
	}
	
	if(gaosan_pubConlumn == null || MyUtil.isEmpty(real_name) || MyUtil.isEmpty(openid_gaosan)){
		response.sendRedirect(MyUtil.getBasePath(request)+"gaosan/index.jsp");
		return;
	}
	
	SerializContext serializContext_tmp = ContextUtil.getSerializContext();
	
	GaosanResult gaosanResult_find = new GaosanResult();
	gaosanResult_find.setOpenid(openid_gaosan);
	
	GaosanResult gaosanResult = (GaosanResult)serializContext_tmp.get(gaosanResult_find);

	if(gaosanResult == null){
		gaosanResult = new GaosanResult();
	}
	
	Pub pub_link = gaosanResult.getPub_link();
	
	List<Pub> pub_list = PubConlumn.getListPubs(leixing);
	
	if(pub_list == null || pub_list.size() <= 0){
		return;
	}
		
	Random random = new Random();
	int nextInt = random.nextInt(pub_list.size());
		
	pub_link = pub_list.get(nextInt);
	
	gaosanResult.setPub_link(pub_link);
	gaosanResult.setName(real_name);
	gaosanResult.setOpenid(openid_gaosan);
	gaosanResult.setPubConlumnId(leixing);
	gaosanResult.setState(State.STATE_WAITE_PROCESS);
	gaosanResult.setMedia_id(null);
	
	serializContext_tmp.save(gaosanResult);
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
			<img style="width: 100%;" alt="" src="${basePath }gaosan/img/erweima.jpg">	 
		</div>
	</body>
</html>
