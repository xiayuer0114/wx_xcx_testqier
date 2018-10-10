<%@page import="com.lymava.base.model.Pub"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%><%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %> 
<form id="pagerForm" method="post" action="${basePath }v2/huiyuan/list.do">
		<input type="hidden" name="page" value="${pageSplit.page }" />
		<input type="hidden" name="phone" value="<c:out value="${phone }" escapeXml="true"/>"   />
		<input type="hidden" name="userGroup_id" value="${object.userGroupId }" />
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
					<input type="hidden" name="userGroup_id" value="${object.userGroupId }" />
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
					商户名称
				</td>
				<td>
					<input type="text" name="nickname" value="<c:out value="${nickname }" escapeXml="true"/>"  />
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
																			<th>用户名</th>
														    				<th>名称</th>
														    				<th>联系电话</th>
														    				<th>邮箱</th>
														    				<th>状态</th>
														    				<th width="40"><a class="btnSelect_bean"  href="javascript:jQuery.bringBack({userId:'', userShowName:'', showName:''})" title="清空">清空</a></th>
								</tr>
							</thead>
							<tbody>
								<c:forEach var="user" varStatus="i" items="${user_list }">
									<tr target="id" rel="${user.id }">
										<td><c:out value="${user.username }" escapeXml="true"/></td>
										<td><c:out value="${user.showName }" escapeXml="true"/></td>
										<td><c:out value="${user.phone }" escapeXml="true"/></td>
										<td><c:out value="${user.email }" escapeXml="true"/></td>
										<td><c:out value="${user.showState }" escapeXml="true"/></td>
										<td>
											<a  class="btnSelect_bean" href="javascript:jQuery.bringBack({userId:'${user.id }', userShowName:'${user.showName }', showName:'${user.showName }'})" title="带回">带回</a>
										</td>
									</tr>
								</c:forEach>
							</tbody>
						</table>
	<%@ include file="/v2/inc/list/spliteFooter.jsp"%>
</div>