<%--
  Created by IntelliJ IDEA.
  User: Administrator
  Date: 2018\4\25 0025
  Time: 19:07
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<c:forEach var="voucherEntitie" items="${voucherEntities }">
    <div class="coupon layui-col-xs12" >
        <div class="coupon1 layui-col-xs8">
            <div class="coupon_1 layui-col-xs12">
                <img src="images/quan.png"/>
            </div>
            <div class="coupon_2">
                <div class="coupon_left">
                    <img src="${basePath }${voucherEntitie.logo}"/>
                </div>
                <div class="coupon_right">
                    <div class="coup1">
                        <c:out value="${voucherEntitie.userName}" escapeXml="true"/>
                    </div>
                    <div class="coup2 layui-col-xs12">
                        <div class=""><img src="images/shangjia/xing.png"/></div>
                        <div class=""><img src="images/shangjia/xing.png"/></div>
                        <div class=""><img src="images/shangjia/xing.png"/></div>
                        <div class=""><img src="images/shangjia/xing.png"/></div>
                        <div class=""><img src="images/shangjia/xing.png"/></div>
                    </div>
                    <div class="coup3 layui-col-xs12">
                        <div class=""><c:out value="${voucherEntitie.voucherName}" escapeXml="true"/></div>
                        <div class="coup3d"></div>
                    </div>
                </div>
            </div>
        </div>
        <div class="coupon2 layui-col-xs4" >
            <div class="coupon2_1 layui-col-xs12">
                <img src="images/quan1.png"/>
            </div>
            <div class="coupon2_2" onclick='maShang("${voucherEntitie.id}");'>
                <div class="coupo1">
                    ￥<c:out value="${voucherEntitie.voucherValue}" escapeXml="true"/>
                </div>
                <div class="coupo2">
                    <c:out value="${voucherEntitie.showStopTime=='2999-12-12'?'':'限领'}" escapeXml="true"/>
                    <c:out value="${voucherEntitie.low_consumption_amount=='0'?'无门槛':'满减'}" escapeXml="true"/>
                </div>
                <div style="height: 0.2em;"></div>
                <div class="coupo3">
                    <%--<c:out value="${voucherEntitie.showUseStopTime==null?'yes':'no'}" escapeXml="true"/>--%>
                    <c:out value="${voucherEntitie.showUseStopTime==''?'长期有效':voucherEntitie.showUseStopTime}" escapeXml="true"/>
                </div>
            </div>
        </div>
    </div>
</c:forEach>