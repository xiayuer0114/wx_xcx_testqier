<%@page import="com.lymava.commons.util.MyUtil"%>
<%@page import="org.bson.types.ObjectId"%>
<%@page import="com.lymava.wechat.gongzhonghao.SubscribeUser"%>
<%@page import="com.google.gson.JsonElement"%>
<%@page import="com.google.gson.JsonArray"%>
<%@page import="com.google.gson.JsonObject"%>
<%@page import="com.lymava.commons.util.JsonUtil"%>
<%@page import="org.apache.xmlbeans.impl.jam.JSourcePosition"%>
<%@page import="com.lymava.wechat.gongzhonghao.GongzonghaoContent"%>
<%@page import="com.lymava.wechat.gongzhonghao.Gongzonghao"%>
<%@page import="com.lymava.base.util.ContextUtil"%>
<%@page import="com.lymava.nosql.context.SerializContext"%>
<%@page import="com.lymava.nosql.mongodb.util.MongoCommand"%>
<%@page import="com.lymava.base.model.User"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	GongzonghaoContent gongzonghaoContent = GongzonghaoContent.getInstance();

	Gongzonghao gongzonghao = gongzonghaoContent.getDefaultGongzonghao();
	
	String next_openid = null;
	
	
	boolean is_run  = true;
	
	while(is_run){
	
		String getGuanzhuUserList_str = gongzonghao.getGuanzhuUserList(next_openid);
		
		JsonObject getGuanzhuUserList = JsonUtil.parseJsonObject(getGuanzhuUserList_str);
		
		JsonObject jsonObject_data = JsonUtil.getRequestJsonObject(getGuanzhuUserList, "data");
		
		next_openid = JsonUtil.getString(getGuanzhuUserList, "next_openid");
		
		JsonArray openid_jsonArray = JsonUtil.getRequestJsonArray(jsonObject_data, "openid");
		
		if(openid_jsonArray == null){
			out.println(getGuanzhuUserList_str);
			is_run = false;
			break;
		}
		
		for(JsonElement jsonElement:openid_jsonArray){
			
			String openid_tmp = jsonElement.getAsString();
			
			SubscribeUser subscribeUser_find = new SubscribeUser();
			subscribeUser_find.setOpenid(openid_tmp);
			
			subscribeUser_find = (SubscribeUser)ContextUtil.getSerializContext().get(subscribeUser_find);
			 
			
			if(subscribeUser_find == null || MyUtil.isEmpty(subscribeUser_find.getUnionid())){
				
				SubscribeUser subscribeUser = gongzonghao.getSubscribeUserInfo(openid_tmp);
					
				subscribeUser.setId(new ObjectId().toString());
				subscribeUser.setGongzonghao(gongzonghao);
				
				if(subscribeUser_find != null){
					subscribeUser.setId(subscribeUser_find.getId());	
				}else{
					out.println(openid_tmp);
				}
					
				out.println(subscribeUser.getNickname()+" <br/>\n");
				ContextUtil.getSerializContext().save(subscribeUser);
			} 
			
		}
		
		is_run = !MyUtil.isEmpty(next_openid);
	}
	
	
%>