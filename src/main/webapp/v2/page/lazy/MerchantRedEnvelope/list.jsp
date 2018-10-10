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
				<th>红包名称</th>
				<th>商家</th>
				<th>商家类型</th>
				<th>会员</th>
				<th>红包总额</th>
				<th>余额</th>
				<th>领取商家</th>
				<th>状态</th>
				<th>领取时间</th>
				<th>有效期</th>
				<th>生成时间</th>
 			</tr>
		</thead>
		<tbody>
			<c:forEach var="object" varStatus="i" items="${object_ite }">
				<tr target="id" rel="${object.id }" id="${object.id }">
					<td><input type="checkbox" name="${currentTimeMillis }checkbox" value="${object.id }" /></td>
					<td><c:out value="${object.red_envolope_name}" escapeXml="true"/></td>
					<td><c:out value="${object.user_merchant.showName}" escapeXml="true"/></td>
					<td><c:out value="${object.merchant_type }" escapeXml="true"/></td>
					<td><c:out value="${object.user_huiyuan.showName}" escapeXml="true"/></td>
					<td><c:out value="${object.amountFen/100}" escapeXml="true"/></td>
					<td><c:out value="${object.balanceFen/100 }" escapeXml="true"/></td>
					<td><c:out value="${object.user_merchant_lingqu.showName}" escapeXml="true"/></td>
					<td><c:out value="${object.showState }" escapeXml="true"/></td>
					<td><c:out value="${object.showLingqu_time }" escapeXml="true"/></td>
					<td><c:out value="${object.showExpiry_time }" escapeXml="true"/></td>
					<td><c:out value="${object.showTime }" escapeXml="true"/></td>
 				</tr>
			</c:forEach>
		</tbody>
	</table>
	<%@ include file="/v2/inc/list/spliteFooter.jsp"%>
</div>