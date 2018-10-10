<%@page import="com.lymava.qier.self_order.model.BillMainRecord"%>
<%@page import="com.lymava.qier.model.Merchant72"%>
<%@page import="com.lymava.qier.model.Product72"%>
<%@page import="com.lymava.commons.exception.CheckException"%>
<%@page import="com.lymava.trade.business.model.ProductItem"%>
<%@page import="java.util.List"%>
<%@page import="com.lymava.trade.business.model.ShoppingCart"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
	request.setAttribute("scope_snsapi", Gongzonghao.scope_snsapi_userinfo);
%>
<%@ include file="/header/check_openid.jsp"%>
<%@ include file="/header/header_check_login.jsp"%>
<%
	String zhuohao_id = HttpUtil.getParemater(request, "zhuohao_id");
	String requestFlow = HttpUtil.getParemater(request, "requestFlow");
	
	
	CheckException.checkIsTure(MyUtil.isValid(zhuohao_id), "当前桌号不存在!");
	Product72 zhuohao_find_out = (Product72) serializContext.get(Product72.class,zhuohao_id);
	
	CheckException.checkIsTure(zhuohao_find_out != null && Product72.state_nomal.equals(zhuohao_find_out.getState()), "当前桌号不存在!");
	
	Merchant72 merchant72 = (Merchant72)zhuohao_find_out.getUser_merchant();
	CheckException.checkIsTure(merchant72 != null && User.STATE_OK.equals(merchant72.getState()), "当前商户不存在!");
	
	BillMainRecord billMainRecord = new BillMainRecord();
	
	billMainRecord.setProductId(zhuohao_id);
	billMainRecord.setState(State.STATE_INPROCESS);
	/**
		先找出用餐中的订单
	*/
	billMainRecord = (BillMainRecord)serializContext.get(billMainRecord);
	/**	如果为空新开一个 **/
	if(billMainRecord == null){
		 response.sendRedirect(MyUtil.getBasePath(request)+"self_order/index.jsp");
		 return;
	}
	
	request.setAttribute("billMainRecord", billMainRecord);
	request.setAttribute("zhuohao_find_out", zhuohao_find_out);
%>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="utf-8">
		<meta name="viewport" content="width=device-width, initial-scale=1,maximum-scale=1,user-scalable=no">
		<meta name="apple-mobile-web-app-capable" content="yes">
		<meta name="apple-mobile-web-app-status-bar-style" content="black">
	    <title>已下单的菜</title>
	    <script type="text/javascript" >var basePath = '${basePath}';</script>
		<script type="text/javascript" src="${basePath }plugin/js/jquery/jquery-1.12.4.min.js"></script>
		<script type="text/javascript" src="${basePath }plugin/js/lymava_common.js?r=2018-09-03"></script>
		<script type="text/javascript" src="${basePath }self_order/js/project.js?r=2018-09-10"></script>
	
		<!--标准mui.css-->
		<link rel="stylesheet" href="${basePath }plugin_front/mui/css/mui.min.css">
		<link rel="stylesheet" href="${basePath }self_order/css/self_order.css">
		
		<script type="text/javascript" src="${basePath }js/fastclick.js"></script>
		<script type="text/javascript">
			jQuery(function(){
					FastClick.attach(document.body);
					
					//7.5rem 的偏移标识
					var width_rem = 75;//7.5
					
					var window_width = $(window).width();
					var window_height = $(window).height();
					
					var rem_font_size = window_width*10/width_rem;
					$("html").css("font-size",rem_font_size+'px');
					
					var height_all = window_height*width_rem/window_width/10;
					
					$('.confirm_order_list').css("height",(height_all-3)+"rem");
			}); 
		</script> 
