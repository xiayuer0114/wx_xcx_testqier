<%--
  Created by IntelliJ IDEA.
  User: Administrator
  Date: 2018\8\16 0016
  Time: 13:56
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>

<%

    // 测试分支问题

    String userId = request.getParameter("userId");
    String token = request.getParameter("token");
    String randCode = request.getParameter("randCode");


    request.setAttribute("userId", userId);
    request.setAttribute("token", token);
    request.setAttribute("randCode", randCode);

%>



<head>
    <title>活动测试页面</title>
</head>
<body>

    <h1>userId = ${userId}</h1>
    <h1>token = ${token}</h1>
    <h1>randCode = ${randCode}</h1>

</body>
</html>
