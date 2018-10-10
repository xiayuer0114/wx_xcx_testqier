<%@page import="com.lymava.commons.util.MyUtil"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%><%
	String basePath_ = MyUtil.getBasePath(request);
	request.setAttribute("basePath",basePath_);
%><!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title> 
<script type="text/javascript" src="${basePath }plugin/js/jquery/jquery.min.js"></script>
<script type="text/javascript"> 
	jQuery(function(){ 
		document.forms['needLoginform'].submit();
	});
</script>
</head>
<body>
<div style="display: none;">
	<form action="${basePath }merchant/login.jsp" name="needLoginform" id="needLoginform">
		<input type="hidden" name="r" value="<%=System.currentTimeMillis() %>" />
	</form>
</div>
</body>
</html>