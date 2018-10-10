<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%><%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<dl>
	<dt>系统编号：</dt>
	<dd>
		<c:out value="${object.id }" escapeXml="true"/>
		<input type="hidden" name="object.id"  value="<c:out value="${object.id }" escapeXml="true"/>">
	</dd>
</dl>
<div class="divider"></div>
