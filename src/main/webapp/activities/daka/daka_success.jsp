<%@ page import="com.lymava.qier.activities.model.Daka" %>
<%@ page import="com.lymava.commons.util.*" %>
<%@ page import="com.lymava.trade.pay.model.PaymentRecordOperationRecord" %>
<%@ page import="com.lymava.trade.base.model.BusinessIntIdConfig" %>
<%@ page import="com.lymava.commons.state.State" %>
<%@ page import="com.lymava.trade.base.model.Business" %>
<%@ page import="com.lymava.trade.pay.model.PaymentRecord" %>
<%@ page import="com.lymava.nosql.util.QuerySort" %>
<%--
  Created by IntelliJ IDEA.
  User: sunM
  Date: 2018\7\3 0003
  Time: 16:46
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ include file="../../header/check_openid.jsp"%>
<%@ include file="../../header/header_check_login.jsp"%>

<%

    // 现在的时间
    Long nowTime = System.currentTimeMillis();

    // 今天开始的时间
    Long nowStartTime = DateUtil.getDayStartTime(nowTime);

    // 参数获取 & 检测
    String tianshu = request.getParameter("tianshu");
    Integer lianxu = MathUtil.parseIntegerNull(tianshu);

    if(lianxu == null || lianxu<1 || lianxu>7){
        // 请求这个页面 参数不正确
        return;
    }

    // 连续打卡判断  非法参数判断
    Daka daka_find = new Daka();
    daka_find.setOpenId(openid_header);
    daka_find.setState(Daka.state_ok);
    daka_find.initQuerySort("dakaTime", QuerySort.desc);

    if (serializContext.findAll(daka_find).size() == 7){
        // 完成了七次打卡
        return;
    }

    daka_find = (Daka) ContextUtil.getSerializContext().findOneInlist(daka_find);

    if(daka_find == null && !lianxu.equals(1)){
        // 打卡记录为空,  却不是从第一天开始打卡
        return;
    }

    if (daka_find != null && nowStartTime.equals(daka_find.getDakaStartTime())){
        // 最后一次打卡记录不为空,  但是 最后一次打卡时间和今天相同
        return;
    }

    if(daka_find != null && !lianxu.equals(1)){
        if(daka_find.getLianxuMark() == null){
            // 打卡记录不为空, 却没有连续打卡的标记
            return;
        }
        if( daka_find.getLianxuMark().equals(lianxu) ){
            // 打卡和连续标记相等
            return;
        }
        if( !daka_find.getLianxuMark().equals( (lianxu-1) ) ){
            // 打卡和连续打卡 相差不差一天
            return;
        }
        if( !nowStartTime.equals( (daka_find.getDakaStartTime()+DateUtil.one_day) )){
            // 这次请求的时间和最后一次请求的时间相差不是一天
            return;
        }
    }


    // 打卡 数据添加
    Daka daka_add = new Daka();

    String id = new ObjectId().toString();
    daka_add.setId(id);
    daka_add.setOpenId(openid_header);
    daka_add.setDakaTime(nowTime);
    daka_add.setDakaStartTime(nowStartTime);
    daka_add.setLianxuMark(lianxu);
    daka_add.setState(Daka.state_ok);

    Long jiangli = 5L;
    // 连续打卡 超过4天
    if(lianxu>4){ jiangli = 10L; }

    daka_add.setInJiangLi(jiangli);

    // 保存这次操作记录
    ContextUtil.getSerializContext().save(daka_add);

    Long yue_balance = 0L;
    if(user.getBalance() != null){
        yue_balance =  user.getBalance();
    }

    PaymentRecord wallet_amount_paymentRecord  = new PaymentRecordOperationRecord();

    wallet_amount_paymentRecord.setId(new ObjectId().toString());
//    wallet_amount_paymentRecord.setBusinessIntId(BusinessIntIdConfig.businessIntId_pay);
    wallet_amount_paymentRecord.setBusinessIntId(33310);
    wallet_amount_paymentRecord.setPay_method(PayFinalVariable.pay_method_balance);
    wallet_amount_paymentRecord.setPrice_fen_all(jiangli*Daka.pianyi);
    wallet_amount_paymentRecord.setUserId_huiyuan(user.getId());
    wallet_amount_paymentRecord.setState(State.STATE_PAY_SUCCESS);
    wallet_amount_paymentRecord.setRequestFlow(id);
    wallet_amount_paymentRecord.setWallet_amount_balance_pianyi(jiangli*User.pianyiFen+yue_balance);
    wallet_amount_paymentRecord.setMemo("七日打卡");

    // 保存这次业务交易
    serializContext.save(wallet_amount_paymentRecord);
    Business.checkRequestFlow(wallet_amount_paymentRecord);

    // 用户余额变动
    user.balanceChangeFen(jiangli*Daka.pianyi);

%>

