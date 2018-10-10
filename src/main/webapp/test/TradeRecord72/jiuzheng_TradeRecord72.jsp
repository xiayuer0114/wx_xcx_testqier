<%@page import="com.lymava.commons.exception.CheckException"%>
<%@page import="com.lymava.trade.base.model.Business"%>
<%@page import="java.util.Date"%>
<%@page import="com.lymava.trade.base.model.BusinessIntIdConfig"%>
<%@page import="com.lymava.commons.util.DateUtil"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="org.bson.types.ObjectId"%>
<%@page import="com.lymava.qier.util.SunmingUtil"%>
<%@page import="com.lymava.nosql.util.PageSplit"%>
<%@page import="java.util.Iterator"%>
<%@page import="com.lymava.nosql.util.QuerySort"%>
<%@page import="com.lymava.commons.state.State"%>
<%@page import="com.lymava.nosql.mongodb.util.MongoCommand"%>
<%@page import="com.lymava.qier.model.TradeRecord72"%>
<%@page import="java.util.LinkedList"%>
<%@page import="java.util.List"%>
<%@page import="com.lymava.nosql.context.SerializContext"%>
<%@page import="com.lymava.base.util.ContextUtil"%>
<%@page import="com.lymava.trade.util.WebConfigContentTrade"%>
<%@page import="com.lymava.qier.business.BusinessIntIdConfigQier"%>
<%@page import="com.lymava.qier.model.Merchant72"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
</head>
<body>
	<table class="table" width="100%" layoutH="138">
		<thead>
			<tr>
				<th>订单编号</th>
				<th>业务编号</th>
				<th>业务名称</th>
				<th>支付总额</th>
				<th>支付时间</th>
				<th>支付方式</th>
				<th>商户</th>
				<th>商户余额</th>
				<th>上笔余额</th>
				<th>差额额</th>
				<th>状态</th>
				<th>时间</th>
 			</tr>
		</thead>
		<tbody>
	<%
	
		Merchant72 merchant72_find = new Merchant72();
		merchant72_find.setUserGroupId(WebConfigContentTrade.getInstance().getMerchantUserGroupId());
		
		SerializContext serializContext = ContextUtil.getSerializContext();
		
		List<Merchant72> merchant72_list= serializContext.findAll(merchant72_find);
		
		for(Merchant72 merchant72_tmp:merchant72_list){
				request.setAttribute("merchant72_tmp", merchant72_tmp);
			//只处理余额不共享的
			if(!Merchant72.share_balance_no.equals(merchant72_tmp.getShare_balance())){
				continue;
			}
			
			Merchant72 merchant72_find_child = new Merchant72();
			
			merchant72_find_child.setUserGroupId(WebConfigContentTrade.getInstance().getMerchantUserGroupId());
			merchant72_find_child.setTopUserId(merchant72_tmp.getId());
			merchant72_find_child.setShare_balance(Merchant72.share_balance_yes);
			
			List<Merchant72> merchant72_find_child_list= serializContext.findAll(merchant72_find_child);
			if(merchant72_find_child_list == null){
				merchant72_find_child_list = new LinkedList<Merchant72>();
			}
			merchant72_find_child_list.add(merchant72_tmp);
			
			
			TradeRecord72 tradeRecord72_find = new TradeRecord72();
			
			tradeRecord72_find.addCommand(MongoCommand.in, "state", State.STATE_OK);
			tradeRecord72_find.addCommand(MongoCommand.in, "state", State.STATE_PAY_SUCCESS);
			tradeRecord72_find.addCommand(MongoCommand.in, "state", State.STATE_REFUND_OK);
			
			for(Merchant72 merchant72_find_child_tmp:merchant72_find_child_list){
				tradeRecord72_find.addCommand(MongoCommand.in, "userId_merchant", merchant72_find_child_tmp.getId());
			}
			
			
			tradeRecord72_find.initQuerySort("payTime", QuerySort.asc);
			
            ObjectId start_object_id = new ObjectId(DateUtil.getSdfFull().parse("2018-09-01 16:22:04"));
            tradeRecord72_find.addCommand(MongoCommand.dayuAndDengyu, "id", start_object_id);
			
			PageSplit pageSplit = new PageSplit();
			pageSplit.setPageSize(5000);
			
			Iterator<TradeRecord72> tradeRecord72_ite = serializContext.findIterable(tradeRecord72_find,pageSplit);
			
			if(pageSplit.getCount() == 0){
				continue;
			}
			
			Long last_balance = null;
			Long you_wenti_count = 0l;
			
			
			while(tradeRecord72_ite.hasNext()){
				
				TradeRecord72 tradeRecord72_tmp = tradeRecord72_ite.next();
				
				Merchant72 user_merchant = tradeRecord72_tmp.getUser_merchant();
				
				//无余额的
				if(tradeRecord72_tmp.getMerchant_balance() == null){
					continue;
				}
				
				if(last_balance == null){
					last_balance = tradeRecord72_tmp.getMerchant_balance();
				}
				
				//当前应该的余额	这里正数是加 负数是减
				Long current_balance = last_balance + tradeRecord72_tmp.getPrice_pianyi_all();
				Long chae = current_balance-tradeRecord72_tmp.getMerchant_balance();
				
				request.setAttribute("last_balance", last_balance);
				request.setAttribute("chae", chae);
				
				if(tradeRecord72_tmp.getPrice_pianyi_all() == -chae  && chae > 0){
					you_wenti_count ++;
					 
					
					
					request.setAttribute("object", tradeRecord72_tmp);
					request.setAttribute("user_merchant", user_merchant);
					%>
					<tr target="id" rel="${object.id }" id="${object.id }">
						<td><c:out value="${object.requestFlow }" escapeXml="true"/></td>
						<td><c:out value="${object.businessIntId }" escapeXml="true"/></td>
						<td><c:out value="${object.business.businessName }" escapeXml="true"/></td>
						<td><c:out value="${object.price_fen_all/-100 }" escapeXml="true"/></td>
						<td><c:out value="${object.showPayTime }" escapeXml="true"/></td>
						<td><c:out value="${object.showPay_method }" escapeXml="true"/></td>
						<td><c:out value="${object.user_merchant.nickname  }" escapeXml="true"/></td>
						<td><c:out value="${object.showMerchant_balance }" escapeXml="true"/></td>
						<td><c:out value="${last_balance/1000000 }" escapeXml="true"/></td>
						<td><c:out value="${chae/1000000 }" escapeXml="true"/></td>
	 					<td><c:out value="${object.showState }" escapeXml="true"/></td>
						<td><c:out value="${object.showTime }" escapeXml="true"/></td>
	 				</tr> 
				<%
							Integer businessIntId = BusinessIntIdConfigQier.businessIntId_refund_pay_twice;
				 
							String old_object_id_str = tradeRecord72_tmp.getId();
				
							ObjectId old_object_id = new ObjectId(new Date(tradeRecord72_tmp.get_id_time_tmp()+1));
				
							tradeRecord72_tmp.setId(old_object_id.toString());
							tradeRecord72_tmp.setBusinessIntId(businessIntId);
							tradeRecord72_tmp.setPayTime(System.currentTimeMillis());
							tradeRecord72_tmp.setState(State.STATE_PAY_SUCCESS);
							if(tradeRecord72_tmp.getPrice_pianyi_all() != null){
								tradeRecord72_tmp.setPrice_pianyi_all(tradeRecord72_tmp.getPrice_pianyi_all()*-1);
							}
							if(tradeRecord72_tmp.getWallet_amount_payment_pianyi() != null){
								tradeRecord72_tmp.setWallet_amount_payment_pianyi(tradeRecord72_tmp.getWallet_amount_payment_pianyi()*-1);
							}
							tradeRecord72_tmp.setWallet_amount_balance_pianyi(null);
							tradeRecord72_tmp.setMerchantRedEnvelope_id(null);
							tradeRecord72_tmp.setRequestFlow(old_object_id_str+"_"+businessIntId);
							tradeRecord72_tmp.setPayFlow(null);
							tradeRecord72_tmp.setPay_method(null);

							serializContext.save(tradeRecord72_tmp);
							
							try{
								Business.checkRequestFlow(tradeRecord72_tmp);
								user_merchant.shareMerchant_balance_Change(tradeRecord72_tmp.getPrice_pianyi_all());
								tradeRecord72_tmp.setMerchant_balance(user_merchant.getCurrentMerchant_balance());
								
								tradeRecord72_tmp.trade_record_tongji();
							}catch(CheckException e){
							}
						}
						last_balance = tradeRecord72_tmp.getMerchant_balance();
					}
				}
				%>
		</tbody>
	</table>
</body>
</html>