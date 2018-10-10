<%--<%@page import="com.lymava.base.model.Pub"%>--%>
<%@page import="com.lymava.qier.model.MerchantPub"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%><%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
		<fieldset >

			<div class="divider"></div>
			<dl>
				<dt>经度：</dt>
				<dd>
					<input type="text" bringBack="shopmap.longitude"  name="pub.inLongitude" value="<c:out value="${pub.longitude}" escapeXml="true"/>"    style="width: 100px;">
				</dd>
			</dl>

			<dl style="width: 400px;">
				<dt>纬度：</dt>
				<dd  style="width: 320px;">
					<input type="text"  bringBack="shopmap.latitude" name="pub.inLatitude" value="<c:out value="${pub.latitude }" escapeXml="true"/>"    style="width: 100px;">
					<a id="shiqua" style="background:none;text-indent:0px;width:150px;overflow:hidden;line-height:15px;height:15px;"  class="btnLook" href="${basePath }v2/page/map/shiqu.jsp"  lookupGroup="shopmap"  rel="shopmap">坐标拾取-鼠标点击拾取坐标</a>
				</dd>
			</dl>


			<div class="divider"></div>


			<dl style="padding: 0;margin: 0;">
				<dt style="width: 30px;">标题</dt>
			</dl>
			<dl class="nowrap intro_dl" >
				<dd  >
					<textarea name="pub.title" class="textInput"><c:out value="${pub.title }" escapeXml="true" /></textarea>
				</dd>
			</dl>
			<div class="divider"></div>

			<dl>
				<dt>副标题 :</dt>
				<dd>
					<input type="text"  name="pub.subhead" value="<c:out value="${pub.subhead }" escapeXml="true"/>"  >
				</dd>
			</dl>
			<div class="divider"></div>

			<dl>
				<dt>视频连接 :</dt>
				<dd>
					<input type="text"  name="pub.video" value="<c:out value="${pub.video }" escapeXml="true"/>"  >
				</dd>
			</dl>
			<div class="divider"></div>

			<dl style="padding: 0;margin: 0;">
				<dt style="width: 30px;">简介</dt>
			</dl>
			<dl class="nowrap intro_dl" >
				<dd  >
					<textarea name="pub.intro" class="textInput"><c:out value="${pub.intro }" escapeXml="true" /></textarea>
				</dd>
			</dl>
			<div class="divider"></div> 
			<dl style="padding: 0;margin: 0;">
				<dt style="width: 30px;">详情</dt>
			</dl>
			<dl class="nowrap content_dl"  >
				<dd  >
					<textarea  upFlashUrl="${basePath }upload/uploadFileXheditor.do"  upMediaUrl="${basePath }upload/uploadFileXheditor.do"  upImgUrl="${basePath }upload/uploadFileXheditor.do" upImgExt="jpg,jpeg,gif,png"   class="editor" name="pub.content"  >${pub.content }</textarea>
				</dd>
			</dl>
		</fieldset>