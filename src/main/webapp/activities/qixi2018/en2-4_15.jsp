<%@page import="com.lymava.qier.model.Merchant72"%>
<%@page import="java.util.Random"%>
<%@page import="java.util.List"%>
<%@page import="com.lymava.commons.util.MathUtil"%>
<%@page import="java.util.Iterator"%>
<%@page import="com.lymava.nosql.util.PageSplit"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ include file="/header/check_openid.jsp"%>
<%@ include file="/header/header_check_login.jsp"%>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="utf-8" />
		<title>七夕-摁si情侣-答题页5</title>
		<meta name="viewport" content="width=device-width, initial-scale=1.0">
	    <meta content="yes" name="apple-mobile-web-app-capable">
	    <meta content="telephone=no,email=no" name="format-detection">
	    <meta content="yes" name="apple-touch-fullscreen">
	    <meta http-equiv="X-UA-Compatible" content="ie=edge">
	    <meta content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0" name="viewport" /><!-- 屏蔽双击缩放 -->
	    <link rel="stylesheet" type="text/css" href="css/en.css"/>
		<script type="text/javascript" >var basePath = '${basePath}';</script>
	    <link rel="stylesheet" href="${basePath }plugin/js/layer_mobile/need/layer.css">
		<script type="text/javascript" src="${basePath }plugin/js/layer_mobile/layer.js"></script>
		<script type="text/javascript" src="${basePath }plugin/js/jquery/jquery-1.12.4.min.js"></script>
		<script type="text/javascript" src="${basePath }plugin/js/lymava_common.js?r=2018-08-15"></script>
		<script type="text/javascript" src="${basePath }activities/qixi2018/js/project.js?r=2018-08-15"></script>
		<style type="text/css">
			#qingliang .layui-m-layerchild{
				background-color: inherit;
			}
			/*弹窗*/
			.cool_both{position: absolute;}
			.Pop-ups_3{height:100vh;width:100%;background:url(${basePath }activities/qixi2018/img/bg.png) no-repeat;background-size:100% 100%;position: relative;text-align: center;}
			.Pop1_u{width: 92%;position: absolute;}
			.Pop1_u img{width: 3.8rem;padding-top: 35%;float: right;}
			.Pop2_u{width: 70%;margin: 0 auto;padding-top: 40%;}
			.Pop2_u img{width: 100%;}
		</style>
		<script type="text/javascript">
			$(function(){
				
			}); 
		</script>
	</head>
	<body id="qingliang" style="height:100vh;width:100%;background:url(${basePath }activities/qixi2018/img/bg1-1.jpg) no-repeat;background-size:100% 100%;">
		<div class="en2_15">
			<img src="img/bg2.jpg"/>
		</div>
		
		<div class="en2-1_15">
			<div class="en2-11_15">
				<img src="img/_01.jpg"/>
			</div>
			<div class="en2-12_15">
				<img src="img/problem5.png"/>
			</div>
			<div class="en2-13_15">
				<img src="img/problem51.png" />
			</div>
			<div class="en2-13_15">
				<img src="img/problem52.png" />
			</div>
			<div class="en2-13_15">
				<img src="img/problem53.png" />
			</div>
			<div class="en2-15_15">
				<img onclick="show_subscript(this)" src="img/botton3.png" />
			</div>
		</div> 
		 <!--弹窗-->
		<div class="Pop-ups_3" style="display: none;">
			<div class="Pop1_u">
				<img src="img/cuo.png" onclick="layer.closeAll()"/>
			</div>
			<div class="Pop2_u">
				<img class="Pop2_u_img" src="${basePath }activities/qixi2018/img/guanzhu.jpeg"/>
			</div>
		</div>
		
	</body>
</html>
