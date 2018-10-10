<%@page import="com.lymava.base.vo.State"%>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.List" %>
<%@ page import="com.lymava.qier.model.Voucher" %>
<%@ page import="java.util.Date" %>
<%@ page import="com.lymava.base.util.ContextUtil" %>
<%@ page import="static java.lang.System.currentTimeMillis" %>
<%@ page import="java.util.Iterator" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%><%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="inc/header_search.jsp"%>
<div class="pageContent">
	<%@ include file="inc/header_toolBar.jsp"%>	
	<table class="table" width="100%" layoutH="138">
		<thead>
			<tr>
				<th width="30"><input type="checkbox" class="checkboxCtrl" group="${currentTimeMillis }checkbox" /></th>
				<th>会员昵称</th>
				<th>openid</th>
				<th>用户姓名</th>
				<th>学校类别</th>
				<th>抽中学校</th>
				<th>状态</th>
 			</tr>
		</thead>
		<tbody>
			<c:forEach var="object" varStatus="i" items="${object_ite }">
				<tr target="id" rel="${object.id }" id="${object.id }">
					<td><input type="checkbox" name="${currentTimeMillis }checkbox" value="${object.id }" /></td>
					<td><c:out value="${object.nickName}" escapeXml="true"/></td>
					<td><c:out value="${object.openid }" escapeXml="true"/></td>
					<td><c:out value="${object.name }" escapeXml="true"/></td>
					<td><c:out value="${object.pubConlumn.name }" escapeXml="true"/></td>
					<td><c:out value="${object.pub_link.name }" escapeXml="true"/></td>
					<td><c:out value="${object.showState }" escapeXml="true"/></td>
 				</tr>
			</c:forEach>
		</tbody>
	</table>
	<%@ include file="/v2/inc/list/spliteFooter.jsp"%>
</div>