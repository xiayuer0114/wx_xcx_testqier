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
	    <link rel="stylesheet" type="text/css" href="css/shengmuti4.css"/>
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
			<img src="img/biaoti4.png" />
		</div>
		<div class="huida">
			<div class="huida_1">
				<img id="4A" name="0" src="img/4A.png" />
			</div>
			<div class="huida_2">
				<img id="4B" name="0" src="img/4B.png" />
			</div>
			<div class="huida_3">
				<img id="4C" name="0" src="img/4C.png" />
			</div>
			<div class="huida_4">
				<img id="4D" name="0" src="img/4D.png" />
			</div>
			<div class="huida_5">
				<img id="4E" name="0" src="img/4E.png" />
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
		int santi_he=Integer.parseInt(request.getParameter("santi_he"));
		request.setAttribute("santi_he",santi_he);
	%>
	<script type="text/javascript">
        var A_daan=0;var B_daan=0;var C_daan=0;var D_daan=0;var E_daan=0;
        $("#4A").click(function () {
            $("#4A").attr('src','img/4A_.png');
            $("#4B").attr('src','img/4B.png');
            $("#4C").attr('src','img/4C.png');
            $("#4D").attr('src','img/4D.png');
            $("#4E").attr('src','img/4E.png');
//            $("#ok").css('display','block');
            A_daan=1;B_daan=0; C_daan=0; D_daan=0; E_daan=0;
            taiozhuan();
        });
        $("#4B").click(function () {
            $("#4A").attr('src','img/4A.png');
            $("#4B").attr('src','img/4B_.png');
            $("#4C").attr('src','img/4C.png');
            $("#4D").attr('src','img/4D.png');
            $("#4E").attr('src','img/4E.png');
//            $("#ok").css('display','block');
            A_daan=0;B_daan=2; C_daan=0; D_daan=0; E_daan=0;
            taiozhuan();
        });
        $("#4C").click(function () {
            $("#4A").attr('src','img/4A.png');
            $("#4B").attr('src','img/4B.png');
            $("#4C").attr('src','img/4C_.png');
            $("#4D").attr('src','img/4D.png');
            $("#4E").attr('src','img/4E.png');
//            $("#ok").css('display','block');
            A_daan=0;B_daan=0; C_daan=3; D_daan=0;E_daan=0;
            taiozhuan();
        });
        $("#4D").click(function () {
            $("#4A").attr('src','img/4A.png');
            $("#4B").attr('src','img/4B.png');
            $("#4C").attr('src','img/4C.png');
            $("#4D").attr('src','img/4D_.png');
            $("#4E").attr('src','img/4E.png');
//            $("#ok").css('display','block');
            A_daan=0;B_daan=0; C_daan=0; D_daan=4;E_daan=0;
            taiozhuan();
        });
        $("#4E").click(function () {
            $("#4A").attr('src','img/4A.png');
            $("#4B").attr('src','img/4B.png');
            $("#4C").attr('src','img/4C.png');
            $("#4D").attr('src','img/4D.png');
            $("#4E").attr('src','img/4E_.png');
//            $("#ok").css('display','block');
            A_daan=0;B_daan=0; C_daan=0; D_daan=0;E_daan=5;
            taiozhuan();
        });

        function taiozhuan() {
//            var url = decodeURI(window.location.href);
//            var argsIndex = url .split("&test_name=");
//            var test_name = argsIndex[1];
            var test_name = '${test_name}';
            var santi_he=${santi_he};
            var siti_he=A_daan+B_daan+C_daan+D_daan+E_daan+santi_he;
            window.location.replace("/activities/XingGeTest/haibao.jsp?siti_he="+siti_he+"&test_name="+test_name);
        };
        <%--var i=0;var j=0;var k=0;var l=0;var x=0;--%>
        <%--var A_daan=0;var B_daan=0;var C_daan=0;var D_daan=0;var E_daan=0;--%>
        <%--$("#4A").click(function () {--%>
            <%--if(i%2==0){--%>
                <%--$("#4A").attr('src','img/4A_.png');--%>
                <%--$("#4A").attr("name","1");--%>
                <%--A_daan=1;--%>
            <%--}else {--%>
                <%--$("#4A").attr('src','img/4A.png');--%>
                <%--$("#4A").attr("name","0");--%>
                <%--A_daan=0;--%>
            <%--}--%>
            <%--i++;--%>
            <%--panduan();--%>
        <%--});--%>
        <%--$("#4B").click(function () {--%>
            <%--if(j%2==0){--%>
                <%--$("#4B").attr('src','img/4B_.png');--%>
                <%--$("#4B").attr("name","1");--%>
                <%--B_daan=2;--%>
            <%--}else {--%>
                <%--$("#4B").attr('src','img/4B.png');--%>
                <%--$("#4B").attr("name","0");--%>
                <%--B_daan=0;--%>
            <%--}--%>
            <%--j++;--%>
            <%--panduan();--%>
        <%--});--%>
        <%--$("#4C").click(function () {--%>
            <%--if(k%2==0){--%>
                <%--$("#4C").attr('src','img/4C_.png');--%>
                <%--$("#4C").attr("name","1");--%>
                <%--C_daan=3;--%>
            <%--}else {--%>
                <%--$("#4C").attr('src','img/4C.png');--%>
                <%--$("#4C").attr("name","0");--%>
                <%--C_daan=0;--%>
            <%--}--%>
            <%--k++;--%>
            <%--panduan();--%>
        <%--});--%>
        <%--$("#4D").click(function () {--%>
            <%--if(l%2==0){--%>
                <%--$("#4D").attr('src','img/4D_.png');--%>
                <%--$("#4D").attr("name","1");--%>
                <%--D_daan=4;--%>
            <%--}else {--%>
                <%--$("#4D").attr('src','img/4D.png');--%>
                <%--$("#4D").attr("name","0");--%>
                <%--D_daan=0;--%>
            <%--}--%>
            <%--l++;--%>
            <%--panduan();--%>
        <%--});--%>
        <%--$("#4E").click(function () {--%>
            <%--if(x%2==0){--%>
                <%--$("#4E").attr('src','img/4E_.png');--%>
                <%--$("#4E").attr("name","1");--%>
                <%--E_daan=5;--%>
            <%--}else {--%>
                <%--$("#4E").attr('src','img/4E.png');--%>
                <%--$("#4E").attr("name","0");--%>
                <%--E_daan=0;--%>
            <%--}--%>
            <%--x++;--%>
            <%--panduan();--%>
        <%--});--%>

        <%--$("#ok").click(function () {--%>
            <%--var url = decodeURI(window.location.href);--%>
            <%--var argsIndex = url .split("&test_name=");--%>
            <%--var test_name = argsIndex[1];--%>
            <%--var santi_he=${santi_he};--%>
            <%--var siti_he=A_daan+B_daan+C_daan+D_daan+E_daan+santi_he;--%>
            <%--window.location.href="/activities/XingGeTest/haibao.jsp?siti_he="+siti_he+"&test_name="+test_name;--%>

        <%--});--%>
        <%--function panduan() {--%>
            <%--var name_attr_A=$("#4A").attr("name");--%>
            <%--var name_attr_B=$("#4B").attr("name");--%>
            <%--var name_attr_C=$("#4C").attr("name");--%>
            <%--var name_attr_D=$("#4D").attr("name");--%>
            <%--var name_attr_E=$("#4E").attr("name");--%>
            <%--if (name_attr_A=="1" || name_attr_B=="1" || name_attr_C=="1" || name_attr_D=="1" || name_attr_E=="1"){--%>
                <%--$("#ok").css('display','block');--%>
            <%--}else {--%>
                <%--$("#ok").css('display','none');--%>
            <%--}--%>
        <%--}--%>
	</script>
<html>