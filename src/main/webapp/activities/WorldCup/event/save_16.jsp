<%@page import="com.lymava.qier.activities.model.WorldCupForecast"%>
<%@page import="com.mongodb.BasicDBObject"%>
<%@page import="com.mongodb.BasicDBList"%>
<%@page import="com.lymava.commons.state.StatusCode"%>
<%@page import="com.google.gson.JsonObject"%>
<%@page import="java.util.Iterator"%>
<%@page import="com.lymava.nosql.util.PageSplit"%>
<%@page import="com.lymava.base.model.BalanceLog"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ include file="../../../header/check_openid.jsp"%>
<%@ include file="../../../header/header_check_login.jsp"%>
<%

	JsonObject jsonObject = new JsonObject();

	String[] data_class_values = request.getParameterValues("data_class");
	String[] country_name_values = request.getParameterValues("country_name");
	String[] country_image_values = request.getParameterValues("country_image");
	
	if(	
			data_class_values == null || data_class_values.length != 15 ||
					country_image_values == null || country_image_values.length != 15 ||
			country_name_values == null || country_name_values.length != 15  
			){
		jsonObject.addProperty(StatusCode.statusCode_key, StatusCode.ACCEPT_FALSE);
		jsonObject.addProperty(StatusCode.statusCode_message_key, "请选择完成后再提交!");
		out.print(jsonObject);
		return;
	}
	
	WorldCupForecast worldCupForecast_find = new WorldCupForecast();
	
	worldCupForecast_find.setType(WorldCupForecast.type_16);
	worldCupForecast_find.setOpenid(openid_header);
	
	WorldCupForecast worldCupForecast = (WorldCupForecast)serializContext.get(worldCupForecast_find);
	
	if(worldCupForecast != null){
		jsonObject.addProperty(StatusCode.statusCode_key, StatusCode.ACCEPT_FALSE);
		jsonObject.addProperty(StatusCode.statusCode_message_key, "每人只能提交一次成绩!");
		out.print(jsonObject);
		return;
	}
	
	worldCupForecast = new WorldCupForecast();
	
	worldCupForecast.setType(WorldCupForecast.type_16);
	worldCupForecast.setOpenid(openid_header);
	
	BasicDBList basicDBList = new BasicDBList();
	
	for(int i=0; i<data_class_values.length && i< country_name_values.length ;i++){
		
		String data_class = data_class_values[i];
		String country_name = country_name_values[i];
		String country_image = country_image_values[i];
		
		BasicDBObject basicDBObject = new BasicDBObject();
		
		basicDBObject.put("data_class", data_class);
		basicDBObject.put("country_name", country_name);
		basicDBObject.put("country_image", country_image);
		
		basicDBList.add(basicDBObject);
	}
	
	worldCupForecast.setBasicDBList(basicDBList);
	
	serializContext.save(worldCupForecast);

	jsonObject.addProperty(StatusCode.statusCode_key, StatusCode.ACCEPT_OK);
	jsonObject.addProperty(StatusCode.statusCode_message_key, "保存成功!");

	out.print(jsonObject);
%>