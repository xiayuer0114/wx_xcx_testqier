<%@page import="java.util.Iterator"%>
<%@page import="com.lymava.nosql.util.PageSplit"%>
<%@page import="com.lymava.base.model.BalanceLog"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ include file="../../header/check_openid.jsp"%>
<%@ include file="../../header/header_check_login.jsp"%>
<!DOCTYPE html>
<html>
	<head>
	<title>JAY迷刮刮卡</title>
    <meta charset="UTF-8">
    <meta content="yes" name="apple-mobile-web-app-capable">
    <meta content="telephone=no,email=no" name="format-detection">
    <meta content="yes" name="apple-touch-fullscreen">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0"  /><!-- 屏蔽双击缩放 -->
    
    <link rel="stylesheet" type="text/css" href="${basePath }activities/guaguaka/css/new_file.css"/>
    
    <script type="text/javascript" >var basePath = '${basePath}';</script>
	
	<script type="text/javascript" src="${basePath }plugin/js/jquery/jquery-1.12.4.min.js" ></script>
    <script type="text/javascript" src="${basePath }plugin/js/lymava_common.js?r=<%=System.currentTimeMillis()%>"></script>
    <script type="text/javascript" src="${basePath }activities/guaguaka/js/project.js" ></script>
	
	<link rel="stylesheet" type="text/css" href="${basePath }plugin/js/layer_ui/css/layui.css"/>
	
	<link rel="stylesheet" href="${basePath }plugin/js/layer_mobile/need/layer.css">
	<script type="text/javascript"	src="${basePath }plugin/js/layer_mobile/layer.js"></script>

	<script type="text/javascript">
		$(function(){
			var window_width = $(window).width();
			$("html").css("font-size",window_width/10+"px");
		}); 
	</script>

	</head>
	<body style="background:url(img/bg.png);">
		<div class="guagua1">
			<div class="gua_red">
				<img src="img/red.png"/>
			</div>
			<div class="gua_f">
				你中了：IPhone x手机一部！
			</div>
			<div class="gua_b">
				<img src="img/botton.png"/>
			</div>
		</div>
	</body>
</html>
