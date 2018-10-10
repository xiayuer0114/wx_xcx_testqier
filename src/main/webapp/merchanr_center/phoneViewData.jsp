<%@ page import="com.lymava.commons.util.DateUtil" %>
<%@ page import="static java.lang.System.currentTimeMillis" %>
<%@ page import="org.bson.types.ObjectId" %>
<%@ page import="java.util.Date" %>
<%@ page import="com.lymava.qier.model.TradeRecord72" %>
<%@ page import="com.lymava.nosql.mongodb.util.MongoCommand" %>
<%@ page import="java.util.List" %>
<%@ page import="com.lymava.base.util.ContextUtil" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="com.lymava.commons.state.State" %>
<%@ page import="java.util.ArrayList" %><%--
  Created by IntelliJ IDEA.
  User: Administrator
  Date: 2018\4\10 0010
  Time: 10:14
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    // 得到商家id
    String userId = request.getParameter("userId");

    if (userId==null || "".equals(userId)){
        return;
    }

    // 今天开始的时间戳
    Long today_start_time = DateUtil.getDayStartTime(currentTimeMillis());
    // 今天结束的时间戳
    Long today_end_time = today_start_time + DateUtil.one_day;
    // 间隔时间的时间戳
    Long jiange = DateUtil.one_hour*4;

    // 设置查询条件
    TradeRecord72 tradeRecord = new TradeRecord72();
    tradeRecord.setUserId_merchant(userId);
    tradeRecord.setState(State.STATE_PAY_SUCCESS);


    SimpleDateFormat simpleDateFormat = new SimpleDateFormat("kk");

    // 横坐标
    String Xshow = "";
    // 总金额
    String today_price_fen_all = "";
    // 支付宝金额
    String today_price_fen_alipay = "";
    // 微信金额
    String today_price_fen_wechatpay = "";

    List<Long> list = new ArrayList();

    for (;;){
        if(today_start_time>=today_end_time){
            break;
        }

        // 查询出每个间隔时间段的数据
        ObjectId today_start_object_id = new ObjectId(new Date(today_start_time));
        tradeRecord.addCommand(MongoCommand.dayuAndDengyu, "id", today_start_object_id);
        ObjectId today_end_object_id = new ObjectId(new Date(today_start_time+jiange));
        tradeRecord.addCommand(MongoCommand.xiaoyu, "id", today_end_object_id);

        List<TradeRecord72> tradeRecords_today = ContextUtil.getSerializContext().findAll(tradeRecord);
        Long tradeRecords_today_Price_fen_all =0L;
        Long tradeRecords_today_Price_fen_alipay =0L;
        Long tradeRecords_today_Price_fen_wechetpay =0L;
        for (int i =0;i<tradeRecords_today.size();i++){
            tradeRecords_today_Price_fen_all += tradeRecords_today.get(i).getPrice_fen_all();

            if(tradeRecords_today.get(i).getPay_method() == 300){
                tradeRecords_today_Price_fen_alipay += tradeRecords_today.get(i).getPrice_fen_all();
            }else if(tradeRecords_today.get(i).getPay_method() == 400){
                tradeRecords_today_Price_fen_wechetpay += tradeRecords_today.get(i).getPrice_fen_all();
            }
        }

        Date date= new Date(today_start_time);
        Xshow += simpleDateFormat.format(date)+"点,";

        today_price_fen_all += tradeRecords_today_Price_fen_all+",";
        today_price_fen_alipay += tradeRecords_today_Price_fen_alipay+",";
        today_price_fen_wechatpay += tradeRecords_today_Price_fen_wechetpay+",";

        list.add(tradeRecords_today_Price_fen_alipay);

        today_start_time = today_start_time+jiange;
    }


    request.getSession().setAttribute("list",list);
    request.getSession().setAttribute("Xshow",Xshow);
    request.getSession().setAttribute("today_price_fen_all",today_price_fen_all);
    request.getSession().setAttribute("today_price_fen_alipay",today_price_fen_alipay);
    request.getSession().setAttribute("today_price_fen_wechatpay",today_price_fen_wechatpay);
%>

<html>
<head>
    <title>Title</title>
    <script type="text/javascript" src="js/highcharts.js"></script>
    <script type="text/javascript" src="js/jquery-3.2.1.js"></script>

</head>
<body>

<span id="list" value=${list}></span>
<span id="Xshow" value=${Xshow}></span>
<span id="today_price_fen_all" value=${today_price_fen_all}></span>
<span id="today_price_fen_alipay" value=${today_price_fen_alipay}></span>
<span id="today_price_fen_wechatpay" value=${today_price_fen_wechatpay}></span>

<div id="container" style="width:100%;height:50em"></div>

</body>

<script type="text/javascript">
    $(function () {

        var list = $("#list").attr("value");
        var Xshow = $("#Xshow").attr("value");
        var today_price_fen_all = $("#today_price_fen_all").attr("value");
        var today_price_fen_alipay = $("#today_price_fen_alipay").attr("value");
        var today_price_fen_wechatpay = $("#today_price_fen_wechatpay").attr("value");



        var xShowTime = Xshow.split(",");
        var price_all1 = today_price_fen_all.split(",");

        var price_alipay1 = today_price_fen_alipay.split(",");
        var price_wechat1 = today_price_fen_wechatpay.split(",");

        var price_all = new Array();
        var price_alipay = new Array();
        var price_wechat = new Array();

        for (var i=0;i<price_all1.length;i++){
            price_all.push(parseInt(price_all1[i])/100);
            price_alipay.push(parseInt(price_alipay1[i])/100);
            price_wechat.push(parseInt(price_wechat1[i])/100);
        }



        var chart = Highcharts.chart('container', {
            title: {
                text: '今日支付数据'
            },
    //        subtitle: {
    //            text: '数据来源：thesolarfoundation.com'
    //        },
            yAxis: {
                title: {
                    text: '支付金额(元)'
                }
            },
            xAxis: {
                categories: xShowTime,
                crosshair: true
            },
            legend: {
                layout: 'vertical',
                align: 'right',
                verticalAlign: 'middle'
            },
            plotOptions: {
                series: {
                    label: {
                        connectorAllowed: false
                    },
                    pointStart: 0
                }
            },
            series: [{
                name: '支付宝',
                data: price_alipay
            }, {
                name: '所有',
                data: price_all
            }, {
                name: '微信',
                data: price_wechat
            }],
            responsive: {
                rules: [{
                    condition: {
                        maxWidth: 500
                    },
                    chartOptions: {
                        legend: {
                            layout: 'horizontal',
                            align: 'center',
                            verticalAlign: 'bottom'
                        }
                    }
                }]
            }
        });
    });

</script>

</html>
