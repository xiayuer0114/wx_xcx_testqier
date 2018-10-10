<%@page import="com.lymava.trade.pay.passway.PayMethod"%>
<%@page import="com.lymava.qier.model.TradeRecord72"%>
<%@page import="java.util.List"%>
<%@page import="java.util.LinkedList"%>
<%@page import="com.lymava.base.util.ContextUtil"%>
<%@page import="com.lymava.trade.pay.model.PaymentRecord"%>
<%@page import="com.lymava.commons.pay.PayFinalVariable"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Map"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%

	List<String> request_flow = new LinkedList<String>();

	request_flow.add("1536403267436"); 
	
	for(String request_flow_tmp:request_flow){
		
		
		
		TradeRecord72 tradeRecord72_find = new TradeRecord72();
		tradeRecord72_find.setRequestFlow(request_flow_tmp);
		
		tradeRecord72_find = (TradeRecord72)ContextUtil.getSerializContext().get(tradeRecord72_find);
		
		PayMethod payMethod = null;
		 
		
		TradeRecord72 tradeRecord72_update = new TradeRecord72();
		tradeRecord72_update.setPay_method(tradeRecord72_find.getPay_method());
		
		ContextUtil.getSerializContext().updateObject(tradeRecord72_find.getId(), tradeRecord72_update);
		
		payMethod =  tradeRecord72_find.getPayMethod();
		
		Map params = new HashMap();
		params.put(PayFinalVariable.third_pay_total_fee_key, tradeRecord72_find.getThirdPayPrice_fen_all());
		
		payMethod.pay_success_notify_back_common(tradeRecord72_find,params);
	}

 
    %>
    
    
    
    
    
    
    
    
    
    
    
    
    
