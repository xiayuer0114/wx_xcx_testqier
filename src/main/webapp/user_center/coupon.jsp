<%--
  Created by IntelliJ IDEA.
  User: Administrator
  Date: 2018\4\18 0018
  Time: 11:33
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../header/check_openid.jsp"%>
<%@ include file="../header/header_check_login.jsp"%>
<html>
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width,initial-scale=1,minimum-scale=1,maximum-scale=1,user-scalable=no" />
    <title>悠择YORZ-我的优惠券</title>
    <%--<link rel="stylesheet" type="text/css" href="${basePath }user_center/css/my_voucher.css"/>--%>

    <link rel="stylesheet" type="text/css" href="${basePath }user_center/css/index1.css"/>


    <link rel="stylesheet" type="text/css" href="${basePath }layui-v2.2.5/layui/css/layui.css"/>
	    
	<link rel="stylesheet" href="${basePath }plugin/js/layer_mobile/need/layer.css">
	<script type="text/javascript" src="${basePath }plugin/js/layer_mobile/layer.js"></script>
		
	<script type="text/javascript" src="${basePath }plugin/js/jquery/jquery-1.12.4.min.js"></script>
</head>
<body style="background-color:#e5e5e5;">
<div class="container" id="">
    <div id="bodyContainer">

    </div>
</div>
</body>
<script type="text/javascript">

    $(function () {
        $.post("${basePath}qier/orderReportContent/getMyAllVoucher.do",function (data) {
            $("#bodyContainer").html(data);
        });
    });

</script>
</html>
