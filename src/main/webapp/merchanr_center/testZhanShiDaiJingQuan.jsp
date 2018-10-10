<%--
  Created by IntelliJ IDEA.
  User: Administrator
  Date: 2018\4\16 0016
  Time: 17:26
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
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

    一进来对所有代金券进行遍历 <br><br>


    店名 和 店的地址   假的五星标志    <br><br>

    图片?!(加字段)   代金券名 : <span>老火锅</span> <br><br>

    总数量  剩余数量  已发出和总数量的百分比 <br><br>

    面额: <span>10</span> 使用条件  <span>满100减少10</span> <br><br>

    马上抢的按钮  <br><br>

    隐藏的属性代金券id.. <br><br>



    <br><br><br><br><br>

    点击马上抢展示出来的数据<br><br>


    店家名<br><br>
    有效时间<br> 面额 <br>

    满x减y <br><br>

    使用规划 后期加上去 <br><br>
    立即领取: 状态等判断  用户代金券+1  商家-1


    <script type="text/javascript">

        $.post("${basePath}/qier/orderReportContent/getAllVoucherData.do",function (data) {
            data = JSON.parse(data);
        });


    </script>


    </body>
</html>
