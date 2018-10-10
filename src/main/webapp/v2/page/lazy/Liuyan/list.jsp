<%@page import="com.lymava.base.vo.State"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%><%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%--<%@ include file="inc/header_search.jsp"%>--%>
<div class="pageContent">
	<%@ include file="inc/header_toolBar.jsp"%>
	<table class="table" width="100%" layoutH="138">
		<thead>
			<tr>
				<th width="30"><input type="checkbox" class="checkboxCtrl" group="${currentTimeMillis }checkbox" /></th>
				<th>留言姓名 </th>
				<th>邮箱</th>
				<th>内容</th>
				<th>ip地址</th>
				<th>提交时间</th>
				<th>备注</th>
				<th>状态</th>
 			</tr>
		</thead>
		<tbody>
			<c:forEach var="object" varStatus="i" items="${object_ite }">
				<tr target="id" rel="${object.id }" id="${object.id }">
					<td><input type="checkbox" name="${currentTimeMillis }checkbox" value="${object.id }" /></td>
					<td><c:out value="${object.name}" escapeXml="true"/></td>
					<td><c:out value="${object.email}" escapeXml="true "/></td>
					<td><c:out value="${object.leaveMessage}" escapeXml="true "/></td>
					<td><c:out value="${object.ipAddr}" escapeXml="true "/></td>
					<td><c:out value="${object.showSubTimeDay}" escapeXml="true "/></td>
					<td><c:out value="${object.memo}" escapeXml="true"/></td>
					<td>
						<c:if test="${object.state ==200 }">正常</c:if>
						<c:if test="${object.state ==300 }">异常</c:if>
					</td>
 				</tr> 
			</c:forEach>
		</tbody>
	</table>
	<%@ include file="/v2/inc/list/spliteFooter.jsp"%>
</div>