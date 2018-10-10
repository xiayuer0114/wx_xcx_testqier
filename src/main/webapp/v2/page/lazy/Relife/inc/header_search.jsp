<%@page import="com.lymava.base.vo.State"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%><%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<form id="pagerForm" method="post" action="${basePath }${baseRequestPath }list.do">
		<input type="hidden" name="page" value="${pageSplit.page }" />
		<input type="hidden" name="pageSize" value="${pageSplit.pageSize }" />
		<%--<input type="hidden" name="openid" value="${object.openid }" />--%>
</form>
<div class="pageHeader">
	<form name="${currentTimeMillis }searchform" id="${currentTimeMillis }searchform"  onsubmit="return navTabSearch(this);" action="${basePath }${baseRequestPath }list.do" method="post">
	<div class="searchBar">
		<table class="searchContent">
			<%--<tr>
				<td>
					地点名称
				</td>
				<td>
					<input name="didianming" value="${object.didianming }"  type="text"   />
				</td>
				<td>
					提示语
				</td>
				<td>
					<input name="tishi" value="${object.tishi }"  type="text"   />
				</td>
			</tr>--%>
			<tr>  
				<td>
					<div class="buttonActive" style="cursor: pointer;"><div class="buttonContent"><button type="submit">检索</button></div></div>
				</td>
			</tr>
		</table>
	</div>
	</form> 
</div>