<%@page import="com.lymava.base.model.SimpleDbCacheContent"%>
<%@page import="java.sql.Date"%>
<%@page import="com.lymava.commons.util.DateUtil"%>
<%@page import="com.lymava.qier.model.Merchant72"%>
<%@page import="com.lymava.base.vo.State"%>
<%@page import="java.util.Iterator"%>
<%@page import="com.lymava.base.util.ContextUtil"%>
<%@page import="com.lymava.nosql.util.PageSplit"%>
<%@page import="com.lymava.commons.exception.CheckException"%>
<%@page import="com.lymava.base.util.FinalVariable"%>
<%@page import="com.lymava.base.model.User"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@page import="java.util.List"%>
<%@ page import="java.util.Calendar" %>
<%@ page import="com.lymava.qier.model.Cashier" %>
<%@ page import="com.lymava.qier.model.Product72" %>
<%@ page import="com.lymava.base.model.Pub" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%!
	public  String get_merchant_today_cash_total_key(String userId_merchant,String currentDayStr){
		return userId_merchant+"_"+currentDayStr+"_"+"merchant_today_cash_total_key";
	}
	public String get_merchant_today_cash_total_key_weixin(String userId_merchant,String currentDayStr){
		return userId_merchant+"_"+currentDayStr+"_"+"merchant_today_cash_total_key_weixin";
	}
	public String get_merchant_today_cash_total_key_alipay(String userId_merchant,String currentDayStr){
		return userId_merchant+"_"+currentDayStr+"_"+"merchant_today_cash_total_key_alipay";
	}
	public String get_merchant_today_cash_total_key_qianbao(String userId_merchant,String currentDayStr){
		return userId_merchant+"_"+currentDayStr+"_"+"merchant_today_cash_total_key_qianbao";
	}
	public String get_merchant_today_refund_total_key(String userId_merchant,String currentDayStr){
		return userId_merchant+"_"+currentDayStr+"_"+"merchant_today_refund_total_key";
	}
	
	public  Long get_merchant_today_cash_total_fen(String userId_merchant,String currentDayStr){
		
		String merchant_today_cash_total_key = get_merchant_today_cash_total_key(userId_merchant, currentDayStr);
		
		Long today_total_fen  = (Long) SimpleDbCacheContent.get_object(merchant_today_cash_total_key);
		
		return today_total_fen;
	}
	public Long get_merchant_today_cash_total_weixin_fen(String userId_merchant,String currentDayStr){
		
		String get_merchant_today_cash_total_key_weixin = get_merchant_today_cash_total_key_weixin(userId_merchant, currentDayStr);
		
		Long total_fen  = (Long) SimpleDbCacheContent.get_object(get_merchant_today_cash_total_key_weixin);
		
		return total_fen;
	}
	public Long get_merchant_today_cash_total_alipay_fen(String userId_merchant,String currentDayStr){
		
		String get_merchant_today_cash_total_key_alipay = get_merchant_today_cash_total_key_alipay(userId_merchant, currentDayStr);
		
		Long total_fen  = (Long) SimpleDbCacheContent.get_object(get_merchant_today_cash_total_key_alipay);
		
		return total_fen;
	}
	public Long get_merchant_today_cash_total_qianbao_fen(String userId_merchant,String currentDayStr){
		
		String get_merchant_today_cash_total_key_qianbao = get_merchant_today_cash_total_key_qianbao(userId_merchant, currentDayStr);
		
		Long total_fen  = (Long) SimpleDbCacheContent.get_object(get_merchant_today_cash_total_key_qianbao);
		
		return total_fen;
	}
	public Long get_merchant_today_refund_total_fen(String userId_merchant,String currentDayStr){
		
		String get_merchant_today_refund_total_key = get_merchant_today_refund_total_key(userId_merchant, currentDayStr);
		
		Long total_fen  = (Long) SimpleDbCacheContent.get_object(get_merchant_today_refund_total_key);
		
		return total_fen;
	}
%>
<%
	Merchant72 merchant72 = (Merchant72)request.getAttribute("merchant72");
    CheckException.checkIsTure(merchant72 != null, "请先登录！");
    
    Long current_time_start = System.currentTimeMillis();
%>
<!-- BEGIN CONTENT BODY -->

<head>
    <meta charset="utf-8">
    <title>layui</title>
    <meta name="renderer" content="webkit">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
    <link rel="stylesheet" href="${basePath}layui-v2.2.5/layui/css/layui.css"  media="all">
    <!-- 注意：如果你直接复制所有代码到本地，上述css路径需要改成你本地的 -->
