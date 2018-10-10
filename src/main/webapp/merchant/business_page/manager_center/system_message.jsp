<%@page import="java.util.Iterator"%>
<%@page import="com.lymava.base.util.ContextUtil"%>
<%@page import="com.lymava.nosql.util.PageSplit"%>
<%@page import="com.lymava.commons.exception.CheckException"%>
<%@page import="com.lymava.base.util.FinalVariable"%>
<%@page import="com.lymava.base.model.User"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%
User user = (User) request.getAttribute(FinalVariable.SESSION_FRONT_FULL_USER);
CheckException.checkIsTure(user != null, "请先登录！");
//用户自己的
//remittanceRequest_find.setUser(user);

String page_temp = request.getParameter("page");
String pageSize_temp = request.getParameter("pageSize");

PageSplit pageSplit = new PageSplit(page_temp,pageSize_temp);
pageSplit.setPageSize(6);
%>
                <!-- BEGIN CONTENT BODY -->
                <div class="page-content">
                    <!-- BEGIN PAGE BASE CONTENT -->
                    <div class="row">
                        <div class="col-md-12">
                            <div class="portlet light bordered" id="form_wizard_1">
                                <div class="portlet-title">
                                    <div class="caption">
                                        <i class="fa fa-commenting font-green"></i>
                                        <span class="caption-subject font-green bold uppercase"> 通告信息
                                        </span>
                                    </div>
                                </div>
                                <div class="portlet-body">
                                    <table class="table table-striped table-hover table-bordered" data-search="true">
                                            <thead>
                                                <tr>
                                                    <th align="center">发布人</th>
                                                    <th text-align="center">标题</th>
                                                    <th text-align="center">简介</th>
                                                    <th text-align="center">类型</th>
                                                    <th text-align="center">系统时间</th>
                                                    <th text-align="center">操作</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                            <c:forEach var="object" items="${object_ite }">
                                                <tr>
							                        <td ><c:out value="${object.userV2.realName }" /></td>
								                    <td ><c:out value="${object.title }" /></td>
													<td ><c:out value="${object.intro }" /></td>
													<td ><c:out value="${object.showType }" /></td>
													<td ><c:out value="${object.showTime }" /></td>
                                                    <td>
                                                        <button class="btn btn-link btn-xs"><i class="fa fa-hand-pointer-o"></i> 查看详情</button>
                                                    </td>
                                                </tr>
                                                </c:forEach>
                                            </tbody>
                                    </table>
                                    <ul class="pager" > 
										<li  page="1"><a href="javascript:void(0)" >首页</a></li>
										<li  page="${pageSplit.prePage }"><a href="javascript:void(0)"  >上一页</a></li>
										<c:forEach var="current_page" begin="${pageSplit.fenyeFirstPage }" end="${pageSplit.fenyeLastPage }" >
										<li  page="${current_page}"><a href="javascript:void(0)"     >${current_page}</a></li>
										</c:forEach>
										<li  page="${pageSplit.nextPage }"><a href="javascript:void(0)"    >下一页</a></li>
								  	</ul>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>