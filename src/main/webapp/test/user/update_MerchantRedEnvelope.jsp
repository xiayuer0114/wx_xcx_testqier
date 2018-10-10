<%@page import="com.lymava.qier.model.MerchantRedEnvelope"%>
<%@page import="com.lymava.qier.model.User72"%>
<%@page import="com.lymava.qier.action.CashierAction"%>
<%@page import="com.lymava.wechat.gongzhonghao.SubscribeUser"%>
<%@page import="com.lymava.commons.util.MyUtil"%>
<%@page import="com.lymava.base.model.User"%>
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
		
		MerchantRedEnvelope merchantRedEnvelope_find = new MerchantRedEnvelope();
		merchantRedEnvelope_find.setState(State.STATE_WAITE_WAITSENDGOODS);


		Iterator<MerchantRedEnvelope> merchantRedEnvelope_ite =  ContextUtil.getSerializContext().findIterable(merchantRedEnvelope_find);
		
		while(merchantRedEnvelope_ite.hasNext()){
			
			MerchantRedEnvelope merchantRedEnvelope_next = merchantRedEnvelope_ite.next();
			
			
			merchantRedEnvelope_next.setState(State.STATE_OK);
			merchantRedEnvelope_next.setUserId_huiyuan(null);
			
			
			ContextUtil.getSerializContext().save(merchantRedEnvelope_next);
		}
 
	 
%>