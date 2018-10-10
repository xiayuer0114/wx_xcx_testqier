<%@page import="com.lymava.commons.state.StatusCode"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Map"%>
<%@page import="com.lymava.trade.base.model.Business"%>
<%@page import="com.lymava.qier.business.BusinessIntIdConfigQier"%>
<%@page import="com.lymava.trade.base.context.BusinessContext"%>
<%@page import="com.lymava.commons.exception.CheckException"%>
<%@page import="com.lymava.commons.util.MathUtil"%>
<%@ page import="com.lymava.qier.activities.hongbaoliebian.HongbaoliebianPaymentRecord" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ include file="../../../header/check_openid.jsp"%>
<%@ include file="../../../header/header_check_login.jsp"%>
<%

	String userId_merchant = request.getParameter("userId_merchant");
	String price_fen_str = request.getParameter("price_fen");
	String requestFlow = request.getParameter("requestFlow");
	String activitieRedEnvelope_id = request.getParameter("activitieRedEnvelope_id");
	String source_paymentRecord_id = request.getParameter("source_paymentRecord_id");


	JsonObject jsonObject = new JsonObject();

	try{

		//创建支付订单
		Long price_fen = MathUtil.parseLongNull(price_fen_str);
		CheckException.checkIsTure(price_fen != null && price_fen > 0 , "支付金额必须大于0的整数!");

		BusinessContext businessContext_instance = BusinessContext.getInstance();

		Business business = businessContext_instance.getBusiness(BusinessIntIdConfigQier.businessIntId_liebian);
		CheckException.checkIsTure(business != null, "业务未配置!");

		Map requestMap = new HashMap();
		requestMap.putAll(request.getParameterMap());

		requestMap.put(Business.user_key, user);
		requestMap.put(Business.ip_key, MyUtil.getIpAddr(request));
		requestMap.put(Business.requestFlow_key, requestFlow);

		requestMap.put("userId_merchant", userId_merchant);
		requestMap.put("activitieRedEnvelope_id", activitieRedEnvelope_id);
		requestMap.put("source_paymentRecord_id", source_paymentRecord_id);
		requestMap.put("price_fen", price_fen_str);
		
		//执行Business，保存记录
		HongbaoliebianPaymentRecord paymentRecord = (HongbaoliebianPaymentRecord)business.executeBusiness(requestMap);
		
		Integer check_state_create = paymentRecord.getState();
		
		if(State.STATE_WAITE_PAY.equals(check_state_create)) {
			jsonObject.addProperty("paymentRecord_id", paymentRecord.getId());
			jsonObject.addProperty("price_fen_all_sum", paymentRecord.getShowPrice_fen_all());
			jsonObject.addProperty(StatusCode.statusCode_key, StatusCode.ACCEPT_OK);
			jsonObject.addProperty(StatusCode.statusCode_message_key, "订单创建成功!");
		}else {
			jsonObject.addProperty(StatusCode.statusCode_key, StatusCode.ACCEPT_FALSE);
			jsonObject.addProperty(StatusCode.statusCode_message_key, "订单创建失败!");
		}
	}catch(CheckException checkException){
		jsonObject.addProperty(StatusCode.statusCode_key, StatusCode.ACCEPT_FALSE);
		jsonObject.addProperty(StatusCode.statusCode_message_key, checkException.getMessage());
	}catch(Exception e){
		jsonObject.addProperty(StatusCode.statusCode_key, StatusCode.ACCEPT_FALSE);
		jsonObject.addProperty(StatusCode.statusCode_message_key, "订单创建失败!");
	}
	out.print(jsonObject);
%>