<%@page import="com.lymava.base.util.ContextUtil"%>
<%@page import="com.lymava.commons.util.MathUtil"%>
<%@page import="com.lymava.commons.util.MyUtil"%>
<%@page import="com.lymava.commons.util.JsonUtil"%>
<%@page import="com.google.gson.JsonObject"%>
<%@page import="com.lymava.wechat.opendevelop.DevelopAccount"%>
<%@page import="com.lymava.wechat.gongzhonghao.Gongzonghao"%>
<%@page import="com.lymava.wechat.gongzhonghao.GongzonghaoContent"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%  
	
	String openid = "oYb451J_r9u9tBbyq86c40RWxa48";
	
	Gongzonghao defaultGongzonghao = GongzonghaoContent.getInstance().getDefaultGongzonghao();
	
	DevelopAccount developAccount = defaultGongzonghao.getDevelopAccount();
	
	String user_info_str = defaultGongzonghao.getGuanzhuUserInfoFromWeixin(openid);
	
	user_info_str = defaultGongzonghao.get_user_userinfo(openid);
	
	
	out.println(user_info_str+"<br/>");
%>