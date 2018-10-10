<%@page import="com.lymava.base.util.ContextUtil"%>
<%@page import="java.util.Iterator"%>
<%@page import="com.lymava.nosql.util.PageSplit"%>
<%@page import="com.lymava.trade.base.model.BusinessIntIdConfig"%>
<%@page import="com.lymava.userfront.util.FrontUtil"%>
<%@page import="com.lymava.base.model.User"%>
<%@page import="com.lymava.trade.pay.model.PaymentRecord"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%

	User check_login_user = FrontUtil.init_http_user(request);
	if(check_login_user != null){
		
		String page_red = request.getParameter("page");
		String pageSize_red = request.getParameter("pageSize");
		
		PageSplit pageSplit = new PageSplit(page_red,pageSize_red);
		
		PaymentRecord paymentRecord_find = new PaymentRecord();
		
		if(check_login_user != null){
			paymentRecord_find.setUserId_huiyuan(check_login_user.getId());
			paymentRecord_find.setBusinessIntId(BusinessIntIdConfig.businessIntId_pay);
		
		    Iterator<PaymentRecord> paymentRecord_ite =  ContextUtil.getSerializContext().findIterable(paymentRecord_find, pageSplit);
		    request.setAttribute("paymentRecord_ite", paymentRecord_ite);
		}
	}
%>
<c:forEach var="paymentRecord" items="${paymentRecord_ite }">
    <div class="title-box">
        <img src="images/hongbao1.png" />
        <div class="title-box1 fl">
            <div style="font-size: 1.2em;">
                <c:if test="${paymentRecord.price_pianyi_all > 0 }">获得红包</c:if>
                <c:if test="${paymentRecord.price_pianyi_all < 0 }">钱包支付</c:if>
            </div>
            <div style="font-size: 1em;"> 
                    ${paymentRecord.showTime }
            </div>
        </div> 
        <div class="title-box2">
            <c:if test="${paymentRecord.price_all_yuan > 0 }">+</c:if>${paymentRecord.price_all_yuan }元
        </div>
    </div>
</c:forEach>
