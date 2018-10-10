<%@page import="java.util.Date"%>
<%@page import="com.lymava.commons.util.DateUtil"%>
<%@page import="com.mongodb.BasicDBObject"%>
<%@page import="com.lymava.base.vo.State"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%><%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %> 
<script type="text/javascript">
					jQuery(function(){
						resetDialog();
					}); 
</script>
   <div class="pageContent" id="${currentTimeMillis }"  >
	<form method="post" action="${basePath }v2/huiyuan/resetIpList.do"class="pageForm required-validate" onsubmit="return validateCallback(this);">
		<div class="pageFormContent" layoutH="56">
		<fieldset >
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
			<c:forEach var="loginIp_log" items="${user.loginIp_list }">
				<c:set  var="loginIp_dbObject" value="${loginIp_log }" scope="request"/>
				<%
				 	Object object = request.getAttribute("loginIp_dbObject");
				
					BasicDBObject basicDBObject = null;
					if(object instanceof String){
						basicDBObject = new BasicDBObject();
						basicDBObject.put("loginIp", object+"");
					}else if(object instanceof BasicDBObject){
						basicDBObject = (BasicDBObject)object;
					}
				
					Long login_time = (Long) basicDBObject.get("login_time");
					String show_time = null;
					if(login_time != null && login_time >0){
						show_time = DateUtil.getSdfFull().format(new Date(login_time));
					}
					
					String loginIp = (String) basicDBObject.get("loginIp");
					request.setAttribute("show_time", show_time);
					request.setAttribute("loginIp", loginIp);
				%>
				<div class="divider"></div>
				<dl class="iplist">
					<dt>${show_time }</dt>
					<dd>
						${loginIp }
					</dd>
				</dl>  
			</c:forEach>
			</fieldset>
		</div>
		<div class="formBar">
			<ul>
				<li><div class="buttonActive"><div class="buttonContent"><button type="submit">保存</button></div></div></li>
				<li>
					<div class="button"><div class="buttonContent"><button type="button" class="close">取消</button></div></div>
				</li>
			</ul>
		</div>
	</form>
</div>
    