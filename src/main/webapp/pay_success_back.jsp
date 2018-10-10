<%@page import="com.lymava.trade.pay.model.PaymentRecord"%>
<%@page import="java.util.List"%>
<%@page import="com.lymava.base.model.BalanceLog"%>
<%@page import="com.lymava.qier.model.TradeRecord72"%>
<%@page import="com.lymava.nosql.context.SerializContext"%>
<%@page import="com.lymava.commons.state.State"%>
<%@page import="com.lymava.trade.business.model.Product"%>
<%@page import="com.lymava.trade.business.model.TradeRecord"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ include file="header/check_openid.jsp"%>
<%@ include file="header/header_check_login.jsp"%>
<%
	String tradeRecord_id = request.getParameter("tradeRecord_id");

	if(tradeRecord_id == null){
		tradeRecord_id = request.getParameter("out_trade_no");
	}
	
	TradeRecord72 tradeRecord  = null;
	
	if(MyUtil.isValid(tradeRecord_id)){
		tradeRecord = (TradeRecord72) serializContext.get(TradeRecord72.class, tradeRecord_id);
	} 
		
	if(tradeRecord == null || !State.STATE_PAY_SUCCESS.equals(tradeRecord.getState())){
		response.sendRedirect(MyUtil.getBasePath(request)+"user_center/my-red.jsp");
		return;
	}
	
	String requestFlow = tradeRecord.getId()+"_x1";
	
	PaymentRecord paymentRecord_find = new PaymentRecord();
	paymentRecord_find.setRequestFlow(requestFlow);
	
	PaymentRecord paymentRecord_find_out = (PaymentRecord)serializContext.get(paymentRecord_find);
		
	if (paymentRecord_find_out != null) {
		response.sendRedirect(MyUtil.getBasePath(request)+"open_red_package_success.jsp?balance_id="+paymentRecord_find_out.getId()+"&tradeRecord_id="+tradeRecord_id);
		return;
	}
	
	Product product =  tradeRecord.getProduct();
	User user_merchant = product.getUser_merchant();
		
	request.setAttribute("tradeRecord", tradeRecord);
	request.setAttribute("user_merchant", user_merchant);
	request.setAttribute("product", product);
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width,initial-scale=1,minimum-scale=1,maximum-scale=1,user-scalable=no" />
    <title>悠择YORZ-支付成功</title>
    <script src="${basePath }js/mui.min.js"></script>
    <link href="${basePath }css/mui.min.css" rel="stylesheet"/>
    <link rel="stylesheet" href="${basePath }css/zaocan.css" />
    
    <link rel="stylesheet" type="text/css" href="${basePath }layui-v2.2.5/layui/css/layui.css"/>
    
    <script type="text/javascript" src="${basePath }plugin/js/jquery/jquery-1.12.4.min.js" ></script>
    <script type="text/javascript" >var basePath = '${basePath}';</script>
    <link rel="stylesheet" href="${basePath }plugin/js/layer_mobile/need/layer.css">
	<script type="text/javascript" src="${basePath }plugin/js/layer_mobile/layer.js"></script>
    <script type="text/javascript" src="${basePath }plugin/js/lymava_common.js?r=<%=System.currentTimeMillis()%>"></script>
    <script type="text/javascript" src="${basePath }js/project.js" ></script>
    <script type="text/javascript" charset="utf-8">
      	mui.init();
    </script>
</head>
<body>
	<form action="${basePath }open_red_package_success.jsp" name="open_red_package_success_form">
						<input id="balance_id_input" name="balance_id" type="hidden"  >
						<input id="tradeRecord_id_input" name="tradeRecord_id" value="${tradeRecord.id }" type="hidden"  >
	</form>
	<div class="container">
		<!--内容部分	-->
		<div class="hongbao">
			<div class="h_bg layui-col-xs12" style="position: absolute;">
				<img src="img/zhifu.png"/>
			</div>
			<div class="h_dian layui-col-xs12" style="position: relative;padding-top: 20%;">
				<div class="h_d_bg layui-col-xs12" style="position: absolute;">
					<img src="img/red.png"/>
				</div>
				<div class="h_d_font layui-col-xs12" style="position: relative;">
					<div class="h_d_font1" style="text-align: right;">
						&nbsp;
					</div>
					<div class="h_d_font2">
						<c:if test="${empty user_merchant.picname }">
							<img src="img/logo_180x180.jpg" style="border-radius: 3rem;"/>  
						</c:if>
						<c:if test="${!empty user_merchant.picname }">
							<img src="${basePath }${user_merchant.picname }" style="border-radius: 3rem;"/>  
						</c:if>
					</div>
					<div class="h_d_font3">
						<c:out value="${user_merchant.nickname }" escapeXml="true"/>
					</div>
					<div class="h_d_font4">
						给你发了一个红包
					</div>
					<div class="h_d_font5">
						恭喜发财，大吉大利
					</div>
					<div class="h_d_font6 chai_img">
						<img id="chai_img" src="img/chai.png"/>
					</div>
				</div>
			</div>
		</div>
		<script type="text/javascript">
		
			var id_of_setinterval = null;
			
			var fanzhuan_running = false;
		
			$(function(){
				$('.chai_img').on('click',function(){
					if(!fanzhuan_running){
						id_of_setinterval = setInterval(start_fanzhuan, 16);
						fanzhuan_running = true;
					}
					setTimeout(start_open_red_package,500);					
				});
			});
			var rotate_count = 0;
			function start_fanzhuan(){
				$('#chai_img').css("transform","rotateY("+rotate_count+"deg)");
				rotate_count += 12;
				
				if(rotate_count > 360){
					rotate_count = 0;
				}
			}
			
			/**
			 * 	支付成功后抽取红包
			 * @returns
			 */
			function start_open_red_package(){
				
				var tradeRecord_id = $("#tradeRecord_id_input").val();
				
				var request_data = {
						tradeRecord_id	:	tradeRecord_id
				}; 
				
				$.ajax({
					type : "post",
					url : basePath+"qierFront/open_red_package_after_pay_success.do",
					data : request_data,
					dataType : "text",
					timeout:30*1000,
					async: false,
					success : function(msg) {
							if(id_of_setinterval != null){
						    	clearInterval(id_of_setinterval);
						    	$('#chai_img').css("transform","rotateY(0deg)");
						    	fanzhuan_running = false;
					    	}
							
							var responseData = json2obj(msg);
							var statusCode = responseData.statusCode;
							
							if(responseData.statusCode == statusCode_USER_INFO_TIMEOUT){
								var data = responseData.data;
								var balance_id = data.balance_id;
								$('#balance_id_input').val(balance_id);
								document.forms["open_red_package_success_form"].submit();
								return;
							}
							
							if(responseData.statusCode != statusCode_ACCEPT_OK){
								alertMsg_correct(responseData.message);
								return;
							}
						
							var data = responseData.data;
							
							var balance_id = data.balance_id;
							
							$('#balance_id_input').val(balance_id);
							document.forms["open_red_package_success_form"].submit();
				    },
				    error : function(){
				    	if(id_of_setinterval != null){
					    	clearInterval(id_of_setinterval);
					    	fanzhuan_running = false;
					    	$('#chai_img').css("transform","rotateY(0deg)");
				    	}
					}
				});
				
			}
		</script>
		
	</div>
	
</body>
</html>