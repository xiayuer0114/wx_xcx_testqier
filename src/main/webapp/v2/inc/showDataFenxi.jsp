<%--
  Created by IntelliJ IDEA.
  User: sunM
  Date: 2018\7\5 0005
  Time: 13:45
  To change this template use File | Settings | File Templates.
--%>

<%-- 孙M  7.5  流水数据分析   --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<html>
<head>
    <title>数据分析</title>
    <!-- 数据分析 -->
</head>
<body>

    <br>
    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;

    开始:&nbsp;
    <input  type="text" id="liushui_startData" style="width: 80px;" readonly="readonly"  class="form-control date" datefmt="yyyy-MM-dd" >

    &nbsp;&nbsp; ---至--- &nbsp;&nbsp;

    结束:
    <input  type="text" id="liushui_endData" style="width: 80px;" readonly="readonly"  class="form-control date" datefmt="yyyy-MM-dd" >

    <button onclick="getliushuiDataByData();">查询</button>

    <br><br>

    <div>
        <center>
            <table id="liushui_data" border="1" style="width: 95%">

                <thead>
                    <th>时间</th>
                    <th>流水</th>

                    <th>订单金额</th>
                    <th>总笔数</th>

                    <th>支付宝</th>
                    <th>支付宝笔数</th>

                    <th>微信</th>
                    <th>微信笔数</th>

                    <th>红包</th>
                    <th>红包笔数</th>

                </thead>

                <tbody></tbody>
            </table>

            <br><br>
            the end...

        </center>
    </div>
</body>

<script type="text/javascript">

    // 查询按钮
    function getliushuiDataByData() {

        var liushui_startData = $("#liushui_startData").val();
        var liushui_endData = $("#liushui_endData").val();

        var startTime = liushui_startData+" 00:00:00";
        var endTime = liushui_endData+" 00:00:00";

        data(startTime,endTime);
    }

    // 组装数据
    function data(startTime,endTime) {
        $.post("${basePath}qier/cashier/showDayLiuShuiView.do",{"startTime":startTime,"endTime":endTime},function (msg) {
            msg = JSON.parse(msg);

            var data = msg.data;

            if(msg.statusCode == 200){
                $("#liushui_data tbody tr").remove();

                for (var i=0; i<data.length; i++){
                    $tr = $(" <tr style='height: 50px'> " +
                        "<td>"+data[i].date+"</td>" +
                        "<td>"+data[i].price_all/100 +"</td> " +
                        "<td>"+data[i].mao_price_all/100 +"</td> " +
                        "<td>"+data[i].price_all_count +"</td> " +
                        "<td>"+data[i].price_all_alipay/100 +"</td> " +
                        "<td>"+data[i].price_all_alipay_count +"</td> " +
                        "<td>"+data[i].price_all_wechatpay/100 +"</td> " +
                        "<td>"+data[i].price_all_wechatpay_count +"</td> " +
                        "<td>"+data[i].price_all_redpay/100 +"</td> " +
                        "<td>"+data[i].price_all_redpay_count +"</td> " +
                        "</tr> ");

                    $("#liushui_data").append($tr);
                }
            }
        });
    }



    $(function () {
        data(null,null);
    });

</script>


</html>
