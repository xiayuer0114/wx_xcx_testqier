<%@page import="com.lymava.trade.pay.model.PaymentRecord"%>
<%@page import="java.util.List"%>
<%@page import="com.lymava.base.model.BalanceLog"%>
<%@page import="com.lymava.qier.model.TradeRecord72"%>
<%@page import="com.lymava.nosql.context.SerializContext"%>
<%@page import="com.lymava.commons.state.State"%>
<%@page import="com.lymava.trade.business.model.Product"%>
<%@page import="com.lymava.trade.business.model.TradeRecord"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
	request.setAttribute("scope_snsapi", Gongzonghao.scope_snsapi_userinfo);

	request.removeAttribute("openid");
	session.removeAttribute("openid");
%>
<%@ include file="/header/check_openid.jsp"%>
<%@ include file="/header/header_check_login.jsp"%>
<%
	request.getAttribute("weixin_nickname");
%>
openid:${openid }<br/>
weixin_nickname:${weixin_nickname }<br/>
weixin_headimgurl:${weixin_headimgurl }<br/>
weixin_unionid:${weixin_unionid }<br/>




