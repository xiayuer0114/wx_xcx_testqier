<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Date"%>
<%@page import="com.lymava.commons.util.DateUtil"%>
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

	String[] group_name_values = request.getParameterValues("group_name");
	String[] country_name_values = request.getParameterValues("country_name");
	String[] country_image_values = request.getParameterValues("country_image");
	String[] group_name_index_values = request.getParameterValues("group_name_index");
	
	String worldCupForecast_until = WebConfigContent.getConfig("worldCupForecast_until");
	
	Date  worldCupForecast_until_date = DateUtil.getSdfFull().parse(worldCupForecast_until);
	
	
	if(System.currentTimeMillis() > worldCupForecast_until_date.getTime()){
		jsonObject.addProperty(StatusCode.statusCode_key, StatusCode.ACCEPT_FALSE);
		jsonObject.addProperty(StatusCode.statusCode_message_key, "活动已于"+worldCupForecast_until+"停止预测!<br/>请等待比赛结果!");
		out.print(jsonObject);
		return;
	}
	
	if(	
			group_name_values == null || group_name_values.length != 16 ||
			country_image_values == null || country_image_values.length != 16 ||
			group_name_index_values == null || group_name_index_values.length != 16 ||
			country_name_values == null || country_name_values.length != 16
			){
		jsonObject.addProperty(StatusCode.statusCode_key, StatusCode.ACCEPT_FALSE);
		jsonObject.addProperty(StatusCode.statusCode_message_key, "请选择完成后再提交!");
		out.print(jsonObject);
		return;
	}
	
	WorldCupForecast worldCupForecast_find = new WorldCupForecast();
	
	worldCupForecast_find.setType(WorldCupForecast.type_32_to_16);
	worldCupForecast_find.setOpenid(openid_header);
	
	WorldCupForecast worldCupForecast_32 = (WorldCupForecast)serializContext.get(worldCupForecast_find);
	
	worldCupForecast_find = new WorldCupForecast();
	
	worldCupForecast_find.setType(WorldCupForecast.type_16);
	worldCupForecast_find.setOpenid(openid_header);
	
	WorldCupForecast worldCupForecast_16 = (WorldCupForecast)serializContext.get(worldCupForecast_find);
	
	/**
	16 的提交后才锁定
	*/
	if(worldCupForecast_16 != null){
		jsonObject.addProperty(StatusCode.statusCode_key, StatusCode.USER_INFO_TIMEOUT);
		jsonObject.addProperty(StatusCode.statusCode_message_key, "每人只能提交一次成绩!");
		out.print(jsonObject);
		return;
	}
	
	if(worldCupForecast_32 == null){
		worldCupForecast_32 = new WorldCupForecast();
	}
	
	
	worldCupForecast_32.setType(WorldCupForecast.type_32_to_16);
	worldCupForecast_32.setOpenid(openid_header);
	
	Map<String,BasicDBObject> group_name_index_map = new HashMap<String,BasicDBObject>();
	
	BasicDBList basicDBList = new BasicDBList();
	
	for(int i=0; i<group_name_values.length && i< country_name_values.length ;i++){
		
		String group_name = group_name_values[i];
		String country_name = country_name_values[i];
		String country_image = country_image_values[i];
		String group_name_index = group_name_index_values[i];
		
		String group_name_1 = group_name+"1";
		String group_name_2 = group_name+"2";
		
		BasicDBObject basicDBObject = new BasicDBObject();
		
		basicDBObject.put("group_name", group_name);
		basicDBObject.put("country_name", country_name);
		basicDBObject.put("country_image", country_image);
		basicDBObject.put("group_name_index", group_name_index);
		
		group_name_index_map.put(group_name_index, basicDBObject);
		
		if(group_name_2.equals(group_name_index)){
			//如果上来的是第二名来了
			
			BasicDBObject basicDBObject_1 = group_name_index_map.get(group_name_1);
			
			if(basicDBObject_1 != null){
				//如果1 为空
				basicDBList.add(basicDBObject);
			}
		}else{
			BasicDBObject basicDBObject_2 = group_name_index_map.get(group_name_2);
			
			basicDBList.add(basicDBObject);
			
			if(basicDBObject_2 != null){
				basicDBList.add(basicDBObject_2);
			}
		}
	}
	
	worldCupForecast_32.setBasicDBList(basicDBList);
	
	serializContext.save(worldCupForecast_32);

	jsonObject.addProperty(StatusCode.statusCode_key, StatusCode.ACCEPT_OK);
	jsonObject.addProperty(StatusCode.statusCode_message_key, "保存成功!");

	out.print(jsonObject);
%>