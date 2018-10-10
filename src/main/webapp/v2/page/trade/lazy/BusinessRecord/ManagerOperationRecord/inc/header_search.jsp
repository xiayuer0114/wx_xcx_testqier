<%@page import="com.lymava.qier.action.CashierAction"%>
<%@page import="com.lymava.base.vo.State"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%><%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<form id="pagerForm" method="post" action="${basePath }${baseRequestPath }list.do">
	<input type="hidden" name="page" value="${pageSplit.page }" />
	<input type="hidden" name="pageSize" value="${pageSplit.pageSize }" />
	<input type="hidden" name="requestFlow" value="${requestFlow }" />
	<input type="hidden" name="showBusinessIntId" value="${showBusinessIntId }" />
	<c:forEach var="businessIntId" items="${businessIntId_array }">
		<input type="hidden" name="businessIntId" value="${businessIntId }" />
	</c:forEach>
	<input type="hidden" name="state" value="${object.state }" />
	<input type="hidden" name="startTime" value="${startTime }" />
	<input type="hidden" name="endTime" value="${endTime }" />
	<input type="hidden" name="userId_huiyuan" value="${object.userId_huiyuan }"    >
</form>
<div class="pageHeader">
	<form name="${currentTimeMillis }searchform" id="${currentTimeMillis }searchform"  onsubmit="return navTabSearch(this);" action="${basePath }${baseRequestPath }list.do" method="post">
		<input type="hidden" name="showBusinessIntId" value="${showBusinessIntId }" />
		<c:forEach var="businessIntId" items="${businessIntId_array }">
			<input type="hidden" name="businessIntId" value="${businessIntId }" />
		</c:forEach>
	<div class="searchBar">
		<table class="searchContent">
			<tr>
				<td  >
					用户
				</td>
				<td class="lookup_td">
					<input type="text"  bringBack="managerOperationRecord.userShowName" value="<c:out value="${object.user_huiyuan.showName }" escapeXml="true"/>"   readonly="readonly" >
					<input type="hidden" name="userId_huiyuan" bringBack="managerOperationRecord.userId" value="${object.userId_huiyuan }"    >
					<a    class="btnLook" href="${basePath }v2/huiyuan/list.do?return_mod=lookup" lookupGroup="managerOperationRecord"  rel="managerOperationRecordLookup">查找</a>
				</td>
			</tr>
			<tr>
				<td>
					<div class="buttonActive" style="cursor: pointer;"><div class="buttonContent"><button type="submit">检索</button></div></div>
				</td>
			</tr>
		</table>
	</div>
	</form> 
</div>