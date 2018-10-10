<%@ page import="com.lymava.qier.activities.model.Daka" %>
<%@ page import="com.lymava.commons.util.*" %>
<%@ page import="com.lymava.nosql.util.QuerySort" %>
<%@ page import="com.lymava.trade.pay.model.PaymentRecord" %>
<%@ page import="com.lymava.trade.pay.model.PaymentRecordOperationRecord" %>
<%@ page import="com.lymava.trade.base.model.BusinessIntIdConfig" %>
<%@ page import="com.lymava.commons.state.State" %>
<%@ page import="com.lymava.trade.base.model.Business" %>
<%@ page import="com.lymava.qier.activities.model.Tanmiguan" %><%--
  Created by IntelliJ IDEA.
  User: sunM
  Date: 2018\7\3 0003
  Time: 14:33
  To change this template use File | Settings | File Templates.
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ include file="../../header/check_openid.jsp"%>
<%@ include file="../../header/header_check_login.jsp"%>

<%

    // 现在的时间
    Long nowTime = System.currentTimeMillis();

    Tanmiguan tanmiguan_find = new Tanmiguan();
    tanmiguan_find.setOpenId(openid_header);
    tanmiguan_find.setState(Tanmiguan.state_ok);

    Tanmiguan tanmiguan = (Tanmiguan)ContextUtil.getSerializContext().get(tanmiguan_find);

    if(tanmiguan == null){

        tanmiguan_find.setLingquTime(nowTime);
        ContextUtil.getSerializContext().save(tanmiguan_find);

        Long jine = 588L;

        Long yue_balance = 0L;
        if(user.getBalance() != null){
            yue_balance =  user.getBalance();
        }

        PaymentRecord wallet_amount_paymentRecord  = new PaymentRecordOperationRecord();

        wallet_amount_paymentRecord.setId(new ObjectId().toString());
        wallet_amount_paymentRecord.setBusinessIntId(33320);
        wallet_amount_paymentRecord.setPay_method(PayFinalVariable.pay_method_balance);
        wallet_amount_paymentRecord.setPrice_fen_all(jine);
        wallet_amount_paymentRecord.setUserId_huiyuan(user.getId());
        wallet_amount_paymentRecord.setState(State.STATE_PAY_SUCCESS);
        wallet_amount_paymentRecord.setRequestFlow(new ObjectId().toString());
        wallet_amount_paymentRecord.setWallet_amount_balance_pianyi(jine*(User.pianyiFen/100L)+yue_balance);;
        wallet_amount_paymentRecord.setMemo("探店体验官发福利");

        // 保存这次业务交易
        serializContext.save(wallet_amount_paymentRecord);
        Business.checkRequestFlow(wallet_amount_paymentRecord);

        // 用户余额变动
        user.balanceChangeFen(jine);
    }

%>

<html>
<head>
    <link rel="stylesheet" type="text/css" href="css/date_2.css"/>
</head>
    <div class="date1_2">
        <img src="img/body.png"/>
    </div>
</html>

