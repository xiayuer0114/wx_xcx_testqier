<%--
	朋友跳转的复活页面

 --%>
<%@ page import="com.lymava.commons.exception.CheckException" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
		 pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ include file="../../header/check_openid.jsp"%>
<%@ include file="../../header/header_check_login.jsp"%>
<%
	String current_page = request.getParameter("current_page");
	String origin_openid = request.getParameter("origin_openid");
	String didian_id = request.getParameter("didian_id");

	CheckException.checkNotNull(current_page, "参数有误，请重试");
	CheckException.checkNotNull(origin_openid, "参数有误，请重试");
	CheckException.isValid(didian_id, "参数有误，请重试");

	request.setAttribute("current_page", current_page);
	request.setAttribute("origin_openid", origin_openid);
	request.setAttribute("didian_id", didian_id);
%>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="utf-8" />
		<title>猜地点赢红包</title>
		<meta name="viewport" content="width=device-width, initial-scale=1.0">
	    <meta content="yes" name="apple-mobile-web-app-capable">
	    <meta content="telephone=no,email=no" name="format-detection">
	    <meta content="yes" name="apple-touch-fullscreen">
	    <meta http-equiv="X-UA-Compatible" content="ie=edge">
	    <meta content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0" name="viewport" /><!-- 屏蔽双击缩放 -->
	    <link rel="stylesheet" type="text/css" href="css/guess.css"/>

		<script type="text/javascript" >var basePath = '${basePath}';</script>
		<script type="text/javascript" src="${basePath }plugin/js/jquery/jquery-1.12.4.min.js" ></script>
		<script type="text/javascript" src="${basePath }plugin/js/lymava_common.js?r=<%=System.currentTimeMillis()%>"></script>

		<link rel="stylesheet" href="${basePath }plugin/js/layer_mobile/need/layer.css">
		<script type="text/javascript"	src="${basePath }plugin/js/layer_mobile/layer.js"></script>

		<script type="text/javascript"	src="${basePath }activities/caididian/js/project.js"></script>
	</head>
	
	
	<body>
		
		<div class="guess_choose">
			<div class="guess2-1">
				<img src="img/2_02.jpg" style="display: block;"/>
			</div>
			
			<div class="guess2-2">
				活动规则
			</div>
			<div class="clear"></div>
			
			<div class="guess2-3">
				<img src="img/2_02_1.jpg" style="display: block;"/>
			</div>
			<!--电视部分-->
			<div class="guess3-3 ">
				<div class="guess3-4_01">
					<img src="img/2_03.jpg" style="display: block; height: auto;"/>
				</div>
				<div class="guess2-4_02">
					<div class="gu2_01">
						<img src="img/left.png"/>
					</div>
					<div class="gu2_02">
						<img src="img/TV1-1.png"/>
					</div>
					<div class="gu2_03">
						<img src="img/right.png"/>
					</div>
				</div>
			</div>
			<div class="clear"></div>
			<!--搜索框部分-->
			<div class="guess3-1">
				你已经猜中这张老照片啦！ 
			</div>
			
			<div class="guess2-7">
				<img src="img/botton3.png" style="padding-top: 2.3rem;"/>
			</div>
			
			<div class="guess3-2">
				<img src="img/2_06.jpg"/>
			</div>
		</div>
		
		
		<!--助力-->
		<div class="guess_boost">
			<div class=""style="height: 10rem;width: 100%;"> </div>
			<div class="guess_boost1">
				<div class="g_boo">
					<img src="img/dui2.png"/>
				</div>
				<div class="g_boo1">
					<img src="img/ph.png"/>
				</div>
				<div class="g_boo2">
					你的朋友没猜中红包宝箱
				</div>

				<%-- 我也试试 --%>
				<div class="g_boo3" id="id_try">
					<img src="img/botton6.png"/>
				</div>
				
				<%-- 帮他复活 --%>
				<div class="g_boo4" id="id_relife">
					<img src="img/botton7.png"/>
				</div>
				<div class="" style="height: 2rem;width:100% ;"></div>
			</div>
		</div>
		
		
	</body>

	
<script>

	$("#id_try").click(function () {
		window.location.href = "${basePath}activities/caididian/index.jsp";
    });

    $("#id_relife").click(function () {
        window.location.href = "${basePath}activities/caididian/action_relife.jsp?current_page=${current_page}&origin_openid=${origin_openid}&didian_id=${didian_id}";
    });
	
</script>

</html>
