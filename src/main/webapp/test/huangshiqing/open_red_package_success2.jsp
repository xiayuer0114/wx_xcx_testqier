<%@page import="com.lymava.qier.activities.model.MarketingActivities"%>
<%@page import="com.lymava.qier.business.BusinessIntIdConfigQier"%>
<%@page import="com.lymava.qier.activities.guaguaka.GuaguakaShareBusiness"%>
<%@page import="com.lymava.qier.util.DiLiUtil"%>
<%@page import="com.lymava.trade.pay.model.PaymentRecord"%>
<%@page import="com.lymava.nosql.mongodb.util.MongoCommand"%>
<%@page import="com.lymava.qier.model.Merchant72"%>
<%@page import="com.lymava.nosql.util.QuerySort"%>
<%@page import="com.lymava.nosql.util.PageSplit"%>
<%@page import="com.lymava.qier.model.MerchantRedEnvelope"%>
<%@page import="com.lymava.base.model.BalanceLog"%>
<%@page import="com.lymava.qier.model.TradeRecord72"%>
<%@page import="com.lymava.nosql.context.SerializContext"%>
<%@page import="com.lymava.commons.state.State"%>
<%@page import="com.lymava.trade.business.model.Product"%>
<%@page import="com.lymava.trade.business.model.TradeRecord"%>
<%@page import="com.lymava.qier.service.MerchantRedEnvelopeService" %>
<%@ page import="java.util.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ include file="/header/check_openid.jsp"%>
<%@ include file="/header/header_check_login.jsp"%>


<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width,initial-scale=1,minimum-scale=1,maximum-scale=1,user-scalable=no" />
    <title>悠择YORZ-红包领取成功</title>
    <script src="${basePath }js/mui.min.js"></script>
    </script>
</head>   
<body style="background-color: <c:if test="${!show_qrcode}">#eee</c:if><c:if test="${show_qrcode}">#fff</c:if>;" class="layui-col-xs12"> 
	
	<%
	MerchantRedEnvelopeService merchantRedEnvelopeService=new MerchantRedEnvelopeService();
	List<MerchantRedEnvelope> merchantRedEnvelope_list = new ArrayList<MerchantRedEnvelope>();
	TradeRecord72 tradeRecord72=new TradeRecord72();
	
	tradeRecord72.setUserId_merchant("5b933105d6c459581b34e5d6");
	tradeRecord72.setUserId_huiyuan("5b9b193dd6c45964b84a88f6");
	
	Integer size=5;
	merchantRedEnvelope_list= merchantRedEnvelopeService.recommendMerchantRedEnvelope(tradeRecord72, size);
	request.setAttribute("merchantRedEnvelope_list", merchantRedEnvelope_list);
	
	%>
	
	
	
	
	
	
	
		<c:forEach var="merchantRedEnvelope" items="${merchantRedEnvelope_list }">
					<div class="layui-col-xs12" style="background-color: #eee;height: 0.2rem;">
						&nbsp;
					</div>
					<div class="layui-col-xs12" style="height: 6.1rem;background-color: #fff;padding: 0.4rem;position: relative;">
						<div  style="height: 5.3rem;width: 5.3rem;position: absolute;left: 0.4rem;top: 0.4rem;">
							 <img alt="" src="<c:out value="${merchantRedEnvelope.user_merchant.picname }" escapeXml="true"/>" style="height: 100%;width: 100%;">
						</div> 
						<div class="layui-col-xs12" style="padding-left: 5.7rem;color: #6e6d6d;height: 100%;">
							  <div class="layui-row">
							    <div class="layui-col-xs6" style="height: 1.25rem;line-height: 1.25rem;overflow: hidden;">
									<c:out value="${merchantRedEnvelope.red_envolope_name }" escapeXml="true"/>
								</div> 
								<div class="layui-col-xs6" style="text-align: right;">
									<img src="imgs/biao.png" style="padding-right: 0.5rem;height: 1rem;">
									<c:out value="${merchantRedEnvelope.merchant_type }" escapeXml="true"/>
								</div>
							 </div>
							 <div class="layui-row">
							    <div class="layui-col-xs4" style="height: 2rem;line-height: 2rem;">
									<font style="font-size: 0.7rem;">金额:${merchantRedEnvelope.amountFen/100 } 元</font> 
								</div>  
								<div class="layui-col-xs4" style="height: 2rem;line-height: 2rem;">
									<font style="font-size: 0.7rem;">距离:${merchantRedEnvelope.showDistance }</font> 
								</div>   
								<div class="layui-col-xs4" style="height: 2rem;line-height: 2rem;text-align: right;">
									<font style="font-size: 0.6rem;">有效期:${merchantRedEnvelope.showExpiryMonthDay }</font> 
								</div>
							 </div>
							 <div class="layui-row" >
							    <div class="layui-col-xs9" style="padding-top: 0.3rem;height: 1.55rem;line-height: 1.55rem;overflow: hidden;">
									<img src="imgs/dao.png" style="padding-right: 0.5rem;height: 1rem;width: 1.25rem;">
									<c:out value="${merchantRedEnvelope.user_merchant.showAddress }" escapeXml="true"/>
								</div>    
								<div class="layui-col-xs3" style="padding-top: 0.3rem;text-align: center ;padding-right: 0.2rem;">
									<c:if test="${merchantRedEnvelope.state == 209 }">
									<div onclick="receive_red_envelopes('${merchantRedEnvelope.id }','${tradeRecord.id}')"   class="lingqu ${merchantRedEnvelope.id }">领取</div>
									<div style="display: none;" class="yi_lingqu">已领取</div>
									</c:if>
									<c:if test="${merchantRedEnvelope.state != 209 }">
									<div  class="yi_lingqu">已领取</div>
									</c:if>
								</div> 
							 </div>
						</div> 
					</div> 
				</c:forEach> 
	
	
	
	
</body>
</html>