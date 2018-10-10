<%@page import="com.lymava.trade.pay.model.PaymentRecord"%>
<%@page import="com.lymava.base.util.ContextUtil"%>
<%@page import="java.util.Iterator"%>
<%@page import="com.lymava.qier.business.BusinessIntIdConfigQier"%>
<%@page import="com.lymava.qier.business.businessRecord.MerchantRedEnvelopePayRecord"%>
<%@page import="com.lymava.qier.model.Merchant72"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	MerchantRedEnvelopePayRecord merchantRedEnvelopePayRecord_find = new MerchantRedEnvelopePayRecord();
	merchantRedEnvelopePayRecord_find.setBusinessIntId(BusinessIntIdConfigQier.businessIntId_dingxiang);
	
	Iterator<MerchantRedEnvelopePayRecord> merchantRedEnvelopePayRecord_ite =  ContextUtil.getSerializContext().findIterable(merchantRedEnvelopePayRecord_find);
	
	while(merchantRedEnvelopePayRecord_ite.hasNext()){
		
		MerchantRedEnvelopePayRecord merchantRedEnvelopePayRecord_next = merchantRedEnvelopePayRecord_ite.next();
		
		PaymentRecord paymentRecord = merchantRedEnvelopePayRecord_next.getPaymentRecord();
		
		if(paymentRecord != null){
			
			MerchantRedEnvelopePayRecord merchantRedEnvelopePayRecord_update = new MerchantRedEnvelopePayRecord();
			merchantRedEnvelopePayRecord_update.setUserId_merchant(paymentRecord.getUserId_merchant());
			
			
			ContextUtil.getSerializContext().updateObject(merchantRedEnvelopePayRecord_next.getId(), merchantRedEnvelopePayRecord_update);
		}
		
	}
%>