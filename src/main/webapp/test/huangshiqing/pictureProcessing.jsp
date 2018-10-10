<%@ page language="java" 
    pageEncoding="utf-8"%>
    
    <%@page import="com.lymava.qier.service.PictureProcessingService" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>图片处理</title>
</head>
<body>
	<%
	PictureProcessingService pps=new PictureProcessingService();
	pps.pictureProcess();
	
	%>
</body>
</html>