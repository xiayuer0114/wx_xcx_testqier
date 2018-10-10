<%--
  Created by IntelliJ IDEA.
  User: Administrator
  Date: 2018\4\18 0018
  Time: 11:33
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
                <div class="coupon_2 ">
                    <div class="coupon_left">
                        <img style="width:5rem;height: 4rem;" src='${basePath }${voucherEntitie.logo}' />
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
                            <div class="coup3d"><c:out value="${voucherEntitie.address}" escapeXml="true"/></div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="coupon2 layui-col-xs4">
                <div class="coupon2_1 layui-col-xs12">
                    <img src="images/quan1.png"/>
                </div>
                <div class="coupon2_2 ">
                    <div class="coupo1">
                        ￥${voucherEntitie.voucherValue }
                    </div>
                    <div class="coupo2">
                        满<c:out value="${voucherEntitie.low_consumption_amount}" escapeXml="true"/>使用 <br>
    					<c:out value="${voucherEntitie.showStopTime}" escapeXml="true"/>
                    </div>
                    <div style="height: 0.2em;"></div>
                </div>
            </div>
        </div>
</c:forEach>