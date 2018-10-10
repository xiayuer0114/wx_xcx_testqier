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
	 
		
	Merchant72 merchant72 = new Merchant72();
	merchant72.setUserGroupId(CashierAction.getMerchantUserGroutId()); 
	//添加查询条件
	MongoCommand.nearSphere(merchant72, longitude, latitude);
	//默认就是采用距离排序	把id 排序这些去掉
	merchant72.setIs_sort(false);
	
	PageSplit pageSplit = new PageSplit();
		
	List<Merchant72> merchant72_ite  = serializContext.findAll(merchant72,pageSplit);
	
	for(Merchant72 merchant72_next:merchant72_ite){
		
		Double distance = merchant72_next.getDistance(latitude, longitude);
		
		System.out.println(merchant72_next.getShowName()+" "+distance);
		out.println(merchant72_next.getShowName()+" "+distance+"<br/>");
	}
	
%>







