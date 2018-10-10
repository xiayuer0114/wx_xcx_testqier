<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%><%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="inc/header_search.jsp"%>
<div class="pageContent">
	<%@ include file="inc/header_toolBar.jsp"%>
	<table class="table" width="100%" layoutH="138">
		<thead>
			<tr>
				<th width="30"><input type="checkbox" class="checkboxCtrl" group="${currentTimeMillis }checkbox" /></th>
				<th>商家</th>
				<%--<th>红包名称</th>--%>
				<th>金额</th>
				<th>状态</th>
				<th>标题</th>
 			</tr>
		</thead>
		<tbody>
			<c:forEach var="object" varStatus="i" items="${object_ite }">
				<tr target="id" rel="${object.id }" id="${object.id }">
					<td><input type="checkbox" name="${currentTimeMillis }checkbox" value="${object.id }" /></td>
					<td><c:out value="${object.user_merchant72.nickname}" escapeXml="true"/></td>
					<%--<td><c:out value="${object.redEnvelope_name}" escapeXml="true"/></td>--%>
					<td><c:out value="${object.showActivity_redEnvelope_price_yuan}" escapeXml="true"/></td>
					<td><c:out value="${object.showState}" escapeXml="true"/></td>
					<td><c:out value="${object.redEnvelope_intro}" escapeXml="true"/></td>
 				</tr>
			</c:forEach>
		</tbody>
	</table>
	<%@ include file="/v2/inc/list/spliteFooter.jsp"%>
</div>