<%@page import="com.lymava.base.model.PubConlumn"%>
<%@page import="com.lymava.commons.state.State"%>
<%@page import="com.lymava.nosql.util.PageSplit"%>
<%@page import="com.lymava.commons.util.HexM"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Iterator"%>
<%@page import="com.lymava.qier.model.UserVoucher"%>
<%@page import="com.lymava.commons.pay.PayFinalVariable"%>
<%@page import="com.lymava.commons.util.MathUtil"%>
<%@page import="com.lymava.trade.business.model.Product"%>
<%@ page import="com.lymava.qier.model.Merchant72" %>
<%@ page import="com.lymava.qier.model.Product72" %>
<%@ page import="java.util.LinkedList" %>
<%@ page import="com.lymava.nosql.mongodb.util.MongoCommand" %>
<%@ page import="com.lymava.qier.action.MerchantShowAction" %>
<%@ page import="com.lymava.qier.model.Voucher" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ include file="../header/check_openid.jsp"%>
<%@ include file="../header/header_check_login.jsp"%>
<%
	String gaosan_pubConlumn_root_id = "5b17bc8fd6c459078e52f763";

	PubConlumn gaosan_pubConlumn =  PubConlumn.getFinalPubConlumn(gaosan_pubConlumn_root_id);
	
	List<PubConlumn> gaosan_pubConlumn_list = gaosan_pubConlumn.getChildrenPubConlumns();
	request.setAttribute("gaosan_pubConlumn_list", gaosan_pubConlumn_list);
	request.setAttribute("gaosan_pubConlumn_list_size", gaosan_pubConlumn_list.size());
%>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>如果重返高三</title>
    	<meta name="viewport" content="width=device-width, initial-scale=1.0">
    	<meta content="yes" name="apple-mobile-web-app-capable">
    	<meta content="telephone=no,email=no" name="format-detection">
    	<meta content="yes" name="apple-touch-fullscreen">
    	<meta http-equiv="X-UA-Compatible" content="ie=edge">
    	<meta content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0" name="viewport" /><!-- 屏蔽双击缩放 -->
    	<link rel="stylesheet" type="text/css" href="${basePath }gaosan/css/school.css"/>
    	<script type="text/javascript" src="${basePath }plugin/js/jquery/jquery-1.12.4.min.js"></script>
		<script type="text/javascript" src="${basePath }plugin/js/lymava_common.js?r=2018-05-22"></script>
		
		<script type="text/javascript" src="${basePath }js/project.js?r=2018-05-22"></script>
		
		<link rel="stylesheet" href="${basePath }plugin/js/layer_mobile/need/layer.css">
		<script type="text/javascript" src="${basePath }plugin/js/layer_mobile/layer.js"></script>
	
    	<script type="text/javascript">
    	
    		function submit_gaosan_form(){
    			
    			var real_name_value = $('#real_name').val();
    			var leixing_value = getRadioValue("leixing");
    			
    			if(checkNull(real_name_value)){
    				alertMsg_warn('请输入您的姓名!');
    				return;
    			}
    			if(checkNull(leixing_value)){
    				alertMsg_warn('请选择专业!');
    				return;
    			}
    		
    			document.forms['gaosan_submit_form'].submit();
    		}
    	</script>
	</head>
	<body>
			<div class="s_bg_05">
				<img src="img/bg.jpg"/>
			</div>
			<div class="s_page_05">
			  <form name="gaosan_submit_form" action="${basePath }gaosan/result.jsp" method="post">
				<div class="page">
				    <input id="real_name" class="field__input" name="real_name" placeholder="请输入你的姓名">
				</div>
				<div class="" style="height:0.5rem;"></div>
				<div class="page_1">
					<c:forEach var="gaosan_pubConlumn_tmp" items="${gaosan_pubConlumn_list }" varStatus="i">
							<c:if test="${i.count%2==1 }">
								<div class="page_01"> 
									<div class="s_tag">
										<div class="s_tag_1">${gaosan_pubConlumn_tmp.name }</div>
										<div class="s_tag_2">
											<input type="radio" name="leixing"  value="${gaosan_pubConlumn_tmp.id }"/>
										</div>
									</div>
								</div>
							</c:if>
							<c:if test="${i.count%2==0 }">
								<div class="page_02">
									<div class="s_tag">
										<div class="s_tag_1">${gaosan_pubConlumn_tmp.name }</div>
										<div class="s_tag_2">
											<input type="radio" name="leixing" value="${gaosan_pubConlumn_tmp.id }"/>
										</div>
									</div>
								</div>
							</c:if>
							<c:if test="${i.count%2==0 && i.count < gaosan_pubConlumn_list_size   }">
								</div>
								<div class="page_1">
							</c:if>
					</c:forEach>
				</div>
				<div class="clear"></div>
				<div class="page_2">
					<img onclick="submit_gaosan_form()" src="img/botton.png"/>
				</div>
				</form>
			</div>
			
	</body>
</html>
