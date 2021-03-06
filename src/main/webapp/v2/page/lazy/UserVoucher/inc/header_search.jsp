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
					开始时间
				</td>
				<td>
							<input name="startTime" value="${startTime }"  type="text" class="date" dateFmt="yyyy-MM-dd HH:mm:ss"  /> 
				</td>
				<td>
					结束时间
				</td>
				<td>
							<input name="endTime" value="${endTime }"  type="text" class="date" dateFmt="yyyy-MM-dd HH:mm:ss"   /> 
				</td>
			</tr>
			<tr> 
				<td>
					商家
				</td>
				<td class="lookup_td">
					<input type="text" bringBack="user_merchant.showName"     value="<c:out value="${object.user_merchant.showName }" escapeXml="true"/>"   > 
					<input type="hidden" bringBack="user_merchant.userId" name="object.userId_huiyuan" value="${object.userId_merchant }"    >
					<a  class="btnLook" href="${basePath }v2/huiyuan/list.do?return_mod=lookup" lookupGroup="user_merchant"  rel="user_merchant_lookup">查找</a>
				</td>
				<td>
					<div class="buttonActive" style="cursor: pointer;"><div class="buttonContent"><button type="submit">检索</button></div></div>
				</td>
			</tr>
		</table>
	</div>
	</form> 
</div>