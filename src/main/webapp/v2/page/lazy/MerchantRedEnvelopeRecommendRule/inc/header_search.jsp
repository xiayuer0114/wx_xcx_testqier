<%@page import="com.lymava.qier.action.CashierAction"%>
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
					消费商家
				</td>
				<td class="lookup_td">
					<input type="text" bringBack="user_merchant_xiaofei.showName"     value="<c:out value="${object.user_merchant_xiaofei.showName }" escapeXml="true"/>"   > 
					<input type="hidden" bringBack="user_merchant_xiaofei.userId" name="object.user_merchant_xiaofei_id" value="${object.user_merchant_xiaofei_id }"    >
					<a  class="btnLook" href="${basePath }v2/huiyuan/list.do?return_mod=lookup&userGroup_id=<%=CashierAction.getMerchantUserGroutId() %>" lookupGroup="user_merchant_xiaofei"  rel="user_merchant_lookup">查找</a>
				</td>
				
				<td>
					红包商家
				</td>
				<td class="lookup_td">
					<input type="text" bringBack="user_merchant_hongbao.showName"     value="<c:out value="${object.user_merchant_hongbao.showName }" escapeXml="true"/>"   > 
					<input type="hidden" bringBack="user_merchant_hongbao.userId" name="object.user_merchant_hongbao_id" value="${object.user_merchant_hongbao_id }"    >
					<a  class="btnLook" href="${basePath }v2/huiyuan/list.do?return_mod=lookup&userGroup_id=<%=CashierAction.getMerchantUserGroutId() %>" lookupGroup="user_merchant_hongbao"  rel="user_merchant_lookup">查找</a>
				</td>
				
				<td>
					开始时间
				</td>
				<td>

					<input name="object.start_time_shengxiao_str" value="${object.start_time_shengxiao_str }"  type="text" class="date" dateFmt="yyyy-MM-dd HH:mm:ss"  />
				</td>
				<td>
					结束时间
				</td>
				<td>
						<input name="object.end_time_shengxiao_str" value="${object.end_time_shengxiao_str }"  type="text" class="date" dateFmt="yyyy-MM-dd HH:mm:ss"   />
				</td>
				
				
				<td>
					状态
				</td>
				<td>
					<select class="combox" svalue="${object.state }" name="object.state">
						<option value="-1">不限</option>
						<option value="<%=State.STATE_OK %>">生效</option>
						<option value="<%=State.STATE_CLOSED %>">失效</option>
						
					</select> 
				</td>
				<%-- <td>
					排序方式
				</td>
				<td>
					<select class="combox" svalue="${sort_filed }" name="sort_filed">
						<option value="id">系统时间</option>		
						<option value="index_id">排序时间</option>
					</select> 
				</td> --%>
				<td>
					<div class="buttonActive" style="cursor: pointer;"><div class="buttonContent"><button type="submit">检索</button></div></div>
				</td>
			</tr>
		</table>
	</div>
	</form> 
</div>