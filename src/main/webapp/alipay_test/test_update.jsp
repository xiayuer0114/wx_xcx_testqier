<%@page import="com.lymava.base.util.ContextUtil"%>
<%@page import="com.lymava.nosql.context.SerializContext"%>
<%@page import="com.lymava.nosql.mongodb.util.MongoCommand"%>
<%@page import="com.lymava.base.model.User"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
</head>
<body>
	<%
	
	SerializContext serializContext = ContextUtil.getSerializContext();
	
    User user_update = new User();
    user_update.addCommand(MongoCommand.unset, "third_user_id", null);
    
    serializContext.commandUpdateObject(User.class, "5ac9effed6c459566fd0829a", user_update);
	
	%>
</body>
</html>