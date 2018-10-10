<%--<%@page import="com.lymava.base.model.Pub"%>--%>
<%@page import="com.lymava.qier.model.MerchantPub"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%><%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
		<fieldset >

			<dl>
				<dt>视频链接 :</dt>
				<dd>
					<%--<input type="text"  name="pub.subhead" value="<c:out value="${pub.subhead }" escapeXml="true"/>"  >--%>
				</dd>
			</dl>
			<div class="divider"></div>
			<dl style="padding: 0;margin: 0;">
				<dt style="width: 30px;">标题</dt>
			</dl>
			<dl class="nowrap intro_dl" >
				<dd  >
					<%--<textarea name="pub.title" class="textInput"><c:out value="${pub.title }" escapeXml="true" /></textarea>--%>
				</dd>
			</dl>
			<div class="divider"></div>
			<dl>
				<dt>副标题 :</dt>
				<dd>
					<%--<input type="text"  name="pub.subhead" value="<c:out value="${pub.subhead }" escapeXml="true"/>"  >--%>
				</dd>
			</dl>
			<div class="divider"></div>
			<dl style="padding: 0;margin: 0;">
				<dt style="width: 30px;">简介</dt>
			</dl>
			<dl class="nowrap intro_dl" >
				<dd  >
					<%--<textarea name="pub.intro" class="textInput"><c:out value="${pub.intro }" escapeXml="true" /></textarea>--%>
				</dd>
			</dl>
			<div class="divider"></div>
			<dl style="padding: 0;margin: 0;">
				<%--<dt style="width: 30px;">详情</dt>--%>
			</dl>
			<dl class="nowrap content_dl"  >
				<dd  >
					<%--<textarea  upFlashUrl="${basePath }upload/uploadFileXheditor.do"  upMediaUrl="${basePath }upload/uploadFileXheditor.do"  upImgUrl="${basePath }upload/uploadFileXheditor.do" upImgExt="jpg,jpeg,gif,png"   class="editor" name="pub.content"  >${pub.content }</textarea>--%>
				</dd>
			</dl>
		</fieldset>