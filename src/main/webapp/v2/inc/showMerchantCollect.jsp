<%--
  Created by IntelliJ IDEA.
  User: Administrator
  Date: 2018\6\13 0013
  Time: 14:21
  To change this template use File | Settings | File Templates.
--%>

<%-- 孙M  6.13  商家的消费信息汇总(所有商家的订单信息) --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<html>
<head>
    <title>all merchant</title>
</head>
<body>

<br>
<div>
    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
    开始:&nbsp;
    <input  type="text" id="startDate_YY" style="width: 80px;" readonly="readonly"  class="form-control date" datefmt="yyyy-MM-dd" >
    年
    <input  type="text" id="start_HH" value="00" style="width: 20px">
    点
    <input  type="text" id="start_MM" value="00" style="width: 20px">
    分
    <input  type="text" id="start_SS" value="00" style="width: 20px">
    秒
    &nbsp;&nbsp; ---至--- &nbsp;&nbsp;
    结束:
    <input  type="text" id="endDate_YY" style="width: 80px;" readonly="readonly"  class="form-control date" datefmt="yyyy-MM-dd" >
    年
    <input  type="text" id="end_HH" value="00" style="width: 20px">
    点
    <input  type="text" id="end_MM" value="00" style="width: 20px">
    分
    <input  type="text" id="end_SS" value="00" style="width: 20px">
    秒

    <br><br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
    <button onclick="getAllMerchantDetail();">查询</button>


    <br> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
    <font color="red"><span id="errorMsg_D"></span></font>

    <br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;

    主体: <b><span id="startTimeStr_D"></span> ---至--- <span id="endTimeStr_D"></span>&nbsp;&nbsp;&nbsp;
    所有商家&nbsp;付款成功&nbsp;的订单详情</b>

    <br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;

    <table border="1">
        <tr>
            <td>订单金额:<span id="orderPrice_all_merchant"></span>元</td>
            <td>实际支付:<span id="realPrice_all_merchant"></span>元</td>
            <td>支付宝:<span id="aliPay_all_merchant"></span>元</td>
            <td>微信:<span id="wechatPay_all_merchant"></span>元</td>
            <td>红包:<span id="redPay_all_merchant"></span>元</td>
        </tr>
        <tr>
            <td>所有退款:<span id="orderPrice_refund_allmerchant"></span>元</td>
            <td>支付宝退款:<span id="aliPay_all_refund_allmerchant"></span>元</td>
            <td>微信退款:<span id="wechatPay_all_refund_allmerchant"></span>元</td>
            <td>红包退款:<span id="otherPay_all_refund_allmerchant"></span>元</td>
        </tr>
        <%--<tr>--%>
        <%--<td>已退款:</td>--%>
        <%--<td>订单金额:<span id="orderPrice_D1"></span>元</td>--%>
        <%--<td>实际支付:<span id="realPrice_D1"></span>元</td>--%>
        <%--<td>支付宝:<span id="aliPay_D1"></span>元</td>--%>
        <%--<td>微信:<span id="wechatPay_D1"></span>元</td>--%>
        <%--<td>红包:<span id="redPay_D1"></span>元</td>--%>
        <%--</tr>--%>
        <%--<tr>--%>
        <%--<td>交易成功:</td>--%>
        <%--<td>订单金额:<span id="orderPrice_D2"></span>元</td>--%>
        <%--<td>实际支付:<span id="realPrice_D2"></span>元</td>--%>
        <%--<td>支付宝:<span id="aliPay_D2"></span>元</td>--%>
        <%--<td>微信:<span id="wechatPay_D2"></span>元</td>--%>
        <%--<td>红包:<span id="redPay_D2"></span>元</td>--%>
        <%--</tr>--%>
    </table>

    <%--付款成功:--%>
    <%--订单金额:<span id="orderPrice_D"></span>元&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;--%>
    <%--实际支付:<span id="realPrice_D"></span>元&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;--%>
    <%--支付宝:<span id="aliPay_D"></span>元&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;--%>
    <%--微信:<span id="wechatPay_D"></span>元&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;--%>
    <%--红包:<span id="redPay_D"></span>元--%>

    <%--<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;--%>
    <%--已退款:--%>
    <%--订单金额:<span id="orderPrice_D1"></span>元&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;--%>
    <%--实际支付:<span id="realPrice_D1"></span>元&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;--%>
    <%--支付宝:<span id="aliPay_D1"></span>元&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;--%>
    <%--微信:<span id="wechatPay_D1"></span>元&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;--%>
    <%--红包:<span id="redPay_D1"></span>元--%>

    <%--<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;--%>
    <%--交易成功:--%>
    <%--订单金额:<span id="orderPrice_D2"></span>元&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;--%>
    <%--实际支付:<span id="realPrice_D2"></span>元&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;--%>
    <%--支付宝:<span id="aliPay_D2"></span>元&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;--%>
    <%--微信:<span id="wechatPay_D2"></span>元&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;--%>
    <%--红包:<span id="redPay_D2"></span>元--%>

    <br><br>
    <div id="container_data_Body_2" style="height: 500px;overflow-y:auto;">
        <center>
            <table border="1" id="dataBody_D" width="95%">
                <thead>
                <th>编号</th>
                <th>商家昵称</th>

                <th>订单金额A(B+E)</th>
                <th>实际付款B(C+D)</th>

                <th>支付宝支付C</th>
                <th>支付宝退款</th>

                <th>微信支付D</th>
                <th>微信退款</th>

                <th>钱包支付E</th>
                <th>钱包退款</th>

                <th>退款金额F</th>
                <%--<th>净流水G(A-F)</th>--%>
                <th>当时余额</th>
                <th>现在余额</th>

                </thead>
                <tbody></tbody>
            </table>
            <br><br>
            the end...
        </center>
    </div>
