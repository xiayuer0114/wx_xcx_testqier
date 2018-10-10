<%--
  Created by IntelliJ IDEA.
  User: Administrator
  Date: 2018\4\19 0019
  Time: 14:11
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:forEach var="voucherEntitie" items="${voucherEntitiesAll }">

    <div class="coupon layui-col-xs12" >
        <div class="coupon1 layui-col-xs12">
            <div class="coup1 layui-col-xs12">
                <div class="c_1 layui-col-xs4">
                    <c:out value="${voucherEntitie.userName}" escapeXml="true"/>
                </div>
                <div class="c_2 layui-col-xs4">
                    .
                </div>
                <div class="c_3 layui-col-xs4">
                    <div class="c3_1">
                        <img src="img/xing2.png"/>
                    </div>
                    <div class="c3_2">
                        <img src="img/xing2.png"/>
                    </div>
                    <div class="c3_2">
                        <img src="img/xing2.png"/>
                    </div>
                    <div class="c3_2">
                        <img src="img/xing2.png"/>
                    </div>
                    <div class="c3_2">
                        <img src="img/xing2.png"/>
                    </div>
                </div>
            </div>
            <div class="layui-col-xs12" style="height: 0.5rem;"></div>
        </div>

        <div class="coupon2 layui-col-xs12">
            <div class="coup2">
                <img src="${basePath }${voucherEntitie.logo}"/>
            </div>
            <div class="coup3">
                <div class="co_1">
                    <c:out value="${voucherEntitie.voucherName}" escapeXml="true"/>
                </div>
                <div class="co_2">
                    还剩<c:out value="${voucherEntitie.voucherCount - voucherEntitie.voucherOutCount }" escapeXml="true"/>份
                </div>
                <div class="co_3">
                    <div class="co3_1">
                        <div class="co3_1a">
                            <img src="img/tiao.png" style='width: <c:out value="${(voucherEntitie.voucherOutCount/voucherEntitie.voucherCount)*100}" escapeXml="true"/>%'/>
                        </div>
                        <div class="co3_1b">

                            ￥ <c:out value="${voucherEntitie.voucherValue}" escapeXml="true"/>
                        </div>
                    </div>
                    <div class="co3_2b">
                        <img src="img/botton.png" onclick='maShang("${voucherEntitie.id}");'/>
                    </div>
                </div>
            </div>
        </div>
        <div class="layui-col-xs12" style="height: 0.5rem;"></div>
    </div>
</c:forEach>