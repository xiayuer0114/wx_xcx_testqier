<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%--
  Created by IntelliJ IDEA.
  User: Administrator
  Date: 2018\6\14 0014
  Time: 9:22
  To change this template use File | Settings | File Templates.
--%>

<%-- 孙M  6.14 一个商家的预付款变动具体信息--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<html>
<head>
    <title>一个商家的预付款变动具体信息</title>
</head>
<body>

    <div>
        <center>
            ${startTimeStr} ---至--- ${endTimeStr}
                <br><br>
                编号:&nbsp;${bianHao}, &nbsp;&nbsp;昵称:&nbsp;${nickName}, &nbsp;&nbsp;登录名:&nbsp;${userName}
                <br><br>



            <table id="showOneMerchantInfoBody" border="1" width="90%">
                <tr>
                    <th>时间</th>
                    <th>实际打款</th>
                    <th style="width: 30px"></th>
                    <th>操作人员</th>
                    <th>充值金额</th>
                    <th>折扣额度</th>
                    <th>备注</th>
                </tr>
                <%-- ↓ duizhangEntityList的值 来源于 Merchant72Action 的 getMerchantBalanceChangById 方法 --%>
                <c:forEach var="duizhangEntityList" items="${duizhangEntityList }" varStatus="i" >
                    <tr style="height: 35px">
                        <td><c:out value="${duizhangEntityList.showTime}" escapeXml="true"/></td>
                        <td><c:out value="${duizhangEntityList.balance}" escapeXml="true"/></td>
                        <td></td>
                        <td><c:out value="${duizhangEntityList.adminName}" escapeXml="true"/></td>
                        <td><c:out value="${duizhangEntityList.count}" escapeXml="true"/></td>
                        <td><c:out value="${duizhangEntityList.discount}" escapeXml="true"/></td>
                        <td><c:out value="${duizhangEntityList.memo}" escapeXml="true"/></td>
                    </tr>
                </c:forEach>

            </table>
        </center>
    </div>

</body>
</html>
