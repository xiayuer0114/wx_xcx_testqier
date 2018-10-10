<%@page import="com.lymava.qier.activities.sharebusiness.WorldCupForecastShareBusiness"%>
<%@page import="com.lymava.wechat.gongzhonghao.Gongzonghao"%>
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
    
    GongzonghaoContent gongzonghaoContent = GongzonghaoContent.getInstance();
    
    Gongzonghao gongzonghao = gongzonghaoContent.getDefaultGongzonghao();
    
    WorldCupForecastShareBusiness worldCupForecastShareBusiness = new WorldCupForecastShareBusiness();
    
    String create_qrcode = gongzonghao.create_qrcode(worldCupForecastShareBusiness);
    
    out.print(create_qrcode);
    
    
%>  