<%@page import="com.lymava.commons.util.Md5Util"%>
<%@page import="com.lymava.commons.util.MyUtil"%>
<%@page import="com.lymava.base.model.User"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%><%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
         <script type="text/javascript">
					jQuery(function(){
						resetDialog();
					});
		</script> 
<%

	User user_merchant = (User)request.getAttribute("user");
	

	StringBuilder url_auto_login = new StringBuilder("merchant/");
	
	String randCode = System.currentTimeMillis() + "";
	String user_sign = Md5Util.MD5Normal(user_merchant.getKey()+randCode.toLowerCase());
	
	url_auto_login.append("?user_id="+user_merchant.getId());
	url_auto_login.append("&randCode="+randCode);
	url_auto_login.append("&user_sign="+user_sign);
	request.setAttribute("url_auto_login", url_auto_login);
%>
<div class="pageContent" id="${currentTimeMillis }" >
	<form method="post" action="${basePath }${url_auto_login }"  target="_blank">
		<div class="pageFormContent"  >
		<fieldset  >
			<dl>
				<dt>登录名称：</dt>
				<dd> 
					<input type="text" name="user.username" value="<c:out value="${user.username }" escapeXml="true" />" readonly="readonly" > 
					<input type="hidden" name="id" value="${user.id }"   >
				</dd>
			</dl>  
			<div class="divider"></div>
			<dl>
				<dt>昵称：</dt>
				<dd> 
					<input type="text" name="user.nickname" value="<c:out value="${user.nickname }" escapeXml="true" />"  readonly="readonly" > 
				</dd>
			</dl>  
			</fieldset>
 		</div>
		<div class="formBar">
			<ul>
				<li><div class="buttonActive"><div class="buttonContent"><button type="submit">确认登录</button></div></div></li>
				<li>
					<div class="button"><div class="buttonContent"><button type="button" class="close">取消</button></div></div>
				</li>
			</ul>
		</div>
	</form>
</div>
    