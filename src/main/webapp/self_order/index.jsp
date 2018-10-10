<%@page import="com.lymava.qier.self_order.model.BillMainRecord"%>
<%@page import="com.lymava.trade.business.model.ProductItem"%>
<%@page import="com.lymava.trade.business.model.ShoppingCart"%>
<%@page import="com.lymava.qier.model.Product72"%>
<%@page import="com.lymava.commons.util.MathUtil"%>
<%@page import="java.util.List"%>
<%@page import="com.lymava.base.model.PubConlumn"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
	request.setAttribute("scope_snsapi", Gongzonghao.scope_snsapi_userinfo);
%>
<%@ include file="/header/check_openid.jsp"%>
<%@ include file="/header/header_check_login.jsp"%>
<%

	String pubConlumn_caipin_id = request.getParameter("pubConlumn_caipin_id");

	String 	diancan =  request.getParameter("diancan");
	String 	zhuohao_id =  request.getParameter("zhuohao_id");
	String 	bianhao_str =  request.getParameter("b");
	Long 	bianhao = MathUtil.parseLongNull(bianhao_str);
	
	Product72 zhuohao_find_out = null;
	if(MyUtil.isValid(zhuohao_id)){
		zhuohao_find_out = (Product72) serializContext.get(Product72.class,zhuohao_id);
	}
	if(zhuohao_find_out == null && bianhao != null){
		Product72 product_find = new Product72();
		product_find.setBianhao(bianhao);
		zhuohao_find_out = (Product72) serializContext.get(product_find);
	}
	//桌号不存在
	if(zhuohao_find_out == null  ){ 
		response.sendRedirect(MyUtil.getBasePath(request)+"data_error.jsp");
		return;
	} 
	
	BillMainRecord billMainRecord = new BillMainRecord();
	
	billMainRecord.setProductId(zhuohao_id);
	billMainRecord.setState(State.STATE_INPROCESS);
	/**
		先找出用餐中的订单
	*/
	billMainRecord = (BillMainRecord)serializContext.get(billMainRecord);
	/**	如果为空新开一个 **/
	if(billMainRecord != null && diancan == null){
		 response.sendRedirect(MyUtil.getBasePath(request)+"self_order/confirm_order.jsp?zhuohao_id="+zhuohao_find_out.getId());
		 return;
	}
	
	PubConlumn pubConlumn_caipin_root = PubConlumn.getFinalPubConlumn("5b9939480e9f11207824c27e");
	List<PubConlumn> pubConlumn_caipin_list = pubConlumn_caipin_root.getChildrenPubConlumns();
	
	if(!MyUtil.isValid(pubConlumn_caipin_id) && pubConlumn_caipin_list != null && pubConlumn_caipin_list.size() > 0){
		pubConlumn_caipin_id = pubConlumn_caipin_list.get(0).getId();
	}
	
	ShoppingCart shoppingCart =   	ShoppingCart.getGouwuche(session);

	List<ProductItem> product_item_list = shoppingCart.getProduct_item_list();

	request.setAttribute("shoppingCart", shoppingCart);
	request.setAttribute("product_item_list", product_item_list);
	
	request.setAttribute("pubConlumn_caipin_list", pubConlumn_caipin_list);
	request.setAttribute("pubConlumn_caipin_id", pubConlumn_caipin_id);
	request.setAttribute("zhuohao_find_out", zhuohao_find_out);
%>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="utf-8">
		<meta name="viewport" content="width=device-width, initial-scale=1,maximum-scale=1,user-scalable=no">
		<meta name="apple-mobile-web-app-capable" content="yes">
		<meta name="apple-mobile-web-app-status-bar-style" content="black">
	    <title>悠择点餐</title>
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
				$(function(){
					//7.5rem 的偏移标识
					var width_rem = 75;//7.5
					
					var window_width = $(window).width();
					var window_height = $(window).height();
					
					var rem_font_size = window_width*10/width_rem;
					$("html").css("font-size",rem_font_size+"px");
					
					var height_all = window_height*width_rem/window_width/10;
					
					$('.index_content').css("height",(height_all-2.3)+"rem");
				}); 
			}); 
		</script> 
