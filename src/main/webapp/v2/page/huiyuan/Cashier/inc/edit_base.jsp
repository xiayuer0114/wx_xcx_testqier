<%@page import="java.util.UUID"%>
<%@page import="com.lymava.commons.util.Md5Util"%>
<%@page import="com.lymava.base.model.User"%>
<%@page import="com.lymava.base.model.Pub"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%><%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
		<fieldset  >
			<dl>
				<dt>登录名：</dt>
				<dd> 
					<input type="text"  name="user.username"  value="<c:out value="${user.username }" escapeXml="true"/>"   class="required" <c:if test="${!empty user }">readonly="readonly"</c:if>  > 
					<input type="hidden" name="user.id" value="${user.id }"   >
					
					<input type="hidden" name="user.share_balance" value="<%=User.share_balance_no %>"   >
					<input type="hidden" name="user.payPwdState" value="<%=User.STATE_NOTOK %>"   >
				</dd>
			</dl>  
			<c:if test="${empty user.id}">
			<div class="divider"></div> 
				<dl>
					<dt>登录密码：</dt>
					<dd>
						<input type="password" name="password" value=""  autocomplete="off"> 
					</dd>
				</dl> 
				<dl>
					<dt>密码确认：</dt>
					<dd>
						<input type="password" name="passwdRe" value=""  autocomplete="off"> 
					</dd>
				</dl> 
			</c:if>   
			<div class="divider"></div> 
			<dl >
				<dt>上级用户：</dt>
				<dd class="lookup_dd">
					<input type="text"  name="topuser.nickname"  value="<c:out value="${user.topUser.nickname }" escapeXml="true"/>"   > 
					<input type="hidden" name="topuser.userId" value="${user.topUserId }"    >
					<a  class="btnLook" href="${basePath }v2/huiyuan/list.do?return_mod=lookup" lookupGroup="topuser"  rel="topuser_lookup">查找</a>
				</dd>
			</dl>
			<dl class="lookup_dd">
						<dt>用户组：</dt>
						<dd>
							<input type="hidden" name="userGroup.id"  value="<c:out value="${user.userGroupId }" escapeXml="true"/>"    class="required">
							<input type="text" name="userGroup.name"  value="<c:out value="${user.userGroup.name }" escapeXml="true"/>"    class="required">
							<a lookupgroup="userGroup" href="${basePath }v2/usergroup/list.do?return_mod=lookup" class="btnLook"  >查找</a>
						</dd>
			</dl> 
			<div class="divider"></div> 
			<dl>
				<dt>状态：</dt>
				<dd>
						<select name="user.state" style="width: 155px;" class="required combox" svalue="${user.state }">
								<option  value="<%=User.STATE_OK %>" >正常</option>
								<option value="<%=User.STATE_NOTOK %>"  >暂停使用</option>
								<option  value="<%=User.STATE_NOTJIHUO %>" >未激活</option>
						</select>
				</dd>
			</dl> 
		</fieldset>