</div>

</body>

<script type="text/javascript">
    $(function () {

    });

    function getAllMerchantDetail() {
        var startDate = $("#startDate_YY").val();
        var start_H = $("#start_HH").val();
        var start_M = $("#start_MM").val();
        var start_S = $("#start_SS").val();

        var endDate = $("#endDate_YY").val();
        var end_H = $("#end_HH").val();
        var end_M = $("#end_MM").val();
        var end_S = $("#end_SS").val();

        var start_time = startDate+" "+start_H+":"+start_M+":"+start_S;
        var end_time = endDate+" "+end_H+":"+end_M+":"+end_S;


        $.post("${basePath}v2/Merchant72/getAllMerchantCollect.do",{"start_time":start_time,"end_time":end_time},function (data) {
            data = JSON.parse(data)


            $("#startTimeStr_D").text(data.startTime_str);
            $("#endTimeStr_D").text(data.endTime_str);

            if(data.statusCode ==  200){
                $("#errorMsg_D").text("");

                $("#orderPrice_all_merchant").text(data.orderPrice_all/100);
                $("#realPrice_all_merchant").text(data.realPrice_all/100);
                $("#aliPay_all_merchant").text(data.aliPay_all/100);
                $("#wechatPay_all_merchant").text(data.wechatPay_all/100);
                $("#redPay_all_merchant").text(data.redPay_all/100);

                $("#orderPrice_refund_allmerchant").text(data.orderPrice_refund/100);
                $("#aliPay_all_refund_allmerchant").text(data.aliPay_all_refund/100);
                $("#wechatPay_all_refund_allmerchant").text(data.wechatPay_all_refund/100);
                $("#otherPay_all_refund_allmerchant").text(data.otherPay_all_refund/100);

                // 移除表格数据
                $("#dataBody_D tbody tr").remove();

                var dataBody = data.data;

                for(var i=0;  i<dataBody.length;  i++){
                    $tr = $("<tr><td>"+dataBody[i].bianhao+"</td><td>"+dataBody[i].nickName+"</td><td>"+dataBody[i].orderPrice/100+"</td><td>"+dataBody[i].realPrice/100+"</td><td>"+dataBody[i].aliPay/100+"</td><td>"+dataBody[i].alipay_refund_price/100+"</td><td>"+dataBody[i].wechatPay/100+"</td><td>"+dataBody[i].wechat_refund_price/100+"</td><td>"+dataBody[i].redPay/100+"</td><td>"+dataBody[i].otherPay_refund_price/100+"</td><td>"+dataBody[i].all_refund_price/100+"</td> <td>"+dataBody[i].then_merchant_balance+"</td><td>"+dataBody[i].merchantBalance+"</td></tr>");
                    $("#dataBody_D").append($tr);
                }
            }else {
                $("#errorMsg_D").text(data.message);
            }
        });

        <%--$.post("${basePath}v2/Merchant72/getAllMerchantCollect_huizhong.do",{"start_time":start_time,"end_time":end_time},function (data) {--%>
        <%--data = JSON.parse(data)--%>

        <%--if(data.statusCode ==  200){--%>
        <%--$("#errorMsg_D").text("");--%>



        <%--$("#orderPrice_D").text(data.orderPrice/100);--%>
        <%--$("#realPrice_D").text(data.realPrice/100);--%>
        <%--$("#aliPay_D").text(data.aliPay/100);--%>
        <%--$("#wechatPay_D").text(data.wechatPay/100);--%>
        <%--$("#redPay_D").text(data.redPay/100);--%>

        <%--$("#orderPrice_D1").text(data.orderPrice_D1/100);--%>
        <%--$("#realPrice_D1").text(data.realPrice_D1/100);--%>
        <%--$("#aliPay_D1").text(data.aliPay_D1/100);--%>
        <%--$("#wechatPay_D1").text(data.wechatPay_D1/100);--%>
        <%--$("#redPay_D1").text(data.redPay_D1/100);--%>

        <%--$("#orderPrice_D2").text(data.orderPrice_D2/100);--%>
        <%--$("#realPrice_D2").text(data.realPrice_D2/100);--%>
        <%--$("#aliPay_D2").text(data.aliPay_D2/100);--%>
        <%--$("#wechatPay_D2").text(data.wechatPay_D2/100);--%>
        <%--$("#redPay_D2").text(data.redPay_D2/100);--%>

        <%--}else {--%>
        <%--$("#errorMsg_D").text(data.message);--%>
        <%--}--%>
        <%--});--%>
    }
</script>


<script type="text/javascript">

    obj = $("#startTimeStr_D");  // 获取到 上面"主体"哪一个元素
    h = obj.height();  //元素高度

    //            obj.offset().top;  //元素距离顶部高度

    wh = $(window).height();//浏览器窗口高度
    $(document).scrollTop();//滚动条高度

    xh=wh-(h+obj.offset().top-$(document).scrollTop());//元素到浏览器底部的高度

    // 设置表格的高度
    $("#container_data_Body_2").attr("style","height: "+(xh-100)+"px;overflow-y:auto;")
</script>

</html>