</head>
<body>
	<body>
		<form  name="submit_shopcart_to_order_form" id="submit_shopcart_to_order_form" action="${basePath }self_order/confirm_order.jsp">
			<input id="zhuohao_id" type="hidden" name="zhuohao_id" value="${zhuohao_find_out.id}" />
			<input id="requestFlow" type="hidden" name="requestFlow" value="<%=MathUtil.create_new_flow() %>" />
		</form>
		<div class="mui-content">
			<div class="mui-row index_header">
			 	<div class="mui-col-xs-3 index_header_logo">
					<img alt="" src="${basePath }self_order/images/logo.jpg">	
			    </div>
			    <div class="mui-col-xs-3 index_header_right">
					<div class="mui-row index_header_name">
					 	 酒阳蒸经新上海店
				    </div>
				    <div class="mui-row index_header_gonggao">
					 	 公告:今日消费全场买单8则!!!!!
				    </div>					 	
			    </div>	
		    </div>
		    <div class="mui-row index_content">
		       	<div class="left mui-col-xs-3">
		       		<c:forEach var="pubConlumn_caipin" items="${pubConlumn_caipin_list }" varStatus="i">
			       		<div onclick="load_product_clicked(this)" data="${pubConlumn_caipin.id }" class="<c:if test="${i.count == 1 }">fenlei_current</c:if><c:if test="${i.count != 1 }">fenlei</c:if>">
			       			<div class="fenlei_content">
			       				<c:out value="${pubConlumn_caipin.name }" escapeXml="true" />
				       		</div> 
			       		</div>
		       		</c:forEach>
		       	</div>
		       	<div class="right mui-col-xs-9">
		       		<div class="fenlei index_product_content">
						 
		       		</div>
		       	</div>
		    </div>
		    <div class="mui-row index_footer">
			    <div class="mui-row index_footer_inner">
			    	<div class="mui-col-xs-3 index_footer_count">
			     	 	<img onclick="pop_shop_cart()" alt="" src="${basePath }self_order/images/gouwuche_you.png">
			     	 	<div class="cart_count">
			     	 		${shoppingCart.shoppingCartSize }
			     	 	</div>
			    	</div>
			     	<div class="mui-col-xs-3 index_footer_left">
			     	共 ¥ <font class="price_yuan_all">${shoppingCart.price_fen_all/100 }</font>
			    	</div>
			    	<div class="mui-col-xs-3 index_footer_right" onclick="submit_shopcart_to_order()">
			     		确认下单
			    	</div>
			    </div>
		    </div>
		    <div id="shop_cart" class="box mui-popover mui-popover-action mui-popover-bottom shop_cart" >
		    	<div class="mui-row shop_cart_header">
			     	 <img class="shop_cart_count_img"  alt="" src="${basePath }self_order/images/gouwuche_you.png">
			     	 <img class="gouwuche_jiantou_shang"  alt="" src="${basePath }self_order/images/gouwuche_jiantou_shang.png">
			     	 <div class="shop_cart_count cart_count">
			     	 		${shoppingCart.shoppingCartSize }
			     	 </div>
			     	<div class="mui-col-xs-6" style="padding-left: 0.25rem;">
				     	点菜单
				    </div>
				    <div class="mui-col-xs-6 shop_cart_clear" onclick="shop_cart_clear()">
				     	<img alt="" src="${basePath }self_order/images/clear_cart.png">
				    </div>
			    </div>
			    <div class="mui-row shop_cart_content" style="position: relative;">
				    <div class="mui-scroll-wrapper">
						<div class="mui-scroll shop_cart_scroll_content">
							
						     
						</div>
					</div>
			    </div>
			     <div class="mui-row shop_cart_footer">
			     	 <div class="mui-col-xs-6 shop_cart_footer_left"  >
				     	共 ¥ <font class="price_yuan_all">${shoppingCart.price_fen_all/100 }</font>
					 </div>
					 <div class="mui-col-xs-6 shop_cart_footer_right" onclick="submit_shopcart_to_order()">
					 		确认下单
					 </div>
			    </div>
		    </div>
		</div>
	</body>
		<script src="${basePath }plugin_front/mui/js/mui.min.js?r=2018-08-25"></script>
	    <script>
	    	var pubConlumn_caipin_id = '${pubConlumn_caipin_id }';
			
			$(function(){
				
				mui.init();
				mui('.mui-scroll-wrapper').scroll();
				
				load_product(pubConlumn_caipin_id);
			});
		</script>
</body>
</html>
