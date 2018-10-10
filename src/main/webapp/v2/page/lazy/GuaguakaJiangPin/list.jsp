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
														<th>奖品类型</th>
														<th>抽中金额</th>
														<th>商家</th>
														<th>中奖数</th>
														<th>状态 </th>
														<th>系统时间</th>
													
 			</tr>
		</thead>
		<tbody>
			<c:forEach var="object" varStatus="i" items="${object_ite }">
				<tr target="id" rel="${object.id }" id="${object.id }">
					<td><input type="checkbox" name="${currentTimeMillis }checkbox" value="${object.id }" /></td>
					<td><c:out value="${object.openid }" escapeXml="true"/></td>
					<td><c:out value="${object.user_huiyuan.nickname}" escapeXml="true"/></td>
					<td><c:out value="${object.showType_jiangpin}" escapeXml="true"/></td>
					<td><c:out value="${object.price_fen/100}" escapeXml="true"/></td>
					<td><c:out value="${object.merchantRedEnvelope.user_merchant.showName}" escapeXml="true"/></td>
					<td><c:out value="${object.rand_number}" escapeXml="true"/></td>
					<td><c:out value="${object.showState}" escapeXml="true "/></td>
					<td><c:out value="${object.showTime}" escapeXml="true "/></td>
 				</tr> 
			</c:forEach>
		</tbody>
	</table>
	<%@ include file="/v2/inc/list/spliteFooter.jsp"%>
</div>