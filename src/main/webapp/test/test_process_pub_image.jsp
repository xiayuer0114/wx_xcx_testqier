<%@page import="com.lymava.commons.util.MyUtil"%>
<%@page import="com.lymava.qier.util.WeiHtmlProcess"%>
<%@page import="org.bson.types.ObjectId"%>
<%@page import="com.lymava.commons.util.IOUtil"%>
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
	pageEncoding="UTF-8"%>
<%

	Pub pub_tmp = Pub.getFinalPub("5b0fafadd6c4591dd6821936");

	String basePath = MyUtil.getBasePath(request);

	String readData = pub_tmp.getContent();

	String realPath = application.getRealPath("/");

	String process_weixin_html = WeiHtmlProcess.process_weixin_html(readData,basePath,realPath, pub_tmp.getId());
	
	Pub pub_update = new Pub();
	pub_update.setContent(process_weixin_html);
	
	ContextUtil.getSerializContext().updateObject(pub_tmp.getId(), pub_update);
 
	System.out.println(process_weixin_html);
%>
