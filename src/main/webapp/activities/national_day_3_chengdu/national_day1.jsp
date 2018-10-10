<%@ page language="java" contentType="text/html; charset=UTF-8"
		 pageEncoding="UTF-8"%><%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="utf-8" />
		<title>
			注意了，小长假“丧”病来袭！！！
		</title>
		<meta name="viewport" content="width=device-width, initial-scale=1.0">
	    <meta content="yes" name="apple-mobile-web-app-capable">
	    <meta content="telephone=no,email=no" name="format-detection">
	    <meta content="yes" name="apple-touch-fullscreen">
	    <meta http-equiv="X-UA-Compatible" content="ie=edge">
	    <meta content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0" name="viewport" /><!-- 屏蔽双击缩放 -->
	    <script src="js/mui.min.js"></script>
	    <link href="css/mui.min.css" rel="stylesheet"/>

		<script type="text/javascript" src="js/project.js"></script>

		<link rel="stylesheet" href="${basePath }plugin/js/layer_mobile/need/layer.css">
		<script type="text/javascript" src="${basePath }plugin/js/layer_mobile/layer.js"></script>
		<script type="text/javascript" src="js/jweixin-1.0.0.js"></script>

	    <link rel="stylesheet" type="text/css" href="css/n_d.css"/>
	    <script type="text/javascript" src="js/jquery.js" ></script>
	    
		<script type="text/javascript">
				$(function(){
					var window_width = $(window).width();
					var rem_font_size = window_width*10/75;
					$("html").css("font-size",rem_font_size+"px");
					
					mui.init();

                    function autoPlayAudio() {
                        wx.config({
                            // 配置信息, 即使不正确也能使用 wx.ready
                            debug: false,
                            appId: '',
                            timestamp: 1,
                            nonceStr: '',
                            signature: '',
                            jsApiList: []
                        });
                        wx.ready(function() {
                            var globalAudio=document.getElementById("audio_music");
                            globalAudio.play();
                        });
                    }
                    autoPlayAudio();
				}); 
		</script>
		 
</head>
<body style="background-color: #FFFFFF;">

<audio id="audio_music" autoplay="autoplay" controls="" loop="loop" preload="auto" style="display: none;"
	   src="music/Toby_Fox_Sans.mp3">
</audio>

<form action="" method="post" name="form_5" id="form_submit_5">
	<input type="text" name="yiti_daan" id="yiti_daan" hidden/>
	<input type="text" name="erti_daan" id="erti_daan" hidden/>
	<input type="text" name="santi_daan" id="santi_daan" hidden/>
	<%--<form action="${basePath }activities/national_day/national_day2.jsp" method="post" name="form_1" id="form_submit_1">--%>
	<div id="n_d1">
		<div class="n_d1 mui-row">
			<img src="img/start.gif" />
		</div>
		<div class="n_d1_1 mui-row">
			<div class="n1_1 mui-row">
				<img src="img/f.png"/>
			</div>
			<div class="n1_2 mui-row">
				<input type="text" id="you_name" name="you_name" maxlength="8" class="field__input" placeholder="输入你的姓名">
			</div>
			<div class="n1_3 mui-row">
				<img id="submit_img_1" src="img/botton1.png"/>
			</div>
		</div>
	</div>
	<div id="n_d2" style="display: none;">
		<div class="n_d2 mui-row">
			<img src="img/one.gif"/>
		</div>
		<div class="n_d2_1 mui-row">
			<div class="n2_1 mui-row">
				<img src="img/title1.png"/>
			</div>
			<div class="n2_2 mui-row">
				<img id="submit_img_2_1" src="img/one1.png"/>
				<img id="one1_1" src="img/one1_1.png" style="display: none;"/>
			</div>
			<div class="n2_3 mui-row">
				<img id="submit_img_2_2" src="img/two1.png"/>
				<img id="two1_1" src="img/two1_1.png" style="display: none;"/>
			</div>
			<div class="n2_4 mui-row">
				<img id="submit_img_2_3" src="img/three1.png"/>
				<img id="three1_1" src="img/three1_1.png" style="display: none;"/>
			</div>
		</div>
	</div>
	<div id="n_d3" style="display: none;">
		<div class="n_d2 mui-row">
			<img src="img/two.gif"/>
		</div>
		<div class="n_d2_1 mui-row">
			<div class="n2_1 mui-row">
				<img src="img/title2.png"/>
			</div>
			<div class="n2_2 mui-row">
				<img id="submit_img_3_1" src="img/one2.png" style="width: 4.9rem;"/>
				<img id="one2_1" src="img/one2_1.png" style="display: none;"/>
			</div>
			<div class="n2_5 mui-row">
				<img id="submit_img_3_2" src="img/two2.png"/>
				<img id="two2_1" src="img/two2_1.png" style="display: none;"/>
			</div>
			<div class="n2_6 mui-row">
				<img id="submit_img_3_3" src="img/three2.png"/>
				<img id="three2_1" src="img/three2_1.png" style="display: none;"/>
			</div>
		</div>
	</div>
	<div id="n_d4" style="display: none;">
		<div class="n_d2 mui-row">
			<img src="img/three.gif"/>
		</div>
		<div class="n_d2_1 mui-row">
			<div class="n2_1 mui-row">
				<img src="img/title3.png"/>
			</div>
			<div class="n2_2 mui-row">
				<img id="submit_img_4_1" src="img/one3.png" style="width: 5.06rem;"/>
				<img id="one3_1" src="img/one3_1.png" style="display: none;"/>
			</div>
			<div class="n2_5 mui-row">
				<img id="submit_img_4_2" src="img/two3.png" style="width: 6.39rem;"/>
				<img id="two3_1" src="img/two3_1.png" style="display: none;"/>
			</div>
			<div class="n2_6 mui-row">
				<img id="submit_img_4_3" src="img/three3.png" style="width: 5.42rem;"/>
				<img id="three3_1" src="img/three3_1.png" style="display: none;"/>
			</div>
		</div>
	</div>
	<div id="n_d5" style="display: none; ">
		<div class="n_d3 mui-row">
			<img src="img/four.gif"/>
		</div>
		<div class="n_d3_1 mui-row">
			<img id="submit_img_5" src="img/botton2.png"/>
		</div>
	</div>
