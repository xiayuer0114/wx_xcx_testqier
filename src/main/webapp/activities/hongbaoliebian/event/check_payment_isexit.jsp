<%@ page import="com.lymava.nosql.context.SerializContext" %>
<%@ page import="com.lymava.base.util.ContextUtil" %>
<%@ page import="com.lymava.commons.exception.CheckException" %>
<%@ page import="com.lymava.commons.util.MyUtil" %>
<%@ page import="com.lymava.qier.activities.hongbaoliebian.HongbaoliebianPaymentRecord" %>
<%@ page import="com.google.gson.JsonObject" %>
<%@ page import="com.lymava.commons.state.StatusCode" %>
<%@ page import="com.lymava.commons.state.State" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="utf-8" %>
<%
    SerializContext serializContext = ContextUtil.getSerializContext();

    String sou_paymentRecord_id = request.getParameter("paymentRecord_id");
    CheckException.checkIsTure(MyUtil.isValid(sou_paymentRecord_id), "订单id不正确");

    // 检测订单的是不是另外一笔订单的'原订单'

    HongbaoliebianPaymentRecord hongbaoliebianPaymentRecord = new HongbaoliebianPaymentRecord();
    hongbaoliebianPaymentRecord.setSourceRecord_id(sou_paymentRecord_id);
    hongbaoliebianPaymentRecord.setState(State.STATE_PAY_SUCCESS); //支付成功
    hongbaoliebianPaymentRecord = (HongbaoliebianPaymentRecord) serializContext.get(hongbaoliebianPaymentRecord);

    JsonObject jsonObject = new JsonObject();
    jsonObject.addProperty("message","success");
    jsonObject.addProperty("statusCode", StatusCode.ACCEPT_GUAQI);
    jsonObject.addProperty("paymentRecord_id", sou_paymentRecord_id);
    if(hongbaoliebianPaymentRecord != null ){
        jsonObject.addProperty("statusCode", StatusCode.ACCEPT_OK);
        jsonObject.addProperty("paymentRecord_id", hongbaoliebianPaymentRecord.getId());
    }

    out.print(jsonObject);
%>