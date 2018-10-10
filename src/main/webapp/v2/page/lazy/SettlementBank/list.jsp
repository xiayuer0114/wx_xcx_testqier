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
				<th>银行名称</th>
				<th>开户行</th>
				<th>开户行地址</th>
				<th>帐号</th>
				<th>账户名称</th>
				<th>状态</th>
				<th>备注</th>
 			</tr>
		</thead>
		<tbody>
			<c:forEach var="object" varStatus="i" items="${object_ite }">
				<tr target="id" rel="${object.id }" id="${object.id }">
					<td><input type="checkbox" name="${currentTimeMillis }checkbox" value="${object.id }" /></td>
					<td><c:out value="${object.merchant72.nickname}" escapeXml="true"/></td>
					<td><c:out value="${object.showBankName }" escapeXml="true"/></td>
					<td><c:out value="${object.depositary_bank }" escapeXml="true"/></td>
					<td><c:out value="${object.bank_addr }" escapeXml="true"/></td>
					<td><c:out value="${object.account }" escapeXml="true"/></td>
					<td><c:out value="${object.name }" /></td>
					<td>
						<c:if test="${object.state ==200 }">正常使用</c:if>
						<c:if test="${object.state ==300 }">暂停使用</c:if>
					</td>
					<td><c:out value="${object.memo }" escapeXml="true"/></td>
 				</tr>
			</c:forEach>
		</tbody>
	</table>
	<%@ include file="/v2/inc/list/spliteFooter.jsp"%>
</div>