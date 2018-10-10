<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="com.lymava.wechat.gongzhonghao.Gongzonghao" %>
<%@ page import="com.lymava.wechat.gongzhonghao.GongzonghaoContent" %>
<%@ page import="com.google.gson.JsonObject" %>
<%@ page import="com.lymava.commons.util.JsonUtil" %>
<%@ page import="com.lymava.base.model.User" %>
<%@ page import="com.lymava.qier.action.CashierAction" %>
<%@ page import="com.lymava.base.util.ContextUtil" %>
<%@ page import="com.lymava.nosql.util.PageSplit" %>
<%@ page import="com.lymava.trade.business.model.TradeRecord" %>
<%@ page import="com.lymava.commons.state.State" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.List" %>
<%@ page import="com.lymava.commons.util.DateUtil" %>
<%@ page import="static java.lang.System.currentTimeMillis" %>
<%@ page import="org.bson.types.ObjectId" %>
<%@ page import="java.util.Date" %>
<%@ page import="com.lymava.nosql.mongodb.util.MongoCommand" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en" style="font-size:36px;">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta content="yes" name="apple-mobile-web-app-capable">
    <meta content="telephone=no,email=no" name="format-detection">
    <meta content="yes" name="apple-touch-fullscreen">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <meta content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0" name="viewport" /><!-- 屏蔽双击缩放 -->
    <title>悠择生活</title>
        <script type="text/javascript" src="${basePath }plugin/js/jquery/jquery-1.12.4.min.js"></script>
        <link rel="stylesheet" href="${basePath }plugin/js/layer_mobile/need/layer.css">
        <script type="text/javascript" src="${basePath }plugin/js/layer_mobile/layer.js"></script>
    </head>
    <body id="body" style="background: url('${basePath }merchant/business_page/cashier/${state }.jpg') no-repeat; background-size: 100%">
    <script type="text/javascript">

        function success_update(requestData) {
            $.post("${basePath}merchant/business_page/cashier/success_update.jsp",requestData,function (msg) {
                msg = JSON.parse($.trim(msg));

                if(msg.statusCode == 300){
                    layer.open({
                        content:msg.message
                        ,btn: ['请通知下跑腿的业务员']
                    });
                }

                if(msg.statusCode == 200){
                    layer.open({
                        content:msg.message
                        ,btn: ['操作成功']
                    });
                }

            });
        }

        $(function () {
            var sign = "${sign}";
            var openId = "${openId}";
            var merchantId = "${merchantId}";

//            var sign = "4609acc8770f382e58fa247cdef1f424";
//            var openId = "oYb451MFXDeJLuUV6MBH2jgvPGs0";
//            var merchantId = "5aa0adf3ef722c157280a317";

            var requestData = {
                "sign":sign,
                "openId":openId,
                "merchantId":merchantId,
                "caozuo":""
            };

            layer.open({
                content: '请告诉我 您想进行的操作'
                ,btn: ['绑定通知','解除绑定',]
                ,yes:function () {
                    requestData.caozuo = "bind";
                    success_update(requestData);
                },no:function () {
                    requestData.caozuo = "unbind";
                    success_update(requestData);
                }
            });
        });
        
    </script>
    </body>
</html>
