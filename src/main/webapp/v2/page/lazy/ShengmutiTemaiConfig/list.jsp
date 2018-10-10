<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="inc/header_search.jsp"%>

<div class="pageContent">
	<%@ include file="inc/header_toolBar.jsp"%>	
	<table class="table" width="100%" layoutH="138">
		<thead>
			<tr>
				<th width="30"><input type="checkbox" class="checkboxCtrl" group="${currentTimeMillis }checkbox" /></th>
				<th>活动名</th>
				<th>开始时间</th>
				<th>结束时间</th>
				<th>状态</th>
				<th>商家</th>
				<th>需要好友</th>

				<th>折扣前</th>
				<th>折扣后</th>
				<th>展示折扣</th>
				<th>倒计时</th>
				<th>份数</th>
				<th>已经购买</th>

 			</tr>
		</thead>
		<tbody>
			<c:forEach var="object" varStatus="i" items="${object_ite }">
				<tr target="id" rel="${object.id }" id="${object.id }">
					<td><input type="checkbox" name="${currentTimeMillis }checkbox" value="${object.id }" /></td>

					<td><c:out value="${object.huodong_name}" escapeXml="true"/></td>
					<td><c:out value="${object.showHuodong_startTime}" escapeXml="true"/></td>
					<td><c:out value="${object.showHuodong_endTime }" escapeXml="true"/></td>
					<td><c:out value="${object.showState }" escapeXml="true"/></td>
					<td><c:out value="${object.merchant72.nickname }" escapeXml="true"/></td>
					<td><c:out value="${object.xuyao_haoyou }" escapeXml="true"/></td>

					<td><c:out value="${object.zhekou_qian/100 }" escapeXml="true"/></td>
					<td><c:out value="${object.zhekou_hou/100 }" escapeXml="true"/></td>
					<td><c:out value="${object.show_zhekou }" escapeXml="true"/></td>
					<td><c:out value="${object.daojishi }" escapeXml="true"/></td>
					<td><c:out value="${object.fenshu }" escapeXml="true"/></td>
					<td><c:out value="${object.yijing_goumei }" escapeXml="true"/></td>



 				</tr>
			</c:forEach>
		</tbody>
	</table>
	<%@ include file="/v2/inc/list/spliteFooter.jsp"%>
</div>