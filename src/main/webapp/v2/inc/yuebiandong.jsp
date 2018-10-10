<%--
  Created by IntelliJ IDEA.
  User: Administrator
  Date: 2018\6\13 0013
  Time: 17:28
  To change this template use File | Settings | File Templates.
--%>

<%-- 孙M  6.13  商家的预付款信息 --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<html>
<head>
    <title>merchant imprest</title>
</head>
<body>

<div>
    <br>
    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
    开始:&nbsp;
    <input type="text" id="startDate_BB" style="width: 80px;" readonly="readonly" class="form-control date"
           datefmt="yyyy-MM-dd">
    &nbsp;&nbsp; ---至--- &nbsp;&nbsp;
    结束:
    <input type="text" id="endDate_BB" style="width: 80px;" readonly="readonly" class="form-control date"
           datefmt="yyyy-MM-dd">

    &nbsp;&nbsp;
    <button onclick="getAllMerchantBalanceDetail();">查询</button>

    &nbsp;&nbsp;开始时间请大于2018年5月6号&nbsp;&nbsp;&nbsp;&nbsp;

    预警显示:
    <select id="redInfo">
        <option value="0.1">10%</option>
        <option value="0.2" selected>20%</option>
        <option value="0.3">30%</option>
        <option value="0.4">40%</option>
        <option value="0.5">50%</option>
    </select>

    <br> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;

    <%--错误信息提示--%>
    <font color="red"><span id="errorMsg_BB"></span></font>

    <br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;

    主体: <b><span id="startTimeStr_BB"></span> ---至--- <span id="endTimeStr_BB"></span></b>
    <br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
    在此时间段内,向商家实际打款 <span id="topUpBalance"></span>元, 充值 <span id="count"></span>元, 折扣 <span id="discount"></span>元
    <br><br>
    <div id="container_data_Body_1" style="height: 200px;overflow-y:auto;">
        <center>
            <table border="1" id="dataBody_BB" width="95%">
                <thead>
                </thead>
                <tbody>
                <td>编号</td>
                <td>商家昵称</td>
                <td>用户名</td>
                <td>当前余额</td>
                <td>打款总额</td>
                <td>最后一次预付款</td>

                </tbody>
            </table>
            <br><br>
            the end...
        </center>
    </div>
</div>

</body>

<script type="text/javascript">

    function getOneMerchantBalanceDetail(merchantId) {
        var startTime = $("#startDate_BB").val();
        var endTime = $("#endDate_BB").val();


        var requestData = {
            "merchantId": merchantId,
            "startTime_str": startTime,
            "endTime_str": endTime
        };

        $.post("${basePath}v2/Merchant72/getMerchantBalanceChangById.do", requestData, function (data) {

            layer.open({
                type: 1,
                area: ['60%', '60%'],
                shadeClose: true, //点击遮罩关闭
                content: data
            });

        });
    }

    function getAllMerchantBalanceDetail(){

        var startTime = $("#startDate_BB").val();
        var endTime = $("#endDate_BB").val();
        startTime = startTime+" 00:00:00";
        endTime = endTime+" 00:00:00";

        loadMerchantYufukuanByTime(startTime,endTime);
    }


    $(function () {

        // 根据时间加载商家的预付款
        loadMerchantYufukuanByTime(null, null);

        $("#redInfo").change(function () {

            var startTime = $("#startDate_BB").val();
            var endTime = $("#endDate_BB").val();
            if(endTime != null && endTime!="" && startTime != null && startTime!="" ){
                startTime = startTime + " 00:00:00";
                endTime = endTime + " 00:00:00";
            }

            loadMerchantYufukuanByTime(startTime, endTime);
        });

    });



    function loadMerchantYufukuanByTime(startTime, endTime) {

        requestUrl = "${basePath}v2/Merchant72/getAllMerchantBalanceByTime.do";

        requsetData = {
            "startTime_str": startTime,
            "endTime_str": endTime
        }

        $.post(requestUrl, requsetData, function (data) {
            data = JSON.parse(data);

            if (data.statusCode != 200) {
                $("#errorMsg_BB").text(data.message);
                return;
            }

            $("#errorMsg_BB").text("");  // 清除错误提示

            $("#startTimeStr_BB").text(data.startTimeStr);  // 主体时间_开始
            $("#endTimeStr_BB").text(data.endTimeStr);      // 主体时间_结束

            $("#topUpBalance").text(data.topUpBalance / 100);  // 实际打款
            $("#count").text(data.count / 100);        //预付款
            $("#discount").text(data.discount / 100); // 折扣额

            // 预警比列
            var redInfo = $("#redInfo").val();

            $("#dataBody_BB tbody tr").eq(0).nextAll().remove();

            var dataBody = data.data;
            for (var i = 0; i < dataBody.length; i++) {

                var styleTR = "";
                var styleTR_height = "height: 50px;";

                if (dataBody[i].balance < (dataBody[i].lastYufukuan/100 * redInfo)) {
                    var styleTR_bgColor = "background-color: #ff0000;";
                    styleTR = styleTR_height + styleTR_bgColor;
                } else {
                    styleTR = styleTR_height;
                }

                $tr = $("<tr style='" + styleTR + "'><td onclick=getOneMerchantBalanceDetail('" + dataBody[i].id + "');>" + dataBody[i].bianhao + "</td><td>" + dataBody[i].nickName + "</td><td>" + dataBody[i].userName + "</td><td>" + dataBody[i].balance + "</td> <td>" + dataBody[i].all_dakuan / 100 + "</td><td>" + dataBody[i].lastYufukuan / 100 + "</td> </tr>");

                $("#dataBody_BB").append($tr);
            }

        });
    }



</script>


<script type="text/javascript">

    obj = $("#startTimeStr_BB");  // 获取到 上面"主体"哪一个元素
    h = obj.height();  //元素高度

    //            obj.offset().top;  //元素距离顶部高度

    wh = $(window).height();//浏览器窗口高度
    $(document).scrollTop();//滚动条高度

    xh = wh - (h + obj.offset().top - $(document).scrollTop());//元素到浏览器底部的高度

    // 设置表格的高度
    $("#container_data_Body_1").attr("style", "height: " + (xh - 100) + "px;overflow-y:auto;")
</script>

</html>
