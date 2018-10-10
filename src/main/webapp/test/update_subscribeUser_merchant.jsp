<%@page import="com.lymava.nosql.util.QuerySort"%>
<%@page import="com.lymava.qier.model.TradeRecord72"%>
<%@page import="com.lymava.nosql.context.SerializContext"%>
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
		
		SubscribeUser subscribeUser_find = new SubscribeUser();

		SerializContext serializContext = ContextUtil.getSerializContext();


		Iterator<SubscribeUser> ite =  ContextUtil.getSerializContext().findIterable(subscribeUser_find);
		
		while(ite.hasNext()){
			
			SubscribeUser subscribeUser_next = ite.next();
			
			String third_user_id = subscribeUser_next.getOpenid();
			
			if(MyUtil.isEmpty(third_user_id)){
				continue;
			}
			
			User user_find = new User();
			user_find.setThird_user_id(third_user_id); 
			
			user_find = (User)serializContext.get(user_find);
			
			if(user_find == null){
				continue;
			}
			
			TradeRecord72 tradeRecord72_find = new TradeRecord72();
			
			tradeRecord72_find.setUserId_huiyuan(user_find.getId());
			tradeRecord72_find.setState(State.STATE_PAY_SUCCESS);
			tradeRecord72_find.initQuerySort("id", QuerySort.asc);
			
			tradeRecord72_find = (TradeRecord72)serializContext.findOneInlist(tradeRecord72_find);
			
			if(tradeRecord72_find == null){
				continue;
			} 
			
			if(MyUtil.isValid(tradeRecord72_find.getUserId_merchant())){
				SubscribeUser subscribeUser_update = new SubscribeUser();
				subscribeUser_update.setQudao_user_id(tradeRecord72_find.getUserId_merchant());
				
				
				serializContext.updateObject(subscribeUser_next.getId(), subscribeUser_update);
			}

		}

	 
%>