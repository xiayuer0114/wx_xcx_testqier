<%@page import="com.lymava.trade.base.model.BusinessIntIdConfig"%>
<%@page import="com.lymava.qier.business.BusinessIntIdConfigQier"%>
<%@page import="com.lymava.base.model.User"%>
<%@page import="com.lymava.nosql.context.SerializContext"%>
<%@page import="com.lymava.qier.model.TradeRecord72"%>
<%@page import="com.lymava.qier.activities.sharebusiness.NazhongrenShareBusiness"%>
<%@page import="com.lymava.qier.activities.sharebusiness.LiuyibaShareBusiness"%>
<%@page import="com.lymava.qier.sharebusiness.GaosanShareBusiness"%>
<%@page import="com.lymava.qier.sharebusiness.QierGongzonghaoShareBusinessDefault"%>
<%@page import="com.lymava.wechat.gongzhonghao.sharebusiness.GongzonghaoShareBusiness"%>
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
	SerializContext serializContext = ContextUtil.getSerializContext();

 	TradeRecord72 tradeRecord72 = new TradeRecord72();
 	tradeRecord72.setRequestFlow("1529297175454");
 	
 	tradeRecord72 = (TradeRecord72)serializContext.get(tradeRecord72);
 	
 	if(tradeRecord72 != null){
 		
 		tradeRecord72.setPay_method(PayFinalVariable.pay_method_alipay);
 		tradeRecord72.setMerchant_balance(User.getPianyi(93230.99));
 		tradeRecord72.setBusinessIntId(BusinessIntIdConfig.businessIntId_trade);
 		tradeRecord72.setState(State.STATE_PAY_SUCCESS);
 		tradeRecord72.setState_printed(State.STATE_OK);
 		
 		serializContext.save(tradeRecord72);
 	}
 	
 	String[] request_array = {"1529306166698",
 			"1529305694263",
 			"1529305690160",
 			"1529305529342",
 			"1529305381979",
 			"1529305115054",
 			"1529304846948",
 			"1529304731316",
 			"1529304489388",
 			"1529304329749",
 			"1529304118114",
 			"1529304049055",
 			"1529303786298",
 			"1529303468620",
 			"1529303458353",
 			"1529303314066",
 			"1529303303171",
 			"1529303092197",
 			"1529302954446",
 			"1529302902479",
 			"1529302645995",
 			"1529302557479",
 			"1529302520743",
 			"1529302486020",
 			"1529302044963",
 			"1529301824774",
 			"1529301452722",
 			"1529301405260",
 			"1529301319498",
 			"1529301280235",
 			"1529301210260",
 			"1529301198543",
 			"1529301152041",
 			"1529300865955",
 			"1529300818201",
 			"1529300809571",
 			"1529300774972",
 			"1529300697280",
 			"1529300597823",
 			"1529300582610",
 			"1529300350164",
 			"1529300318565",
 			"1529300160337",
 			"1529300114988",
 			"1529300107754",
 			"1529300070248",
 			"1529300000305",
 			"1529299884037",
 			"1529299808573",
 			"1529299812892",
 			"1529299532396",
 			"1529299517124",
 			"1529299472180",
 			"1529299458886",
 			"1529299318330",
 			"1529298816184",
 			"1529298726761",
 			"1529298691165",
 			"1529298594856",
 			"1529298569058",
 			"1529298506391",
 			"1529298455957",
 			"1529298455403",
 			"1529298378327",
 			"1529298360112",
 			"1529298324720",
 			"1529298205903",
 			"1529298138230",
 			"1529297974563",
 			"1529297878735",
 			"1529297831765",
 			"1529297785879",
 			"1529297701231",
 			"1529297700664",
 			"1529297574225",
 			"1529297563597",
 			"1529297339397",
 			"1529297266810",
 			"1529297242542",
 			"1529297223097"};
 	
 		for(String request_flow:request_array){
 			if(request_flow == null){
 				continue;
 			}
 			
 		 	tradeRecord72 = new TradeRecord72();
 		 	tradeRecord72.setRequestFlow(request_flow);
 		 	
 		 	tradeRecord72 = (TradeRecord72)serializContext.get(tradeRecord72);
 		 	
 		 	if(tradeRecord72 != null){
 		 		tradeRecord72.setMerchant_balance(tradeRecord72.getMerchant_balance()-69*User.pianyiYuan);
 		 		serializContext.save(tradeRecord72);
 		 	}
 			
 		}
 	
 	
 	
%>