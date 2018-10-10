<%@page import="java.util.Iterator"%>
<%@page import="com.lymava.nosql.util.PageSplit"%>
<%@page import="com.lymava.base.model.BalanceLog"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ include file="../header/check_openid.jsp"%>
<%@ include file="../header/header_check_login.jsp"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width,initial-scale=1,minimum-scale=1,maximum-scale=1,user-scalable=no" />
    <title>悠择YORZ-我的红包</title>
    <link rel="stylesheet" type="text/css" href="${basePath }user_center/css/index.css"/>
	<link rel="stylesheet" type="text/css" href="${basePath }user_center/layui-v2.2.5/layui/css/layui.css"/>
	<link rel="stylesheet" href="${basePath }user_center/css/my-red.css" />

	<script type="text/javascript" src="${basePath }merchant_show/js/jquery-1.11.0.js"></script>
</head>
	<body>
		<div class="container" id="containerBody">
			<!--banner-->
			<div class="header c-b layui-col-xs12">
				<div>
					<img src="images/hongbao_02.jpg" />
				</div>
				<div class="pos-r box-1">
					<img src="images/hongbao_03.jpg" />
					<div class="red-text pos-a">红包总金额</div>
				</div>
				<div class="pos-r box-2">
					<img src="images/hongbao_04.jpg" />
					<div class="red-text1 pos-a">+${front_user.availableBalanceFen/100 }元</div>
				</div>
				<div class="pos-r box-3">
					<img src="images/hongbao_05.jpg" />
				</div>
			</div>
			<div class="title">
				钱包明细
			</div>
			<c:forEach var="balanceLog" items="${balanceLogIterator }">
			<div class="title-box">
				<img src="images/hongbao1.png" />
				<div class="title-box1 fl">
					<div style="font-size: 1.2em;">
						<c:if test="${balanceLog.count > 0 }">获得红包</c:if>
						<c:if test="${balanceLog.count < 0 }">钱包支付</c:if>
					</div>
					<div style="font-size: 1em;">
						${balanceLog.showTime }
					</div>
				</div>
				<div class="title-box2">
					<c:if test="${balanceLog.count > 0 }">+</c:if>${balanceLog.countYuan }元
				</div> 
			</div>
			</c:forEach>
		</div>
	</body>

<script type="text/javascript">

    var page_temp = 1;

	$(function () {
        $.post("${basePath}user_center/my-red-more.jsp",{"page":page_temp},function (data) {
            $("#containerBody").append(data);
		});
    });




    // 事件监听  上拉到底部加载数据
    window.onscroll = function () {
        //监听事件内容
        if(getScrollHeight() <= getWindowHeight() + getDocumentTop()){
            //当滚动条到底时,这里是触发内容
            //异步请求数据,局部刷新dom
            ++page_temp;
            $.post("${basePath}user_center/my-red-more.jsp",{"page":page_temp},function (data) {
                $("#containerBody").append(data);
            });
        }
    }
    //文档高度
    function getDocumentTop() {
        var scrollTop = 0, bodyScrollTop = 0, documentScrollTop = 0;
        if (document.body) {
            bodyScrollTop = document.body.scrollTop;
        }
        if (document.documentElement) {
            documentScrollTop = document.documentElement.scrollTop;
        }
        scrollTop = (bodyScrollTop - documentScrollTop > 0) ? bodyScrollTop : documentScrollTop;    return scrollTop;
    }
    //可视窗口高度
    function getWindowHeight() {
        var windowHeight = 0;    if (document.compatMode == "CSS1Compat") {
            windowHeight = document.documentElement.clientHeight;
        } else {
            windowHeight = document.body.clientHeight;
        }
        return windowHeight;
    }
    //滚动条滚动高度
    function getScrollHeight() {
        var scrollHeight = 0, bodyScrollHeight = 0, documentScrollHeight = 0;
        if (document.body) {
            bodyScrollHeight = document.body.scrollHeight;
        }
        if (document.documentElement) {
            documentScrollHeight = document.documentElement.scrollHeight;
        }
        scrollHeight = (bodyScrollHeight - documentScrollHeight > 0) ? bodyScrollHeight : documentScrollHeight;    return scrollHeight;
    }
</script>

</html>
