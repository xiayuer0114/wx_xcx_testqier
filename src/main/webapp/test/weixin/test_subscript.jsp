<%@page import="com.lymava.commons.util.MyUtil"%>
<%@page import="com.lymava.wechat.opendevelop.WeixinCallBackMessageFilter"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Map"%>
<%@page import="com.lymava.wechat.gongzhonghao.Gongzonghao"%>
<%@page import="com.lymava.wechat.gongzhonghao.GongzonghaoContent"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%><%
    
    String xmlContent = "<xml><ToUserName><![CDATA[gh_4e34af65f089]]></ToUserName>
					    		<FromUserName><![CDATA[oYb451J_r9u9tBbyq86c40RWxa48]]></FromUserName>
					    		<CreateTime>1537872947</CreateTime>
					    		<MsgType><![CDATA[text]]></MsgType>
					    		<Content><![CDATA[测试]]></Content>
					    		<MsgId>6605114013200595602</MsgId>
				    		</xml>";
				    	
	WeixinCallBackMessageFilter.threadLocal_realPath.set(application.getRealPath("/"));
	WeixinCallBackMessageFilter.threadLocal_basePath.set(MyUtil.getBasePath(request));

    
   Gongzonghao gongzonghao = GongzonghaoContent.getInstance().getDefaultGongzonghao();
   gongzonghao.executeCallBackMessage(xmlContent, new HashMap());
    
%>