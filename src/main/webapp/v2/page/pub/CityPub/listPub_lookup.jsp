<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%><%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<form id="pagerForm" method="post" action="${basePath }v2/pub/listPub.do">
		<input type="hidden" name="page" value="${pageSplit.page }" />
		<input type="hidden" name="pageSize" value="${pageSplit.pageSize }" />
		<input type="hidden" name="pubConlumnId" value="${pubConlumnId }" />
		<input type="hidden" name="rootPubConlumnId" value="${rootPubConlumnId }" />
		<input type="hidden" name="return_mod" value="lookup" />
</form>
<%   request.setAttribute("targetType", "dialog"); %>
<div class="pageHeader">
	<form  id="${currentTimeMillis }searchform" name="${currentTimeMillis }searchform"  onsubmit="return dwzSearch(this, 'dialog');"  action="${basePath }v2/pub/listPub.do" method="post">
	<div class="searchBar">
		<table class="searchContent">
			<tr>
				<td>
					名称 ：
				</td>
				<td>
					 <input type="text" name="name" value="<c:out value="${name }" escapeXml="true"/>"  size="15"  />
					 <input type="hidden" name="pubConlumnId" value="${pubConlumnId }" />
					<input type="hidden" name="rootPubConlumnId" value="${rootPubConlumnId }" />
					<input type="hidden" name="return_mod" value="lookup" />
 				</td>
			</tr>
			<tr>
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
		&nbsp;
	</div>
	<table class="table" width="100%" layoutH="138">
		<thead>
			<tr>
														<th>名称</th>
									    				<th>类别</th>
 									    				<th>简介</th>
									    				<th>状态</th>
 									    				<th width="40">操作</th>
 			</tr>
		</thead>
		<tbody>
			<c:forEach var="pub" varStatus="i" items="${pub_ite }">
				<tr target="id" rel="${pub.id }">
					<td><c:out value="${pub.cityName }" escapeXml="true"/></td>
					<td><c:out value="${pub.pubConlumn.name }" escapeXml="true"/></td>
					<td><c:out value="${pub.intro }" escapeXml="true"/></td>
					<td><c:out value="${pub.showState }" escapeXml="true"/></td>
 					<td>
						<a class="btnSelect" href="javascript:jQuery.bringBack({pubId:'${pub.id }', pubName:'${pub.cityName }'})" title="带回">带回</a>
					</td>
 				</tr>
			</c:forEach>
		</tbody>
	</table>
	<%@ include file="/v2/inc/list/spliteFooter.jsp"%>
</div>