<%
	/**
		销售统计页面
	**/
%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%@page import="com.lymava.base.util.ContextUtil"%>
<%@page import="com.lymava.base.util.FinalVariable"%>
<%@page import="com.lymava.commons.exception.CheckException"%>
<%@page import="com.lymava.base.model.User"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%><%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
	User user = (User) request.getAttribute(FinalVariable.SESSION_FRONT_FULL_USER);
	CheckException.checkIsTure(user != null, "请先登录！");
	
	String startTime_str = request.getParameter("startTime");
	String endTime_str = request.getParameter("endTime");
	
	Date startTime_date = null;
	Date endTime_date = null;
	
	SimpleDateFormat sdf =  (SimpleDateFormat)ContextUtil.getApplicationContext().getBean("sdf");
	
	try{  startTime_date = sdf.parse(startTime_str); }catch(Exception e){ }
	try{  endTime_date = sdf.parse(endTime_str); }catch(Exception e){ }
	
	if(startTime_date != null && endTime_date != null){
		
		long startTime = startTime_date.getTime();
		long endTime = endTime_date.getTime();
		
		CheckException.checkIsTure(endTime > startTime, "统计终止时间必须大于起始时间!");
		
		//结算岂止跨度不能超过30天 超过30天的按照30天结算
		long max_day = 31;
		long max_time_m = max_day*24*60*60*1000;
		
		CheckException.checkIsTure(endTime-startTime < max_time_m, "统计跨度不能超过31天!");
	}


%> 
                <!-- BEGIN CONTENT BODY -->
                <div class="page-content">
                    <!-- BEGIN PAGE BASE CONTENT -->
                    <div class="row">
                        <div class="col-md-12">
                            <div class="portlet light bordered" id="form_wizard_1">
                                <div class="portlet-title">
                                    <div class="caption">
                                        <i class="fa fa-bar-chart font-green"></i>
                                        <span class="caption-subject font-green bold uppercase"> 销售统计
                                        </span>
                                    </div>
                                </div>
                                <div class="portlet-body">
                                    <form name="search_form" class="form-inline" style="margin-bottom:10px;" role="form" action="${requestURL }">
                                        <div class="form-group">
                                            <label class="sr-only" for="starttime">开始时间</label>
                                            <div class="input-icon">
                                                <i class="fa fa-hourglass-start"></i>
                                                <input type="text" class="form-control date_m"  placeholder="开始时间" value="${dayReport.showStartTime }" name="startTime"  readonly="readonly" datefmt="yyyy-MM-dd HH:mm:ss"> </div>
                                        </div>
                                        <div class="form-group">
                                            <label class="sr-only" for="endtime">结束时间</label>
                                            <div class="input-icon">
                                                <i class="fa fa-hourglass-end"></i>
                                                <input type="text" class="form-control date_m" placeholder="结束时间" value="${dayReport.showEndTime }" name="endTime" readonly="readonly" datefmt="yyyy-MM-dd HH:mm:ss"> </div>
                                        </div>
                                        <button type="button"   class="btn btn-default button-submit"><i class="fa fa-bar-chart"></i> 统计</button>
                                    </form>
                                    <div class="alert alert-warning">
                                        <strong>笔数总计：</strong> ${dayReport.count } 笔 
                                        <strong>销售总计：</strong> ${dayReport.amount_all/1000000 } 元 
                                        <strong>成本总计：</strong> ${dayReport.cost_all/1000000*-1 } 元 
                                        <strong>利润总计：</strong> ${dayReport.profit_all/1000000 } 元
                                    </div>
                                    <table class="table table-striped table-hover table-bordered" data-search="true">
                                            <thead>
                                                <tr>
                                                    <th align="center">业务名称</th>
                                                    <th text-align="center">交易笔数</th>
                                                    <th text-align="center">销售总额</th>
                                                    <th text-align="center">进货总额</th>
                                                    <th text-align="center">利润总额</th>
                                                </tr>
                                            </thead>
                                            <c:forEach var="dayReportDetail" items="${dayReport.dayReportDetail_list }">
												<tr>
													<td>${dayReportDetail.business.name }</td>
													<td>${dayReportDetail.count }</td>
													<td>${dayReportDetail.amount_all/1000000 }</td>
													<td>${dayReportDetail.cost_all/1000000*-1 }</td>
													<td>${dayReportDetail.profit_all/1000000 }</td>
												</tr>
											</c:forEach>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>  