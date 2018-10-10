<%@page import="com.lymava.commons.cache.SimpleCache"%>
<%@page import="com.lymava.base.model.SimpleDbCacheContent"%>
<%@page import="com.lymava.base.model.SimpleDbCache"%>
<%@page import="com.lymava.nosql.context.SerializContext"%>
<%@page import="com.lymava.qier.model.Product72"%>
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
<%@ page import="java.util.Date" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
	User front_user = FrontUtil.init_http_user(request);
	request.setAttribute("front_user", front_user);
	
	CheckException.checkIsTure(front_user != null, "登录超时,请重新登录!");
	
	String product_72_id = request.getParameter("product_72_id");

    Product72 product72_find = new Product72();

    product72_find.setId(product_72_id);
    product72_find.setUserId_merchant(front_user.getId());
    SerializContext serializContext = ContextUtil.getSerializContext();
    product72_find = (Product72)serializContext.get(product72_find);
    CheckException.checkIsTure(product72_find != null, "收银牌不存在!");

	product72_find.clear_preset();

	JsonObject jsonObject_return = new JsonObject();
	 
	jsonObject_return.addProperty(StatusCode.statusCode_key, StatusCode.ACCEPT_OK);
	jsonObject_return.addProperty(StatusCode.statusCode_message_key, "清空成功！");
			 
	out.print(jsonObject_return.toString());
%>