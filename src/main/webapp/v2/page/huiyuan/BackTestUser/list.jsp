<%@page import="com.lymava.base.model.User"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="inc/header_search.jsp" %>
<div class="pageContent">
	<%@ include file="inc/header_panelBar.jsp" %>
	<table class="table" width="100%" layoutH="138">
		<thead>
			<tr>
														<th width="30"><input type="checkbox" class="checkboxCtrl" group="${currentTimeMillis }checkbox" /></th>
														<th>编号</th>
														<th>用户名</th>
														<th>unionid</th>
														<th>用户组</th>
									    				<th>昵称</th>
									    				<th>姓名</th>
									    				<th>余额</th>
									    				<th>积分</th>
									    				<th>登录ip</th>
									    				<th>状态</th>
									    				<th>注册日期</th>
			</tr>
		</thead>
		<tbody>
			<c:forEach var="user" varStatus="i" items="${user_list }">
				<tr target="id" rel="${user.id }" id="${user.id }">
					<td><input type="checkbox" name="${currentTimeMillis }checkbox" value="${user.id }" /></td>
					<td><c:out value="${user.bianhao }" escapeXml="true"/></td>
					<td><c:out value="${user.username }" escapeXml="true"/></td>
					<td><c:out value="${user.unionid }" escapeXml="true"/></td>
					<td><c:out value="${user.userGroup.name }" escapeXml="true"/></td>
					<td><c:out value="${user.nickname }" escapeXml="true"/></td>
					<td><c:out value="${user.realname }" escapeXml="true"/></td>
					<td><c:out value="${user.showBalance }" escapeXml="true"/></td>
					<td><c:out value="${user.showIntegral }" escapeXml="true"/></td>
					<td><a href="${basePath  }v2/huiyuan/edit.do?return_mod=loginip_list&id={id}" target="dialog"><c:out value="${user.lastLoginIp }" escapeXml="true"/></a></td>
					<td><c:out value="${user.showState }" escapeXml="true"/></td>
					<td><c:out value="${user.showTime }" escapeXml="true"/></td>
				</tr>
			</c:forEach>
		</tbody>
	</table>
	<%@ include file="/v2/inc/list/spliteFooter.jsp"%>
</div>