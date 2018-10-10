<%@ page import="com.lymava.commons.state.State" %><%--
  Created by IntelliJ IDEA.
  User: Administrator
  Date: 2018\5\3 0003
  Time: 10:18
  To change this template use File | Settings | File Templates.
--%>

<%-- 孙M  5.3  财务数据展示页面  每个商家消费的详情 --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<html>
<head>
    <title>每个商家消费的详情</title>
</head>
<body>
    <br>
    <div>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
        开始:&nbsp;
        <input  type="text" id="startDate" style="width: 80px;" readonly="readonly"  class="form-control date" datefmt="yyyy-MM-dd" >
        年
        <input  type="text" id="start_H" value="00" style="width: 20px">
        点
        <input  type="text" id="start_M" value="00" style="width: 20px">
        分
        <input  type="text" id="start_S" value="00" style="width: 20px">
        秒
        &nbsp;&nbsp; ---至--- &nbsp;&nbsp;
        结束:
        <input  type="text" id="endDate" style="width: 80px;" readonly="readonly"  class="form-control date" datefmt="yyyy-MM-dd" >
        年
        <input  type="text" id="end_H" value="00" style="width: 20px">
        点
        <input  type="text" id="end_M" value="00" style="width: 20px">
        分
        <input  type="text" id="end_S" value="00" style="width: 20px">
        秒

        <br><br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
        商家:&nbsp;
        <select id="merchantList" name="merchantList">
            <option value="" selected>全部商家</option>
        </select>

        <br><br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
        状态;&nbsp;
        <select id="payState">
            <option value="">全部状态</option>
            <option value="<%= State.STATE_PAY_SUCCESS%>" selected>付款成功</option>
            <option value="<%= State.STATE_FALSE%>">付款失败</option>
            <option value="<%= State.STATE_WAITE_PAY%>">等待付款</option>
            <option value="<%= State.STATE_REFUND_OK%>">已退款</option>
        </select>

        <br><br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;

        <button onclick="getDetail();">查询</button>



        <br> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
        <font color="red"><span id="errorMsg"></span></font>

        <br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;

        主体: <b><span id="startTimeStr"></span> ---至--- <span id="endTimeStr"></span>&nbsp;&nbsp;&nbsp;
        <span id="nickName"></span>&nbsp;<span id="showPayState"></span>&nbsp;的订单详情</b>

        <br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
        收益: 订单金额:<span id="orderPrice"></span>元&nbsp;&nbsp;&nbsp;
            实际支付:<span id="realPrice"></span>元&nbsp;&nbsp;&nbsp;
            支付宝:<span id="aliPay"></span>元&nbsp;&nbsp;&nbsp;
            微信:<span id="wechatPay"></span>元&nbsp;&nbsp;&nbsp;
            红包:<span id="redPay"></span>元

        <br><br>
        <%--<div style="height: 510px;overflow-y:auto;">--%>
        <div id="container_data_Body" style="height: 200px;overflow-y:auto;">
            <center>
                <table border="1" id="dataBody" width="95%">
                    <thead>
                        <th>流水号</th><th>创建时间</th><th>订单金额</th><th>支付方式</th><th>实际支付</th><th>钱包支付</th>
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
        // 获取商家列表
        $.post("${basePath}v2/Merchant72/getMerchantList.do",{},function (data) {
            data = JSON.parse(data);

            if (data.statusCode == 200 ){
                var listM = data.data;

                for (var i = 0;  i < listM.length; i++ ){
                    $op = $("<option value='"+listM[i].merchantId+"'>"+listM[i].nickName+"</option>")
                    $("#merchantList").append($op);
                }
            }else{
                alert(data.message)
            }
        });
    });

    var start_time;
    var end_time;
    var merchantId;
    var payState;



    function getDetail() {
        var startDate = $("#startDate").val();
        var start_H = $("#start_H").val();
        var start_M = $("#start_M").val();
        var start_S = $("#start_S").val();

        var endDate = $("#endDate").val();
        var end_H = $("#end_H").val();
        var end_M = $("#end_M").val();
        var end_S = $("#end_S").val();

        start_time = startDate+" "+start_H+":"+start_M+":"+start_S;
        end_time = endDate+" "+end_H+":"+end_M+":"+end_S;
        merchantId = $("#merchantList").val();
        payState = $("#payState").val();

        $("#dataBody tbody tr").remove();
        loadDataBody();
    }



    function loadDataBody() {
        var requestData = {
            "startTime":start_time,
            "endTime":end_time,
            "merchantId":merchantId,
            "payState":payState,
        };

        $.post("${basePath}v2/Merchant72/getTradeRecord72Detail.do",requestData,function (data) {
            data = JSON.parse(data);

            if(data.statusCode == 200){
                $("#errorMsg").text("");

                $("#startTimeStr").text(data.startTime_str);
                $("#endTimeStr").text(data.endTime_str);
                $("#nickName").text(data.nickName);
                $("#showPayState").text(data.showPayState);

                $("#orderPrice").text(data.orderPrice/100)
                $("#realPrice").text(data.realPrice/100)
                $("#aliPay").text(data.aliPay/100)
                $("#wechatPay").text(data.wechatPay/100)
                $("#redPay").text(data.redPay/100)

                var data = data.data;
                for (var i=0; i<data.length; i++){
                    $tr = $("<tr><td>"+data[i].payFlow+"</td><td>"+data[i].orderTime+"</td><td>"+data[i].order_price/100+"</td><td>"+data[i].payMethod+"</td><td>"+data[i].real_pay/100+"</td><td>"+data[i].wallet_pay/100+"</td></tr>");
                    $("#dataBody").append($tr);
                }
            }else{
                $("#errorMsg").text(data.message);
            }
        });
    }

</script>

<script type="text/javascript">

    obj = $("#startTimeStr");  // 获取到 上面"主体"哪一个元素
    h = obj.height();  //元素高度

    //            obj.offset().top;  //元素距离顶部高度

    wh = $(window).height();//浏览器窗口高度
    $(document).scrollTop();//滚动条高度

    xh=wh-(h+obj.offset().top-$(document).scrollTop());//元素到浏览器底部的高度

    // 设置表格的高度
    $("#container_data_Body").attr("style","height: "+(xh-220)+"px;overflow-y:auto;")
</script>



</html>
