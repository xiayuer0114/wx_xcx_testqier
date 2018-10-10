<%@page import="com.lymava.nosql.util.QuerySort"%>
<%@page import="com.lymava.commons.state.State"%>
<%@page import="com.lymava.qier.model.MerchantRedEnvelope"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Iterator"%>
<%@page import="com.lymava.nosql.util.PageSplit"%>
<%@page import="com.lymava.base.model.BalanceLog"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ include file="../header/check_openid.jsp"%>
<%@ include file="../header/header_check_login.jsp"%>
<%
	MerchantRedEnvelope merchantRedEnvelope_find = new MerchantRedEnvelope();
	
	merchantRedEnvelope_find.setState(State.STATE_OK);
	merchantRedEnvelope_find.initQuerySort("index_id", QuerySort.asc);
	merchantRedEnvelope_find.setUserId_huiyuan(user.getId());
	
	PageSplit pageSplit_red = new PageSplit();
	pageSplit_red.setPageSize(3);
	 
	List<MerchantRedEnvelope> merchantRedEnvelope_list = serializContext.findAll(merchantRedEnvelope_find, pageSplit_red);
	
	request.setAttribute("merchantRedEnvelope_list", merchantRedEnvelope_list);
	request.setAttribute("subscribeUser", subscribeUser);
%>
<!DOCTYPE html>
<html>
	<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta content="yes" name="apple-mobile-web-app-capable">
    <meta content="telephone=no,email=no" name="format-detection">
    <meta content="yes" name="apple-touch-fullscreen">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <meta content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0" name="viewport" /><!-- 屏蔽双击缩放 -->
	<link rel="stylesheet" type="text/css" href="${basePath }user_center/myhongbao/css/index.css"/>
	<link rel="stylesheet" type="text/css" href="${basePath }user_center/layui-v2.2.5/layui/css/layui.css"/>
	
	<script type="text/javascript" src="${basePath }merchant_show/js/jquery-1.11.0.js"></script>
	</head>
	<body>
		<div class="hongbao1_18_02" style="height:20vh;width:100%;background:url(myhongbao/img/bg.jpg) no-repeat;background-size:100% 100%;">
			<div class="">
				<img src="${subscribeUser.headimgurl }" style="width: 5rem;height: 5rem;border-radius: 5rem;"/>
			</div>
			<div class="" style="padding-top: 1rem;">
				${subscribeUser.nickname }
			</div>
		</div>
		<div class="hongbao2_18">
			<div class="hongbao2_18_01">
				<img src="myhongbao/img/hongbao.png"/>
			</div>
			<div class="hongbao2_18_02">
				我的钱包
			</div>
			<div class="hongbao2_18_03">
				余额：￥${front_user.availableBalanceFen/100 }
			</div>
			<div class="" style="height: 0.5rem;">&nbsp;</div>
		</div>
		<!--红包详情内容-->
		<c:forEach var="merchantRedEnvelope" items="${merchantRedEnvelope_list }">
		<div class="hongbao3_18">
			<div class="hongbao3_18_01">
				<img src="${basePath }<c:out value="${merchantRedEnvelope.user_merchant.picname }" escapeXml="true"/>" style="width: 4.8rem;height: 4.8rem;" />
			</div>
			<div class="hongbao3_18_02" >
				<div class="" style="font-size:1rem;color: #6e6d6d;line-height: 1rem;height: 1rem;overflow: hidden;text-align: left;float: left;width: 100%;padding-top: 0.1rem;">
					<c:out value="${merchantRedEnvelope.red_envolope_name }" escapeXml="true"/>
				</div>  
				<div class="" style="padding-top: 1.9rem;font-size: 0.6rem;">
					金额：${merchantRedEnvelope.amountFen/100 } 元
				</div>
				<div class="" style="padding-top: 0.25rem;line-height: 1.4rem;height: 1.4rem;position: relative;">
					<div class="" style="float: left;position: absolute;">
						<img src="myhongbao/img/dao.png" style="width: 0.8rem;">
					</div>
					<div class=""  style="float: left;padding-left: 0.8rem;font-size: 0.6rem;line-height: 1.4rem;height: 1.4rem;overflow: hidden;padding-top: 0.2rem;">
						地址：<c:out value="${merchantRedEnvelope.user_merchant.showAddress }" escapeXml="true"/>
					</div>
				</div>
			</div>
			<div class="hongbao3_18_03" style="">
				<div class="" style="width: 100%;height: 2rem;line-height: 2rem;">
					 &nbsp;
				</div>
				<div class=""  style="float: left;padding-top: 1.55rem;font-size: 0.6rem;">
					有效期至：${merchantRedEnvelope.showExpiry_time }
				</div> 
			</div>
		</div>
		</c:forEach>
	</body>
</html>
