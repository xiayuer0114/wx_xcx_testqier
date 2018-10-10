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
				<th>订单编号</th>
				<th>业务名称</th>
				<th>管理员名称</th>
				<th>用户登录名</th>
				<th>用户名称</th>
				<th>红包总数量</th>
				<th>红包总金额</th>
				<th>登录ip记录</th>
				<th>状态</th>
				<th>操作时间</th>
 			</tr>
		</thead>
		<tbody>
			<c:forEach var="object" varStatus="i" items="${object_ite }">
				<tr target="id" rel="${object.id }" id="${object.id }">
					<td><input type="checkbox" name="${currentTimeMillis }checkbox" value="${object.id }" /></td>
					<td><c:out value="${object.requestFlow}" escapeXml="true"/></td>
					<td><c:out value="${object.business.businessName }" escapeXml="true"/></td>
					<td><c:out value="${object.userV2.userName}" escapeXml="true"/></td>
					<td><c:out value="${object.user_huiyuan.username }" escapeXml="true"/></td>
					<td><c:out value="${object.user_huiyuan.nickname }" escapeXml="true"/></td>
					<td><c:out value="${object.redEnvelopeSCount}" escapeXml="true"/></td>
					<td><c:out value="${object.amount / 1000000}" escapeXml="true"/></td>
					<td><c:out value="${object.ip}" escapeXml="true"/></td>
					<td><c:out value="${object.showState}" escapeXml="true"/></td>
					<td><c:out value="${object.showTime}" escapeXml="true"/></td>
 				</tr>
			</c:forEach>
		</tbody>
	</table>
	<%@ include file="/v2/inc/list/spliteFooter.jsp"%>
</div>