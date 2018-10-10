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
	 	  <div class="layui-row" style="position: absolute;top: 0;left: 0;top:0;"> 
			<img alt="" src="image/bg2.jpg" style="width: 100%;">			    
		  </div>
		  <div class="layui-row" style="padding-top: 0.7rem;">
			    <div class="layui-col-xs6">
			       &nbsp;
			    </div>
			    <div class="layui-col-xs6">
			      <img alt="" src="image/header_step3.png" style="width: 1.9rem;margin-left:-0.95rem;" >
			    </div>
		  </div>
		  <div class="layui-row xuexiao_row" style="padding-top: 0.3rem;">
			    <div class="layui-col-xs6">
			       &nbsp;
			    </div>
			    <div class="layui-col-xs6">
			      <img alt="" src="image/botton2.png" data="佩奇" style="width: 1.9rem;margin-left:-0.95rem;" >
			    </div>
		  </div> 
		   <div class="layui-row xuexiao_row">
			    <div class="layui-col-xs6">
			       &nbsp;
			    </div>
			    <div class="layui-col-xs6">
			      <img alt="" src="image/botton3.png" data="戒毒" style="width: 1.9rem;margin-left:-0.95rem;" >
			    </div>
		  </div> 
		  <div class="layui-row xuexiao_row">
			    <div class="layui-col-xs6">
			       &nbsp;
			    </div>
			    <div class="layui-col-xs6">
			      <img alt="" src="image/botton4.png" data="蓝翔" style="width: 1.9rem;margin-left:-0.95rem;" >
			    </div>
		  </div> 
		  <div class="layui-row xuexiao_row">
			    <div class="layui-col-xs6">
			       &nbsp;
			    </div>
			    <div class="layui-col-xs6">
			      <img alt="" src="image/botton5.png" data="新东方" style="width: 1.9rem;margin-left:-0.95rem;" >
			    </div>
		  </div> 
		  <div class="layui-row xuexiao_row">
			    <div class="layui-col-xs6">
			       &nbsp;
			    </div>
			    <div class="layui-col-xs6">
			      <img alt="" src="image/botton6.png" data="哈尔滨" style="width: 1.9rem;margin-left:-0.95rem;" >
			    </div>
		  </div> 
		  <div class="layui-row xuexiao_row">
			    <div class="layui-col-xs6">
			       &nbsp;
			    </div>
			    <div class="layui-col-xs6">
			      <img alt="" src="image/botton7.png" data="北大青鸟" style="width: 1.9rem;margin-left:-0.95rem;" >
			    </div>
		  </div> 
		  <form action="${basePath }activities/gaokao/step4.jsp" name="jump_to_step4_form" method="post"	 >	 
		  	<input   type="hidden"    name="user_name"  value="${user_name }">
		  	<input   type="hidden"    name="sex"  value="${sex }">
		  	<input   type="hidden"    name="kemu"  value="${kemu }">
		  	<input id="xuexiao"  type="hidden"    name="xuexiao"  value="">
			  <div class="layui-row" style="padding-top: 0.2rem;">
				    <div class="layui-col-xs6">
				       &nbsp;
				    </div>
				    <div class="layui-col-xs6">
				      <img onclick="document.forms['jump_to_step4_form'].submit()"  class="btn_tijiao" src="image/botton9.png" style="width: 1.9rem;margin-left:-1rem;" >
				    </div>
			  </div> 
		  </form>
	 </div>
</body>
</html>