</head>

<div class="page-content" id="containerCashier">

    <!-- BEGIN PAGE BASE CONTENT -->
    <div class="row">
        <div class="col-md-12">
            <div class="portlet light bordered" id="form_wizard_1">
                <div class="portlet-title">
                    <div class="caption">
                        <i class="fa fa-list font-green"></i>
                        <span class="caption-subject font-green bold uppercase"> 日统计列表</span>
                    </div>
                </div>
                <form  name="search_form"  class="form-inline" style="margin-bottom:10px;" role="form" action="${requestURL }">
                    <a href="javascript:void(0)" onclick="refresh()" type="button" class="btn btn-primary"  >刷新</a>
                </form>
                <div style="padding: 20px; background-color: #F2F2F2;">
                    <div class="layui-row layui-col-space15">
                    	<%
                    		for(int i=0;i<10;i++){
                    			
                    			current_time_start 	=	current_time_start-DateUtil.one_day*i;
                    			
                    			String currentDayStr = merchant72.getCurrentDayStr(current_time_start);
                    			 
                    			Long merchant_today_cash_total_fen  = get_merchant_today_cash_total_fen(merchant72.getId(),currentDayStr);
                    			
                    			Long merchant_today_cash_total_weixin_fen  = get_merchant_today_cash_total_weixin_fen(merchant72.getId(),currentDayStr);
                    			
                    			Long merchant_today_cash_total_alipay_fen  = get_merchant_today_cash_total_alipay_fen(merchant72.getId(),currentDayStr);
                    				 
                    			Long merchant_today_cash_total_qianbao_fen  = get_merchant_today_cash_total_qianbao_fen(merchant72.getId(),currentDayStr);
                    			
                    			Long merchant_today_refund_total_fen  =  get_merchant_today_refund_total_fen(merchant72.getId(),currentDayStr);
                    				 
                    			request.setAttribute("merchant_today_cash_total_fen", merchant_today_cash_total_fen);
                    			request.setAttribute("merchant_today_cash_total_weixin_fen", merchant_today_cash_total_weixin_fen);
                    			request.setAttribute("merchant_today_cash_total_alipay_fen", merchant_today_cash_total_alipay_fen);
                    			request.setAttribute("merchant_today_cash_total_qianbao_fen", merchant_today_cash_total_qianbao_fen);
                    			request.setAttribute("merchant_today_refund_total_fen", merchant_today_refund_total_fen);
                    			
                    			request.setAttribute("currentDayStr", currentDayStr);
                    	%>
                            <div class="layui-col-md3" style="width: 18rem;">
                                <div class="layui-card">
                                    <div class="layui-card-header">
                                        <c:out value="${currentDayStr }" escapeXml="true"/>
                                    </div>
                                    <div class="layui-card-body">
                                        <input type="hidden" value="${product72List.id }">
                                        <table style="width: 100%;">
                                            <tr>
                                                <td>总收益: &nbsp;&nbsp;&nbsp;</td>
                                                <td style="color: red">${merchant_today_cash_total_fen/100 }</td>
                                            </tr>
                                            <tr>
                                                <td>设置时间: &nbsp;&nbsp;&nbsp;</td>
                                                <td><c:out value="${product72List.show_update_amount_time }" escapeXml="true"/></td>
                                            </tr>
                                            <tr>
                                                <td>预置金额: &nbsp;&nbsp;&nbsp; </td>
                                                <td><c:out value="${product72List.preset_amount_fen/100}" escapeXml="true"/></td>
                                            </tr>
                                            <tr>
                                                <td>餐位费: &nbsp;&nbsp;&nbsp; </td>
                                                <td><c:out value="${product72List.canWeiFei_fen/100}" escapeXml="true"/></td>
                                            </tr>
                                            <tr>
                                                <td>用餐人数: &nbsp;&nbsp;&nbsp; </td>
                                                <td><c:out value="${product72List.renshu}" escapeXml="true"/></td>
                                            </tr>
                                            <tr>
                                                <td>小计: &nbsp;&nbsp;&nbsp; </td>
                                                <td><c:out value="${product72List.xiaoJi}" escapeXml="true"/></td>
                                            </tr> 
                                        </table>
                                    </div>
                                </div>
                            </div>
						<% } %>
                    </div>
                </div>



                </div>
            </div>
        </div>
</div> 

