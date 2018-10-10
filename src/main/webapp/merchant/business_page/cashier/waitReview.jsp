<%--
  Created by IntelliJ IDEA.
  User: Administrator
  Date: 2018\3\21 0021
  Time: 11:01
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Title</title>
</head>
<body>

    <%
        String message = request.getParameter("message");
    %>

    <h3> <%=message%> </h3>

</body>
</html>
