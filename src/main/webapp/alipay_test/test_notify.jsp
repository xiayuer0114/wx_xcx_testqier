<%@page import="com.lymava.nosql.util.QuerySort"%>
<%@page import="java.util.List"%>
<%@page import="com.lymava.nosql.util.PageSplit"%>
<%@page import="com.lymava.base.vo.State"%>
<%@page import="com.lymava.qier.model.TradeRecord72"%>
<%@page import="com.lymava.base.model.User"%>
<%@page import="com.lymava.base.util.ContextUtil"%>
<%@page import="com.lymava.nosql.context.SerializContext"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
SerializContext serializContext = ContextUtil.getSerializContext();

/**
 * 检查这个用户的订单编号
 */

		User user_find = new User();
		user_find.setThird_user_id("o3gi9v0tOiS819RkSKZW97mpmNFQ");
		
		user_find = (User) serializContext.get(user_find);
		
		if(user_find == null){ return;}
		
		TradeRecord72 tradeRecord72_find = new TradeRecord72();
		tradeRecord72_find.setUserId_huiyuan(user_find.getId());
		tradeRecord72_find.setState(State.STATE_PAY_SUCCESS);
		
		PageSplit pageSplit = new PageSplit();
		pageSplit.setPageSize(1);
		
		tradeRecord72_find.initQuerySort("id", QuerySort.desc);
		
		List<TradeRecord72> tradeRecord72_list = serializContext.findAll(tradeRecord72_find,pageSplit);
		
		if(tradeRecord72_list != null && tradeRecord72_list.size() > 0){
			TradeRecord72 tradeRecord72 = tradeRecord72_list.get(0);
			tradeRecord72.notify_huiyuan();
		}

%>