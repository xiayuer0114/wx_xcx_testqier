<%@page import="com.lymava.base.model.Pub"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%><%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
		<fieldset  >
			<dl>
				<dt>third_user_id：</dt>
				<dd>
					<input type="text" name="user.third_user_id" value="<c:out value="${user.third_user_id }" escapeXml="true"/>"  >
				</dd>
			</dl>
			<dl>
				<dt style="font-size: 0.6rem;">小程序openId：</dt>
				<dd>
					<input type="text" name="user.xiaochengxu_openid" value="<c:out value="${user.xiaochengxu_openid}" escapeXml="true"/>"  >
				</dd>
			</dl>
			<div class="divider"></div>
			<dl>
				<dt>联系电话：</dt>
				<dd>
					<input type="text" name="user.phone" value="<c:out value="${user.phone }" escapeXml="true"/>"  > 
				</dd>
			</dl>
			<dl>
				<dt>店面电话：</dt>
				<dd>
					<input type="text" name="user.merchart72Phone" value="<c:out value="${user.merchart72Phone }" escapeXml="true"/>"  >
				</dd>
			</dl>
			<div class="divider"></div> 
			<dl>
				<dt>用户微信：</dt>
				<dd>
					<input type="text" name="user.weixin" value="<c:out value="${user.weixin }" escapeXml="true"/>"  > 
				</dd>
			</dl>
			<div class="divider"></div> 
			<dl>
				<dt>QQ：</dt>
				<dd>
					<input type="text" name="user.qq" value="<c:out value="${user.qq }" escapeXml="true"/>"  > 
				</dd> 
			</dl>
			<div class="divider"></div> 
			<dl>
				<dt>邮箱：</dt>
				<dd>
					<input type="text" name="user.email" value="<c:out value="${user.email }" escapeXml="true"/>"  > 
				</dd>
			</dl>
		</fieldset>