<%@page import="com.lymava.trade.pay.model.PaymentRecord"%>
<%@page import="com.lymava.qier.model.TradeRecord72"%>
<%@page import="com.lymava.qier.util.PrintUtil"%>
<%@page import="com.lymava.base.util.ContextUtil"%>
<%@page import="com.lymava.trade.business.model.TradeRecord"%>
<%@page import="java.util.List"%>
<%@page import="com.lymava.nosql.util.PageSplit"%>
<%@page import="com.lymava.base.model.PubConlumn"%>
<%@page import="com.lymava.base.model.Pub"%>
<%@page import="java.util.Enumeration"%>
<%@page import="com.lymava.wechat.opendevelop.DevelopAccount"%>
<%@page import="com.lymava.wechat.gongzhonghao.GongzonghaoContent"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%><%
   
    PaymentRecord paymentRecord = (PaymentRecord)ContextUtil.getSerializContext().get(PaymentRecord.class, "5b18f42378505f26aa8fdbf8");
    paymentRecord.close_pay();
    
%> 