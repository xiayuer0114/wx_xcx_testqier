<%@page import="java.util.Iterator"%>
<%@page import="com.lymava.nosql.util.PageSplit"%>
<%@page import="com.lymava.base.model.BalanceLog"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ include file="../../header/check_openid.jsp"%>
<%@ include file="../../header/header_check_login.jsp"%>
<!DOCTYPE html>
<html style="font-size: 20.7px;">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width,initial-scale=1,maximum-scale=1,minimum-scale=1,user-scalable=no">
<meta name="format-detection" content="telephone=no">
<meta http-equiv="X-UA-Compatible" content="ie=edge">

<script type="text/javascript"
	src="${basePath }plugin/js/layer_mobile/layer.js"></script>
<script type="text/javascript"
	src="${basePath }plugin/js/jquery/jquery-1.12.4.min.js"></script>
<script type="text/javascript"
	src="${basePath }plugin/js/lymava_common.js?r=2018-06-10"></script>
<script type="text/javascript" >var basePath = '${basePath}';</script>
<link rel="stylesheet" href="${basePath }plugin/js/layer_mobile/need/layer.css">
<script type="text/javascript" src="${basePath }plugin/js/layer_mobile/layer.js"></script>
<script type="text/javascript" src="${basePath }activities/WorldCup/js/project.js"></script>
<title>2018世界杯冠军之路</title>
<style>
* {
	margin: 0;
	padding: 0;
}

.team-act {
	background-color: #16b13a;
}

.groups .group ul li .act {
	line-height: .90666667rem;
	border: none;
}
</style>
<script type="text/javascript">
	var count_all = 0;
	$(function() {
		$('.group li').bind("click", function() {
			
			var click_li = $(this);
			
			var has_class = $(this).hasClass("team-act");

			var li_parent = $(this).parent();

			var index_str = $(li_parent).attr("index");
			var index = parseInt_m(index_str);
			
			var group_name = li_parent.prev().html();
			group_name = group_name.replace("组", "")

			if (!isNumber(index)) {
				index = 0;
			}
			
			var country_name_span = $(this).find('.country-name');
			var country_name_value = country_name_span.html();
			
			var country_icon = $(this).find('.country-icon');
			
			var country_image = country_icon.attr("src");

			if (!has_class) {

				if (index >= 2) {
					return;
				}
				
				li_parent;
				
				index++;

				$(this).addClass("team-act");
				$(this).find('.circle').addClass("act");
				
				var group_name_1 = group_name+"1";
				var group_name_2 = group_name+"2";
				
				var is_find = false;
				
				var find_group_name_1 = false;
				var find_group_name_2 = false;
				
				var index_count = 1;
				
				$(li_parent).find('.circle').each(function(){
					if(group_name_1 == $(this).html()){
						find_group_name_1 = true;
					} 
					if(group_name_2 == $(this).html()){
						find_group_name_2 = true;
					} 
				});
				
				var input_class = group_name+"input";
				
				var group_name_index = null;
				
				if(find_group_name_1){
					group_name_index = group_name_2;
					click_li.find('.circle').html(group_name_2);
				}else if(find_group_name_2){
					group_name_index = group_name_1;
					click_li.find('.circle').html(group_name_1);
				}else{
					group_name_index = group_name_1;
					click_li.find('.circle').html(group_name_1);
				}
				
				
				
				$('#32_to_16_form').append('<input name="group_name" value="'+group_name+'" type="hidden" class="'+country_name_value+' '+input_class+' " >');
				$('#32_to_16_form').append('<input name="country_name" value="'+country_name_value+'" type="hidden" class="'+country_name_value+' '+input_class+' " >');
				$('#32_to_16_form').append('<input name="country_image" value="'+country_image+'" type="hidden" class="'+country_name_value+' '+input_class+' " >');
				$('#32_to_16_form').append('<input name="group_name_index" value="'+group_name_index+'" type="hidden" class="'+country_name_value+' " >');

				count_all ++;
			} else {
				$('.'+country_name_value).remove();
				
				$(this).removeClass("team-act");
				$(this).find('.circle').removeClass("act");
				$(this).find('.circle').html("");

				if (index <= 0) {
					return;
				}

				index--;
				count_all --;
			}

			$(li_parent).attr("index", index);
			
			if(count_all >= 16){
				$('.next-button').addClass("ok");
			}else{
				$('.next-button').removeClass("ok");
			}
		});
	});
	function submit_32_to_16(){
		
		ajaxForm("32_to_16_form",function(){
			
		},function(msg){
			var res = json2obj(msg);
			
			if(res.statusCode != "200"){
				alertMsg_warn(res.message);
			}else{
				document.forms["redirect_to_16_form"].submit();
			}
			 
		});
		
	}
