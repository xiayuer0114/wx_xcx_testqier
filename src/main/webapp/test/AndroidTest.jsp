<%--
  Created by IntelliJ IDEA.
  User: Administrator
  Date: 2018\4\12 0012
  Time: 15:55
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%

%>

<html>
<head>
    <title>Title</title>
    <script type="text/javascript" src="${basePath }plugin/js/jquery/jquery-1.12.4.min.js"></script>
    <script type="text/javascript" src="${basePath }plugin/js/md5.js"></script>
</head>
<body>

<div id="test">

</div>

<script type="text/javascript">
    
    $(function () {
//        alert("123");


        <%--$.post("${basePath}qierAndroid/queryOrderByDate.do?startDate",function (data) {--%>
            <%--console.log(data)--%>
        <%--});--%>


        <%--$.post("${basePath}applet/homeLogin.do",{"code":"123"},function (data) {--%>
            <%--console.log(data)--%>
//        });


        <%--$.post("${basePath}applet/getMerchantPubs.do",{"code":"123"},function (data) {--%>
            <%--console.log(data)--%>
        <%--});--%>


        $.post("${basePath}applet/homeLogin.do",{"code":"123"},function (data) {
            console.log(data);

            data = JSON.parse(data).message;

            $("#test").append(data);
            console.log(data)
        });



        <%--$.post("${basePath}qierAndroid/getOneOrderById.do?payFlow=adad",function (data) {--%>
            <%--console.log(data)--%>
        <%--});--%>


        <%--var pwd = hex_md5("testuser");--%>
        <%--var userpwd = hex_md5(pwd+"aaaa".toLowerCase());--%>

        <%--$.post("${basePath}qierAndroid/login.do?username=testuser&userpwd="+userpwd+"&randCode=aaaa",function (data) {--%>
            <%--console.log(data)--%>
        <%--});--%>


        <%--$.post("${basePath}/qier/orderReportContent/gongzonghaoOrderViewData.do"--%>
    });
    
</script>

</body>
</html>
