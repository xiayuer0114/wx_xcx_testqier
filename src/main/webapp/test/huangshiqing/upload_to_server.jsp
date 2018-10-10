<%@page import="com.lymava.commons.util.MyUtil"%>
<%@page import="com.lymava.wechat.gongzhonghao.Gongzonghao"%>
<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>Insert title here</title>
</head>
<body>






<%

//System.out.print("----------------------准备发送到服务器");
String serverId=request.getParameter("serverId");
//System.out.print("----------------------serverId:"+serverId);


Gongzonghao gongzonghao=new Gongzonghao();

byte[] buf=gongzonghao.media_get(serverId);

MyUtil.savePic(buf, request.getRealPath("/"));



%>

</body>
</html>