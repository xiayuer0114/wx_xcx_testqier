<%@page import="com.lymava.qier.business.BusinessIntIdConfigQier"%>
<%@page import="java.util.Iterator"%>
<%@page import="com.lymava.nosql.context.SerializContext"%>
<%@page import="com.lymava.nosql.mongodb.util.MongoCommand"%>
<%@page import="com.lymava.qier.model.TradeRecord72"%>
<%@page import="com.lymava.qier.util.PrintUtil"%>
<%@page import="com.lymava.base.util.ContextUtil"%>
<%@page import="com.lymava.trade.business.model.TradeRecord"%>
<%@page import="java.util.List"%>
<%@page import="com.lymava.nosql.util.PageSplit"%>
<%@page import="com.lymava.base.model.PubConlumn"%>
<%@page import="com.lymava.base.model.Pub"%>
<%@page import="java.util.Enumeration"%>
<%@page import="com.lymava.wechat.opendevelop.DevelopAccount"%>
<%@page import="com.lymava.wechat.gongzhonghao.GongzonghaoContent"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%><%
   
    TradeRecord72 tradeRecord = new TradeRecord72();
    
    tradeRecord.addCommand(MongoCommand.empty, "businessIntId", null);
    
    SerializContext serializContext = ContextUtil.getSerializContext();
    
    List<TradeRecord72> tradeRecord_list =  serializContext.findAll(tradeRecord);
    
    for(TradeRecord72 tradeRecord72_tmp:tradeRecord_list){
    	
    	TradeRecord72 tradeRecord72_update = new TradeRecord72();
    	
    	tradeRecord72_update.setBusinessIntId(BusinessIntIdConfigQier.businessIntId_give_back);
    	
    	serializContext.updateObject(tradeRecord72_tmp.getId(),tradeRecord72_update);
    }
    
    
    request.setAttribute("object_ite", tradeRecord_list);
%> 
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<table class="table" width="100%" layoutH="138">
		<thead>
			<tr>
														<th width="30"><input type="checkbox" class="checkboxCtrl" group="${currentTimeMillis }checkbox" /></th>
														<th>订单编号</th>
														<th>用户</th>
														<th>业务编号</th>
														<th>业务名称</th>
														<th>订单金额</th>
														<th>支付总额</th>
														<th>支付时间</th>
														<th>支付方式</th>
														<th>钱包支付</th>
														<th>账户余额</th>
														<th>商户</th>
														<th>商户余额</th>
														<th>状态</th>
														<th>提交IP</th>
														<th>时间</th>
 			</tr>
		</thead>
		<tbody>
			<c:forEach var="object" varStatus="i" items="${object_ite }">
				<tr target="id" rel="${object.id }" id="${object.id }">
					<td><input type="checkbox" name="${currentTimeMillis }checkbox" value="${object.id }" /></td>
					<td><c:out value="${object.requestFlow }" escapeXml="true"/></td>
					<td><c:out value="${object.user_huiyuan.showName }" escapeXml="true"/></td>
					<td><c:out value="${object.businessIntId }" escapeXml="true"/></td>
					<td><c:out value="${object.business.businessName }" escapeXml="true"/></td>
					<td><c:out value="${object.price_fen_all/-100 }" escapeXml="true"/></td>
					<td><c:out value="${object.countPayPrice_fen_all/100 }" escapeXml="true"/></td>
					<td><c:out value="${object.showPayTime }" escapeXml="true"/></td>
					<td><c:out value="${object.showPay_method }" escapeXml="true"/></td>
					<td><c:out value="${object.wallet_amount_payment_fen/100 }" escapeXml="true"/></td>
					<td><c:out value="${object.wallet_amount_balance_fen/100 }" escapeXml="true"/></td>
					<td><c:out value="${object.user_merchant.nickname  }" escapeXml="true"/></td>
					<td><c:out value="${object.showMerchant_balance }" escapeXml="true"/></td>
 					<td><c:out value="${object.showState }" escapeXml="true"/></td>
 					<td><c:out value="${object.ip }" escapeXml="true"/></td>
					<td><c:out value="${object.showTime }" escapeXml="true"/></td>
 				</tr> 
			</c:forEach>
		</tbody>
	</table>