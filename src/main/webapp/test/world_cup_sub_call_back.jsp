<%@page import="com.lymava.wechat.opendevelop.WeixinCallBackMessageFilter"%>
<%@page import="com.lymava.qier.activities.sharebusiness.WorldCupForecastShareBusiness"%>
<%@page import="com.lymava.qier.activities.model.WorldCupForecast"%>
<%@page import="java.util.Iterator"%>
<%@page import="com.lymava.nosql.util.PageSplit"%>
<%@page import="com.lymava.base.model.BalanceLog"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ include file="../header/check_openid.jsp"%>
<%@ include file="../header/header_check_login.jsp"%>
<%
	WeixinCallBackMessageFilter.threadLocal_realPath.set(application.getRealPath("/") );

	WorldCupForecast worldCupForecast_find = new WorldCupForecast();
	
	worldCupForecast_find.setType(WorldCupForecast.type_16);
	worldCupForecast_find.setOpenid(openid_header);
	
	WorldCupForecast worldCupForecast = (WorldCupForecast)serializContext.get(worldCupForecast_find);
	
	if(worldCupForecast == null){
		return;
	}
	
	Gongzonghao gongzonghao = GongzonghaoContent.getInstance().getDefaultGongzonghao();
	
	WorldCupForecastShareBusiness worldCupForecastShareBusiness = new WorldCupForecastShareBusiness();
	
	worldCupForecastShareBusiness.subscribe_call_back(gongzonghao, "", openid_header);
	 
%>