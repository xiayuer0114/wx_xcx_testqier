<%@page import="com.lymava.trade.util.WebConfigContentTrade"%>
<%@page import="com.lymava.base.util.WebConfigContent"%>
<%@page import="com.lymava.commons.state.State"%>
<%@ page import="com.lymava.qier.action.CashierAction" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%><%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<form id="pagerForm" method="post" action="${basePath }${baseRequestPath }list.do">
		<input type="hidden" name="page" value="${pageSplit.page }" />
		<input type="hidden" name="pageSize" value="${pageSplit.pageSize }" />
		<input type="hidden" name="requestFlow" value="${object.requestFlow }" />
		<input type="hidden" name="showBusinessIntId" value="${showBusinessIntId }" />
		<c:forEach var="businessIntId" items="${businessIntId_array }">
			<input type="hidden" name="businessIntId" value="${businessIntId }" />
		</c:forEach>
		<c:if test="${empty businessIntId_array }">
			<input type="hidden" name="businessIntId" value="${object.businessIntId }" />
		</c:if>
		<input type="hidden" name="state" value="${object.state }" />
		<input type="hidden" name="object.userId_huiyuan" value="${object.userId_huiyuan }"    >
		<input type="hidden" name="startTime" value="${startTime }" />  
		<input type="hidden" name="endTime" value="${endTime }" />
</form>
<div class="pageHeader">
	<form name="${currentTimeMillis }searchform" id="${currentTimeMillis }searchform"  onsubmit="return navTabSearch(this);" action="${basePath }${baseRequestPath }list.do" method="post">

		<%-- 跳转至Business --%>
		<input type="hidden" name="businessIntId" value="${showBusinessIntId }" />
		<c:forEach var="businessIntId" items="${businessIntId_array }">
			<input type="hidden" name="businessIntId" value="${businessIntId }" />
		</c:forEach>

	<div class="searchBar">
		<table class="searchContent">
			<tr> 
				<td>
					订单编号
				</td>
				<td>
					 <input type="text" name="requestFlow" value="<c:out value="${object.requestFlow }" escapeXml="true"/>"   />
				</td> 
				<td>
					开始
				</td>
				<td>
					<input name="startTime" readonly="readonly" value="${startTime }"  type="text" class="date" dateFmt="yyyy-MM-dd HH:mm:ss"  />
				</td>
				<td>
					结束
				</td>
				<td>
					<input name="endTime" readonly="readonly" value="${endTime }"  type="text" class="date" dateFmt="yyyy-MM-dd HH:mm:ss"   />
				</td>
			</tr>
			<tr>
				<td  >
					商户
				</td>
				<td class="lookup_td">
					<input type="text"  bringBack="user_merchant.userShowName" value="<c:out value="${object.user_huiyuan.showName }" escapeXml="true"/>"   readonly="readonly" >
					<input type="hidden" name="userId_huiyuan" bringBack="user_merchant.userId" value="${object.userId_huiyuan }"    >
					<a class="btnLook" href="${basePath }v2/huiyuan/list.do?return_mod=lookup&userGroup_id=<%=CashierAction.getMerchantUserGroutId() %>" lookupGroup="user_merchant" rel="user_merchant_lookup">查找</a>
				</td>
			</tr>
			<tr>
				<%--<td  >
					用户
				</td>
				<td class="lookup_td">
					<% request.setAttribute("userGroup_default", WebConfigContent.getInstance().getDefaultUserGroup()); %>
					<input type="text"  bringBack="businessRecord.userShowName" value="<c:out value="${object.user_huiyuan.showName }" escapeXml="true"/>"   readonly="readonly" >
					<input type="hidden" name="userId_huiyuan" bringBack="businessRecord.userId" value="${object.userId_huiyuan }"    >
					<a    class="btnLook" href="${basePath }v2/huiyuan/list.do?return_mod=lookup&userGroup_id=${userGroup_default.id }" lookupGroup="businessRecord"  rel="businessRecordLookup">查找</a>
				</td>
				<td>
					状态
				</td>
				<td  >
					<select name="state" class="combox" svalue="${object.state }">
									<option    value="-1" >不限</option>
									<option    value="<%=State.STATE_FALSE %>" >失败</option>
									<option  value="<%=State.STATE_INPROCESS %>" >进行中</option>
									<option  value="<%=State.STATE_REFUND_OK %>" >已退款</option>
									<option  value="<%=State.STATE_WAITE_PAY %>" >等待付款</option>
									<option  value="<%=State.STATE_PAY_SUCCESS %>" >支付成功</option>
									<option  value="<%=State.STATE_WAITE_WAITSENDGOODS %>" >等待发货</option>
									<option  value="<%=State.STATE_CLOSED %>" >交易关闭</option>
									<option    value="<%=State.STATE_OK %>" >交易成功</option>
						</select>
				</td>--%>

				<td>
					<div class="buttonActive"><div class="buttonContent"><button type="submit">检索</button></div></div>
				</td>
			</tr>
		</table>
	</div>
	</form> 
</div>