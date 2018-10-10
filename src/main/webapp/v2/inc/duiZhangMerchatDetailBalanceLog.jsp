<%--
  Created by IntelliJ IDEA.
  User: Administrator
  Date: 2018\5\4 0004
  Time: 15:59
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<center>
    编号: ${merchant72_find_duizhang.bianhao} ,  昵称: ${merchant72_find_duizhang.nickname} ,  姓名: ${merchant72_find_duizhang.username}
<table border="1" width="80%">
    <tr>
        <th>时间</th>
        <th>充值金额</th>
        <th>面值金额</th>
        <th>折扣额度</th>
        <th>操作人员</th>
        <th>备注</th>
    </tr>
    <c:forEach var="duizhangEntities" items="${duizhangEntities_b }">
        <tr style="height: 38px">

            <td><c:out value="${duizhangEntities.merchartId }" escapeXml="true"/></td>
            <td><c:out value="${duizhangEntities.topUpBalance/1000000 }" escapeXml="true"/></td>
            <td><c:out value="${duizhangEntities.balanceCount/1000000 }" escapeXml="true"/></td>
            <td><c:out value="${duizhangEntities.discount/1000000 }" escapeXml="true"/></td>

            <td><c:out value="${duizhangEntities.adminUser.realName }" escapeXml="true"/></td>
            <td><c:out value="${duizhangEntities.memo }" escapeXml="true"/></td>

        </tr>
    </c:forEach>
</table>
</center>



