<%@ page language="java" contentType="text/html; charset=UTF-8"
		 pageEncoding="UTF-8"%><%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="inc/header_search.jsp"%>
<div class="pageContent">
	<%@ include file="inc/header_toolBar.jsp"%>
	<table class="table" width="100%" layoutH="138">
		<thead>
		<tr>
			<th width="30"><input type="checkbox" class="checkboxCtrl" group="${currentTimeMillis }checkbox" /></th>
			<th>用户openid</th>
			<th>用户昵称</th>
			<th>红包名字</th>
			<th>商家</th>
			<th>价格</th>
			<th>上一个红包</th>
			<th>状态</th>
		</tr>
		</thead>
		<tbody>
		<c:forEach var="object" varStatus="i" items="${object_ite }">
			<tr target="id" rel="${object.id }" id="${object.id }">
				<td><input type="checkbox" name="${currentTimeMillis }checkbox" value="${object.id }" /></td>
				<td><c:out value="${object.open_id}" escapeXml="true"/></td>
				<td><c:out value="${object.user72.nickname}" escapeXml="true"/></td>
				<td><c:out value="${object.merchantRedEnvelope.red_envolope_name}" escapeXml="true"/></td>
				<td><c:out value="${object.merchant72.nickname}" escapeXml="true"/></td>
				<td><c:out value="${object.activitieMerchant.showActivity_redEnvelope_price_yuan}" escapeXml="true"/></td>

				<td><c:out value="${object.paymentRecord.activitie_redEnvelope.activity_redEnvelope_name}" escapeXml="true"/></td>


				<td><c:out value="${object.showState}" escapeXml="true"/></td>
			</tr>
		</c:forEach>
		</tbody>
	</table>
	<%@ include file="/v2/inc/list/spliteFooter.jsp"%>
</div>