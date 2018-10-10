<%@page import="java.util.Iterator"%>
<%@page import="com.lymava.nosql.util.PageSplit"%>
<%@page import="com.lymava.base.model.BalanceLog"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ include file="../../header/check_openid.jsp"%>
<%@ include file="../../header/header_check_login.jsp"%>
<%
	String user_name = request.getParameter("user_name");
	String sex = request.getParameter("sex");
	String kemu = request.getParameter("kemu");
	
	String shenfenzheng = "500103200105082127";
	if("少男".equals(sex)){
		shenfenzheng = "500103200105082121";
	}else{
		shenfenzheng = "500103200105082122";
	}
	
	request.setAttribute("shenfenzheng", shenfenzheng);
	request.setAttribute("user_name", user_name);
	request.setAttribute("sex", sex);
	request.setAttribute("kemu", kemu);
%>
<!DOCTYPE html>
<html style="font-size: 100px;">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	
	<meta name="viewport" content="width=375,initial-scale=1,minimum-scale=1,maximum-scale=1,user-scalable=no" />
	
	<meta name="format-detection" content="telephone=no">
	<meta http-equiv="X-UA-Compatible" content="ie=edge">
	
	<script type="text/javascript" >var basePath = '${basePath}';</script>
	
	<script type="text/javascript" src="${basePath }plugin/js/jquery/jquery-1.12.4.min.js" ></script>
    <script type="text/javascript" src="${basePath }plugin/js/lymava_common.js?r=<%=System.currentTimeMillis()%>"></script>
    <script type="text/javascript" src="${basePath }js/project.js" ></script>
	
	<link rel="stylesheet" type="text/css" href="css/layui.css"/>
	<link rel="stylesheet" href="css/gaokao.css">
	
	<link rel="stylesheet" href="${basePath }plugin/js/layer_mobile/need/layer.css">
	<script type="text/javascript"	src="${basePath }plugin/js/layer_mobile/layer.js"></script>
	 
	<title>成绩证书</title> 
<body>
	 <div class="layui-container" style="position: relative;padding: 0;margin: 0;">
	 	  <div class="layui-row" style="position: absolute;top: 0;left: 0;top:0;"> 
			<img alt="" src="image/bg.jpg" style="width: 100%;">			    
		  </div> 
		  <div class="layui-row" style="padding-top: 0.7rem;">
			    <div class="layui-col-xs6">
			       &nbsp; 
			    </div>
			    <div class="layui-col-xs6">
			      <img alt="" src="image/step2_title.jpg" style="width: 1.9rem;margin-left:-0.95rem;" >
			    </div>
		  </div>
		  <div class="layui-row info_row" style="padding-top: 0.2rem;">
			    <div class="layui-col-xs3">
			       &nbsp;
			    </div>
			    <div class="layui-col-xs9">
			       姓名：${user_name }
			    </div> 
		  </div>
		   <div class="layui-row info_row" style="padding-top: 0.15rem;">
			    <div class="layui-col-xs3">
			       &nbsp;
			    </div>
			    <div class="layui-col-xs9">
			       考生证：20185001030112
			    </div>
		  </div>  
		  <div class="layui-row info_row" style="padding-top: 0.15rem;">
			    <div class="layui-col-xs3">&nbsp;</div>
			    <div class="layui-col-xs9">
			       报名序号：201822224242
			    </div>
		  </div>  
		  <div class="layui-row info_row" style="padding-top: 0.15rem;">
			    <div class="layui-col-xs3">&nbsp;</div>
			    <div class="layui-col-xs9">
			       身份证号：${shenfenzheng }
			    </div>
		  </div>
		  <div class="layui-row info_row_table" style="padding-top: 0.15rem;">
		  		<div class="layui-col-xs3">&nbsp;</div>
			    <div class="layui-col-xs6">
			        <div class="layui-table-body layui-table-main">
						<table cellspacing="0" cellpadding="0" border="0" class="layui-table" style="background-color:transparent; ">
							<tbody>
								<tr >
									<td data-field="id">
										科目
									</td>
									<td data-field="username">
										分数
									</td> 
								</tr>
								<tr >
									<td >语文</td>
									<td>120</td> 
								</tr>
								<tr >
									<td >数学</td>
									<td>120</td> 
								</tr>
								<tr >
									<td >英语</td>
									<td>120</td> 
								</tr>
								<tr >
									<td >综合</td>
									<td>220</td> 
								</tr>
								<tr >
									<td >总分</td>
									<td>580</td> 
								</tr>
							</tbody>
						</table>
					</div>
			    </div> 
			    <div class="layui-col-xs3">&nbsp;</div>
		  </div>   
		  <div class="layui-row info_row" style="padding-top: 0.05rem;">
			    <div class="layui-col-xs12" style="text-align: center;font-weight: bold;">
			       (请妥善保管，遗失不补)
			    </div>
		  </div>
		  <form action="${basePath }activities/gaokao/step3.jsp" name="jump_to_step3_form" method="post"	 >	 
		  	<input   type="hidden"    name="user_name"  value="${user_name }">
		  	<input   type="hidden"    name="sex"  value="${sex }">
		  	<input   type="hidden"    name="kemu"  value="${kemu }">
			  <div class="layui-row" style="padding-top: 0.1rem;">
				    <div class="layui-col-xs6">
				       &nbsp;
				    </div>
				    <div class="layui-col-xs6">
				      <img onclick="document.forms['jump_to_step3_form'].submit()" class="btn_tijiao" src="image/botton8.png" style="width: 1.9rem;margin-left:-1rem;" >
				    </div>
			  </div> 
		  </form>
	 </div>
</body>
</html>


