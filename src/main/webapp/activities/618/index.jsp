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
		<meta charset="UTF-8">
		<title>上线活动</title>
	    <meta name="viewport" content="width=device-width, initial-scale=1.0">
	    <meta content="yes" name="apple-mobile-web-app-capable">
	    <meta content="telephone=no,email=no" name="format-detection">
	    <meta content="yes" name="apple-touch-fullscreen">
	    <meta http-equiv="X-UA-Compatible" content="ie=edge">
	    <meta content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0" name="viewport" /><!-- 屏蔽双击缩放 -->
		<script type="text/javascript"	src="${basePath }plugin/js/jquery/jquery-1.12.4.min.js"></script>
		<script type="text/javascript" >var basePath = '${basePath}';</script>
		<link rel="stylesheet" type="text/css" href="${basePath }activities/618/css/online.css"/>
	</head>
	<script type="text/javascript">
		
			var id_of_setinterval = null;
			
			var fanzhuan_running = false;
		
			$(function(){
				$('.chai_img').on('click',function(){
					if(!fanzhuan_running){
						id_of_setinterval = setInterval(start_fanzhuan, 16);
						fanzhuan_running = true;
					}
					
					setTimeout(redirect_next_step,500);
				});
			});
			var rotate_count = 0;
			function start_fanzhuan(){
				$('.chai_img').css("transform","rotateY("+rotate_count+"deg)");
				rotate_count += 12;
				if(rotate_count > 360){
					rotate_count = 0;
				}
			}
			
			/**
			 * 	
			 * @returns
			 */
			function redirect_next_step(){ 
				document.forms["share_to_friends_circle_form"].submit();
			}
		</script>
	<body style="height:100vh;width:100%;background:url(img/bg.jpg) no-repeat;background-size:100% 100%;">
		<form name="share_to_friends_circle_form" action="${basePath }activities/618/share_to_friends_circle.jsp">
		</form>
		<div class="online_14">
			<div class="online_14_tear">
				<img class="chai_img" src="img/chai.png"/>
			</div>
		</div>
	</body>
</html>
