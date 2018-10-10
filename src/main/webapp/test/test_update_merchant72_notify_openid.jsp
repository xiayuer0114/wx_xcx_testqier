<%@page import="com.lymava.commons.util.MyUtil"%>
<%@page import="com.lymava.qier.action.CashierAction"%>
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
	
	Merchant72 user_find = new Merchant72();
	user_find.setUserGroupId(CashierAction.getMerchantUserGroutId());
	
	Iterator<Merchant72> ite =  ContextUtil.getSerializContext().findIterable(user_find);
	
	while(ite.hasNext()){
		
		Merchant72 user_next = ite.next();
		
		String notify_openid = user_next.getNotify_openid();
		
		if(!MyUtil.isEmpty(notify_openid)){
			
			user_next.addNotify_openid(notify_openid); 

	        // 设置 更新订单通知的微信用户
	        Merchant72 merchant72_update = new Merchant72();
	        merchant72_update.setNotify_openid_list(user_next.getNotify_openid_list());
	        
	        ContextUtil.getSerializContext().updateObject(user_next.getId(), merchant72_update);
		}
		
	}

	 
%>



