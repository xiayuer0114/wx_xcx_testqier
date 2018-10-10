<%@page import="com.lymava.commons.util.MyUtil"%>
<%@page import="com.lymava.base.util.ContextUtil"%>
<%@page import="com.mongodb.DBObject"%>
<%@page import="com.mongodb.BasicDBObject"%>
<%@page import="com.lymava.nosql.mongodb.util.MongoCommand"%>
<%@page import="com.lymava.commons.state.State"%>
<%@page import="com.lymava.nosql.util.PageSplit"%>
<%@page import="com.lymava.commons.util.HexM"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Iterator"%>
<%@page import="com.lymava.commons.pay.PayFinalVariable"%>
<%@page import="com.lymava.commons.util.MathUtil"%>
<%@page import="com.lymava.trade.business.model.Product"%>
<%@ page import="com.lymava.base.model.PubConlumn" %>
<%@ page import="com.lymava.qier.model.xiaoChengXuModel.CityPub" %>
<%@ page import="com.lymava.qier.model.xiaoChengXuModel.ConfigPub" %>
<%@ page import="com.lymava.qier.model.xiaoChengXuModel.ShowPub" %>
<%@ page import="com.lymava.qier.model.xiaoChengXuModel.LinkPub" %>
<%@ page import="java.io.*" %>
<%@ page import="com.lymava.commons.exception.CheckException" %>
<%@ page import="com.lymava.qier.util.WeiHtmlProcess" %>
<%@ page import="com.lymava.qier.action.CashierAction" %>
<%@ page import="com.lymava.qier.model.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
	Merchant72 merchant72_find = new Merchant72();
	merchant72_find.setUserGroupId(CashierAction.getMerchantUserGroutId());

	Iterator<Merchant72> merchant72Iterator = ContextUtil.getSerializContext().findIterable(merchant72_find);

	while (merchant72Iterator.hasNext()){
		Merchant72 merchant72_temp = merchant72Iterator.next();

		TradeRecord72 tradeRecord72_find = new TradeRecord72();
		tradeRecord72_find.setUserId_merchant(merchant72_temp.getId());
		tradeRecord72_find.addCommand(MongoCommand.budengyu, "wallet_amount_payment_pianyi", null);
		
		PageSplit pageSplit_tmp = new PageSplit();

		ContextUtil.getSerializContext().findIterable(tradeRecord72_find,pageSplit_tmp);

		Merchant72 merchant72_update = new Merchant72();
		merchant72_update.setUseRed_renshu(pageSplit_tmp.getCount().intValue());

		ContextUtil.getSerializContext().updateObject(merchant72_temp.getId(),merchant72_update);

		// System.out.println(merchant72_temp.getNickname()+":....."+tradeRecord72s.size());
	}


%>