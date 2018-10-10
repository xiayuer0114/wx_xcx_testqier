<%@page import="com.lymava.qier.action.CashierAction"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="com.lymava.base.model.User" %>
<%@ page import="com.lymava.base.util.ContextUtil" %>
<%@ page import="com.lymava.nosql.util.PageSplit" %>
<%@ page import="com.lymava.trade.business.model.TradeRecord" %>
<%@ page import="com.lymava.commons.util.DateUtil" %>
<%@ page import="static java.lang.System.currentTimeMillis" %>
<%@ page import="org.bson.types.ObjectId" %>
<%@ page import="com.lymava.nosql.mongodb.util.MongoCommand" %>
<%@ page import="com.lymava.commons.exception.CheckException" %>
<%@ page import="java.util.*" %>
<%@ page import="com.lymava.commons.state.State" %>
<%@ page pageEncoding="UTF-8" language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="../header/check_openid.jsp"%>
<%@ include file="../header/header_check_login.jsp"%>
<%
	if(user == null || CashierAction.getCommonUserGroutId().equals(user.getUserGroupId())){
		response.sendRedirect(MyUtil.getBasePath(request)+"merchant_show/index.jsp");
		return;
	}
%>
<html>
<head>

    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width,initial-scale=1,minimum-scale=1,maximum-scale=1,user-scalable=no" />
    <title>商家中心</title>
    <link rel="stylesheet" href="css/my.css" />
    <link rel="stylesheet" type="text/css" href="layui-v2.2.5/layui/css/layui.css"/>

    <script type="text/javascript" src="${basePath }merchanr_center/js/jquery-3.2.1.js"></script>
    <script type="text/javascript" src="${basePath }merchanr_center/js/layer.mobile-v2.0/layer.mobile-v2.0/layer_mobile/layer.js"></script>

</head>
<body>
    <div class="container">
        <!--顶部-->
        <div class="top">
            <div class="top1">
                ${userCheck.nickname}
            </div>
        </div>

        <!--今日收益-->
        <div class="bg"></div>
        <div class="today">
            <div class="today_1">
                收入（元）
            </div>
            <div class="today_2">
                <span id="today_price_fen_all"></span>
            </div>
            <div class="today_3 layui-col-xs12">
                <div class="today_3a layui-col-xs6">
                    <div class="tt">
                        交易共<span id="today_order"></span>笔
                    </div>
                </div>
                <div class="today_3blayui-col-xs6">
                    <div class="tt1">
                        顾客共<span id="renshu"></span>人
                    </div>
                </div>
            </div>
            <div class="clear"></div>
        </div>
        <div class="bg"></div>

        <!--对账-->
        <div class="account layui-col-xs12">
            <div class="account_1 layui-col-xs5">
                <img src="img/icon1.png"/>&nbsp;查账
            </div>
            <div class="layui-col-xs2" style="color: #68b7f1;padding-top: 0.5rem;">
                |
            </div>
            <div class="account_2 layui-col-xs5" >
                <img src="img/icon.png"/>&nbsp;
            </div>
        </div>
        <div class="clear"></div>
        <!--详情处-->
        <div class="details" id="orderDataViewTable">
        </div>

    </div>


    <%--点击一个订单  弹出这个订单的具体消息--%>
    <div class="click">
        <div class="click1">
            <img src="img/shangjia.png"/>
        </div>
        <div class="click2">
            <div class="click3 ">
                <!--一-->
                <div class="click2_1">
                    <img id="img" src=""/>
                    &nbsp;<span id="userName"></span>
                </div>
                <div id="dataHide">
                    <div class="click2_2">
                        +<span id="price_fen_all"></span>
                    </div>
                    <div class="click2_3">
                        <span id="showState"></span>
                    </div>

                    <!--二-->
                    <div class="click2_4">
                        <div class="cl1">
                            付款方式
                        </div>
                        <div class="cl2">
                            <span id="showPay_method"></span>
                        </div>
                    </div>
                    <div class="clear"></div>
                    <div class="click2_5">
                        <div class="cl1">
                            商品说明
                        </div>
                        <div class="cl2">
                            <span id="productName"></span>
                        </div>
                    </div>
                    <div class="clear"></div>

                    <!--三-->
                    <div class="click2_6">
                        <div class="cl1">
                            创建时间
                        </div>
                        <div class="cl2">
                            <span id="showTime"></span>
                        </div>
                    </div>
                    <div class="clear"></div>
                    <div class="click2_5">
                        <div class="cl1">
                            订单号
                        </div>
                        <div class="cl2">
                            <span id="payFlow"></span>
                        </div>
                    </div>
                    <div class="clear"></div>
                    <div class="click2_5">
                        <div class="cl1">
                            商户订单号
                        </div>
                        <div class="cl2">
                            <span id="productId"></span>
                        </div>
                    </div>
                    <div class="clear"></div>
                </div>

                <div class="" style="padding-top: 2rem;"></div>
            </div>
        </div>
    </div>

    <div class="inquire">
        <div class="click1">
            <img src="img/shangjia.png"/>
        </div>
        <div class="click_s">
            <div class="search">
                <div class="search1">
                    <input type="text" id="inputOrderId" placeholder="&nbsp;输入订单号查询 , 或者选择日期查询" class="layui-col-xs12"/>
                </div>
                <div class="search2">
                    <div class="se_1">
                        <input type="date" id="startDate" placeholder="&nbsp;&nbsp;输入起始时间"/>
                    </div>
                    <div class="se_2">
                        <input type="date" id="endDate" placeholder="&nbsp;&nbsp;输入截止时间"/>
                    </div>
                </div>
                <div class="clear"></div>
                <div class="search3" onclick="selByWhere();">
                    查询
                </div>
                <center><div><font color="red"><span id="errorMsg"></span></font></div></center>
            </div>
        </div>
    </div>

