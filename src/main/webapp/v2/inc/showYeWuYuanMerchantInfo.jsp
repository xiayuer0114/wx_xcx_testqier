<%@ page import="com.lymava.base.safecontroler.model.UserV2" %>
<%@ page import="com.lymava.base.util.FinalVariable" %>
<%@ page import="com.lymava.base.safecontroler.model.UserRole" %>
<%@ page import="static com.lymava.base.model.UserGroup.STATE_OK" %>
<%@ page import="com.lymava.base.util.ContextUtil" %>
<%@ page import="com.lymava.qier.model.Merchant72" %>
<%@ page import="com.lymava.commons.util.MyUtil" %>
<%@ page import="java.util.List" %>
<%@ page import="com.lymava.qier.action.CashierAction" %>
<%@ page import="com.lymava.base.model.User" %>
<%@ page import="com.lymava.nosql.mongodb.vo.BaseModel" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="com.lymava.qier.model.TradeRecord72" %>
<%@ page import="com.lymava.trade.base.model.BusinessIntIdConfig" %>
<%@ page import="com.lymava.nosql.mongodb.util.MongoCommand" %>
<%@ page import="com.lymava.commons.state.State" %>
<%@ page import="com.lymava.qier.util.SunmingUtil" %>
<%@ page import="com.google.gson.JsonObject" %>
<%@ page import="java.util.Map" %>
<%@ page import="com.lymava.qier.model.BalanceLog72" %>
<%@ page import="com.lymava.qier.model.User72" %>
<%@ page import="com.lymava.commons.util.DateUtil" %>
<%@ page import="com.google.gson.JsonArray" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>
  Created by IntelliJ IDEA.
  User: sunM
  Date: 2018\7\5 0005
  Time: 13:45
  To change this template use File | Settings | File Templates.
--%>

<%-- 孙M  7.5  流水数据分析   --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
    SimpleDateFormat simpleDateFormat =  DateUtil.getSdfShort();

    // 今天开始的时间
    Long day_startTime = DateUtil.getDayStartTime();

    // 今天结束的时间
    Long day_endTime = day_startTime + DateUtil.one_day;

    // 显示几天的信息
    Integer tianshu = 15;


    // 登录者信息
    UserV2 userV2 = (UserV2) request.getAttribute(FinalVariable.SESSION_LOGINUSER);

    Merchant72 merchant72_find = new Merchant72();
    merchant72_find.setUserGroupId(CashierAction.getMerchantUserGroutId());
    merchant72_find.setUserv2_yewuyuan_id(userV2.getId());


    Iterator<Merchant72> merchant72Iterator = ContextUtil.getSerializContext().findIterable(merchant72_find);

    JsonArray jsonArray_all = new JsonArray();

    while (merchant72Iterator.hasNext()){
        Merchant72 merchant72_out = merchant72Iterator.next();

        TradeRecord72 tradeRecord72_find = new TradeRecord72();

        tradeRecord72_find.setUserId_merchant(merchant72_out.getId());
        tradeRecord72_find.setBusinessIntId(BusinessIntIdConfig.businessIntId_trade);
        tradeRecord72_find.addCommand(MongoCommand.in, "state", State.STATE_PAY_SUCCESS);	// 付款成功
        tradeRecord72_find.addCommand(MongoCommand.in, "state", State.STATE_OK);			// 交易成功
        tradeRecord72_find.addCommand(MongoCommand.in, "state", State.STATE_REFUND_OK);	// 已退款

        JsonArray jsonArray = new JsonArray();

        JsonObject jsonObject_merchant = new JsonObject();
        jsonObject_merchant.addProperty("time",merchant72_out.getNickname());
        jsonObject_merchant.addProperty("price",0);
        jsonArray.add(jsonObject_merchant);

        Long endTime = day_endTime;
        Integer tinshu_temp = tianshu;

        while (tinshu_temp > 0){

            Long startTime = endTime-DateUtil.one_day;

            tradeRecord72_find = (TradeRecord72) SunmingUtil.setQueryWhere_time(tradeRecord72_find, startTime, endTime);

            Long orderPrice = 0L;
            Iterator<TradeRecord72> tradeRecord72List = ContextUtil.getSerializContext().findIterable(tradeRecord72_find);

            while (tradeRecord72List.hasNext()){
                TradeRecord72 tradeRecord72_out =  tradeRecord72List.next();
                orderPrice += Math.abs(tradeRecord72_out.getShowPrice_fen_all());
            }

            JsonObject jsonObject = new JsonObject();
            jsonObject.addProperty("time",simpleDateFormat.format(new Date(endTime)));
            jsonObject.addProperty("price",orderPrice);

            jsonArray.add(jsonObject);

            tinshu_temp--;
            endTime -= DateUtil.one_day;
        }
        jsonArray_all.add(jsonArray);
    }

    request.setAttribute("merchant_yewuyuan",jsonArray_all);

%>

<html>
<head>
    <title>业务员对应商家流水信息</title>
</head>
<body>

<br><br><br>

<center>
    <table  border="1" id="table">

    </table>
</center>

</body>

<script type="text/javascript">

    var merchant_yewuyuan = ${merchant_yewuyuan};

    if(merchant_yewuyuan != null || merchant_yewuyuan!=""){

        for (var i= 0; i<merchant_yewuyuan.length; i++){
            var td = "";
            for (var j= 0; j<merchant_yewuyuan[i].length; j++){
                var data = merchant_yewuyuan[i][j];
                td += "<td>"+data.time+"</td><td>"+data.price/100+"</td><td width='10px'></td>";
            }
            $td = $(td);
            $tr =  $("<tr></tr>")

            $tr.append($td);
            $("#table").append($tr);
        }
    }


</script>


</html>
