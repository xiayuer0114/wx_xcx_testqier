<%@page import="com.lymava.commons.state.State"%>
<%@page import="com.lymava.qier.activities.model.GaokaoChengji"%>
<%@page import="java.util.Iterator"%>
<%@page import="com.lymava.nosql.util.PageSplit"%>
<%@page import="com.lymava.base.model.BalanceLog"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ include file="../../header/check_openid.jsp"%>
<%@ include file="../../header/header_check_login.jsp"%>
<%
	String user_name = request.getParameter("user_name");
	String sex = request.getParameter("sex");
	String kemu = request.getParameter("kemu");
	String xuexiao = request.getParameter("xuexiao");
	
	GaokaoChengji gaokaoChengji = new GaokaoChengji();
	gaokaoChengji.setOpenid(openid_header);
	
	gaokaoChengji = (GaokaoChengji)serializContext.get(gaokaoChengji);
	
	if(gaokaoChengji == null){
		gaokaoChengji = new GaokaoChengji();
	}
	
	gaokaoChengji.setOpenid(openid_header); 
	gaokaoChengji.setUser_name(user_name);
	gaokaoChengji.setSex(sex);
	gaokaoChengji.setKemu(kemu);
	gaokaoChengji.setXuexiao(xuexiao);
	gaokaoChengji.setState(State.STATE_WAITE_PROCESS);
	
	serializContext.save(gaokaoChengji);
	
	
	request.setAttribute("xuexiao", xuexiao);
	request.setAttribute("user_name", user_name);
	request.setAttribute("sex", sex);
	request.setAttribute("kemu", kemu);
%>
<!DOCTYPE html>
<html style="font-size: 100px;">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	
	<meta name="viewport" content="width=375,initial-scale=1,minimum-scale=1,maximum-scale=1,user-scalable=no" />
	
	<meta name="format-detection" content="telephone=no">
	<meta http-equiv="X-UA-Compatible" content="ie=edge">
	
	<script type="text/javascript" >var basePath = '${basePath}';</script>
	
	<script type="text/javascript" src="${basePath }plugin/js/jquery/jquery-1.12.4.min.js" ></script>
    <script type="text/javascript" src="${basePath }plugin/js/lymava_common.js?r=<%=System.currentTimeMillis()%>"></script>
    
    <script type="text/javascript" src="${basePath }activities/gaokao/js/project.js" ></script>
	
	<link rel="stylesheet" type="text/css" href="css/layui.css"/>
	
		<link rel="stylesheet" href="${basePath }plugin/js/layer_mobile/need/layer.css">
	<script type="text/javascript"	src="${basePath }plugin/js/layer_mobile/layer.js"></script>
	
	<link rel="stylesheet" href="css/gaokao.css">
	<title>高考</title> 
<body>
	 <div class="layui-container" style="position: relative;padding: 0;margin: 0;">
	 	  <div class="layui-row"  > 
			<img alt="" src="image/step4_code.jpg" style="width: 100%;">			    
		  </div> 
	 </div>
</body>
</html>


