<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.List"%>
<%@page import="java.util.LinkedList"%>
<%@page import="java.util.Date"%>
<%@page import="com.lymava.commons.util.DateUtil"%>
<%@page import="java.util.Iterator"%>
<%@page import="com.lymava.nosql.util.PageSplit"%>
<%@page import="com.lymava.base.model.BalanceLog"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ include file="../header/check_openid.jsp"%>
<%@ include file="../header/header_check_login.jsp"%>
<%
	String date_tody = DateUtil.getSdfShort().format(new Date(System.currentTimeMillis()));

	List<String> date_string_list = new LinkedList<String>();

	SimpleDateFormat sdf = new SimpleDateFormat("MM.dd");
	
	Long date_start_time = DateUtil.getSdfShort().parse("2018-04-08").getTime(); 
	 
	for(int i=0;i<7;i++){
		String date_string = sdf.format(new Date(date_start_time+i*DateUtil.one_day));
		if(date_string.startsWith("0")){
			date_string = date_string.substring(1);
		} 
		date_string_list.add(date_string);
	}

	request.setAttribute("date_string_list", date_string_list);
	request.setAttribute("date_tody", date_tody);
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width,initial-scale=1,minimum-scale=1,maximum-scale=1,user-scalable=no" />
    <title>早餐红包</title>
    <link rel="stylesheet" type="text/css" href="${basePath }user_center/css/index.css"/>
	<link rel="stylesheet" type="text/css" href="${basePath }user_center/layui-v2.2.5/layui/css/layui.css"/>
	<link rel="stylesheet" href="${basePath }user_center/css/my-break.css" />
	 
	<script type="text/javascript" >var basePath = '${basePath}';</script>
	
    <link rel="stylesheet" href="${basePath }plugin/js/layer_mobile/need/layer.css">
	<script type="text/javascript" src="${basePath }plugin/js/layer_mobile/layer.js"></script>
	
	<script type="text/javascript" src="${basePath }plugin/js/jquery/jquery-1.12.4.min.js"></script>
	<script type="text/javascript" src="${basePath }plugin/js/lymava_common.js?r=<%=System.currentTimeMillis()%>"></script>
	
	<script type="text/javascript" src="${basePath }user_center/js/user_center.js"></script>
</head>
	<body>
		<div class="container">
			<!--banner-->
			<div>
				<img src="images/red1.jpg" />
			</div>
			<div class="pos-r">
				<img src="images/red2.jpg" />
				<div class="dianji pos-a" style="cursor: pointer;">
					<img src="images/dianji1.png" />
				</div>
			</div>
			<div class="pos-r">
				<img src="images/red4.jpg" />
				<div class="pos-a red-text2">
					每天领取早餐红包，数量有限，先到先得
				</div>
			</div>
			<div class="pos-r layui-col-xs12 pos_bg" >
					<img src="images/red3.jpg" style="" />
			</div>
			<div class="sign layui-col-xs12 ">
					<div class="sign_1 layui-col-xs12">
							&nbsp;
					</div> 
					<div class="layui-col-xs12" style="width: 80%;">
							<div class="sign_2 layui-col-xs12">
								<div  class="sign_2_d layui-col-xs12"  style="">
									未领
								</div> 
								<div  class="sign_2_c layui-col-xs12">
									未领
								</div> 
								<div  class="sign_2_c layui-col-xs12">
									未领
								</div> 
								<div  class="sign_2_c layui-col-xs12">
									未领
								</div> 
								<div  class="sign_2_c layui-col-xs12">
									未领
								</div> 
								<div  class="sign_2_c layui-col-xs12">
									未领
								</div> 
								<div  class="sign_2_c layui-col-xs12">
									未领
								</div>  
							</div>
							<div class="date layui-col-xs12" >
								<div  class="date_1 layui-col-xs12">
									<div class="date_a">
										 <img src=" images/red5.png" />
									</div> 
									<div  class="date_b layui-col-xs12">
										 <img src="images/zaocan_02.png" />
									</div> 
								</div> 
								<div  class="date_1 layui-col-xs12">
									<div class="date_a">
										 <img src="images/red6.png" />
									</div>  
									<div  class="date_b layui-col-xs12">
										 <img src="images/zaocan_03.png" />
									</div> 
								</div> 
								<div  class="date_1 layui-col-xs12">
									<div class="date_a">
										 <img src="images/red6.png" />
									</div> 
									<div  class="date_b layui-col-xs12">
										 <img src="images/zaocan_03.png"/>
									</div> 
								</div> 
								<div  class="date_1 layui-col-xs12">
									<div class="date_a">
										 <img src="images/red6.png"/>
									</div> 
									<div  class="date_b layui-col-xs12">
										 <img src="images/zaocan_03.png"/>
									</div> 
								</div> 
								<div  class="date_1 layui-col-xs12">
									<div class="date_a">
										 <img src="images/red6.png" />
									</div> 
									<div  class="date_b layui-col-xs12">
										 <img src="images/zaocan_03.png"/>
									</div> 
								</div> 
								<div  class="date_1 layui-col-xs12">
									<div class="date_a">
										 <img src="images/red6.png" />
									</div> 
									<div  class="date_b layui-col-xs12">
										 <img src="images/zaocan_03.png" />
									</div> 
								</div> 
								<div  class="date_1 layui-col-xs12" >
									<div class="date_a">
										 <img src="images/red6.png"/>
									</div> 
									<div  class="date_b layui-col-xs12">
										 <img src="images/zaocan_01.png"/>
									</div> 
								</div> 
								
							</div>
							<div class="sign_2 layui-col-xs12">
								<c:forEach var="date_string" items="${date_string_list }" varStatus="i">
									<c:if test="${i.count == 1 }">
										<div  class="sign_2_d layui-col-xs12">
											${date_string }
										</div>  
									</c:if>
									<c:if test="${i.count != 1 }">
										<div  class="sign_2_c layui-col-xs12">
											${date_string }
										</div> 
									</c:if>
								</c:forEach>
							</div>
				  </div> 
				  <div class="sign_1 layui-col-xs12">
							&nbsp;
				  </div> 
			</div>
		<div class="layui-col-xs12">
				<img src="images/red7.jpg" />
		</div>
		</div>
	</body>
</html>
