<%@page import="com.lymava.commons.util.DateUtil"%>
<%@page import="com.lymava.qier.activities.guaguaka.GuaguakaJiangPin"%>
<%@page import="java.util.Iterator"%>
<%@page import="com.lymava.nosql.util.PageSplit"%>
<%@page import="com.lymava.base.model.BalanceLog"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ include file="../../header/check_openid.jsp"%>
<%@ include file="../../header/header_check_login.jsp"%>
<%
	GuaguakaJiangPin guaguakaJiangPin_find = new GuaguakaJiangPin();

	Long currentDayStartTime = DateUtil.getCurrentDayStartTime();
	
	guaguakaJiangPin_find.setOpenid(openid_header);
	guaguakaJiangPin_find.setLingqu_day(currentDayStartTime);
	
	guaguakaJiangPin_find = (GuaguakaJiangPin)serializContext.get(guaguakaJiangPin_find);
	
	request.setAttribute("guaguakaJiangPin", guaguakaJiangPin_find);
%>
<!DOCTYPE html>
<html>
	<head>
	<title>JAY迷刮刮卡</title>
    <meta charset="UTF-8">
    <meta content="yes" name="apple-mobile-web-app-capable">
    <meta content="telephone=no,email=no" name="format-detection">
    <meta content="yes" name="apple-touch-fullscreen">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0"  /><!-- 屏蔽双击缩放 -->
    
    <script type="text/javascript" >var basePath = '${basePath}';</script>
	
	<script type="text/javascript" src="${basePath }plugin/js/jquery/jquery-1.12.4.min.js" ></script>
    <script type="text/javascript" src="${basePath }plugin/js/lymava_common.js?r=<%=System.currentTimeMillis()%>"></script>
	<link rel="stylesheet" type="text/css" href="${basePath }plugin/js/layer_ui/css/layui.css"/>
	
	<link rel="stylesheet" href="${basePath }plugin/js/layer_mobile/need/layer.css">
	<script type="text/javascript"	src="${basePath }plugin/js/layer_mobile/layer.js"></script>
	
	<link rel="stylesheet" type="text/css" href="${basePath }activities/guaguaka/css/new_file.css"/>
    <script type="text/javascript" src="${basePath }activities/guaguaka/js/project.js" ></script>
    <script type="text/javascript" src="${basePath }activities/guaguaka/js/Lottery.js" ></script>
    <script type="text/javascript">
	    $(function(){
			var window_width = $(window).width();
			$("html").css("font-size",window_width/10+"px");
		});
	    function sure_jiangp(){
	    	$('#lotteryContainer').html('<div style="width: 100%;height: 0.92rem;line-height: 0.92rem;text-align: center;background-color: #fff;vertical-align: middle;">'+
						'<div style="font-size: 0.4rem;height: 0.4rem;line-height: 0.4rem;padding-top: 0.34rem;">今日已刮过,明天再来吧!</div>'+
					'</div>');
	    	layer.closeAll();
	    }
    </script>
	<c:if test="${empty guaguakaJiangPin }">
		<script type="text/javascript">
			var had_open = false;
			function drawPercent(percent) {
				
	            if(percent > 80 && !had_open){
	            	
	            	had_open = true;
	            	
	            	var request_url = basePath+"activities/guaguaka/kaijiang.jsp";
	            	var request_data = {
	            			
	            	};
	            	ajax_post(request_url,request_data,function(msg){
	            		
	            		var responseData = json2obj(msg);
	    				
	    				if(checkNotNull(responseData) && responseData.statusCode == "300"){
	    					alertMsg_info(responseData.message);
	    					return;
	    				}
	    				
	    				//信息框
	    				  layer.open({
	    				    content: msg
	    				    ,style: 'width: 7rem;height: 8rem;padding:0;background-color: rgba(255,255,255,0);'
	    				    ,shadeClose: false
	    				    ,yes: function(index){ 
	    				    	layer.close(index);
	    				    }
	    				  });
	    			});
	            }
	        }
			
			$(function(){
				
				setTimeout(function(){
					var lotteryContainer_div = $('#lotteryContainer');
					var lottery = new Lottery('lotteryContainer', '#CCC', 'color', lotteryContainer_div.width(), lotteryContainer_div.height(), drawPercent);
					lottery.init("", 'text'); 
				}, 500);
			});
			</script>
		</c:if>
	</head>
	<body id="guaguaka">
		<div class="gua11_18 layui-row">
			<div class="layui-col-xs12">
				<img src="img/_01.png" style="width: 100%;" />
			</div>
		</div> 
		<div class="layui-row" style="position: relative;">
			<div class="layui-col-xs12">
				<img src="img/gua.jpg" style="width: 6.8rem;padding-left: 1.6rem;" />
			</div>
			<div id="lotteryContainer" style="position: absolute;width: 4.8rem;height: 0.92rem;left: 2.6rem;top:1.35rem;line-height: 0.92rem;" >
				<c:if test="${!empty guaguakaJiangPin }">
					<div style="width: 100%;height: 0.92rem;line-height: 0.92rem;text-align: center;background-color: #fff;vertical-align: middle;">
						<div style="font-size: 0.4rem;height: 0.4rem;line-height: 0.4rem;padding-top: 0.34rem;">今日已刮过,明天再来吧!</div>
					</div>    
				</c:if> 
			</div> 
		</div>  
		<div class="gua33_18" style="padding: 0;margin: 0;">
			<img src="img/footer_03.jpg" style="width: 100%;"/>
		</div>
	</body>
</html>
