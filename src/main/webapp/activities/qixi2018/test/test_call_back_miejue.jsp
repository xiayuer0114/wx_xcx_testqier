<%@page import="com.lymava.qier.activities.qixi.Qixi2018ShareBusiness"%>
<%@page import="com.lymava.qier.activities.qingliang.QingliangShareBusiness"%>
<%@page import="com.lymava.qier.activities.sharebusiness.KOL200ShareBusiness"%>
<%@page import="com.lymava.commons.util.MyUtil"%>
<%@page import="com.lymava.wechat.opendevelop.WeixinCallBackMessageFilter"%>
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

	WeixinCallBackMessageFilter.threadLocal_realPath.set(application.getRealPath("/"));
	WeixinCallBackMessageFilter.threadLocal_basePath.set(MyUtil.getBasePath(request));
	
	Gongzonghao defaultGongzonghao = GongzonghaoContent.getMorenGongzonghao();
	
	Qixi2018ShareBusiness nazhongrenShareBusiness = new Qixi2018ShareBusiness();
	
	String openid	= "oYb451J_r9u9tBbyq86c40RWxa48";
	
	nazhongrenShareBusiness.subscribe_call_back(defaultGongzonghao, "miejue", openid);
	 
%>