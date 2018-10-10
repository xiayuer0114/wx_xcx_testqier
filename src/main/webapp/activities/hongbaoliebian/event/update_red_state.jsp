<%@ page import="com.lymava.nosql.context.SerializContext" %>
<%@ page import="com.lymava.base.util.ContextUtil" %>
<%@ page import="com.lymava.commons.exception.CheckException" %>
<%@ page import="com.lymava.commons.util.MyUtil" %>
<%@ page import="com.lymava.qier.activities.hongbaoliebian.HongbaoliebianPaymentRecord" %>
<%@ page import="com.lymava.qier.activities.model.ActivitieMerchantRedEnvelope" %>
<%@ page import="com.lymava.commons.state.State" %>
<%@ page import="com.google.gson.JsonObject" %>
<%@ page import="com.lymava.commons.state.StatusCode" %>
<%@ page import="com.lymava.qier.model.MerchantRedEnvelope" %>
<%@ page import="com.lymava.qier.model.User72" %>
<%@ page contentType="text/html; charset=UTF-8" language="java" pageEncoding="utf-8" %>

<%@ include file="../../../header/check_openid.jsp"%>
<%@ include file="../../../header/header_check_login.jsp"%>

<%
    //  修改活动红包的状态为'支付成功'  修改红包的所属用户为'当前支付用户'

    String payment_id =request.getParameter("payment_id");
    CheckException.checkIsTure(MyUtil.isValid(payment_id ), "订单id错误");

    HongbaoliebianPaymentRecord hongbaoliebianPaymentRecord = (HongbaoliebianPaymentRecord)serializContext.get(HongbaoliebianPaymentRecord.class, payment_id);
    CheckException.checkIsTure(hongbaoliebianPaymentRecord != null , "订单不存在");

    ActivitieMerchantRedEnvelope activitieMerchantRedEnvelope = hongbaoliebianPaymentRecord.getActivitie_redEnvelope();
    CheckException.checkIsTure(activitieMerchantRedEnvelope != null , "订单中没有活动红包");



    User72 user72 = new User72();
    user72.setThird_user_id(openid_header);
    user72 = (User72)serializContext.get(user72);
    CheckException.checkIsTure(user72 != null, "用户不存在");

    ActivitieMerchantRedEnvelope activitieMerchantRedEnvelope1_update = new ActivitieMerchantRedEnvelope();
    activitieMerchantRedEnvelope1_update.setState(State.STATE_PAY_SUCCESS);
    activitieMerchantRedEnvelope1_update.setUser72(user72);
    serializContext.updateObject(activitieMerchantRedEnvelope.getId(), activitieMerchantRedEnvelope1_update);

    MerchantRedEnvelope merchantRedEnvelope = activitieMerchantRedEnvelope.getMerchantRedEnvelope();
    MerchantRedEnvelope merchantRedEnvelope_update = new MerchantRedEnvelope();
    merchantRedEnvelope_update.setUser_huiyuan(user72);
    serializContext.updateObject(merchantRedEnvelope.getId(), merchantRedEnvelope_update);

    JsonObject jsonObject = new JsonObject();
    jsonObject.addProperty("statusCode", StatusCode.ACCEPT_OK);
    jsonObject.addProperty("message", "success");
    out.print(jsonObject);
%>