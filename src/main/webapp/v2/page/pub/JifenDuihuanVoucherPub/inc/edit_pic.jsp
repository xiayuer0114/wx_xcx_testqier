<%--<%@page import="com.lymava.base.model.Pub"%>--%>
<%@page import="com.lymava.qier.model.MerchantPub"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%><%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
		<fieldset >
		<dl class="nowrap">
				<dt>详细图片：</dt>
				<dd>
					<input defaultbg="zip_diy_bg"    class="mydisupload"   fileNumLimit="1" name="pub.file"  type="hidden"  value="<c:out value="${pub.file }" escapeXml="true" />" />
				</dd> 
			</dl>
			<dl class="nowrap">
				<dt>商家logo：</dt>
				<dd>
					<%--<input class="mydisupload"   fileNumLimit="4" name="pub.merchantLogo"  type="hidden"  value="<c:out value="${pub.merchantLogo }" escapeXml="true" />" />--%>
				</dd>
			</dl>
		</fieldset>