</form>
</body>
	<script type="text/javascript">
		$("#submit_img_1").click(function () {
		    if($("#you_name").val()==null||$("#you_name").val()==""){
				var msg="请输入你的姓名！";
                alertMsg_correct(msg);
				return;
			}
//			$("#form_submit_1").submit();
			$("#n_d1").css("display","none");
            $("#n_d2").css("display","block");
            $("#n_d3").css("display","none");
            $("#n_d4").css("display","none");
            $("#n_d5").css("display","none");
        });

        $("#submit_img_2_1").click(function () {
            $("#yiti_daan").val("A");
            $("#submit_img_2_1").css("display","none");
            $("#one1_1").css("display","block");
            $("#submit_img_2_2").css("display","block");
            $("#two1_1").css("display","none");
            $("#submit_img_2_3").css("display","block");
            $("#three1_1").css("display","none");
//            $("#form_submit_2").submit();

            $("#n_d1").css("display","none");
            $("#n_d2").css("display","none");
            $("#n_d3").css("display","block");
            $("#n_d4").css("display","none");
            $("#n_d5").css("display","none");

        });
        $("#submit_img_2_2").click(function () {
            $("#yiti_daan").val("B");
            $("#submit_img_2_1").css("display","block");
            $("#one1_1").css("display","none");
            $("#submit_img_2_2").css("display","none");
            $("#two1_1").css("display","block");
            $("#submit_img_2_3").css("display","block");
            $("#three1_1").css("display","none");
//            $("#form_submit_2").submit();
            $("#n_d1").css("display","none");
            $("#n_d2").css("display","none");
            $("#n_d3").css("display","block");
            $("#n_d4").css("display","none");
            $("#n_d5").css("display","none");
        });
        $("#submit_img_2_3").click(function () {
            $("#yiti_daan").val("C");
            $("#submit_img_2_1").css("display","block");
            $("#one1_1").css("display","none");
            $("#submit_img_2_2").css("display","block");
            $("#two1_1").css("display","none");
            $("#submit_img_2_3").css("display","none");
            $("#three1_1").css("display","block");
//            $("#form_submit_2").submit();
            $("#n_d1").css("display","none");
            $("#n_d2").css("display","none");
            $("#n_d3").css("display","block");
            $("#n_d4").css("display","none");
            $("#n_d5").css("display","none");
        });

        $("#submit_img_3_1").click(function () {
            $("#erti_daan").val("A");
            $("#submit_img_3_1").css("display","none");
            $("#one2_1").css("display","block");
            $("#submit_img_3_2").css("display","block");
            $("#two2_1").css("display","none");
            $("#submit_img_3_3").css("display","block");
            $("#three2_1").css("display","none");
//            $("#form_submit_3").submit();
            $("#n_d1").css("display","none");
            $("#n_d2").css("display","none");
            $("#n_d3").css("display","none");
            $("#n_d4").css("display","block");
            $("#n_d5").css("display","none");

        });
        $("#submit_img_3_2").click(function () {
            $("#erti_daan").val("B");
            $("#submit_img_3_1").css("display","block");
            $("#one2_1").css("display","none");
            $("#submit_img_3_2").css("display","none");
            $("#two2_1").css("display","block");
            $("#submit_img_3_3").css("display","block");
            $("#three2_1").css("display","none");
//            $("#form_submit_3").submit();
            $("#n_d1").css("display","none");
            $("#n_d2").css("display","none");
            $("#n_d3").css("display","none");
            $("#n_d4").css("display","block");
            $("#n_d5").css("display","none");
        });
        $("#submit_img_3_3").click(function () {
            $("#erti_daan").val("C");
            $("#submit_img_3_1").css("display","block");
            $("#one2_1").css("display","none");
            $("#submit_img_3_2").css("display","block");
            $("#two2_1").css("display","none");
            $("#submit_img_3_3").css("display","none");
            $("#three2_1").css("display","block");
//            $("#form_submit_3").submit();
            $("#n_d1").css("display","none");
            $("#n_d2").css("display","none");
            $("#n_d3").css("display","none");
            $("#n_d4").css("display","block");
            $("#n_d5").css("display","none");
        });

        $("#submit_img_4_1").click(function () {
            $("#santi_daan").val("A");
            $("#submit_img_4_1").css("display","none");
            $("#one3_1").css("display","block");
            $("#submit_img_4_2").css("display","block");
            $("#two3_1").css("display","none");
            $("#submit_img_4_3").css("display","block");
            $("#three3_1").css("display","none");
//            $("#form_submit_4").submit();
            $("#n_d1").css("display","none");
            $("#n_d2").css("display","none");
            $("#n_d3").css("display","none");
            $("#n_d4").css("display","none");
            $("#n_d5").css("display","block");
        });
        $("#submit_img_4_2").click(function () {
            $("#santi_daan").val("B");
            $("#submit_img_4_1").css("display","block");
            $("#one3_1").css("display","none");
            $("#submit_img_4_2").css("display","none");
            $("#two3_1").css("display","block");
            $("#submit_img_4_3").css("display","block");
            $("#three3_1").css("display","none");
//            $("#form_submit_4").submit();
            $("#n_d1").css("display","none");
            $("#n_d2").css("display","none");
            $("#n_d3").css("display","none");
            $("#n_d4").css("display","none");
            $("#n_d5").css("display","block");
        });
        $("#submit_img_4_3").click(function () {
            $("#santi_daan").val("C");
            $("#submit_img_4_1").css("display","block");
            $("#one3_1").css("display","none");
            $("#submit_img_4_2").css("display","block");
            $("#two3_1").css("display","none");
            $("#submit_img_4_3").css("display","none");
            $("#three3_1").css("display","block");
//            $("#form_submit_4").submit();
            $("#n_d1").css("display","none");
            $("#n_d2").css("display","none");
            $("#n_d3").css("display","none");
            $("#n_d4").css("display","none");
            $("#n_d5").css("display","block");
        });

        $("#submit_img_5").click(function () {
            var haibao_url="";
            var yiti_daan=$("#yiti_daan").val();
            var erti_daan=$("#erti_daan").val();
            var santi_daan=$("#santi_daan").val();
            var yiti=0;var erti=0;var santi=0;var he=0;
            if(yiti_daan=="A"&&erti_daan=="A"&&santi_daan=="A"){
                haibao_url="${basePath }activities/national_day_3_chengdu/n_d_poster5.jsp";
            }else {
                if(yiti_daan=="A"){
                    yiti=1;
                }else if(yiti_daan=="B"){
                    yiti=2;
                }else {
                    yiti=3;
                }
                if(erti_daan=="A"){
                    erti=1;
                }else if(erti_daan=="B"){
                    erti=2;
                }else {
                    erti=3;
                }
                if(santi_daan=="A"){
                    santi=1;
                }else if(santi_daan=="B"){
                    santi=2;
                }else {
                    santi=3;
                }

                he=yiti+erti+santi;
                var suiji=he%4+1;
                haibao_url="${basePath }activities/national_day_3_chengdu/n_d_poster"+suiji+".jsp";


            }
            $("#form_submit_5").attr("action",haibao_url);
            $("#form_submit_5").submit();
        });
	</script>

</html>