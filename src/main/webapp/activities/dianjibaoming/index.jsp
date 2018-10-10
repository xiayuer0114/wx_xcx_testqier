<%@page import="com.lymava.trade.pay.model.PaymentRecord"%>
<%@page import="com.lymava.userfront.util.FrontUtil" %>
<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/header/check_openid.jsp"%>
<%@ include file="/header/header_check_login.jsp"%>
<%
	//user
	User user_huiyuan = FrontUtil.init_http_user(request);
	
	String user_id=user_huiyuan.getId();
	//ST.Moti圣慕缇
	String userId_merchant = "5b309e497d170b366d56a674"; 
	
	PaymentRecord paymentRecord_find=	new PaymentRecord();
	
	paymentRecord_find.setUserId_huiyuan(user_id);
	paymentRecord_find.setUserId_merchant(userId_merchant);
	paymentRecord_find.setState(State.STATE_PAY_SUCCESS);
	
	
	PaymentRecord 	paymentRecord=	(PaymentRecord)serializContext.findOne(paymentRecord_find);
	//如果查找到，说明该用户在该商家的此次活动已经付过款，则直接跳转成功支付的页面
	if(paymentRecord !=null){
		response.sendRedirect(MyUtil.getBasePath(request)+"activities/dianjibaoming/pay_success.jsp");
		//return ;
	}
	request.setAttribute("userId_merchant", userId_merchant);
%> 
<!DOCTYPE html>
<html>
	<head>
		<meta charset="utf-8" />
		<meta name="viewport" content="width=device-width, initial-scale=1.0">
	    <meta content="yes" name="apple-mobile-web-app-capable">
	    <meta content="telephone=no,email=no" name="format-detection">
	    <meta content="yes" name="apple-touch-fullscreen">
	    <meta http-equiv="X-UA-Compatible" content="ie=edge">
	    <meta content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0" name="viewport" />
	    <script type="text/javascript" >var basePath = '${basePath}';</script>
	    <link rel="stylesheet" type="text/css" href="css/new_file.css"/>
	    <script type="text/javascript" src="js/jquery-1.12.4.min.js" ></script> 	
	    <script src="mui/js/mui.min.js"></script>
	    <script type="text/javascript" src="${basePath }plugin/js/layer_mobile/layer.js"></script>
	   	<link rel="stylesheet" href="${basePath }plugin/js/layer_mobile/need/layer.css">
	    <script type="text/javascript" src="${basePath }plugin/js/lymava_common.js?r=2018-08-15"></script>
	    <script type="text/javascript" src="${basePath }activities/dianjibaoming/js/project.js?r=2018-08-15"></script>
	    
    	<link href="mui/css/mui.min.css" rel="stylesheet"/>
		<script type="text/javascript">
			$(function(){
				var window_width = $(window).width();
				var rem_font_size = window_width*10/75;
				$("html").css("font-size",rem_font_size+"px");
			}); 
			var userId_merchant = '${userId_merchant}';
		</script>
		
		<script type="text/javascript">
			$(function(){
				//alert("--------------");
				//判断是否已经支付完成，完成则直接跳转成功页面
				//redirectPage(basePath+"activities/dianjibaoming/pay_success.jsp");
			}); 
		</script>
		
		<script type="text/javascript">
			var pay_method = '<%=PayFinalVariable.pay_method_weipay%>';
		</script>
		
		
	<body style="background-image: url(img/1.png); background-size: 100%;" >
		<div class="mui-active">
			<img src="img/03.png" onclick="create_paymentrecord()"/>
		</div>
	</body>
</html>
