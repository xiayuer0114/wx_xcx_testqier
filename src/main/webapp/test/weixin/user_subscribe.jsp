<%@page import="com.lymava.wechat.gongzhonghao.GongzonghaoContent"%>
<%@page import="com.lymava.wechat.gongzhonghao.SubscribeUser"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	GongzonghaoContent gongzonghaoContent = GongzonghaoContent.getInstance();

	String FromUserName = "oYb451AhRJ-qXpsN1pfv9GKB3lSI";

	SubscribeUser subscribeUser = gongzonghaoContent.getSubscribeUser(FromUserName);
	
	GongzonghaoContent.getInstance().user_subscribe(subscribeUser);
	 
%>