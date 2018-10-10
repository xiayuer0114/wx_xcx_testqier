<%@page import="java.util.Iterator"%>
<%@page import="com.lymava.nosql.util.PageSplit"%>
<%@page import="com.lymava.base.model.BalanceLog"%>
<%@ page import="com.lymava.commons.util.*" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.text.ParseException" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ include file="../../header/check_openid.jsp"%>
<%@ include file="../../header/header_check_login.jsp"%>
<%
	String startTime_str = WebConfigContent.getConfig("caididian_startTime");
	String endTime_str = WebConfigContent.getConfig("caididian_endTime");

	try {
		//活动是否开始
		Date startTimeDate = DateUtil.getSdfFull().parse(startTime_str);
		if (new Date().after(startTimeDate)) {
			request.setAttribute("isStart", true);
		}

		//活动是否结束
		Date endTimeDate = DateUtil.getSdfFull().parse(endTime_str);
		if (new Date().after(endTimeDate)) {
			request.setAttribute("isEnd", true);
		}

	} catch (ParseException e) {
	}
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
		<script src="js/jquery-1.11.0.js" type="text/javascript"></script>

	</head>


	<body>
		<div class="guess_choose">
			<div class="guess1">
				<img src="img/1_01.jpg" style="display: block;"/>
			</div>
			<div class="guess1-1">
				<div class="guess1-1_01">
					<img src="img/1_02.jpg"/>
				</div>
				<div class="guess1-1_02">
					<img src="img/botton1.png" id="id_game_begin"/>
				</div>
			</div>

			<div class="guess1-2">
				<img src="img/1_03.jpg"/>
			</div>
		</div>

		<!--活动规则-->
		<div class="guess_rule" style="position: absolute;" <c:if test="${empty isEnd}">hidden="hidden"</c:if>>
			<div class=""style="height: 10rem;width: 100%;"> </div>
			<div class="guess_rule1" style="position: relative;">
				<img src="img/rule2.png"/>
			</div>
		</div>

		<c:if test="${not empty status}">
			<div class="guess_choose1" style="text-align: center; position:absolute; top:0; left:0;" id="id_guess_choose1">
				<c:if test="${status == 'false'}">
					<img src="img/hint_fail.png" style="width: 15rem; padding-top: 12rem;">
				</c:if>
				<c:if test="${status == 'true'}">
					<img src="img/hint_success.png" style="width: 15rem; padding-top: 12rem;">
				</c:if>
			</div>
		</c:if>

	</body>

<script>

	//点击猜地点
	$("#id_game_begin").click(function () {
		window.location.href = "${basePath}activities/caididian/action_getPageAndDeal.jsp?page=1";
    });

	//div guess_choose1隐藏
	$("#id_guess_choose1").click(function () {
        $(this).attr("hidden", "hidden");
    });

</script>
</html>
