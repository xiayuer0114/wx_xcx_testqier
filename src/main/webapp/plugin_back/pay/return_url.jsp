<%@page import="com.lymava.commons.state.State"%>
<%@page import="com.lymava.base.util.ContextUtil"%>
<%@page import="com.lymava.trade.pay.model.PaymentRecord"%>
<%@page import="com.lymava.commons.util.MyUtil"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	String basePath = MyUtil.getBasePath(request);
	String out_trade_no = request.getParameter("out_trade_no");
	
	PaymentRecord paymentRecord  = null;
	
	if(MyUtil.isValid(out_trade_no)){
		paymentRecord = (PaymentRecord) ContextUtil.getSerializContext().get(PaymentRecord.class, out_trade_no);
	} 
	if(paymentRecord != null && State.STATE_WAITE_PAY.equals(paymentRecord.getState())){
		paymentRecord = (PaymentRecord)paymentRecord.getFinalBusinessRecord();
		paymentRecord.make_sure_paystate();
	}
	
	response.sendRedirect(basePath+"pay_success_back.jsp?tradeRecord_id="+out_trade_no);
%>