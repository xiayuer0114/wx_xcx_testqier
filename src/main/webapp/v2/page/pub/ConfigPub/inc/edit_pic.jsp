<%--<%@page import="com.lymava.base.model.Pub"%>--%>
<%@page import="com.lymava.qier.model.MerchantPub"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%><%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
		<fieldset >
			<dl style="height: 230px">
				<dt style="width: 150px">图片</dt>
				<dd>
					<input class="mydisupload"   fileNumLimit="1" name="pub.pic"  type="hidden"  value="<c:out value="${pub.pic}" escapeXml="true" />" />
				</dd>
			</dl>
		</fieldset>