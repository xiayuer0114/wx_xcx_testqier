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
				<th>商家名称</th>
				<th>类型</th>
				<th>通用红包</th>
				<th>联系人</th>
				<th>联系电话</th>
				<th>业务员</th>
				<th>商户预付款</th>
				<th>定向红包余额</th>
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
					<td><c:out value="${user.nickname }" escapeXml="true"/></td>
					<td><c:out value="${user.merchant72_type }" escapeXml="true"/></td>
					<td><c:out value="${user.red_pack_ratio_min/10000 }" escapeXml="true"/>%-<c:out value="${user.red_pack_ratio_max/10000 }" escapeXml="true"/>%</td>
					<td><c:out value="${user.realname }" escapeXml="true"/></td>
					<td><c:out value="${user.phone }" escapeXml="true"/></td>
					<td><c:out value="${user.userv2_yewuyuan==null?'':user.userv2_yewuyuan.realName }" escapeXml="true"/></td>
					<td><c:out value="${user.showMerchant_balance }" escapeXml="true"/></td>
					<td><c:out value="${user.merchant_redenvelope_balance_fen/100 }" escapeXml="true"/></td>
					<td><a href="${basePath  }v2/huiyuan/edit.do?return_mod=loginip_list&id={id}" target="dialog"><c:out value="${user.lastLoginIp }" escapeXml="true"/></a></td>
					<td><c:out value="${user.showState }" escapeXml="true"/></td>
					<td><c:out value="${user.showTime }" escapeXml="true"/></td>
				</tr>
			</c:forEach>
		</tbody>
	</table>
	<%@ include file="/v2/inc/list/spliteFooter.jsp"%>
</div>