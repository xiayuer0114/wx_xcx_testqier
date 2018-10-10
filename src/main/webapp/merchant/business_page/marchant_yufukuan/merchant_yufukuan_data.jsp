<%@ page import="com.lymava.base.model.User" %>
<%@ page import="com.lymava.base.util.FinalVariable" %>
<%@ page import="com.lymava.commons.exception.CheckException" %>
<%@ page import="com.lymava.qier.model.TradeRecord72" %>
<%@ page import="com.lymava.commons.state.State" %>
<%@ page import="com.lymava.qier.business.BusinessIntIdConfigQier" %>
<%@ page import="com.lymava.nosql.util.PageSplit" %>
<%@ page import="java.util.List" %>
<%@ page import="com.lymava.base.util.ContextUtil" %>
<%@ page import="com.lymava.nosql.context.SerializContext" %>
<%@ page import="com.google.gson.JsonArray" %>
<%@ page import="com.google.gson.JsonObject" %>
<%@ page import="com.lymava.qier.cmbpay.model.TransferToMerchantRecord" %>
<%@ page import="com.lymava.commons.util.MyUtil" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    User user = (User) request.getAttribute(FinalVariable.SESSION_FRONT_FULL_USER);
    CheckException.checkIsTure(user != null, "请先登录！");
    SerializContext serializContext = ContextUtil.getSerializContext();

    String next = request.getParameter("next");

    PageSplit pageSplit = new PageSplit(1,10);

    if(MyUtil.isEmpty(next)){
        request.getSession().setAttribute("merchant_yufukuan_page", pageSplit.getPage());
    }else {
        Integer data_page = (Integer)request.getSession().getAttribute("merchant_yufukuan_page");
        data_page++;
        pageSplit.setPage(data_page);
        request.getSession().setAttribute("merchant_yufukuan_page", pageSplit.getPage());
    }

    TransferToMerchantRecord paymentRecord_find = new TransferToMerchantRecord();
    paymentRecord_find.setUserId_huiyuan(user.getId());
    paymentRecord_find.setBusinessIntId(BusinessIntIdConfigQier.businessIntId_manual_transfer_to_merchant);  // 业务订单
    paymentRecord_find.setState(State.STATE_PAY_SUCCESS);  //  支付成功

    List<TransferToMerchantRecord> tradeRecord72List = serializContext.findAll(paymentRecord_find, pageSplit);

    JsonArray jsonArray = new JsonArray();

    for (TransferToMerchantRecord tradeRecord72_tmp : tradeRecord72List){
        JsonObject jsonObject = new JsonObject();
        jsonObject.addProperty("orderId", tradeRecord72_tmp.getRequestFlow());
        jsonObject.addProperty("yufukuan_price", tradeRecord72_tmp.getYufukuan_price_fen()/100);
        jsonObject.addProperty("price_all", tradeRecord72_tmp.getPrice_fen_all()/100);
        jsonObject.addProperty("shoeTime", tradeRecord72_tmp.getShowTime());

        jsonArray.add(jsonObject);
    }
    out.print(jsonArray);
%>