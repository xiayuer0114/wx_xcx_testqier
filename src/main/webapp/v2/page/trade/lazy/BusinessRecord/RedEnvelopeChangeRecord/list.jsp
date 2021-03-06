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
				<th>订单编号</th>
				<th>管理员名称</th>
				<th>商户</th>
				<th>业务编号</th>
				<th>业务名称</th>
				<th>变动金额</th>
				<th>审核状态</th>
				<th>提交IP</th>
				<th>时间</th>
 			</tr>
		</thead>
		<tbody>
			<c:forEach var="object" varStatus="i" items="${object_ite }">
				<tr target="id" rel="${object.id }" id="${object.id }">
					<td><input type="checkbox" name="${currentTimeMillis }checkbox" value="${object.id }" /></td>
					<td><c:out value="${object.requestFlow }" escapeXml="true"/></td>
					<td><c:out value="${object.userV2.userName}" escapeXml="true"/></td>
					<td><c:out value="${object.user_huiyuan.showName }" escapeXml="true"/></td>
					<td><c:out value="${object.businessIntId }" escapeXml="true"/></td>
					<td><c:out value="${object.business.businessName }" escapeXml="true"/></td>
					<td><c:out value="${object.merchant_redenvelope_balance_change_Fen/100 }" escapeXml="true"/></td>
					<td>
						<c:if test="${object.state == 200}">未审核</c:if>
						<c:if test="${object.state == 300}">审核失败</c:if>
						<c:if test="${object.state == 500}">已变更</c:if>
					</td>
 					<td><c:out value="${object.ip }" escapeXml="true"/></td>
					<td><c:out value="${object.showTime }" escapeXml="true"/></td>
 				</tr> 
			</c:forEach>
		</tbody>
	</table>
	<%@ include file="/v2/inc/list/spliteFooter.jsp"%>
</div>