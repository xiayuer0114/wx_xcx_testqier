<%@page import="com.lymava.commons.state.State"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%><%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="inc/header_search.jsp"%>
<div class="pageContent">
	<%@ include file="../inc/header_toolBar.jsp"%>	
	<table class="table" width="100%" layoutH="138">
		<thead>
			<tr>
				<th width="30"><input type="checkbox" class="checkboxCtrl" group="${currentTimeMillis }checkbox" /></th>
				<th>订单编号</th>
				<th>用户</th>
				<th>商户</th>
				<th>业务编号</th>
				<th>业务名称</th>
				<th>交易金额</th>
				<th>支付时间</th>
				<th>支付方式</th>
				<th>实际支付</th>
				<th>钱包抵扣</th>
				<th>账户余额</th>
				<th>状态</th>
				<th>提交IP</th>
				<th>时间</th>
 			</tr>
		</thead>
		<tbody>
			<c:forEach var="object" varStatus="i" items="${object_ite }">
				<tr target="id" rel="${object.id }" id="${object.id }">
					<td><input type="checkbox" name="${currentTimeMillis }checkbox" value="${object.id }" /></td>
					<td><c:out value="${object.requestFlow }" escapeXml="true"/></td>
					<td><c:out value="${object.user_huiyuan.showName }" escapeXml="true"/></td>
					<td><c:out value="${object.user_merchant.showName }" escapeXml="true"/></td>
					<td><c:out value="${object.businessIntId }" escapeXml="true"/></td>
					<td><c:out value="${object.business.businessName }" escapeXml="true"/></td>
					<td><c:out value="${object.price_fen_all/100 }" escapeXml="true"/></td>
					<td><c:out value="${object.showPayTime }" escapeXml="true"/></td>
					<td><c:out value="${object.showPay_method }" escapeXml="true"/></td> 
					<td><c:out value="${object.thirdPayPrice_fen_all/100 }" escapeXml="true"/></td>
					<td><c:out value="${object.wallet_amount_payment_fen/100 }" escapeXml="true"/></td>
					<td><c:out value="${object.wallet_amount_balance_fen/100 }" escapeXml="true"/></td>
 					<td><c:out value="${object.showState }" escapeXml="true"/></td>
 					<td><c:out value="${object.ip }" escapeXml="true"/></td>
					<td><c:out value="${object.showTime }" escapeXml="true"/></td>
 				</tr> 
			</c:forEach>
		</tbody>
	</table>
	<%@ include file="/v2/inc/list/spliteFooter.jsp"%>
</div>