<%@page import="com.lymava.base.model.Pub"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%><%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
		<fieldset>
			<div class="divider"></div> 
			<dl class="nowrap">
				<dt>展示图片：</dt>
				<dd>
						<input class="mydisupload"   fileNumLimit="1" name="pub.pic"  type="hidden"  value="<c:out value="${pub.pic }" escapeXml="true" />" />
				</dd> 
			</dl>
			<div class="divider"></div> 
				<dl class="nowrap">
				<dt>效果图片：</dt>
				<dd>
						<input class="mydisupload"   fileNumLimit="4" name="pub.inPics"  type="hidden"  value="<c:out value="${pub.pics }" escapeXml="true" />" />
				</dd> 
			</dl>  
		</fieldset>