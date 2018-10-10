<%@page import="com.lymava.qier.business.BusinessIntIdConfigQier"%>
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
		
		Long  price_fen_all = refundRecord_next.getPrice_fen_all();
		
		if(price_fen_all != null && price_fen_all < 0){
			 
			out.println(refundRecord_next.getRequestFlow()+" "+refundRecord_next.getId()+" "+refundRecord_next.getShowTime()+ " 业务id异常<br/>");
			
			RefundRecord refundRecord_update = new RefundRecord();
			refundRecord_update.setBusinessIntId(BusinessIntIdConfigQier.businessIntId_refund_tongyong);
			
			serializContext.updateObject(refundRecord_next.getId(), refundRecord_update);
		}
		

	}

%>