<%@page import="com.lymava.base.model.Pub"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%><%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
		<fieldset>
			<div class="divider"></div> 
    		<dl class="nowrap">
				<dt>商品简介：</dt>
				<dd style="width: 80%;">
					<textarea   rows="6" cols="40" name="pub.intro" class="textInput"><c:out value="${pub.intro }" escapeXml="true" /></textarea>
				</dd>
			</dl>
			<div class="divider"></div> 
			<dl class="nowrap">
				<dt>商品详情：</dt>
				<dd style="width: 80%;">
					<textarea  style="width: 100%;"  rows="12"     upFlashUrl="${basePath }upload/uploadFileXheditor.do"  upMediaUrl="${basePath }upload/uploadFileXheditor.do"  upImgUrl="${basePath }upload/uploadFileXheditor.do"  upImgExt="jpg,jpeg,gif,png"  class="editor" name="pub.content"  ><c:out value="${pub.content }" escapeXml="true" /></textarea>
				</dd>
			</dl>
		</fieldset>