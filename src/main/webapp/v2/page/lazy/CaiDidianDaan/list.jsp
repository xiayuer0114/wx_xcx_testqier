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
				<th>用户的openid</th>
				<th>用户名</th>
				<th>奖品类型</th>
				<th>中奖状态</th>
				<th>地点名称</th>
				<th>生成几率</th>
				<th>领取时间</th>
				<th>复活次数</th>
				<th>复活时间</th>
 			</tr>
		</thead>
		<tbody>
			<c:forEach var="object" varStatus="i" items="${object_ite }">
				<tr target="id" rel="${object.id }" id="${object.id }">
					<td><input type="checkbox" name="${currentTimeMillis }checkbox" value="${object.id }" /></td>
					<td><c:out value="${object.openid }" escapeXml="true"/></td>
					<td><c:out value="${object.user_huiyuan.username }" escapeXml="true"/></td>
					<td>
						<c:if test="${object.type_jiangpin == 1 }">
							未中奖
						</c:if>
						<c:if test="${object.type_jiangpin == 2 }">
							6.66 红包
						</c:if>
						<c:if test="${object.type_jiangpin == 3 }">
							1.66 红包
						</c:if>
					</td>
					<td>
						<c:if test="${object.state == 200 }">
							已发放
						</c:if>
						<c:if test="${object.state == 300 }">
							未中奖
						</c:if>
						<c:if test="${object.state == 502 }">
							未开宝箱
						</c:if>
					</td>
					<td><c:out value="${object.didian.didianming }" escapeXml="true"/></td>
					<td>
						<c:if test="${not empty object.rand_number }">
							<c:out value="${object.rand_number / 100 }" escapeXml="true"/>
						</c:if>
					</td>
					<td><c:out value="${object.showLingqu_day }" escapeXml="true"/></td>
					<td><c:out value="${object.relife_count }" escapeXml="true"/></td>
					<td><c:out value="${object.showRelife_day }" escapeXml="true"/></td>
				</tr>
			</c:forEach>
		</tbody>
	</table>
	<%@ include file="/v2/inc/list/spliteFooter.jsp"%>
</div>