<%@page import="com.lymava.base.vo.State"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%><%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="inc/header_search.jsp"%>
<div class="pageContent">
	<%@ include file="inc/header_toolBar.jsp"%>	
	<table class="table" width="100%" layoutH="138">
		<thead>
			<tr>
														<th width="30"><input type="checkbox" class="checkboxCtrl" group="${currentTimeMillis }checkbox" /></th>
														<th>openid </th>
														<th>用户名称 </th>
														<th>红包金额(元)</th>
														<th>红包有效开始时间 </th>
														<th>红包有效结束时间</th>
														<th>红包状态</th>
														<th>系统时间</th>
													
 			</tr>
		</thead>
		<tbody>
			<c:forEach var="object" varStatus="i" items="${object_ite }">
				<tr target="id" rel="${object.id }" id="${object.id }">
					<td><input type="checkbox" name="${currentTimeMillis }checkbox" value="${object.id }" /></td>
					<td><c:out value="${object.openid }" escapeXml="true"/></td>
					<td><c:out value="${object.user72.nickname}" escapeXml="true"/></td>
					<td><c:out value="${object.amount_fen/100}" escapeXml="true "/></td>
					<td><c:out value="${object.showStartTime}" escapeXml="true "/></td>
					<td><c:out value="${object.showEndTime}" escapeXml="true "/></td>
					<td><c:out value="${object.showState}" escapeXml="true "/></td>
					<td><c:out value="${object.showTime}" escapeXml="true "/></td>
 				</tr> 
			</c:forEach>
		</tbody>
	</table>
	<%@ include file="/v2/inc/list/spliteFooter.jsp"%>
</div>