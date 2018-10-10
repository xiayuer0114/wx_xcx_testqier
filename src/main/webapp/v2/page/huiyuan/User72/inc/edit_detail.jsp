<%@page import="com.lymava.base.model.Pub"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%><%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
		<fieldset  >
			<dl>
				<dt>昵称：</dt>
				<dd>
					<input type="text" name="user.nickname" value="<c:out value="${user.nickname }" escapeXml="true"/>"  > 
				</dd>
			</dl>
			<div class="divider"></div> 
			<dl>
				<dt>真实姓名：</dt>
				<dd>
					<input type="text" name="user.realname" value="<c:out value="${user.realname }" escapeXml="true"/>"  > 
				</dd>
			</dl>
			<dl>
				<dt>证件号码：</dt>
				<dd>
					<input type="text" name="user.idCard" value="<c:out value="${user.idCard }" escapeXml="true"/>"  > 
				</dd>
			</dl>
			<div class="divider"></div> 
			<dl>
				<dt>性别：</dt>
				<dd>
					<select name="user.sex" class="required combox" svalue="${user.sex }">
							<option    value="男">男</option>
							<option   value="女">女</option>
					</select>
				</dd>
			</dl>
			<div class="divider"></div> 
			<dl>
				<dt>出生日期：</dt>
				<dd>
					<input type="text" name="user.inBirthDate" value="<c:out value="${user.showBirthDate }" escapeXml="true"/>" class=" date"   > 
				</dd>
			</dl>
			<div class="divider"></div> 
			<dl>
				<dt>省：</dt>
				<dd style="float: left;height: 22px;">
					<select id="sheng" name="user.sheng" data="<c:out value="${user.sheng }" escapeXml="true"/>" style="width: 94px;float: left;">
					</select>
				</dd>
			</dl>
			<div class="divider"></div> 
			<dl>
				<dt>市：</dt>
				<dd style="float: left;height: 22px;">
					<select id="shi" name="user.shi" data="<c:out value="${user.shi }" escapeXml="true"/>" style="width: 94px;float: left;">
					</select>
				</dd>
			</dl>
			<div class="divider"></div> 
			<dl>
				<dt>区：</dt>
				<dd style="float: left;height: 22px;">
					<select id="qu" name="user.qu" data="<c:out value="${user.qu }" escapeXml="true"/>" style="width: 94px;float: left;">
					</select>
				</dd>
			</dl>
			<div class="divider"></div> 
			<dl>
				<dt>地址：</dt>
				<dd style="float: left;height: 22px;">
					<input type="text" name="user.address" value="<c:out value="${user.address }" escapeXml="true"/>"  style="float: left;"> 
				</dd>
			</dl>
			<script type="text/javascript" src="${basePath }plugin/js/city.js"></script>
				<script type="text/javascript">
					jQuery(function(){
						cityLiandong('sheng','shi','qu');
					});
			</script>
		</fieldset>