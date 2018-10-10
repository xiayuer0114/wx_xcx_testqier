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
				<th>消费商家</th>
				<th>共享商家</th>
				<th>规则状态</th>
				<th>生效时间</th>
				<th>失效时间</th>
				<th>排序时间</th>
 			</tr>
		</thead>
		
		<tbody>
			<c:forEach var="object" varStatus="i" items="${object_ite }">
				<tr target="id" rel="${object.id }" id="${object.id }">
					<td><input type="checkbox" name="${currentTimeMillis }checkbox" value="${object.id }" /></td>
					<td><c:out value="${object.user_merchant_xiaofei.showName}" escapeXml="true"/></td>
					
					<td><c:out value="${object.user_merchant_gongxiang.showName}" escapeXml="true"/></td>
					
					
					
					<td><c:out value="${object.state_str }" escapeXml="true"/></td>
					<td><c:out value="${object.start_time_shengxiao_str}" escapeXml="true"/></td>
					<td><c:out value="${object.end_time_shengxiao_str }" escapeXml="true"/></td>
					<td><c:out value="${object.sort_id_str }" escapeXml="true"/></td>
 				</tr>
			</c:forEach>
		</tbody>
	</table>
	<%@ include file="/v2/inc/list/spliteFooter.jsp"%>
</div>