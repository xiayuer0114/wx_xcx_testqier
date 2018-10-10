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
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>

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
    user = (User)ContextUtil.getSerializContext().get(user);

    String page_temp = request.getParameter("page");
    String pageSize_temp = request.getParameter("pageSize");
    PageSplit pageSplit = new PageSplit(page_temp, pageSize_temp);


//    pageSplit.setPage(1);
    pageSplit.setPageSize(2);

    TradeRecord tradeRecord = new TradeRecord();
    tradeRecord.setUser_merchant(user);
    tradeRecord.setState(State.STATE_PAY_SUCCESS);

//    List<TradeRecord> tradeRecords = ContextUtil.getSerializContext().findAll(tradeRecord);

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


<head>
    <title>Title</title>

    <script type="text/javascript" src="${basePath }plugin/js/jquery/jquery-1.12.4.min.js"></script>
    <link rel="stylesheet" href="${basePath }plugin/js/layer_mobile/need/layer.css">
    <script type="text/javascript" src="${basePath }plugin/js/layer_mobile/layer.js"></script>



</head>
<body>
<strong>今日收益：</strong> ${today_price_fen_all/100} 元 &nbsp;&nbsp;
<table class="table table-striped table-hover table-bordered" data-search="true" id="orderDataViewTable">
    <thead>
    <tr>
        <th align="center">商品名称</th>
        <th text-align="center">总价</th>
        <%--<th text-align="center">创建时间</th>--%>
        <th text-align="center">付款时间</th>
        <%--<th text-align="center">付款方式</th>--%>
        <%--<th text-align="center">付款状态</th>--%>
        <th text-align="center">备注</th>
    </tr>
    </thead>
    <tbody>
    <!--数据循环-->
    <c:forEach var="tradeRecord" items="${object_ite}">
        <tr>
            <td>${tradeRecord.product.name}</td>
            <td>${tradeRecord.price_fen_all/100 }</td>
                <%--<td>${tradeRecord.showTime }</td>--%>
            <td>${tradeRecord.showPayTime }</td>
                <%--<td>${tradeRecord.showPay_method }</td>--%>
                <%--<td>${tradeRecord.showState }</td>--%>
            <td>${tradeRecord.memo}</td>
        </tr>
    </c:forEach>
    </tbody>
</table>
<br><br><br><br><br>the end...

<%--<li><a href="javascript:void(0)" onclick="sc();">下一页</a></li>--%>

<script type="text/javascript">
    var pageNow = 1;

    function sc() {
        pageNow = pageNow +1;
        var pageSize = ${pageSplit.pageSize};
        $.post("${basePath}/qier/orderReportContent/gongzonghaoOrderViewData.do",{"pageNow":pageNow,"pageSize":pageSize},function (data) {
            data = JSON.parse(data).message.toString();
            data = JSON.parse(data);

            for (var i = 0; i<data.length; i++){
                $tr = $("<tr></tr>");
                $td1 = $("<td>"+data[i].tradeRecord72Name+"</td>");
                $td2 = $("<td>"+data[i].price_fen_all/100+"</td>");
                $td3 = $("<td>"+data[i].showPayTime+"</td>");
                $td4 = $("<td>"+data[i].memo+"</td>");
                $tr.append($td1).append($td2).append($td3).append($td4);
                $("#orderDataViewTable").append($tr);
            }
        });

    }

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
                    $tr = $("<tr></tr>");
                    $td1 = $("<td>"+data[i].tradeRecord72Name+"</td>");
                    $td2 = $("<td>"+data[i].price_fen_all/100+"</td>");
                    $td3 = $("<td>"+data[i].showPayTime+"</td>");
                    $td4 = $("<td>"+data[i].memo+"</td>");
                    $tr.append($td1).append($td2).append($td3).append($td4);
                    $("#orderDataViewTable").append($tr);
                }
            });
        }
    }

</script>

</body>
</html>
