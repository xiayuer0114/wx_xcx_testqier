<%--<%@page import="com.lymava.base.model.Pub"%>--%>
<%@page import="com.lymava.qier.model.MerchantPub"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%><%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
		<fieldset >
			<dl style="height: 230px">
				<dt style="width: 150px">生活圈展示</dt>
				<dd>
					<input class="mydisupload"   fileNumLimit="1" name="pub.pic"  type="hidden"  value="<c:out value="${pub.pic}" escapeXml="true" />" />
				</dd>
			</dl>
			<dl style="height: 230px">
				<dt style="width: 150px">头像背景</dt>
				<dd>
					<input defaultbg="zip_diy_bg"    class="mydisupload"   fileNumLimit="1" name="pub.file"  type="hidden"  value="<c:out value="${pub.file }" escapeXml="true" />" />
				</dd>
			</dl>


			<div class="divider"></div>
			<dl class="nowrap" >
				<dt style="width: 150px" >特推下面的三张图片：</dt>
				<br>
				<dd style="width: 95%">
					<input class="mydisupload"   fileNumLimit="4" name="pub.inPics"  type="hidden"  value="<c:out value="${pub.pics }" escapeXml="true" />" />
				</dd>
			</dl>
		</fieldset>