<%@page import="com.lymava.commons.util.JsonUtil"%><%@page import="com.google.gson.JsonObject"%><%@page import="com.lymava.commons.util.MyUtil"%><%@page import="com.lymava.wechat.gongzhonghao.GongzonghaoContent"%><%@page import="com.lymava.wechat.gongzhonghao.Gongzonghao"%><%@page import="com.lymava.commons.util.HttpUtil"%><%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%><%
    
    //检查是否已经持有微信openid
    String openid = (String)session.getAttribute("openid");
    
    if(openid == null){
    	
	    String state = request.getParameter("state");
	    String code = request.getParameter("code");
	     
    }
    
    if(openid == null){
    	//String fullRequestPath = MyUtil.getBasePath(request)+HttpUtil.getFullRequestPath(request);
    	
		String app_id = "2018031602385554";
    	String redirect_uri = "http://tiesh.liebianzhe.com/qier/alipay_test/alipay_openid_auth_call_back.jsp";
    	String scope = "auth_base"; 
    	
    	String  create_recall_url = "https://openauth.alipay.com/oauth2/publicAppAuthorize.htm?app_id="+app_id+"&scope="+scope+"&redirect_uri="+redirect_uri;
    	response.sendRedirect(create_recall_url);
    	return;
	} 
%>