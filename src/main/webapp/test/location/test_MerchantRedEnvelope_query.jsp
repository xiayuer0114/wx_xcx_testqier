<%@page import="com.lymava.qier.util.DiLiUtil"%>
<%@page import="com.lymava.qier.model.MerchantRedEnvelope"%>
<%@page import="com.google.gson.JsonObject"%>
<%@page import="com.lymava.nosql.util.QuerySort"%>
<%@page import="java.util.LinkedList"%>
<%@page import="com.mongodb.client.model.geojson.Point"%>
<%@page import="com.mongodb.client.model.geojson.Position"%>
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
	SerializContext serializContext = ContextUtil.getSerializContext();

	// 经度
	Double longitude = 106.593888d;
	// 纬度
	Double latitude = 29.571829d;
	 
		
	MerchantRedEnvelope merchantRedEnvelope = new MerchantRedEnvelope();
	//添加查询条件
	MongoCommand.nearSphere(merchantRedEnvelope, longitude, latitude);
	//默认就是采用距离排序	把id 排序这些去掉
	merchantRedEnvelope.setIs_sort(false);
	
	PageSplit pageSplit = new PageSplit();
		
	List<MerchantRedEnvelope> merchantRedEnvelope_ite  = serializContext.findAll(merchantRedEnvelope,pageSplit);
	
	for(MerchantRedEnvelope merchantRedEnvelope_next:merchantRedEnvelope_ite){
		
		// 经度
		Double longitude_red = merchantRedEnvelope_next.getLongitude();
		// 纬度
		Double latitude_red = merchantRedEnvelope_next.getLatitude();
		
		Double distance = DiLiUtil.getDistance(latitude_red, longitude_red,latitude, longitude);
		
		System.out.println(merchantRedEnvelope_next.getRed_envolope_name()+" "+distance);
		out.println(merchantRedEnvelope_next.getRed_envolope_name()+" "+distance+"<br/>");
	}
	
%>