</body>


<script type="text/javascript">


    $(".account_1").click(function(){
        $(".inquire").css("display","block");
    });
    $(".click1").click(function(){
        $(".inquire").css("display","none");
    });


    // 根据输入的订单号  或者 选着的日期查询订单数据
    function selByWhere(){

        var orderId = $("#inputOrderId").val();
        var startDate = $("#startDate").val();
        var endDate = $("#endDate").val();

        if (endDate=="" || endDate==null || startDate=="" || startDate==null){
            if(orderId=="" || orderId==null){
                $("#errorMsg").text("数据不完整");
                return;
            }else {
                $(".inquire").css("display","none");
                orderViewDetails(orderId);
            }
        } else {
            $("#errorMsg").text("");
            $(".inquire").css("display","none");

            $("#orderDataViewTable").empty();

            pageNow = 1;
            isToday = "1";
            thisStartDate = startDate;
            thisEndDate = endDate;

            $.post("${basePath}/qier/orderReportContent/gongzonghaoInitOrderViewData.do",{"isToday":isToday,"startDate":startDate,"endDate":endDate},function (data) {
                $("#today_price_fen_all").text(JSON.parse(data).data.today_price_fen_all/100);
                $("#renshu").text(JSON.parse(data).data.renshu);
                $("#today_order").text(JSON.parse(data).data.today_order);

                data = JSON.parse(data).message.toString();
                data = JSON.parse(data);
                addData(data);
            });
        };

    };

    //  点击订单  展示详细信息
    function orderViewDetails(orderId) {
        $(".click").css("display","block");

        $.post("${basePath}/qier/orderReportContent/orderViewDetails.do",{"orderId":orderId},function (data) {
            data = JSON.parse(data).data;

            if (data=="" || data==null){
                $("#img").attr("src","img/pay2.png");
                $("#userName").text("订单信息有误!");

                $("#dataHide").hide();
                return;
            }
            $("#dataHide").show();

            if(data.pay_method == 300){
                $("#img").attr("src","img/pay.png");
            }else if(data.pay_method == 400){
                $("#img").attr("src","img/pay1.png");
            }else {
                $("#img").attr("src","img/pay2.png");
            }

            $("#userName").text(data.nickname);
            $("#payFlow").text(data.payFlow);
            $("#price_fen_all").text(data.price_fen_all/100);
            $("#productId").text(data.productId);
            $("#productName").text(data.productName);
            $("#showPay_method").text(data.showPay_method);
            $("#showState").text(data.showState);
            $("#showTime").text(data.showTime);
        });
    }

    // 点击报表   展示订单数据(手机)
    function viewOrderData(userId) {
        window.location.href = "${basePath}merchanr_center/phoneViewData.jsp?userId="+userId;
    };

    // 这个方法由其他地方调用 传入json的数据 使用jquery向页面添加订单信息
    function addData(data) {
        for (var i = 0; i<data.length; i++){

            $tr = $("<div class='details1' onclick=orderViewDetails('"+data[i].payFlow+"');></div>");

            $td1 = $("<div class='details1_1'></div>");
            $td2 = $("<div class='details1_2'></div>");
            $td3 = $("<div class='details1_3'></div>");

            $td4 = $("<div class='aa'>"+data[i].tradeRecord72Name+"</div>");
            $td5 = $("<div class='aa1'>"+data[i].payTime+"</div>");
            $td6 = $("<div class='dd'>+"+data[i].price_fen_all/100+"</div><div class=\"clear\"></div>");
            $td7 = $("<div class='dd1'>"+data[i].payMethed+"</div><div class=\"clear\"></div>");



            $td = $("<img src='img/yorz_logo.jpg'/>");
            if(data[i].payMethedInteger == 300){
                $td = $("<img src='img/pay.png'/>");
            }else if(data[i].payMethedInteger == 400){
                $td = $("<img src='img/pay1.png'/>");
            }

            $td2.append($td4).append($td5);
            $td3.append($td6).append($td7);
            $td1.append($td);

            $clear = $("<div class='clear'></div>");

            $tr.append($td1).append($td2).append($td3);
            $("#orderDataViewTable").append($tr).append($clear);
        }
    }


    //  加载事件
    $(function () {
        //  点击弹出层的任意地方 关闭弹出层
        $(".click").click(function(){
            $(".click").css("display","none");
            <%--$.post("${basePath}/qier/orderReportContent/clearOrderViewDetails.do");--%>
        });

        //初始化数据
        $.post("${basePath}/qier/orderReportContent/gongzonghaoInitOrderViewData.do",{"isToday":isToday},function (data) {

            $("#today_price_fen_all").text(JSON.parse(data).data.today_price_fen_all/100);
            $("#renshu").text(JSON.parse(data).data.renshu);
            $("#today_order").text(JSON.parse(data).data.today_order);

            data = JSON.parse(data).message.toString();
            data = JSON.parse(data);
            addData(data);
        });
    });

    var pageNow = 1;
    var isToday= "0";
    var thisStartDate = "";
    var thisEndDate = "";

    // 事件监听  上拉到底部加载数据
    window.onscroll = function () {



        //监听事件内容
        if(getScrollHeight() <= getWindowHeight() + getDocumentTop()){
            //当滚动条到底时,这里是触发内容
            //异步请求数据,局部刷新dom
            pageNow = pageNow +1;

            $.post("${basePath}/qier/orderReportContent/gongzonghaoInitOrderViewData.do",{"isToday":isToday,"pageNow":pageNow,"startDate":thisStartDate,"endDate":thisEndDate},function (data) {
                data = JSON.parse(data).message.toString();
                data = JSON.parse(data);

                addData(data);
            });
        }
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

</script>

</html>
