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
                    <div class="" style="float: left;">
                        <img src="img/dian.png"/>
                    </div>
                    <div class="" style="float: left;padding-left: 2%;padding-top: 0.1rem;">
                        <c:out value="${voucherEntitie.userName}" escapeXml="true"/>
                    </div>
                </div>
                <div class="c_2 layui-col-xs4">

                </div>
                <div class="c_3 layui-col-xs4" >
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
                    <div class="co3_1">
                        <div class="co_3">
                            还剩<c:out value="${voucherEntitie.voucherCount - voucherEntitie.voucherOutCount }" escapeXml="true"/>份
                        </div>
                        <div class="co3_1a">
                            <img src="img/tiao.png" style='width: <c:out value="${voucherEntitie.showCountRatio }" escapeXml="true"/>%'/>
                        </div>
                        <div class="co3_1b">
                            <div class="co3_1f">
                                ￥
                            </div>
                            <div class="co3_2f">
                                <c:out value="${voucherEntitie.voucherValue}" escapeXml="true"/>
                            </div>
                        </div>
                    </div>
                    <div class="co3_2a">
                        <div class="co3_f">
                            <span onclick='maShang("${voucherEntitie.id}");'>马上抢</span>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="layui-col-xs12" style="height: 0.5rem;"></div>
    </div>

    </div>
</c:forEach>