</head>
<body>
	<body>
		<div class="mui-content">
			<div class="mui-row confirm_header">
		   	 	 <div class="mui-row confirm_header_state">
			 	 	订单已提交,等待店家确认
		   	 	 </div>	
		   	 	  <div class="mui-row confirm_header_zhuohao">
			 	 	<div class="mui-col-xs-4 confirm_header_zh">
			 	 		桌号 <c:out value="${billMainRecord.product.name }"/>
				    </div>
				    <div class="mui-col-xs-4 confirm_header_renshu">
				    	人数 <c:out value="${billMainRecord.yongcan_renshu }"/>
				    </div>
				    <div class="mui-col-xs-4 confirm_header_time">
				    	下单时间 <c:out value="${billMainRecord.showHms }"/>
				    </div>
		   	 	 </div>	 
		    </div>	
		   	<div class="mui-row confirm_order_list ">
		   		<c:forEach var="billItemRecord_tmp" items="${billMainRecord.billItemRecordList }" varStatus="i">
		   			 <div class="mui-row confirm_order_header">
					 	 	<div class="mui-col-xs-2 confirm_order_header_img">
					 	 		<img style="width: 0.6rem;height: 0.6rem;border-radius: 0.3rem;" alt="" src="<c:out value="${billItemRecord_tmp.user_huiyuan.picname }"/>">
						    </div>
						 	 <div class="mui-col-xs-2 confirm_order_header_name">
					 	 		<c:out value="${billItemRecord_tmp.user_huiyuan.nickname }"/>
						    </div>
						    <div class="mui-col-xs-4 confirm_order_header_renshu">
						    	2份
						    </div>
						    <div class="mui-col-xs-4 confirm_order_header_time">
						    	20:07
						    </div>
				   	</div>
				 	 <div class="mui-row confirm_order_product" <c:if test="${i.count == 1 }">style="border-top:0;"</c:if> >
						 	 		<c:if test="${billItemRecord_tmp.state ==  502}">
							 	 		<img class="state_img" alt="" src="${basePath }self_order/images/dai_shenghe.jpg">
						 	 		</c:if>
						 	 		<c:if test="${billItemRecord_tmp.state ==  500}">
							 	 		<img class="state_img" alt="" src="${basePath }self_order/images/yixiachu.jpg">
						 	 		</c:if>
							 	 	<div class="mui-col-xs-2 confirm_order_product_name">
							 	 		${billItemRecord_tmp.product.name }
								    </div>
								    <div class="mui-col-xs-4 confirm_order_product_fenshu">
								    	${billItemRecord_tmp.quantity/100 }份
								    </div>
								 	 <div class="mui-col-xs-2 confirm_order_product_price">
								 	 	¥${billItemRecord_tmp.showPrice_fen_all/100 }
								    </div> 
					</div>	 
				</c:forEach> 
		    </div>
		    <div class="mui-row index_footer">
			   <div class="mui-row index_footer_inner">
			     	<div class="mui-col-xs-3 confirm_order_footer_left" style="width: 3.75rem;">
			     		共 ¥ ${billMainRecord.bill_price_fen_all/100 }
			    	</div>
			    	<div class="mui-col-xs-3 confirm_order_footer_count" style="width: 3.75rem;">
			    	 <a href="${basePath }self_order/index.jsp?zhuohao_id=${zhuohao_find_out.id}&diancan=true" style="color: inherit;"  >
			     	 	 	继续点菜
			     	 	 </a>
			    	</div>
			    </div>
			    <%--  
			    <div class="mui-row index_footer_inner">
			    	<div class="mui-col-xs-3 confirm_order_footer_left">
			     	 	 <a href="${basePath }self_order/confirm_order.jsp?zhuohao_id=${zhuohao_find_out.id}" style="color: inherit;"  >
			     	 	 	继续点菜
			     	 	 </a>
			    	</div>
			     	<div class="mui-col-xs-3 confirm_order_footer_pay">
			     		共 ¥ 0.05 确认支付
			    	</div> 
			    </div>
			     --%>
		    </div>
		</div>
	</body>
		<script src="${basePath }plugin_front/mui/js/mui.min.js?r=2018-08-25"></script>
	    <script>
			mui.init(); 
			mui('.mui-scroll-wrapper').scroll();
		</script>
</body>
</html>
