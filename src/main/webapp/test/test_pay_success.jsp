<%@page import="com.lymava.base.util.ContextUtil"%>
<%@page import="com.lymava.trade.pay.model.PaymentRecord"%>
<%@page import="com.lymava.commons.pay.PayFinalVariable"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Map"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%

	PaymentRecord paymentRecord = (PaymentRecord)ContextUtil.getSerializContext().get(PaymentRecord.class, "5b1b4023ef70d11407c565a5");

	paymentRecord = (PaymentRecord)paymentRecord.getFinalBusinessRecord();

	Map params = new HashMap();

	params.put(PayFinalVariable.third_pay_total_fee_key, paymentRecord.getThirdPayPrice_fen_all());
	
	paymentRecord.getPayMethod().pay_success_notify_back_common(paymentRecord,params);
    
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
</head>
<body>

</body>
</html>