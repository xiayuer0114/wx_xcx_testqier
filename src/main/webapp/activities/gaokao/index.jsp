<%@page import="java.util.Iterator"%>
<%@page import="com.lymava.nosql.util.PageSplit"%>
<%@page import="com.lymava.base.model.BalanceLog"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ include file="../../header/check_openid.jsp"%>
<%@ include file="../../header/header_check_login.jsp"%>
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
	
	<link rel="stylesheet" type="text/css" href="${basePath }activities/gaokao/css/layui.css"/>
	<link rel="stylesheet" href="${basePath }activities/gaokao/css/gaokao.css">
	
	<link rel="stylesheet" href="${basePath }plugin/js/layer_mobile/need/layer.css">
	<script type="text/javascript"	src="${basePath }plugin/js/layer_mobile/layer.js"></script>
	
	<title>成绩查询</title> 
<body>
	 <div class="layui-container" style="position: relative;padding: 0;margin: 0;">
	 	<form action="${basePath }activities/gaokao/step2.jsp" name="jump_to_step2_form" method="post"	 >	 
	 	 <div class="layui-row" style="position: absolute;top: 0;left: 0;top:0;">
			<img alt="" src="image/bg1.jpg" style="width: 100%;">			    
		  </div>
		  <div class="layui-row" style="padding-top: 1.45rem;">
			    <div class="layui-col-xs6">
			       &nbsp;
			    </div>
			    <div class="layui-col-xs6">
			      <img alt="" src="image/font.png" style="width: 1.9rem;margin-left:-0.95rem;" >
			    </div>
		  </div>
		  <div class="layui-row user_name_row" >
		  		<div class="layui-col-xs6">
			       &nbsp;
			    </div>
			    <div class="layui-col-xs6">      
			      <input  id="user_name" class="user_name"  name="user_name" placeholder="请输入姓名" >
	    </div> 
		  </div>
		  <div class="layui-row sex_row" >
		  		<div class="layui-col-xs4" style="text-align: right;font-size: 0.2rem;">
			       少男 
			    </div>
			    <div class="layui-col-xs2">
			       <input name="sex" type="radio" value="少男">
			    </div>
			    <div class="layui-col-xs3" style="text-align: right;font-size: 0.2rem;">     
			       少女
			    </div> 
			    <div class="layui-col-xs3">     
			       <input name="sex" type="radio" value="少女">
			    </div> 
		  </div>
		  <div class="layui-row sex_row_2" >
		  		<div class="layui-col-xs4" style="text-align: right;font-size: 0.2rem;">
			       文科
			    </div>
			    <div class="layui-col-xs2">
			        <input name="kemu" type="radio" value="文科">
			    </div>
			    <div class="layui-col-xs3" style="text-align: right;font-size: 0.2rem;">     
			       理科
			    </div> 
			    <div class="layui-col-xs3">     
			        <input name="kemu" type="radio" value="理科">
			    </div> 
		  </div>
		  <div class="layui-row see_res_row" >
		  		<div class="layui-col-xs6" style="text-align: right;">
			       &nbsp;
			    </div>
			    <div class="layui-col-xs6">
			        <img class="btn btn_to_step2" alt="" src="image/botton1.png" style="width: 1.9rem;margin-left:-0.95rem;" >
			    </div> 
		  </div>
		  </form>
	 </div>
</body>
</html>


