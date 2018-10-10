<%--
  Created by IntelliJ IDEA.
  User: Administrator
  Date: 2018\4\17 0017
  Time: 13:52
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../header/check_openid.jsp"%>
<%@ include file="../header/header_check_login.jsp"%>
<html>
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width,initial-scale=1,minimum-scale=1,maximum-scale=1,user-scalable=no" />
    <title>促销活动</title>
    <link rel="stylesheet" href="css/activity.css" />
    <link rel="stylesheet" type="text/css" href="layui-v2.2.5/layui/css/layui.css"/>


    <script type="text/javascript" src="${basePath }merchanr_center/js/jquery-3.2.1.js"></script>
    <script type="text/javascript" src="${basePath }merchanr_center/js/layer.mobile-v2.0/layer.mobile-v2.0/layer_mobile/layer.js"></script>
</head>
<body>
<div class="active layui-col-xs12" id="bodyData">
    <!--头顶部分-->
    <div class="top layui-col-xs12">
        <div class="top1 layui-col-xs12" style="position: absolute;">
            <img src="img/nav_bg.png"/>
        </div>
        <div class="top2 layui-col-xs12" style="position: relative;">
            <div class="top2_1 layui-col-xs4">&nbsp;</div>
            <div class="top2_2 layui-col-xs4">
                促销活动
            </div>
            <div class="top2_3 layui-col-xs4">
                <a href="/merchanr_center/coupon.jsp"><div class="">我的优惠券</div></a>
            </div>
        </div>
    </div>
    <!--点击后套餐页面	-->
    <div class="clock1">
        <div class="active1">
            <img src="img/bgg.png"/>
        </div>
        <div class="active_all1">
            <div class="active_vo">
                <div class="voucher1">
                    <div class="voucher1_1">
                        <div class="vo1_1" >
                            <span id="userNameVoucher"></span>

                        </div>
                        <div class="vo1_2">
                            有效期：<span id="showReleaseTime"></span> 至 <span id="showStopTime"></span>
                        </div>
                    </div>
                    <div class="voucher1_2">
                        <div class="vou1">
                            ￥
                        </div>
                        <div class="vou2">
                            <span id="voucherValue"></span>
                        </div>
                    </div>
                    <div class="clear"></div>
                </div>
                <div class="voucher2">
                    满<span id="low_consumption_amount"></span>可使用
                </div>
                <%--todo 使用规则 暂留--%>
                <%--<div class="voucher3">--%>
                    <%--使用规则：--%>
                <%--</div>--%>
                <%--<div class="voucher4">--%>
                    <%--1、可与其他优惠同享<br />--%>
                    <%--2、仅代金券领取城市使用<br />--%>
                    <%--3、仅莽子老火锅使用<br />--%>
                    <%--4、仅在线支付可用--%>
                <%--</div>--%>
                <div class="" style="height: 2rem;"></div>
                <span id="voucherId"></span>
                <div class="voucher5">
                    <span id="nowGet"><img src="img/bg_2.png"/></span>
                </div>
            </div>
        </div>
    </div>



</div>
</body>

<script type="text/javascript">

    // '马上抢'的点击事件
    function maShang(id) {
        $(".co3_2b").click(function(){ $(".clock1").css("display","block"); });

        $.post("${basePath}/qier/orderReportContent/getOneVoucher.do",{"id":id},function (data) {
            data = JSON.parse(data);

            if (data.statusCode == 300){
                //提示
                layer.open({
                    content: '手慢了,被抢光了!'
                    ,skin: 'msg'
                    ,time: 2 //2秒后自动关闭
                });
            }else if(data.statusCode == 200){
                data = JSON.parse(data.data.jsonData);
                $("#userNameVoucher").text(data[0].userName);
                $("#showReleaseTime").text(data[0].showReleaseTime);
                $("#showStopTime").text(data[0].showStopTime);
                $("#voucherValue").text(data[0].voucherValue);
                $("#low_consumption_amount").text(data[0].low_consumption_amount);
                $("#voucherId").attr("value",data[0].id);
            }
        });
    }

    $(function () {
        // 点击'马上抢'按钮展示页面 和 点击其他地方关闭页面
//        $(".co3_2a").click(function(){ $(".clock").css("display","block"); });
//        $(".clock").click(function(){ $(".clock").css("display","none"); });
//        $(".co3_2b").click(function(){ $(".clock1").css("display","block"); });
        $(".clock1").click(function(){ $(".clock1").css("display","none"); });

        // 加载所有正在发布中的代金券
        $.post("${basePath}/qier/orderReportContent/getAllVoucherData.do",function (data) {
            $("#bodyData").append(data);
        });


        $("#nowGet").click(function () {
            var id = $("#voucherId").attr("value");

            $.post("${basePath}/qier/orderReportContent/userGetOneVoucherNow.do",{"id":id},function (data) {
                //提示
                layer.open({
                    content: JSON.parse(data).message
                    ,skin: 'msg'
                    ,time: 2 //2秒后自动关闭
                });
            })
        });

    });



    
</script>

</html>