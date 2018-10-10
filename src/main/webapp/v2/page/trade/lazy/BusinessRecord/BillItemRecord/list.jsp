<%@page import="com.lymava.commons.state.State"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%><%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="inc/header_search.jsp"%>
<div class="pageContent">
	<%@ include file="inc/header_toolBar.jsp"%>	
	<table class="table" width="100%" layoutH="138">
		<thead>
			<tr>
				<th width="30"><input type="checkbox" class="checkboxCtrl" group="${currentTimeMillis }checkbox" /></th>
				<th>主订单号</th>
				<th>用户</th>
				<th>菜品</th>
				<th>数量</th>
				<th>单价</th>
				<th>总价</th>
				<th>商户</th>
				<th>状态</th>
				<th>时间</th>
 			</tr>
		</thead>
		<tbody>
			<c:forEach var="object" varStatus="i" items="${object_ite }">
				<tr target="id" rel="${object.id }" id="${object.id }">
					<td><input type="checkbox" name="${currentTimeMillis }checkbox" value="${object.id }" /></td>
					<td><c:out value="${object.paymentRecord_id }" escapeXml="true"/></td>
					<td><c:out value="${object.user_huiyuan.username }" escapeXml="true"/></td>
					<td><c:out value="${object.product.name }" escapeXml="true"/></td>
					<td><c:out value="${object.price_fen/100 }" escapeXml="true"/></td>
					<td><c:out value="${object.quantity/100}" escapeXml="true"/></td>
					<td><c:out value="${object.showPrice_fen_all/100 }" escapeXml="true"/></td>
					<td><c:out value="${object.user_merchant.nickname  }" escapeXml="true"/></td>
 					<td><c:out value="${object.showState }" escapeXml="true"/></td>
					<td><c:out value="${object.showTime }" escapeXml="true"/></td>
 				</tr> 
			</c:forEach> 
		</tbody>
	</table>
	<%@ include file="/v2/inc/list/spliteFooter.jsp"%>
</div>