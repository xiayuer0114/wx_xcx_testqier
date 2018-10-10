<%@ page language="java" contentType="text/html; charset=UTF-8"
		 pageEncoding="UTF-8"%><%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="utf-8" />
		<meta name="viewport" content="width=device-width, initial-scale=1.0">
	    <meta content="yes" name="apple-mobile-web-app-capable">
	    <meta content="telephone=no,email=no" name="format-detection">
	    <meta content="yes" name="apple-touch-fullscreen">
	    <meta http-equiv="X-UA-Compatible" content="ie=edge">
	    <meta content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0" name="viewport" /><!-- 屏蔽双击缩放 -->
	    <link rel="stylesheet" type="text/css" href="css/shengmuti.css"/>
	    <script type="text/javascript" src="js/jquery-1.12.4.min.js" ></script> 
		<script type="text/javascript">
			$(function(){
				var window_width = $(window).width();
				var rem_font_size = window_width*10/75;
				$("html").css("font-size",rem_font_size+"px");
			}); 
		</script>
	</head>
	<body style="background-image: url(img/beijing1.png); background-size: 100% 100%;">
		<div class="logo">  
			<img src="img/logo.png" />
		</div>
		<div class="zhuti">
			<img src="img/zhuti.png" />
		</div>
		<div class="zhutibeijing">
			<img src="img/yuanjiaojuxing.png" />
			<div class="zhutibeijing_1">
				<img src="img/diandan.png" />
			</div>
		</div>
		<div class="wenzi">
			<div class="wenzi_1">点单时，最容易放飞自我</div>
			<div class="wenzi_2">一不小心就暴露了自己的隐藏属性</div>
			<div class="wenzi_3">从点餐动作和喜好</div>
			<div class="wenzi_4">发现你不知道的那一面</div>
		</div>
		<div class="fenggexian">
			<img src="img/fengexian.png" />
		</div>
		<div class="sidaoti">
			<img src="img/sidaoti.png" />
		</div>
		<div class="xingming">
			<input type="text" id="name" placeholder="请输入你的姓名" style="">
		</div>
		<div class="kaishi">
			<a id="kaishi"><img src="img/kaishi.png" /></a>
		</div>
		
	</body>
	<script type="text/javascript">
		$("#kaishi").click(function () {
			var name=$("#name").val();
			if(name!=""){
                window.location.replace("/activities/XingGeTest/index1.jsp?name="+name);
			}else {

			}
        });
	</script>
<html>