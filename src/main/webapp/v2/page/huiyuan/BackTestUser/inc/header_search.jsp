<%@page import="com.lymava.nosql.util.QuerySort"%>
<%@page import="com.lymava.base.model.User"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	String sort_filed = request.getParameter("sort_filed");
	String sort_type = request.getParameter("sort_type");
	
	request.setAttribute("sort_filed", sort_filed);
	request.setAttribute("sort_type", sort_type);
%>
<form id="pagerForm" method="post" action="${basePath }v2/huiyuan/list.do">
		<input type="hidden" name="page" value="${pageSplit.page }" />
		<input type="hidden" name="pageSize" value="${pageSplit.pageSize }" />
		<input type="hidden" name="userName" value="${userName }" />
		<input type="hidden" name="phone" value="${phone }" />
		<input type="hidden" name="topUser.id" value="${topUser.id }" />
		<input type="hidden" name="userGroup.id" value="${userGroup.id }" />
		<input type="hidden" name="share_balance" value="${share_balance }" />
		<input type="hidden" name="object.state" value="${object.state }" />
		<input type="hidden" name="sort_filed" value="${sort_filed }" />
		<input type="hidden" name="sort_type" value="${sort_type }" />
</form>
<div class="pageHeader">
	<form name="${currentTimeMillis}searchform" onsubmit="return navTabSearch(this);" action="${basePath }v2/huiyuan/list.do" method="post">
	<div class="searchBar">
		<table class="searchContent">
			<tr>
				<td>
					登录名 ：
				</td>
				<td>
					 <input type="text" name="userName" value="<c:out value="${userName }" escapeXml="true"/>"  size="15"  />
				</td>
				
				<td>
					openid
				</td>
				<td>
					 <input type="text" name="third_user_id" value="<c:out value="${object.third_user_id }" escapeXml="true"/>"  size="15"  />
				</td>
				
				<td>
					用户组
				</td>
				<td class="lookup_td">
					<input type="hidden" name="userGroup.id"  value="<c:out value="${userGroup.id }" escapeXml="true"/>"    class="required">
					<input type="text" name="userGroup.name"  value="<c:out value="${userGroup.name }" escapeXml="true"/>"    class="required">
					<a lookupgroup="userGroup" href="${basePath }v2/usergroup/list.do?return_mod=lookup" class="btnLook"   >查找</a>
				</td>
				
			</tr>
			<tr >
					
					<td  >
						状态
					</td>
					<td  >
						<select name="object.state" class="combox" svalue="${object.state }">
								<option    value="-1" >不限</option>
			                    <option    value="<%=User.STATE_OK %>" >正常</option>
			                    <option    value="<%=User.STATE_NOTOK %>" >异常</option>
			                    <option    value="<%=User.STATE_NOTJIHUO %>" >未激活</option>
						</select>
					</td>
					
					<td>
						<div class="buttonActive"><div class="buttonContent"><button type="submit">检索</button></div></div>
					</td>
			</tr>
		</table>
	</div>
	</form> 
</div>