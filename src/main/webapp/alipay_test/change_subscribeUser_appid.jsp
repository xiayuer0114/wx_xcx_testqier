<%@page import="com.lymava.wechat.gongzhonghao.SubscribeUser"%>
<%@page import="com.google.gson.JsonElement"%>
<%@page import="com.lymava.commons.util.JsonUtil"%>
<%@page import="java.net.URL"%>
<%@page import="com.lymava.commons.http.HttpsPost"%>
<%@page import="com.google.gson.JsonArray"%>
<%@page import="com.google.gson.JsonObject"%>
<%@page import="java.util.Iterator"%>
<%@page import="com.lymava.nosql.context.SerializContext"%>
<%@page import="com.lymava.base.util.ContextUtil"%>
<%@page import="com.lymava.commons.vo.EntityKeyValue"%>
<%@page import="java.util.List"%>
<%@page import="java.util.LinkedList"%>
<%@page import="com.lymava.commons.util.HttpUtil"%>
<%@page import="com.lymava.commons.util.MyUtil"%>
<%@page import="com.lymava.wechat.gongzhonghao.GongzonghaoContent"%>
<%@page import="com.lymava.wechat.gongzhonghao.Gongzonghao"%>
<%@page import="com.lymava.commons.util.MathUtil"%>
<%@page import="com.lymava.trade.business.model.Product"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
		SubscribeUser user_find = new SubscribeUser();
		
		SerializContext serializContext = ContextUtil.getSerializContext();
		
		Iterator<SubscribeUser> user_ite =  serializContext.findIterable(user_find);
		
		boolean has_next = user_ite.hasNext();
		
		Gongzonghao gongzonghao =	GongzonghaoContent.getInstance().getDefaultGongzonghao();
		
		
		
		while(has_next){
			
			SubscribeUser user_next = user_ite.next();
			
			SubscribeUser subscribeUser_update = new SubscribeUser();
			subscribeUser_update.setApp_id(gongzonghao.getAppid());
			
			serializContext.updateObject(user_next.getId(), subscribeUser_update);
			
			has_next = user_ite.hasNext();
		}
%>