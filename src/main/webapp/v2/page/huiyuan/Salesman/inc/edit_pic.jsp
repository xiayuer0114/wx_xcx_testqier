<%@page import="com.lymava.base.model.Pub"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%><%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
		<fieldset  >
			<dl class="nowrap">
				<dt>头像：</dt>
				<dd>
						<input class="mydisupload"   fileNumLimit="1" name="user.picname"  type="hidden"  value="<c:out value="${user.picname }" escapeXml="true" />" />
				</dd> 
			</dl>
			<script type="text/javascript">
				jQuery(function(){
					uploadInitMy();
				});
			</script> 
		</fieldset>