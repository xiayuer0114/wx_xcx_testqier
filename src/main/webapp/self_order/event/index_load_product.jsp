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

	String pubConlumn_caipin_id = request.getParameter("pubConlumn_caipin_id");
	PubConlumn pubConlumn_current = PubConlumn.getFinalPubConlumn(pubConlumn_caipin_id);
	
	ShoppingCart shoppingCart =   	ShoppingCart.getGouwuche(session);

	Product product_find = new Product();
	product_find.setPubConlumnId(pubConlumn_caipin_id);

	SerializContext serializContext = ContextUtil.getSerializContext();
	
	Iterator<Product> product_ite =  serializContext.findIterable(product_find);
	
	request.setAttribute("product_ite", product_ite);
	request.setAttribute("pubConlumn_caipin_id", pubConlumn_caipin_id);
	request.setAttribute("pubConlumn_current", pubConlumn_current);
%>
<div class="header">
							<div class="header_right">
								<c:out value="${pubConlumn_current.name }" escapeXml="true" />
							</div>			
			       		</div>	
			       		<div class="product_list">
			       		  <c:forEach var="product_tmp" items="${product_ite }" >
			       		  	<c:set scope="request" value="${product_tmp }" var="product_tmp_set" />
			       		  	<% 
			       		 		Product product_tmp = (Product)request.getAttribute("product_tmp_set");
			       		  		if(product_tmp != null){
			       		  			ProductItem productItem = shoppingCart.getProductItem(product_tmp.getId());
			       		  			request.setAttribute("productItem", productItem);
			       		  		}
			       		  	%>
							<div class="mui-row product">
								<div class="mui-col-xs-3 image">
									   <img alt="" src="${basePath }${product_tmp.pic }">	
			       				</div>
			       				<div class="mui-col-xs-3 desc">
									  <div class="mui-row title">
									  	<c:out value="${product_tmp.name }" escapeXml="true" />
									  </div>	 
									  <div class="mui-row yishou">已售 ${product_tmp.had_sale }</div>
									  <div class="mui-row xianjia">¥${product_tmp.price_fen/100 }/份</div>
									  <div class="mui-row yuanjia">会员价:¥${product_tmp.price_fen/100 }/份</div>	
			       				</div>	
			       				<div class="mui-col-xs-3 jiajian">
									 <div class="mui-row buttons add_to_cart_content" data="${product_tmp.id }" >
									 	<div onclick="add_to_shoppingCart_clicked(this)" class="mui-col-xs-3 jian_btn" count="-1">
									 		<img alt="" src="${basePath }self_order/images/jian.jpg" style="width: 100%;height: 100%;">
									 	</div>
									 	<div class="mui-col-xs-3 shuzi shuzi_${product_tmp.bianhao }">
									 		<c:if test="${empty productItem}">0</c:if>
									 		<c:if test="${!empty productItem}">${productItem.count }</c:if>
									 	</div>
									 	<div onclick="add_to_shoppingCart_clicked(this)"  class="mui-col-xs-3 jia_btn" count="1">
									 		<img alt="" src="${basePath }self_order/images/jia.jpg" style="width: 100%;height: 100%;">
									 	</div>
									 </div>	
			       				</div>	
			       			</div>  
			       			<div class="mui-row line"></div> 	       			
			       		</c:forEach>
			       </div>  
			       		
			       		