</script>
<link
	href="1/1_files/world_cup_way.655150927e698c71eee660af4ccd0180.css"
	rel="stylesheet">
</head> 
<body>
	<form name="redirect_to_16_form" action="${basePath }activities/WorldCup/16.jsp" >
	</form>
	<div id="main">
		<form id="32_to_16_form" name="32_to_16_form" action="${basePath }activities/WorldCup/event/save_32_to_16.jsp">
		</form>
		<div data-v-698035a2="" id="part1">
			<p data-v-698035a2="" class="title-hint">
				<img src="1/1_files/1.jpg" />
			</p>
			<div data-v-698035a2="" class="groups">
				<div data-v-698035a2="" class="group">
					<p data-v-698035a2="" class="group-name">A组</p>
					<ul data-v-698035a2="">
						<li data-v-698035a2=""><img data-v-698035a2=""
							src="1/1_files/rB8CLFrwFPmAWBnoAAAJEOggWtM595.jpg" alt=""
							class="country-icon"> <span data-v-698035a2=""
							class="country-name">俄罗斯</span> <span data-v-698035a2=""
							class="circle"></span></li>
						<li data-v-698035a2="" class=""><img data-v-698035a2=""
							src="1/1_files/rB8RDlrwFPiAVq1_AAAJFvF1K7M133.jpg" alt=""
							class="country-icon"> <span data-v-698035a2=""
							class="country-name">埃及</span> <span data-v-698035a2=""
							class="circle"></span></li>
						<li data-v-698035a2="" class=""><img data-v-698035a2=""
							src="1/1_files/rB8ApFrwFPmABSwuAAANbFNHo_c272.jpg" alt=""
							class="country-icon"> <span data-v-698035a2=""
							class="country-name">沙特阿拉伯</span> <span data-v-698035a2=""
							class="circle"></span></li>
						<li data-v-698035a2="" class=""><img data-v-698035a2=""
							src="1/1_files/rB8RDlrwFPmAYYptAAAXQccQvqc767.jpg" alt=""
							class="country-icon"> <span data-v-698035a2=""
							class="country-name">乌拉圭</span> <span data-v-698035a2=""
							class="circle"></span></li>
					</ul>
				</div>
				<div data-v-698035a2="" class="group">
					<p data-v-698035a2="" class="group-name">B组</p>
					<ul data-v-698035a2="">
						<li data-v-698035a2="" class=""><img data-v-698035a2=""
							src="1/1_files/rB8RDlrwFPiAY3vgAAAUJ6dAtHc013.jpg" alt=""
							class="country-icon"> <span data-v-698035a2=""
							class="country-name">伊朗</span> <span data-v-698035a2=""
							class="circle"></span></li>
						<li data-v-698035a2="" class=""><img data-v-698035a2=""
							src="1/1_files/rB8CLFrwFPiAFaRFAAAFFT1oVEI706.jpg" alt=""
							class="country-icon"> <span data-v-698035a2=""
							class="country-name">摩洛哥</span> <span data-v-698035a2=""
							class="circle"></span></li>
						<li data-v-698035a2="" class=""><img data-v-698035a2=""
							src="1/1_files/rB8RDlrwFPmAfo19AAANSJclN98725.jpg" alt=""
							class="country-icon"> <span data-v-698035a2=""
							class="country-name">葡萄牙</span> <span data-v-698035a2=""
							class="circle"></span></li>
						<li data-v-698035a2="" class=""><img data-v-698035a2=""
							src="1/1_files/rB8ApFr0NPeAJ0dMAAAPtliy6uM210.jpg" alt=""
							class="country-icon"> <span data-v-698035a2=""
							class="country-name">西班牙</span> <span data-v-698035a2=""
							class="circle"></span></li>
					</ul>
				</div>
				<div data-v-698035a2="" class="group">
					<p data-v-698035a2="" class="group-name">C组</p>
					<ul data-v-698035a2="">
						<li data-v-698035a2="" class=""><img data-v-698035a2=""
							src="1/1_files/rB8RDlrwFPiAIqmVAAAaQ31-qak453.jpg" alt=""
							class="country-icon"> <span data-v-698035a2=""
							class="country-name">澳大利亚</span> <span data-v-698035a2=""
							class="circle"></span></li>
						<li data-v-698035a2="" class=""><img data-v-698035a2=""
							src="1/1_files/rB8ApFrwFPiABjH_AAAKUb1xT9k052.jpg" alt=""
							class="country-icon"> <span data-v-698035a2=""
							class="country-name">丹麦</span> <span data-v-698035a2=""
							class="circle"></span></li>
						<li data-v-698035a2="" class=""><img data-v-698035a2=""
							src="1/1_files/rB8ApFrwFPiAbmdsAAAJQhG6zFY412.jpg" alt=""
							class="country-icon"> <span data-v-698035a2=""
							class="country-name">法国</span> <span data-v-698035a2=""
							class="circle"></span></li>
						<li data-v-698035a2="" class=""><img data-v-698035a2=""
							src="1/1_files/rB8CLFrwFPmABdXKAAAHDdWGo5M629.jpg" alt=""
							class="country-icon"> <span data-v-698035a2=""
							class="country-name">秘鲁</span> <span data-v-698035a2=""
							class="circle"></span></li>
					</ul>
				</div>
				<div data-v-698035a2="" class="group">
					<p data-v-698035a2="" class="group-name">D组</p>
					<ul data-v-698035a2="">
						<li data-v-698035a2="" class=""><img data-v-698035a2=""
							src="1/1_files/rB8ApFrwFPeAMloyAAAK3QK6QjU022.jpg" alt=""
							class="country-icon"> <span data-v-698035a2=""
							class="country-name">阿根廷</span> <span data-v-698035a2=""
							class="circle"></span></li>
						<li data-v-698035a2="" class=""><img data-v-698035a2=""
							src="1/1_files/rB8CLFrwFPiAQfMUAAAUsZzeO3U662.jpg" alt=""
							class="country-icon"> <span data-v-698035a2=""
							class="country-name">克罗地亚</span> <span data-v-698035a2=""
							class="circle"></span></li>
						<li data-v-698035a2="" class=""><img data-v-698035a2=""
							src="1/1_files/rB8ApFrwFPiAFQVSAAAOVoguOn0188.jpg" alt=""
							class="country-icon"> <span data-v-698035a2=""
							class="country-name">冰岛</span> <span data-v-698035a2=""
							class="circle"></span></li>
						<li data-v-698035a2="" class=""><img data-v-698035a2=""
							src="1/1_files/rB8ApFrwFPiAG3fMAAAGksSkzik668.jpg" alt=""
							class="country-icon"> <span data-v-698035a2=""
							class="country-name">尼日利亚</span> <span data-v-698035a2=""
							class="circle"></span></li>
					</ul>
				</div>
				<div data-v-698035a2="" class="group">
					<p data-v-698035a2="" class="group-name">E组</p>
					<ul data-v-698035a2="">
						<li data-v-698035a2="" class=""><img data-v-698035a2=""
							src="1/1_files/rB8ApFrwFPiAd-z7AAAVxrJNviU748.jpg" alt=""
							class="country-icon"> <span data-v-698035a2=""
							class="country-name">巴西</span> <span data-v-698035a2=""
							class="circle"></span></li>
						<li data-v-698035a2="" class=""><img data-v-698035a2=""
							src="1/1_files/rB8CLFrwFPiAIyK_AAAME59i_n0682.jpg" alt=""
							class="country-icon"> <span data-v-698035a2=""
							class="country-name">哥斯达黎加</span> <span data-v-698035a2=""
							class="circle"></span></li>
						<li data-v-698035a2="" class=""><img data-v-698035a2=""
							src="1/1_files/ruishi.jpg"
							alt="" class="country-icon"> <span data-v-698035a2=""
							class="country-name">瑞士</span> <span data-v-698035a2=""
							class="circle"></span></li>
						<li data-v-698035a2="" class=""><img data-v-698035a2=""
							src="1/1_files/rB8CLFrwFPmAXfKLAAAPlf0SkkI534.jpg" alt=""
							class="country-icon"> <span data-v-698035a2=""
							class="country-name">塞尔维亚</span> <span data-v-698035a2=""
							class="circle"></span></li>
					</ul>
				</div>
				<div data-v-698035a2="" class="group">
					<p data-v-698035a2="" class="group-name">F组</p>
					<ul data-v-698035a2="">
						<li data-v-698035a2="" class=""><img data-v-698035a2=""
							src="1/1_files/rB8CLFrwFPiAY6j1AAAHkJNDCYY866.jpg" alt=""
							class="country-icon"> <span data-v-698035a2=""
							class="country-name">德国</span> <span data-v-698035a2=""
							class="circle"></span></li>
						<li data-v-698035a2="" class=""><img data-v-698035a2=""
							src="1/1_files/rB8RDlrwFPiARQFhAAASrk6EbzA809.jpg" alt=""
							class="country-icon"> <span data-v-698035a2=""
							class="country-name">韩国</span> <span data-v-698035a2=""
							class="circle"></span></li>
						<li data-v-698035a2="" class=""><img data-v-698035a2=""
							src="1/1_files/rB8ApFrwFPiAIpKJAAANJt5IiSs975.jpg" alt=""
							class="country-icon"> <span data-v-698035a2=""
							class="country-name">墨西哥</span> <span data-v-698035a2=""
							class="circle"></span></li>
						<li data-v-698035a2="" class=""><img data-v-698035a2=""
							src="1/1_files/rB8RDlrwFPmAEN_tAAALQa5s73U753.jpg" alt=""
							class="country-icon"> <span data-v-698035a2=""
							class="country-name">瑞典</span> <span data-v-698035a2=""
							class="circle"></span></li>
					</ul>
				</div>
				<div data-v-698035a2="" class="group">
					<p data-v-698035a2="" class="group-name">G组</p>
					<ul data-v-698035a2="">
						<li data-v-698035a2="" class=""><img data-v-698035a2=""
							src="1/1_files/rB8RDlrwFPeAZGFiAAAG-LDFBJQ726.jpg" alt=""
							class="country-icon"> <span data-v-698035a2=""
							class="country-name">比利时</span> <span data-v-698035a2=""
							class="circle"></span></li>
						<li data-v-698035a2="" class=""><img data-v-698035a2=""
							src="1/1_files/rB8RDlrwFPiAc2LuAAAKsFFuhHs647.jpg" alt=""
							class="country-icon"> <span data-v-698035a2=""
							class="country-name">英格兰</span> <span data-v-698035a2=""
							class="circle"></span></li>
						<li data-v-698035a2="" class=""><img data-v-698035a2=""
							src="1/1_files/rB8RDlrwFPmAeAO8AAALRlZI-ZI336.jpg" alt=""
							class="country-icon"> <span data-v-698035a2=""
							class="country-name">巴拿马</span> <span data-v-698035a2=""
							class="circle"></span></li>
						<li data-v-698035a2="" class=""><img data-v-698035a2=""
							src="1/1_files/rB8CLFrwFPmAOHkoAAALqTdfRpk270.jpg" alt=""
							class="country-icon"> <span data-v-698035a2=""
							class="country-name">突尼斯</span> <span data-v-698035a2=""
							class="circle"></span></li>
					</ul>
				</div>
				<div data-v-698035a2="" class="group">
					<p data-v-698035a2="" class="group-name">H组</p>
					<ul data-v-698035a2="">
						<li data-v-698035a2="" class=""><img data-v-698035a2=""
							src="1/1_files/rB8CLFrwFPiAN5PsAAAJk85XwmI083.jpg" alt=""
							class="country-icon"> <span data-v-698035a2=""
							class="country-name">哥伦比亚</span> <span data-v-698035a2=""
							class="circle"></span></li>
						<li data-v-698035a2="" class=""><img data-v-698035a2=""
							src="1/1_files/rB8CLFrwFPiAIGsKAAALS16jG4U532.jpg" alt=""
							class="country-icon"> <span data-v-698035a2=""
							class="country-name">日本</span> <span data-v-698035a2=""
							class="circle"></span></li>
						<li data-v-698035a2="" class=""><img data-v-698035a2=""
							src="1/1_files/rB8ApFrwFPmADjwLAAAFndhZTY4521.jpg" alt=""
							class="country-icon"> <span data-v-698035a2=""
							class="country-name">波兰</span> <span data-v-698035a2=""
							class="circle"></span></li>
						<li data-v-698035a2="" class=""><img data-v-698035a2=""
							src="1/1_files/rB8RDlrwFPmAcqc3AAAJP9nhoq8583.jpg" alt=""
							class="country-icon"> <span data-v-698035a2=""
							class="country-name">塞内加尔</span> <span data-v-698035a2=""
							class="circle"></span></li>
					</ul>
				</div>
			</div>
			<p data-v-698035a2="" class="next-button" onclick="submit_32_to_16()">进入淘汰赛</p>
		</div>
	</div>
</body>
</html>


