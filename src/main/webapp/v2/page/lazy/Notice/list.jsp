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
														<th>考生姓名 </th>
														<th>性别</th>
														<th>身份证号 </th>
														<th>考生证</th>
														<th>报名序号 </th>
														<th>科类型</th>
													
 			</tr>
		</thead>
		<tbody>
			<c:forEach var="object" varStatus="i" items="${object_ite }">
				<tr target="id" rel="${object.id }" id="${object.id }">
					<td><input type="checkbox" name="${currentTimeMillis }checkbox" value="${object.id }" /></td>
					<td><c:out value="${object.name}" escapeXml="true"/></td>
					<td><c:out value="${object.sex}" escapeXml="true "/></td>
					<td><c:out value="${object.idNumber}" escapeXml="true "/></td>
					<td><c:out value="${object.examineeCard}" escapeXml="true "/></td>
					<td><c:out value="${object.signUpSerialNumber}" escapeXml="true "/></td>
					<td><c:out value="${object.artsAndScience}" escapeXml="true"/></td>
 				</tr> 
			</c:forEach>
		</tbody>
	</table>
	<%@ include file="/v2/inc/list/spliteFooter.jsp"%>
</div>