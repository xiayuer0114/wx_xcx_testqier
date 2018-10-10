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
			<tr>
				<td>
					openid
				</td>
				<td>
					<input name="openid" value="${object.openid }" type="text"   />
				</td>
				<td>
					开始时间
				</td>
				<td>
					<input name="startTime" value="${startTime }" readonly="readonly"  type="text" class="date" dateFmt="yyyy-MM-dd HH:mm:ss"  />
				</td>
				<td>
					结束时间
				</td>
				<td>
					<input name="endTime" value="${endTime }"  readonly="readonly"  type="text" class="date" dateFmt="yyyy-MM-dd HH:mm:ss"   />
				</td>
				<td>
					奖品类型
				</td>
				<td>
					<select name="type_jiangpin">
						<option value="" <c:if test="${object.type_jiangpin gt 3 or object.type_jiangpin lt 1 or empty object.type_jiangpin}">selected="selected"</c:if>>（请选择）</option>
						<option value="1" <c:if test="${object.type_jiangpin == 1}">selected="selected"</c:if>>未中奖</option>
						<option value="2" <c:if test="${object.type_jiangpin == 2}">selected="selected"</c:if>>6.66 红包</option>
						<option value="3" <c:if test="${object.type_jiangpin == 3}">selected="selected"</c:if>>1.66 红包</option>
					</select>
					<%--<input name="type_jiangpin" value="${object.type_jiangpin }"  type="text"   />--%>
				</td>
				<td>
					中奖状态
				</td>
				<td>
					<select name="state">
						<option value="" <c:if test="${object.state!=200 and object.state!=300 and object.state!=502}">selected="selected"</c:if>>（请选择）</option>
						<option value="200" <c:if test="${object.state == 200}">selected="selected"</c:if>>已发放</option>
						<option value="300" <c:if test="${object.state == 300}">selected="selected"</c:if>>未中奖</option>
						<option value="502" <c:if test="${object.state == 502}">selected="selected"</c:if>>未开宝箱</option>
					</select>
					<%--<input name="state" value="${object.state }"  type="text"   />--%>
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