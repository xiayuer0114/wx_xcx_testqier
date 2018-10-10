<%@page import="com.lymava.qier.action.CashierAction"%>
<%@page import="com.lymava.base.util.WebConfigContent"%>
<%@page import="com.lymava.base.vo.State"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%><%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<form id="pagerForm" method="post" action="${basePath }${baseRequestPath }list.do">
		<input type="hidden" name="page" value="${pageSplit.page }" />
		<input type="hidden" name="pageSize" value="${pageSplit.pageSize }" />
		<input type="hidden" name="qudao_user_id"   value="${object.qudao_user_id }"    >
		<input type="hidden" name="object.state"   value="${object.state }"    >
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
				<td  >
						渠道用户
				</td>
				<td class="lookup_td">
					<input type="text"  bringBack="subscribeUser.userShowName" value="<c:out value="${object.qudao_user.showName }" escapeXml="true"/>"   readonly="readonly" > 
					<input type="hidden" name="qudao_user_id" bringBack="subscribeUser.userId" value="${object.qudao_user_id }"    >
					<a    class="btnLook" href="${basePath }v2/huiyuan/list.do?return_mod=lookup&userGroup_id=<%=CashierAction.getMerchantUserGroutId() %>" lookupGroup="subscribeUser"  rel="subscribeUserLookup">查找</a>
				</td>
			</tr>
			<tr> 
				<td>
					昵称
				</td>
				<td>
							<input name="nickname" value="${object.nickname }"  type="text"   />
				</td> 
				<td>
					unionid
				</td>
				<td>
							<input name="unionid" value="${object.unionid }"  type="text"   />
				</td> 
					<td>
					openid
				</td>
				<td>
							<input name="openid" value="${object.openid }"  type="text"   />
				</td> 
				<td>
					关注状态
				</td>
				<td>
					<select name="object.state" class="combox" svalue="${object.state }">
										<option  value="-1" >不限</option>
			                    		<option  value="<%=State.STATE_OK %>" >已关注</option>
			                    		<option  value="<%=State.STATE_FALSE %>" >未关注</option>
			                    		<option  value="<%=State.STATE_CLOSED %>" >重复关注</option>
			                    		<option  value="<%=State.STATE_WAITE_PROCESS %>" >等待关注</option>
					</select> 
				</td>
				<td>
					<div class="buttonActive" style="cursor: pointer;"><div class="buttonContent"><button type="submit">检索</button></div></div>
				</td>
			</tr>
		</table>
	</div>
	</form> 
</div>