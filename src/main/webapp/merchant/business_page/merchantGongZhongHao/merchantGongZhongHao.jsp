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
<%@ page import="com.lymava.commons.util.DateUtil" %>
<%@ page import="static java.lang.System.currentTimeMillis" %>
<%@ page import="org.bson.types.ObjectId" %>
<%@ page import="com.lymava.nosql.mongodb.util.MongoCommand" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.util.List" %><%--
  Created by IntelliJ IDEA.
  User: Administrator
  Date: 2018\4\8 0008
  Time: 21:23
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%

    String code = request.getParameter("code");
    // 通过codeId拿到 openId
    Gongzonghao gongzonghao = GongzonghaoContent.getInstance().getDefaultGongzonghao();
    String user_access_token = null;
    try {
        user_access_token = gongzonghao.get_user_access_token(code);
    } catch (Exception e) {
        e.printStackTrace();
    }

    JsonObject user_access_token_jsonObject =  JsonUtil.parseJsonObject(user_access_token);
    String openId  = JsonUtil.getRequestString(user_access_token_jsonObject, "openid");

    User user = new User();
    user.setThird_user_id("oFqO35SQQqVME0f5jcDhQd1pbKhw");
    user.setUserGroupId(CashierAction.getMerchantUserGroutId());
    user = (User) ContextUtil.getSerializContext().get(user);

    String page_temp = request.getParameter("page");
    String pageSize_temp = request.getParameter("pageSize");
    PageSplit pageSplit = new PageSplit(page_temp, pageSize_temp);


//    pageSplit.setPage(1);
    pageSplit.setPageSize(10);

    TradeRecord tradeRecord = new TradeRecord();
//    tradeRecord.setUser_merchant(user);
//    tradeRecord.setState(State.STATE_PAY_SUCCESS);

    List<TradeRecord> tradeRecords = ContextUtil.getSerializContext().findAll(tradeRecord);
    System.out.println(tradeRecords);

    // 全部数据
    Iterator object_ite = ContextUtil.getSerializContext().findIterable(tradeRecord, pageSplit);
    request.setAttribute("object_ite", object_ite);
    request.setAttribute("pageSplit", pageSplit);

    // 今天开始的时间戳
    Long today_start_time = DateUtil.getDayStartTime(currentTimeMillis());
    // 今天结束的时间戳
    Long today_end_time = today_start_time + DateUtil.one_day;


    // 今天的数据统计
    ObjectId today_start_object_id = new ObjectId(new Date(today_start_time));
    tradeRecord.addCommand(MongoCommand.dayuAndDengyu, "id", today_start_object_id);

    ObjectId today_end_object_id = new ObjectId(new Date(today_end_time));
    tradeRecord.addCommand(MongoCommand.xiaoyu, "id", today_end_object_id);

    List<TradeRecord> tradeRecords_today = ContextUtil.getSerializContext().findAll(tradeRecord);

    Long today_price_fen_all = 0L;
    for (int i=0; i<tradeRecords_today.size();i++){
        today_price_fen_all += tradeRecords_today.get(i).getPrice_fen_all();
    }
    request.getSession().setAttribute("today_price_fen_all",today_price_fen_all);

%>


<html>
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width,initial-scale=1,minimum-scale=1,maximum-scale=1,user-scalable=no" />
    <title>商家页面</title>
    <link rel="stylesheet" href="css/my.css" />
    <link rel="stylesheet" type="text/css" href="layui-v2.2.5/layui/css/layui.css"/>

    <script type="text/javascript" src="${basePath }plugin/js/jquery/jquery-1.12.4.min.js"></script>
    <link rel="stylesheet" href="${basePath }plugin/js/layer_mobile/need/layer.css">
    <script type="text/javascript" src="${basePath }plugin/js/layer_mobile/layer.js"></script>
</head>
<body>

