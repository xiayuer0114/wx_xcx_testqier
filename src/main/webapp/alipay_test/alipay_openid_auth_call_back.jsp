<%@page import="com.lymava.commons.util.JsonUtil"%><%@page import="com.google.gson.JsonObject"%><%@page import="com.lymava.commons.util.MyUtil"%><%@page import="com.lymava.wechat.gongzhonghao.GongzonghaoContent"%><%@page import="com.lymava.wechat.gongzhonghao.Gongzonghao"%><%@page import="com.lymava.commons.util.HttpUtil"%><%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%><%
    String state = request.getParameter("state");
    System.out.println("回调成功!"+state); 
    //response.sendRedirect("/qier/"); 
%>