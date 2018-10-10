<%@ page import="com.lymava.nosql.context.SerializContext" %>
<%@ page import="com.lymava.qier.model.BalanceLog72" %>
<%@ page import="com.lymava.base.util.ContextUtil" %>
<%@ page import="com.lymava.qier.action.Merchant72Action" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="com.lymava.qier.cmbpay.model.TransferToMerchantRecord" %>
<%@ page import="com.lymava.qier.business.BusinessIntIdConfigQier" %>
<%@ page import="com.lymava.commons.state.State" %>
<%@ page import="com.lymava.base.model.User" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="utf-8" %>

<%
    SerializContext serializContext= ContextUtil.getSerializContext();

    BalanceLog72 balanceLog72_find = new BalanceLog72();
    balanceLog72_find.setMemo(Merchant72Action.getBalanceLogMerchantMemo());

    Iterator<BalanceLog72> balanceLog72Iterator = serializContext.findIterable(balanceLog72_find);

    while (balanceLog72Iterator.hasNext()){
        BalanceLog72 balanceLog72_tmp = balanceLog72Iterator.next();

        TransferToMerchantRecord transferToMerchantRecord_add  = new TransferToMerchantRecord();

        transferToMerchantRecord_add.setBusinessIntId(BusinessIntIdConfigQier.businessIntId_manual_transfer_to_merchant);
        transferToMerchantRecord_add.setState(State.STATE_PAY_SUCCESS);
        transferToMerchantRecord_add.setId(balanceLog72_tmp.getId());
        transferToMerchantRecord_add.setUserV2Id(balanceLog72_tmp.getUserv2Id());
        transferToMerchantRecord_add.setUserId_huiyuan(balanceLog72_tmp.getUser_id());
        transferToMerchantRecord_add.setBack_memo("同步balance72的数据____"+balanceLog72_tmp.getBack_memo());
        transferToMerchantRecord_add.setPrice_pianyi_all(balanceLog72_tmp.getTopUpBalance());
        transferToMerchantRecord_add.setWallet_amount_balance_pianyi(balanceLog72_tmp.getBalance());
        transferToMerchantRecord_add.setRequestFlow(balanceLog72_tmp.getOrderId());

        Long discount = balanceLog72_tmp.getDiscount();
        if(discount == null){ discount = 0L; }
        transferToMerchantRecord_add.setYingxiao_price_fen(discount/ User.pianyiFen);

        Long count = balanceLog72_tmp.getCount();
        if(count == null){ count = 0L; }
        transferToMerchantRecord_add.setYufukuan_price_fen(count/User.pianyiFen);

        serializContext.save(transferToMerchantRecord_add);
    }
%>