<div class="container">
    <!--顶部-->
    <div class="top">
        <div class="top1">
            我是商家
        </div>
    </div>

    <!--今日收益-->
    <div class="bg"></div>
    <div class="today">
        <div class="today_1">
            今日收入（元）
        </div>
        <div class="today_2">
            ${today_price_fen_all/100}
        </div>
        <div class="today_3 layui-col-xs12">
            <div class="today_3a layui-col-xs6">
                <div class="tt">
                    交易共1笔
                </div>
            </div>
            <div class="today_3blayui-col-xs6">
                <div class="tt1">
                    顾客共1人
                </div>
            </div>
        </div>
        <div class="clear"></div>
    </div>
    <div class="bg"></div>

    <!--最新一笔-->
    <div class="date layui-col-xs12">
        <div class="date_1 layui-col-xs9">
            <div class="">
                最新一笔
            </div>
            <div class="">
                &nbsp;|
            </div>
            <div class="">
                &nbsp;04月15日 &nbsp;
            </div>
            <div class="">
                15：55
            </div>
        </div>
        <div class="date_2 layui-col-xs3">
            <div class="">
                0.10元
            </div>
        </div>
    </div>

    <!--对账-->
    <div class="account layui-col-xs12">
        <div class="account_1 layui-col-xs5">
            <img src="img/icon1.png"/>&nbsp;查账
        </div>
        <div class="layui-col-xs2" style="color: #68b7f1;padding-top: 0.5rem;">
            |
        </div>
        <div class="account_2 layui-col-xs5">
            <img src="img/icon.png"/>&nbsp;报表
        </div>
    </div>
    <div class="clear"></div>
    <!--详情处-->
    <div class="details" id="orderDataViewTable">
        <c:forEach var="tradeRecord" items="${object_ite}">
            <div class="details1">
                <div class="details1_1">
                    <img src="img/xiang.png"/>
                </div>
                <div class="details1_2">
                    <div class="dd">
                        ${tradeRecord.product.name}
                    </div>
                    <div class="dd1">
                        ${tradeRecord.showTime }
                    </div>
                </div>
                <div class="details1_3">
                    <div class="dd">
                        ${tradeRecord.price_fen_all/100 }
                    </div>
                    <div class="dd1">
                        ${tradeRecord.showPay_method }
                    </div>
                </div>
            </div>
        </c:forEach>
        <div class="clear"></div>
    </div>

</div>

<script type="text/javascript">
    var pageNow = 1;
    //文档高度
    function getDocumentTop() {
        var scrollTop = 0, bodyScrollTop = 0, documentScrollTop = 0;
        if (document.body) {
            bodyScrollTop = document.body.scrollTop;
        }
        if (document.documentElement) {
            documentScrollTop = document.documentElement.scrollTop;
        }
        scrollTop = (bodyScrollTop - documentScrollTop > 0) ? bodyScrollTop : documentScrollTop;    return scrollTop;
    }

    //可视窗口高度
    function getWindowHeight() {
        var windowHeight = 0;    if (document.compatMode == "CSS1Compat") {
            windowHeight = document.documentElement.clientHeight;
        } else {
            windowHeight = document.body.clientHeight;
        }
        return windowHeight;
    }

    //滚动条滚动高度
    function getScrollHeight() {
        var scrollHeight = 0, bodyScrollHeight = 0, documentScrollHeight = 0;
        if (document.body) {
            bodyScrollHeight = document.body.scrollHeight;
        }
        if (document.documentElement) {
            documentScrollHeight = document.documentElement.scrollHeight;
        }
        scrollHeight = (bodyScrollHeight - documentScrollHeight > 0) ? bodyScrollHeight : documentScrollHeight;    return scrollHeight;
    }

    window.onscroll = function () {
        //监听事件内容
        if(getScrollHeight() <= getWindowHeight() + getDocumentTop()){
            //当滚动条到底时,这里是触发内容
            //异步请求数据,局部刷新dom


            pageNow = pageNow +1;
            var pageSize = ${pageSplit.pageSize};
            $.post("${basePath}/qier/orderReportContent/gongzonghaoOrderViewData.do",{"pageNow":pageNow,"pageSize":pageSize},function (data) {
                data = JSON.parse(data).message.toString();
                data = JSON.parse(data);

                for (var i = 0; i<data.length; i++){
                    $tr = $("<div class='details1'></div>");
                    $td1 = $("<div class='details1_1'><img src='img/xiang.png'/></div>");
                    $td2 = $("<div class='details1_2'></div>");
                    $td3 = $("<div class='details1_3'></div>");

                    $td4 = $("<div class='dd'>"+data[i].tradeRecord72Name+"</div>");
                    $td5 = $("<div class='dd1'>"+data[i].payTime+"</div>");
                    $td6 = $("<div class='dd'>"+data[i].price_fen_all/100+"</div>");
                    $td7 = $("<div class='dd1'>"+data[i].payMethed+"</div>");


                    $td2.append($td4).append($td5);
                    $td3.append($td6).append($td7);

                    $tr.append($td1).append($td2).append($td3);
                    $("#orderDataViewTable").append($tr);
                }
            });
        }
    }

</script>



</body>
</html>
