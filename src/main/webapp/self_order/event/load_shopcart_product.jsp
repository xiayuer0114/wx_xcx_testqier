<%@page import="com.lymava.trade.business.model.ProductItem"%>
<%@page import="com.lymava.trade.business.model.ShoppingCart"%>
<%@page import="java.util.Iterator"%>
<%@page import="com.lymava.nosql.context.SerializContext"%>
<%@page import="com.lymava.base.util.ContextUtil"%>
<%@page import="java.awt.image.renderable.ContextualRenderedImageFactory"%>
<%@page import="com.lymava.trade.business.model.Product"%>
<%@page import="java.util.List"%>
<%@page import="com.lymava.base.model.PubConlumn"%>
<%@page import="com.lymava.commons.util.MyUtil"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%

	ShoppingCart shoppingCart =   	ShoppingCart.getGouwuche(session);

	List<ProductItem> product_item_list = shoppingCart.getProduct_item_list();

	request.setAttribute("shoppingCart", shoppingCart);
	request.setAttribute("product_item_list", product_item_list);
%>
<c:forEach var="product_item"  items="${product_item_list }">
	<div class="mui-row shop_cart_product">
							     	 <div class="mui-col-xs-4 shop_cart_product_name"  >
								     	<c:out value="${product_item.product.name }" escapeXml="true" />
									 </div>
									 <div class="mui-col-xs-4 shop_cart_product_jiage" >
									 	¥<c:out value="${product_item.product.price_fen/100 }" escapeXml="true" />
									 </div>
									 <div class="mui-col-xs-4 shop_cart_product_jia_jian" >
									 	<div class="mui-row buttons" data="${product_item.product.id }">
												 	<div onclick="add_to_shoppingCart_clicked(this)" class="mui-col-xs-3 jian_btn" count="-1">
												 		<img alt="" src="${basePath }self_order/images/jian.jpg" style="width: 100%;height: 100%;">
												 	</div>
												 	<div class="mui-col-xs-3 shuzi shuzi_${product_item.product.bianhao }">
												 		<c:out value="${product_item.count }" escapeXml="true" />
												 	</div>
												 	<div onclick="add_to_shoppingCart_clicked(this)" class="mui-col-xs-3 jia_btn" count="1">
												 		<img alt="" src="${basePath }self_order/images/jia.jpg" style="width: 100%;height: 100%;">
												 	</div>
										</div>	 
									 </div>
	</div> 
</c:forEach>	       		
			       		