<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ include file="/header/check_openid.jsp"%>
<%@ include file="/header/header_check_login.jsp"%>
<!DOCTYPE html>
<html>
	<meta charset="utf-8" />
		<title>圣慕缇:生活需要一点红</title>
		<meta name="viewport" content="width=device-width, initial-scale=1.0">
	    <meta content="yes" name="apple-mobile-web-app-capable">
	    <meta content="telephone=no,email=no" name="format-detection">
	    <meta content="yes" name="apple-touch-fullscreen">
	    <meta http-equiv="X-UA-Compatible" content="ie=edge">
	    <meta content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0" name="viewport" /><!-- 屏蔽双击缩放 -->
		<link rel="stylesheet" type="text/css" href="css/home_page.css"/>

		<script type="text/javascript" >var basePath = '${basePath}';</script>
		
	    <link rel="stylesheet" href="${basePath }plugin/js/layer_mobile/need/layer.css">
		<script type="text/javascript" src="${basePath }plugin/js/layer_mobile/layer.js"></script>
		
		<script type="text/javascript" src="${basePath }plugin/js/jquery/jquery-1.12.4.min.js"></script>
		<script type="text/javascript" src="${basePath }plugin/js/lymava_common.js?r=2018-09-27"></script>

		<script type="text/javascript" src="${basePath }activities/shengmuti/js/project.js?r=2018-09-27"></script>

		<script type="text/javascript">
			$(function(){
				var window_width = $(window).width();
				var rem_font_size = window_width*10/75;
				$("html").css("font-size",rem_font_size+"px");
			}); 
			
			function not_start_notice(){
				var message = "10月1日才开放哦，敬请期待。";
				alertMsg_info(message);
			}
			
			function not_start_notice_message(message){
				alertMsg_info(message);
			}
		</script>
	<body>
		
		<div class="home_page">
			<img src="img/bg.gif"/>
		</div>
		
		<div class="home_page1" style="width:100%;background:url(img/bg.jpg) no-repeat;background-size:100% 100%;">
			<div class="h_p1">
					<img src="img/title.png"/>
			</div>
			<div class="h_p2">
				<a href="${basePath }activities/PinPaiGuShi/daddy.html">
					<img src="img/one.png"/>
				</a>
			</div>
			<div class="h_p3">
				<a href="${basePath }activities/XingGeTest/index.jsp">
					<img src="img/two.png"/>
				</a>
			</div>
			<div class="h_p3">
				<a href="${basePath }activities/JiKaHuoDong/">
					<img  src="img/three.png"/>
				</a>
			</div>
			<div class="h_p3">
				<img  onclick="not_start_notice_message('活动筹备中,敬请期待。')" src="img/four.png"/>
			</div>
			<div class="h_p3">
				<a href="${basePath }activities/dianjibaoming/">
					<img   src="img/five.png"/>
				</a>
			</div>
		</div>
	</body>
</html>
