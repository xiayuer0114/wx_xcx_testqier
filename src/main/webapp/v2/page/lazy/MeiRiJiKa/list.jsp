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
				<th>我的openid</th>
				<th>朋友openid</th>
				<th>集卡名称</th>
				<th>集卡类型</th>
				<th>状态</th>
				<th>活动日期</th>
 			</tr>
		</thead>
		<tbody>
			<c:forEach var="object" varStatus="i" items="${object_ite }">
				<tr target="id" rel="${object.id }" id="${object.id }">
					<td><input type="checkbox" name="${currentTimeMillis }checkbox" value="${object.id }" /></td>
					<td><c:out value="${object.my_openid}" escapeXml="true"/></td>
					<td><c:out value="${object.friend_openid}" escapeXml="true"/></td>
					<td><c:out value="${object.jika_lei }" escapeXml="true"/></td>
					<td><c:out value="${object.card_type }" escapeXml="true"/></td>
					<td><c:out value="${object.showState }" escapeXml="true"/></td>
					<td><c:out value="${object.showJika_kaishi_day }" escapeXml="true"/></td>
 				</tr>
			</c:forEach>
		</tbody>
	</table>
	<%@ include file="/v2/inc/list/spliteFooter.jsp"%>
</div>