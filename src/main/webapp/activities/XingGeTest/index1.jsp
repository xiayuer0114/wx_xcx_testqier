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
	    <link rel="stylesheet" type="text/css" href="css/shengmuti1.css"/>
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
		<div class="zhuti">
			<img src="img/zhuti.png" />
		</div>
		<div class="zhutibeijing">
			<img src="img/zhutimu.png" />
		</div>
		<div class="wenti">
			<img src="img/biaoti1.png" />
		</div>
		<div class="huida">
			<div class="huida_1">
				<img src="img/1A.png" id="1A"/>
			</div>
			<div class="huida_2">
				<img src="img/1B.png" id="1B"/>
			</div>
			<div class="huida_3">
				<img src="img/1C.png" id="1C"/>
			</div>
			<div class="huida_4">
				<img src="img/1D.png" id="1D"/>
			</div>
			<div class="huida_5">
				<img src="img/1E.png" id="1E"/>
			</div>
		</div>
		<%--<div class="ok">--%>
			<%--<img  src="img/OK.png" id="ok" style="display: none;width: 1.12rem;height: 0.6rem;position: relative;left: 6rem;"/>--%>
		<%--</div>--%>
		
	</body>
	<%
		String name=request.getParameter("name");
		name=new String(name.getBytes("iso-8859-1"),"utf-8");
		request.setAttribute("name",name);
	%>
	<script type="text/javascript">

		var A_daan=0;var B_daan=0;var C_daan=0;var D_daan=0;var E_daan=0;

		$("#1A").click(function () {
			$("#1A").attr('src','img/1A_.png');
            $("#1B").attr('src','img/1B.png');
            $("#1C").attr('src','img/1C.png');
            $("#1D").attr('src','img/1D.png');
            $("#1E").attr('src','img/1E.png');
            $("#ok").css('display','block');
            A_daan=1;B_daan=0; C_daan=0; D_daan=0;E_daan=0;
            tiaozhuan();
		});
        $("#1B").click(function () {
            $("#1A").attr('src','img/1A.png');
            $("#1B").attr('src','img/1B_.png');
            $("#1C").attr('src','img/1C.png');
            $("#1D").attr('src','img/1D.png');
            $("#1E").attr('src','img/1E.png');
            $("#ok").css('display','block');
            A_daan=0;B_daan=2; C_daan=0; D_daan=0;E_daan=0;
            tiaozhuan();
        });
        $("#1C").click(function () {
            $("#1A").attr('src','img/1A.png');
            $("#1B").attr('src','img/1B.png');
            $("#1C").attr('src','img/1C_.png');
            $("#1D").attr('src','img/1D.png');
            $("#1E").attr('src','img/1E.png');
            $("#ok").css('display','block');
            A_daan=0;B_daan=0; C_daan=3; D_daan=0;E_daan=0;
            tiaozhuan();
        });
        $("#1D").click(function () {
            $("#1A").attr('src','img/1A.png');
            $("#1B").attr('src','img/1B.png');
            $("#1C").attr('src','img/1C.png');
            $("#1D").attr('src','img/1D_.png');
            $("#1E").attr('src','img/1E.png');
            $("#ok").css('display','block');
            A_daan=0;B_daan=0; C_daan=0; D_daan=4;E_daan=0;
            tiaozhuan();
        });
        $("#1E").click(function () {
            $("#1A").attr('src','img/1A.png');
            $("#1B").attr('src','img/1B.png');
            $("#1C").attr('src','img/1C.png');
            $("#1D").attr('src','img/1D.png');
            $("#1E").attr('src','img/1E_.png');
            $("#ok").css('display','block');
            A_daan=0;B_daan=0; C_daan=0; D_daan=0;E_daan=5;
            tiaozhuan();
        });

        function tiaozhuan () {
//            var url = decodeURI(window.location.href);
//            var argsIndex = url .split("?name=");
            var test_name = '${name}';
            var yiti_daan=A_daan+B_daan+C_daan+D_daan+E_daan;
            window.location.replace("${basePath}/activities/XingGeTest/index2.jsp?yiti_daan="+yiti_daan+"&test_name="+test_name);
        };
	</script>
<html>