<%@page import="com.lymava.commons.state.StatusCode"%>
<%@page import="com.google.gson.JsonObject"%>
<%@page import="com.lymava.commons.util.Md5Util"%>
<%@page import="com.lymava.commons.util.MyUtil"%>
<%@page import="com.lymava.qier.util.QierUtil"%>
<%@page import="com.lymava.base.util.ContextUtil"%>
<%@page import="com.lymava.qier.model.Merchant72"%>
<%@page import="com.lymava.commons.util.MathUtil"%>
<%@page import="com.lymava.commons.exception.CheckException"%>
<%@page import="com.lymava.userfront.util.FrontUtil"%>
<%@page import="com.lymava.base.model.User"%>
<%@page import="com.lymava.commons.state.State"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
	User front_user = FrontUtil.init_http_user(request);
	request.setAttribute("front_user", front_user);
	
	CheckException.checkIsTure(front_user != null, "登录超时,请重新登录!");
	
	Merchant72 merchant72 = QierUtil.getMerchant72User(front_user);
	request.setAttribute("merchant72", merchant72);
	
	CheckException.checkIsTure(merchant72 != null, "登录超时,请重新登录!");
	 
	
    String setSelHour = request.getParameter("selHour");
    String state_auto_voice_str = request.getParameter("state_auto_voice");
    String state_shaoma_yuzhi_str = request.getParameter("state_shaoma_yuzhi");
    
    Integer state_auto_voice =  MathUtil.parseInteger(state_auto_voice_str);
    Integer state_shaoma_yuzhi =  MathUtil.parseInteger(state_shaoma_yuzhi_str);
    
   
    
    Integer SelHour = MathUtil.parseInteger(setSelHour);

    Merchant72 merchant72_update = new Merchant72();
    
    merchant72_update.setQueryHour(SelHour);
    merchant72_update.setState_auto_voice(state_auto_voice);
    merchant72_update.setState_shaoma_yuzhi(state_shaoma_yuzhi);

    ContextUtil.getSerializContext().updateObject(front_user.getId(),merchant72_update);
	
	JsonObject jsonObject_return = new JsonObject();
	 
	jsonObject_return.addProperty(StatusCode.statusCode_key, StatusCode.ACCEPT_OK);
	jsonObject_return.addProperty(StatusCode.statusCode_message_key, "设置成功！");
			 
	out.print(jsonObject_return.toString());
%>