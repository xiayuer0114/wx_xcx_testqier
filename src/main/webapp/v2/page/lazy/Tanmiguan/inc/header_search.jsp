<%@page import="com.lymava.base.vo.State"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%><%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<form id="pagerForm" method="post" action="${basePath }${baseRequestPath }list.do">
		<input type="hidden" name="page" value="${pageSplit.page }" />
		<input type="hidden" name="pageSize" value="${pageSplit.pageSize }" />
</form>
<div class="pageHeader">
	<form name="${currentTimeMillis }searchform" id="${currentTimeMillis }searchform"  onsubmit="return navTabSearch(this);" action="${basePath }${baseRequestPath }list.do" method="post">
	<div class="searchBar">
		<table class="searchContent">
			<tr> 
				<td>
					openId
				</td>
				<td>
					<input name="openId" value="${object.openId}"  type="text"/>
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