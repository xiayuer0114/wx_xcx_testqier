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
		
		User user_find = new User();
		user_find.setUserGroupId(CashierAction.getCommonUserGroutId());

		Iterator<User> ite =  ContextUtil.getSerializContext().findIterable(user_find);
		
		while(ite.hasNext()){
			
			User user_next = ite.next();
			
			String third_user_id = user_next.getThird_user_id();
			
			if(MyUtil.isEmpty(third_user_id)){
				continue;
			}
			
			SubscribeUser subscribeUser_find = new SubscribeUser();
			subscribeUser_find.setOpenid(third_user_id);
			
			SubscribeUser subscribeUser = (SubscribeUser)ContextUtil.getSerializContext().get(subscribeUser_find);
			
			if(subscribeUser != null && !MyUtil.isEmpty(subscribeUser.getNickname()) ){
				
				User72 user_update = new User72();
				
				user_update.setNickname(subscribeUser.getNickname());
				user_update.setRealname(subscribeUser.getNickname());
				user_update.setUnionid(subscribeUser.getUnionid());
				
				
				ContextUtil.getSerializContext().updateObject(user_next.getId(), user_update);
			}
			
		}

	 
%>