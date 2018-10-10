<%@page import="com.lymava.commons.state.State"%>
<%@page import="com.lymava.commons.util.MyUtil"%>
<%@page import="com.google.gson.JsonObject"%>
<%@page import="com.lymava.base.model.User"%>
<%@page import="com.lymava.userfront.util.FrontUtil"%>
<%@page import="com.lymava.commons.state.StatusCode"%>
<%@page import="com.lymava.trade.pay.model.PaymentRecord"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Map"%>
<%@page import="com.lymava.trade.base.model.Business"%>
<%@page import="com.lymava.qier.business.BusinessIntIdConfigQier"%>
<%@page import="com.lymava.trade.base.context.BusinessContext"%>
<%@page import="com.lymava.commons.exception.CheckException"%>
<%@page import="com.lymava.commons.util.MathUtil"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
	User user_huiyuan = FrontUtil.init_http_user(request);
	
	String price_fen_str = request.getParameter("price_fen"); 
	String requestFlow = request.getParameter("requestFlow");
	
	JsonObject jsonObject = new JsonObject();
	
	try{
		
		//ST.Moti圣慕缇
		String userId_merchant = "5b309e497d170b366d56a674"; 
		
		//创建支付订单
		//Long price_fen = MathUtil.parseLongNull(price_fen_str);
		
		Long price_fen=new Long(price_fen_str);

		CheckException.checkIsTure(price_fen != null && price_fen > 0 , "支付金额必须大于0的整数!"); 
		
		BusinessContext businessContext_instance = BusinessContext.getInstance();
		
		Business business = businessContext_instance.getBusiness(BusinessIntIdConfigQier.businessIntId_shengmuti_baoming);
		CheckException.checkIsTure(business != null, "业务未配置!");
		
		Map requestMap = new HashMap();
		requestMap.putAll(request.getParameterMap());
		
		requestMap.put(Business.user_key, user_huiyuan);
		requestMap.put(Business.ip_key, MyUtil.getIpAddr(request));
		requestMap.put(Business.requestFlow_key, requestFlow);
		requestMap.put("userId_merchant", userId_merchant);
		requestMap.put("price_fen", price_fen_str);
		
		//执行Business，保存记录
		PaymentRecord paymentRecord = (PaymentRecord)business.executeBusiness(requestMap);
		
		Integer state = paymentRecord.getState();
		
		if(State.STATE_WAITE_PAY.equals(state)) {
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