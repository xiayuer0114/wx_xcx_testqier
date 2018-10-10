<%@page import="com.lymava.qier.business.BusinessIntIdConfigQier"%>
<%@page import="com.lymava.qier.business.businessRecord.MerchantRedEnvelopePayRecord"%>
<%@page import="com.lymava.qier.model.MerchantRedEnvelope"%>
<%@page import="com.lymava.qier.action.CashierAction"%>
<%@page import="com.mongodb.BasicDBList"%>
<%@page import="com.lymava.nosql.context.SerializContext"%>
<%@page import="com.lymava.qier.activities.sharebusiness.NazhongrenShareBusiness"%>
<%@page import="com.lymava.qier.activities.sharebusiness.LiuyibaShareBusiness"%>
<%@page import="com.lymava.qier.sharebusiness.GaosanShareBusiness"%>
<%@page import="com.lymava.qier.sharebusiness.QierGongzonghaoShareBusinessDefault"%>
<%@page import="com.lymava.wechat.gongzhonghao.sharebusiness.GongzonghaoShareBusiness"%>
<%@page import="com.lymava.wechat.gongzhonghao.GongzonghaoContent"%>
<%@page import="com.lymava.wechat.gongzhonghao.Gongzonghao"%>
<%@page import="com.lymava.base.util.ContextUtil"%>
<%@page import="com.mongodb.DBObject"%>
<%@page import="com.mongodb.BasicDBObject"%>
<%@page import="com.lymava.nosql.mongodb.util.MongoCommand"%>
<%@page import="com.lymava.qier.model.Voucher"%>
<%@page import="com.lymava.commons.state.State"%>
<%@page import="com.lymava.nosql.util.PageSplit"%>
<%@page import="com.lymava.commons.util.HexM"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Iterator"%>
<%@page import="com.lymava.qier.model.UserVoucher"%>
<%@page import="com.lymava.commons.pay.PayFinalVariable"%>
<%@page import="com.lymava.commons.util.MathUtil"%>
<%@page import="com.lymava.trade.business.model.Product"%>
<%@ page import="com.lymava.qier.model.Merchant72" %>
<%@ page import="com.lymava.qier.model.Product72" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%  
	MerchantRedEnvelopePayRecord merchantRedEnvelopePayRecord_find = new MerchantRedEnvelopePayRecord();
	merchantRedEnvelopePayRecord_find.setBusinessIntId(BusinessIntIdConfigQier.businessIntId_dingxiang);
	
	SerializContext serializContext = ContextUtil.getSerializContext();
	
	Iterator<MerchantRedEnvelopePayRecord> merchantRedEnvelopePayRecord_ite = serializContext.findIterable(merchantRedEnvelopePayRecord_find);
	
	while(merchantRedEnvelopePayRecord_ite.hasNext()){
		
		MerchantRedEnvelopePayRecord merchantRedEnvelopePayRecord_next = merchantRedEnvelopePayRecord_ite.next();
		
		
		if(merchantRedEnvelopePayRecord_next.getMerchantRedEnvelope_id() == null){
			
			MerchantRedEnvelopePayRecord merchantRedEnvelopePayRecord_update = new MerchantRedEnvelopePayRecord();
			merchantRedEnvelopePayRecord_update.setMerchantRedEnvelope_id(merchantRedEnvelopePayRecord_next.getRequestFlow());
			
			serializContext.updateObject(merchantRedEnvelopePayRecord_next.getId(), merchantRedEnvelopePayRecord_update);
		}
		 
	}
%>







