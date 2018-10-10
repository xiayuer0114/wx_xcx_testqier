<%@page import="com.lymava.trade.pay.model.PaymentRecord"%>
<%@page import="java.util.Iterator"%>
<%@page import="com.lymava.nosql.context.SerializContext"%>
<%@page import="com.lymava.base.util.ContextUtil"%>
<%@page import="com.lymava.trade.base.model.BusinessIntIdConfig"%>
<%@page import="com.lymava.trade.pay.model.RefundRecord"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	RefundRecord  refundRecord_find = new RefundRecord();

	refundRecord_find.setBusinessIntId(BusinessIntIdConfig.businessIntId_refund);
	
	SerializContext serializContext = ContextUtil.getSerializContext();
	
	Iterator<RefundRecord> refundRecord_ite =  serializContext.findIterable(refundRecord_find);
	
	while(refundRecord_ite.hasNext()){
		
		RefundRecord refundRecord_next = refundRecord_ite.next();
		
		PaymentRecord paymentRecord = refundRecord_next.getPaymentRecord();
		
		if(paymentRecord == null){
			out.println(refundRecord_next.getRequestFlow()+" "+refundRecord_next.getId()+" paymentRecord 不存在<br/>");
			continue;
		}
		
		RefundRecord refundRecord_update = new RefundRecord();
		refundRecord_update.setUserId_merchant(paymentRecord.getUserId_merchant());
		
		serializContext.updateObject(refundRecord_next.getId(), refundRecord_update);
	}

%>