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
	    <link rel="stylesheet" type="text/css" href="css/shengmuti3.css"/>
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
			<img src="img/biaoti3.png" />
		</div>
		<div class="huida">
			<div class="huida_1">
				<img id="3A" name="0" src="img/3A.png" />
			</div>
			<div class="huida_2">
				<img id="3B" name="0" src="img/3B.png" />
			</div>
			<div class="huida_3">
				<img id="3C" name="0" src="img/3C.png" />
			</div>
			<div class="huida_4">
				<img id="3D" name="0" src="img/3D.png" />
			</div>
			<div class="huida_5">
				<img id="3E" name="0" src="img/3E.png" />
			</div>
		</div>
		<%--<div class="ok">--%>
			<%--<img id="ok" src="img/OK.png" style="display: none;width: 1.12rem;height: 0.6rem;position: relative;left: 6rem"/>--%>
		<%--</div>--%>
		
	</body>
	<%
		String test_name=request.getParameter("test_name");
		test_name=new String(test_name.getBytes("iso-8859-1"),"utf-8");
		request.setAttribute("test_name",test_name);
		int he=Integer.parseInt(request.getParameter("he"));
		request.setAttribute("he",he);
	%>
	<script type="text/javascript">
        var A_daan=0;var B_daan=0;var C_daan=0;var D_daan=0;var E_daan=0;
        $("#3A").click(function () {
            $("#3A").attr('src','img/3A_.png');
            $("#3B").attr('src','img/3B.png');
            $("#3C").attr('src','img/3C.png');
            $("#3D").attr('src','img/3D.png');
            $("#3E").attr('src','img/3E.png');
//            $("#ok").css('display','block');
            A_daan=1;B_daan=0; C_daan=0; D_daan=0; E_daan=0;
            taiozhuan();
        });
        $("#3B").click(function () {
            $("#3A").attr('src','img/3A.png');
            $("#3B").attr('src','img/3B_.png');
            $("#3C").attr('src','img/3C.png');
            $("#3D").attr('src','img/3D.png');
            $("#3E").attr('src','img/3E.png');
//            $("#ok").css('display','block');
            A_daan=0;B_daan=2; C_daan=0; D_daan=0; E_daan=0;
            taiozhuan();
        });
        $("#3C").click(function () {
            $("#3A").attr('src','img/3A.png');
            $("#3B").attr('src','img/3B.png');
            $("#3C").attr('src','img/3C_.png');
            $("#3D").attr('src','img/3D.png');
            $("#3E").attr('src','img/3E.png');
//            $("#ok").css('display','block');
            A_daan=0;B_daan=0; C_daan=3; D_daan=0;E_daan=0;
            taiozhuan();
        });
        $("#3D").click(function () {
            $("#3A").attr('src','img/3A.png');
            $("#3B").attr('src','img/3B.png');
            $("#3C").attr('src','img/3C.png');
            $("#3D").attr('src','img/3D_.png');
            $("#3E").attr('src','img/3E.png');
//            $("#ok").css('display','block');
            A_daan=0;B_daan=0; C_daan=0; D_daan=4;E_daan=0;
            taiozhuan();
        });
        $("#3E").click(function () {
            $("#3A").attr('src','img/3A.png');
            $("#3B").attr('src','img/3B.png');
            $("#3C").attr('src','img/3C.png');
            $("#3D").attr('src','img/3D.png');
            $("#3E").attr('src','img/3E_.png');
//            $("#ok").css('display','block');
            A_daan=0;B_daan=0; C_daan=0; D_daan=0;E_daan=5;
            taiozhuan();
        });

        function taiozhuan() {
//            var url = decodeURI(window.location.href);
//            var argsIndex = url .split("&test_name=");
//            var test_name = argsIndex[1];
            var test_name = '${test_name}';
            var he=${he};
            var santi_he=A_daan+B_daan+C_daan+D_daan+E_daan+he;
            window.location.replace("/activities/XingGeTest/index4.jsp?santi_he="+santi_he+"&test_name="+test_name);
        };
	</script>
<html>