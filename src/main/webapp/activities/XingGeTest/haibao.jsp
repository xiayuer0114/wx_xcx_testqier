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
	    <link rel="stylesheet" type="text/css" href="css/haibao1.css"/>
	    <script type="text/javascript" src="js/jquery-1.12.4.min.js" ></script>
		<%
			String test_name=request.getParameter("test_name");
			test_name=new String(test_name.getBytes("iso-8859-1"),"utf-8");
			request.setAttribute("test_name",test_name);
			int siti_he=Integer.parseInt(request.getParameter("siti_he"));
			request.setAttribute("siti_he",siti_he);
		%>
		<script type="text/javascript">
			$(function(){
				var window_width = $(window).width();
				var rem_font_size = window_width*10/75;
				var suijishu=${siti_he};
//                var url = decodeURI(window.location.href);
//                var argsIndex = url .split("&test_name=");
//                var test_name = argsIndex[1];
				var test_name = '${test_name}';
                suijishu=suijishu%4+1;
				<%--$.post("${basePath }${baseRequestPath }v2/XingGeTest/save.do",{test_name:"${name}",da_an:"${siti_he}",result_img:"jieguo"+suijishu+".png",state:"200"},function () {--%>

                <%--});--%>
                $("html").css("font-size",rem_font_size+"px");
				$("body").css("background-image","url(img/jieguo"+suijishu+".jpg)");
				$(".mingzi").html(test_name);
			});
		</script>
	</head>
	<body style="background-size: 100% 100%;position: relative">
			<div class="mingzi" style="border-bottom: 2px dashed #ff7800;
			font-size: 0.4rem;
			font-family: '黑体';
			color:#ff7800;
			position:absolute;
			width: auto;
			left: 0.69rem;
			top: 1rem"></div>
	</body>
<html>