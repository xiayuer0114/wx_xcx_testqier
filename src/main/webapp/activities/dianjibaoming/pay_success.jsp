<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/header/check_openid.jsp"%>
<%@ include file="/header/header_check_login.jsp"%>
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
				
				alertMsg_correct("亲,您已报名成功!");
			}); 
		</script>
		<script type="text/javascript">
			var pay_method = '<%=PayFinalVariable.pay_method_weipay%>';
		</script>
	<body style="background-image: url(img/827810056574090719.png); background-size: 100%;">
		
	</body>
</html>
