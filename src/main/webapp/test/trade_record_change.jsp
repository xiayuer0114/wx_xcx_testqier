<%@page import="com.lymava.trade.base.model.BusinessIntIdConfig"%>
<%@page import="com.lymava.qier.model.TradeRecord72"%>
<%@page import="com.lymava.nosql.context.SerializContext"%>
<%@page import="com.lymava.trade.business.model.TradeRecordOld"%>
<%@page import="com.lymava.wechat.gongzhonghao.GongzonghaoContent"%>
<%@page import="com.lymava.wechat.gongzhonghao.Gongzonghao"%>
<%@page import="com.lymava.base.util.ContextUtil"%>
<%@page import="com.mongodb.DBObject"%>
<%@page import="com.mongodb.BasicDBObject"%>
<%@page import="com.lymava.nosql.mongodb.util.MongoCommand"%>
<%@page import="com.lymava.qier.model.Voucher"%>
<%@page import="com.lymava.commons.state.State"%>
<%@page import="com.lymava.nosql.util.PageSplit"%>
<%@page import="com.lymava.commons.util.HexM"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Iterator"%>
<%@page import="com.lymava.qier.model.UserVoucher"%>
<%@page import="com.lymava.commons.pay.PayFinalVariable"%>
<%@page import="com.lymava.commons.util.MathUtil"%>
<%@page import="com.lymava.trade.business.model.Product"%>
<%@ page import="com.lymava.qier.model.Merchant72" %>
<%@ page import="com.lymava.qier.model.Product72" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%  
	TradeRecordOld tradeRecordOld = new TradeRecordOld();

	SerializContext serializContext = ContextUtil.getSerializContext();
	
	
	Iterator<TradeRecordOld> tradeRecordOld_ite =  serializContext.findIterable(tradeRecordOld);
	
	while(tradeRecordOld_ite.hasNext()){
		
		TradeRecordOld tradeRecordOld_next = tradeRecordOld_ite.next();
		
		TradeRecord72 tradeRecord_tmp = new TradeRecord72();
		
		tradeRecord_tmp.setId(tradeRecordOld_next.getId());
		tradeRecord_tmp.setProduct(tradeRecordOld_next.getProduct());
		
		tradeRecord_tmp.setQuantity(tradeRecordOld_next.getQuantity());
		tradeRecord_tmp.setUser_huiyuan(tradeRecordOld_next.getUser_huiyuan());
		tradeRecord_tmp.setUserId_merchant(tradeRecordOld_next.getUserId_merchant());
		tradeRecord_tmp.setPrice_fen(tradeRecordOld_next.getPrice_fen());
		tradeRecord_tmp.setPrice_fen_all(-tradeRecordOld_next.getPrice_fen_all());
		tradeRecord_tmp.setState(tradeRecordOld_next.getState());
		tradeRecord_tmp.setMemo(tradeRecordOld_next.getMemo());
		
		tradeRecord_tmp.setRequestFlow(tradeRecordOld_next.getPayFlow());
		tradeRecord_tmp.setMemo(tradeRecordOld_next.getMemo());
		tradeRecord_tmp.setBusinessIntId(BusinessIntIdConfig.businessIntId_trade);
		tradeRecord_tmp.setPay_method(tradeRecordOld_next.getPay_method());
		//tradeRecord_tmp.setPayFlow(tradeRecordOld_next.getPayFlow());
		tradeRecord_tmp.setInWallet_amount_payment_fen(tradeRecordOld_next.getAmount_payment());
		tradeRecord_tmp.setWallet_amount_balance_fen(tradeRecordOld_next.getBalance());
		tradeRecord_tmp.setPayTime(tradeRecordOld_next.getPayTime()); 
		
		serializContext.save(tradeRecord_tmp);
	}
	
	
	 
%>