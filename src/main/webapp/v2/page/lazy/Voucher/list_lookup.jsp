<%@page import="com.lymava.base.model.Pub"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%><%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %> 
<form id="pagerForm" method="post" action="${basePath }v2/voucherManage/list.do">
		<input type="hidden" name="page" value="${pageSplit.page }" />
		<input type="hidden" name="return_mod" value="lookup" />
</form>
<%   request.setAttribute("targetType", "dialog"); %>
<div class="pageHeader">
	<form  id="${currentTimeMillis }searchform" name="${currentTimeMillis }searchform"  onsubmit="return dwzSearch(this, 'dialog');"    target="dialog"  action="${basePath }v2/huiyuan/list.do" method="post">
	<div class="searchBar">
		<table class="searchContent">
			<tr>
				<td>
					客户手机:
				</td>
				<td>
					<input type="text" name="phone" value="<c:out value="${phone }" escapeXml="true"/>"  size="15"  />
					<input type="hidden" name="return_mod" value="lookup" />
				</td>
			</tr>
			<tr>
				<td>
					登录名：
				</td>
				<td>
					<input type="text" name="userName" value="<c:out value="${userName }" escapeXml="true"/>"  size="15"  />
				</td>
				<td>
					<div class="buttonActive"><div class="buttonContent"><button type="submit">检索</button></div></div>
				</td>
			</tr>
		</table>
	</div>
	</form> 
</div>
<div class="pageContent">
						<div class="panelBar">
							<ul class="toolBar">
								<li class="line">line</li>
							</ul>
						</div>
						<table class="table" width="100%" layoutH="138">
							<thead>
								<tr>
									<th>代金券名</th>
									<th>商家名</th>
									<th>描述</th>
									<th>价值</th>
									<th>使用条件</th>
									<th>有效时间</th>
									<th>状态</th>
									<th width="40">操作</th>
								</tr>
							</thead>
							<tbody>
								<c:forEach var="voucher" varStatus="i" items="${object_ite }">
									<tr target="id" rel="${voucher.id }">
										<td><c:out value="${voucher.voucherName }" escapeXml="true"/></td>
										<td><c:out value="${voucher.user_merchant.nickname }" escapeXml="true"/></td>
										<td><c:out value="${voucher.voucherMiaoSu }" escapeXml="true"/></td>
										<td><c:out value="${voucher.voucherValue }" escapeXml="true"/></td>
										<td><c:out value="${voucher.useWhere }" escapeXml="true"/></td>
										<td><c:out value="${voucher.showUseStopTime }" escapeXml="true"/></td>
										<td><c:out value="${voucher.showInState }" escapeXml="true"/></td>
										<td>
											<a class="btnSelect" href="javascript:jQuery.bringBack({id:'${voucher.id }', voucherName:'${voucher.voucherName }', showMerchantName:'${voucher.user_merchant.nickname }'})" title="带回">带回</a>
										</td>
									</tr>
								</c:forEach>
							</tbody>
						</table>
	<%@ include file="/v2/inc/list/spliteFooter.jsp"%>
</div>