<%--
  Created by IntelliJ IDEA.
  User: Administrator
  Date: 2018\5\4 0004
  Time: 12:11
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

    <tr class="from_a">
        <td>编号</td><td>商家名</td><td>初始余额</td><td>充值金额</td>
        <td>面值金额</td><td>折扣额/折扣</td><td>支付总额</td><td>支付: 微信</td>
        <td>支付: 支付宝</td><td>红包/代金券</td><td>面值余额</td>
    </tr>


    <c:forEach var="duizhangEntities" items="${duizhangEntities }" varStatus="i" >

        <c:if test="${i.count%2==1}">
            <tr class="from_a" style="height: 35px;background-color: #00F7DE">
        </c:if>
        <c:if test="${i.count%2!=1}">
            <tr class="from_a" style="height: 35px;">
        </c:if>

            <%--<td>编号</td>--%>
            <td onclick=showData(<c:out value="${duizhangEntities.merchant72.bianhao }" escapeXml="true"/>); >
                <c:out value="${duizhangEntities.merchant72.bianhao }" escapeXml="true"/>
            </td>

            <%--<td>商家名</td>--%>
            <td onclick=showData(<c:out value="${duizhangEntities.merchant72.bianhao }" escapeXml="true"/>); >
                <c:out value="${duizhangEntities.merchant72.nickname }" escapeXml="true"/>
            </td>

            <%--<td>初始余额</td>--%>
            <td><c:out value="${duizhangEntities.start_remaining_balance/1000000 }" escapeXml="true"/></td>

            <%--<td>充值金额</td>--%>
            <td><c:out value="${duizhangEntities.topUpBalance/1000000 }" escapeXml="true"/></td>

            <%--<td>面值金额</td>--%>
            <td><c:out value="${duizhangEntities.balanceCount/1000000 }" escapeXml="true"/></td>

            <%--<td>折扣额/折扣</td>--%>
            <td><c:out value="${duizhangEntities.discount/1000000 }" escapeXml="true"/></td>

            <%--<td>支付总额</td>--%>
            <td><c:out value="${duizhangEntities.price_all/100 }" escapeXml="true"/></td>

            <%--<td>支付: 微信</td>--%>
            <td><c:out value="${duizhangEntities.price_wechatpay/100 }" escapeXml="true"/></td>

            <%--<td>支付: 支付宝</td>--%>
            <td><c:out value="${duizhangEntities.price_alipay/100 }" escapeXml="true"/></td>

            <%--<td>支付: 代金券</td>--%>
            <td><c:out value="${duizhangEntities.redpay/100 }" escapeXml="true"/></td>

            <%--<td>面值余额</td>--%>
            <td><c:out value="${duizhangEntities.end_remaining_balance/1000000 }" escapeXml="true"/></td>

        </tr>
    </c:forEach>
