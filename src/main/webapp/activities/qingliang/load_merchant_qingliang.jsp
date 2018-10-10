<%@page import="com.lymava.nosql.util.QuerySort"%>
<%@page import="com.lymava.qier.activities.qingliang.MerchantQingliang"%>
<%@page import="java.util.Iterator"%>
<%@page import="com.lymava.nosql.util.PageSplit"%>
<%@page import="com.lymava.base.model.BalanceLog"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ include file="../../header/check_openid.jsp"%>
<%@ include file="../../header/header_check_login.jsp"%>
<%
	MerchantQingliang merchantQingliang = new MerchantQingliang();
	merchantQingliang.setState(State.STATE_OK);
	
	merchantQingliang.initQuerySort("price_fen", QuerySort.desc);
	
	String page_load_merchant = request.getParameter("page");
	String pageSize = "9";
	
	PageSplit pageSplit = new PageSplit(page_load_merchant,pageSize);
	
	Iterator<MerchantQingliang> merchantQingliang_ite =  serializContext.findIterable(merchantQingliang,pageSplit);
	
	request.setAttribute("merchantQingliang_ite", merchantQingliang_ite);
%>
			<div class="cool_cc">
				<img src="img/cash1.png"/>
			</div>
			<c:forEach var="merchantQingliang" items="${merchantQingliang_ite }" varStatus="i">
				<div class="cool_ca1" >
					<div class="cool_c1">
						<c:if test="${i.count == 1 }"><img src="img/one.png"/></c:if>
						<c:if test="${i.count == 2 }"><img src="img/two.png"/></c:if>
						<c:if test="${i.count == 3 }"><img src="img/three.png"/></c:if>
						<c:if test="${i.count > 3 }">
							<div class="cool1_c11">
								${i.count }.
							</div>
						</c:if>
					</div>
					<div class="cool_c2">
						<img src="${basePath }${merchantQingliang.user_merchant.picname }" style="width: 3.5rem;height: 3.5rem;"/>
					</div>
					<div class="cool_c3">
						筹款金额
					</div>
					<div class="cool_c4">
						CNY${merchantQingliang.showPriceYuan }
					</div>
				</div>
			<div class="clear"></div>
			</c:forEach>
			