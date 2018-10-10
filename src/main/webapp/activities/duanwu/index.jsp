<%@page import="java.util.Iterator"%>
<%@page import="com.lymava.nosql.util.PageSplit"%>
<%@page import="com.lymava.base.model.BalanceLog"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ include file="../../header/check_openid.jsp"%>
<%@ include file="../../header/header_check_login.jsp"%>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>测测你是哪粽人</title>
	    <meta name="viewport" content="width=device-width, initial-scale=1.0">
	    <meta content="yes" name="apple-mobile-web-app-capable">
	    <meta content="telephone=no,email=no" name="format-detection">
	    <meta content="yes" name="apple-touch-fullscreen">
	    <meta http-equiv="X-UA-Compatible" content="ie=edge">
	    <meta content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0" name="viewport" /><!-- 屏蔽双击缩放 -->
		<script type="text/javascript"	src="${basePath }plugin/js/jquery/jquery-1.12.4.min.js"></script>
		<script type="text/javascript" >var basePath = '${basePath}';</script>
		<link rel="stylesheet" type="text/css" href="${basePath }layui-v2.2.5/layui/css/layui.css" />
		<link rel="stylesheet" type="text/css" href="${basePath }activities/duanwu/css/duanwu.css"/>
		
		<link rel="stylesheet" href="${basePath }plugin/js/layer_mobile/need/layer.css">
		
		<script type="text/javascript"	src="${basePath }plugin/js/layer_mobile/layer.js"></script>
		<script type="text/javascript"	src="${basePath }plugin/js/jquery/jquery-1.12.4.min.js"></script>
		<script type="text/javascript"	src="${basePath }plugin/js/lymava_common.js?r=2018-06-10"></script>
		<script type="text/javascript" >var basePath = '${basePath}';</script>
		
		<script type="text/javascript"	src="${basePath }activities/duanwu/js/project.js"></script>
		 
		<style type="text/css">
			.wenti{
				color: #b7491a;
				font-size: 1rem;
				text-align: right;
				padding-top: 1rem;
			}
			.wenti_daan{
				color: #b7491a;
				 line-height: 2rem;
				 height: 2rem;
				 text-align: right; 
			}
			.wenti_right{
				 line-height: 2rem;
				 height: 2rem;
				 vertical-align: middle;
			}
			.wenti_right input{
				display: block;
				height: 1rem;
				margin-top: 0.4rem;
			}
		</style>
	</head> 
	<script type="text/javascript">
		function submit_to_step2(){
			var dianying_value = getRadioValue("dianying");
			
			if(checkNull(dianying_value)){
				alertMsg_info("请先选择!");
				return;
			}
			
			document.forms["form_1"].submit();
		}
	</script>
	<body> 
		<div style="margin: 0;padding: 0;" class="layui-container">
			 <img alt="" src="${basePath }activities/duanwu/img/beijing.jpg" style="width: 100%;">
		</div> 
		<form action="${basePath }activities/duanwu/step_2.jsp" method="post" name="form_1" >
		<div style="position: absolute;margin: 0;padding: 0;left: 0;top: 15rem;;width: 100%;" class="layui-container">
				<div class="layui-row">  
				    <div class="layui-col-xs7" >
				      <div class="wenti" >“你喜欢哪种类型的电影“</div>
				    </div> 
				    <div class="layui-col-xs5">
				   	  <div class="layui-row">  
				      	<div class="layui-col-xs6 wenti_daan">喜剧</div>
				      	<div class="layui-col-xs6 wenti_right">
				      		<input name="dianying" type="radio" value="喜剧" >
				      	</div>
				      </div>
				      <div class="layui-row">  
				      	<div class="layui-col-xs6 wenti_daan">恐怖片</div>
				      	<div class="layui-col-xs6 wenti_right">
				      		<input name="dianying" type="radio" value="恐怖片" >
				      	</div>
				      </div>
				      <div class="layui-row">  
				      	<div class="layui-col-xs6 wenti_daan">科幻片</div>
				      	<div class="layui-col-xs6 wenti_right">
				      		<input name="dianying" type="radio" value="科幻片" >
				      	</div>
				      </div>
				      <div class="layui-row">  
				      	<div class="layui-col-xs6 wenti_daan">爱情片</div>
				      	<div class="layui-col-xs6 wenti_right">
				      		<input name="dianying" type="radio" value="爱情片" >
				      	</div>
				      </div>
				      <div class="layui-row">  
				      	<div class="layui-col-xs6 wenti_daan">战争片</div>
				      	<div class="layui-col-xs6 wenti_right">
				      		<input name="dianying" type="radio" value="战争片">
				      	</div>
				      </div>
				      <div class="layui-row" style="padding-top: 2rem;">  
				      	 <div class="layui-col-xs12">
				      	 	<img onclick="submit_to_step2()" alt="" src="${basePath }activities/duanwu/img/xiayiti.png" style="width: 5rem;padding-left: 2rem;"/>
				      	 </div>  
				    </div>
			   </div>
			</div>
		</div>
		</form>
	</body>
</html>
