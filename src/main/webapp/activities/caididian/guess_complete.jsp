<%@ page import="com.lymava.qier.activities.caididian.CaiDidianDaan" %>
<%@ page import="com.lymava.qier.activities.caididian.Didian" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
		 pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ include file="../../header/check_openid.jsp"%>
<%@ include file="../../header/header_check_login.jsp"%>
<%
	Didian diadian_currnet = (Didian) request.getAttribute("diadian_currnet");

	CaiDidianDaan caiDidianDaan_find =new CaiDidianDaan();
	caiDidianDaan_find.setOpenid(openid_header);
	caiDidianDaan_find.setDidian_id(diadian_currnet.getId());
	CaiDidianDaan caiDidianDaan = (CaiDidianDaan) serializContext.findOne(caiDidianDaan_find);

	if (caiDidianDaan != null)
		request.setAttribute("caiDidianDaan", caiDidianDaan);

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

			<div class="guess2-2" id="id_click_guess_rule">
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
					<%--<c:if test="${pageSplit.page > 1}">--%>
						<div class="gu2_01" id="id_left">
							<img src="img/left.png"/>
						</div>
					<%--</c:if>--%>
					<div class="gu2_02">
						<img src="${basePath}${diadian_currnet.picResult}"/>
					</div>
					<%--<c:if test="${pageSplit.page < pageSplit.count}">--%>
						<div class="gu2_03" id="id_right">
							<img src="img/right.png"/>
						</div>
					<%--</c:if>--%>
				</div>
			</div>
			<div class="clear"></div>

			<!--搜索框部分-->
			<div class="guess3-1">
				你已经猜中这张老照片啦！
			</div>

			<div class="guess2-7" id="id_click_open_box">
				<img src="img/botton3.png" style="padding-top: 2.3rem;"/>
			</div>

			<div class="guess3-2">
				<img src="img/2_06.jpg"/>
			</div>
		</div>

		<!--活动规则-->
		<div class="guess_rule" hidden="hidden" id="id_guess_rule">
			<div class=""style="height: 10rem;width: 100%;"> </div>
			<div class="guess_rule1">
				<img src="img/rule.png"/>
			</div>
		</div>

		<%@include file="inc/earnPrizes.jsp"%>

	</body>

	<script>
		//左右滑动图片
		$("#id_left").click(function () {
			window.location.href = "${basePath}activities/caididian/action_getPageAndDeal.jsp?page=${pageSplit.prePage}";
		});
		$("#id_right").click(function () {
			window.location.href = "${basePath}activities/caididian/action_getPageAndDeal.jsp?page=${pageSplit.nextPage}";
		});

		//活动规则（显示、隐藏）
		$("#id_click_guess_rule").click(function () {
			$("#id_guess_rule").removeAttr("hidden");
		});
		$("#id_guess_rule").click(function () {
			$(this).attr("hidden", "hidden");
		});

		//点击“开启记忆宝箱”
		$("#id_click_open_box").click(function () {
            $("#id_guess_ok_div").removeAttr("hidden");
        });

        //动态div显示隐藏
        $("#id_guess_ok_div").click(function () {
            $(this).attr("hidden", "hidden");
        });
	</script>
</html>
