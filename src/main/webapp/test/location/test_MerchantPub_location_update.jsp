<%@page import="com.lymava.qier.model.MerchantPub"%>
<%@page import="com.lymava.qier.model.MerchantRedEnvelope"%>
<%@page import="com.lymava.qier.action.CashierAction"%>
<%@page import="com.mongodb.BasicDBList"%>
<%@page import="com.lymava.nosql.context.SerializContext"%>
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
	MerchantPub merchantPub = new MerchantPub();
	
	SerializContext serializContext = ContextUtil.getSerializContext();
	
	Iterator<MerchantPub> merchantPub_ite = serializContext.findIterable(merchantPub);
	
	while(merchantPub_ite.hasNext()){
		
		MerchantPub merchantPub_next = merchantPub_ite.next();
		 
		Merchant72 merchant72_next = merchantPub_next.getMerchant72();
		if(merchant72_next == null){
			continue;
		}
		
		// 经度
		Double longitude = merchant72_next.getLongitude();
		// 纬度
		Double latitude = merchant72_next.getLatitude();
		
		if(longitude != null && latitude != null){
			BasicDBList location = new BasicDBList();
			if(longitude < latitude){
				location.add(latitude);
				location.add(longitude);
			}else{
				location.add(longitude);
				location.add(latitude);
			}
			
			merchantPub_next.setLocation(location);
			
			serializContext.save(merchantPub_next);
		}
		
	}
%>







