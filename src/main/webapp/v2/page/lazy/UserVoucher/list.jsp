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
				<th>商家名</th>
				<th>代金券名称</th>
				<th>描述</th>
				<th>价值</th>
				<th>获得会员</th>
				<th>获得时间</th>
				<th>有效时间</th>
				<th>状态</th>
 			</tr>
		</thead>
		<tbody>
			<c:forEach var="object" varStatus="i" items="${object_ite }">
				<tr target="id" rel="${object.id }" id="${object.id }">
					<td><input type="checkbox" name="${currentTimeMillis }checkbox" value="${object.id }" /></td>
					<td><c:out value="${object.user_merchant.showName}" escapeXml="true"/></td>
					<td><c:out value="${object.voucher.voucherName}" escapeXml="true"/></td>
					<td><c:out value="${object.voucher.voucherMiaoSu}" escapeXml="true"/></td>
					<td><c:out value="${object.voucher.voucherValue }" escapeXml="true"/></td>
					<td><c:out value="${object.user_huiyuan.showName}" escapeXml="true"/></td>
					<td><c:out value="${object.showTime }" escapeXml="true"/></td>
					<td><c:out value="${object.voucher.showInStopTime }" escapeXml="true"/></td>
					<td><c:out value="${object.showUseState }" escapeXml="true"/></td>
 				</tr>
			</c:forEach>
		</tbody>
	</table>
	<%@ include file="/v2/inc/list/spliteFooter.jsp"%>
</div>